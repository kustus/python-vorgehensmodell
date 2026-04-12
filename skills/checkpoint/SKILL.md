---
description: Session-Checkpoint — STATE.md aktualisieren, Memory sichern, Commit + Push.
---

# Checkpoint

Sichert den aktuellen Arbeitsstand: Dokumentation, Memory und Git. Läuft nach **einer einzigen Auswahl** vollautomatisch durch.

**Wann verwenden:** Am Ende einer Arbeitssession, vor einem Themenwechsel, oder wenn der Kontext zu groß wird.

---

## Ablauf

### Phase 1: Alles sammeln (READ-ONLY, parallel)

1. STATE.md lesen
2. `git status --short` + `git diff --stat HEAD`
3. MEMORY.md lesen (Duplikate vermeiden)
4. Submodul-Status prüfen (`.basis-python-framework/`)
5. Session-Änderungen zusammenfassen

### Phase 2: Eine AskUserQuestion mit Vorschau (einzige Interaktion!)

**Direkt per AskUserQuestion** mit Preview-Feature — die Optionen enthalten die vollständige Vorschau als Preview:

**Frage:** "Checkpoint-Modus wählen:"
**Optionen mit Preview:**
1. **Commit + Push** (Recommended) — Preview zeigt: STATE.md-Änderungen, Memory-Einträge, Dateiliste, Commit-Message
2. **Nur Commit** — Preview wie Option 1, ohne Push
3. **Nur STATE.md + Memory** — Kein Git

Jede Option zeigt im Preview exakt was passieren wird. So sieht der User den Vorschlag UND wählt in einem Schritt.

### Phase 3: Ausführen (OHNE weitere Fragen)

Nach Auswahl alles in einem Rutsch:

1. STATE.md aktualisieren (neuen Block oben einfügen, nicht neu schreiben)
2. Memory-Dateien schreiben/aktualisieren + MEMORY.md Index
3. Submodul committen (wenn Änderungen)
4. `git add` (relevante Dateien, keine Secrets)
5. `git commit` mit der vorgeschlagenen Message
6. `git push` (nur bei Option 1)
7. Kurze Bestätigung: `Checkpoint gesichert. Commit: [hash]`

---

## Regeln

- **Genau 1 AskUserQuestion** — enthält die Preview, danach keine Fragen mehr
- **STATE.md:** Session-Block oben einfügen, nicht die ganze Datei neu schreiben
- **Memory sparsam** — nur wirklich neue Erkenntnisse, keine Duplikate
- **Commit-Message:** Deutsch, fasst die Session zusammen
- **Keine Secrets commiten** — .env, Passwörter, API-Keys, CREDENTIALS.md prüfen
- **Submodul:** Immer prüfen, bei Änderungen zuerst dort committen
