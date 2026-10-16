---
type: index
status: aktiv
created: {{HEUTE}}
updated: {{HEUTE}}
tags: [claude, meta]
---

# Wartung

`Claude/scripts/vault-check.sh` prueft den Vault ohne Obsidian. Diese Datei sagt, wann das laeuft und wie die Befunde abgearbeitet werden.

## Aufruf

```bash
bash Claude/scripts/vault-check.sh
```

Laeuft in Git Bash auf Windows, in jeder Bash auf macOS und Linux. Braucht nur `bash`, `awk`, `grep`, `sed`, `find` und `date`. Kein Python, kein Node, kein Obsidian.

Exit-Code: `0` keine Fehler, `1` mindestens ein Fehler, `2` Aufrufproblem.

## Wann ausfuehren

| Anlass | Pflicht |
| --- | --- |
| nach jedem Umbenennen, Verschieben oder Loeschen | ja |
| nachdem eine KI die Inbox geleert hat | ja |
| nach einem Umbau mit mehr als drei Dateien | ja |
| in der Wochenroutine, zusammen mit dem Inbox-Leeren | ja |
| vor einem Commit mit nur einer geaenderten Notiz | nein |

## Ausgabeformat

Eine Zeile je Befund, tabgetrennt, direkt maschinell abarbeitbar:

```
SCHWERE  CODE  PFAD  DETAIL
```

Am Ende eine Zeile `ZUSAMMENFASSUNG` mit Zahlen zu Notizen, Links, Fehlern, Warnungen und Hinweisen.

## Befunde und was damit passiert

| Code | Bedeutung | Schwere | KI darf ohne Rueckfrage |
| --- | --- | --- | --- |
| `LINK_BROKEN` | Wikilink zeigt auf nichts | fehler | reparieren, wenn das Ziel eindeutig ist: genau eine Datei mit passendem Namen. Sonst melden. |
| `FM_MISSING` | Pflichtfeld fehlt | fehler | nachtragen, wenn der Wert aus Ordner, Dateiname oder Git-History ableitbar ist. Sonst `status: unsortiert` setzen und melden. |
| `FM_BADVALUE` | Wert nicht in der Liste oder Datum nicht ISO | fehler | auf den passenden Wert aus `Claude/schema.md` mappen, wenn die Zuordnung eindeutig ist. Datumsformat immer korrigieren. Sonst melden. |
| `FM_NOTAGS` | `tags` ist leer | fehler | einen Tag aus der Liste in `Claude/schema.md` setzen, wenn das Thema eindeutig ist. Sonst melden. |
| `ORPHAN` | keine andere Notiz verlinkt darauf | warnung | nichts. Der Link muss inhaltlich passen, das entscheidet {{NAME}}. Vorschlag machen. |
| `INBOX_STALE` | liegt laenger als sieben Tage in `00_Inbox` | warnung | nach `Claude/inbox-regeln.md` einsortieren, wenn eine Zeile eindeutig greift. Sonst melden. |
| `DUP_TITLE` | Titel aehnelt einem anderen zu mehr als 70 Prozent | warnung | nichts. Zusammenlegen ist Inhaltsarbeit, nur auf Zuruf. |
| `ATTACH_UNUSED` | Anhang wird von keiner Notiz referenziert | hinweis | nichts. Nie loeschen. Melden, wenn er dauerhaft ungenutzt bleibt. |

## Feste Grenzen

- Nie loeschen. Was raus soll, geht nach `40_Archive/` und bekommt `status: archiviert`.
- Nie Notiztext aendern. Das Skript und seine Abarbeitung fassen Frontmatter, Links und Dateinamen an, sonst nichts.
- Nie raten. Jeder Fall, der nicht eindeutig ist, wird gemeldet statt aufgeloest.
- Nach der Abarbeitung das Skript erneut laufen lassen und das Ergebnis nennen.

## Bekannte, gewollte Befunde

| Befund | Warum er stehen bleibt |
| --- | --- |
| `ATTACH_UNUSED` fuer Berichtsheft-PDFs noch offener Wochen | Das PDF entsteht vor der Verlinkung in der Wochennotiz |

Wikilinks in Inline-Code und Codebloecken prueft das Skript nicht. Syntaxbeispiele wie in `CLAUDE.md` erzeugen deshalb keinen Befund.

## Ausnahmen im Skript

- `Templates/` wird bei der Frontmatter-Pruefung uebersprungen, weil dort `created`, `updated` und `tags` bewusst leer sind.
- `40_Archive/` wird bei `ORPHAN` uebersprungen, und Links aus dem Archiv zaehlen nicht als eingehend. Sonst haelt eine ersetzte Fassung eine Notiz kuenstlich am Leben.
- Jede `_index.md` sowie `CLAUDE.md` und `Start.md` brauchen keinen eingehenden Link.
- `00_Inbox/_index.md` und `00_Inbox/Inbox.md` altern nicht.
- Dateien, deren Name mit einem Punkt beginnt (`.gitkeep`, `.DS_Store`), zaehlen nicht als Anhang.
- `tags` darf als Inline-Liste `[a, b]` oder als Blockliste mit `- a` stehen. Beide Formen gelten als gefuellt.

## Related

- [[Claude/schema|Schema]]
- [[Claude/inbox-regeln|Inbox-Regeln]]
- [[Claude/_index|Claude]]
