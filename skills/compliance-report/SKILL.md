---
description: Compliance-Bericht (DSGVO, Datenschutz, Aufbewahrung).
---

# Compliance-Bericht

Erstellt einen Compliance-Bericht mit Fokus auf DSGVO und Datenschutz.

## 6 Prüfbereiche

### 1. Datenhaltung

- Wo werden Daten gespeichert? (SQLite lokal, Cloud, NAS)
- Werden Daten an Dritte übermittelt?
- Verschlüsselung at rest / in transit?

### 2. Zugriffskontrolle

- Authentifizierung vorhanden?
- Autorisierung (Rollen/Berechtigungen)?
- Session-Management sicher?

### 3. Nachvollziehbarkeit

- Änderungshistorie (Audit Trail)?
- Logging von Zugriffen?
- Versionierung der Daten?

### 4. Verfügbarkeit & Betrieb

- Backup-Strategie?
- Recovery-Plan?
- SLA definiert?

### 5. Änderungsmanagement

- Versionskontrolle (Git)?
- Release-Prozess definiert?
- Rollback-Strategie?

### 6. Risikobewertung

- Identifizierte Risiken und Maßnahmen
- Restrisiken
- Handlungsempfehlungen

## Ausgabe

Schreibe nach `.Vorgehensmodell/dokumentation/08-compliance.md`.

Format: Formaler Markdown-Bericht mit ✅/⚠️/❌ pro Bereich und konkreten Empfehlungen.
