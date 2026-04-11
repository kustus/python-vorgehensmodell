# Architektur (Framework-Vorgaben)

> Diese Datei enthält die **Framework-seitigen Architektur-Vorgaben** für alle Python/Flask-Projekte.
> Projektspezifische Details (Komponenten, Services, Auth) stehen in `build/ARCHITECTURE.md`.

## Tech-Stack

- **Python 3.11** + Flask mit Jinja2-Templates
- **Bootstrap 5.3** + Bootstrap Icons — kein Build-Tooling nötig
- **SQLAlchemy ORM** mit SQLite — kein separater DB-Server
- **Docker** + Gunicorn für Container-Deployment
- **FPDF2** für PDF-Generierung (PDF/A)

## Projektstruktur (Konvention)

```
projekt/
├── .basis-python-framework/              ← Submodul (read-only)
├── .Vorgehensmodell/
│   ├── framework-links/                  ← Symlinks ins Framework
│   ├── build/                            ← Projektspezifische Doku
│   ├── plan/                             ← Plan-Phase
│   ├── run/                              ← Betrieb
│   └── dokumentation/                    ← Generierte Docs + PDFs
├── src/<package_name>/
│   ├── main.py                           ← create_app() Factory
│   ├── views.py                          ← Blueprint mit Routen
│   ├── services/                         ← Fachlogik (Service-Schicht)
│   ├── models/                           ← SQLAlchemy-Models
│   └── ui/
│       ├── templates/                    ← Jinja2-Templates
│       └── static/                       ← CSS/JS
├── tests/
├── CLAUDE.md                             ← Projekt-Anweisungen
├── pyproject.toml                        ← Version, Dependencies
├── Dockerfile
└── docker-compose.yml
```

## Service-Architektur

### Fachlogik in Services, nicht in Routes

| Verantwortung | Route (views.py) | Service |
|---------------|-------------------|---------|
| Daten laden (DB, API) | Nein | Ja |
| Persistieren (DB schreiben) | Nein | Ja |
| Business-Logik / Validierung | Nein | Ja |
| Orchestrierung | Ja | Nein |
| HTTP-Request parsen, Response | Ja | Nein |

### Blueprint-Struktur
- Ein Blueprint pro logischem Bereich
- Routes orchestrieren nur — keine Fachlogik in Routes

## Datenbank-Konvention

### Eine DB pro App: `data/app.db`

Jede Flask-App verwendet **genau eine SQLite-Datenbank** unter dem festen Pfad `data/app.db`.

- **Alle Tabellen** der App liegen in dieser einen DB (keine Aufteilung nach Concerns)
- **Pfad:** `data/app.db` (relativ zum App-Verzeichnis, im Docker-Volume persistent)
- **Env-Variable:** `APP_DB_PATH` (Override, Default: `data/app.db`)
- **WAL-Modus** aktivieren (paralleler Lese-/Schreibzugriff)
- **Kein direkter Zugriff** auf Datenbanken anderer Apps — immer über HTTP-APIs

### Kein Cross-App DB-Zugriff

Apps dürfen **nicht** direkt auf SQLite-Dateien anderer Apps zugreifen. Alle app-übergreifenden Daten (Users, Tasks, Config) werden über **REST-APIs** gelesen und geschrieben.

| Zugriff | Falsch | Richtig |
|---------|--------|---------|
| User-Daten | `sqlite3.connect("../suite/data/app.db")` | `suite_api.get_user_by_nr(nr)` → HTTP |
| Tasks | Direkt auf `tasks.db` | `suite_api.get_tasks(...)` → HTTP |

## UI-Architektur

### UI-Konventionen
- **Bootstrap-Karten** immer mit `.card-header` + `.card-body`
- **Formulare:** `row g-3` + `col-md-X`, kein Flexbox-Hacking
- **Kein `integrity`-Attribut** bei CDN-Scripts (Safari blockiert bei Hash-Mismatch)
- **Keine Google Fonts** direkt verlinken (DSGVO) — lokal als WOFF2
- **Deutsch:** Alle Labels, Meldungen auf Deutsch

### Wiederverwendbare UI-Komponenten (Partials)

Komplexere UI-Elemente, die in mehreren Templates vorkommen (können), werden als **Jinja2-Partial** implementiert:

- **Partial-Datei:** `_komponentenname.html` (mit Underscore-Prefix) in einem gemeinsamen Template-Verzeichnis
- **API-Route:** Zugehörige Backend-Route liefert die Daten für die Komponente (z.B. `POST /api/konten` für eine Konto-Suche)
- **Einbindung:** `{% include "_komponentenname.html" %}` — das Partial enthält keinen eigenen `<script>`-Tag, sondern wird innerhalb eines `<script>`-Blocks des Aufrufers inkludiert
- **Konfiguration:** Das Partial wird über HTML-Attribute (`data-*`) oder Übergabe-Variablen parametrisiert, nicht über globale JS-Variablen

**Wann ein Partial erstellen?**
- Das UI-Element wird in ≥ 2 Templates verwendet (oder wird das absehbar)
- Es hat eigene Interaktionslogik (Dropdown, Suche, Validierung)
- Es braucht Backend-Daten (API-Call)

**Beispiel:** Konto-Suche (`_konto_suche.html`) — Suchfeld mit Dropdown, lädt Konten per API, filtert nach bebuchten Konten.

### Links
- Intern: kein `target="_blank"`
- Extern: `target="_blank" rel="noopener"` + Pfeil-Icon

## Deploy-Prozess (Schema)

```bash
# Build
docker build -t <image-name> .

# Deploy
docker compose up -d
```

## Pflicht-Endpunkte

Jede Flask-App muss bereitstellen:
- `GET /api/health` — Health-Check
- `GET /manifest` — App-Metadaten
- `GET /info` — App-Informationen
- `POST /api/reload-config` — Config neu laden

## Bekannte Fallstricke

- `base.html` braucht `now` → `UndefinedError` ohne Context-Processor
- Kein `integrity`-Attribut bei CDN-Scripts (Safari blockiert bei Hash-Mismatch)
- `request.url.hostname` ist in Jinja2 immer leer → `request.host.split(':')[0]` verwenden
- Keine Google Fonts direkt verlinken (DSGVO)
