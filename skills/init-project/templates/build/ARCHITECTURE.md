# {{PROJEKTNAME}} — Architektur-Entscheidungen

## Tech-Stack

| Schicht | Technologie | Warum |
|---------|------------|-------|
| Backend | Python 3.11 + Flask | ... |
| Frontend | Bootstrap 5.3 + Bootstrap Icons | Standard-CSS, kein Build-Tooling nötig |
| Schrift | Lokal als WOFF2 | DSGVO-konform — keine Google Fonts |
| Datenbank | SQLite + SQLAlchemy ORM | Einfach, kein separater DB-Server |
| PDF | FPDF2 mit PDF/A | ... |
| Container | Docker | ... |

---

## Verzeichnisstruktur

```
{{PROJEKTNAME}}/
├── src/{{PACKAGE_NAME}}/
│   ├── main.py              # create_app() Factory
│   ├── views.py             # Blueprint mit Routen
│   ├── services/            # Fachlogik
│   ├── models/              # SQLAlchemy-Models
│   └── ui/templates/        # Jinja2-Templates
├── tests/
├── pyproject.toml           # Version, Dependencies
├── Dockerfile
└── docker-compose.yml
```

---

## Service-Schicht: Fachlogik in Services, nicht in Routes

**Fachlogik gehört in Service-Klassen, nicht in Flask-Routes.** Routes orchestrieren nur: sie rufen Services auf und geben das Ergebnis als JSON zurück.

| Verantwortung | Route (views.py) | Service |
|---------------|-------------------|---------|
| Daten laden (DB, API) | Nein | Ja |
| Persistieren (DB schreiben) | Nein | Ja |
| Business-Logik / Validierung | Nein | Ja |
| Orchestrierung | Ja | Nein |
| HTTP-Request parsen, JSON-Response | Ja | Nein |

---

## UI-Patterns

### Bootstrap-Karten

Immer mit `.card-header` + `.card-body`. Formularfelder nur Bootstrap Grid (`row g-3` + `col-md-X`).

### Links

- Intern: kein `target="_blank"`
- Extern: `target="_blank" rel="noopener"` + Pfeil-Icon

---

## Konfiguration

Beschreibe hier das Config-System (YAML, Environment Variables, etc.).

---

## Deploy

```
docker build → docker compose up -d
```

---

## Pflicht-Endpunkte

Jede Flask-App muss bereitstellen:
- `GET /api/health` — Health-Check
- `GET /manifest` — App-Metadaten
- `POST /api/reload-config` — Config neu laden

---

## Bekannte Fallstricke

- `base.html` braucht `now` → `UndefinedError` ohne Context-Processor
- Kein `integrity`-Attribut bei CDN-Scripts (Safari blockiert bei Hash-Mismatch)
- `request.url.hostname` ist in Jinja2 immer leer → `request.host.split(':')[0]` verwenden
- Keine Google Fonts direkt verlinken (DSGVO)
