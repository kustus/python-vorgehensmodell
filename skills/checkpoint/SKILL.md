---
description: Session-Checkpoint — STATE.md aktualisieren, Memory sichern, Commit + Push.
---

# Checkpoint

Sichert den aktuellen Arbeitsstand: Dokumentation, Memory und Git.

**Wann verwenden:** Am Ende einer Arbeitssession, vor einem Themenwechsel, oder wenn der Kontext zu groß wird.

---

## Ablauf

### 1. STATE.md aktualisieren

Lies `.Vorgehensmodell/build/STATE.md` und aktualisiere:

- **Aktuelle Arbeit:** Was wurde in dieser Session implementiert? (Features, Bugfixes, Refactoring)
- **Entscheidungen:** Neue Architektur- oder Design-Entscheidungen (mit Datum + Begründung)
- **Bekannte Probleme:** Neue Bugs oder offene Punkte
- **Geklärte Fragen:** Fragen die in dieser Session beantwortet wurden

Zeige dem Benutzer die geplanten Änderungen an STATE.md und warte auf Bestätigung bevor du schreibst.

### 2. Memory aktualisieren

Prüfe ob es neue Erkenntnisse gibt die in Memory gespeichert werden sollten:

- **Projekt-Memory:** Neue Architekturentscheidungen, Konventionen, Infrastruktur-Änderungen
- **Feedback-Memory:** Korrekturen oder bestätigte Vorgehensweisen vom Benutzer
- **Referenz-Memory:** Neue externe Ressourcen oder API-Erkenntnisse

Zeige dem Benutzer die geplanten Memory-Einträge und warte auf Bestätigung.

### 3. Git Status + Diff

Zeige:
- `git status` — welche Dateien geändert/neu
- Zusammenfassung der Änderungen (keine vollständigen Diffs, nur Dateinamen + kurze Beschreibung)
- Anzahl geänderter Dateien, eingefügte/gelöschte Zeilen

Frage den Benutzer: **"Soll ich committen?"**

### 4. Commit

Nur nach expliziter Bestätigung:

- Stage alle relevanten Dateien (keine Secrets, keine .env)
- Erstelle eine aussagekräftige Commit-Message auf Deutsch
- Format: `feat/fix/refactor/docs: Kurzbeschreibung` + Details im Body
- Co-Authored-By Header

### 5. Push

Nur nach **separater** expliziter Bestätigung:

- Frage: **"Soll ich auf remote pushen?"**
- `git push`

---

## Wichtige Regeln

- **Jeder Schritt einzeln bestätigen** — nicht alles auf einmal durchführen
- **STATE.md erst zeigen, dann schreiben** — der Benutzer entscheidet was rein kommt
- **Memory sparsam** — nur wirklich neue Erkenntnisse, keine Duplikate
- **Commit-Message soll die Session zusammenfassen**, nicht einzelne Änderungen auflisten
- **Keine Secrets commiten** — .env, Passwörter, API-Keys prüfen
