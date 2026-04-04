# Release-Management

## Umgebungen
| Umgebung | Host | URL |
|----------|------|-----|
| Entwicklung | localhost | http://localhost:... |
| Produktion | | |

## Versionierung
`MAJOR.MINOR.PATCH` in `pyproject.toml`

- Patch: Bugfix
- Minor: Feature
- Major: Architekturbruch

## Deploy-Modi
- `/pyVGM-deploy` — Schnell (Standard): Build + Deploy
- `/pyVGM-deploy full` — Mit Tests + Git Tag
- `/pyVGM-deploy pre-prod` — Übergabepaket (Images + Docs)
- `/pyVGM-deploy prod` — Direkt auf Produktiv-Host

## Deploy-Pipeline
```
docker build → (optional: push to registry) → docker compose up -d
```

## Rollback
Git Tag auschecken → neu builden → deployen.

## Freigabe-Prozess
| Rolle | Verantwortung |
|-------|--------------|
| Entwickler | Implementierung, Test-Deploys |
| Fachlicher Freigeber | Fachliche Abnahme |
| Technischer Freigeber | Prod-Deploy-Genehmigung |
