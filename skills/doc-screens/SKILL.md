---
description: Bildschirm-Dokumentation (Mockups, Feldtabellen, Validierung).
---

# Bildschirm-Dokumentation

Dokumentiert alle Bildschirme/Seiten der Anwendung.

## Inhalt

Für jeden Bildschirm (Jinja2-Template):

### Steckbrief

| Feld | Wert |
|------|------|
| Name | Dashboard / Settings / ... |
| Template | `templates/dashboard.html` |
| Route | `GET /` |
| Rolle | Alle / Admin |
| Beschreibung | ... |

### Mockup (ASCII oder Beschreibung)

```
┌─────────────────────────────────────────────┐
│ [Logo]  App-Name            [User ▼]        │
├─────────────────────────────────────────────┤
│ ┌─── KPI-Karten ──────────────────────────┐ │
│ │ [Gesamt: 42]  [Offen: 5]  [Fehler: 1]  │ │
│ └─────────────────────────────────────────┘ │
│                                             │
│ ┌─── Tabelle ─────────────────────────────┐ │
│ │ Nr  │ Datum  │ Betrag │ Status │ Aktion │ │
│ │ 001 │ 01.03. │ 42,50  │ ✅     │ [→]    │ │
│ │ 002 │ 02.03. │ 18,90  │ ⏳     │ [→]    │ │
│ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

### Feld-Tabelle (bei Formularen)

| Feld | Typ | Pflicht | Validierung | Beschreibung |
|------|-----|---------|-------------|-------------|
| Name | Text | Ja | min. 2 Zeichen | Vollständiger Name |
| Betrag | Dezimal | Ja | > 0, max. 2 NK | Betrag in EUR |
| Datum | Datum | Ja | nicht in Zukunft | Belegdatum |

### Business-Logik

Welche Aktionen sind auf diesem Bildschirm möglich? Was passiert bei Klick?

## Ausgabe

Schreibe nach `.Vorgehensmodell/dokumentation/05-bildschirme.md`.

## Regeln

- Alle Templates aus dem `templates/`-Verzeichnis erfassen
- Mockups als ASCII-Art (lesbar in Markdown)
- Validierungsregeln aus dem Code extrahieren (Backend + Frontend)
- Bootstrap-Komponenten erwähnen (Cards, Tables, Modals)
