# Framework-Backlog

Ideen und Verbesserungen am **Entwicklungsframework** selbst — also an Commands, Scripts, Prüfprozessen, Dokumentationspipeline und Projektstruktur. Nicht projektspezifisch, sondern übertragbar auf andere Projekte.

---

## Schutz & Governance

| # | Idee | Beschreibung | Aufwand |
|---|------|-------------|---------|
| F1 | Schreibschutz für Vorgaben | `.claude/commands/` und `.Vorgehensmodell/build/*.md` vor Benutzeränderungen schützen (permissions.deny in settings.json, CODEOWNERS, oder CLAUDE.md-Regel) | Gering |
| F2 | Managed Settings | Unternehmensweite Claude-Code-Konfiguration über MDM verteilen (managed-settings.json) — einheitliche Konventionen über Projekte hinweg | Mittel |
| F3 | Differenzierte Schreibrechte | Commands dürfen bestimmte Dateien ändern, Benutzer nicht direkt — Whitelist-Ansatz statt Blacklist | Mittel |
| F4 | Änderungsprotokoll für Vorgaben | Automatisches Logging wenn `.Vorgehensmodell/build/` oder `.claude/commands/` geändert werden (Git Hook oder Claude Hook) | Gering |

## Qualitätssicherung

| # | Idee | Beschreibung | Aufwand |
|---|------|-------------|---------|
| F5 | Automatisiertes Prüfscript | `/check-planning-req` als Bash-Script statt Agent-Aufruf — deterministisch, schneller, keine LLM-Interpretation | Mittel |
| F6 | Konventions-Linter | Eigenes Script das alle Code-Konventionen prüft (ruff-Regeln, Service-Schicht, Pflicht-Endpunkte) — unabhängig von ruff | Mittel |
| F7 | Pre-Commit Hook für Konventionen | Automatische Prüfung bei jedem Commit — nicht nur bei Deploy | Gering |
| F8 | Regressions-Tests für Commands | Tests die prüfen ob `/deploy`, `/doc-all` etc. korrekt ablaufen (Dry-Run-Modus) | Hoch |

## Dokumentation

| # | Idee | Beschreibung | Aufwand |
|---|------|-------------|---------|
| F9 | Umlaut-Fixer als dauerhaftes Script | Python-Script für Umlaut-Korrektur als `.claude/scripts/fix-umlauts.py` — wiederverwendbar, nicht jedes Mal neu schreiben | Gering |
| F10 | Dokumentations-Diff | Bei `/doc-all` nur geänderte Dokumente neu generieren statt alle 9 | Mittel |
| F11 | Automatische Versionierung in Docs | Version aus pyproject.toml automatisch in alle Dokumente einfügen (Script statt manuell) | Gering |
| F12 | Deckblatt-Template | Eigene erste Seite mit Logo, Titel, Version, Datum — statt Logo vor H1 | Mittel |
| F13 | Inhaltsverzeichnis in PDFs | FPDF2 mit TOC oder manuelles TOC generieren | Mittel |

## Release-Management

| # | Idee | Beschreibung | Aufwand |
|---|------|-------------|---------|
| F14 | CHANGELOG automatisch generieren | Aus Git-Commits oder RELEASE-PLAN.md den Changelog automatisch erstellen | Mittel |
| F15 | Versionsvergleich | Command der zeigt was sich zwischen zwei Versionen geändert hat (Code-Diff + Feature-Diff) | Mittel |
| F16 | Release-Artefakte archivieren | Alte Docker-Images taggen und aufheben statt überschreiben | Gering |
| F17 | Smoke-Test nach Deploy | Automatischer HTTP-Call gegen den Health-Endpunkt um zu prüfen ob die App läuft | Hoch |

## Projektstruktur

| # | Idee | Beschreibung | Aufwand |
|---|------|-------------|---------|
| F18 | Template-Repository | Dieses Framework (Commands, Scripts, .planning-Struktur) als Template-Repo für neue Projekte | Mittel |
| F19 | .Vorgehensmodell/build/ als pip-Paket | Vorgaben und Prüfscripts als wiederverwendbares Paket das in jedes Projekt eingebunden wird | Hoch |
| F20 | SessionStart-Hook | Automatische Prüfung beim Session-Start ob alle Pflichtdateien aktuell sind | Gering |

## Tests

| # | Idee | Beschreibung | Aufwand |
|---|------|-------------|---------|
| F21 | Test-Coverage-Report | pytest Coverage-Report generieren und im Release-Report aufnehmen | Gering |
| F22 | Integrationstests mit Test-Client | Flask test_client() für Route-Tests | Mittel |
| F23 | Docker-Tests | Prüfen ob Container korrekt startet und Health-Check besteht | Mittel |
