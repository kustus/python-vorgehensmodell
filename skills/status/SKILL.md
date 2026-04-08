---
description: Zeigt den aktuellen Projektstatus (Version, Code-Metriken, offene Punkte).
---

# Projektstatus

Zeigt eine Übersicht über den aktuellen Projektzustand.

## Daten sammeln

### 1. Version & Build

- Version aus `pyproject.toml` lesen
- Letzter Git-Commit (Hash, Datum, Nachricht)
- Aktueller Branch

### 2. Code-Metriken

```bash
# Python-Dateien (ohne .venv, tests)
find src/ -name "*.py" -not -path "*/.venv/*" | wc -l
find src/ -name "*.py" -not -path "*/.venv/*" -exec cat {} + | wc -l

# Templates
find src/ -name "*.html" | wc -l

# Tests
find tests/ -name "*.py" 2>/dev/null | wc -l

# TODOs
grep -rn "TODO\|FIXME" src/ --include="*.py" 2>/dev/null | wc -l
```

### 3. Docker-Status (wenn vorhanden)

```bash
docker compose ps --format "table {{.Name}}\t{{.Status}}" 2>/dev/null
```

### 4. Offene Punkte

- Aus `.Vorgehensmodell/build/STATE.md` → "Bekannte Probleme"
- Aus `CLAUDE.md` → "Offene Features"
- Aus REQUIREMENTS.md → nicht abgehakte Items zählen

### 5. Dokumentations-Status

Prüfe `.Vorgehensmodell/` Vollständigkeit:
- Plan-Phase: X/6 Dokumente ausgefüllt
- Build-Phase: X/8 Dokumente vorhanden
- Run-Phase: X/4 Dokumente vorhanden
- Dokumentation: X PDFs generiert

**Wichtig bei PDF-Zählung:** Nur eigene Projekt-PDFs zählen (`.Vorgehensmodell/dokumentation/*.pdf` und `.Vorgehensmodell/dokumentation/pdf/*.pdf`). Externe/mitgelieferte Dokumentation (z.B. `external-libs/`, `fachliche-docs/`) ausschließen — diese sind Referenzmaterial, keine generierten Projektdokumente.

## Ausgabeformat

```
=== PROJEKTSTATUS ===

📦 Version:     0.5.0
🔀 Branch:      main
📝 Letzter Commit: abc1234 — "feat: Bankabgleich implementiert" (vor 2 Tagen)

📊 Code-Metriken:
   Python-Dateien: 24
   LOC:            3.847
   Templates:      12
   Tests:          8
   TODOs:          5

🐳 Docker:
   app-service    Up 3 days (healthy)
   db             Up 3 days

📋 Offene Punkte:
   - [ ] API Error Retry-Button (STATE.md)
   - [ ] Weitere Belegkategorien (REQUIREMENTS.md)

📚 Dokumentation:
   Plan:  4/6 ausgefüllt
   Build: 6/8 vorhanden
   Run:   2/4 vorhanden
   PDFs:  0 generiert
```
