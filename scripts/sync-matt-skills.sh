#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ref="${MATT_SKILLS_REF:-main}"
temp="$(mktemp -d)"
trap 'rm -rf "$temp"' EXIT

curl --fail --location --silent --show-error \
  "https://codeload.github.com/mattpocock/skills/tar.gz/$ref" \
  --output "$temp/source.tar.gz"
tar -xzf "$temp/source.tar.gz" -C "$temp"
source_root="$(find "$temp" -mindepth 1 -maxdepth 1 -type d -print -quit)"

skills=(
  "skills/engineering/tdd:tdd"
)

for mapping in "${skills[@]}"; do
  source_path="${mapping%%:*}"
  destination="${mapping##*:}"
  target="$repo/skills/$destination"
  test -f "$source_root/$source_path/SKILL.md"
  rm -rf "$target"
  mkdir -p "$target"
  cp -R "$source_root/$source_path/." "$target/"

  # Keep the selected bundle spec-valid and self-contained.
  awk -v skill="$destination" '
    /^disable-model-invocation:/ { next }
    skill == "tdd" && /^- \*\*Refactoring is not part of the loop\./ {
      print "- **Refactoring follows the loop.** Review broader structural cleanup after the behavior is green instead of mixing it into each red → green cycle."
      next
    }
    { print }
  ' "$target/SKILL.md" > "$target/SKILL.md.tmp"
  mv "$target/SKILL.md.tmp" "$target/SKILL.md"
done

printf 'synced %s Matt Pocock skills from %s\n' "${#skills[@]}" "$ref"
