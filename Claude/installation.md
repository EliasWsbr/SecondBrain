---
type: index
status: aktiv
created: 2026-10-13
updated: 2026-10-13
tags: [claude, meta]
---

# Installation

Für Claude, nicht für den Menschen. Diese Datei richtet den Vault so ein, dass er sich genauso verhält wie das Original: Obsidian als Oberfläche, Claude als Pfleger über MCP, Git als Backup und Sync.
Arbeite die Schritte der Reihe nach ab. Jeder Schritt beginnt mit **Erledigt, wenn**. Trifft das schon zu, überspring ihn. Dadurch kannst du nach jedem Neustart von Claude Code einfach oben wieder anfangen.

| Teil | Wann |
| --- | --- |
| A Ersteinrichtung | genau einmal, direkt nach dem Klonen des Skeletts. Erkennbar am Block "Ersteinrichtung offen" oben in `CLAUDE.md` |
| B Weiteres Gerät | der Vault liegt schon auf GitHub und soll auf einen zweiten Rechner |
| C Reparatur | MCP, Plugins oder Sync funktionieren nicht mehr |

## Grundregeln während der Installation

- Während Teil A gelten die Arbeitsregeln aus `CLAUDE.md` noch nicht vollständig. MCP gibt es erst ab A8, bis dahin arbeitest du mit Datei- und Shell-Werkzeugen. Schreibstil und Commit-Präfix `ki: ` gelten trotzdem.
- Alle Fragen an den Nutzer in **einer** Nachricht bündeln. Nachfragen nur, wenn eine Antwort fehlt oder unklar ist.
- Bei jedem Schritt, den der Nutzer selbst machen muss, genau sagen, wo er klickt. Nichts voraussetzen.
- Außerhalb des Vault-Ordners nur zwei Dinge ändern: die MCP-Registrierung von Claude Code (über `claude mcp add`, schreibt der Nutzer) und auf Wunsch ein GitHub-Repo. Keine globalen Installationen (`brew`, `winget`, `pip`) ohne Rückfrage.
- Den MCP-Token nie in eine Datei im Vault schreiben, nie committen, nie im Chat wiederholen.
- Schlägt etwas fehl: Ausgabe zeigen, Ursache nennen, Teil C prüfen. Nicht raten, nicht still weitermachen.
- Am Ende muss der Vault leer sein bis auf die Grundstruktur. Keine Testnotizen anlegen, keine Beispielinhalte erfinden.

## Wie der Vault funktioniert

Lies das einmal, bevor du anfängst. Sonst weißt du in Teil C nicht, wo du suchen musst.

### Prinzip

- PARA für Handlungsorientiertes (`00_Inbox` bis `40_Archive`), Zettelkasten für Wissen in `30_Resources`. Ordner sagen, wie dringend etwas ist. Links und Tags sagen, worum es geht.
- Jede Notiz hat fünf Pflichtfelder (`type`, `status`, `created`, `updated`, `tags`) mit geschlossenen Wertelisten aus `Claude/schema.md`. Darauf bauen alle Dashboards auf.
- Der Nutzer pflegt kaum von Hand. Er erzählt, Claude legt ab. Die Regeln dafür stehen in `CLAUDE.md`, die Details in `Claude/`.
- Neues landet in `00_Inbox/` und wird nach der Entscheidungstabelle in `Claude/inbox-regeln.md` einsortiert.
- `Claude/scripts/vault-check.sh` prüft Links, Frontmatter, Waisen und Inbox-Alter ohne Obsidian. Wann es läuft, steht in `Claude/wartung.md`.

### Bausteine

| Baustein | Wo | Aufgabe |
| --- | --- | --- |
| `CLAUDE.md` | Root | einzige Regelquelle. Claude Code lädt sie automatisch, Claude Desktop über die Projektanweisung |
| `_index.md` je Ordner | überall | Wegweiser. Claude liest erst Index, dann Notiz, nie den ganzen Vault |
| `Start.md` | Root | Cockpit für den Menschen: Berichtsheft, fällige Aufgaben, Schnellzugriff |
| `Claude/schema.md` | `Claude/` | erlaubte Werte für `type`, `status`, Tags, Fachfelder |
| `Claude/Memory/` | `Claude/` | dauerhafte Fakten über den Nutzer, eine Datei je Thema. Startet leer |
| `Claude/Sessions/` | `Claude/` | Zusammenfassungen wichtiger Unterhaltungen. Startet leer |
| `Templates/` | Root | eine Vorlage je `type`. Core-Plugin Vorlagen zeigt hierher |
| `*.base` | mehrere Ordner | Dashboards des Core-Plugins Bases (ab Obsidian 1.9). Filtern nach `type` und `status` |
| `30_Resources/vault-status.md` | `30_Resources/` | Kennzahlen und Lücken per Dataview |
| `20_Areas/Ausbildung/` | `20_Areas/` | Berichtsheft-Modul: Stichworte, laufende Fassung, Wochennotizen, PDF-Bau |

### Plugins

| Plugin | Ordner-ID | Aufgabe | Quelle | im Repo |
| --- | --- | --- | --- | --- |
| Git | `obsidian-git` | committet alle 10 Minuten, holt beim Start | vinzent03/obsidian-git | Code ja, Einstellungen nein (A5) |
| Dataview | `dataview` | Abfragen in `vault-status.md` | blacksmithgu/obsidian-dataview | ja |
| Tasks | `obsidian-tasks-plugin` | wiederkehrende Aufgaben, `tasks`-Blöcke in `Start.md` | obsidian-tasks-group/obsidian-tasks | ja |
| Iconize | `obsidian-icon-folder` | Ordner-Icons | florianwoelki/obsidian-iconize | ja, inklusive Icon-Zuordnung |
| Recent Files | `recent-files-obsidian` | Liste zuletzt geöffneter Dateien | tgrosinger/recent-files-obsidian | ja |
| MCP Connector | `mcp-tools-istefox` | MCP-Server in Obsidian, Brücke zu Claude | istefox/obsidian-mcp-connector | nein, läuft nur auf Desktop, wird in A5 geladen |

Theme: Tokyo Night. CSS-Snippet: `graph-styler-nord`. Beides liegt im Repo und ist in `.obsidian/appearance.json` aktiv.

### Was nicht versioniert ist

`.gitignore` hält Geräteabhängiges aus dem Repo, sonst gibt es bei jedem Sync Konflikte:

- `.obsidian/workspace*.json`, `graph.json`: Fensterzustand je Gerät.
- `.obsidian/plugins/*/data.json`: Plugin-Einstellungen, darunter der MCP-Token. Ausnahme: Iconize, weil die Icon-Zuordnung kein Geheimnis ist. Deshalb schreibst du die Git-Einstellungen in A5 auf jedem Gerät neu.
- `.obsidian/plugins/mcp-tools-istefox/`: das MCP-Plugin, weil es auf iOS nicht läuft und 2,8 MB groß ist.
- `Attachments/Referenz/`: große Referenz-PDFs bleiben lokal.

### Datenfluss im Alltag

1. Nutzer sagt Claude etwas, in Claude Code im Vault-Ordner oder in Claude Desktop im Projekt.
2. Claude folgt `CLAUDE.md` und schreibt über die MCP-Tools (`patch_vault_file`, `create_vault_file`, `search_vault` usw.) direkt in den offenen Vault.
3. Obsidian Git committet nach spätestens 10 Minuten als `vault backup: <Zeitstempel>` und schiebt nach GitHub.
4. Andere Geräte holen den Stand beim Start von Obsidian und danach alle 10 Minuten.

MCP funktioniert nur, solange Obsidian mit diesem Vault läuft. Der Server bindet nur an `127.0.0.1`, nichts verlässt den Rechner.

### Was der Nutzer selbst tun muss

Alles andere machst du. Sag ihm diese Liste gleich am Anfang, damit er weiß, was kommt:

1. Fragen beantworten (A2).
2. Falls nötig, einmal bei GitHub anmelden (A6).
3. Obsidian öffnen und den Plugins vertrauen (A7).
4. Einen Befehl aus den Obsidian-Einstellungen kopieren und ausführen, dann Claude Code neu starten (A8).
5. Optional: Claude Desktop anbinden (A9).

Dauer: etwa 15 bis 20 Minuten.

## Teil A: Ersteinrichtung

### A1 Voraussetzungen prüfen

**Erledigt, wenn:** alle Pflichtzeilen der Tabelle grün sind.

Arbeitsverzeichnis muss der Vault-Root sein: `ls CLAUDE.md Claude/installation.md` findet beide Dateien. Sonst den Nutzer nach dem Pfad fragen und dorthin wechseln.

Betriebssystem mit `uname -s` feststellen: `Darwin` ist macOS, `MINGW*` oder `MSYS*` ist Windows mit Git Bash, `Linux` ist Linux. Unter Windows läuft Claude Code in Git Bash, alle Befehle hier funktionieren dort. Linux ist nicht getestet. Weicht dort etwas ab, sag es dem Nutzer, statt zu raten.

| Was | Pflicht | Prüfen | Fehlt es |
| --- | --- | --- | --- |
| Git | ja | `git --version` | macOS: Nutzer führt `xcode-select --install` aus. Windows: Git for Windows von git-scm.com. Linux: über den Paketmanager der Distribution |
| Git-Identität | ja | `git config user.name` und `git config user.email` | in A2 mitfragen, dann `git config --global user.name ...` und `user.email ...` setzen |
| Obsidian | ja | macOS: `ls -d /Applications/Obsidian.app`. Windows: `ls "$LOCALAPPDATA/Programs/Obsidian/Obsidian.exe"`. Linux: `command -v obsidian` oder `flatpak info md.obsidian.Obsidian` | Nutzer installiert von obsidian.md/download. Liegt es woanders, einfach nachfragen |
| perl, curl | ja | `perl -v`, `curl --version` | bringen macOS und Git Bash mit, unter Linux über den Paketmanager |
| GitHub CLI | nein | `gh --version` und `gh auth status` | ohne `gh` legt der Nutzer das Repo in A6 im Browser an |
| Python 3 mit python-docx, LibreOffice | nein | `python3 -c "import docx"`, `soffice --version` | nur für Berichtsheft-PDFs. Später nachrüsten, siehe `Claude/berichtsheft.md` |

Prüfe außerdem, ob dieser Ordner schon in Obsidian offen ist (der Nutzer weiß das). Wenn ja: Obsidian bis A7 schließen lassen. Sonst überschreibt Obsidian Git die Einstellungen aus A5.

### A2 Fragen stellen

**Erledigt, wenn:** alle Werte feststehen und der Nutzer die Zusammenfassung bestätigt hat.

Stell diese Fragen in einer einzigen Nachricht. Zeig die Beispiele mit, damit klar ist, welches Format gemeint ist.

| Schlüssel | Frage | Beispiel | Regel |
| --- | --- | --- | --- |
| `VAULT_NAME` | Wie soll dein Vault heißen? | `MaxBrain` | nur A bis Z, a bis z, 0 bis 9, Leerzeichen, Punkt, Unterstrich, Bindestrich. Keine Umlaute |
| `NAME` | Dein Vorname, so wie Claude dich anspricht | `Max` | |
| `VOLLER_NAME` | Vor- und Nachname, so wie er aufs Berichtsheft soll | `Max Mustermann` | |
| `BERUF` | Ausbildungsberuf | `Fachinformatiker Systemintegration` | |
| `BETRIEB` | Ausbildungsbetrieb mit Ort | `Beispiel GmbH, Musterstadt` | |
| `BETRIEB_KURZ` | Kurzname des Betriebs, landet im Dateinamen | `Beispiel` | gleiche Zeichenregel wie `VAULT_NAME` |
| `ORT` | Ort für "Ort, Datum" auf dem Berichtsheft | `Musterstadt` | |
| `BEGINN` | Ausbildungsbeginn | `2026-09-01` | in `JJJJ-MM-TT` umwandeln |
| `AUSBILDUNGSJAHR` | Aktuelles Ausbildungsjahr | `1` | 1 bis 4 |

Dazu, ohne Platzhalter:

- Soll ich ein **privates** GitHub-Repo für Backup und Sync anlegen? Unter welchem Namen? Vorschlag: `VAULT_NAME` ohne Leerzeichen.
- Nutzt du Claude Desktop zusätzlich zu Claude Code?
- Falls A1 keine Git-Identität gefunden hat: Name und E-Mail für Commits.

Diese Werte ermittelst du selbst, nicht fragen:

| Schlüssel | Wert |
| --- | --- |
| `HEUTE` | `date +%Y-%m-%d` |
| `NAECHSTER_FREITAG` | nächster Freitag ab heute, heute eingeschlossen |
| `MONATSENDE_FREITAG` | letzter Freitag des laufenden Monats. Ist der schon vorbei, der letzte Freitag des nächsten Monats |

Wochentag gegenprüfen: macOS `date -j -f %Y-%m-%d <datum> +%A`, Git Bash und Linux `date -d <datum> +%A`.

Ist der Nutzer gar nicht in Ausbildung, gilt der Anhang "Ohne Ausbildung", bevor du weitermachst.

Fass am Ende alle Werte in einer Tabelle zusammen und frag einmal: "Passt das so?" Erst danach weiter. Der Name landet auf offiziellen Dokumenten, Tippfehler sind dort teuer.

### A3 Git-Historie klären

**Erledigt, wenn:** `.git` existiert und die Historie entweder leer ist oder dem Nutzer gehört.

Stell fest, wie das Skelett auf den Rechner kam:

| Befund | Bedeutung | Tun |
| --- | --- | --- |
| kein Ordner `.git` | ZIP-Download | `git init -b main` |
| `git remote get-url origin` zeigt auf ein Repo des Nutzers | GitHub-Vorlage "Use this template" | nichts, Historie bleibt |
| `origin` zeigt auf ein fremdes Repo | per `git clone` vom Skelett geholt | Historie neu anlegen, siehe unten |

Wem ein Repo gehört: mit `gh` per `gh api user -q .login` gegen den Besitzer in der URL vergleichen. Ohne `gh` den Nutzer fragen.

Historie neu anlegen, nur im dritten Fall:

```bash
git log --format='%h %an %s'      # nur Skelett-Commits? Sonst abbrechen und fragen
rm -rf .git
git init -b main
```

Grund: Die Skelett-Historie gehört nicht in den Vault des Nutzers, und `origin` würde sonst auf das fremde Repo pushen.

### A4 Personalisieren

**Erledigt, wenn:** dieser Befehl nichts ausgibt:

```bash
grep -rIl --exclude-dir=.git --exclude-dir=.obsidian '{{[A-Z_]*}}' . | grep -v -e 'Claude/installation.md$' -e 'Claude/scripts/personalisieren.sh$'
```

`Claude/scripts/personalisieren.sh` ersetzt alle Platzhalter in Inhalten und Dateinamen. Werte kommen als Umgebungsvariablen mit Präfix `SB_`. Werte in einfache Anführungszeichen setzen. Ein einfaches Anführungszeichen im Wert schreibst du als `'\''`.

Erst Probelauf, er schreibt nichts:

```bash
SB_VAULT_NAME='...' SB_NAME='...' SB_VOLLER_NAME='...' SB_BERUF='...' \
SB_BETRIEB='...' SB_BETRIEB_KURZ='...' SB_ORT='...' SB_BEGINN='JJJJ-MM-TT' \
SB_AUSBILDUNGSJAHR='1' SB_HEUTE='JJJJ-MM-TT' \
SB_NAECHSTER_FREITAG='JJJJ-MM-TT' SB_MONATSENDE_FREITAG='JJJJ-MM-TT' \
bash Claude/scripts/personalisieren.sh --probe
```

Erwartet: eine Zeile `PROBE` und eine Liste der betroffenen Dateien. `FEHLT` oder `UNGUELTIG` heißt: Wert korrigieren, nicht weitermachen.
Dann derselbe Befehl ohne `--probe`. Erwartet: `UMBENANNT` für `Ausbildung {{BETRIEB_KURZ}}.md` und am Ende `ZUSAMMENFASSUNG ... rest=0`.

Stichprobe: `head -12 CLAUDE.md` zeigt den Vault-Namen und die Kopfzeile mit Name, Beruf, Betrieb.

### A5 Obsidian vorbereiten

**Erledigt, wenn:** `.obsidian/plugins/obsidian-git/data.json` existiert und `.obsidian/plugins/mcp-tools-istefox/manifest.json` die ID `mcp-tools-istefox` enthält.

Obsidian muss für diesen Vault noch geschlossen sein.

**1. Einstellungen für Obsidian Git schreiben.** Die Datei ist nicht versioniert, deshalb fehlt sie nach jedem Klonen. Inhalt, wenn es ein GitHub-Repo gibt oder geben wird:

```json
{
  "commitMessage": "vault backup: {{date}}",
  "autoCommitMessage": "vault backup: {{date}}",
  "commitDateFormat": "YYYY-MM-DD HH:mm:ss",
  "autoSaveInterval": 10,
  "autoPushInterval": 0,
  "autoPullInterval": 10,
  "autoPullOnBoot": true,
  "disablePush": false,
  "pullBeforePush": true,
  "differentIntervalCommitAndPush": false,
  "syncMethod": "merge",
  "autoBackupAfterFileChange": false,
  "showStatusBar": true
}
```

Bedeutung: alle 10 Minuten Commit und Push in einem Rutsch, vorher Pull. Beim Start Pull. `{{date}}` ist hier Syntax von Obsidian Git, kein Platzhalter des Skeletts.
Ohne Remote setzt du `"disablePush": true`, `"autoPullOnBoot": false` und `"autoPullInterval": 0`. Sonst meldet das Plugin alle 10 Minuten einen Fehler.

**2. MCP Connector laden.** Gleiche Quelle wie der Community-Store von Obsidian, die GitHub-Releases des Plugins:

```bash
P=.obsidian/plugins/mcp-tools-istefox
mkdir -p "$P"
for f in main.js manifest.json styles.css; do
  curl -fsSL -o "$P/$f" "https://github.com/istefox/obsidian-mcp-connector/releases/latest/download/$f" || rm -f "$P/$f"
done
grep '"id"' "$P/manifest.json" && grep '"version"' "$P/manifest.json" && ls -l "$P"
```

Erwartet: `main.js` mit rund 2,8 MB und `manifest.json` mit `"id": "mcp-tools-istefox"`. Ein fehlendes `styles.css` ist normal.
Unter macOS danach: `chmod go-w .obsidian/plugins "$P"`. Sonst verweigert der Broker des Plugins die Registrierung.
Scheitert der Download, installiert der Nutzer das Plugin in A7 über den Store.

**3. Restliche Plugins prüfen.** Jeder dieser Ordner braucht `main.js` und `manifest.json`: `dataview`, `obsidian-git`, `obsidian-icon-folder`, `obsidian-tasks-plugin`, `recent-files-obsidian`.

```bash
for p in dataview obsidian-git obsidian-icon-folder obsidian-tasks-plugin recent-files-obsidian mcp-tools-istefox; do
  printf '%-24s %s\n' "$p" "$(ls .obsidian/plugins/$p/main.js .obsidian/plugins/$p/manifest.json 2>/dev/null | wc -l | tr -d ' ')"
done
```

Jede Zeile muss `2` zeigen. `.obsidian/community-plugins.json` listet alle sechs schon, sie werden beim ersten Öffnen aktiv.

### A6 Erster Commit und GitHub

**Erledigt, wenn:** `git log --oneline` mindestens einen Commit zeigt und, falls ein Repo gewünscht war, `git status -sb` in der ersten Zeile `main...origin/main` ohne `ahead` zeigt.

```bash
git add -A
git status --short | grep 'data.json'    # darf nur obsidian-icon-folder/data.json zeigen
git commit -m "ki: Vault aus Skelett eingerichtet"
```

Taucht ein anderes `data.json` auf, stimmt die `.gitignore` nicht. Dann stoppen, sonst landet der MCP-Token im Repo.

GitHub, nur wenn der Nutzer in A2 zugestimmt hat. Das Repo ist immer privat, weil der Vault persönliche Daten und Berichtshefte enthält.

| Lage | Tun |
| --- | --- |
| `origin` existiert schon (Vorlage) | `git push -u origin main` |
| `gh` angemeldet | `gh repo create "<REPO>" --private --source=. --remote=origin --push`, danach `gh auth setup-git` |
| `gh` da, nicht angemeldet | Nutzer tippt `! gh auth login` und folgt dem Browser-Dialog. Dann wie oben |
| kein `gh` | Nutzer legt auf github.com/new ein leeres privates Repo an, ohne README und ohne .gitignore, und nennt dir die URL. Dann `git remote add origin <URL>` und `git push -u origin main` |

`gh auth setup-git` hinterlegt die Anmeldung für Git. Ohne das kann Obsidian Git später nicht pushen. Unter Windows übernimmt das alternativ der Git Credential Manager, der beim ersten Push ein Browserfenster öffnet.

### A7 Obsidian öffnen

**Erledigt, wenn:** der Nutzer bestätigt, dass der Vault offen ist und sechs Community-Plugins aktiv sind.

Gib dem Nutzer diese Schritte, mit dem echten Pfad aus `pwd`:

1. Obsidian starten. Im Startfenster "Ordner als Vault öffnen" wählen (englisch: "Open folder as vault") und diesen Ordner auswählen: `<Pfad>`. Ist schon ein anderer Vault offen: unten links auf den Vault-Namen klicken, "Vaults verwalten", dann "Ordner als Vault öffnen".
2. Bei der Frage, ob du dem Autor vertraust: "Vertrauen und Plugins aktivieren" (englisch: "Trust author and enable plugins").
3. Falls der MCP Connector in A5 nicht geladen werden konnte: Einstellungen, Community-Plugins, Durchsuchen, "MCP Connector" von istefox, Installieren, Aktivieren.
4. Kontrolle: Die Ordner links haben Icons. `Start.md` zeigt unter "Offen" zwei Berichtsheft-Aufgaben. Einstellungen, Community-Plugins zeigt sechs aktive Plugins.

Bietet Obsidian Plugin-Updates an, darf der Nutzer sie installieren.
Öffnet eine `.base`-Datei nicht als Tabelle, ist Obsidian älter als 1.9. Dann Obsidian aktualisieren lassen.

### A8 MCP für Claude Code verbinden

**Erledigt, wenn:** `claude mcp list` einen Eintrag `obsidian_...` als verbunden zeigt und in dieser Session ein Aufruf von `get_server_info` mit `"status":"ok"` antwortet.

Prüf zuerst `claude mcp list`. Steht dort schon ein verbundener Eintrag für diesen Vault, weiter bei "Nach dem Neustart".

Sag dem Nutzer:

1. In Obsidian: Einstellungen, links unten "MCP Connector", Abschnitt "Access control".
2. In der Zeile des Tokens "Default" auf den Knopf "Claude Code" klicken. Das kopiert einen fertigen Befehl `claude mcp add --transport http --scope user ...` mit Adresse und Token.
3. Den Befehl in einem **eigenen Terminalfenster** einfügen und ausführen, nicht hier im Chat. Grund: So landet der Token nicht im Gesprächsverlauf.
4. Diese Claude-Code-Session beenden (`/exit`) und im Vault-Ordner mit `claude --continue` neu starten. Erst dann sieht Claude die neuen Tools.

Die Beschriftungen stammen aus Version 3 des Plugins und können sich leicht ändern. Findet der Nutzer den Knopf nicht, lies die aktuelle Anleitung im README von istefox/obsidian-mcp-connector, Abschnitt "Connecting a client".

Nach dem Neustart:

- `get_server_info` aufrufen. Erwartet: `"status":"ok"`.
- `list_vault_files` oder `get_vault_overview` aufrufen. Erwartet: die Ordner `00_Inbox` bis `Templates` und `Claude`.
- Den Servernamen notieren (`obsidian_<vault>`). Die Tools heißen in Claude Code `mcp__obsidian_<vault>__<tool>`.

Klappt die Verbindung nicht: Teil C.

### A9 Claude Desktop, optional

**Erledigt, wenn:** der Nutzer Claude Desktop nicht nutzt, oder dort im Projekt `VAULT_NAME` ein Aufruf von `get_server_info` funktioniert.

Sag dem Nutzer:

1. In Obsidian unter "Access control" einen zweiten Token anlegen, Label `Claude Desktop`. Ein Token je Client erlaubt es, einen Client zu sperren, ohne den anderen zu treffen.
2. In dessen Zeile auf ".mcpb" klicken. Die Datei per Drag and Drop auf das Fenster von Claude Desktop ziehen. Sie erscheint unter Einstellungen, Erweiterungen. Node.js ist dafür nicht nötig.
3. In Claude Desktop ein Projekt mit dem Namen des Vaults anlegen. Als Projektanweisung genau den Text aus `Claude/setup.md`, Abschnitt "Claude Desktop", einfügen. Den Text gibst du ihm aus der Datei, er ist schon personalisiert.
4. Claude Desktop komplett beenden und neu starten, auf macOS mit Cmd+Q.
5. Im Projekt testen: "Ruf get_server_info auf."

### A10 Prüfen

**Erledigt, wenn:** alle drei Prüfungen bestanden sind.

1. `bash Claude/scripts/vault-check.sh`. Erwartet vor A11: genau ein `FM_MISSING` und ein `ORPHAN` für `README.md`, sonst nichts. Die Datei fällt in A11 weg. Alles andere nach `Claude/wartung.md` beheben.
2. MCP: `search_vault_simple` mit der Anfrage `Berichtsheft` liefert Treffer in `20_Areas/Ausbildung/`.
3. Nutzer bestätigt: `30_Resources/vault-status.md` zeigt Tabellen statt Code, `Start.md` zeigt die Aufgaben, unten rechts zeigt die Statusleiste Obsidian Git.

### A11 Abschluss

**Erledigt, wenn:** `CLAUDE.md` mit `# <VAULT_NAME>` beginnt und `README.md` nicht mehr existiert.

```bash
git rm -q README.md Claude/scripts/personalisieren.sh
perl -0pi -e 's/<!-- INSTALLATION:START -->.*?<!-- INSTALLATION:END -->\n+//s' CLAUDE.md
head -3 CLAUDE.md
bash Claude/scripts/vault-check.sh | tail -1    # erwartet: fehler=0 warnung=0 hinweis=0
git add -A
git commit -m "ki: Ersteinrichtung abgeschlossen"
git push    # nur mit Remote
```

`Claude/installation.md` bleibt. Sie wird für Teil B und C gebraucht.

Dann dem Nutzer kurz melden:

- was eingerichtet ist: Vault, Plugins, MCP, Git, gegebenenfalls GitHub und Claude Desktop.
- was offen ist, als Liste: zum Beispiel Berichtsheft-PDF-Werkzeuge, iPhone, Claude Desktop.
- wie es losgeht: "Erzähl mir was über dich, dann lege ich `Claude/Memory/Profil.md` an." Und: "Unter der Woche Stichworte in `Berichtsheft Notizen` werfen, freitags machen wir die Woche fertig."

## Teil B: Weiteres Gerät

Der Vault existiert schon auf GitHub. Nichts personalisieren, keine Historie anfassen.

1. **A1** Voraussetzungen prüfen.
2. **Klonen**, wenn der Vault noch nicht lokal liegt: `git clone <URL> "<VAULT_NAME>"`. Die URL kennt der Nutzer, mit `gh` hilft `gh repo list`. Danach Claude Code in diesem Ordner neu starten.
3. **A5** Obsidian vorbereiten: Git-Einstellungen schreiben, MCP Connector laden.
4. Bei Bedarf `gh auth setup-git` oder Git Credential Manager, damit Obsidian Git pushen darf.
5. **A7** Obsidian öffnen.
6. **A8** MCP verbinden. Jedes Gerät hat einen eigenen Token, weil `data.json` nicht synchronisiert wird.
7. **A9** optional.
8. `bash Claude/scripts/vault-check.sh`.

### iPhone und iPad

Nicht automatisierbar, nur auf ausdrücklichen Wunsch beschreiben:

- Obsidian aus dem App Store, darin das Community-Plugin Git. Repo per HTTPS klonen, Anmeldung mit GitHub-Benutzername und einem Fine-grained Personal Access Token, der nur auf dieses Repo Lese- und Schreibrecht für Contents hat.
- Der MCP Connector fehlt dort absichtlich. Claude kann auf dem iPhone nicht in den Vault schreiben.

> [!warning] Zu verifizieren
> Obsidian Git auf iOS gilt laut Plugin-Doku als eingeschränkt. Vor der Empfehlung die aktuelle Doku von vinzent03/obsidian-git lesen.

## Teil C: Reparatur

| Symptom | Ursache | Lösung |
| --- | --- | --- |
| `claude mcp list` zeigt den Eintrag als fehlgeschlagen, `ECONNREFUSED` | Obsidian läuft nicht oder dieser Vault ist nicht offen | Obsidian mit diesem Vault öffnen, dann Claude Code neu starten |
| `401` bei jedem Aufruf | Token ersetzt oder gelöscht | `claude mcp remove <name> -s user`, dann A8 Schritt 1 bis 4 wiederholen |
| `404 route not found` | Vault nicht offen oder Route geändert | Vault öffnen, Befehl aus "Access control" neu kopieren wie bei `401` |
| `409` | gleicher Token in zwei offenen Vaults, meist eine Kopie | in der Kopie "Make this copy independent", dann A8 neu |
| MCP-Tools fehlen in der Session | Session vor der Registrierung gestartet | Claude Code neu starten |
| "Broker connection: Refused" in den Plugin-Einstellungen (macOS) | Schreibrechte für andere auf dem Plugin-Ordner | `chmod go-w .obsidian/plugins .obsidian/plugins/mcp-tools-istefox .obsidian/plugins/mcp-tools-istefox/data.json` |
| Plugins nach dem Öffnen inaktiv | eingeschränkter Modus | Einstellungen, Community-Plugins, eingeschränkten Modus ausschalten |
| `.base` zeigt keine Tabelle | Obsidian älter als 1.9 | Obsidian aktualisieren |
| `tasks`-Blöcke erscheinen als Code | Tasks-Plugin inaktiv | Plugin aktivieren |
| Obsidian Git meldet "push failed" oder Anmeldefehler | keine Git-Anmeldung hinterlegt | `gh auth setup-git`, unter Windows Git Credential Manager |
| Obsidian Git meldet Konflikte in `.obsidian/*.json` | Geräteabhängiges ist doch versioniert | Konflikt lösen, Datei in `.gitignore` aufnehmen, mit `git rm --cached` aus dem Index nehmen |
| `vault-check.sh` meldet `FM_*` | Frontmatter verletzt das Schema | nach `Claude/wartung.md` abarbeiten |

Die vollständige Fehlerliste des MCP-Plugins steht in dessen README, Abschnitt "Troubleshooting". Das Plugin schreibt außerdem ein Log nach `.obsidian/plugins/mcp-tools-istefox/diagnostic.log`.

## Anhang: Ohne Ausbildung

Nur, wenn der Nutzer nicht in Ausbildung ist. Vor A4 erledigen, dann verlangt `personalisieren.sh` die Ausbildungswerte nicht mehr.

Löschen:

- `20_Areas/Ausbildung/` komplett
- `Claude/berichtsheft.md`, `Claude/scripts/build_berichtsheft.py`, `Claude/scripts/Muster_Ausbildungsnachweis_woechentlich_v1.docx`
- `Templates/Berichtsheft-Woche.md`, `Templates/Lernthema.md`
- `Attachments/Berichtsheft/`

Anpassen, jeweils die Stellen zu Berichtsheft, Lernstand und Ausbildung entfernen:

- `CLAUDE.md`: Kopfzeile ohne "Azubi ... seit ...", Ordnerzeile `20_Areas/Ausbildung/`, Ausnahme für Berichtsheft-Dateinamen, `Berichtsheft Notizen.md` unter Arbeitsweise, Detailzeile `Claude/berichtsheft.md`, Satz zu Tagesereignissen unter Memory, letzte Zeile unter Schreibstil
- `Start.md`, `_index.md`, `00_Inbox/Inbox.md`, `20_Areas/_index.md`, `Claude/_index.md`, `Templates/_index.md`
- `Claude/schema.md`: Typen `berichtsheft`, `berichtsheft-laufend`, `lernthema` samt Fachfeldern, Tags `ausbildung`, `berichtsheft`, `berufsschule`, `pruefung`
- `Claude/inbox-regeln.md`: Zeilen 6, 7 und 13
- `Claude/setup.md`: Zuruf "Das war heute im Betrieb"
- `30_Resources/vault-status.md`: Abschnitt Berichtsheft und die drei Typen in der Werteliste
- `Claude/scripts/vault-check.sh`: die drei Typen in `TYPES`
- `.obsidian/plugins/obsidian-icon-folder/data.json`: Eintrag `20_Areas/Ausbildung`

Danach `bash Claude/scripts/vault-check.sh` laufen lassen. Erwartet: `fehler=0`.

## Anhang: Platzhalter

| Platzhalter | Steht in |
| --- | --- |
| `{{VAULT_NAME}}` | `CLAUDE.md`, `_index.md`, `Claude/setup.md` |
| `{{NAME}}` | `CLAUDE.md`, `_index.md`, `Claude/_index.md`, `Claude/schema.md`, `Claude/inbox-regeln.md`, `Claude/wartung.md`, `Claude/setup.md`, `Claude/berichtsheft.md` |
| `{{VOLLER_NAME}}` | `Berichtsheft laufend.md`, `Claude/scripts/build_berichtsheft.py` |
| `{{BERUF}}`, `{{BETRIEB}}`, `{{BEGINN}}`, `{{AUSBILDUNGSJAHR}}` | `CLAUDE.md`, Area-Notiz Ausbildung, `Berichtsheft laufend.md` |
| `{{BETRIEB_KURZ}}` | Dateiname und Inhalt der Area-Notiz Ausbildung, alle Links darauf |
| `{{ORT}}` | `Claude/scripts/build_berichtsheft.py` |
| `{{HEUTE}}` | `created` und `updated` aller Strukturnotizen |
| `{{NAECHSTER_FREITAG}}`, `{{MONATSENDE_FREITAG}}` | Fälligkeiten in `Berichtsheft Routine.md` |

`{{date}}` in den Einstellungen von Obsidian Git ist kein Platzhalter des Skeletts und bleibt stehen.

## Related

- [[CLAUDE|CLAUDE.md]]
- [[Claude/setup|Setup]]
- [[Claude/_index|Claude]]
