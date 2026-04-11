# Entwicklungsvorgaben (Framework)

> Diese Datei enthält die **Framework-seitigen Entwicklungsvorgaben** für alle Python/Flask-Projekte.
> Projektspezifische Ergänzungen stehen in `build/DEVELOPMENT-GUIDELINES.md`.

## Abhängigkeiten
- Immer im `.venv` installieren, nie global
- Aufruf über `python -m` oder aus aktiviertem venv

## Code-Konventionen

### Python
- Python 3.11 (Type Hints verwenden)
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

### Architektur
- **Service-Schicht:** Fachlogik in Services, nicht in Flask-Routes
- Routes orchestrieren nur — keine Fachlogik in Routes
- **Business-Logik nur im Backend** — Browser-JS ist für Darstellung + Interaktion
- Alle Service-Klassen einzeln testbar (kein Flask-Context nötig)

### Flask — Pflichten
- `create_app()` Factory mit Context Processor (`now`, `app_version`)
- **APP_VERSION** per `importlib.metadata.version()`, nie hardcoded
- **Gunicorn** im Dockerfile (`--workers 1 --threads 4`), nicht `app.run()`
- Blueprint-Struktur: Ein Blueprint pro logischem Bereich

### Flask — Pflicht-Endpunkte
Jede Flask-App muss bereitstellen:
- `GET /api/health` — Health-Check
- `GET /manifest` — App-Metadaten
- `GET /info` — App-Informationen
- `POST /api/reload-config` — Config neu laden

### Flask — Context Processor (Pflicht)
```python
@app.context_processor
def inject_globals():
    return {
        "now": datetime.datetime.now(),
        "app_version": APP_VERSION,
    }
```

### Flask — Version
```python
import importlib.metadata
APP_VERSION = importlib.metadata.version("package-name")
```
Nie hardcoden — nur in `pyproject.toml` pflegen.

### Datenbank
- SQLAlchemy ORM — kein Raw SQL mit String-Formatierung
- WAL-Modus für parallelen Zugriff
- Migrations über Alembic (wenn nötig)
- Models in eigenem Package/Modul

```python
# Richtig: SQLAlchemy ORM
eingang = db.session.get(Eingang, eingang_id)

# Falsch: Raw SQL mit String-Formatierung
db.execute(f"SELECT * FROM eingang WHERE id = {id}")  # SQL Injection!
```

### UI-Patterns (Pflicht)
**Vor jeder UI-Implementierung:** `FLASK-PATTERNS.md` lesen und dem Benutzer das passende Pattern vorschlagen. Kein eigenes Pattern erfinden wenn ein bestehendes passt. Siehe `.Vorgehensmodell/framework-links/FLASK-PATTERNS.md`.

### Frontend / Templates
- **Bootstrap-Karten** immer mit `.card-header` + `.card-body`
- **Formulare:** `row g-3` + `col-md-X`, kein Flexbox-Hacking
- **HTML-Inputs für Zahlen:** `type="text" inputmode="decimal"`, nicht `type="number"`
- **Kein `integrity`-Attribut** bei CDN-Scripts (Safari blockiert bei Hash-Mismatch)
- **Keine Google Fonts** direkt verlinken (DSGVO) — lokal als WOFF2
- **Jinja2:** `request.host.split(':')[0]` statt `request.url.hostname` (immer leer)
- Intern: kein `target="_blank"` — Extern: `target="_blank" rel="noopener"` + Pfeil-Icon

### Docker
- Dockerfile mit Gunicorn, nicht Flask Dev-Server
- Health-Check konfigurieren
- Config-Dateien nie überschreiben (rsync-Excludes)

```dockerfile
FROM python:3.11-slim
CMD ["gunicorn", "--bind", "0.0.0.0:PORT", "--workers", "1", "--threads", "4", "--timeout", "120", "package.main:create_app()"]
```

### Fehlerbehandlung
- Alle Service-Methoden mit try/except
- Verständliche deutsche Fehlermeldungen für den User
- Technische Details nur ins Log, nicht in die UI
- Flask `errorhandler` für 404/500 mit benutzerfreundlichen Seiten

### Tests
- pytest in `tests/` Verzeichnis
- Fixtures für DB-Setup
- Service-Methoden einzeln testbar (kein Flask-Context nötig)
- Pflicht-Tests für Geschäftslogik in Services

```bash
python -m pytest tests/ -v
```

### Versionierung

Bei **jeder** Änderung Version in `pyproject.toml` erhöhen:
- Patch (0.0.X): Bugfix
- Minor (0.X.0): Feature
- Major (X.0.0): Architekturbruch

### PDF-Generierung

Alle PDFs als **PDF/A** (Aufbewahrungspflicht).

## Deploy
<!-- Wird durch /pyVGM-deploy Command gesteuert -->

## Release-Management
Siehe [framework-links/RELEASE-MANAGEMENT.md](../framework-links/RELEASE-MANAGEMENT.md)
