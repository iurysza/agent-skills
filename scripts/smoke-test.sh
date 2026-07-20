#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cleaner="$repo/skills/skill-cleaner/scripts/skill-cleaner.mjs"
fixture="$(mktemp -d)"
install_root="$(mktemp -d)"
report="$(mktemp)"
json="$(mktemp)"
invalid_config="$(mktemp)"
trap 'rm -rf "$fixture" "$install_root"; rm -f "$report" "$json" "$invalid_config"' EXIT

skills=()
while IFS= read -r skill; do
  skills+=("$skill")
done < <(find "$repo/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -exec dirname {} \; | xargs -n1 basename | sort)

mkdir -p "$fixture/example-skill"
cat > "$fixture/example-skill/SKILL.md" <<'EOF'
---
name: example-skill
description: Inspect example fixtures when smoke-testing the skill analyzer.
---

# Example skill

This fixture exists only for automated smoke tests.
EOF

node "$cleaner" --help | grep -Fq 'Audit installed Agent Skills'
node "$cleaner" --root "$fixture" --no-logs --context-tokens 200000 > "$report"
grep -Fq '# Skill Cleaner Report' "$report"
grep -Fq "$fixture" "$report"

node "$cleaner" --root "$fixture" --no-logs --context-tokens 200000 --json > "$json"
node -e '
  const fs = require("node:fs");
  const report = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  if (!report.skills.some((skill) => skill.baseName === "example-skill")) process.exit(1);
  if (report.budget.contextTokens !== 200000) process.exit(1);
' "$json"

node -e '
  const fs = require("node:fs");
  const config = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  config.notGrouped = "middle";
  fs.writeFileSync(process.argv[2], JSON.stringify(config));
' "$repo/skills.sh.json" "$invalid_config"
if node "$repo/scripts/validate-skills-config.mjs" "$invalid_config" "$repo/skills" >/dev/null 2>&1; then
  printf 'error: invalid skills.sh.json passed validation\n' >&2
  exit 1
fi

python3 - "$repo" <<'PY'
import ast
import json
import pathlib
import sys

repo = pathlib.Path(sys.argv[1])
for script in (
    repo / "skills/gemini-tts/scripts/generate_tts.py",
    repo / "skills/chatgpt-imagegen/scripts/generate_image.py",
):
    ast.parse(script.read_text(encoding="utf-8"), filename=str(script))
json.loads((repo / "skills/gemini-tts/templates.json").read_text(encoding="utf-8"))
json.loads((repo / "skills/audio-transcribe/scripts/package.json").read_text(encoding="utf-8"))
PY

bash -n "$repo/skills/chatgpt-imagegen/scripts/chatgpt-img"
python3 "$repo/scripts/test-media-clis.py" >/dev/null
bun run "$repo/scripts/test-audio-transcribe.ts" >/dev/null
python3 "$repo/skills/gemini-tts/scripts/generate_tts.py" --list-voices >/dev/null
python3 "$repo/skills/gemini-tts/scripts/generate_tts.py" \
  --text 'Offline smoke test.' --template newscaster --dry-run >/dev/null
python3 "$repo/skills/chatgpt-imagegen/scripts/generate_image.py" --help >/dev/null
"$repo/skills/chatgpt-imagegen/scripts/chatgpt-img" --help >/dev/null
bun run "$repo/skills/audio-transcribe/scripts/transcribe.ts" --help >/dev/null

python_venv="$install_root/python-venv"
uv venv "$python_venv" >/dev/null
uv pip install --python "$python_venv/bin/python" \
  -r "$repo/skills/gemini-tts/requirements.txt" \
  -r "$repo/skills/chatgpt-imagegen/requirements.txt" >/dev/null
"$python_venv/bin/python" - <<'PY'
from google import genai
from google.genai import types
from openai import OpenAI

genai.Client(api_key="test")
types.GenerateContentConfig(response_modalities=["audio"])
OpenAI(api_key="test")
PY

audio_runtime="$install_root/audio-runtime"
mkdir -p "$audio_runtime"
cp "$repo/skills/audio-transcribe/scripts/package.json" "$audio_runtime/package.json"
bun install --cwd "$audio_runtime" --no-save >/dev/null
(
  cd "$audio_runtime"
  bun -e 'import("@google/genai").then(({GoogleGenAI}) => new GoogleGenAI({apiKey:"test"}))'
)

(
  cd "$install_root"
  npx -y skills@1.5.19 add "$repo" --skill '*' --agent universal --copy --yes >/dev/null
)
for skill in "${skills[@]}"; do
  test -f "$install_root/.agents/skills/$skill/SKILL.md"
done

installed_cleaner="$install_root/.agents/skills/skill-cleaner/scripts/skill-cleaner.mjs"
node "$installed_cleaner" --root "$fixture" --no-logs --context-tokens 200000 >/dev/null
python3 "$install_root/.agents/skills/gemini-tts/scripts/generate_tts.py" \
  --text 'Installed smoke test.' --dry-run >/dev/null
python3 "$install_root/.agents/skills/chatgpt-imagegen/scripts/generate_image.py" --help >/dev/null
bun run "$install_root/.agents/skills/audio-transcribe/scripts/transcribe.ts" --help >/dev/null

printf 'skill and installed-payload smoke tests passed (%s skills)\n' "${#skills[@]}"
