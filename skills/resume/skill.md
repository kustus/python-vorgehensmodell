---
description: Session-Briefing — Projekt-Kontext wiederherstellen, offene Punkte auflisten, nächste Schritte vorschlagen.
---

# Resume

Stellt den Projekt-Kontext am Anfang einer neuen Session wieder her. Liest die beim letzten `/checkpoint` gespeicherten Informationen und gibt ein kompaktes Briefing.

**Wann verwenden:** Am Anfang jeder neuen Session, oder wenn der Kontext verloren gegangen ist.

---

## Ablauf

### 1. Letzten Stand laden

Lies **parallel** (per Agent oder direkt):

- `.Vorgehensmodell/build/STATE.md` → "Aktuelle Arbeit" (erster Block), "Bekannte Probleme", "Offen:"-Einträge
- `MEMORY.md` → Index aller Projekt-Memories scannen (Typ `project` = offene Aufgaben)
- `git log --oneline -5` → letzte 5 Commits
- `pyproject.toml` → aktuelle Version(en)

### 2. Briefing ausgeben

Formatiere als kompakte Übersicht:

```
╔══════════════════════════════════════════════════╗
║  [Projektname] — Session-Briefing               ║
║  Letzter Commit: [hash] — [datum]                ║
╠══════════════════════════════════════════════════╣
║                                                  ║
║  Version: [app] v[X.Y.Z] / [common] v[X.Y.Z]   ║
║                                                  ║
║  Zuletzt implementiert:                          ║
║  ✓ [Feature 1 aus STATE.md]                      ║
║  ✓ [Feature 2]                                   ║
║  ✓ [Feature 3]                                   ║
║                                                  ║
║  Offene Punkte:                                  ║
║  1. [aus STATE.md "Offen:"]                      ║
║  2. [aus project_*.md Memories]                  ║
║  3. [aus "Bekannte Probleme"]                    ║
║                                                  ║
║  Bekannte Probleme:                              ║
║  ⚠ [Problem 1]                                   ║
║  ⚠ [Problem 2]                                   ║
║                                                  ║
║  Nächste Schritte (Vorschlag):                   ║
║  → [Dringendster Punkt]                          ║
║  → [Zweitwichtigster Punkt]                      ║
╚══════════════════════════════════════════════════╝
```

### 3. Nächste Schritte priorisieren

Sortiere die offenen Punkte nach:
1. **Blocker** — Dinge die den normalen Betrieb stören (z.B. IMAP-IDLE kaputt)
2. **Geplante Features** — aus STATE.md als "nächste Phase" markiert
3. **Nice-to-have** — Refactoring, Framework-Verbesserungen

### 4. Pflichtlektüre anbieten

Frage: **"Soll ich die Pflichtlektüre (CLAUDE.md Session-Start) laden?"**

Nur auf Bestätigung die Framework- und Projekt-Dateien lesen (spart Kontext wenn der User direkt weiterarbeiten will).

---

## Regeln

- **Kompakt bleiben** — das Briefing soll auf einen Bildschirm passen
- **Keine Dateien ändern** — nur lesen und zusammenfassen
- **Offene Punkte deduplizieren** — STATE.md und Memory können sich überlappen
- **Prioritäten vorschlagen, nicht diktieren** — der User entscheidet was als nächstes kommt
- **Git-Status zeigen** — falls uncommitted Changes vorhanden, darauf hinweisen
