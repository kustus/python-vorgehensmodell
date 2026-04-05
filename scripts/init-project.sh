#!/bin/bash
# pyVGM — Projektstruktur initialisieren

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROJECT_ROOT="$(cd "${PLUGIN_ROOT}/.." && pwd)"

VGM_DIR="${PROJECT_ROOT}/.Vorgehensmodell"
TEMPLATES_DIR="${PLUGIN_ROOT}/skills/init-project/templates"
STATIC_DIR="${PLUGIN_ROOT}/static"

# Prüfen ob bereits initialisiert
if [ -d "${VGM_DIR}" ]; then
  echo "BEREITS_INITIALISIERT"
  # Statusbericht ausgeben
  echo "---STATUS---"
  for phase in plan build run; do
    echo "PHASE:${phase}"
    if [ -d "${VGM_DIR}/${phase}" ]; then
      for f in "${VGM_DIR}/${phase}"/*.md; do
        [ -f "$f" ] || continue
        name=$(basename "$f" .md)
        # Prüfe ob Datei mehr als nur Template-Inhalt hat (>10 Zeilen = ausgefüllt)
        tmpl="${TEMPLATES_DIR}/${phase}/${name}.md"
        if [ -f "$tmpl" ] && cmp -s "$f" "$tmpl"; then
          echo "  TEMPLATE:${name}"
        else
          echo "  AUSGEFUELLT:${name}"
        fi
      done
    fi
  done
  exit 0
fi

# === Struktur anlegen ===
mkdir -p "${VGM_DIR}/plan"
mkdir -p "${VGM_DIR}/build"
mkdir -p "${VGM_DIR}/run"
mkdir -p "${VGM_DIR}/dokumentation"
mkdir -p "${VGM_DIR}/framework-links"

# === Templates kopieren (nur Projekt-Dateien) ===
cp "${TEMPLATES_DIR}"/plan/*.md "${VGM_DIR}/plan/"
cp "${TEMPLATES_DIR}"/build/*.md "${VGM_DIR}/build/"
cp "${TEMPLATES_DIR}"/run/*.md "${VGM_DIR}/run/"

# === Framework-Links: Symlinks zu Framework-Dateien ===
SUBMODULE_NAME=$(basename "${PLUGIN_ROOT}")
REL_STATIC="../${SUBMODULE_NAME}/static"
REL_ROOT="../${SUBMODULE_NAME}"

# static/ Dateien
for doc in DEVELOPMENT-GUIDELINES.md ARCHITECTURE.md RELEASE-MANAGEMENT.md FLASK-KNOWHOW.md FLASK-PATTERNS.md FRAMEWORK-GUIDE.md; do
  if [ -f "${STATIC_DIR}/${doc}" ]; then
    ln -sf "${REL_STATIC}/${doc}" "${VGM_DIR}/framework-links/${doc}"
  fi
done

# Assets
for asset in pdf-style.css assconso-logo.png; do
  if [ -f "${STATIC_DIR}/${asset}" ]; then
    ln -sf "${REL_STATIC}/${asset}" "${VGM_DIR}/framework-links/${asset}"
  fi
done

# FRAMEWORK-BACKLOG.md (liegt im Framework-Root, nicht in static/)
if [ -f "${PLUGIN_ROOT}/FRAMEWORK-BACKLOG.md" ]; then
  ln -sf "${REL_ROOT}/FRAMEWORK-BACKLOG.md" "${VGM_DIR}/framework-links/FRAMEWORK-BACKLOG.md"
fi

# === CLAUDE.md erstellen (nur wenn nicht vorhanden) ===
if [ ! -f "${PROJECT_ROOT}/CLAUDE.md" ]; then
  if [ -f "${STATIC_DIR}/CLAUDE.md.template" ]; then
    cp "${STATIC_DIR}/CLAUDE.md.template" "${PROJECT_ROOT}/CLAUDE.md"
  fi
fi

# === Zusammenfassung ===
PLAN_COUNT=$(ls "${VGM_DIR}/plan/"*.md 2>/dev/null | wc -l | tr -d ' ')
BUILD_COUNT=$(ls "${VGM_DIR}/build/"*.md 2>/dev/null | wc -l | tr -d ' ')
RUN_COUNT=$(ls "${VGM_DIR}/run/"*.md 2>/dev/null | wc -l | tr -d ' ')
LINK_COUNT=$(ls "${VGM_DIR}/framework-links/" 2>/dev/null | wc -l | tr -d ' ')
TOTAL=$((PLAN_COUNT + BUILD_COUNT + RUN_COUNT))

echo "---BANNER---"
echo '▄▀▄ ▄▀▀ ▄▀▀ ▄▀▀ ▄▀▄ █▄ █ ▄▀▀ ▄▀▄   Claude Code Plugin - pyVGM'
echo '█▀█ ▀▀▄ ▀▀▄ █   █ █ █ ▀█ ▀▀▄ █ █   (C) 2026 Assconso GmbH'
echo '▀ ▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀  ▀ ▀▀▀ ▀▀▀   www.assconso.de'
echo "INITIALISIERT"
echo "PLAN:${PLAN_COUNT}"
echo "BUILD:${BUILD_COUNT}"
echo "RUN:${RUN_COUNT}"
echo "TOTAL:${TOTAL}"
echo "CLAUDE_MD:$([ -f "${PROJECT_ROOT}/CLAUDE.md" ] && echo 'ja' || echo 'nein')"
echo "SKILLS:$(ls -d "${PROJECT_ROOT}/.claude/skills/pyVGM-"* 2>/dev/null | wc -l | tr -d ' ')"
echo "FRAMEWORK_LINKS:${LINK_COUNT}"
echo "---PLAN-TEMPLATES---"
for f in "${VGM_DIR}/plan/"*.md; do
  [ -f "$f" ] || continue
  echo "  $(basename "$f" .md)"
done
echo "---BUILD-TEMPLATES---"
for f in "${VGM_DIR}/build/"*.md; do
  [ -f "$f" ] || continue
  echo "  $(basename "$f" .md)"
done
echo "---RUN-TEMPLATES---"
for f in "${VGM_DIR}/run/"*.md; do
  [ -f "$f" ] || continue
  echo "  $(basename "$f" .md)"
done
