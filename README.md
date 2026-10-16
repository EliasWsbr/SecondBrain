# Second-Brain-Skelett

Ein leerer Obsidian-Vault, den Claude für dich pflegt. Du erzählst, Claude legt ab: Wissen, Projekte, Geräte, Menschen und auf Wunsch dein Berichtsheft. Obsidian ist die Oberfläche, Git das Backup.

## Für wen

- Für alle, die Notizen nicht mehr von Hand sortieren wollen.
- Besonders für Azubis: Das Berichtsheft-Modul sammelt Stichworte unter der Woche. Daraus entsteht der wöchentliche Ausbildungsnachweis als PDF.
- Ohne Ausbildung sagst du das bei der Einrichtung. Claude entfernt das Modul dann.

## Was du brauchst

| Was | Wofür | Woher |
| --- | --- | --- |
| Obsidian ab 1.9 | Oberfläche für deine Notizen | [obsidian.md/download](https://obsidian.md/download) |
| Git | Versionierung und Backup | [git-scm.com/downloads](https://git-scm.com/downloads), auf dem Mac reicht `xcode-select --install` |
| Claude Code | richtet den Vault ein und pflegt ihn | [claude.com/claude-code](https://claude.com/claude-code), braucht ein kostenpflichtiges Claude-Abo oder API-Zugang |
| GitHub-Account | optional, für Backup und Sync zwischen Geräten | [github.com](https://github.com) |

Läuft auf macOS und Windows (Claude Code in Git Bash). Linux sollte funktionieren, ist aber nicht getestet.

## Installation

1. **Skelett holen.** Eine der drei Varianten:
   - Oben auf GitHub **Use this template**, dann **Create a new repository**. Stell das neue Repo auf **Private**, weil dein Vault persönliche Daten enthält. Danach dein Repo klonen.
   - Oder klonen: `git clone https://github.com/EliasWsbr/SecondBrain.git MaxBrain`
   - Oder ohne Git-Kenntnisse: **Code**, **Download ZIP**, entpacken.
2. **Ordner benennen**, so wie dein Vault heißen soll, zum Beispiel `MaxBrain`.
3. **Obsidian noch nicht öffnen.** Claude sagt dir später, wann.
4. **Terminal im Ordner öffnen.**
   - macOS: Terminal starten, `cd ` tippen, den Ordner ins Fenster ziehen, Enter.
   - Windows: Rechtsklick auf den Ordner, **Open Git Bash here**. Unter Windows 11 steht das unter **Weitere Optionen anzeigen**.
5. `claude` starten und schreiben: **Richte den Vault ein.**

Claude stellt dir dann ein paar Fragen in einer Nachricht. Danach erledigt Claude alles selbst und sagt dir, wann du in Obsidian klicken musst. Selbst tippst du nur einen Befehl, damit dein Zugangsschlüssel nicht im Chat landet.

Dauer: etwa 15 bis 20 Minuten. Diese Datei löscht Claude am Ende der Einrichtung.

## Was danach da ist

- Ordner nach PARA: Inbox, Projects, Areas, Resources, Archive
- Regeln für Claude in `CLAUDE.md` und `Claude/`
- Vorlagen für jeden Notiztyp, Dashboards, ein Prüfskript
- Berichtsheft-Modul mit wöchentlicher Routine und PDF-Erzeugung
- Obsidian Git mit Auto-Backup alle 10 Minuten
- MCP-Verbindung, damit Claude direkt in deinen Vault schreibt

## Datenschutz

- Der Vault liegt auf deinem Rechner und, wenn du willst, in deinem eigenen privaten Repo.
- Die MCP-Verbindung läuft nur lokal über `127.0.0.1`.
- Zugangsschlüssel und Geräteeinstellungen stehen in `.gitignore`. Sie landen deshalb nie im Repo.
- Was Claude liest oder schreibt, läuft über dein Claude-Konto, wie jede andere Unterhaltung.

## Später

| Du willst | Dann |
| --- | --- |
| auf einem zweiten Rechner arbeiten | Vault klonen, `claude` starten, schreiben: **Richte den Vault auf diesem Gerät ein** |
| eine Verbindung reparieren | `claude` im Vault starten, Problem beschreiben. Claude nutzt `Claude/installation.md`, Teil C |
| Regeln ändern | `CLAUDE.md` und die Dateien in `Claude/` anpassen, oder Claude darum bitten |

## Lizenz

Das Skelett steht unter der MIT-Lizenz, siehe `LICENSE`. Die mitgelieferten Plugins und das Theme haben eigene Lizenzen, siehe `.obsidian/THIRD_PARTY_NOTICES.txt`. Recent Files steht unter GPL-3.0, alle anderen unter MIT.
