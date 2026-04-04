---
description: Build + Deploy der Flask-App (Docker oder direkt).
---

# Deploy

Baut und deployt die Flask-Anwendung.

## Argumente

| Argument | Beschreibung |
|----------|-------------|
| *(keins)* | Standard-Deploy: Build + Restart |
| `full` | Mit Tests, Qualitätsprüfung + Git Tag |
| `pre-prod` | Übergabepaket erstellen (Images + Docs) |
| `prod` | Produktiv-Deploy (mit Checkliste) |

---

## Standard-Deploy (`/pyVGM-deploy`)

### 1. Version prüfen

Lies die aktuelle Version aus `pyproject.toml`. Frage den Benutzer ob die Version stimmt oder ob sie erhöht werden soll.

### 2. Build

```bash
docker compose build [service]
```

Oder bei Cross-Build (z.B. Mac → Linux):
```bash
docker buildx build --platform linux/amd64 -t <image>:<version> .
```

### 3. Deploy

```bash
docker compose up -d [service]
```

### 4. Health-Check

```bash
curl -s http://localhost:<PORT>/api/health | python3 -m json.tool
```

Warte max. 30 Sekunden auf `{"ok": true}`.

### 5. Zusammenfassung

Zeige: Version, Build-Dauer, Health-Status.

---

## Full-Deploy (`/pyVGM-deploy full`)

Vor dem Build zusätzlich:

1. **Tests ausführen**: `python -m pytest tests/ -v`
   - Bei Fehlern: STOPP, Fehler anzeigen
2. **Code-Qualität prüfen** (analog `/pyVGM-code-quality`)
3. **Git Status prüfen**: Keine uncommitted Changes
4. **Version bumpen** falls nötig
5. Standard-Deploy (Build + Restart)
6. **Git Tag erstellen**: `v<version>`

---

## Pre-Prod (`/pyVGM-deploy pre-prod`)

Erstellt ein Übergabepaket für einen anderen Admin:

1. Full-Deploy-Prüfungen (Tests, Qualität)
2. Docker-Image als TAR exportieren: `docker save <image> | gzip > <image>-<version>.tar.gz`
3. Dokumentation generieren (`/pyVGM-doc-all`)
4. Release-Report erstellen (Markdown):
   - Version, Datum, Änderungen seit letztem Tag
   - Test-Ergebnis, Qualitäts-Note
   - Installationsanleitung
5. Alles in ZIP packen:
   ```
   release-<version>/
   ├── <image>-<version>.tar.gz
   ├── docker-compose.yml
   ├── RELEASE-REPORT.md
   ├── INSTALL.md
   └── docs/
   ```

---

## Prod-Deploy (`/pyVGM-deploy prod`)

**ACHTUNG:** Frage den Benutzer **explizit** per AskUserQuestion-Dialog um Bestätigung!

Checkliste vor Prod-Deploy:
- [ ] Tests erfolgreich?
- [ ] Version getaggt?
- [ ] Dokumentation aktuell?
- [ ] Backup der Datenbank?
- [ ] Rollback-Plan bekannt?

Nach Bestätigung: Standard-Deploy auf Produktiv-Host.

---

## Wichtige Regeln

- **NIEMALS ohne Bestätigung deployen** (besonders bei prod)
- **Config-Dateien nie überschreiben** — gehören dem Betrieb, nicht dem Build
- Bei Fehlern im Health-Check: Logs zeigen (`docker compose logs <service>`)
- Rollback: `git checkout v<vorherige-version>` → neu builden → deployen
