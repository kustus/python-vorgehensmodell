# Release-Management (Framework-Vorgaben)

> Diese Datei enthält die **Framework-seitigen Release-Vorgaben** für alle Python/Flask-Projekte.
> Projektspezifische Details (Host-URLs, Versionen, Zeitplan) stehen in `build/RELEASE-MANAGEMENT.md`.

## Versionierung

### Schema

```
MAJOR.MINOR.PATCH
```

- **MAJOR:** Wird bei Breaking Changes erhöht
- **MINOR:** Wird bei jedem Feature erhöht
- **PATCH:** Für Bugfixes

### Wo gepflegt

`pyproject.toml` — einzige Quelle der Wahrheit:
```toml
[project]
version = "1.2.3"
```

Nie hardcoden — im Code über `importlib.metadata.version()` auslesen.

## Deploy-Modi

### `/pyVGM-deploy` — Schnell (Dev-Iteration)

- Version-Bump + Build + Deploy
- Keine Tests, keine Prüfungen
- Kein Git Tag
- Mehrmals täglich möglich

### `/pyVGM-deploy full` — Formales Release

1. Unit Tests ausführen
2. Version hochzählen
3. Docker Build
4. Deploy
5. Git Tag setzen (`v1.X.X`)
6. Verifikation

### `/pyVGM-deploy pre-prod` — Übergabepaket

Wie `/pyVGM-deploy full`, zusätzlich:
- Konsistenzprüfung (Code vs. Dokumentation)
- Dokumentation generieren (PDFs)
- Docker-Image + PDFs als Übergabepaket

### `/pyVGM-deploy prod` — Produktions-Release

Wie `/pyVGM-deploy full`, zusätzlich:
- Produktions-Host als Ziel
- CHANGELOG.md aktualisieren
- Prod-spezifische Checkliste (Testdaten bereinigt, Freigabe)

## Rollback

Git Tag auschecken → neu builden → deployen.

```bash
git checkout v1.X.X
docker build -t <image-name> .
docker compose up -d
```

Im Notfall: Container stoppen (`docker compose down`).

## Git-Workflow

### Tags

| Tag-Format | Bedeutung |
|------------|-----------|
| `v1.X.X` | Release auf Test-Umgebung |
| `v1.X.X-prod` | Release auf Produktion |

### Commits

Aussagekräftige Commit-Messages auf Deutsch. Kein erzwungenes Format, aber:
- Feature: "Belegimport: CSV-Validierung hinzugefügt"
- Fix: "Datumsformatierung: Locale-Problem korrigiert"
- Docs: "Anwendungsbeschreibung: Health-Check dokumentiert"

## Changelog

### Format

Datei `CHANGELOG.md` im Projekt-Root. Neueste Version oben.

```markdown
## [1.X.X] — YYYY-MM-DD

### Hinzugefügt
- Feature-Beschreibung

### Geändert
- Änderung-Beschreibung
```

### Wann aktualisieren

- Bei jedem formalen Release (nicht bei `/pyVGM-deploy`)
- Vor jedem Prod-Deploy

## Freigabe-Prozess (Schema)

### Ablauf vor Prod-Deploy

1. Entwickler erstellt Release auf Test-Umgebung
2. Fachbereich testet und gibt frei
3. Entwickler erstellt Release Notes + Dokumentationspaket (PDFs via `/pyVGM-doc-all`)
4. IT gibt technisch frei
5. Deploy auf Produktions-Host
6. Rauchtest durch Fachbereich auf Produktion

### Dokumentationspaket für Freigabe

Folgende Dokumente werden übergeben (`/pyVGM-doc-all`):
- Anwendungsbeschreibung (inkl. Abschaltkonzept)
- Architektur
- Security-Report
- Compliance-Report
- Release Notes / Changelog
