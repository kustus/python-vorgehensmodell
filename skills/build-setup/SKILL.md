---
description: Richtet eine neue Flask-App ein (pyproject.toml, create_app, Dockerfile, Tests).
---

# Build-Setup: Flask-App scaffolden

Richtet die technische Grundlage für ein Flask-Projekt ein. Verwendet die Plan-Phase-Ergebnisse falls vorhanden.

## Voraussetzung

`.Vorgehensmodell/` muss existieren. Falls nicht: `/pyVGM-init-project` zuerst ausführen.

---

## Ablauf (6 Schritte)

### Schritt 1: Plan-Ergebnisse übernehmen

Lies `.Vorgehensmodell/plan/` Dokumente (falls ausgefüllt) und übernimm relevante Infos in:
- `.Vorgehensmodell/build/PROJECT.md` → Vision, Stakeholder aus Business Case
- `.Vorgehensmodell/build/REQUIREMENTS.md` → Use Cases als Feature-Liste
- `.Vorgehensmodell/build/RELEASE-MANAGEMENT.md` → Meilensteine als Release-Plan

### Schritt 2: Projekt-Konfiguration

Frage den Benutzer per **AskUserQuestion-Dialog**:

1. **Package-Name** (snake_case, z.B. `meine_app`)
2. **Port** (z.B. 5000, 8000)
3. **Datenbank?** (SQLite / PostgreSQL / Keine)
4. **Docker?** (Ja / Nein)
5. **Gemeinsame Library?** (Name oder "Keine" — wenn das Projekt ein Monorepo mit geteilter Library ist)

### Schritt 3: Projektstruktur erstellen

Erstelle basierend auf den Antworten:

```
pyproject.toml                    # Name, Version 0.1.0, Dependencies
src/<package_name>/
├── __init__.py
├── main.py                       # create_app() mit Context Processor
├── views.py                      # Blueprint mit /api/health, /manifest, /api/reload-config
├── services/
│   └── __init__.py
├── models/                       # (nur wenn Datenbank gewählt)
│   └── __init__.py
└── ui/
    ├── templates/
    │   ├── dashboard.html        # Startseite (extends base.html)
    │   ├── settings.html         # Konfigurationsseite
    │   └── info.html             # Versionen, Systeminformationen
    └── static/
        └── .gitkeep
tests/
├── __init__.py
└── conftest.py                   # pytest Fixtures
```

#### main.py — Pflicht-Inhalte:
```python
import datetime, os, importlib.metadata
from pathlib import Path
from flask import Flask

try:
    APP_VERSION = importlib.metadata.version("<package-name>")
except Exception:
    APP_VERSION = "0.0.0"

def create_app(config_path=None):
    app = Flask(__name__,
        template_folder=str(Path(__file__).parent / "ui" / "templates"),
        static_folder=str(Path(__file__).parent / "ui" / "static"))
    app.secret_key = os.environ.get("FLASK_SECRET_KEY", "<package>-dev-key")

    from <package>.views import app_bp
    app.register_blueprint(app_bp)

    @app.context_processor
    def inject_globals():
        return {"now": datetime.datetime.now(), "app_version": APP_VERSION}

    return app
```

#### views.py — Pflicht-Endpunkte:
- `GET /api/health` → `{"ok": true, "version": "..."}`
- `GET /manifest` → `{"key": "...", "name": "...", "port": ..., "version": "..."}`
- `POST /api/reload-config` → `{"ok": true}`

### Schritt 4: Dockerfile (wenn Docker gewählt)

```dockerfile
FROM python:3.11-slim
WORKDIR /app
ENV PYTHONUNBUFFERED=1
ENV TZ=Europe/Berlin

# Dependencies
COPY pyproject.toml .
COPY src/ src/
RUN pip install -e .

RUN mkdir -p /app/config /app/data
VOLUME /app/data
EXPOSE <PORT>

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:<PORT>/api/health')" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:<PORT>", "--workers", "1", "--threads", "4", "--timeout", "120", "<package>.main:create_app()"]
```

Plus `docker-compose.yml` wenn Docker gewählt.

### Schritt 5: Virtual Environment + Installation

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
```

Prüfe ob die App startet:
```bash
python -c "from <package>.main import create_app; app = create_app(); print(f'✅ App erstellt: {app.name}')"
```

### Schritt 6: Zusammenfassung

Zeige:
- Erstellte Dateien und Verzeichnisse
- Nächste Schritte (Entwicklung starten, `/pyVGM-test` für Tests)
- Hinweis auf `DEVELOPMENT-GUIDELINES.md` für Code-Konventionen
