# Post-Install Anweisungen

Zeige dem User folgende Nachricht an und führe danach die Aufräumarbeiten aus.

## Nachricht anzeigen

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   ▄▀▄ ▄▀▀ ▄▀▀ ▄▀▀ ▄▀▄ █▄ █ ▄▀▀ ▄▀▄                            ║
║   █▀█ ▀▀▄ ▀▀▄ █   █ █ █ ▀█ ▀▀▄ █ █   pyVGM v{{VERSION}}       ║
║   ▀ ▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀  ▀ ▀▀▀ ▀▀▀   Python-Vorgehensmodell   ║
║                                                                  ║
║   ✅ {{SKILLS_COUNT}} Skills als /pyVGM-* verfügbar              ║
║                                                                  ║
║   Nächste Schritte:                                              ║
║   1. VS Code Fenster neu laden (Cmd+Shift+P → Reload Window)    ║
║   2. /pyVGM           → Alle Commands im Überblick              ║
║   3. /pyVGM-init-project → Projekt initialisieren               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

## Aufräumen

1. Lösche diese Datei (`post-install.md` im Projektverzeichnis)
2. Entferne den `## Post-Install` Abschnitt aus `CLAUDE.md` (falls vorhanden)
