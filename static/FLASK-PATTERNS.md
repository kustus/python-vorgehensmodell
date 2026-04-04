# Flask-Patterns — Erprobte Architektur-Patterns

Bewährte Patterns aus produktiven Flask-Projekten. Jedes Pattern enthält Kontext, Implementierung und Regeln.

---

## Pattern 1: Service-Schicht

### Wann verwenden?
Immer. Jede Flask-App trennt Routes (Orchestrierung) von Services (Fachlogik).

### Struktur
```
views.py          → Route nimmt Request entgegen, ruft Service auf, gibt JSON zurück
services/
├── beleg_service.py   → Fachlogik: Laden, Speichern, Validieren
└── export_service.py  → PDF-Generierung, Archivierung
```

### Regeln
| Verantwortung | Route | Service |
|---------------|-------|---------|
| HTTP-Request parsen | ✅ | ❌ |
| Fachlogik / Business Rules | ❌ | ✅ |
| Datenbank-Zugriff | ❌ | ✅ |
| JSON-Response bauen | ✅ | ❌ |
| Dateien lesen/schreiben | ❌ | ✅ |

### Beispiel
```python
# views.py — nur Orchestrierung
@app_bp.route("/api/belege/<int:id>/freigeben", methods=["POST"])
def beleg_freigeben(id):
    result = beleg_service.freigeben(id, request.json)
    return jsonify(result)

# services/beleg_service.py — Fachlogik
def freigeben(beleg_id: int, daten: dict) -> dict:
    beleg = db.session.get(Beleg, beleg_id)
    beleg.status = "FREIGEGEBEN"
    beleg.freigabe_datum = datetime.now()
    db.session.commit()
    return {"ok": True, "status": beleg.status}
```

---

## Pattern 2: State-Singleton (komplexe Formulare)

### Wann verwenden?
Bei Formularen mit vielen abhängigen Feldern, berechneten Werten und dynamischen Buchungszeilen.

### Konzept
Ein JavaScript-Datenobjekt als **Single Source of Truth** statt DOM-Lesen/Parsen.

```javascript
var BelegState = (function() {
    var s = null;  // State-Objekt
    function init(data) { s = data; renderAll(); }
    function set(key, value) { s[key] = value; renderAll(); }
    function renderAll() {
        // Alle UI-Elemente aus State ableiten
        // Hidden Field synchronisieren
        document.getElementById('buchungen_json').value = JSON.stringify(s.buchungen);
    }
    return { init, set, renderAll };
})();
```

### Regeln
- `set(key, value)` → aktualisiert State → `renderAll()` leitet alle UI-Elemente ab
- Hidden Field wird bei jedem Render synchronisiert
- Backend übernimmt bei Freigabe 1:1 die Daten aus dem Hidden Field
- **Business-Logik bleibt im Backend** — JS nur für Darstellung

---

## Pattern 3: SSE-Live-Updates

### Wann verwenden?
Wenn Hintergrundprozesse (Worker, KI-Analyse) laufen und die UI den Status live anzeigen soll. Kein Polling, kein WebSocket.

### Backend
```python
from queue import Queue

_sse_queues: list[Queue] = []

def sse_publish(event: str, data: dict):
    msg = f"event: {event}\ndata: {json.dumps(data)}\n\n"
    for q in _sse_queues:
        q.put(msg)

@app_bp.route("/api/events")
def sse_stream():
    q = Queue()
    _sse_queues.append(q)
    def generate():
        try:
            while True:
                msg = q.get(timeout=30)
                yield msg
        except:
            pass
        finally:
            _sse_queues.remove(q)
    return Response(generate(), mimetype="text/event-stream")
```

### Frontend
```javascript
const source = new EventSource('/api/events');
source.addEventListener('status_update', function(e) {
    const data = JSON.parse(e.data);
    // UI aktualisieren — z.B. Liste per fetch() nachladen
    fetch('/api/liste').then(r => r.text()).then(html => {
        document.getElementById('liste').innerHTML = html;
    });
});
```

### Regeln
- Kein voller Page-Reload bei Events
- Event-Handler laden nur das betroffene Partial nach
- Timeout 30s, Auto-Reconnect durch EventSource

---

## Pattern 4: 3-Stufen-Worker-Pipeline

### Wann verwenden?
Bei Hintergrundverarbeitung mit mehreren Phasen (z.B. Eingang → KI-Analyse → PDF-Generierung).

### Stufen
```
Stufe 1: EINGANG           → INSERT in DB + SSE-Event, non-blocking
Stufe 2: VERARBEITUNGS-WORKER (2s Poll) → KI-Analyse, Status: EMPFANGEN → ZUR_PRUEFUNG
Stufe 3: NACHARBEITEN-WORKER (5s Poll)  → PDF + Buchung, Status: FREIGEGEBEN → ABGESCHLOSSEN
```

### Regeln
- Event-Handler sind **non-blocking** (kein API-Call, kein Lock)
- **Ein Worker pro Stufe** (single-threaded, kein Lock nötig)
- Worker **pollt DB** (nicht feste Liste) — neue Einträge werden automatisch gefunden
- **Startup-Recovery:** Hängende Status (IN_BEARBEITUNG) beim Start zurücksetzen
- **Fehlerbehandlung:** Status → FEHLER + `fehler_typ` + `retry_count`. Manueller Retry über UI.

### Beispiel
```python
import threading, time

def verarbeitungs_worker():
    while True:
        eingang = db.session.query(Eingang).filter_by(status="EMPFANGEN").first()
        if eingang:
            eingang.status = "IN_BEARBEITUNG"
            db.session.commit()
            try:
                ergebnis = ki_analyse(eingang)
                eingang.status = "ZUR_PRUEFUNG"
            except Exception as e:
                eingang.status = "FEHLER"
                eingang.fehler_typ = str(e)
            db.session.commit()
        time.sleep(2)

threading.Thread(target=verarbeitungs_worker, daemon=True).start()
```

---

## Pattern 5: Config-Reload-Kette

### Wann verwenden?
Bei Projekten mit gemeinsamer Konfiguration über mehrere Services/Apps hinweg.

### Konzept
```
Config-Änderung in Admin-App
    │
    ├─→ Lokaler Reload
    │
    └─→ HTTP-Ping an alle anderen Apps:
         POST http://app1:PORT/api/reload-config
         POST http://app2:PORT/api/reload-config
```

### Implementierung
```python
@app_bp.route("/api/reload-config", methods=["POST"])
def reload_config():
    # Settings-Objekt im Speicher aktualisieren
    global _settings
    _settings = load_settings()
    return jsonify({"ok": True})
```

### Regeln
- Jede App hat `/api/reload-config`
- Fire-and-forget Pings (kein Fehler wenn App nicht erreichbar)
- Settings-Objekt im Speicher cachen, nicht bei jedem Request YAML lesen

---

## Pattern 6: Debug-Modus für destruktive Aktionen

### Wann verwenden?
Bei Apps mit persistierten Daten (DB, Dateien) die einen "Alle löschen"-Button brauchen (nur für Entwicklung).

### UI
```html
{% if debug_mode %}
<div class="card border-start border-danger border-4 mb-4">
    <div class="card-header">
        <h6 class="text-danger"><i class="bi bi-bug me-2"></i>Debug-Modus</h6>
    </div>
    <div class="card-body py-2">
        <button class="btn btn-sm btn-outline-danger" onclick="if(confirm('Wirklich alles löschen?')) fetch('/api/debug/delete-all', {method:'POST'})">
            <i class="bi bi-trash me-1"></i>Alle Einträge löschen
        </button>
    </div>
</div>
{% endif %}
```

### Regeln
- `debug_mode` aus Config, **nie hardcoded**
- API-Route prüft `debug`-Flag serverseitig (nie nur client-seitig)
- Gibt `403` zurück wenn Debug nicht aktiv
- `confirm()` Dialog vor dem Löschen

---

## Pattern 7: Zahlenformatierung (deutsch)

### Wann verwenden?
Bei jeder Anwendung die Zahlen anzeigt oder entgegennimmt (insbesondere Beträge).

### Schichten
| Schicht | Vorgehen |
|---------|----------|
| Python (Backend, PDF) | `format_betrag(value)` → `"1.234,56"` |
| Jinja2-Templates | `{{ wert\|de_zahl }}` Filter |
| JavaScript (Anzeige) | `n.toLocaleString('de-DE', {minimumFractionDigits: 2})` |
| JavaScript (Eingabe) | `parseFloat(input.value.replace(',', '.'))` |
| HTML-Inputs | `type="text" inputmode="decimal"` |

### Regeln
- **Nie** manuelles `.replace(".", ",")` — Babel `format_decimal` verwenden
- `type="number"` vermeiden (Browser-Validierung kollidiert mit deutschem Format)

---

## Pattern 8: Lazy Loading für Previews

### Wann verwenden?
Bei Listen mit Bild-Vorschauen (z.B. Beleg-Scans). Direktes `src` würde gunicorn-Worker blockieren.

```html
<img data-src="/api/preview/{{ id }}" class="lazy" style="max-height:60px">
```

```javascript
// IntersectionObserver für echtes Lazy Loading
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.src = entry.target.dataset.src;
            observer.unobserve(entry.target);
        }
    });
});
document.querySelectorAll('img.lazy').forEach(img => observer.observe(img));
```
