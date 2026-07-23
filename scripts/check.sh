#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo"

if command -v skills-ref >/dev/null 2>&1; then
  validator=(skills-ref)
elif command -v uvx >/dev/null 2>&1; then
  validator=(uvx --from 'git+https://github.com/agentskills/agentskills.git#subdirectory=skills-ref' skills-ref)
else
  printf 'error: install uv or skills-ref\n' >&2
  exit 1
fi

count=0
while IFS= read -r -d '' skill_file; do
  "${validator[@]}" validate "$(dirname "$skill_file")"
  count=$((count + 1))
done < <(find skills -mindepth 2 -maxdepth 2 -name SKILL.md -print0 | sort -z)

test "$count" -gt 0
node --check skills/skill-cleaner/scripts/skill-cleaner.mjs
python3 - <<'PY'
import ast
from pathlib import Path

for path in (
    Path("skills/chatgpt-imagegen/scripts/generate_image.py"),
    Path("skills/gemini-tts/scripts/generate_tts.py"),
):
    ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
PY

if grep -RIEna '(/Users/[^/[:space:]]+|/home/[^/[:space:]]+|/var/folders/[^[:space:]]+|[A-Za-z]:\\Users\\)' skills; then
  printf 'error: personal absolute path found\n' >&2
  exit 1
fi

bad_dir="$(find skills -type d \( -name node_modules -o -name .venv -o -name __pycache__ -o -name artifacts \) -print -quit)"
if [[ -n "$bad_dir" ]]; then
  printf 'error: generated directory found: %s\n' "$bad_dir" >&2
  exit 1
fi

printf 'checked %s skills\n' "$count"
