# pyVGM — Framework-Guide

## Was ist pyVGM?

Ein Claude Code Plugin für strukturierte Python/Flask-Projektentwicklung nach dem **Plan → Build → Deploy → Run**-Modell. Es stellt Skills (Slash-Commands), Templates, Scripts und Hooks bereit.

---

## Typischer Workflow

```
1. /pyVGM-init-project    → Projekt initialisieren
2. /pyVGM-plan            → Plan-Phase (6 Schritte)
3. /pyVGM-build-setup     → Flask-App scaffolden
4. [Entwicklung]          → Claude folgt DEVELOPMENT-GUIDELINES.md
5. /pyVGM-test            → Tests ausführen
6. /pyVGM-code-quality    → Code-Qualitätsprüfung
7. /pyVGM-flask-check     → Flask Best Practices prüfen
8. /pyVGM-deploy          → Build + Deploy
9. /pyVGM-doc-all         → Dokumentation generieren
```

---

## Alle Commands

### Plan-Phase
| Command | Beschreibung |
|---------|-------------|
| `/pyVGM-init-project` | Projekt initialisieren (Struktur + CLAUDE.md) |
| `/pyVGM-plan` | Plan-Phase interaktiv durchgehen (6 Schritte) |

### Build-Phase
| Command | Beschreibung |
|---------|-------------|
| `/pyVGM-build-setup` | Flask-App scaffolden (pyproject.toml, create_app, Dockerfile) |
| `/pyVGM-new-app` | Neue Flask-App zum Projekt hinzufügen (Wizard) |
| `/pyVGM-test` | Tests ausführen (pytest) |
| `/pyVGM-code-quality` | Code-Qualitätsprüfung (5 Bereiche, Note A-F) |
| `/pyVGM-security-check` | OWASP-Sicherheitsprüfung |
| `/pyVGM-flask-check` | Flask Best Practices prüfen |
| `/pyVGM-docker-check` | Docker-Umgebung prüfen |
| `/pyVGM-release-plan` | Release-Planung verwalten |

### Deploy
| Command | Beschreibung |
|---------|-------------|
| `/pyVGM-deploy` | Build + Deploy (schnell / full / pre-prod / prod) |

### Dokumentation
| Command | Beschreibung |
|---------|-------------|
| `/pyVGM-doc-all` | Gesamtdokumentation generieren |
| `/pyVGM-doc-pdf` | PDF-Export mit Corporate Design |
| `/pyVGM-doc-architecture` | Architektur (Mermaid-Diagramme) |
| `/pyVGM-doc-services` | Service- und Blueprint-Steckbriefe |
| `/pyVGM-doc-datenmodell` | ER-Diagramm + Feldtabellen |
| `/pyVGM-doc-screens` | Bildschirme + Mockups |
| `/pyVGM-doc-sequences` | Sequenzdiagramme |
| `/pyVGM-doc-anwendung` | Formale Anwendungsbeschreibung |

### Übergreifend
| Command | Beschreibung |
|---------|-------------|
| `/pyVGM` | Alle Commands im Überblick |
| `/pyVGM-status` | Projektstatus anzeigen |
| `/pyVGM-check-consistency` | Code vs. Dokumentation prüfen |
| `/pyVGM-compliance-report` | Compliance-Bericht (DSGVO etc.) |
| `/pyVGM-migrate` | Bestehendes Flask-Projekt migrieren |

---

## Projektstruktur nach `/pyVGM-init-project`

```
mein-projekt/
├── .basis-python-framework/    ← Submodul (Framework-Source)
├── .claude/skills/pyVGM-*      ← Symlinks auf Framework-Skills
├── .Vorgehensmodell/            ← Projektdokumente
│   ├── framework-links/        ← Symlinks ins Framework (read-only)
│   │   ├── DEVELOPMENT-GUIDELINES.md
│   │   ├── ARCHITECTURE.md
│   │   ├── RELEASE-MANAGEMENT.md
│   │   ├── FLASK-KNOWHOW.md
│   │   ├── FLASK-PATTERNS.md
│   │   ├── FRAMEWORK-GUIDE.md
│   │   ├── FRAMEWORK-BACKLOG.md
│   │   ├── pdf-style.css
│   │   └── assconso-logo.png
│   ├── build/                  ← Projektspezifische Doku (editierbar)
│   ├── plan/                   (Business Case, Stakeholder, Scope, ...)
│   ├── run/                    (Operations, Support, Training, ...)
│   └── dokumentation/          (generierte Docs + PDFs)
├── CLAUDE.md                   ← Projektregeln für Claude
├── pyproject.toml
├── Dockerfile
└── src/
```

### Framework/Projekt-Trennung

| Typ | Ort | Mechanismus |
|-----|-----|-------------|
| Framework-Wissen | `framework-links/` | Symlink ins Submodul (read-only) |
| Projekt-Wissen | `build/` | Kopie aus Template (editierbar) |

Dateien wie `DEVELOPMENT-GUIDELINES.md` existieren in **beiden** Verzeichnissen — die Framework-Version enthält generische Regeln, die Projekt-Version nur projektspezifische Ergänzungen mit einem Basis-Header-Verweis.

---

## Phasen-Übersicht

### Plan-Phase (vor der Entwicklung)
6 Dokumente werden interaktiv erarbeitet:
1. **Business Case** — Warum wird dieses Projekt gemacht?
2. **Stakeholder** — Wer ist beteiligt/betroffen?
3. **Scope** — Was gehört dazu, was nicht?
4. **Use Cases** — Wer macht was mit der Anwendung?
5. **Risiken** — Was kann schiefgehen?
6. **Meilensteine** — Wann ist was fertig?

### Build-Phase (Entwicklung)

**Framework-Vorgaben** (via `framework-links/`, read-only):
- `DEVELOPMENT-GUIDELINES.md` — Code-Konventionen
- `ARCHITECTURE.md` — Tech-Stack, UI-Konventionen
- `RELEASE-MANAGEMENT.md` — Versionierung, Deploy-Modi
- `FLASK-KNOWHOW.md` — Bekannte Fallstricke
- `FLASK-PATTERNS.md` — Erprobte Patterns

**Projekt-Dateien** (in `build/`, editierbar):
- `PROJECT.md` — Vision, Architektur-Übersicht
- `ARCHITECTURE.md` — Projektspezifische Details (mit Basis-Header)
- `REQUIREMENTS.md` — Features nach Phasen
- `DEVELOPMENT-GUIDELINES.md` — Projektspezifische Ergänzungen (mit Basis-Header)
- `STATE.md` — Aktueller Stand, Entscheidungen

### Run-Phase (Betrieb)
- `OPERATIONS.md` — Verantwortlichkeiten, Monitoring
- `SUPPORT.md` — Support-Level, Eskalation
- `TRAINING.md` — Schulungsmaterial
- `DECOMMISSION.md` — Abschalt-Plan

---

## Python/Flask-Konventionen (Kurzreferenz)

| Regel | Details |
|-------|---------|
| Service-Schicht | Fachlogik in Services, nicht in Routes |
| Context Processor | `now` + `app_version` injizieren (Pflicht) |
| Version | `importlib.metadata.version()`, nie hardcoden |
| Gunicorn | Immer im Dockerfile, nie `app.run()` |
| Bootstrap | Cards + card-body, row g-3 + col-md-X |
| Kein integrity | CDN-Scripts ohne SRI-Hashes |
| Keine Google Fonts | Lokal als WOFF2 (DSGVO) |
| PDF/A | Alle generierten PDFs als PDF/A |
| .venv | Pakete immer im Virtual Environment |

---

## Voraussetzungen

- Python 3.10+
- Docker (für Container-Deployment)
- VS Code mit Claude Code Extension
- Git

---

## Framework aktualisieren

```bash
git submodule update --remote
bash .basis-python-framework/install.sh
```
