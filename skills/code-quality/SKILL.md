---
description: Code-Qualitätsprüfung (Python-Qualität, Architektur, Konsistenz, Wartbarkeit, Metriken).
---

# Code-Qualitätsprüfung

Analysiert den Code nach 5 Qualitätsbereichen und vergibt eine Gesamtnote (A-F).

## 5 Prüfbereiche

### 1. Python-Qualität

- **Type Hints:** Funktionen ohne Type Hints zählen
- **Unused Imports:** Nicht verwendete Imports finden
- **Fehlerbehandlung:** Bare `except:` ohne Exception-Typ
- **f-Strings:** String-Konkatenation statt f-Strings
- **Mutable Defaults:** `def f(x=[])` → Mutable Default-Argumente

Prüfe mit:
```bash
python -m ruff check src/ --select E,W,F,I --statistics 2>/dev/null || echo "ruff nicht installiert"
```

### 2. Architektur-Struktur

- **Service-Schicht:** Business-Logik in Routes? (Datenbankzugriffe in views.py = schlecht)
- **Blueprint-Größe:** Dateien > 500 Zeilen → sollten aufgeteilt werden
- **Zirkuläre Imports:** Imports zwischen Modulen prüfen
- **Separation of Concerns:** Templates mit Business-Logik? JS mit Backend-Logik?

### 3. Konsistenz

- **Namenskonventionen:** snake_case für Funktionen/Module, PascalCase für Klassen
- **Import-Stil:** Konsistente Reihenfolge (stdlib → third-party → eigene)
- **Docstrings:** Vorhanden bei öffentlichen Funktionen?
- **Error-Response-Format:** Einheitliches JSON-Format für Fehler?

### 4. Wartbarkeit

- **Test-Abdeckung:** Tests vorhanden? Kritische Pfade getestet?
- **Config-Management:** Hardcoded Werte? Magic Numbers?
- **Logging:** Strukturiertes Logging statt print()?
- **Dependencies:** Veraltete Pakete? Unused Dependencies?

### 5. Code-Metriken

Sammle:
- Anzahl Python-Dateien
- Gesamte LOC (ohne Tests, ohne .venv)
- Durchschnittliche Dateigröße
- Größte Dateien (Top 5)
- Anzahl TODO/FIXME/HACK Kommentare
- Git-Statistik: Commits letzte 30 Tage

```bash
find src/ -name "*.py" -not -path "*/.venv/*" | wc -l
find src/ -name "*.py" -not -path "*/.venv/*" -exec cat {} + | wc -l
grep -rn "TODO\|FIXME\|HACK" src/ --include="*.py" | wc -l
```

## Bewertung

| Note | Punkte | Bedeutung |
|------|--------|-----------|
| A | 90-100% | Exzellent — produktionsreif |
| B | 75-89% | Gut — kleinere Verbesserungen |
| C | 60-74% | Befriedigend — einige Issues |
| D | 40-59% | Ausreichend — deutlicher Nachbesserungsbedarf |
| F | <40% | Mangelhaft — grundlegende Probleme |

## Ausgabeformat

```
=== CODE-QUALITÄT ===

1. Python-Qualität         B  (82%)
2. Architektur-Struktur    A  (95%)
3. Konsistenz              B  (78%)
4. Wartbarkeit             C  (65%)
5. Code-Metriken           —  (Info)

Gesamtnote: B (80%)

=== TOP 5 VERBESSERUNGEN ===
1. [Hoch] Type Hints in services/beleg_service.py ergänzen (12 Funktionen ohne Hints)
2. [Hoch] views.py aufteilen (847 Zeilen → max. 500 pro Datei)
3. [Mittel] 5 bare except: durch spezifische Exceptions ersetzen
4. [Mittel] Test-Abdeckung für BankdatenService fehlt
5. [Niedrig] 23 TODO-Kommentare aufräumen
```
