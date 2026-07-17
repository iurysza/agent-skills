#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
list_file="$(mktemp)"
trap 'rm -f "$list_file"' EXIT
cd "$repo"

skills_ref_source='git+https://github.com/agentskills/agentskills.git@38a2ff82958afee88dadf4831509e6f7e9d8ef4e#subdirectory=skills-ref'

if command -v skills-ref >/dev/null 2>&1; then
  validator=(skills-ref)
elif command -v uvx >/dev/null 2>&1; then
  validator=(uvx --from "$skills_ref_source" skills-ref)
else
  printf 'error: install uv or skills-ref to validate skills\n' >&2
  exit 1
fi

skill_count=0
while IFS= read -r -d '' skill_md; do
  skill_dir="$(dirname "$skill_md")"
  "${validator[@]}" validate "$skill_dir"
  skill_count=$((skill_count + 1))
done < <(find skills -mindepth 2 -maxdepth 2 -name SKILL.md -print0 | sort -z)

if [[ "$skill_count" -eq 0 ]]; then
  printf 'error: no skills found\n' >&2
  exit 1
fi

if grep -RIEna '(/Users/[^/[:space:]]+|/home/[^/[:space:]]+|/var/folders/[^[:space:]]+|[A-Za-z]:\\Users\\[^\\[:space:]]+)' skills; then
  printf 'error: personal absolute path found\n' >&2
  exit 1
fi

vendored="$(find skills -type d \( -name node_modules -o -name .venv -o -name __pycache__ -o -name artifacts \) -print -quit)"
if [[ -n "$vendored" ]]; then
  printf 'error: generated or vendored directory found: %s\n' "$vendored" >&2
  exit 1
fi

npx -y skills@1.5.19 add "$repo" --list > "$list_file"
for skill in tool-install strunk-writing-quality skill-cleaner; do
  if ! grep -Fq "$skill" "$list_file"; then
    printf 'error: Vercel CLI did not discover %s\n' "$skill" >&2
    exit 1
  fi
done

if command -v gitleaks >/dev/null 2>&1; then
  gitleaks dir "$repo" --no-banner --redact
else
  printf 'warning: gitleaks unavailable; secret scan skipped\n' >&2
fi

printf 'validated %s skills\n' "$skill_count"
