---
description: Wizard zum Hinzufügen einer neuen Flask-App in ein bestehendes Projekt (Monorepo oder Standalone).
---

# Neue Flask-App erstellen

Interaktiver Wizard zum Erstellen einer neuen Flask-App mit allen Pflicht-Bestandteilen.

## Wann verwenden?

- Monorepo mit mehreren Apps → neue App hinzufügen
- Neue eigenständige Flask-App erstellen

---

## Ablauf

### 1. Abfrage per AskUserQuestion-Dialog

1. **App-Name** (z.B. "Beleganalyse", "Steuerberater")
2. **Package-Name** (snake_case, z.B. `beleganalyse_ai`)
3. **Port** (z.B. 8000)
4. **Kurzbeschreibung** (1 Satz)
5. **Datenbank?** (SQLite / Keine)
6. **Hintergrundverarbeitung?** (Worker-Pipeline / Keine)

### 2. Dateien erstellen

Erstelle die komplette App-Struktur:

```
<app-name>/
├── pyproject.toml
├── Dockerfile.suite              # (oder Dockerfile)
└── src/<package_name>/
    ├── __init__.py
    ├── main.py                   # create_app() + Context Processor
    ├── views.py                  # Blueprint + Pflicht-Endpunkte
    └── ui/
        ├── templates/
        │   ├── dashboard.html    # Startseite
        │   ├── settings.html     # Konfiguration
        │   ├── info.html         # Versionen + Systeminfo
        │   └── setup.html        # Wizard für Erstkonfiguration
        └── static/
            └── .gitkeep
```

### 3. Pflicht-Inhalte

#### pyproject.toml
```toml
[project]
name = "<app-name>"
version = "0.1.0"
requires-python = ">=3.10"
dependencies = [
    "flask>=3.0",
    "gunicorn>=23.0",
]

[project.optional-dependencies]
dev = ["pytest", "ruff"]
```

#### main.py
- `create_app()` Factory
- Context Processor mit `now`, `app_version`
- `APP_VERSION` via `importlib.metadata.version()`

#### views.py — Pflicht-Endpunkte
- `GET /api/health` → `{"ok": true, "version": "..."}`
- `GET /manifest` → App-Metadaten (key, name, port, version, nav)
- `POST /api/reload-config` → Config neu laden
- `GET /info` → Info-Seite
- `GET /settings` → Settings-Seite

#### Dockerfile
- `python:3.11-slim` Basis
- Gunicorn CMD (nicht `app.run()`)
- Health-Check konfiguriert
- `--workers 1 --threads 4 --timeout 120`

#### dashboard.html
```html
{% extends "base.html" %}
{% block title %}<App-Name>{% endblock %}
{% block content %}
<div class="container-fluid py-4">
    <h4 class="mb-4"><i class="bi bi-<icon> me-2" style="color:var(--primary)"></i><App-Name></h4>
    <!-- Inhalt -->
</div>
{% endblock %}
```

### 4. Docker-Compose-Eintrag (wenn vorhanden)

Falls `docker-compose.yml` existiert, füge den neuen Service hinzu.

### 5. Checkliste anzeigen

Zeige eine Checkliste der erstellten Dateien und nächsten Schritte:

- [ ] `pyproject.toml` mit Version + korrektem `name`
- [ ] `create_app()` mit Context Processor (`now`, `app_version`)
- [ ] `/api/health` + `/manifest` + `/api/reload-config` vorhanden
- [ ] Dockerfile mit Gunicorn (nicht `app.run()`)
- [ ] Virtual Environment: `python -m venv .venv && pip install -e .`
- [ ] Erster Start testen: `python -c "from <package>.main import create_app; print('OK')"`
