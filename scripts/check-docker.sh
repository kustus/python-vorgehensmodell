#!/bin/bash
# pyVGM — Docker-Umgebung prüfen

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROJECT_ROOT="$(cd "${PLUGIN_ROOT}/.." && pwd)"

ERRORS=0

echo "=== pyVGM Docker-Check ==="
echo ""

# 1. Docker verfügbar?
if command -v docker &>/dev/null; then
  echo "✅ Docker installiert ($(docker --version 2>/dev/null | head -1))"
else
  echo "❌ Docker nicht gefunden"
  ERRORS=$((ERRORS + 1))
fi

# 2. Docker Daemon läuft?
if docker info &>/dev/null 2>&1; then
  echo "✅ Docker Daemon läuft"
else
  echo "❌ Docker Daemon nicht erreichbar"
  ERRORS=$((ERRORS + 1))
fi

# 3. docker-compose.yml vorhanden?
if [ -f "${PROJECT_ROOT}/docker-compose.yml" ] || [ -f "${PROJECT_ROOT}/deploy/docker-compose.yml" ]; then
  echo "✅ docker-compose.yml gefunden"
else
  echo "⚠️  docker-compose.yml nicht gefunden"
fi

# 4. Dockerfile(s) vorhanden?
DOCKERFILES=$(find "${PROJECT_ROOT}" -maxdepth 3 -name "Dockerfile*" -not -path "*/.venv/*" -not -path "*/node_modules/*" 2>/dev/null | wc -l | tr -d ' ')
if [ "$DOCKERFILES" -gt 0 ]; then
  echo "✅ ${DOCKERFILES} Dockerfile(s) gefunden"
else
  echo "⚠️  Keine Dockerfiles gefunden"
fi

# 5. Laufende Container prüfen (wenn docker-compose vorhanden)
COMPOSE_FILE=""
if [ -f "${PROJECT_ROOT}/docker-compose.yml" ]; then
  COMPOSE_FILE="${PROJECT_ROOT}/docker-compose.yml"
elif [ -f "${PROJECT_ROOT}/deploy/docker-compose.yml" ]; then
  COMPOSE_FILE="${PROJECT_ROOT}/deploy/docker-compose.yml"
fi

if [ -n "$COMPOSE_FILE" ] && command -v docker &>/dev/null; then
  echo ""
  echo "--- Container-Status ---"
  cd "$(dirname "$COMPOSE_FILE")" && docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "⚠️  docker compose ps fehlgeschlagen"
fi

echo ""
if [ "$ERRORS" -eq 0 ]; then
  echo "✅ Docker-Umgebung OK"
else
  echo "❌ ${ERRORS} Fehler gefunden"
fi

exit "$ERRORS"
