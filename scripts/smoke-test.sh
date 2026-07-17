#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cleaner="$repo/skills/skill-cleaner/scripts/skill-cleaner.ts"
fixture="$(mktemp -d)"
install_root="$(mktemp -d)"
report="$(mktemp)"
json="$(mktemp)"
trap 'rm -rf "$fixture" "$install_root"; rm -f "$report" "$json"' EXIT

mkdir -p "$fixture/example-skill"
cat > "$fixture/example-skill/SKILL.md" <<'EOF'
---
name: example-skill
description: Inspect example fixtures when smoke-testing the skill analyzer.
---

# Example skill

This fixture exists only for automated smoke tests.
EOF

"$cleaner" --help | grep -Fq 'Audit installed Agent Skills'
"$cleaner" --root "$fixture" --no-logs --context-tokens 200000 > "$report"
grep -Fq '# Skill Cleaner Report' "$report"
grep -Fq "$fixture" "$report"

"$cleaner" --root "$fixture" --no-logs --context-tokens 200000 --json > "$json"
node -e '
  const fs = require("node:fs");
  const report = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
  if (!report.skills.some((skill) => skill.baseName === "example-skill")) process.exit(1);
  if (report.budget.contextTokens !== 200000) process.exit(1);
' "$json"

(
  cd "$install_root"
  npx -y skills@1.5.19 add "$repo" --skill '*' --agent universal --copy --yes >/dev/null
)
for skill in tool-install strunk-writing-quality skill-cleaner; do
  test -f "$install_root/.agents/skills/$skill/SKILL.md"
done
installed_cleaner="$install_root/.agents/skills/skill-cleaner/scripts/skill-cleaner.ts"
test -x "$installed_cleaner"
"$installed_cleaner" --root "$fixture" --no-logs --context-tokens 200000 >/dev/null

printf 'skill and installed-payload smoke tests passed\n'
