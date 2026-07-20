#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
temp="$(mktemp -d)"
cleanup() {
  for _ in 1 2 3; do
    rm -rf "$temp" 2>/dev/null || true
    [[ ! -e "$temp" ]] && return
  done
}
trap cleanup EXIT

targets=(
  'universal:.agents/skills'
  'claude-code:.claude/skills'
  'codex:.agents/skills'
  'opencode:.agents/skills'
  'pi:.pi/skills'
)
skills=()
while IFS= read -r skill; do
  skills+=("$skill")
done < <(find "$repo/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -exec dirname {} \; | xargs -n1 basename | sort)

for target in "${targets[@]}"; do
  IFS=: read -r agent destination <<<"$target"
  project="$temp/npx-$agent"
  mkdir -p "$project"
  (
    cd "$project"
    npx -y skills@1.5.19 add "$repo" --skill '*' --agent "$agent" --copy --yes >/dev/null
  )
  for skill in "${skills[@]}"; do
    test -f "$project/$destination/$skill/SKILL.md"
  done
done

if ! gh skill install --help >/dev/null 2>&1; then
  printf 'error: GitHub CLI with gh skill support is required\n' >&2
  exit 1
fi

gh_home="$temp/gh-home"
mkdir -p "$gh_home"
for target in \
  'universal:.agents/skills' \
  'claude-code:.claude/skills' \
  'codex:.codex/skills' \
  'opencode:.config/opencode/skills' \
  'pi:.pi/agent/skills'; do
  IFS=: read -r agent destination <<<"$target"
  HOME="$gh_home" XDG_CONFIG_HOME="$gh_home/.config" \
    gh skill install "$repo" --from-local --all --agent "$agent" --scope user --force >/dev/null 2>&1
  for skill in "${skills[@]}"; do
    test -f "$gh_home/$destination/$skill/SKILL.md"
  done
done

installed_cleaner="$gh_home/.agents/skills/skill-cleaner/scripts/skill-cleaner.mjs"
node "$installed_cleaner" --root "$repo/skills" --no-logs --context-tokens 200000 >/dev/null

printf 'npx skills and gh skill compatibility tests passed\n'
