# pyVGM — Python-Vorgehensmodell

Claude Code Plugin für strukturierte Python/Flask-Projektentwicklung nach dem **Plan/Build/Doc/Run**-Modell.

## Installation

In einem leeren oder bestehenden Projektverzeichnis:

```bash
git init
git submodule add https://github.com/kustus/python-vorgehensmodell.git .basis-python-framework
bash .basis-python-framework/install.sh
```

Das Script erkennt das Submodul und erstellt **Symlinks** in `.claude/skills/pyVGM-*`, die direkt auf die Skills im Framework zeigen. Danach VS Code Fenster neu laden:

**Cmd+Shift+P** → **Developer: Reload Window**

## Erste Schritte

```
/pyVGM                    Alle Commands im Überblick
/pyVGM-init-project       Projekt initialisieren
/pyVGM-plan               Plan-Phase starten
```

## Skills

### Plan-Phase
| Skill | Beschreibung |
|-------|-------------|
| `/pyVGM-init-project` | Projekt initialisieren (Struktur + CLAUDE.md) |
| `/pyVGM-plan` | Plan-Phase interaktiv durchgehen |

### Build-Phase
| Skill | Beschreibung |
|-------|-------------|
| `/pyVGM-build-setup` | Flask-App scaffolden + Build-Umgebung |
| `/pyVGM-new-app` | Neue Flask-App hinzufügen (Wizard) |
| `/pyVGM-test` | Tests ausführen (pytest) |
| `/pyVGM-code-quality` | Code-Qualitätsprüfung (Note A-F) |
| `/pyVGM-security-check` | OWASP-Sicherheitsprüfung |
| `/pyVGM-flask-check` | Flask Best Practices prüfen |
| `/pyVGM-docker-check` | Docker-Umgebung prüfen |
| `/pyVGM-release-plan` | Release-Planung verwalten |

### Deploy
| Skill | Beschreibung |
|-------|-------------|
| `/pyVGM-deploy` | Build + Deploy (schnell / full / pre-prod / prod) |

### Dokumentation
| Skill | Beschreibung |
|-------|-------------|
| `/pyVGM-doc-all` | Gesamtdokumentation (9 Dokumente + PDF) |
| `/pyVGM-doc-pdf` | PDF-Export mit Corporate Design |
| `/pyVGM-doc-architecture` | Architektur (Mermaid-Diagramme) |
| `/pyVGM-doc-services` | Service- & Blueprint-Steckbriefe |
| `/pyVGM-doc-datenmodell` | ER-Diagramm + Feldtabellen |
| `/pyVGM-doc-screens` | Bildschirme + Mockups |
| `/pyVGM-doc-sequences` | Sequenzdiagramme |
| `/pyVGM-doc-anwendung` | Formale Anwendungsbeschreibung |

### Übergreifend
| Skill | Beschreibung |
|-------|-------------|
| `/pyVGM` | Alle Commands im Überblick |
| `/pyVGM-status` | Projektstatus anzeigen |
| `/pyVGM-check-consistency` | Code vs. Dokumentation prüfen |
| `/pyVGM-compliance-report` | Compliance-Bericht (DSGVO etc.) |
| `/pyVGM-migrate` | Bestehendes Flask-Projekt migrieren |

## Projektstruktur nach Installation

```
mein-projekt/
├── .basis-python-framework/    ← Submodul (Framework-Source)
├── .claude/skills/pyVGM-*      ← Symlinks auf Framework-Skills
├── .Vorgehensmodell/            ← Projektdokumente (nach /pyVGM-init-project)
│   ├── plan/
│   ├── build/
│   ├── run/
│   └── dokumentation/
└── CLAUDE.md
```

## Aktualisieren

```bash
git submodule update --remote
bash .basis-python-framework/install.sh
```

Neue Skills werden automatisch verlinkt. Bestehende Symlinks bleiben erhalten.

## Voraussetzungen

- Python 3.10+
- Docker (für Container-Deployment)
- VS Code mit Claude Code Extension
- Git
- Node.js (nur für PDF-Export: md-to-pdf, mermaid-cli)

## Lizenz

MIT — Assconso GmbH
