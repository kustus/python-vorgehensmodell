#!/bin/bash
# pyVGM — Python-Vorgehensmodell Plugin Installer

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SKILLS_DIR="${SCRIPT_DIR}/skills"
CLAUDE_DIR="${PROJECT_ROOT}/.claude"
COMMANDS_DIR="${CLAUDE_DIR}/commands"

PLUGIN_JSON="${SCRIPT_DIR}/.claude-plugin/plugin.json"

# Version aus plugin.json lesen (python3 oder jq, kein Node nötig)
if command -v python3 &>/dev/null; then
  VERSION=$(python3 -c "import json; print(json.load(open('${PLUGIN_JSON}'))['version'])" 2>/dev/null || echo "unknown")
  POST_MSG=$(python3 -c "import json; print(json.load(open('${PLUGIN_JSON}')).get('postInstall',{}).get('message',''))" 2>/dev/null || echo "")
elif command -v jq &>/dev/null; then
  VERSION=$(jq -r '.version' "${PLUGIN_JSON}" 2>/dev/null || echo "unknown")
  POST_MSG=$(jq -r '.postInstall.message // ""' "${PLUGIN_JSON}" 2>/dev/null || echo "")
else
  VERSION="unknown"
  POST_MSG=""
fi

if [ ! -d "${SKILLS_DIR}" ]; then
  echo "Fehler: skills/ nicht gefunden in ${SCRIPT_DIR}"
  exit 1
fi

# Skills zählen
TOTAL=0
for skill in "${SKILLS_DIR}"/*/SKILL.md; do
  [ -f "$skill" ] || continue
  TOTAL=$((TOTAL + 1))
done

# Plugin-Modus: Wenn als Submodul eingebunden, werden Skills direkt vom Plugin geladen
PLUGIN_MODE=false
if [ -d "${PROJECT_ROOT}/.git/modules" ] && [ -f "${SCRIPT_DIR}/.git" ]; then
  PLUGIN_MODE=true
fi

LINKED=0
COPIED=0
if [ "$PLUGIN_MODE" = true ]; then
  # Plugin-Modus: Symlinks in .claude/skills/ erstellen
  SKILLS_TARGET="${CLAUDE_DIR}/skills"
  mkdir -p "${SKILLS_TARGET}"

  # Relativer Pfad vom Symlink-Ort zum Submodul
  SUBMODULE_NAME=$(basename "${SCRIPT_DIR}")
  REL_PATH="../../${SUBMODULE_NAME}/skills"

  for skill in "${SKILLS_DIR}"/*/SKILL.md; do
    [ -f "$skill" ] || continue
    name=$(basename "$(dirname "$skill")")
    # /pyVGM Übersicht ohne Prefix, alle anderen mit pyVGM-
    if [ "$name" = "pyVGM" ]; then
      link="${SKILLS_TARGET}/pyVGM"
    else
      link="${SKILLS_TARGET}/pyVGM-${name}"
    fi

    # Symlink nur erstellen/aktualisieren wenn nötig
    if [ -L "$link" ]; then
      continue
    fi

    ln -sf "${REL_PATH}/${name}" "$link"
    LINKED=$((LINKED + 1))
  done
else
  # Standalone-Modus: Skills nach .claude/commands/ kopieren
  mkdir -p "${COMMANDS_DIR}"
  for skill in "${SKILLS_DIR}"/*/SKILL.md; do
    [ -f "$skill" ] || continue
    name=$(basename "$(dirname "$skill")")
    target="${COMMANDS_DIR}/${name}.md"

    if [ -f "$target" ] && cmp -s "$skill" "$target"; then
      continue
    fi

    cp "$skill" "$target"
    COPIED=$((COPIED + 1))
  done
fi

# post-install.md ins Projektverzeichnis kopieren (mit Platzhaltern ersetzen)
POST_INSTALL_SRC="${SCRIPT_DIR}/.claude-plugin/post-install.md"
if [ -f "$POST_INSTALL_SRC" ]; then
  sed -e "s/{{VERSION}}/${VERSION}/g" \
      -e "s/{{SKILLS_COUNT}}/${TOTAL}/g" \
      "$POST_INSTALL_SRC" > "${PROJECT_ROOT}/post-install.md"
fi

# CLAUDE.md erstellen falls noch nicht vorhanden
if [ ! -f "${PROJECT_ROOT}/CLAUDE.md" ]; then
  cat > "${PROJECT_ROOT}/CLAUDE.md" << CLAUDEMD_EOF
# pyVGM — Python-Vorgehensmodell Plugin v${VERSION}

## Post-Install

Lies die Datei [post-install.md](post-install.md) und führe die dortigen Anweisungen aus.
CLAUDEMD_EOF
fi

printf '▄▀▄ ▄▀▀ ▄▀▀ ▄▀▀ ▄▀▄ █▄ █ ▄▀▀ ▄▀▄   Claude Code Plugin - pyVGM\n'
if [ "$PLUGIN_MODE" = true ]; then
  printf '█▀█ ▀▀▄ ▀▀▄ █   █ █ █ ▀█ ▀▀▄ █ █   Version: %s - %s Skills als /pyVGM-* verlinkt\n' "${VERSION}" "${TOTAL}"
  printf '▀ ▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀  ▀ ▀▀▀ ▀▀▀   Developer: Reload Window > /pyVGM\n'
else
  printf '█▀█ ▀▀▄ ▀▀▄ █   █ █ █ ▀█ ▀▀▄ █ █   Version: %s - %s/%s Skills installiert\n' "${VERSION}" "${COPIED}" "${TOTAL}"
  printf '▀ ▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀ ▀  ▀ ▀▀▀ ▀▀▀   %s\n' "${POST_MSG}"
fi

# Anweisung an Claude: post-install.md lesen und anzeigen
if [ -f "${PROJECT_ROOT}/post-install.md" ]; then
  printf '\n---\nCLAUDE: Lies die Datei post-install.md und führe die dortigen Anweisungen aus.\n'
fi
