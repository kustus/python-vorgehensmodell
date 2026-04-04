---
description: Führt interaktiv durch die Plan-Phase (Business Case, Stakeholder, Scope, Use Cases, Risiken, Meilensteine).
---

# Plan-Phase: Projektplanung interaktiv durchgehen

Führe den Benutzer Schritt für Schritt durch die Plan-Phase. Jedes Dokument wird interaktiv erarbeitet — der Benutzer beantwortet Fragen, Claude erstellt/aktualisiert das Dokument.

## Argumente

| Argument | Beschreibung |
|----------|-------------|
| *(keins)* | Übersicht: Status aller Plan-Dokumente anzeigen |
| `business-case` | Business Case erarbeiten |
| `stakeholder` | Stakeholder-Analyse durchführen |
| `scope` | Scope-Definition erstellen |
| `use-cases` | Use Cases erfassen |
| `risks` | Risikoanalyse durchführen |
| `milestones` | Meilensteine festlegen |
| `all` | Alle Schritte nacheinander durchgehen |

---

## Übersicht (`/pyVGM-plan`)

Prüfe welche Plan-Dokumente existieren und ob sie ausgefüllt sind:

```
=== PLAN-PHASE ===

1. Business Case      ✅ / 📋 / ❌    (.Vorgehensmodell/plan/BUSINESS-CASE.md)
2. Stakeholder         ✅ / 📋 / ❌    (.Vorgehensmodell/plan/STAKEHOLDER.md)
3. Scope               ✅ / 📋 / ❌    (.Vorgehensmodell/plan/SCOPE.md)
4. Use Cases           ✅ / 📋 / ❌    (.Vorgehensmodell/plan/USE-CASES.md)
5. Risiken             ✅ / 📋 / ❌    (.Vorgehensmodell/plan/RISKS.md)
6. Meilensteine        ✅ / 📋 / ❌    (.Vorgehensmodell/plan/MILESTONES.md)
```

✅ = Datei existiert und enthält projektspezifische Inhalte
📋 = Datei existiert aber ist nur ein Template
❌ = Datei fehlt

---

## Ablauf pro Dokument

Jedes Dokument wird in einer interaktiven Befragung erarbeitet. Claude stellt Fragen, der Benutzer antwortet, Claude schreibt das Dokument.

### 1. Business Case (`/pyVGM-plan business-case`)

Fragen an den Benutzer:
1. **Was ist der Anlass für dieses Projekt?** (Problem, Geschäftsrisiko)
2. **Was ist die geplante Lösung?** (grob, 1-2 Sätze)
3. **Wer ist der Auftraggeber?**
4. **Wer entwickelt?** (intern, extern, KI-gestützt?)
5. **Welche Plattform/Technologie?** (Flask, Docker, etc.)
6. **Ist die Lösung zeitlich befristet?** Wenn ja, bis wann?
7. **Wie hoch ist das geschätzte Budget / der Aufwand?**
8. **Was passiert wenn das Projekt NICHT gemacht wird?** (Geschäftsrisiko)

→ Ergebnis in `.Vorgehensmodell/plan/BUSINESS-CASE.md` schreiben

### 2. Stakeholder-Analyse (`/pyVGM-plan stakeholder`)

Fragen:
1. **Wer benutzt die Anwendung direkt?** (Rollen, Anzahl)
2. **Wer gibt das Projekt frei?** (Fachlich, Technisch)
3. **Wer ist indirekt betroffen?** (z.B. Mitarbeiter die zugeordnet werden)
4. **Wer muss informiert werden?** (Datenschutz, Compliance, IT-Security)
5. **Wie soll mit den Stakeholdern kommuniziert werden?** (Frequenz, Kanal)

→ Stakeholder-Matrix + Kommunikationsplan in `.Vorgehensmodell/plan/STAKEHOLDER.md`

### 3. Scope-Definition (`/pyVGM-plan scope`)

Fragen:
1. **Was sind die Kernfunktionen?** (Was MUSS die Anwendung können?)
2. **Was ist explizit NICHT enthalten?** (Abgrenzung)
3. **Welche Systeme werden NICHT angebunden?** (Schnittstellen-Ausschluss)
4. **Gibt es Einschränkungen?** (Budget, Zeit, Technologie, Plattform)

→ In-Scope / Out-of-Scope / Abgrenzung in `.Vorgehensmodell/plan/SCOPE.md`

### 4. Use Cases (`/pyVGM-plan use-cases`)

Fragen:
1. **Welche Akteure gibt es?** (Rollen mit kurzer Beschreibung)
2. **Pro Akteur: Was sind die Hauptaufgaben in der Anwendung?**
   - Für jeden genannten Use Case nachfragen:
     - Vorbedingung?
     - Ablauf (Schritt für Schritt)?
     - Was ist das Ergebnis?
     - Priorität (Hoch/Mittel/Niedrig)?
3. **Gibt es Sonderfälle oder Ausnahmen?** (z.B. Rückfragen, Eskalation)

→ Use-Case-Übersicht + Details in `.Vorgehensmodell/plan/USE-CASES.md`

### 5. Risikoanalyse (`/pyVGM-plan risks`)

Fragen:
1. **Was könnte schiefgehen?** (Technisch, organisatorisch, zeitlich)
2. **Pro Risiko:**
   - Eintrittswahrscheinlichkeit (Hoch/Mittel/Niedrig)?
   - Auswirkung (Hoch/Mittel/Niedrig)?
   - Wie kann man das Risiko verringern? (Maßnahme)
3. **Gibt es externe Abhängigkeiten?** (APIs, Lizenzen, Infrastruktur)

→ Risiko-Register + Matrix in `.Vorgehensmodell/plan/RISKS.md`

### 6. Meilensteine (`/pyVGM-plan milestones`)

Fragen:
1. **Wann soll das Projekt starten?**
2. **Wann muss es produktiv sein?** (GoLive-Termin)
3. **Gibt es Zwischenmeilensteine?** (MVP, Beta, Phase 1/2/3)
4. **Wann endet der Betrieb?** (falls befristet)
5. **Welche Abhängigkeiten gibt es zwischen Meilensteinen?**

→ Zeitplan-Tabelle in `.Vorgehensmodell/plan/MILESTONES.md`

---

## Alle durchgehen (`/pyVGM-plan all`)

Führe alle 6 Schritte nacheinander durch. Zwischen jedem Schritt das Ergebnis zusammenfassen und fragen ob der Benutzer weitermachen möchte.
