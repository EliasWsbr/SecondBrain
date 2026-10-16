---
type: index
status: aktiv
created: {{HEUTE}}
updated: {{HEUTE}}
tags: [meta]
---

# Vault-Status

Zahlen und Luecken im Vault, live aus dem Frontmatter.
Alle Abfragen sind reines Dataview DQL, kein DataviewJS. Sie laufen also auch dann, wenn JavaScript-Abfragen abgeschaltet sind, und auf dem iPhone.
Geprueft wird gegen die geschlossenen Listen aus [[Claude/schema|Claude/schema.md]]. Bleibt eine Tabelle leer, ist dort nichts zu tun.

## Gesamtzahl

```dataview
TABLE WITHOUT ID length(rows) AS "Notizen gesamt"
WHERE file.folder != "Templates"
GROUP BY "alle"
```

## Verteilung nach type

```dataview
TABLE WITHOUT ID key AS "type", length(rows) AS "Anzahl"
WHERE file.folder != "Templates"
GROUP BY type
SORT length(rows) DESC
```

## Verteilung nach status

```dataview
TABLE WITHOUT ID key AS "status", length(rows) AS "Anzahl"
WHERE file.folder != "Templates"
GROUP BY status
SORT length(rows) DESC
```

## Frontmatter unvollstaendig

Pflicht sind `type`, `status`, `created`, `updated` und mindestens ein Tag.

```dataview
TABLE WITHOUT ID file.link AS "Notiz", type, status, created, updated
WHERE file.folder != "Templates"
  AND (!type OR !status OR !created OR !updated OR !file.tags OR length(file.tags) = 0)
SORT file.path ASC
```

## Werte ausserhalb der Liste

```dataview
TABLE WITHOUT ID file.link AS "Notiz", type, status
WHERE file.folder != "Templates"
  AND ( (type AND !contains(list("index", "project", "area", "note", "solution", "device", "person", "source", "berichtsheft", "berichtsheft-laufend", "lernthema", "claude-memory", "claude-session"), type))
     OR (status AND !contains(list("aktiv", "ruht", "entwurf", "fertig", "archiviert", "unsortiert"), status)) )
SORT file.path ASC
```

## Inbox-Bestand

Standinventar (`_index`, `Inbox`) bleibt aussen vor. Alles andere gehoert einsortiert.

```dataview
TABLE WITHOUT ID file.link AS "Notiz", status, created, (date(today) - date(created)).days AS "Tage"
FROM "00_Inbox"
WHERE file.name != "_index" AND file.name != "Inbox"
SORT created ASC
```

## Offene Projekte

```dataview
TABLE WITHOUT ID file.link AS "Projekt", status, area, outcome, due
FROM "10_Projects"
WHERE type = "project" AND status != "fertig" AND status != "archiviert"
SORT status ASC, file.name ASC
```

## Unfertiges Wissen

```dataview
TABLE WITHOUT ID file.link AS "Notiz", type, status, updated
FROM "30_Resources"
WHERE (type = "note" OR type = "solution") AND status = "entwurf"
SORT updated ASC
```

## Berichtsheft, noch nicht abgegeben

```dataview
TABLE WITHOUT ID file.link AS "Woche", woche, von, bis, abteilung, status
FROM "20_Areas/Ausbildung"
WHERE type = "berichtsheft" AND status != "fertig"
SORT woche ASC
```

## Zuletzt geaendert

```dataview
TABLE WITHOUT ID file.link AS "Notiz", type, status, updated
WHERE file.folder != "Templates"
SORT updated DESC
LIMIT 12
```

## Verwaist und kaputt

Dataview sieht keine kaputten Links und keine verwaisten Notizen. Das prueft `Claude/scripts/vault-check.sh`, siehe [[Claude/wartung|Wartung]].

## Related

- [[30_Resources/_index|Resources]]
- [[Claude/schema|Schema]]
- [[Claude/wartung|Wartung]]
- [[_index|Vault-Einstieg]]
