#!/usr/bin/env bash
# personalisieren.sh
# Einmal-Skript fuer die Ersteinrichtung des Vault-Skeletts.
# Ersetzt die Platzhalter {{SCHLUESSEL}} in Dateiinhalten und Dateinamen
# durch die Werte aus den Umgebungsvariablen SB_SCHLUESSEL.
#
# Aufruf vom Vault-Root, alle Werte als SB_-Variablen:
#   SB_VAULT_NAME=... SB_NAME=... SB_VOLLER_NAME=... SB_BERUF=... \
#   SB_BETRIEB=... SB_BETRIEB_KURZ=... SB_ORT=... SB_BEGINN=JJJJ-MM-TT \
#   SB_AUSBILDUNGSJAHR=1 SB_HEUTE=JJJJ-MM-TT \
#   SB_NAECHSTER_FREITAG=JJJJ-MM-TT SB_MONATSENDE_FREITAG=JJJJ-MM-TT \
#   bash Claude/scripts/personalisieren.sh [--probe]
#
# --probe   nur pruefen und anzeigen, nichts schreiben
#
# Nie angefasst: .git/, .obsidian/ (Plugin-Code enthaelt eigene {{...}}),
# Claude/installation.md (dokumentiert die Platzhalter) und dieses Skript.
# Nur Schluessel, die noch in Dateien vorkommen, muessen gesetzt sein.
# Exit 0 = fertig, 1 = Werte ungueltig oder Platzhalter uebrig, 2 = falscher Ort.
# Doku: Claude/installation.md, Teil A

set -u

case "${1:-}" in
  -h|--help) sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  --probe) PROBE=1 ;;
  "") PROBE=0 ;;
  *) printf 'Unbekannter Schalter: %s\n' "$1" >&2; exit 2 ;;
esac

VAULT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)"
if [ -z "$VAULT" ] || [ ! -f "$VAULT/CLAUDE.md" ] || [ ! -f "$VAULT/Claude/installation.md" ]; then
  printf 'Vault-Root nicht gefunden, erwartet CLAUDE.md zwei Ebenen ueber diesem Skript\n' >&2
  exit 2
fi
cd "$VAULT" || exit 2

command -v perl >/dev/null 2>&1 || { printf 'perl fehlt. macOS und Git Bash bringen es mit.\n' >&2; exit 2; }

KEYS="VAULT_NAME NAME VOLLER_NAME BERUF BETRIEB BETRIEB_KURZ ORT BEGINN AUSBILDUNGSJAHR HEUTE NAECHSTER_FREITAG MONATSENDE_FREITAG"

T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT

# ------------------------------------------------------ Betroffene Dateien
find . -type f -not -path "./.git/*" -not -path "./.obsidian/*" \
  -not -path "./Claude/installation.md" -not -path "./Claude/scripts/personalisieren.sh" \
  | sed 's|^\./||' | LC_ALL=C sort > "$T/alle"
: > "$T/inhalt"
while IFS= read -r f; do
  grep -Iq '{{[A-Z_]*}}' "$f" 2>/dev/null && printf '%s\n' "$f" >> "$T/inhalt"
done < "$T/alle"
grep '{{[A-Z_]*}}' "$T/alle" > "$T/namen" || true

# Nur Schluessel, die wirklich noch vorkommen, muessen gesetzt sein.
{ while IFS= read -r f; do grep -o '{{[A-Z_]*}}' "$f"; done < "$T/inhalt"
  grep -o '{{[A-Z_]*}}' "$T/namen"; } | tr -d '{}' | LC_ALL=C sort -u > "$T/benutzt"

# ------------------------------------------------------------ Werte pruefen
fehler=0
while IFS= read -r k; do
  case " $KEYS " in
    *" $k "*) ;;
    *) printf 'UNBEKANNT\t{{%s}}\tPlatzhalter ohne Schluessel, Fehler im Skelett\n' "$k"; fehler=1; continue ;;
  esac
  v="$(printenv "SB_$k" || true)"
  if [ -z "$v" ]; then
    printf 'FEHLT\tSB_%s\n' "$k"; fehler=1; continue
  fi
  case "$v" in
    *'{{'*|*'}}'*) printf 'UNGUELTIG\tSB_%s\tenthaelt geschweifte Klammern\n' "$k"; fehler=1; continue ;;
    # Werte landen im YAML-Frontmatter und in einem Python-String.
    *'"'*|*'\'*|*': '*|*' #'*) printf 'UNGUELTIG\tSB_%s\tkein Anfuehrungszeichen, Backslash, ": " oder " #": %s\n' "$k" "$v"; fehler=1; continue ;;
    [\&\*\!\|\>\'\%\@\`\#\[\]\-\ ]*) printf 'UNGUELTIG\tSB_%s\tdarf nicht mit Sonderzeichen oder Leerzeichen beginnen: %s\n' "$k" "$v"; fehler=1; continue ;;
  esac
  case "$k" in
    BEGINN|HEUTE|NAECHSTER_FREITAG|MONATSENDE_FREITAG)
      printf '%s' "$v" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' \
        || { printf 'UNGUELTIG\tSB_%s\tkein Datum JJJJ-MM-TT: %s\n' "$k" "$v"; fehler=1; } ;;
    AUSBILDUNGSJAHR)
      printf '%s' "$v" | grep -Eq '^[1-4]$' \
        || { printf 'UNGUELTIG\tSB_%s\tZahl von 1 bis 4: %s\n' "$k" "$v"; fehler=1; } ;;
    VAULT_NAME|BETRIEB_KURZ)
      # Landen in Datei- und Ordnernamen. Regel aus CLAUDE.md: keine Umlaute,
      # keine Sonderzeichen, damit Git zwischen Windows, macOS und iOS heil bleibt.
      printf '%s' "$v" | grep -Eq '^[A-Za-z0-9][A-Za-z0-9 ._-]*$' \
        || { printf 'UNGUELTIG\tSB_%s\tnur A-Z, a-z, 0-9, Leerzeichen, Punkt, Unterstrich, Bindestrich: %s\n' "$k" "$v"; fehler=1; } ;;
  esac
done < "$T/benutzt"
[ "$fehler" -eq 0 ] || { printf 'Abbruch, nichts geschrieben.\n'; exit 1; }

if [ "$PROBE" -eq 1 ]; then
  printf 'PROBE\t%s Dateien mit Platzhaltern im Inhalt, %s Dateinamen mit Platzhaltern\n' \
    "$(wc -l < "$T/inhalt" | tr -d ' ')" "$(wc -l < "$T/namen" | tr -d ' ')"
  sed 's/^/INHALT\t/' "$T/inhalt"
  sed 's/^/NAME\t/' "$T/namen"
  exit 0
fi

# ----------------------------------------------------------------- Ersetzen
# perl liest die Werte aus der Umgebung. Dadurch brauchen &, / oder Leerzeichen
# in den Werten kein Escaping, anders als bei sed.
ersetze='s/\{\{([A-Z_]+)\}\}/defined $ENV{"SB_$1"} ? $ENV{"SB_$1"} : "{{$1}}"/ge'
n=0
while IFS= read -r f; do
  perl -pi -e "$ersetze" "$f" && n=$((n + 1))
done < "$T/inhalt"

# Dateinamen zuletzt, damit die Inhaltsliste oben gueltig bleibt.
m=0
while IFS= read -r f; do
  neu="$(printf '%s' "$f" | perl -pe "$ersetze")"
  if [ -e "$neu" ]; then
    printf 'KONFLIKT\t%s\t%s existiert schon\n' "$f" "$neu"; continue
  fi
  mv "$f" "$neu" && m=$((m + 1)) && printf 'UMBENANNT\t%s\t%s\n' "$f" "$neu"
done < "$T/namen"

# ------------------------------------------------------------ Gegenprobe
rest=0
while IFS= read -r f; do
  [ -f "$f" ] || continue
  if grep -Iq '{{[A-Z_]*}}' "$f" 2>/dev/null; then
    grep -n '{{[A-Z_]*}}' "$f" | sed "s|^|REST\t$f:|"; rest=1
  fi
done < <(find . -type f -not -path "./.git/*" -not -path "./.obsidian/*" \
  -not -path "./Claude/installation.md" -not -path "./Claude/scripts/personalisieren.sh" | sed 's|^\./||')
find . -name '*{{*' -not -path "./.git/*" -not -path "./.obsidian/*" | sed 's|^\./|REST\t|'
[ -z "$(find . -name '*{{*' -not -path "./.git/*" -not -path "./.obsidian/*")" ] || rest=1

printf 'ZUSAMMENFASSUNG\tdateien=%s\tumbenannt=%s\trest=%s\n' "$n" "$m" "$rest"
[ "$rest" -eq 0 ] || exit 1
exit 0
