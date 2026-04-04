---
description: OWASP-Sicherheitsprüfung für Flask-Anwendungen.
---

# Sicherheits-Check

Prüft die Flask-Anwendung auf die OWASP Top 10 Schwachstellen und Flask-spezifische Sicherheitsrisiken.

## 5 Prüfbereiche

### 1. Authentifizierung & Autorisierung

- [ ] Login/Session-Management vorhanden (oder bewusst weggelassen mit Begründung)
- [ ] `app.secret_key` nicht der Default-Wert und nicht hardcoded
- [ ] Session-Cookie: `httponly=True`, `samesite='Lax'`
- [ ] Keine Credentials im Code (API-Keys, Passwörter)
- [ ] Keine Credentials in Git-Historie

```bash
grep -rn "password\|api_key\|secret\|token" src/ --include="*.py" -i | grep -v ".venv" | grep -v "test"
```

### 2. Eingabevalidierung & Injection

- [ ] **SQL-Injection:** Nur SQLAlchemy ORM, keine Raw SQL mit String-Formatierung
- [ ] **XSS:** Jinja2 Auto-Escaping aktiv (Standard in Flask)
- [ ] **CSRF:** Flask-WTF oder manueller CSRF-Schutz bei POST/PUT/DELETE
- [ ] **Path Traversal:** `os.path.join()` mit Validierung, kein `..` in Pfaden
- [ ] **Command Injection:** Kein `os.system()`, `subprocess.call(shell=True)` mit User-Input

```bash
grep -rn "execute\|raw_sql\|text(" src/ --include="*.py" | grep -v ".venv"
grep -rn "os\.system\|subprocess.*shell=True" src/ --include="*.py" | grep -v ".venv"
```

### 3. Datenschutz (DSGVO)

- [ ] Keine Google Fonts per CDN (IP-Übertragung an Google)
- [ ] Keine externen Tracking-Scripts
- [ ] Personenbezogene Daten verschlüsselt gespeichert?
- [ ] Datenminimierung: Nur nötige Daten erfassen
- [ ] Löschkonzept vorhanden?

### 4. Konfiguration & Secrets

- [ ] Debug-Modus nicht in Produktion aktiv (`app.debug = False`)
- [ ] Secret Key aus Environment Variable (nicht hardcoded)
- [ ] Config-Dateien nicht in Git (.gitignore prüfen)
- [ ] `.env` in `.gitignore`
- [ ] Keine Default-Credentials in Produktion

### 5. Logging & Audit

- [ ] Fehler werden geloggt (nicht nur `print()`)
- [ ] Keine sensiblen Daten in Logs (Passwörter, Tokens)
- [ ] Zugriffe protokolliert?
- [ ] Log-Rotation konfiguriert?

## Ausgabeformat

```
=== SICHERHEITS-CHECK (OWASP) ===

1. Authentifizierung & Autorisierung    ✅ / ⚠️ / ❌
2. Eingabevalidierung & Injection       ✅ / ⚠️ / ❌
3. Datenschutz (DSGVO)                  ✅ / ⚠️ / ❌
4. Konfiguration & Secrets              ✅ / ⚠️ / ❌
5. Logging & Audit                      ✅ / ⚠️ / ❌

=== KRITISCHE FINDINGS ===
- [KRITISCH] SQL-Injection in views.py:142 — Raw SQL mit f-String
- [HOCH] Hardcoded API-Key in config.py:23

=== EMPFEHLUNGEN ===
- SQLAlchemy ORM statt Raw SQL verwenden
- API-Key in Environment Variable auslagern
```

Zeige pro Finding die Datei + Zeilennummer und eine konkrete Lösung.
