# Migration: Framework/Projekt-Trennung mit `framework-links/`

> Dokumentation der Umbau-Entscheidungen, damit die Trennung nachvollziehbar ist und bei Problemen diagnostiziert werden kann.

## Problem

Wenn ein Framework als Submodul N Projekte bedient, müssen Framework-Updates (neue Konventionen, bessere Patterns) automatisch in alle Projekte wirken. Bisher wurden alle Dateien bei `/init-project` **kopiert** — danach waren sie vom Framework abgekoppelt.

## Lösung: `framework-links/` + Namensgleichheit

### Prinzip

| Typ | Ort | Mechanismus |
|-----|-----|-------------|
| Framework-Wissen | `.Vorgehensmodell/framework-links/` | Symlink ins Submodul (read-only) |
| Projekt-Wissen | `.Vorgehensmodell/build/` | Kopie aus Template (editierbar) |

### Namenskonvention

Framework- und Projekt-Dateien heißen **gleich** — die Trennung erfolgt über das Verzeichnis:

```
.Vorgehensmodell/
├── framework-links/
│   └── DEVELOPMENT-GUIDELINES.md    ← Symlink (Framework, read-only)
├── build/
│   └── DEVELOPMENT-GUIDELINES.md    ← Projekt (Ergänzungen, editierbar)
```

### Pflicht-Header in Projekt-Dateien

Jede Projekt-Datei mit Framework-Pendant beginnt mit:

```markdown
# Entwicklungsvorgaben (Projekt)

> **Basis:** [framework-links/DEVELOPMENT-GUIDELINES.md](../framework-links/DEVELOPMENT-GUIDELINES.md)
> Die Framework-Vorgaben gelten uneingeschränkt. Diese Datei enthält **ausschließlich
> projektspezifische Ergänzungen** — keine Überschreibung oder Abschwächung der Basis-Regeln.
```

## Dateikategorien

### 1. Reine Framework-Dateien (nur Symlink, kein Projekt-Pendant)

Dateien die für alle Projekte identisch gelten:

| Datei | Inhalt |
|-------|--------|
| `FLASK-KNOWHOW.md` | Flask-Fallstricke, Best Practices |
| `FLASK-PATTERNS.md` | Erprobte Flask/Jinja2-Patterns |
| `FRAMEWORK-GUIDE.md` | Framework-Anleitung |
| `FRAMEWORK-BACKLOG.md` | Verbesserungsideen fürs Framework |
| `pdf-style.css` | Corporate Design für PDFs |
| `assconso-logo.png` | Logo für PDFs |

### 2. Gemischte Dateien (Symlink + Projekt-Pendant)

Dateien wo Framework-Vorgaben und Projekt-Details koexistieren:

| Framework-Datei (Symlink) | Projekt-Datei (Kopie) | Aufteilung |
|---|---|---|
| `DEVELOPMENT-GUIDELINES.md` | `DEVELOPMENT-GUIDELINES.md` | Framework: Python, SQLAlchemy, Flask-Pflichten / Projekt: Paketspezifika, venv-Details |
| `ARCHITECTURE.md` | `ARCHITECTURE.md` | Framework: Tech-Stack-Vorgaben, UI-Konventionen / Projekt: Services, Models, Config |
| `RELEASE-MANAGEMENT.md` | `RELEASE-MANAGEMENT.md` | Framework: Versionierung, Deploy-Modi / Projekt: Host-URLs, Zeitplan |

### 3. Reine Projekt-Dateien (nur in build/, kein Symlink)

| Datei | Inhalt |
|-------|--------|
| `PROJECT.md` | Vision, Akteure, Infrastruktur |
| `STATE.md` | Aktueller Entwicklungsstand |
| `REQUIREMENTS.md` | Feature-Backlog |
| `ROADMAP.md` | Phasen-Übersicht |
| `RELEASE-PLAN.md` | Versions-Feature-Zuordnung |

## CLAUDE.md-Trennung

### Framework-CLAUDE.md (im Submodul-Root)

Wird von Claude automatisch gelesen. Enthält **generische** Regeln:
- Slash-Commands ausführen (nicht darüber reden)
- Widerspruch-Handling
- Code-Konventionen (Kurzfassung, verweist auf DEVELOPMENT-GUIDELINES.md)
- Kontexthygiene (Agent-Delegation)
- Deploy-Modi (generisch)
- Test-Regeln
- Hinweis: framework-links/ ist read-only

### Projekt-CLAUDE.md (im Projekt-Root)

Enthält **nur projektspezifisches**:
- Projektname + Beschreibung
- Sprache
- Pflichtlektüre (getrennt in "Framework-Vorgaben" und "Projekt-Dateien")
- Projektspezifische Konventionen
- Deploy-Details (konkrete Hosts)
- Offene Features

## Resultierende Verzeichnisstruktur

```
.Vorgehensmodell/
├── framework-links/                          ← ALLE Symlinks, zentral, read-only
│   ├── DEVELOPMENT-GUIDELINES.md             → static/DEVELOPMENT-GUIDELINES.md
│   ├── ARCHITECTURE.md                       → static/ARCHITECTURE.md
│   ├── RELEASE-MANAGEMENT.md                 → static/RELEASE-MANAGEMENT.md
│   ├── FLASK-KNOWHOW.md                      → static/FLASK-KNOWHOW.md
│   ├── FLASK-PATTERNS.md                     → static/FLASK-PATTERNS.md
│   ├── FRAMEWORK-GUIDE.md                    → static/FRAMEWORK-GUIDE.md
│   ├── FRAMEWORK-BACKLOG.md                  → FRAMEWORK-BACKLOG.md
│   ├── pdf-style.css                         → static/pdf-style.css
│   └── assconso-logo.png                     → static/assconso-logo.png
├── build/                                    ← NUR Projekt-Dateien
│   ├── DEVELOPMENT-GUIDELINES.md             (mit Basis-Header)
│   ├── ARCHITECTURE.md                       (mit Basis-Header)
│   ├── RELEASE-MANAGEMENT.md                 (mit Basis-Header)
│   ├── PROJECT.md
│   ├── STATE.md
│   ├── REQUIREMENTS.md
│   ├── ROADMAP.md
│   ├── RELEASE-PLAN.md
│   └── [projektspezifische Dateien]
├── plan/                                     ← NUR Projekt
├── run/                                      ← NUR Projekt
└── dokumentation/                            ← NUR generiert
```

## Änderungen an install.sh

Nach dem Skills-Symlink-Block einen Block für `framework-links/` einfügen:

```bash
# === Framework-Links: Symlinks für bestehende Projekte ===
if [ "$PLUGIN_MODE" = true ]; then
  VM_DIR="${PROJECT_ROOT}/.Vorgehensmodell"
  if [ -d "$VM_DIR" ]; then
    mkdir -p "${VM_DIR}/framework-links"
    SUBMODULE_NAME=$(basename "${SCRIPT_DIR}")
    REL_STATIC="../${SUBMODULE_NAME}/static"

    for doc in DEVELOPMENT-GUIDELINES.md ARCHITECTURE.md ...; do
      link="${VM_DIR}/framework-links/${doc}"
      if [ -f "${SCRIPT_DIR}/static/${doc}" ] && [ ! -L "$link" ]; then
        ln -sf "${REL_STATIC}/${doc}" "$link"
      fi
    done

    # Migration: Alte Kopien aufräumen
    for old in "${VM_DIR}/build/FLASK-KNOWHOW.md" ...; do
      [ -f "$old" ] && [ ! -L "$old" ] && rm -f "$old"
    done
  fi
fi
```

## Änderungen an init-project.sh

Framework-Dateien werden nicht mehr kopiert, sondern als Symlinks in `framework-links/` erstellt:

```bash
mkdir -p "${VM_DIR}/framework-links"

# Statt: cp "${STATIC_DIR}/FLASK-KNOWHOW.md" "${VM_DIR}/build/"
# Jetzt: ln -sf "../../${SUBMODULE_NAME}/static/FLASK-KNOWHOW.md" "${VM_DIR}/framework-links/"
```

## Symlink-Pfade

Relative Pfade vom Symlink-Standort zum Submodul:

```
Von .Vorgehensmodell/framework-links/  →  ../../.basis-python-framework/static/<datei>
Von .Vorgehensmodell/framework-links/  →  ../../.basis-python-framework/<datei>  (für Root-Dateien)
```

## Checkliste: Framework-Umbau (erledigt)

1. [x] Framework-Dateien identifizieren: Was ist generisch, was projektspezifisch?
2. [x] Generische Dateien nach `static/` verschieben (DEVELOPMENT-GUIDELINES, ARCHITECTURE, RELEASE-MANAGEMENT)
3. [x] Templates auf Projekt-Gerüste mit Basis-Header reduzieren
4. [x] CLAUDE.md aufteilen: Framework-CLAUDE.md (Submodul-Root) + Projekt-Template
5. [x] `install.sh` erweitern: `framework-links/` Verzeichnis + Symlinks + Migration alter Kopien
6. [x] `init-project.sh` anpassen: Symlinks statt Kopien für Framework-Dateien

---

## Anleitung: Bestehendes Projekt migrieren

> Einmalmigration für Projekte, die vor dem `framework-links/`-Umbau mit `/pyVGM-init-project` erstellt wurden. Diese Projekte haben Framework-Dateien als **Kopien** in `build/` oder `dokumentation/` liegen, statt als Symlinks.

### Voraussetzungen

- Git-Submodul `.basis-python-framework` ist vorhanden
- Das Framework wurde bereits auf die neue Version aktualisiert (diese Datei existiert im Submodul)

### Schritt 1: Submodul aktualisieren

```bash
cd mein-projekt/
git submodule update --remote .basis-python-framework
bash .basis-python-framework/install.sh
```

`install.sh` erledigt automatisch:
- ✅ Erstellt `.Vorgehensmodell/framework-links/` Verzeichnis
- ✅ Legt Symlinks an für alle Framework-Dateien
- ✅ Löscht alte Kopien von: `FRAMEWORK-GUIDE.md`, `FRAMEWORK-BACKLOG.md` (aus `.Vorgehensmodell/`), `pdf-style.css`, `assconso-logo.png` (aus `dokumentation/`), `FLASK-KNOWHOW.md`, `FLASK-PATTERNS.md` (aus `build/`)

### Schritt 2: Symlinks prüfen

```bash
ls -la .Vorgehensmodell/framework-links/
```

Erwartetes Ergebnis — 9 Symlinks:

| Symlink | Ziel |
|---------|------|
| `DEVELOPMENT-GUIDELINES.md` | `../.basis-python-framework/static/DEVELOPMENT-GUIDELINES.md` |
| `ARCHITECTURE.md` | `../.basis-python-framework/static/ARCHITECTURE.md` |
| `RELEASE-MANAGEMENT.md` | `../.basis-python-framework/static/RELEASE-MANAGEMENT.md` |
| `FLASK-KNOWHOW.md` | `../.basis-python-framework/static/FLASK-KNOWHOW.md` |
| `FLASK-PATTERNS.md` | `../.basis-python-framework/static/FLASK-PATTERNS.md` |
| `FRAMEWORK-GUIDE.md` | `../.basis-python-framework/static/FRAMEWORK-GUIDE.md` |
| `FRAMEWORK-BACKLOG.md` | `../.basis-python-framework/FRAMEWORK-BACKLOG.md` |
| `pdf-style.css` | `../.basis-python-framework/static/pdf-style.css` |
| `assconso-logo.png` | `../.basis-python-framework/static/assconso-logo.png` |

Falls ein Symlink fehlt: manuell anlegen (Pfade siehe oben) oder `install.sh` erneut ausführen.

### Schritt 3: Projekt-Dateien in build/ auf Basis-Header umstellen

Die Dateien `DEVELOPMENT-GUIDELINES.md`, `ARCHITECTURE.md` und `RELEASE-MANAGEMENT.md` in `.Vorgehensmodell/build/` enthalten nach der alten Struktur **gemischten Inhalt** (Framework + Projekt). Jetzt muss der Framework-Anteil entfernt und durch einen Basis-Header ersetzt werden.

**Für jede der drei Dateien:**

1. Öffne die Datei in `build/`
2. Ersetze den Anfang durch den passenden Basis-Header:

**build/DEVELOPMENT-GUIDELINES.md:**
```markdown
# Entwicklungsvorgaben (Projekt)

> **Basis:** [framework-links/DEVELOPMENT-GUIDELINES.md](../framework-links/DEVELOPMENT-GUIDELINES.md)
> Die Framework-Vorgaben gelten uneingeschränkt. Diese Datei enthält **ausschließlich
> projektspezifische Ergänzungen** — keine Überschreibung oder Abschwächung der Basis-Regeln.
```

**build/ARCHITECTURE.md:**
```markdown
# Architektur (Projekt)

> **Basis:** [framework-links/ARCHITECTURE.md](../framework-links/ARCHITECTURE.md)
> Die Framework-Vorgaben gelten uneingeschränkt. Diese Datei enthält **ausschließlich
> projektspezifische Details** — keine Überschreibung oder Abschwächung der Basis-Regeln.
```

**build/RELEASE-MANAGEMENT.md:**
```markdown
# Release-Management (Projekt)

> **Basis:** [framework-links/RELEASE-MANAGEMENT.md](../framework-links/RELEASE-MANAGEMENT.md)
> Die Framework-Vorgaben gelten uneingeschränkt. Diese Datei enthält **ausschließlich
> projektspezifische Details** — keine Überschreibung oder Abschwächung der Basis-Regeln.
```

3. Entferne alle Abschnitte, die jetzt in der Framework-Datei stehen (z.B. allgemeine Python-Konventionen, Flask-Pflichten, Deploy-Modi-Schema)
4. Behalte nur projektspezifische Inhalte (z.B. konkrete Versionen, Host-URLs, projektspezifische Konventionen)

**Faustregel:** Wenn ein Abschnitt für _jedes_ Python/Flask-Projekt gilt → gehört ins Framework. Wenn er _nur für dieses Projekt_ gilt → bleibt in `build/`.

### Schritt 4: CLAUDE.md anpassen

Die Projekt-`CLAUDE.md` muss die Pflichtlektüre auf `framework-links/` umstellen. Ersetze den Pflichtlektüre-Block:

**Vorher (alt):**
```markdown
## Session-Start: Pflichtlektüre
1. [.Vorgehensmodell/build/PROJECT.md](...) — Vision
2. [.Vorgehensmodell/build/ARCHITECTURE.md](...) — Tech-Stack
3. [.Vorgehensmodell/build/DEVELOPMENT-GUIDELINES.md](...) — Konventionen
...
```

**Nachher (neu):**
```markdown
## Session-Start: Pflichtlektüre

### Framework-Vorgaben (`.Vorgehensmodell/framework-links/`)
1. [DEVELOPMENT-GUIDELINES.md](.Vorgehensmodell/framework-links/DEVELOPMENT-GUIDELINES.md) — Code-Konventionen
2. [ARCHITECTURE.md](.Vorgehensmodell/framework-links/ARCHITECTURE.md) — Tech-Stack, UI-Konventionen
3. [RELEASE-MANAGEMENT.md](.Vorgehensmodell/framework-links/RELEASE-MANAGEMENT.md) — Versionierung, Deploy-Modi
4. [FLASK-KNOWHOW.md](.Vorgehensmodell/framework-links/FLASK-KNOWHOW.md) — Flask-Fallstricke
5. [FLASK-PATTERNS.md](.Vorgehensmodell/framework-links/FLASK-PATTERNS.md) — Erprobte Patterns

### Projekt-Dateien (`.Vorgehensmodell/build/`)
1. [PROJECT.md](.Vorgehensmodell/build/PROJECT.md) — Vision, Architektur, Ports
2. [ARCHITECTURE.md](.Vorgehensmodell/build/ARCHITECTURE.md) — Projektspezifische Details
3. [STATE.md](.Vorgehensmodell/build/STATE.md) — Aktueller Stand
4. [REQUIREMENTS.md](.Vorgehensmodell/build/REQUIREMENTS.md) — Features
5. [DEVELOPMENT-GUIDELINES.md](.Vorgehensmodell/build/DEVELOPMENT-GUIDELINES.md) — Projektspezifische Ergänzungen
```

Falls die Projekt-CLAUDE.md noch Abschnitte wie "Python/Flask-Konventionen" enthält, die jetzt in der Framework-CLAUDE.md stehen: entfernen. Die Framework-CLAUDE.md wird automatisch geladen, weil sie im Submodul-Root liegt.

### Schritt 5: Verifizierung

```bash
# Symlinks lesbar?
cat .Vorgehensmodell/framework-links/DEVELOPMENT-GUIDELINES.md | head -3
# Erwartete Ausgabe: "# Entwicklungsvorgaben (Framework)"

# Basis-Header in Projekt-Dateien?
head -3 .Vorgehensmodell/build/DEVELOPMENT-GUIDELINES.md
# Erwartete Ausgabe: "# Entwicklungsvorgaben (Projekt)" + Basis-Verweis

# Alte Kopien weg?
ls .Vorgehensmodell/build/FLASK-KNOWHOW.md 2>/dev/null && echo "WARNUNG: Alte Kopie noch vorhanden" || echo "OK"
ls .Vorgehensmodell/build/FLASK-PATTERNS.md 2>/dev/null && echo "WARNUNG: Alte Kopie noch vorhanden" || echo "OK"
ls .Vorgehensmodell/dokumentation/pdf-style.css 2>/dev/null && echo "WARNUNG: Alte Kopie noch vorhanden" || echo "OK"
```

### Schritt 6: Committen

```bash
git add .Vorgehensmodell/ CLAUDE.md
git commit -m "Migration auf framework-links: Symlinks statt Kopien für Framework-Dateien"
```

### Was kann schiefgehen?

| Problem | Ursache | Lösung |
|---------|---------|--------|
| `cat: No such file or directory` bei Symlink | Submodul nicht ausgecheckt | `git submodule update --init` |
| Symlink zeigt auf falsche Datei | Submodul-Name geändert | Symlink löschen, `install.sh` erneut ausführen |
| Claude liest alte Kopie statt Symlink | Alte Kopie nicht gelöscht | Datei in `build/` prüfen — Framework-Inhalt entfernen |
| Doppelte Regeln (Framework + Projekt) | Projekt-Datei nicht reduziert | Basis-Header einfügen, Framework-Abschnitte entfernen |
