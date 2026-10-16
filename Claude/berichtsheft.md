---
type: index
status: aktiv
created: {{HEUTE}}
updated: {{HEUTE}}
tags: [claude, meta, ausbildung]
---

# Berichtsheft: Regeln für Einträge

Vor jedem Berichtsheft-Eintrag lesen. `Berichtsheft laufend.md` wächst jede Woche. Ab etwa zehn Wochen nicht mehr komplett lesen, sondern gezielt, siehe unten.

## Wohin was gehört

| Was | Wohin |
| --- | --- |
| Stichpunkt unter der Woche, ohne Form | `20_Areas/Ausbildung/Berichtsheft Notizen.md`, an den passenden Wochentag anhängen |
| Ausformulierter Tag | `20_Areas/Ausbildung/Berichtsheft laufend.md`, unter die Überschrift `### <Wochentag>, TT.MM.JJJJ` der laufenden KW |
| Offiziell eingereichte Woche | eigene Notiz `JJJJ-Www.md`, type `berichtsheft`, Wortlaut 1:1 aus dem abgegebenen PDF |

## Fremde Rohnotizen

Stichworte von Mitauszubildenden dürfen nur als unbestätigter Entwurf einfließen, nie als bestätigte Fassung. Grund: Gruppen arbeiten oft an verschiedenen Themen, obwohl sie gleich eingeteilt scheinen.

- Jeden übernommenen Tag oder Block mit `> [!warning] Unbestätigt, aus fremden Rohnotizen` kennzeichnen.
- Einzelne Zeilen in einem sonst eigenen Tag mit `(unbestätigt, fremde Notiz)` markieren.
- Einen offenen Punkt setzen, damit {{NAME}} vor der Abgabe gegencheckt.
- Passt der fremde Verlauf nachweislich nicht zum eigenen, nicht übernehmen und in der Inbox unter `## Liegengeblieben` mit Begründung parken.

## Wenn eine Woche eingereicht ist

1. Wochennotiz `JJJJ-Www.md` nach `Templates/Berichtsheft-Woche.md` anlegen, type `berichtsheft`, Wortlaut 1:1 aus dem abgegebenen Dokument.
2. In `Berichtsheft laufend.md` in der Zeile `**Offiziell eingereicht:**` der betroffenen KW darauf verlinken.
3. Das PDF unter `Attachments/Berichtsheft/` ablegen und in derselben Zeile verlinken.
4. Status der Wochennotiz auf `fertig` setzen.

## Schreiben ohne Vollread

1. `get_note_outline` auf `Berichtsheft laufend.md`, um zu sehen welche KW und welche Wochentage existieren.
2. `patch_vault_file` mit Ziel-Heading `### <Wochentag>, TT.MM.JJJJ`, Operation append.
3. Fehlt die Kalenderwoche, den Block aus `## Vorlage für eine neue Woche` per `get_vault_file_partial` holen, ausfüllen und direkt über der Überschrift `## Vorlage für eine neue Woche` einsetzen.
4. Vorhandenes niemals überschreiben, immer anhängen.

## Register

Das Berichtsheft folgt nicht dem Schreibstil aus `CLAUDE.md`. Hier gilt:

- Nominalstil, kein Plauderton, keine Anrede. "Grundkonfiguration von Firewalls" statt "Firewalls eingerichtet".
- Protokolle und Technologien beim Namen nennen und ausschreiben: DHCP, RIP, VPN, HCI, JBOD.
- Produkt- und Herstellernamen generisch halten: Firewalls statt FortiGate, Festplattenverschlüsselung statt BitLocker, Backup-Lösung statt Veeam, Switch statt Cisco-Switch, Out-of-Band-Management-Schnittstelle statt iDRAC, Mobile-Device-Management-System statt Intune.
- Keine Pausen, keine Privatthemen. Mittagspause, Alter, Hobbys, Hotelankunft und Freizeitanteile gehören nicht hinein.
- Keine Kundennamen, keine Betriebsgeheimnisse. Szenario beschreiben, nicht den Kunden.
- Rechtschreibfehler aus den Rohnotizen stillschweigend berichtigen.
- Fachlich Falsches korrigieren, nicht übernehmen. "Verschiedene OSI Modelle" wird zu "Schichten des OSI-Modells", weil es genau ein OSI-Modell gibt.

## Formulierungshilfe

Die linke Spalte wird angestrichen, die rechte nicht.

| Statt | Besser |
| --- | --- |
| Firewalls eingerichtet | Zurücksetzen und Grundkonfiguration von Firewalls |
| Was mit VMs gemacht | Aufsetzen und Konfiguration einer virtuellen Maschine |
| Basics über DNS gelernt | Grundlagen des Domain Name System: Aufbau der Namensauflösung und Eintragstypen |
| Am Netzwerk gearbeitet | Konfiguration von Switchports und Einrichtung von Trunk-Verbindungen |
| Ping gemacht | Erreichbarkeitsprüfung mittels ICMP zwischen Firewall und Switch |
| Troubleshooting | Eingrenzung und Behebung eines Verbindungsfehlers auf der WAN-Schnittstelle |
| Mittagspause | gehört nicht ins Berichtsheft |
| Vorstellungsrunde mit Alter und Hobbys | Vorstellung der Auszubildendengruppe |

## Nachweis bauen

`python3 Claude/scripts/build_berichtsheft.py <woche.md> Claude/scripts/Muster_Ausbildungsnachweis_woechentlich_v1.docx <outdir> --datum TT.MM.JJJJ`

- Braucht Python 3 mit `python-docx` und LibreOffice (`soffice` im PATH). Fehlt beides, gibt es keine PDFs, der Rest des Vaults läuft trotzdem.
- Auf Windows ohne eigenes Python: das von LibreOffice mitgelieferte `program/python.exe` nehmen und `PYTHONPATH` auf ein Verzeichnis setzen, in das `python-docx` per pip installiert wurde.
- `pdfinfo` fehlt unter Windows. Das Skript zählt die Seiten dann selbst aus der PDF-Struktur.
- Schalter `--eng` setzt nur den Unterschriftsblock enger, nie den Tabelleninhalt. Ohne ihn rutscht der Vordruck unter Windows auf zwei Seiten, weil LibreOffice dort echtes Arial statt Liberation Sans nimmt und die Zeilen höher ausfallen.
- Gegenprobe ist die erste eingereichte Woche. Baut sie sich hier auf zwei Seiten, stimmt die Umgebung nicht, nicht der Text.
- Meldet das Skript zwei Seiten, werden Stichpunkte zusammengezogen, nicht der Satz gequetscht. Die Grenze liegt bei rund zwölf Stichpunkten, wenn zusätzlich Unterweisungen eingetragen sind.
- Schalter `--signatur <png>` setzt die Unterschrift in eine eigene Zeile unter Ort und Datum, direkt auf die Linie. Das Bild bleibt außerhalb des Vaults, damit es nicht per Git synchronisiert wird. Die Unterschrift kostet rund eine Zeile, deshalb vorher Stichpunkte straffen.
- Die erzeugte `.docx` liegt neben dem PDF. Wer Word hat, exportiert daraus das PDF.

## Pflichtangaben

Jedes Blatt braucht Name, Ausbildungsjahr und Berichtszeitraum.
Je Woche: `Abteilung/Einsatzort`, dazu `Stunden Betrieb` und `Stunden Berufsschule` getrennt erfasst.
Der Berichtszeitraum läuft Montag bis Sonntag, nicht Montag bis Freitag.

## Related

- [[Berichtsheft laufend]]
- [[Berichtsheft Routine]]
- [[Ausbildung {{BETRIEB_KURZ}}]]
