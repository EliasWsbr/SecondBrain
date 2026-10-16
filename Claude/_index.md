---
type: index
status: aktiv
created: {{HEUTE}}
updated: {{HEUTE}}
tags: [claude, meta]
---

# Claude

Regeln, Gedaechtnis und Werkzeuge fuer die KI-Pflege des Vaults.
Die Regelquelle ist [[CLAUDE|CLAUDE.md]] im Root. Hier liegen nur die Details, die dort verlinkt sind.
Einzeln laden, nie alles auf einmal.

## Regeln

- [[Claude/schema|schema.md]] Frontmatter, erlaubte Werte fuer type und status, Tags
- [[Claude/inbox-regeln|inbox-regeln.md]] Entscheidungstabelle fuer den Eingang
- [[Claude/wartung|wartung.md]] wann geprueft wird, was ohne Rueckfrage korrigiert werden darf
- [[Claude/berichtsheft|berichtsheft.md]] Register und Ablauf fuers Berichtsheft
- [[Claude/setup|setup.md]] MCP, Claude Desktop, Sync
- [[Claude/installation|installation.md]] Einrichtung auf einem neuen Geraet, Reparatur von Plugins und MCP

## Gedaechtnis

Dauerhafte Fakten ueber {{NAME}}, je Thema eine Datei in `Claude/Memory/`. Einzeln laden.
Die Liste fuehrt [[Claude/Claude-Speicher.base|Claude-Speicher]] dynamisch, nicht von Hand nachtragen.

## Sessions

- [[Claude/Sessions/Sessions|Sessions]] Ablage fuer Zusammenfassungen substantieller Unterhaltungen
- [[Claude/Claude-Speicher.base|Claude-Speicher]] listet Memory und Sessions dynamisch

## Werkzeuge

- `scripts/vault-check.sh` prueft den Vault ohne Obsidian
- `scripts/build_berichtsheft.py` erzeugt die Berichtsheft-PDFs

## Related

- [[_index|Vault-Einstieg]]
