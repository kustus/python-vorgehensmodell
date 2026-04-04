---
description: PDF-Export der Dokumentation mit Corporate Design.
---

# PDF-Export

Konvertiert Markdown-Dokumentation zu PDF mit Corporate Design.

## Voraussetzungen

```bash
npm install -g md-to-pdf @mermaid-js/mermaid-cli
```

## Ablauf

### 1. Mermaid-Diagramme rendern

Suche alle `.md`-Dateien in `.Vorgehensmodell/dokumentation/` nach Mermaid-Blöcken.

Für jeden Block:
```bash
echo '<mermaid-code>' | npx mmdc -i - -o diagram-N.png -t neutral -b transparent
```

Ersetze den Mermaid-Block durch `![Diagramm](diagram-N.png)` im Markdown.

### 2. Frontmatter einfügen

Jede Markdown-Datei bekommt ein PDF-Frontmatter (falls nicht vorhanden):

```yaml
---
pdf_options:
  format: A4
  margin: 25mm
  headerTemplate: '<div style="font-size:8px;width:100%;text-align:center;color:#999;">{{PROJEKTNAME}} — Dokumentation</div>'
  footerTemplate: '<div style="font-size:8px;width:100%;text-align:right;color:#999;padding-right:25mm;">Seite <span class="pageNumber"></span> von <span class="totalPages"></span></div>'
  displayHeaderFooter: true
stylesheet: pdf-style.css
---
```

### 3. Logo einfügen

Am Anfang jedes Dokuments (nach Frontmatter, vor erstem Header):

```markdown
![Logo](assconso-logo.png)
```

### 4. PDF generieren

```bash
cd .Vorgehensmodell/dokumentation/
npx md-to-pdf <datei>.md --stylesheet pdf-style.css
```

### 5. Zusammenfassung

Zeige:
- Anzahl generierter PDFs
- Dateipfade
- Gesamtgröße

## Regeln

- Deutsche Umlaute prüfen (ä/ö/ü/ß müssen korrekt dargestellt werden)
- PDF/A-Konformität ist **nicht** erforderlich für Dokumentation (nur für Buchhaltungsbelege)
- Mermaid-Diagramme als PNG einbetten (md-to-pdf kann kein Mermaid nativ)
