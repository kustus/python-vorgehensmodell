---
description: Führt pytest Tests aus und berichtet Ergebnisse.
---

# Tests ausführen

Führt die Unit-/Integrationstests des Projekts aus.

## Ablauf

### 1. Tests ausführen

```bash
python -m pytest tests/ -v --tb=short 2>&1
```

### 2. Ergebnis auswerten

Zeige:
- Anzahl Tests: bestanden / fehlgeschlagen / übersprungen
- Fehlgeschlagene Tests mit Fehlermeldung und Datei:Zeile
- Laufzeit

### 3. Coverage (optional)

Falls `pytest-cov` installiert:
```bash
python -m pytest tests/ -v --cov=src/ --cov-report=term-missing 2>&1
```

Zeige Abdeckung pro Modul.

## Wann testen?

- **Pflicht** vor `/pyVGM-deploy full` und `/pyVGM-deploy prod`
- **Empfohlen** nach jeder größeren Änderung
- **Nicht nötig** bei reinen Template-/CSS-Änderungen

## Ausgabeformat

```
=== TESTS ===

✅ 23 bestanden
❌ 2 fehlgeschlagen
⏭️ 1 übersprungen

=== FEHLER ===
FAILED tests/test_beleg_service.py::test_freigabe_ohne_betrag
  → AssertionError: Expected status 'FEHLER', got 'FREIGEGEBEN'

FAILED tests/test_api.py::test_health_check
  → ConnectionError: App nicht gestartet

Laufzeit: 3.2s
```
