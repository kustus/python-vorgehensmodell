---
description: Session-Checkpoint — STATE.md aktualisieren, Memory sichern, Commit + Push.
---

# Checkpoint

Sichert den aktuellen Arbeitsstand: Dokumentation, Memory und Git.

**Wann verwenden:** Am Ende einer Arbeitssession, vor einem Themenwechsel, oder wenn der Kontext zu groß wird.

---

## Ablauf

### Phase 1: Alles sammeln (READ-ONLY)

**Parallel** die folgenden Informationen zusammentragen — KEINE Dateien ändern:

1. **STATE.md lesen** — aktuellen Stand kennen
2. **Git Status + Diff** — `git status`, `git diff --stat`, geänderte Dateien auflisten
3. **Memory-Index lesen** — bestehende Memories kennen, Duplikate vermeiden
4. **Session-Änderungen zusammenfassen** — was wurde implementiert, welche Entscheidungen

### Phase 2: Vorschlag präsentieren (EINE Frage, ALLES auf einmal)

Dem Benutzer **einen einzigen, vollständigen Vorschlag** zeigen:

```
═══ CHECKPOINT-VORSCHLAG ═══

📄 STATE.md — Geplante Änderungen:
  [Vorschau der Aktualisierungen, kompakt]

🧠 Memory — Neue/aktualisierte Einträge:
  [Liste der geplanten Memory-Einträge oder "Keine neuen Memories"]

📦 Git — XX Dateien geändert:
  [Dateiliste, Commit-Message-Vorschlag]

🚀 Push: ja/nein

═══════════════════════════════

Änderungen OK? (Anpassen oder bestätigen)
```

Der Benutzer antwortet **einmal** — z.B. "ja", "ohne Push", "Memory X weglassen", etc.

### Phase 3: Ausführen (OHNE weitere Fragen)

Nach Bestätigung alles in einem Rutsch durchführen:

1. STATE.md schreiben
2. Memory-Dateien schreiben/aktualisieren + MEMORY.md Index
3. `git add` (relevante Dateien, keine Secrets)
4. `git commit` mit der vorgeschlagenen Message
5. `git push` (nur wenn im Vorschlag bestätigt)
6. Kurze Bestätigung: "Checkpoint gesichert. Commit: [hash]"

---

## Regeln

- **Maximal 1 Interaktion** — alles in Phase 2 zeigen, nach Bestätigung durchlaufen
- **STATE.md:** Session-Änderungen oben einfügen, nicht die ganze Datei neu schreiben
- **Memory sparsam** — nur wirklich neue Erkenntnisse, keine Duplikate
- **Commit-Message:** Deutsch, fasst die Session zusammen (nicht einzelne Änderungen)
- **Keine Secrets commiten** — .env, Passwörter, API-Keys, CREDENTIALS.md prüfen
- **Push nur wenn bestätigt** — Default-Vorschlag: ja (kann der User ablehnen)
- **Submodul prüfen:** Immer `git status` im Framework-Submodul (`.basis-python-framework/`) prüfen. Wenn dort Änderungen vorliegen: zuerst im Submodul committen, dann im Hauptrepo die Submodul-Referenz updaten (`git add .basis-python-framework`). Beides im Vorschlag anzeigen.
