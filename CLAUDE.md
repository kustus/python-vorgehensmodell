# Python-Vorgehensmodell — Framework-Konventionen

> Diese Datei wird automatisch von Claude Code gelesen und gilt für **alle Projekte**, die dieses Framework als Submodul einbinden.

**Sprache:** Alle Antworten und Kommentare auf **Deutsch**.

## Verbindliche Projektvorgaben

Die folgenden Regeln sind **nicht optional**. Sie gelten für jede Änderung an jedem Projekt, das dieses Framework verwendet.

### Slash-Commands ausführen — nicht darüber reden

Wenn der Benutzer einen Slash-Command aufruft (z.B. `/deploy`, `/doc-all`, `/plan`), dann den Command **exakt nach seiner Skill-Definition ausführen**. Nicht zusammenfassen was getan werden müsste, nicht fragen ob gestartet werden soll, nicht erklären was der Command tut — sondern ihn **tun**. Der Command-Inhalt definiert die Schritte, diese sind auszuführen.

### Bei Widerspruch: Warnen statt ignorieren

Wenn eine Benutzeranfrage gegen eine der Vorgaben verstößt:
1. **Den Widerspruch benennen**
2. **Die Vorgabe zitieren** — Datei + Regel
3. **Alternative vorschlagen**
4. **Nur auf ausdrückliche Bestätigung** die Vorgabe brechen

### Framework-Dateien sind read-only

Dateien in `.Vorgehensmodell/framework-links/` sind **Symlinks ins Framework** und dürfen nicht editiert werden. Projektspezifische Ergänzungen gehören in die gleichnamige Datei unter `.Vorgehensmodell/build/`.

## Session-Start: Pflichtlektüre

**Vor jeder inhaltlichen Arbeit** diese Dateien lesen:

### Framework-Vorgaben (`.Vorgehensmodell/framework-links/`)
1. [DEVELOPMENT-GUIDELINES.md](.Vorgehensmodell/framework-links/DEVELOPMENT-GUIDELINES.md) — Code-Konventionen, Architektur-Regeln
2. [ARCHITECTURE.md](.Vorgehensmodell/framework-links/ARCHITECTURE.md) — Tech-Stack, UI-Konventionen
3. [RELEASE-MANAGEMENT.md](.Vorgehensmodell/framework-links/RELEASE-MANAGEMENT.md) — Versionierung, Deploy-Modi
4. [FLASK-KNOWHOW.md](.Vorgehensmodell/framework-links/FLASK-KNOWHOW.md) — Flask-Fallstricke & Best Practices
5. [FLASK-PATTERNS.md](.Vorgehensmodell/framework-links/FLASK-PATTERNS.md) — Erprobte Flask/Jinja2-Patterns

### Projekt-Dateien (`.Vorgehensmodell/build/`)
Werden in der Projekt-CLAUDE.md aufgelistet.

## Unverletzliche Code-Konventionen (Python/Flask)

Kurzfassung — Details in [DEVELOPMENT-GUIDELINES.md](.Vorgehensmodell/framework-links/DEVELOPMENT-GUIDELINES.md):

- **Python 3.10+:** Type Hints, PEP 8 (ruff), snake_case
- **Kein** Raw SQL mit String-Formatierung, `app.run()` in Produktion, globale Pakete
- **Alle** DB-Zugriffe über SQLAlchemy ORM
- **Fachlogik** in `services/` auslagern — testbar ohne Flask-Context
- **Pakete** immer im `.venv` installieren
- **Pflicht-Endpunkte:** `/api/health`, `/manifest`, `/api/reload-config`
- **Fehlerbehandlung:** Alle Service-Methoden mit try/except + deutsche Fehlermeldungen

## Kontexthygiene

Der Hauptkontext muss schlank bleiben. Schwere Arbeit an Agents delegieren.

### Pflicht: Agents nutzen für
- **Codebase-Recherche** (mehr als 2-3 Dateien lesen) → `subagent_type: Explore`
- **Code-Generierung** ganzer Dateien oder Module → Agent mit Write-Berechtigung
- **Reviews & Checks** (Quality, Security, Flask) → Agent liefert nur Ergebnis zurück
- **Dokumentation generieren** → Agent schreibt, Hauptkontext koordiniert

### Verboten im Hauptkontext
- Große Dateien direkt lesen (> 200 Zeilen) — Agent nutzen
- Breite Grep-Suchen über die gesamte Codebase — Agent nutzen
- Mehrere Dateien nacheinander lesen um "einen Überblick zu bekommen" — Agent nutzen

### Worktree-Isolation
Bei riskanten Änderungen Agents mit `isolation: "worktree"` starten.

## Deploy-Workflow

Vier Modi — Details in [RELEASE-MANAGEMENT.md](.Vorgehensmodell/framework-links/RELEASE-MANAGEMENT.md):

- **`/deploy`** — Schnell: Version → Build → Deploy (Standard für Dev-Iterationen)
- **`/deploy full`** — Vollständig: Tests → Version → Build → Deploy → Git Tag
- **`/deploy pre-prod`** — Übergabepaket: Tests → Konsistenzprüfung → Build → Docs → Image + PDFs
- **`/deploy prod`** — Produktion: Wie full + Produktions-Host + CHANGELOG

## Tests

- **`/test`** — Unit Tests ausführen (`python -m pytest tests/ -v`)
- Tests sind **Pflicht vor jedem formalen Deploy** (nicht bei `/deploy`)
- Neue Geschäftslogik in `services/` **muss** Tests haben
- Testdateien in `tests/` Verzeichnis
