---
description: Release-Planung verwalten (neue Version, Backlog, Feature-Zuordnung).
---

# Release-Planung

Verwaltet die Zuordnung von Features zu Versionen.

## Argumente

| Argument | Beschreibung |
|----------|-------------|
| *(keins)* | Aktuelle Release-Planung anzeigen |
| `new` | Neue Version planen (Features aus Backlog auswählen) |
| `backlog` | Backlog verwalten (hinzufügen, priorisieren, entfernen) |

## Übersicht (`/pyVGM-release-plan`)

Lies `.Vorgehensmodell/build/RELEASE-PLAN.md` und zeige:
- Geplante Versionen mit zugeordneten Features
- Backlog (nicht zugeordnete Features)
- Aktuelle Version aus `pyproject.toml`

## Neue Version (`/pyVGM-release-plan new`)

1. Zeige den Backlog
2. Frage welche Features in die nächste Version sollen
3. Frage die Versionsnummer (Vorschlag: nächster Minor/Patch)
4. Aktualisiere RELEASE-PLAN.md

## Backlog (`/pyVGM-release-plan backlog`)

1. Zeige aktuellen Backlog
2. Frage: Hinzufügen / Priorisieren / Entfernen
3. Aktualisiere RELEASE-PLAN.md

## Dateiformat

```markdown
## v0.6.0 (geplant)
- [ ] Feature A
- [ ] Feature B

## v0.5.0 (aktuell)
- [x] Feature C
- [x] Feature D

## Backlog
- Feature E (Hoch)
- Feature F (Mittel)
- Feature G (Niedrig)
```
