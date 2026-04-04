---
description: Migriert ein bestehendes Flask-Projekt ins pyVGM-Framework.
---

# Bestehendes Projekt migrieren

Analysiert ein bestehendes Flask-Projekt und erstellt die `.Vorgehensmodell/`-Struktur mit vorausgefüllten Dokumenten.

## Ablauf

### 1. Projekt analysieren

Untersuche das Projekt:

- `pyproject.toml` / `setup.py` / `requirements.txt` → Dependencies, Version, Name
- Flask `create_app()` → Blueprints, Extensions
- `src/` oder Hauptpaket → Module, Services, Models
- `templates/` → Bildschirme, Seitenstruktur
- `Dockerfile` → Deployment-Konfiguration
- `docker-compose.yml` → Services, Netzwerk
- SQLAlchemy-Models → Datenmodell
- Tests → Testabdeckung
- Git-Log → Aktivität, Contributors

### 2. Analyse-Bericht erstellen

Zeige dem Benutzer:

```
=== PROJEKT-ANALYSE ===

📦 Name: meine-app (v0.5.0)
🐍 Python: 3.11
🌶️ Flask: 3.0.3

📁 Struktur:
   12 Python-Module
   8 Templates
   3 Services
   5 Models
   2 Blueprints

🧪 Tests: 15 Tests in 4 Dateien
🐳 Docker: Dockerfile + docker-compose.yml vorhanden

📋 Fehlende Best Practices:
   ⚠️ Kein /api/health Endpunkt
   ⚠️ Kein Context Processor für 'now'
   ⚠️ APP_VERSION hardcoded
```

### 3. .Vorgehensmodell/ erstellen

Erstelle die Struktur und fülle automatisch aus:

- **PROJECT.md** → Aus README.md, pyproject.toml
- **ARCHITECTURE.md** → Aus Code-Analyse (Blueprints, Services, Models)
- **REQUIREMENTS.md** → Aus Code-Features (implementiert = abgehakt)
- **STATE.md** → Aus Git-Log + bekannten TODOs
- **DEVELOPMENT-GUIDELINES.md** → Aus erkannten Patterns

### 4. CLAUDE.md erstellen

Generiere CLAUDE.md aus dem Template, angepasst an das Projekt.

### 5. Empfehlungen

Zeige Verbesserungsvorschläge:
- Fehlende Pflicht-Endpunkte
- Fehlender Context Processor
- Hardcoded Version
- Fehlende Service-Schicht

## Regeln

- **Kein Code ändern!** Nur analysieren und dokumentieren
- Bestehende Dateien nicht überschreiben (fragen wenn CLAUDE.md existiert)
- Nur Fakten aus dem Code — nichts erfinden
