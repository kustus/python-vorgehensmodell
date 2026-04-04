# Flask Know-How — Bekannte Fallstricke & Best Practices

Gesammelt aus Praxiserfahrung mit Flask-Projekten. Diese Probleme sind nicht offensichtlich aus der Flask-Dokumentation und kosten sonst Stunden.

---

## 1. Jinja2: `request.url.hostname` ist immer leer

**Problem:** `request.url.hostname` gibt in Jinja2-Templates immer `None` zurück.

**Lösung:** `request.host.split(':')[0]` verwenden.

```html
<!-- FALSCH -->
<a href="http://{{ request.url.hostname }}:5010/settings">

<!-- RICHTIG -->
<a href="http://{{ request.host.split(':')[0] }}:5010/settings">
```

---

## 2. Context Processor: `now` für base.html

**Problem:** `base.html` verwendet `{{ now.year }}` im Footer. Ohne Context Processor → `UndefinedError` auf jeder Seite.

**Lösung:** Immer `now` injizieren:

```python
@app.context_processor
def inject_globals():
    return {"now": datetime.datetime.now(), "app_version": APP_VERSION}
```

---

## 3. CDN-Scripts: Kein `integrity`-Attribut

**Problem:** Safari blockiert Scripts komplett wenn der SRI-Hash nicht stimmt (z.B. nach CDN-Update).

**Lösung:** `integrity` und `crossorigin` weglassen:

```html
<!-- FALSCH -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-..." crossorigin="anonymous"></script>

<!-- RICHTIG -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
```

---

## 4. Google Fonts: DSGVO-Falle

**Problem:** Google Fonts über CDN einbinden überträgt IP-Adressen an Google. Seit 2022 gibt es dafür Abmahnungen in Deutschland.

**Lösung:** Schriften lokal als WOFF2 ausliefern.

```css
/* FALSCH */
@import url('https://fonts.googleapis.com/css2?family=Roboto');

/* RICHTIG */
@font-face {
    font-family: 'Roboto';
    src: url('/static/fonts/roboto-regular.woff2') format('woff2');
}
```

---

## 5. HTML-Inputs für Zahlen: `type="text"` statt `type="number"`

**Problem:** `type="number"` verwendet Punkt als Dezimaltrenner. In Deutschland wird Komma erwartet. Browser-Validierung kollidiert mit deutschem Format.

**Lösung:**
```html
<input type="text" inputmode="decimal" placeholder="z.B. 1.234,56">
```

JavaScript zum Parsen: `parseFloat(input.value.replace(',', '.'))`

---

## 6. Bootstrap `d-flex` verstecken

**Problem:** `style.display = 'none'` funktioniert nicht bei Elementen mit Bootstrap-Klasse `d-flex`, weil `d-flex` `!important` hat.

**Lösung:** `d-none` Klasse verwenden, nicht `style.display`:

```javascript
// FALSCH
element.style.display = 'none';

// RICHTIG
element.classList.add('d-none');
element.classList.remove('d-flex');
```

---

## 7. Gunicorn statt Flask Dev-Server

**Problem:** `app.run()` erzeugt doppelte Log-Zeilen, kein Graceful Shutdown, nicht produktionsreif.

**Lösung:** Immer Gunicorn im Dockerfile:

```dockerfile
# RICHTIG
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "1", "--threads", "4", "--timeout", "120", "package.main:create_app()"]

# FALSCH
CMD ["python", "-c", "from package.main import create_app; create_app().run(...)"]
```

Standard-Parameter: `--workers 1 --threads 4 --timeout 120` (Single-Worker wegen SQLite).

---

## 8. APP_VERSION nie hardcoden

**Problem:** Version in mehreren Dateien pflegen führt zu Inkonsistenzen.

**Lösung:** Nur in `pyproject.toml`, dann über `importlib.metadata` lesen:

```python
try:
    import importlib.metadata
    APP_VERSION = importlib.metadata.version("package-name")
except Exception:
    APP_VERSION = "0.0.0"
```

---

## 9. SQLite WAL-Modus für parallelen Zugriff

**Problem:** SQLite im Default-Modus blockiert bei gleichzeitigen Lese-/Schreibzugriffen.

**Lösung:** WAL-Modus aktivieren:

```python
from sqlalchemy import event

@event.listens_for(engine, "connect")
def set_sqlite_pragma(dbapi_conn, connection_record):
    cursor = dbapi_conn.cursor()
    cursor.execute("PRAGMA journal_mode=WAL")
    cursor.close()
```

---

## 10. Placeholder nie als nackten Wert

**Problem:** `placeholder="admin"` sieht aus wie ein vorausgefüllter Wert.

**Lösung:** Immer mit "z.B." Prefix:

```html
<!-- FALSCH -->
<input placeholder="admin">

<!-- RICHTIG -->
<input placeholder="z.B. admin">
```

---

## 11. Config-Dateien nie beim Deploy überschreiben

**Problem:** Deploy überschreibt produktive Config mit Entwicklungs-Defaults.

**Lösung:** Config-Verzeichnisse vom rsync/Copy ausschließen:

```bash
rsync --exclude 'config/' --exclude '.env' ...
```

---

## 12. Embedded-Modus: URL-Parameter, kein Cookie

**Problem:** Ein Cookie `fi_embedded=1` gilt domainweit (alle Ports auf demselben Host) und schaltet versehentlich andere Apps in den Embedded-Modus.

**Lösung:** `?embedded=1` als URL-Parameter, weitergeben über:

```html
<a href="/seite?{{ request.query_string.decode() }}">Link</a>
```

---

## 13. Lazy Loading für Bilder

**Problem:** `<img src="/api/preview/123">` blockiert gunicorn-Worker bei vielen gleichzeitigen Requests.

**Lösung:** `data-src` + JavaScript Lazy Loading:

```html
<img data-src="/api/preview/{{ id }}" class="lazy">
```

```javascript
document.querySelectorAll('img.lazy').forEach(img => {
    img.src = img.dataset.src;
});
```

---

## 14. PDF immer als PDF/A

Für Archivierung und Langzeitaufbewahrung (z.B. GoBD: 10 Jahre) müssen PDFs als PDF/A generiert werden. FPDF2 unterstützt PDF/A nativ.

---

## 15. Jinja2: Template-Vererbung in Blueprints

**Problem:** Wenn ein Blueprint ein eigenes `base.html` hat, löst `{% extends "base.html" %}` rekursiv auf sich selbst auf → `RecursionError`.

**Lösung:** Kein eigenes `base.html` im Blueprint. Stattdessen das gemeinsame `base.html` aus der Library/dem Hauptprojekt verwenden.
