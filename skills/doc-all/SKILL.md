---
description: Generiert die Gesamtdokumentation (9 Dokumente + PDF-Export).
---

# Gesamtdokumentation generieren

Erstellt automatisch 9 professionelle Dokumente aus dem Code und den Projektdateien.

## Dokumente

| Nr | Dokument | Skill | Quelle |
|----|----------|-------|--------|
| 1 | Anwendungsbeschreibung | `/pyVGM-doc-anwendung` | Plan-Phase + PROJECT.md |
| 2 | Architektur | `/pyVGM-doc-architecture` | Code-Struktur + ARCHITECTURE.md |
| 3 | Datenmodell | `/pyVGM-doc-datenmodell` | SQLAlchemy-Models |
| 4 | Services & Blueprints | `/pyVGM-doc-services` | Python-Services + Views |
| 5 | Bildschirme | `/pyVGM-doc-screens` | Templates + Routes |
| 6 | Sequenzdiagramme | `/pyVGM-doc-sequences` | Ablauf-Analyse |
| 7 | Sicherheitsbericht | `/pyVGM-security-check` | Code-Analyse |
| 8 | Compliance-Bericht | `/pyVGM-compliance-report` | Architektur-Analyse |
| 9 | Code-Qualität | `/pyVGM-code-quality` | Code-Metriken |

## Ablauf

### 1. Dokumente generieren

Führe die Skills 1-9 nacheinander aus. Jedes Dokument wird als Markdown in `.Vorgehensmodell/dokumentation/` gespeichert.

### 2. README erstellen

Erstelle `.Vorgehensmodell/dokumentation/README.md` mit:
- Dokumenten-Index (Tabelle mit Titel, Datei, Letzte Aktualisierung)
- Generierungsdatum
- Version aus `pyproject.toml`

### 3. PDF-Export (optional)

Frage den Benutzer per AskUserQuestion ob PDFs generiert werden sollen.

Bei "Ja" → `/pyVGM-doc-pdf` für alle Dokumente ausführen.

## Regeln

- Frontmatter mit Titel, Datum, Version in jedem Dokument
- Mermaid-Diagramme in Fenced Code Blocks (```mermaid)
- Deutsche Umlaute korrekt (UTF-8)
- Nur Fakten aus dem Code — keine erfundenen Inhalte
