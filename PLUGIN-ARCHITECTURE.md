# Plugin-Architektur: pyVGM — Python-Vorgehensmodell

Dokumentation der Architekturentscheidungen und Patterns für dieses Claude Code Plugin.

## Kernkonzept: Symlinks statt Kopien

Claude Code erkennt Skills in `.claude/skills/<name>/SKILL.md` automatisch als Slash-Commands.
Dieses Plugin nutzt **Symlinks** statt Kopien: `.claude/skills/pyVGM-plan` → `../../.basis-python-framework/skills/plan`.

**Vorteile:**
- Änderungen am Framework wirken sofort (kein erneutes Installieren)
- Submodul-Updates (`git submodule update --remote`) aktualisieren alle Skills
- Neue Skills brauchen nur einen neuen Symlink

## Skill-Naming: Verzeichnisname statt `name`-Feld

Claude Code bestimmt den Skill-Namen so:
1. `name`-Feld im YAML-Frontmatter → hat Vorrang
2. Verzeichnisname → Fallback wenn `name` fehlt

**Wichtig:** Die SKILL.md-Dateien dürfen **kein `name`-Feld** im Frontmatter haben.
Sonst überschreibt es den Verzeichnisnamen und der `pyVGM-` Prefix geht verloren.

```yaml
# RICHTIG — Verzeichnisname bestimmt den Skill-Namen
---
description: Führt interaktiv durch die Plan-Phase.
---

# FALSCH — name: überschreibt den Symlink-Namen
---
name: plan
description: Führt interaktiv durch die Plan-Phase.
---
```

## Prefix-Konvention: `pyVGM-`

Alle Skills bekommen den Prefix `pyVGM-` über die Symlink-Benennung:

```
.claude/skills/pyVGM-plan     → ../../.basis-python-framework/skills/plan
.claude/skills/pyVGM-deploy   → ../../.basis-python-framework/skills/deploy
.claude/skills/pyVGM-status   → ../../.basis-python-framework/skills/status
```

Der `/pyVGM` Übersichts-Skill ist ein Sonderfall: Verzeichnis heißt `pyVGM/`, Symlink heißt `pyVGM`.

## Plugin-Modus-Erkennung in install.sh

Das `install.sh` erkennt ob es als Git-Submodul eingebunden ist:

```bash
PLUGIN_MODE=false
if [ -d "${PROJECT_ROOT}/.git/modules" ] && [ -f "${SCRIPT_DIR}/.git" ]; then
  PLUGIN_MODE=true
fi
```

| Modus | Erkennung | Verhalten |
|---|---|---|
| **Plugin-Modus** (Submodul) | `.git` ist Datei | Erstellt Symlinks in `.claude/skills/pyVGM-*` |
| **Standalone-Modus** (Clone) | `.git` ist Verzeichnis | Kopiert Skills nach `.claude/commands/` |

## Installation: Submodul, nicht Clone

**Kritisch:** Die README muss `git submodule add` anweisen, nicht `git clone`.
Claude Code liest die README und folgt den Anweisungen wörtlich.

```bash
# RICHTIG — Framework als Submodul im Projekt
git init
git submodule add https://github.com/kustus/python-vorgehensmodell.git .basis-python-framework
bash .basis-python-framework/install.sh

# FALSCH — Framework IST das Projekt
git clone https://github.com/kustus/python-vorgehensmodell.git .
./install.sh
```

## Kein Node.js als harte Abhängigkeit

Anders als das SharePoint-Framework setzt pyVGM **kein Node.js voraus**. `install.sh` verwendet `python3` oder `jq` zum Lesen von `plugin.json`. Node.js wird nur für den optionalen PDF-Export benötigt (`md-to-pdf`, `mermaid-cli`).

## Neue Skills hinzufügen

1. Verzeichnis unter `skills/` erstellen: `skills/mein-skill/SKILL.md`
2. **Kein `name`-Feld** im Frontmatter (nur `description`)
3. `install.sh` erneut ausführen — erstellt automatisch den Symlink `pyVGM-mein-skill`
4. `/pyVGM` Übersicht in `skills/pyVGM/SKILL.md` aktualisieren

## Verzeichnisstruktur

```
projekt/
├── .basis-python-framework/       ← Git-Submodul (Framework-Source)
│   ├── .claude-plugin/
│   │   ├── plugin.json            ← Manifest (name: "pyVGM")
│   │   └── post-install.md        ← Template für Post-Install-Nachricht
│   ├── hooks/hooks.json           ← SessionStart-Hook
│   ├── scripts/
│   │   ├── init-project.sh        ← Erstellt .Vorgehensmodell/
│   │   ├── session-check.sh       ← Prüft Projektumgebung
│   │   └── check-docker.sh        ← Prüft Docker-Setup
│   ├── skills/                    ← Skill-Quelldateien (ohne name-Feld!)
│   │   ├── plan/SKILL.md
│   │   ├── deploy/SKILL.md
│   │   ├── pyVGM/SKILL.md        ← Übersichts-Command
│   │   └── ...
│   ├── static/                    ← Templates, CSS, Logo, Know-How
│   ├── install.sh                 ← Erstellt Symlinks oder Kopien
│   └── README.md
├── .claude/skills/                ← Symlinks (vom install.sh erstellt)
│   ├── pyVGM -> ../../.basis-python-framework/skills/pyVGM
│   ├── pyVGM-plan -> ../../.basis-python-framework/skills/plan
│   ├── pyVGM-deploy -> ../../.basis-python-framework/skills/deploy
│   └── ...
├── .Vorgehensmodell/              ← Projektdokumente (nach /pyVGM-init-project)
└── CLAUDE.md
```
