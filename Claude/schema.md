---
type: index
status: aktiv
created: {{HEUTE}}
updated: {{HEUTE}}
tags: [claude, meta]
---

# Schema

Verbindliches Frontmatter-Schema fuer jede Notiz im Vault. Diese Datei ist die einzige Quelle dafuer. Widerspricht ihr eine andere Notiz, gilt diese Datei.

## Pflichtfelder

Jede `.md`-Datei hat genau diese fuenf Felder, in genau dieser Reihenfolge, ganz oben im Frontmatter:

| Feld | Typ | Regel |
| --- | --- | --- |
| `type` | Wert aus der Liste unten | steuert, in welcher `.base` die Notiz auftaucht |
| `status` | Wert aus der Liste unten | steuert Dashboards und Filter |
| `created` | `YYYY-MM-DD` | wird nie geaendert |
| `updated` | `YYYY-MM-DD` | bei jeder inhaltlichen Aenderung auf heute setzen |
| `tags` | Liste, mindestens ein Eintrag | Schreibweise `tags: [a, b]`. Die Blockform, die Obsidian beim Bearbeiten schreibt, gilt auch |

Danach folgen die Fachfelder des jeweiligen `type`, in beliebiger Reihenfolge.

Einzige Ausnahme: `Templates/`. Dort sind `created`, `updated` und `tags` bewusst leer, weil die Werte erst beim Anlegen einer Notiz entstehen. `vault-check.sh` ueberspringt den Ordner.

## Erlaubte Werte fuer `type`

Geschlossene Liste. Ein neuer Wert nur nach Ruecksprache.

| Wert | Wofuer | Ordner | Vorlage |
| --- | --- | --- | --- |
| `index` | Wegweiser ohne eigenen Inhalt: `_index.md`, MOCs, Dashboards, feste Arbeitsseiten | ueberall | keine |
| `project` | Vorhaben mit Ende und Ergebnis | `10_Projects/` | `Project` |
| `area` | Dauerverantwortung ohne Enddatum | `20_Areas/` | `Area` |
| `note` | Dauerwissen | `30_Resources/` | `Knowledge Note` |
| `solution` | geloestes Problem mit Ursache und Nachpruefung | `30_Resources/` | `Solution` |
| `device` | Geraet | `30_Resources/Devices/` | `Device` |
| `person` | Mensch | `30_Resources/People/` | `Person` |
| `source` | Buch, Artikel, Video | `30_Resources/` | `Source` |
| `berichtsheft` | eine Ausbildungswoche | `20_Areas/Ausbildung/` | `Berichtsheft-Woche` |
| `berichtsheft-laufend` | die durchlaufende Fassung, genau eine Datei | `20_Areas/Ausbildung/` | keine |
| `lernthema` | Pruefungsstoff | `20_Areas/Ausbildung/` | `Lernthema` |
| `claude-memory` | dauerhafter Fakt ueber {{NAME}} | `Claude/Memory/` | `Claude-Memory` |
| `claude-session` | Zusammenfassung einer Unterhaltung | `Claude/Sessions/` | `Claude-Session` |

## Erlaubte Werte fuer `status`

Geschlossene Liste, fuer alle Typen dieselbe.

| Wert | Bedeutung | typischer Fall |
| --- | --- | --- |
| `aktiv` | laeuft, gilt, wird benutzt | offenes Projekt, gepflegte Area, gueltiges Memory |
| `ruht` | bewusst zurueckgestellt, keine naechste Aktion | Someday-Projekt, stillgelegtes Geraet |
| `entwurf` | angefangen, nicht fertig | Wissensnotiz mit Luecken, Berichtsheft-Woche vor der Abgabe |
| `fertig` | abgeschlossen, abgegeben oder geprueft | abgegebene Woche, verifizierte Loesung |
| `archiviert` | historisch, liegt in `40_Archive/` | ersetzte Fassung |
| `unsortiert` | nicht sicher ableitbar, liegt in `00_Inbox/` | Eingang, den die Inbox-Regeln nicht abdecken |

Regeln dazu:

- Jede Notiz in `40_Archive/` hat `status: archiviert`. Keine Ausnahme.
- Jede `.base` filtert `note.status != "archiviert"`, damit Archiviertes nicht in den Dashboards auftaucht.
- Raten ist verboten. Ist der Wert nicht sicher ableitbar, setze `unsortiert` und melde die Notiz.

## Fachfelder je `type`

| type | zusaetzliche Pflichtfelder | optional |
| --- | --- | --- |
| `project` | `area` (Wikilink), `outcome` | `due` |
| `area` | `review` (`weekly`, `monthly`, `quarterly`) | |
| `note` | | `source` |
| `solution` | `system` (Wikilink) | |
| `device` | | `hostname`, `ip`, `os`, `location`, `aliases` |
| `person` | `relation` | `org` |
| `source` | `medium` | `author`, `url` |
| `berichtsheft` | `woche` (`YYYY-Www`), `von`, `bis`, `ausbildungsjahr`, `abteilung` | |
| `berichtsheft-laufend` | `name`, `beruf`, `betrieb`, `ausbildungsjahr`, `beginn` | |
| `lernthema` | `pruefung`, `stand` (`offen`, `am-lernen`, `sitzt`), `wichtigkeit` (`hoch`, `mittel`, `niedrig`) | `lernfeld` |
| `claude-memory` | `kategorie` (`profil`, `ausbildung`, `technik`, `business`, `praeferenz`, `admin`), `gueltig-ab` | |
| `claude-session` | `datum`, `thema`, `ergebnis` | |
| `index` | keine | |

## Tags

Mindestens einer je Notiz. Ein Tag ersetzt keinen Link.

Erlaubte Liste, neuer Tag nur nach Ruecksprache:

`admin`, `ausbildung`, `berichtsheft`, `berufsschule`, `claude`, `entwicklung`, `erfahrung`, `finanzen`, `grundlagen`, `hardware`, `homelab`, `infrastruktur`, `meta`, `moc`, `netzwerk`, `person`, `pruefung`, `recht`, `rechenzentrum`, `storage`, `technik`, `virtualisierung`

Die Liste ist ein Startbestand. Taucht ein neues Querschnittsthema auf, nach Ruecksprache den Tag hier eintragen und erst danach verwenden.

## Datumsformat

Immer `YYYY-MM-DD`, ohne Anfuehrungszeichen. Relatives wie "letzte Woche" vor dem Speichern aufloesen. Einzige Abweichung: `woche` im Berichtsheft nutzt `YYYY-Www`, zum Beispiel `2026-W37`.

## Beispiel

```yaml
---
type: note
status: entwurf
created: 2026-09-15
updated: 2026-09-22
tags: [netzwerk, grundlagen]
source: Berufsschule Lernfeld 2
---
```

## Related

- [[Claude/inbox-regeln|Inbox-Regeln]]
- [[Claude/wartung|Wartung]]
- [[CLAUDE|Regelquelle]]
