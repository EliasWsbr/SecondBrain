---
type: index
status: aktiv
created: {{HEUTE}}
updated: {{HEUTE}}
tags: [claude, meta]
---

# Setup

Für {{NAME}}, nicht für das Modell. Nur lesen, wenn es um MCP, Claude Desktop, Claude Code oder Sync geht.
Wie der Vault auf einem Gerät eingerichtet wird, steht in [[Claude/installation|installation.md]].

## Wie die Teile zusammenspielen

| Teil | Aufgabe |
| --- | --- |
| Obsidian | Oberfläche. Die Notizen sind reine Markdown-Dateien im Vault-Ordner. |
| Plugin MCP Connector | MCP-Server in Obsidian, nur auf `127.0.0.1`. Darüber liest und schreibt Claude im Vault. |
| Claude Code | lädt `CLAUDE.md` automatisch, wenn du die Session im Vault-Ordner startest. Greift zusätzlich per MCP zu. |
| Claude Desktop | liest `CLAUDE.md` nur über die Projektanweisung, siehe unten. |
| Plugin Git | committet alle 10 Minuten und schiebt nach GitHub. Holt beim Start den Stand der anderen Geräte. |
| GitHub | privates Repo, Backup und Sync zwischen deinen Geräten. |

## Claude Desktop

Claude Desktop liest `CLAUDE.md` nicht von allein. Lege ein Projekt `{{VAULT_NAME}}` an, aktiviere die Obsidian-Erweiterung und hinterlege als Projektanweisung genau diesen Text:

```text
Du hast über den Obsidian-MCP-Connector Zugriff auf meinen Vault "{{VAULT_NAME}}".
Lies zu Beginn jeder Unterhaltung, die den Vault betrifft, die Datei CLAUDE.md im Vault-Root.
Sie ist die einzige Regelquelle. Halte dich daran, auch beim Schreibstil.
```

Mehr gehört nicht hinein. Jede zusätzliche Regel in der Projektanweisung ist eine zweite Wahrheit neben `CLAUDE.md` und läuft irgendwann auseinander.

## Claude Code

Lädt `CLAUDE.md` aus dem Vault-Root automatisch. Session im Vault-Verzeichnis starten. Der MCP-Server ist mit `--scope user` registriert und steht deshalb auch in Sessions außerhalb des Vaults bereit.

## Grenzen

- Die Projektanweisung greift nur in diesem Projekt, nicht in normalen Unterhaltungen.
- Obsidian muss laufen, sonst ist der MCP-Endpoint tot und Claude kann nichts schreiben.
- Das Plugin `mcp-tools-istefox` ist per `.gitignore` von der Versionierung ausgenommen, weil es auf iOS nicht läuft. Auf dem iPhone gibt es keinen MCP-Zugriff.
- `.obsidian/plugins/*/data.json` enthält den MCP-Token und ist bewusst nicht versioniert. Auf jedem Gerät entsteht ein eigener Token.
- Dauerinstruktionen wirken zuverlässig, aber nicht mit mechanischer Garantie. Was dir wichtig ist, sag zusätzlich explizit.

## Zurufe, die zuverlässig greifen

| Was du sagst | Was passiert |
| --- | --- |
| "Speicher das im Vault" | Claude wählt Ordner und Vorlage nach `CLAUDE.md` |
| "Merk dir das über mich" | landet in `Claude/Memory/` |
| "Das war heute im Betrieb: ..." | wird an die laufende Berichtsheft-Woche angehängt |
| "Leg das als gelöstes Problem ab" | `30_Resources/` nach der Solution-Vorlage |
| "Räum die Inbox auf" | Einsortieren nach `Claude/inbox-regeln.md`, danach `vault-check.sh` |
| "Was weißt du über mein ...?" | Claude liest die Area und die verlinkten Notizen |

## Related

- [[_index|Vault-Einstieg]]
- [[Claude/installation|Installation]]
- [[Claude/berichtsheft|Berichtsheft-Regeln]]
