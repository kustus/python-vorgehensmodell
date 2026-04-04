---
description: Initialisiert ein neues Python/Flask-Projekt nach dem Vorgehensmodell (Plan/Build/Run).
---

# Projekt initialisieren

Führe das Init-Script aus:

```bash
bash scripts/init-project.sh
```

## Ergebnis interpretieren

Nutze **ausschließlich** die Script-Ausgabe als Datenquelle. Erfinde keine Informationen dazu.

### Wenn "INITIALISIERT":

Lies die Werte aus der Ausgabe und die Template-Listen.

Gib zuerst eine Zusammenfassung mit:
- Verzeichnisbaum `.Vorgehensmodell/` mit den Zahlen und Template-Namen aus der Ausgabe
- Ob CLAUDE.md erstellt wurde und wie viele Skills verlinkt sind
- Gesamtzahl der erstellten Dateien

#### Framework-Guide anzeigen

Zeige den Link zum Framework-Guide und den Hinweis zur Preview:

```
Ausführliche Beschreibung aller Commands und des Frameworks:
```

Dann diesen Link (als Markdown, nicht als Code-Block):

[Framework-Guide öffnen](.Vorgehensmodell/FRAMEWORK-GUIDE.md)

Danach den Hinweis: **Tipp:** In VS Code mit **Cmd+Shift+V** die schöne Vorschau öffnen.

#### Projekt benennen

Frage den Benutzer per **AskUserQuestion-Dialog** (nicht per Text) mit **zwei Fragen** in einem Aufruf:

1. Frage: **"Wie heißt die Anwendung?"** — Header: "Projektname" — Optionen: Nur "Other" (keine vordefinierten Optionen, der Benutzer gibt den Namen frei ein)
2. Frage: **"Was soll die Anwendung grob tun?"** — Header: "Beschreibung" — Optionen: Nur "Other" (Freitext, 1-2 Sätze)

Mit den Antworten:
- Ersetze `{{PROJEKTNAME}}` in **allen** Dateien unter `.Vorgehensmodell/` und in `CLAUDE.md`
- Ersetze `{{PROJEKTBESCHREIBUNG}}` in **allen** Dateien unter `.Vorgehensmodell/` und in `CLAUDE.md`
- Verwende dafür `sed` oder direktes Editieren — alle Vorkommen in allen Dateien

#### Verzeichnis umbenennen (optional)

Vergleiche den eingegebenen Projektnamen mit dem aktuellen Verzeichnisnamen (`basename` des Arbeitsverzeichnisses). Wenn sie sich unterscheiden, frage den Benutzer per **AskUserQuestion-Dialog**:

Frage: "Das Verzeichnis heißt `<aktueller Name>`, das Projekt `<Projektname>`. Soll das Verzeichnis umbenannt werden?" — Header: "Umbenennen" — Optionen: "Ja, umbenennen" / "Nein, so lassen"

Wenn der Benutzer zustimmt:
1. Benenne das Verzeichnis um: `mv ../<alter Name> ../<neuer Name>` (Projektname in kebab-case — Kleinbuchstaben, Bindestriche statt Leerzeichen)
2. Zeige dem Benutzer folgende **Hinweise**:
   - Das Arbeitsverzeichnis hat sich geändert
   - VS Code muss den Workspace neu öffnen: **File > Open Folder** → neuen Pfad wählen
   - Diese Claude Code Session muss neu gestartet werden
   - Danach mit **/pyVGM-plan** weitermachen
3. **Beende die Ausgabe** nach diesen Hinweisen — keine weitere Frage stellen

Wenn der Benutzer ablehnt, weiter zur Plan-Phase.

#### Weiter zur Plan-Phase

Frage per **AskUserQuestion-Dialog** ob die Plan-Phase gestartet werden soll. Header: "Weiter" — Optionen: "/pyVGM-plan starten" / "Später"

### Wenn "BEREITS_INITIALISIERT":

Lies den Statusbericht und zeige:
- TEMPLATE = noch nicht ausgefüllt
- AUSGEFUELLT = bereits bearbeitet

Prüfe ob `{{PROJEKTNAME}}` noch als Platzhalter in `CLAUDE.md` oder `.Vorgehensmodell/` vorkommt. Falls ja, frage Name + Beschreibung per AskUserQuestion-Dialog ab und ersetze die Platzhalter.

Dann frage welche Phase/welches Dokument bearbeitet werden soll.
