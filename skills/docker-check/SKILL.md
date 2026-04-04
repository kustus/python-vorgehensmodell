---
description: Prüft Docker-Umgebung (Container, Health-Checks, Volumes, Dockerfile).
---

# Docker-Check

Prüft ob die Docker-Konfiguration den Best Practices entspricht.

## Ablauf

### 1. Script ausführen

```bash
bash scripts/check-docker.sh
```

### 2. Zusätzliche Prüfungen (durch Claude)

#### Dockerfile-Analyse
- [ ] Base-Image: `python:3.11-slim` (nicht `python:3.11` — zu groß)
- [ ] Gunicorn im CMD (nicht `app.run()`)
- [ ] HEALTHCHECK konfiguriert
- [ ] `PYTHONUNBUFFERED=1` gesetzt
- [ ] `TZ=Europe/Berlin` gesetzt
- [ ] Multi-Stage Build (wenn sinnvoll)
- [ ] pip-Cache gemountet (`--mount=type=cache,target=/root/.cache/pip`)

#### docker-compose.yml Analyse
- [ ] Volumes für persistente Daten definiert
- [ ] Config-Volumes separat (nicht im Build)
- [ ] Restart-Policy gesetzt (`unless-stopped` oder `always`)
- [ ] Ports korrekt gemappt
- [ ] Health-Check in Compose (zusätzlich zum Dockerfile)

#### Netzwerk & Erreichbarkeit
- [ ] Interne Service-Kommunikation über Container-Namen (nicht localhost)
- [ ] Externe Ports nur wo nötig exponiert

## Ausgabeformat

```
=== DOCKER-CHECK ===

Script-Ergebnis:
  ✅ Docker installiert
  ✅ Docker Daemon läuft
  ✅ docker-compose.yml gefunden
  ✅ 3 Dockerfile(s) gefunden

Dockerfile-Analyse:
  ✅ python:3.11-slim
  ✅ Gunicorn CMD
  ⚠️ Kein HEALTHCHECK
  ✅ PYTHONUNBUFFERED=1

Compose-Analyse:
  ✅ Volumes definiert
  ⚠️ Keine Restart-Policy

=== EMPFEHLUNGEN ===
- HEALTHCHECK in Dockerfile hinzufügen
- restart: unless-stopped in docker-compose.yml
```
