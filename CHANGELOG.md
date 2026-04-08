# Changelog — Python-Vorgehensmodell

Neueste Änderungen oben. Jeder Eintrag enthält einen **Migration**-Abschnitt mit konkreten Schritten für bestehende Projekte.

---

## 2026-04-07 — Neuer Skill: `/pyVGM-resume` (Session-Briefing)

Neuer Skill der am Anfang einer Session den Projekt-Kontext wiederherstellt. Liest STATE.md, Memory, Git-Log und gibt ein kompaktes Briefing mit offenen Punkten und Prioritätsvorschlägen.

Deploy-Hook: `exit 1` statt nur Hinweis (blockiert tatsächlich).

### Migration
1. `cp .basis-python-framework/skills/resume/ .claude/skills/pyVGM-resume/` (oder `/pyVGM-update` ausführen)
2. Deploy-Hook in `.claude/settings.local.json` prüfen — sollte `exit 1` enthalten

---

## 2026-04-06 — Datenbank-Konvention: Eine DB pro App

ARCHITECTURE.md: Neuer Abschnitt "Datenbank-Konvention" — jede App hat genau eine SQLite-DB unter `data/app.db`. Kein Cross-App DB-Zugriff, nur über HTTP-APIs.

### Migration
1. App-eigene DB nach `data/app.db` umbenennen (Auto-Migration beim Start implementieren)
2. Env-Variable `APP_DB_PATH` statt app-spezifischer Variablen
3. Verwaiste/leere DB-Dateien löschen

---

## 2026-04-06 — UI-Partials als Architektur-Vorgabe

ARCHITECTURE.md: Neuer Abschnitt "Wiederverwendbare UI-Komponenten (Partials)" — komplexere UI-Elemente als Jinja2-Partial mit zugehöriger API-Route implementieren. Code-Quality-Skill: Neuer Prüfpunkt "UI-Partial-Kandidaten" erkennt duplizierte UI-Elemente in Templates.

### Migration: Keine
Bestehende Projekte profitieren automatisch bei nächster Code-Quality-Prüfung.

---

## 2026-04-05 — doc-pdf Assets über framework-links

doc-pdf Skill referenziert pdf-style.css und assconso-logo.png jetzt aus `framework-links/` statt `dokumentation/`.

### Migration: Keine
Wird automatisch durch das Skill-Update wirksam.

---

## 2026-04-05 — framework-links Konzept

Framework-Dateien (DEVELOPMENT-GUIDELINES, ARCHITECTURE, RELEASE-MANAGEMENT, FLASK-KNOWHOW, FLASK-PATTERNS, FRAMEWORK-GUIDE, Assets) werden jetzt über Symlinks in `framework-links/` bereitgestellt statt als Kopien. Neue Dateien: `CLAUDE.md` (Framework-Konventionen), `FRAMEWORK-BACKLOG.md`, `MIGRATION-FRAMEWORK-LINKS.md`.

### Migration
1. `bash .basis-python-framework/install.sh` ausführen — erstellt `framework-links/`, löscht alte Kopien automatisch
2. Falls `build/FRAMEWORK-GUIDE.md` noch existiert: löschen
3. `build/DEVELOPMENT-GUIDELINES.md`: Basis-Header einfügen, Framework-Inhalte entfernen (alles was in `framework-links/DEVELOPMENT-GUIDELINES.md` steht)
4. `build/ARCHITECTURE.md`: Basis-Header einfügen (Inhalt ist fast komplett projektspezifisch)
5. `build/RELEASE-MANAGEMENT.md`: Basis-Header einfügen
6. `CLAUDE.md`: Pflichtlektüre aufteilen in "Framework-Vorgaben (framework-links/)" und "Projekt-Dateien (build/)", generische Regeln entfernen (stehen jetzt in Framework-CLAUDE.md)
7. Falls `dokumentation/pdf-assets/` existiert: löschen (Assets jetzt über framework-links/)
