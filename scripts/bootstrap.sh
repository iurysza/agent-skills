#!/usr/bin/env bash
# Install the agent-skills catalog into user-level skill folders on this box.
#
#   curl -fsSL https://raw.githubusercontent.com/iurysza/agent-skills/main/scripts/bootstrap.sh | bash
#
# Repos call this from their cloud setup (Cursor install, Claude Code
# SessionStart hook, Codex setup script). Nothing is written into the repo.
# Catalog skills are replaced; other skills in the same folders are kept.
# A failed download only warns, so it never breaks the box's setup.
#
# Env:
#   AGENT_SKILLS_REF   git ref to install (default: main)
#   AGENT_SKILLS_DIRS  space-separated target folders
#                      (default: ~/.agents/skills ~/.cursor/skills ~/.claude/skills ~/.codex/skills)
set -uo pipefail

ref="${AGENT_SKILLS_REF:-main}"
dirs="${AGENT_SKILLS_DIRS:-$HOME/.agents/skills $HOME/.cursor/skills $HOME/.claude/skills $HOME/.codex/skills}"
url="https://codeload.github.com/iurysza/agent-skills/tar.gz/${ref}"

warn() { printf 'agent-skills: %s\n' "$*" >&2; }

tmp="$(mktemp -d)" || { warn "mktemp failed"; exit 0; }
trap 'rm -rf "$tmp"' EXIT

if ! curl -fsSL --retry 3 "$url" | tar -xz -C "$tmp" 2>/dev/null; then
  warn "could not download $url; skills not updated"
  exit 0
fi

src="$(find "$tmp" -mindepth 2 -maxdepth 2 -type d -name skills | head -n 1)"
if [ -z "$src" ]; then
  warn "no skills/ folder in $ref"
  exit 0
fi

count=0
for dir in $dirs; do
  mkdir -p "$dir" || { warn "cannot create $dir"; continue; }
  for skill in "$src"/*/; do
    name="$(basename "$skill")"
    [ -f "$skill/SKILL.md" ] || continue
    rm -rf "${dir:?}/$name"
    cp -R "$skill" "$dir/$name"
  done
  count=$((count + 1))
done

printf 'agent-skills: installed %s skills from %s into %s folders\n' \
  "$(find "$src" -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')" "$ref" "$count"
