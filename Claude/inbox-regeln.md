---
type: index
status: aktiv
created: {{HEUTE}}
updated: {{HEUTE}}
tags: [claude, meta]
---

# Inbox-Regeln

`00_Inbox/` ist der einzige Eingang fuer Neues. Alles, was noch keinen Platz hat, landet dort. Diese Datei sagt, wohin es danach geht.

## Wie die Tabelle zu lesen ist

- Gehe die Zeilen von oben nach unten durch. Die **erste** Zeile, deren Bedingung zutrifft, gewinnt. Danach hoerst du auf zu pruefen.
- Trifft keine Zeile zu, greift Zeile 14. Dann bleibt die Notiz liegen und du meldest sie.
- Setze beim Verschieben immer alle fuenf Pflichtfelder aus `Claude/schema.md`. Fehlt ein Fachfeld und ist es nicht aus dem Text ableitbar, lass es leer und melde es.
- Rate nie. Passen zwei Zeilen gleich gut, gilt die obere.

## Entscheidungstabelle

| # | Bedingung, pruefbar am Text oder Frontmatter | Ziel | `type` | `status` | Fachfelder setzen |
| --- | --- | --- | --- | --- | --- |
| 1 | Dateiname ist `_index.md`, oder die Notiz enthaelt nur Links und keine eigene Aussage | bleibt liegen, wo sie ist | `index` | `aktiv` | keine |
| 2 | Es gibt bereits eine Notiz zum selben Gegenstand, und diese hier ist die aeltere Fassung | `40_Archive/` | unveraendert | `archiviert` | keine |
| 3 | Der Text nennt Hostname, IP-Adresse, Betriebssystem oder eine Hardware-Modellbezeichnung | `30_Resources/Devices/` | `device` | `aktiv` | `hostname`, `ip`, `os`, `location` |
| 4 | Der Titel ist der Name eines Menschen, und der Text beschreibt dessen Rolle | `30_Resources/People/` | `person` | `aktiv` | `relation`, `org` |
| 5 | Der Text nennt einen dauerhaft gueltigen Fakt ueber {{NAME}}: Vorliebe, Entscheidung, Rahmenbedingung | `Claude/Memory/` | `claude-memory` | `aktiv` | `kategorie`, `gueltig-ab` |
| 6 | Der Titel hat das Format `YYYY-Www` | `20_Areas/Ausbildung/` | `berichtsheft` | `entwurf` | `woche`, `von`, `bis`, `ausbildungsjahr`, `abteilung` |
| 7 | Der Text nennt eine Pruefung oder ein Lernfeld als Gegenstand | `20_Areas/Ausbildung/` | `lernthema` | `aktiv` | `pruefung`, `lernfeld`, `stand`, `wichtigkeit` |
| 8 | Der Text nennt ein Ergebnis und einen Endpunkt: Abgabe, Termin, "fertig, wenn" | `10_Projects/` | `project` | `aktiv`, ohne naechste Aktion `ruht` | `area`, `outcome`, `due` |
| 9 | Der Text beschreibt eine Verantwortung, die nie fertig wird, mit wiederkehrendem Blick darauf | `20_Areas/` | `area` | `aktiv` | `review` |
| 10 | Der Text enthaelt Problem, Ursache und Loesung zu einem konkreten System | `30_Resources/` | `solution` | nachgeprueft `fertig`, sonst `entwurf` | `system` |
| 11 | Der Text gibt den Inhalt eines Buchs, Artikels, Videos oder Kurses wieder | `30_Resources/` | `source` | gelesen `fertig`, sonst `entwurf` | `medium`, `author`, `url` |
| 12 | Der Text erklaert einen Sachverhalt, der auch in einem Jahr noch gilt | `30_Resources/` | `note` | vollstaendig `fertig`, sonst `entwurf` | `source` falls bekannt |
| 13 | Der Text ist eine Notiz zum Ausbildungsalltag, die in keine Zeile 6 bis 12 passt | `20_Areas/Ausbildung/` | `note` | `entwurf` | keine |
| 14 | keine Zeile davor trifft zu | bleibt in `00_Inbox/` | so gut wie ableitbar | `unsortiert` | keine |

## Beim Verschieben immer

- `created` auf das Datum setzen, an dem die Notiz in die Inbox kam. `updated` auf heute.
- Mindestens einen Tag aus der Liste in `Claude/schema.md` setzen.
- Mindestens einen ausgehenden Wikilink auf eine Area, eine MOC oder das passende `_index.md` setzen. Ohne den findet die Notiz niemand wieder.
- Nach dem Verschieben `Claude/scripts/vault-check.sh` laufen lassen.

## Standinventar

Diese Dateien liegen dauerhaft in `00_Inbox/` und werden nie einsortiert:

| Datei | Wofuer |
| --- | --- |
| `_index.md` | Wegweiser des Ordners |
| `Inbox.md` | Schnellablage fuer Stichworte, die noch keine eigene Notiz verdienen |

Alles andere in `00_Inbox/` ist Eingang und gehoert in die Tabelle oben.

## Was gemeldet wird

Nach jedem Leeren bekommst du eine Liste mit:

- Notizen, die auf `status: unsortiert` stehen, mit der Zeile, an der die Entscheidung gescheitert ist.
- Fachfelder, die leer bleiben mussten.
- Faelle, in denen zwei Zeilen gleich gut passten.

## Related

- [[Claude/schema|Schema]]
- [[Claude/wartung|Wartung]]
- [[00_Inbox/_index|Inbox]]
