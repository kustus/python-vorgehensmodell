---
description: Framework-Submodul aktualisieren mit Changelog und automatischer Migration.
---

# Framework-Update

Prüft ob ein Update für das Framework-Submodul verfügbar ist, zeigt die Änderungen aus dem Changelog, und führt nach Bestätigung das Update mit Migrationsschritten durch.

## Ablauf

### 1. Aktuellen Stand ermitteln

```bash
SUBMODULE=".basis-python-framework"
CURRENT=$(git -C "$SUBMODULE" rev-parse HEAD)
git -C "$SUBMODULE" fetch origin 2>/dev/null
LATEST=$(git -C "$SUBMODULE" rev-parse origin/main)
```

Falls `$CURRENT` = `$LATEST`:
> **Framework ist aktuell.** Kein Update verfügbar.

→ Ende.

### 2. Changelog-Diff anzeigen

Lies das CHANGELOG.md aus dem **neuen** Stand:
```bash
git -C "$SUBMODULE" show origin/main:CHANGELOG.md
```

Lies das CHANGELOG.md aus dem **aktuellen** Stand:
```bash
cat "$SUBMODULE/CHANGELOG.md"
```

Vergleiche beide Versionen. Zeige dem User **alle neuen Einträge** (die im neuen Stand dazugekommen sind, aber im aktuellen fehlen).

Format der Ausgabe:

```
╔══════════════════════════════════════════════════╗
║  Framework-Update verfügbar                      ║
╚══════════════════════════════════════════════════╝

Neue Änderungen seit letztem Update:

## 2026-XX-XX — Beschreibung
...

## 2026-XX-XX — Beschreibung
...

Migrationsschritte erforderlich: Ja/Nein
```

### 3. User fragen

> Soll das Framework aktualisiert werden?

**Nur bei expliziter Bestätigung weitermachen.**

### 4. Update durchführen

```bash
git submodule update --remote .basis-python-framework
bash .basis-python-framework/install.sh
```

Ergebnis von `install.sh` anzeigen.

### 5. Migrationsschritte ausführen

Lies alle `### Migration`-Abschnitte der neuen Changelog-Einträge. Führe die Schritte **in chronologischer Reihenfolge** aus (älteste zuerst).

Einträge mit `### Migration: Keine` überspringen.

**Wichtig:** Bei Schritten die Dateien ändern (Basis-Header einfügen, CLAUDE.md umstrukturieren etc.) — die Dateien lesen, verstehen was projektspezifisch ist, und nur die beschriebenen Änderungen durchführen.

### 6. Zusammenfassung

```
╔══════════════════════════════════════════════════╗
║  Update abgeschlossen                            ║
╚══════════════════════════════════════════════════╝

Commit: <alter-hash> → <neuer-hash>
Changelog-Einträge: X
Migrationsschritte ausgeführt: Y

Geänderte Dateien:
  - ...
```

### 7. Commit vorschlagen

> Soll ein Commit erstellt werden?

Falls ja:
```bash
git add .Vorgehensmodell/ CLAUDE.md .basis-python-framework
git commit -m "Framework-Update: <Changelog-Zusammenfassung>"
```
