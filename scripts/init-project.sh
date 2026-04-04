#!/bin/bash
# pyVGM — Projektstruktur initialisieren

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROJECT_ROOT="$(cd "${PLUGIN_ROOT}/.." && pwd)"

VGM_DIR="${PROJECT_ROOT}/.Vorgehensmodell"
TEMPLATES_DIR="${PLUGIN_ROOT}/skills/init-project/templates"

# Prüfen ob bereits initialisiert
if [ -d "${VGM_DIR}" ]; then
  echo "BEREITS_INITIALISIERT"
  echo "Verzeichnis .Vorgehensmodell/ existiert bereits."
  exit 0
fi

# Verzeichnisstruktur anlegen
mkdir -p "${VGM_DIR}/plan"
mkdir -p "${VGM_DIR}/build"
mkdir -p "${VGM_DIR}/run"
mkdir -p "${VGM_DIR}/dokumentation"

# Templates kopieren
COPIED=0

# Plan-Phase
for f in BUSINESS-CASE.md STAKEHOLDER.md SCOPE.md USE-CASES.md RISKS.md MILESTONES.md; do
  if [ -f "${TEMPLATES_DIR}/plan/${f}" ]; then
    cp "${TEMPLATES_DIR}/plan/${f}" "${VGM_DIR}/plan/${f}"
    COPIED=$((COPIED + 1))
  fi
done

# Build-Phase
for f in PROJECT.md ARCHITECTURE.md REQUIREMENTS.md DEVELOPMENT-GUIDELINES.md STATE.md RELEASE-MANAGEMENT.md RELEASE-PLAN.md ROADMAP.md; do
  if [ -f "${TEMPLATES_DIR}/build/${f}" ]; then
    cp "${TEMPLATES_DIR}/build/${f}" "${VGM_DIR}/build/${f}"
    COPIED=$((COPIED + 1))
  fi
done

# Run-Phase
for f in OPERATIONS.md SUPPORT.md TRAINING.md DECOMMISSION.md; do
  if [ -f "${TEMPLATES_DIR}/run/${f}" ]; then
    cp "${TEMPLATES_DIR}/run/${f}" "${VGM_DIR}/run/${f}"
    COPIED=$((COPIED + 1))
  fi
done

# Static Files kopieren
if [ -f "${PLUGIN_ROOT}/static/FLASK-KNOWHOW.md" ]; then
  cp "${PLUGIN_ROOT}/static/FLASK-KNOWHOW.md" "${VGM_DIR}/build/FLASK-KNOWHOW.md"
  COPIED=$((COPIED + 1))
fi
if [ -f "${PLUGIN_ROOT}/static/FLASK-PATTERNS.md" ]; then
  cp "${PLUGIN_ROOT}/static/FLASK-PATTERNS.md" "${VGM_DIR}/build/FLASK-PATTERNS.md"
  COPIED=$((COPIED + 1))
fi
if [ -f "${PLUGIN_ROOT}/static/pdf-style.css" ]; then
  cp "${PLUGIN_ROOT}/static/pdf-style.css" "${VGM_DIR}/dokumentation/pdf-style.css"
  COPIED=$((COPIED + 1))
fi
if [ -f "${PLUGIN_ROOT}/static/assconso-logo.png" ]; then
  cp "${PLUGIN_ROOT}/static/assconso-logo.png" "${VGM_DIR}/dokumentation/assconso-logo.png"
  COPIED=$((COPIED + 1))
fi

# CLAUDE.md aus Template erstellen (falls noch nicht vorhanden)
if [ ! -f "${PROJECT_ROOT}/CLAUDE.md" ] && [ -f "${PLUGIN_ROOT}/static/CLAUDE.md.template" ]; then
  cp "${PLUGIN_ROOT}/static/CLAUDE.md.template" "${PROJECT_ROOT}/CLAUDE.md"
  COPIED=$((COPIED + 1))
fi

# Zusammenfassung
echo "INITIALISIERT"
echo "${COPIED} Dateien erstellt in .Vorgehensmodell/"
echo ""
echo "Struktur:"
echo "  .Vorgehensmodell/"
echo "  ├── plan/          (6 Templates: Business Case, Stakeholder, Scope, ...)"
echo "  ├── build/         (8+ Templates: Project, Architecture, Requirements, ...)"
echo "  ├── run/           (4 Templates: Operations, Support, Training, Decommission)"
echo "  └── dokumentation/ (PDF-Style, Logo)"
