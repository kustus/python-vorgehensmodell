---
description: Build + Deploy der Flask-App (Docker oder direkt).
---

# Deploy

Baut und deployt die Flask-Anwendung auf das QNAP NAS. Läuft **ohne Rückfragen** durch — der User hat den Command explizit aufgerufen.

## Argumente

| Argument | Beschreibung |
|----------|-------------|
| *(keins)* | Standard-Deploy |
| `prod` | Produktiv-Deploy (mit Bestätigung) |

---

## Standard-Deploy (`/pyVGM-deploy`)

### 0. Auswahl (AskUserQuestion — zwei Fragen am Anfang, dann automatisch)

**Frage 1:** "Deploy-Modus wählen:"
1. **Nur Deploy** — Build + Deploy, kein Git
2. **Deploy + Commit** — Uncommitted Changes committen, dann deployen
3. **Deploy + Commit + Push** — Committen, pushen, dann deployen

**Frage 2:** "Tests vorher ausführen?"
1. **Nein** — direkt deployen
2. **Ja** — `pytest` vorher, bei Fehlern STOPP

Bei Modus 3 + Tests: zusätzlich Git Tag `v<version>` erstellen + pushen.

Danach läuft alles vollautomatisch durch — **keine weiteren Fragen**.

### 1. Tests (wenn gewählt)

```bash
python -m pytest tests/ -v
```

Bei Fehlern: **STOPP**, Fehler anzeigen, kein Deploy.

### 2. Git-Commit (wenn Modus 2 oder 3)

Wenn uncommitted Changes vorhanden:
- `git add` aller geänderten Dateien (KEINE neuen unbekannten Dateien ohne Prüfung)
- Commit-Message automatisch generieren (aus `git diff --stat` + Versionen)

Wenn keine Changes vorhanden → diesen Schritt überspringen (kein Fehler).

### 3. Services bestimmen

Prüfe welche Verzeichnisse geändert wurden (seit letztem Deploy/Commit):
- `finance-ai-common/` geändert → **alle Consumer**: `suite-admin beleganalyse-ai steuerberater-ai monatsabschluss-ai`
- Nur ein App-Verzeichnis geändert → nur diesen Service
- Mehrere Apps → nur die geänderten

Falls unklar oder keine Änderungen erkennbar: alle Services deployen.

### 4. Deploy ausführen

Credentials aus `.Vorgehensmodell/build/CREDENTIALS.md` lesen (stillschweigend).

Deploy via `deploy.sh` mit SSH_ASKPASS (nicht sshpass!):

```bash
export SSHPASS='<password>'
ASKPASS_SCRIPT=$(mktemp)
cat > "$ASKPASS_SCRIPT" << 'ASKEOF'
#!/bin/sh
echo "$SSHPASS"
ASKEOF
chmod +x "$ASKPASS_SCRIPT"
export SSH_ASKPASS="$ASKPASS_SCRIPT"
export SSH_ASKPASS_REQUIRE=force
export DISPLAY=:0
./deploy.sh <services...> 2>&1
rm -f "$ASKPASS_SCRIPT"
```

**Timeout:** 600 Sekunden (10 Minuten).
**Immer im Vordergrund** — kein `run_in_background`.

### 5. Git-Push + Tag (wenn Modus 3)

- `git push`
- Wenn Tests gewählt: zusätzlich Git Tag `v<version>` erstellen + pushen

### 6. Health-Check

Nach Deploy: Health-Check aller deployten Services (kein sleep, direkt versuchen):

```bash
curl -s --max-time 15 http://ac-nas1.local:<PORT>/api/health
```

Ports: suite-admin=5010, beleganalyse-ai=8000, steuerberater-ai=5011, monatsabschluss-ai=5012

Suite-Admin hat Health unter `/suite/api/health` oder antwortet auf `/suite` mit Redirect — beides gilt als OK.

### 7. Statusbericht

Am Ende **einen** kompakten Bericht ausgeben:

```
╔══════════════════════════════════════════════════╗
║  Deploy abgeschlossen                            ║
╠══════════════════════════════════════════════════╣
║  Modus: Deploy + Commit + Push                   ║
║  Tests: ✅ 12 passed                             ║
║  Commit: abc1234 — "feat: ..."                   ║
║  Push: ✅                                        ║
║  Tag: v0.15.0                                    ║
║                                                  ║
║  Services:                                       ║
║  suite-admin        v0.40.0  ✅                  ║
║  beleganalyse-ai    v0.45.0  ✅                  ║
║  monatsabschluss-ai v0.15.0  ✅                  ║
║                                                  ║
║  Dauer: 3m 42s                                   ║
╚══════════════════════════════════════════════════╝
```

---

## Prod-Deploy (`/pyVGM-deploy prod`)

Einzige Ausnahme: Hier wird **zusätzlich** eine Bestätigungs-Frage gestellt (Checkliste: Tests OK, Backup, Rollback-Plan).

---

## Wichtige Regeln

- **Maximal 2 Fragen am Anfang** (Modus + Tests) — danach läuft alles durch
- **Config-Dateien nie überschreiben** — gehören dem Betrieb
- Bei Fehlern im Health-Check: Logs zeigen (`docker compose logs <service>`)
- **SSH_ASKPASS verwenden**, nicht sshpass (siehe SSH-DEPLOY-ASKPASS.md)
- Deploy immer im **Vordergrund** — kein run_in_background
