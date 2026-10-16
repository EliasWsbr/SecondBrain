---
type: index
status: aktiv
created: {{HEUTE}}
updated: {{HEUTE}}
tags: [claude, meta]
---

<!-- INSTALLATION:START -->
> [!warning] Ersteinrichtung offen
> Dieser Vault ist noch ein unausgefülltes Skelett. Die Platzhalter in doppelten geschweiften Klammern sind noch nicht ersetzt.
> Bevor du irgendetwas anderes tust: lies `Claude/installation.md` und arbeite Teil A ab, auch wenn der Nutzer nur "Hallo" schreibt.
> Diesen Block löschst du im letzten Installationsschritt, vorher nicht.
<!-- INSTALLATION:END -->

# {{VAULT_NAME}}

Second Brain von {{NAME}}, Azubi {{BERUF}} bei {{BETRIEB}} seit {{BEGINN}}.
Der Vault wird überwiegend von KI gepflegt, nicht von Hand.
PARA für Handlungsorientiertes, Zettelkasten für Wissen. Ordner sagen, wie dringend etwas ist. Links und Tags sagen, worum es geht.
Diese Datei ist die einzige Regelquelle. Widerspricht ihr eine andere Notiz, gilt diese Datei. Die Details stehen in den Dateien unter `Claude/`, hier steht nur, wo sie liegen.

## Einstieg in eine Session

1. `_index.md` im Root lesen. Das ist der Wegweiser.
2. Von dort in den passenden Bereichsindex `<Ordner>/_index.md`.
3. Erst dann die einzelne Notiz nachladen.

Nie den Vault volltextscannen. Erst `search_vault` oder den Index, dann gezielt öffnen.

## Ordner

Maximal zwei Ebenen tief. Feinsortierung läuft über `type` und Tags, nicht über Unterordner.

| Ordner | Was liegt hier |
| --- | --- |
| `00_Inbox/` | einziger Eingang für Neues, wird nach `Claude/inbox-regeln.md` geleert |
| `10_Projects/` | Vorhaben mit Ende und Ergebnis |
| `20_Areas/` | Dauerverantwortungen ohne Enddatum |
| `20_Areas/Ausbildung/` | Berichtsheft, Berufsschule, Prüfung, Area-Notiz |
| `30_Resources/` | Dauerwissen, gelöste Probleme, MOCs, Vault-Status |
| `30_Resources/Devices/` und `30_Resources/People/` | Geräte, Menschen |
| `40_Archive/` | ersetzte Fassungen, nur auf Nachfrage lesen |
| `Attachments/` | PDFs und andere Anhänge, `Referenz/` bleibt lokal |
| `Claude/` | Regeln, Gedächtnis, Skripte |
| `Templates/` | Vorlagen je Notiztyp |

Im Root liegen nur `_index.md`, `Start.md`, `LICENSE` und diese Datei.

## Schema

Pflichtfelder in jeder Notiz: `type`, `status`, `created`, `updated`, `tags`. Datum immer `YYYY-MM-DD`.
Die geschlossenen Wertelisten für `type` und `status`, die Fachfelder je Typ und die erlaubten Tags stehen vollständig in `Claude/schema.md`. Nicht hier wiederholen, nicht raten, nichts dazuerfinden.
Ist ein Wert nicht sicher ableitbar, `status: unsortiert` setzen und melden.

## Dateinamen

- Heißen wie das Ding, das sie beschreiben. Keine Datumspräfixe, keine IDs.
- Keine Umlaute: ae, oe, ue, ss. Kein `&`, `!`, `?`, `:`, `/`, `*`, keine Emojis. `und` statt `&`. Grund: Git zwischen Windows und macOS, dazu iOS-Sync.
- Ausnahmen: Berichtsheft-Wochen heißen `JJJJ-Www.md`, Sessions `JJJJ-MM-TT Thema.md`, Bereichsindizes `_index.md`.

## Verlinken

- `[[Wikilink]]` für eine konkrete Notiz. Jede neue Notiz braucht mindestens einen ausgehenden Link auf eine Area, eine MOC oder das `_index.md` ihres Ordners, sonst findet sie niemand wieder.
- Tag für ein Querschnittsthema über mehrere Notizen. Ein Tag ersetzt keinen Link.
- MOC in `30_Resources/`, sobald ein Thema mehr als fünf Notizen hat. Eine MOC sammelt keine Inhalte, sie verweist nur.
- Jede Notiz endet mit `## Related` und Wikilinks.
- Link auf eine `.base` mit Pfad und Alias: `[[30_Resources/Knowledge.base|Knowledge]]`.
- In Tabellenzellen muss der Alias-Strich escaped werden. Einfacher: in Indizes Listen statt Tabellen nutzen.
- Nach Umbenennen oder Verschieben `Claude/scripts/vault-check.sh` ausführen.

## Arbeitsweise

Ohne Rückfrage: Notiz anlegen wenn Ordner und type eindeutig sind, bestehende Notiz ergänzen und `updated` hochsetzen, an `00_Inbox/Inbox.md` und `20_Areas/Ausbildung/Berichtsheft Notizen.md` anhängen, fehlende Pflichtfelder nachtragen, eindeutige Befunde aus `vault-check.sh` korrigieren.

Nur nach Rückfrage: löschen, umbenennen, verschieben, bestehenden Text überschreiben oder kürzen, Sammelnotizen splitten, neuen type oder Property-Namen oder Tag einführen, in `40_Archive/` schreiben.

Immer:
- Erst `search_vault`, dann anlegen. Ergänzen schlägt neu anlegen, sonst entstehen fünf Notizen zum selben Thema.
- Passen zwei Ordner gleich gut, fragen statt raten.
- Nach dem Schreiben nennen, welche Datei geändert wurde.
- Ändert sich ein Fakt, die bestehende Notiz aktualisieren. `status: archiviert` nur, wenn der alte Stand historisch zählt.
- Große Dateien gezielt anfassen: `get_vault_file_partial` oder `patch_vault_file` mit Heading-Ziel statt Vollread.
- Nichts löschen. Was raus soll, geht nach `40_Archive/` und bekommt `status: archiviert`.

## Commits

Obsidian-Git committet Inhalt automatisch unter `vault backup: <Zeitstempel>`. Alles andere folgt dieser Konvention, damit in der History sofort sichtbar ist, was von der KI kam.

| Präfix | Wer hat committet | Beispiel |
| --- | --- | --- |
| `ki: ` | eine KI, egal ob Claude Code, Claude Desktop oder MCP | `ki: Frontmatter auf Schema migriert` |
| `vault backup: ` | Obsidian-Git automatisch, nicht von Hand vergeben | `vault backup: 2026-09-22 10:49:16` |
| kein Präfix | {{NAME}} von Hand | `Berichtsheft KW38 nachgetragen` |

Regeln:

- Message deutsch, Präsens, erste Zeile höchstens 72 Zeichen.
- Strukturänderungen bekommen einen eigenen Commit, getrennt von Inhaltsänderungen.
- Vor einem Umbau mit mehr als drei Dateien erst einen Sicherungs-Commit.
- Umbauten laufen auf einem eigenen Branch, nicht auf `main`.
- Während eines KI-Umbaus den Auto-Commit von Obsidian-Git aus lassen, sonst zerschneidet er die Commits.

## Detaildateien, nur bei Bedarf lesen

| Datei | Wann |
| --- | --- |
| `Claude/schema.md` | immer, bevor Frontmatter geschrieben oder geprüft wird |
| `Claude/inbox-regeln.md` | wenn etwas aus `00_Inbox/` einsortiert wird |
| `Claude/wartung.md` | wenn `vault-check.sh` gelaufen ist und Befunde abgearbeitet werden |
| `Claude/berichtsheft.md` | vor jedem Eintrag ins Berichtsheft |
| `Claude/setup.md` | bei Fragen zu MCP, Claude Desktop oder Sync |
| `Claude/installation.md` | Einrichtung auf einem weiteren Gerät, Plugin oder MCP-Verbindung reparieren |
| `Claude/Memory/<Thema>.md` | wenn ein persönlicher Fakt gebraucht wird. Einzeln laden, nie alle |
| `Templates/<Vorlage>.md` | beim Anlegen einer Notiz dieses Typs |
| `_index.md` und `Start.md` | bei Fragen zur Navigation für Menschen |
| `Claude/Claude-Speicher.base` | listet Memory und Sessions dynamisch, nie von Hand nachführen |
| `40_Archive/` | nie lesen, das sind ersetzte Fassungen |

## Memory

Erzählt {{NAME}} etwas dauerhaft Gültiges (Vorliebe, Entscheidung, Rahmenbedingung, Person), erst prüfen ob es dazu eine Datei in `Claude/Memory/` gibt. Wenn ja ergänzen, wenn nein nach `Templates/Claude-Memory.md` neu anlegen.
Eine Datei je Thema. Bewährte Themen: Profil, Ziele, Arbeitsweise, Ausbildung Rahmen, Menschen, Technik Setup, Nebenthemen.
Tagesereignisse gehören nicht ins Memory, sondern ins Berichtsheft.

## Sessions

Eine Session-Notiz nach `Claude/Sessions/` schreiben, wenn alle drei Punkte zutreffen: die Unterhaltung lief über mehrere Schritte, es wurde eine Entscheidung getroffen oder ein Konzept erarbeitet, und das Ergebnis steht nicht schon vollständig in einer Fach-Notiz.
Nicht schreiben bei Einzelfrage, Befehlsnachschlag, reiner Recherche, Smalltalk.
Am Ende einer passenden Session ungefragt anlegen und danach sagen, dass sie existiert. Im Zweifel fragen.

## Schreibstil

Gilt für Vault-Notizen und für Antworten im Chat.

- Deutsch, Du-Form, sachlich und direkt. Auch Notizen an {{NAME}} selbst duzen.
- Keine Gedankenstriche, weder Halbgeviertstrich noch Geviertstrich. Ersatz: Komma, Doppelpunkt, Klammer oder neuer Satz. Bindestriche in zusammengesetzten Wörtern bleiben: Raw-Block-Device-Passthrough, Time-Machine-Backup.
- Sätze unter 15 Wörtern, aktiv formuliert. Zwei Aussagen in einem Satz trennen. Kein Passiv, wenn das Subjekt bekannt ist.
- Prosa nur unter Context, Notes, Warum das zählt, Warum diese Lösung, Warum das relevant ist. Dort höchstens vier Sätze. Alles andere ist Liste oder Tabelle.
- Jede Behauptung bekommt Grund oder Folge: weil, sonst, damit.
- Gegenüberstellung als "X statt Y" oder "X schlägt Y".
- Offene Punkte immer als `- [ ]`, nie als Fließtext.
- Unsicheres markieren statt glätten: `> [!warning] Zu verifizieren` oder eine Zeile unter `## Lücken`.
- Strukturüberschriften englisch (Current Focus, Open Loops, Next Actions, Related), Inhaltsüberschriften deutsch (Problem, Ursache, Lösung, Nachprüfen, Lücken, Fakt).
- Property-Namen englisch, Statuswerte deutsch. Ausnahme Behördliches: woche, abteilung, stand, pruefung, wichtigkeit, kategorie.
- Fachbegriffe bleiben englisch, wenn sie im IT-Alltag englisch sind: Switch, Routing, Cluster, Passthrough, Storage.
- Keine Emojis, außer Tasks-Syntax für wiederkehrende Aufgaben. Keine Meta-Einleitungen, keine Floskeln, keine Marketing-Sprache, keine Motivationssätze.
- Beispiele nur, wenn die Regel sonst mehrdeutig bleibt. Dann eines, nicht drei.
- Berichtsheft hat ein eigenes Register, siehe `Claude/berichtsheft.md`.
