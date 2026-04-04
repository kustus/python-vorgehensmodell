---
description: Prüft ob Code und Dokumentation übereinstimmen (8 Bereiche).
---

# Konsistenz-Check: Code vs. Dokumentation

Vergleicht den tatsächlichen Code mit der Dokumentation in `.Vorgehensmodell/build/` und `CLAUDE.md`.

## 8 Prüfbereiche

### 1. Projektstruktur vs. ARCHITECTURE.md

Vergleiche die tatsächliche Verzeichnisstruktur mit dem Diagramm in `ARCHITECTURE.md`:
- Fehlende Verzeichnisse/Dateien?
- Verzeichnisse im Code die nicht dokumentiert sind?
- Tech-Stack-Tabelle noch aktuell?

### 2. SQLAlchemy-Models vs. STATE.md

- Alle Models/Tabellen in STATE.md erwähnt?
- Neue Felder die nicht dokumentiert sind?
- Status-Werte/Enums aktuell?

### 3. Flask-Routes vs. Dokumentation

- Alle API-Endpunkte in ARCHITECTURE.md oder einem API-Dokument beschrieben?
- Routen im Code die nicht dokumentiert sind?
- Dokumentierte Routen die nicht (mehr) existieren?

### 4. Service-Methoden vs. Tatsächliche Nutzung

- Öffentliche Service-Methoden die nicht aufgerufen werden (Dead Code)?
- Services die in ARCHITECTURE.md beschrieben aber nicht implementiert sind?

### 5. Features vs. REQUIREMENTS.md

- Implementierte Features die nicht in REQUIREMENTS.md stehen?
- Features als "erledigt" markiert die nicht im Code zu finden sind?
- Offene Features die eigentlich schon implementiert sind?

### 6. Code-Konventionen vs. DEVELOPMENT-GUIDELINES.md

- Verstöße gegen dokumentierte Konventionen?
- Konventionen die nicht mehr eingehalten werden (veraltet)?

### 7. Config vs. Tatsächliche Nutzung

- Config-Keys die gelesen aber nicht dokumentiert sind?
- Dokumentierte Config-Keys die nicht (mehr) verwendet werden?

### 8. Dependencies vs. pyproject.toml

- Importierte Pakete die nicht in pyproject.toml stehen?
- Dependencies in pyproject.toml die nicht importiert werden?

## Ausgabeformat

```
=== KONSISTENZ-CHECK ===

1. Projektstruktur vs. ARCHITECTURE.md     ✅ konsistent
2. Models vs. STATE.md                     ⚠️ 2 Abweichungen
3. Routes vs. Dokumentation                ⚠️ 3 undokumentierte Endpunkte
4. Service-Methoden vs. Nutzung            ✅ konsistent
5. Features vs. REQUIREMENTS.md            ⚠️ 1 Feature als offen markiert, aber implementiert
6. Code-Konventionen vs. Guidelines        ✅ konsistent
7. Config vs. Nutzung                      ✅ konsistent
8. Dependencies vs. pyproject.toml         ⚠️ 1 unused dependency

=== ABWEICHUNGEN ===

### 2. Models vs. STATE.md
- ⚠️ Feld `retry_count` in Model `Eingang` nicht in STATE.md erwähnt
- ⚠️ Status `ANGEREICHERT` fehlt in STATE.md

### 3. Routes vs. Dokumentation
- ⚠️ POST /api/pre-check nicht dokumentiert
- ⚠️ GET /api/bankdaten nicht dokumentiert
- ⚠️ DELETE /api/debug/delete-all nicht dokumentiert

=== EMPFEHLUNGEN ===
Für jede Abweichung: Entweder Code oder Dokumentation anpassen (mit konkretem Vorschlag).
```
