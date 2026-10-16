---
type: index
status: aktiv
created: {{HEUTE}}
updated: {{HEUTE}}
tags: [ausbildung, berichtsheft]
area: "[[Ausbildung {{BETRIEB_KURZ}}]]"
---

# Berichtsheft Routine

> [!info] Wie das hier funktioniert
> Die beiden Aufgaben unten sind wiederkehrend (Tasks-Plugin). Hakst du eine ab, legt das Plugin die nächste Fälligkeit automatisch an. Die Zeile bleibt also stehen und wandert nur weiter. Nicht löschen.

## Wiederkehrend

- [ ] Berichtsheft-Woche abschließen: [[Berichtsheft Notizen]] in die Wochennotiz übertragen, Stunden prüfen, Status von `entwurf` auf `fertig` setzen, Notizen-Liste leeren #berichtsheft 🔁 every week on Friday 📅 {{NAECHSTER_FREITAG}}
- [ ] Berichtsheft-Monat abschließen: PDFs der Wochen mit `Claude/scripts/build_berichtsheft.py` erzeugen, vom Ausbilder gegenzeichnen lassen, unterschriebene Fassung in `Attachments/Berichtsheft/` ablegen und in der Wochennotiz verlinken #berichtsheft 🔁 every month on the last Friday 📅 {{MONATSENDE_FREITAG}}

## Offen

```tasks
not done
tag includes #berichtsheft
sort by due
short mode
```

## Erledigt (letzte 10)

```tasks
done
tag includes #berichtsheft
sort by done reverse
limit 10
short mode
```

## Related

- [[Berichtsheft Notizen]]
- [[Berichtsheft laufend]]
- [[20_Areas/Ausbildung/_index|Ausbildung]]
