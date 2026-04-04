#!/bin/bash
# pyVGM — Session-Start: Projektumgebung prüfen

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROJECT_ROOT="$(cd "${PLUGIN_ROOT}/.." && pwd)"

WARNINGS=""

# 1. .Vorgehensmodell/ vorhanden?
if [ ! -d "${PROJECT_ROOT}/.Vorgehensmodell" ]; then
  WARNINGS="${WARNINGS}⚠️ .Vorgehensmodell/ nicht gefunden. Starte mit /pyVGM-init-project\n"
fi

# 2. Pflicht-Dateien der Build-Phase vorhanden?
for f in PROJECT.md ARCHITECTURE.md STATE.md REQUIREMENTS.md DEVELOPMENT-GUIDELINES.md; do
  if [ -d "${PROJECT_ROOT}/.Vorgehensmodell/build" ] && [ ! -f "${PROJECT_ROOT}/.Vorgehensmodell/build/${f}" ]; then
    WARNINGS="${WARNINGS}⚠️ Build-Datei fehlt: .Vorgehensmodell/build/${f}\n"
  fi
done

# 3. CLAUDE.md vorhanden?
if [ ! -f "${PROJECT_ROOT}/CLAUDE.md" ]; then
  WARNINGS="${WARNINGS}⚠️ CLAUDE.md fehlt im Projektverzeichnis\n"
fi

# 4. Python-Version prüfen
if command -v python3 &>/dev/null; then
  PY_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
  PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
  PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
  if [ "$PY_MAJOR" -lt 3 ] || ([ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -lt 10 ]); then
    WARNINGS="${WARNINGS}⚠️ Python ${PY_VERSION} erkannt — empfohlen ist 3.10+\n"
  fi
else
  WARNINGS="${WARNINGS}❌ Python3 nicht gefunden!\n"
fi

# 5. Virtual Environment vorhanden?
if [ ! -d "${PROJECT_ROOT}/.venv" ] && [ ! -d "${PROJECT_ROOT}/venv" ]; then
  WARNINGS="${WARNINGS}⚠️ Kein Virtual Environment (.venv/) gefunden\n"
fi

# 6. Docker verfügbar?
if ! command -v docker &>/dev/null; then
  WARNINGS="${WARNINGS}⚠️ Docker nicht installiert oder nicht im PATH\n"
fi

# 7. Git Status (uncommitted changes?)
if [ -d "${PROJECT_ROOT}/.git" ] || [ -f "${PROJECT_ROOT}/.git" ]; then
  UNCOMMITTED=$(cd "${PROJECT_ROOT}" && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$UNCOMMITTED" -gt 0 ]; then
    WARNINGS="${WARNINGS}⚠️ ${UNCOMMITTED} uncommitted Änderungen im Repository\n"
  fi
fi

# 8. pyproject.toml Version lesen
if [ -f "${PROJECT_ROOT}/pyproject.toml" ]; then
  APP_VERSION=$(python3 -c "
import re
with open('${PROJECT_ROOT}/pyproject.toml') as f:
    m = re.search(r'^version\s*=\s*\"(.+?)\"', f.read(), re.M)
    print(m.group(1) if m else 'unbekannt')
" 2>/dev/null || echo "unbekannt")
fi

# Ergebnis als JSON systemMessage ausgeben
if [ -n "$WARNINGS" ]; then
  # Warnings escapen für JSON
  ESCAPED=$(printf '%b' "$WARNINGS" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read()))" 2>/dev/null || echo '""')
  echo "{\"systemMessage\": ${ESCAPED}}"
fi
