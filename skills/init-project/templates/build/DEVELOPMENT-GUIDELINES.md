# {{PROJEKTNAME}} — Entwicklungsrichtlinien

## Sprache

- Code: Englisch (Variablen, Funktionen, Klassen)
- Kommentare/Doku: Deutsch
- Git-Commits: Deutsch

---

## Python-Konventionen

### Allgemein
- Python 3.10+ (Type Hints verwenden)
- PEP 8 Formatierung (ruff als Linter/Formatter)
- Imports: stdlib → third-party → eigene Module (jeweils alphabetisch)
- Keine globalen Variablen außer Konstanten (UPPER_CASE)

### Namenskonventionen
| Element | Konvention | Beispiel |
|---------|-----------|---------|
| Module | snake_case | `booking_generator.py` |
| Klassen | PascalCase | `BelegService` |
| Funktionen | snake_case | `parse_betrag()` |
| Konstanten | UPPER_CASE | `MAX_RETRY_COUNT` |
| Private | Prefix `_` | `_internal_helper()` |

### Type Hints
```python
def parse_betrag(value: str | float) -> float:
    ...

def get_eingang(eingang_id: int) -> dict | None:
    ...
```

---

## Flask-Konventionen

### App Factory
```python
def create_app(config_path: str | None = None) -> Flask:
    app = Flask(__name__, ...)
    # Blueprint registrieren
    # Context Processor einrichten
    return app
```

### Blueprint-Struktur
- Ein Blueprint pro logischem Bereich
- Routes orchestrieren nur — keine Fachlogik in Routes
- Services für Business-Logik

### Context Processor (Pflicht)
```python
@app.context_processor
def inject_globals():
    return {
        "now": datetime.datetime.now(),
        "app_version": APP_VERSION,
    }
```

### Version
```python
import importlib.metadata
APP_VERSION = importlib.metadata.version("package-name")
```
Nie hardcoden — nur in `pyproject.toml` pflegen.

---

## Datenbank

### SQLAlchemy
- WAL-Modus für parallelen Zugriff
- Migrations über Alembic (wenn nötig)
- Models in eigenem Package/Modul

### Abfragen
```python
# Richtig: SQLAlchemy ORM
eingang = db.session.get(Eingang, eingang_id)

# Falsch: Raw SQL mit String-Formatierung
db.execute(f"SELECT * FROM eingang WHERE id = {id}")  # SQL Injection!
```

---

## Frontend / Templates

### Bootstrap
- Cards immer mit `.card-header` + `.card-body`
- Formularfelder: `row g-3` + `col-md-X`
- Kein Flexbox-Hacking, Bootstrap Grid verwenden

### HTML-Inputs für Zahlen
```html
<input type="text" inputmode="decimal">  <!-- NICHT type="number" -->
```

### CDN-Scripts
- Kein `integrity`-Attribut (Safari blockiert bei Hash-Mismatch)
- Keine Google Fonts (DSGVO) — lokal als WOFF2

### Business-Logik
- **Nur im Backend!** Browser-JS ist für Darstellung + Interaktion
- Validierung, Regeln, Entscheidungen gehören ins Python-Backend

---

## Docker

### Dockerfile
```dockerfile
FROM python:3.11-slim
# Gunicorn, nicht app.run()!
CMD ["gunicorn", "--bind", "0.0.0.0:PORT", "--workers", "1", "--threads", "4", "--timeout", "120", "package.main:create_app()"]
```

### Health-Check
```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:PORT/api/health')" || exit 1
```

---

## Versionierung

Bei **jeder** Änderung Version in `pyproject.toml` erhöhen:
- Patch (0.0.X): Bugfix
- Minor (0.X.0): Feature
- Major (X.0.0): Architekturbruch

---

## Tests

```bash
python -m pytest tests/ -v
```

- Tests in `tests/` Verzeichnis
- Fixtures für DB-Setup
- Service-Methoden einzeln testbar (kein Flask-Context nötig)

---

## PDF-Generierung

Alle PDFs als **PDF/A** (Aufbewahrungspflicht).

---

## Pakete

Immer im `.venv` installieren, nie global:
```bash
python -m venv .venv
source .venv/bin/activate
pip install -e .
```
