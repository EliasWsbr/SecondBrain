#!/usr/bin/env bash
# vault-check.sh
# Prueft den Vault ohne Obsidian.
# Ausgabe: eine Zeile je Befund, tabgetrennt.
#   SCHWERE  CODE  PFAD  DETAIL
# Am Ende eine Zeile ZUSAMMENFASSUNG.
# Exit 0 = keine Fehler, 1 = mindestens ein Fehler, 2 = Aufrufproblem.
#
# Codes:
#   LINK_BROKEN     Wikilink zeigt auf nichts
#   FM_MISSING      Pflichtfeld fehlt
#   FM_BADVALUE     Wert nicht in der geschlossenen Liste oder Datum nicht ISO
#   FM_NOTAGS       tags ist leer
#   ORPHAN          Notiz ohne eingehenden Link
#   INBOX_STALE     liegt laenger als 7 Tage in 00_Inbox
#   DUP_TITLE       Titel aehnelt einem anderen Titel
#   ATTACH_UNUSED   Anhang wird von keiner Notiz referenziert
#
# Doku: Claude/wartung.md

set -u

case "${1:-}" in
  -h|--help)
    sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
esac

VAULT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)"
if [ -z "$VAULT" ] || [ ! -f "$VAULT/CLAUDE.md" ]; then
  printf 'fehler\tSETUP\t.\tVault-Root nicht gefunden, erwartet CLAUDE.md eine Ebene ueber Claude/scripts\n' >&2
  exit 2
fi
cd "$VAULT" || exit 2

T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
TAB="$(printf '\t')"

TODAY="$(date +%Y-%m-%d)"
INBOX_MAX_TAGE=7

# Geschlossene Wertelisten, muessen zu Claude/schema.md passen.
TYPES="index project area note solution device person source berichtsheft berichtsheft-laufend lernthema claude-memory claude-session"
STATI="aktiv ruht entwurf fertig archiviert unsortiert"

# Dateien mit Punkt am Namensanfang (.gitkeep, .DS_Store) zaehlen nicht.
find . -type f -not -path "./.git/*" -not -path "./.obsidian/*" -not -name ".*" \
  | sed 's|^\./||' | LC_ALL=C sort > "$T/files"
grep -E '\.md$' "$T/files" > "$T/notes"

: > "$T/rawlinks"
: > "$T/meta"

# ------------------------------------------- Durchlauf je Notiz, einmal
# Je Datei: Wikilinks einsammeln und das Frontmatter auslesen.
# Eine eigene awk-Runde je Datei, damit Leerzeichen in Pfaden nichts kaputt machen.
while IFS= read -r f; do
  awk -v F="$f" '
    BEGIN { inFm = 0; closed = 0; nk = 0; fence = 0 }
    FNR == 1 && $0 ~ /^---[ \t\r]*$/ { inFm = 1; next }
    inFm && $0 ~ /^---[ \t\r]*$/ { inFm = 0; closed = 1; next }
    inFm {
      if (match($0, /^[A-Za-z_][A-Za-z0-9_-]*:/)) {
        k = substr($0, 1, RLENGTH - 1)
        v = substr($0, RLENGTH + 1)
        sub(/^[ \t]+/, "", v); sub(/[ \t\r]+$/, "", v)
        nk++; key[nk] = k; val[nk] = v
      } else if (nk > 0 && $0 ~ /^[ \t]+-([ \t]|$)/) {
        # Blockliste, wie Obsidian sie schreibt: "tags:" und darunter "  - meta"
        item = $0
        sub(/^[ \t]+-[ \t]*/, "", item); sub(/[ \t\r]+$/, "", item)
        if (item != "") val[nk] = (val[nk] == "" ? item : val[nk] ", " item)
      }
      next
    }
    # Codebloecke und Inline-Code enthalten keine echten Links.
    /^[ \t]*```/ { fence = !fence; next }
    fence { next }
    {
      line = $0
      gsub(/`[^`]*`/, "", line)
      while (match(line, /\[\[[^]]+\]\]/)) {
        t = substr(line, RSTART + 2, RLENGTH - 4)
        line = substr(line, RSTART + RLENGTH)
        sub(/\|.*$/, "", t)
        sub(/#.*$/, "", t)
        sub(/\^.*$/, "", t)
        while (length(t) > 0 && substr(t, length(t), 1) == "\\") t = substr(t, 1, length(t) - 1)
        sub(/[ \t\r]+$/, "", t); sub(/^[ \t]+/, "", t)
        if (t != "") printf "L\t%s\t%d\t%s\n", F, FNR, t
      }
    }
    END {
      fm = ""
      for (i = 1; i <= nk; i++) fm = fm key[i] "=" val[i] "\036"
      printf "M\t%s\t%s\t%s\n", F, (closed ? "ja" : "nein"), fm
    }
  ' "$f"
done < "$T/notes" > "$T/roh"

grep '^L'"$TAB" "$T/roh" | cut -f2- > "$T/rawlinks"
grep '^M'"$TAB" "$T/roh" | cut -f2- > "$T/meta"

: > "$T/befunde"

# ------------------------------------------------------ Links aufloesen
awk -F'\t' -v LIST="$T/files" '
  function norm(s) { sub(/\.md$/, "", s); return s }
  function add(k, v) { if (k in key) { if (key[k] != v) amb[k] = 1 } else key[k] = v }
  BEGIN {
    while ((getline l < LIST) > 0) {
      add(l, l); add(norm(l), l)
      n = split(l, p, "/"); add(p[n], l); add(norm(p[n]), l)
    }
  }
  { if ($3 in key) printf "%s\t%s\t%s\t%s\n", $1, $2, $3, key[$3]
    else           printf "%s\t%s\t%s\t\n",   $1, $2, $3 }
' "$T/rawlinks" > "$T/links"

awk -F'\t' '$4 == "" { printf "fehler\tLINK_BROKEN\t%s\tZeile %s zeigt auf [[%s]]\n", $1, $2, $3 }' \
  "$T/links" >> "$T/befunde"

# Links aus 40_Archive zaehlen nicht als eingehend. Sonst haelt eine
# ersetzte Fassung eine Notiz kuenstlich am Leben.
awk -F'\t' '$4 != "" && $4 != $1 && $1 !~ /^40_Archive\// { c[$4]++ } END { for (k in c) printf "%s\t%d\n", k, c[k] }' \
  "$T/links" | LC_ALL=C sort > "$T/eingehend"

# --------------------------------------------------- Frontmatter pruefen
awk -F'\t' -v TYPES="$TYPES" -v STATI="$STATI" '
  BEGIN {
    n = split(TYPES, a, " "); for (i = 1; i <= n; i++) okType[a[i]] = 1
    n = split(STATI, b, " "); for (i = 1; i <= n; i++) okStatus[b[i]] = 1
    split("type status created updated tags", pflicht, " ")
  }
  {
    file = $1; closed = $2; fm = $3
    if (file ~ /^Templates\//) next
    delete have; delete val
    m = split(fm, felder, "\036")
    for (i = 1; i <= m; i++) {
      if (felder[i] == "") continue
      p = index(felder[i], "=")
      if (p == 0) continue
      k = substr(felder[i], 1, p - 1)
      have[k] = 1; val[k] = substr(felder[i], p + 1)
    }
    if (closed != "ja") { printf "fehler\tFM_MISSING\t%s\tkein abgeschlossenes Frontmatter\n", file; next }
    for (k = 1; k <= 5; k++)
      if (!(pflicht[k] in have)) printf "fehler\tFM_MISSING\t%s\t%s fehlt\n", file, pflicht[k]
    if ("type" in have && !(val["type"] in okType))
      printf "fehler\tFM_BADVALUE\t%s\ttype %s steht nicht in der Liste\n", file, val["type"]
    if ("status" in have && !(val["status"] in okStatus))
      printf "fehler\tFM_BADVALUE\t%s\tstatus %s steht nicht in der Liste\n", file, val["status"]
    for (k in have)
      if ((k == "created" || k == "updated") && val[k] !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/)
        printf "fehler\tFM_BADVALUE\t%s\t%s ist kein ISO-Datum: %s\n", file, k, val[k]
    if ("tags" in have) {
      t = val["tags"]; gsub(/[][ \t]/, "", t)
      if (t == "") printf "fehler\tFM_NOTAGS\t%s\tmindestens ein Tag setzen\n", file
    }
    if (file ~ /^40_Archive\// && "status" in have && val["status"] != "archiviert")
      printf "fehler\tFM_BADVALUE\t%s\tin 40_Archive muss status archiviert sein, ist %s\n", file, val["status"]
    printf "META\t%s\t%s\t%s\n", file, val["status"], val["created"] > "/dev/stderr"
  }
' "$T/meta" 2>"$T/status" >> "$T/befunde"

# ------------------------------------------------------------- Orphans
# Ausgenommen: Vorlagen, Archiv, jede _index.md und die drei festen Einstiege.
while IFS= read -r f; do
  case "$f" in
    Templates/*|40_Archive/*) continue ;;
    _index.md|CLAUDE.md|Start.md) continue ;;
    */_index.md|_index.md) continue ;;
  esac
  if ! grep -qF "$f$TAB" "$T/eingehend"; then
    printf 'warnung\tORPHAN\t%s\tkein eingehender Wikilink\n' "$f" >> "$T/befunde"
  fi
done < "$T/notes"

# --------------------------------------------------------- Inbox-Alter
# GNU date (Linux, Git Bash) kennt -d, BSD date (macOS) braucht -j -f.
epoch() { date -d "$1" +%s 2>/dev/null || date -j -f '%Y-%m-%d' "$1" +%s 2>/dev/null; }
n_now=$(epoch "$TODAY") || n_now=0
while IFS="$TAB" read -r marker f status created; do
  case "$f" in
    00_Inbox/_index.md|00_Inbox/Inbox.md) continue ;;
    00_Inbox/*) ;;
    *) continue ;;
  esac
  [ -z "${created:-}" ] && continue
  c=$(epoch "$created") || continue
  tage=$(( (n_now - c) / 86400 ))
  if [ "$tage" -gt "$INBOX_MAX_TAGE" ]; then
    printf 'warnung\tINBOX_STALE\t%s\tliegt seit %s Tagen in der Inbox\n' "$f" "$tage" >> "$T/befunde"
  fi
done < "$T/status"

# ------------------------------------------------------- Titel-Dubletten
# Gemeldet wird ab 70 Prozent gemeinsamer Woerter, bei mindestens zwei
# Woertern je Titel. Vorlagen und Indizes bleiben aussen vor.
grep -vE '(^|/)_index\.md$' "$T/notes" | grep -v '^Templates/' \
| awk -F'/' '{ b = $NF; sub(/\.md$/, "", b); print b "\t" $0 }' > "$T/titel"

awk -F'\t' '
  {
    t = tolower($1)
    gsub(/[^a-z0-9 ]/, " ", t)
    gsub(/  +/, " ", t); sub(/^ /, "", t); sub(/ $/, "", t)
    pfad[NR] = $2; norm[NR] = t
  }
  END {
    for (i = 1; i <= NR; i++) for (j = i + 1; j <= NR; j++) {
      ni = split(norm[i], wi, " "); nj = split(norm[j], wj, " ")
      if (ni < 2 || nj < 2) continue
      delete seen; gemeinsam = 0
      for (k = 1; k <= ni; k++) seen[wi[k]] = 1
      for (k = 1; k <= nj; k++) if (wj[k] in seen) gemeinsam++
      union = ni + nj - gemeinsam
      if (union > 0 && gemeinsam / union >= 0.7)
        printf "warnung\tDUP_TITLE\t%s\taehnelt %s\n", pfad[i], pfad[j]
    }
  }
' "$T/titel" >> "$T/befunde"

# ----------------------------------------------------- Ungenutzte Anhaenge
grep -E '^Attachments/' "$T/files" > "$T/anhaenge" || true
cut -f3 "$T/links" | LC_ALL=C sort -u > "$T/ziele"
while IFS= read -r a; do
  [ -z "$a" ] && continue
  b="${a##*/}"
  if ! grep -qxF "$a" "$T/ziele" && ! grep -qxF "$b" "$T/ziele"; then
    printf 'hinweis\tATTACH_UNUSED\t%s\tvon keiner Notiz referenziert\n' "$a" >> "$T/befunde"
  fi
done < "$T/anhaenge"

# ------------------------------------------------------------- Ausgabe
LC_ALL=C sort -t"$TAB" -k2,2 -k3,3 "$T/befunde"

f=$(grep -c '^fehler'  "$T/befunde" || true)
w=$(grep -c '^warnung' "$T/befunde" || true)
h=$(grep -c '^hinweis' "$T/befunde" || true)
n=$(wc -l < "$T/notes" | tr -d ' ')
l=$(wc -l < "$T/links" | tr -d ' ')
printf 'ZUSAMMENFASSUNG\tnotizen=%s\tlinks=%s\tfehler=%s\twarnung=%s\thinweis=%s\n' "$n" "$l" "$f" "$w" "$h"

[ "$f" -gt 0 ] && exit 1
exit 0
