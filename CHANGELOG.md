# Changelog — Python-Vorgehensmodell

Neueste Änderungen oben. Jeder Eintrag enthält einen **Migration**-Abschnitt mit konkreten Schritten für bestehende Projekte.

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
