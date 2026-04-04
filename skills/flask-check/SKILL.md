---
description: Prüft Flask Best Practices (Context Processor, Endpunkte, Gunicorn, Version, Templates).
---

# Flask Best Practices Check

Prüft ob die Flask-App alle Pflichtanforderungen und Best Practices einhält.

## Prüfbereiche (5 Punkte)

### 1. App Factory & Context Processor

- [ ] `create_app()` Factory vorhanden
- [ ] Context Processor injiziert `now` (base.html braucht es)
- [ ] Context Processor injiziert `app_version`
- [ ] `APP_VERSION` über `importlib.metadata.version()` (nicht hardcoded)
- [ ] `app.secret_key` gesetzt

### 2. Pflicht-Endpunkte

- [ ] `GET /api/health` → gibt `{"ok": true, "version": "..."}` zurück
- [ ] `GET /manifest` → gibt App-Metadaten zurück (key, name, port, version)
- [ ] `POST /api/reload-config` → lädt Config neu

### 3. Dockerfile & Deployment

- [ ] Gunicorn im CMD (nicht `app.run()`)
- [ ] `--workers 1 --threads 4` (Standard für SQLite)
- [ ] `--timeout 120` (für langsame Operationen)
- [ ] HEALTHCHECK konfiguriert
- [ ] `PYTHONUNBUFFERED=1` gesetzt

### 4. Template-Architektur

- [ ] Kein eigenes `base.html` im Blueprint (RecursionError-Gefahr)
- [ ] `{% extends "base.html" %}` verwendet das gemeinsame Template
- [ ] Kein `integrity`-Attribut bei CDN-Scripts
- [ ] Keine Google Fonts per CDN (DSGVO)
- [ ] `request.host.split(':')[0]` statt `request.url.hostname`

### 5. Service-Schicht

- [ ] Fachlogik in Service-Klassen/Modulen, nicht in Routes
- [ ] Routes orchestrieren nur (Service aufrufen → JSON zurückgeben)
- [ ] Business-Logik nur im Backend, nicht in Browser-JS

## Ausgabeformat

```
=== FLASK BEST PRACTICES CHECK ===

1. App Factory & Context Processor    ✅ 5/5
2. Pflicht-Endpunkte                  ⚠️ 2/3  (reload-config fehlt)
3. Dockerfile & Deployment            ✅ 5/5
4. Template-Architektur               ⚠️ 4/5  (integrity-Attribut gefunden)
5. Service-Schicht                    ✅ 3/3

Gesamt: 19/21 (90%)

=== EMPFEHLUNGEN ===
- /api/reload-config Endpunkt hinzufügen (siehe DEVELOPMENT-GUIDELINES.md)
- integrity-Attribute von CDN-Scripts entfernen (Safari blockiert bei Hash-Mismatch)
```

Zeige pro Punkt ✅/⚠️/❌ und konkrete Empfehlungen mit Datei + Zeilennummer.
