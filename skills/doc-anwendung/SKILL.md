---
description: Formale Anwendungsbeschreibung für IT-Governance.
---

# Anwendungsbeschreibung

Erstellt eine formale Anwendungsbeschreibung — das "Steckbrief"-Dokument für IT-Governance, Management oder externe Stakeholder.

## Inhalt

### 1. Steckbrief

| Feld | Wert |
|------|------|
| Anwendungsname | (aus PROJECT.md) |
| Version | (aus pyproject.toml) |
| Verantwortlich | (aus STAKEHOLDER.md) |
| Plattform | Python/Flask, Docker |
| Status | Entwicklung / Produktion / Abschaltung |
| Erstellt | (Datum) |

### 2. Ausgangslage

Was war das Problem? Warum wurde die Anwendung entwickelt?
→ Aus BUSINESS-CASE.md übernehmen.

### 3. Zielsetzung

Was soll die Anwendung erreichen?
→ Aus PROJECT.md und SCOPE.md.

### 4. Anforderungen

Zusammenfassung der Kern-Features (nicht technisch, sondern fachlich).
→ Aus REQUIREMENTS.md, nur die wichtigsten.

### 5. Akteure & Berechtigungen

Wer nutzt die Anwendung in welcher Rolle?
→ Aus USE-CASES.md und STAKEHOLDER.md.

### 6. Datenmodell (Übersicht)

Vereinfachtes ER-Diagramm und Beschreibung der Hauptentitäten.
→ Aus den SQLAlchemy-Models, aber vereinfacht für Nicht-Techniker.

### 7. Technische Architektur (Übersicht)

Kontextdiagramm + Tech-Stack-Tabelle.
→ Aus ARCHITECTURE.md, vereinfacht.

### 8. Sicherheit & Datenschutz

- Authentifizierung / Autorisierung
- Datenschutz-Maßnahmen (DSGVO)
- Datenstandort
→ Aus Security-Check-Ergebnis.

### 9. Betriebskonzept

- Hosting / Infrastruktur
- Monitoring / Alerting
- Backup / Recovery
- SLA
→ Aus OPERATIONS.md.

### 10. Abschaltkonzept

Was passiert wenn die Anwendung abgeschaltet wird?
→ Aus DECOMMISSION.md.

## Ausgabe

Schreibe nach `.Vorgehensmodell/dokumentation/01-anwendungsbeschreibung.md`.

## Regeln

- Sprache: Deutsch, formell, für Management lesbar
- Keine technischen Details die ein Nicht-Techniker nicht versteht
- Diagramme vereinfachen (max. 5-7 Boxen)
- Nur Fakten — keine Marketingsprache
