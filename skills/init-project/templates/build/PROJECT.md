# {{PROJEKTNAME}} — Projektvision

## Ziel

{{PROJEKTBESCHREIBUNG}}

## Prinzipien

- **...** — ...
- **...** — ...

## Architektur

```
{{PROJEKTNAME}}/
├── src/
│   └── {{PACKAGE_NAME}}/
│       ├── __init__.py
│       ├── main.py           # create_app() + Blueprint-Registrierung
│       ├── views.py           # Flask-Blueprint (Routen, API-Endpunkte)
│       ├── services/          # Fachlogik (Service-Schicht)
│       ├── models/            # SQLAlchemy-Models
│       └── ui/
│           ├── templates/     # Jinja2-Templates
│           └── static/        # CSS/JS
├── tests/
├── pyproject.toml
├── Dockerfile
└── docker-compose.yml
```

## Infrastruktur

| Komponente | Technologie | Details |
|------------|------------|---------|
| Runtime | Docker | ... |
| Datenbank | SQLite + SQLAlchemy | ... |
| Webserver | Gunicorn | `--workers 1 --threads 4` |
| Frontend | Bootstrap 5.3 | ... |

## Ports / URLs

| Service | Port | URL |
|---------|------|-----|
| {{PROJEKTNAME}} | ... | http://localhost:... |

## Offene Punkte

- [ ] ...
