#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$repo/scripts/sync-skills.sh"
chmod +x "$script"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

pass() {
  printf 'ok: %s\n' "$*"
}

tmp="$(mktemp -d "${TMPDIR:-/tmp}/sync-skills-test.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT

src="$tmp/catalog/skills"
mkdir -p "$src/alpha" "$src/beta"
cat >"$src/alpha/SKILL.md" <<'EOF'
---
name: alpha
description: Test skill alpha.
---
# Alpha
EOF
cat >"$src/beta/SKILL.md" <<'EOF'
---
name: beta
description: Test skill beta.
---
# Beta
EOF
echo 'extra' >"$src/beta/notes.txt"
echo 'should-not-vendor' >"$src/beta/notes.test.ts"
echo 'should-not-vendor' >"$src/beta/test_helper.py"

dest="$tmp/consumer/.agents/skills"
mkdir -p "$dest/local-only" "$dest/alpha"
cat >"$dest/local-only/SKILL.md" <<'EOF'
---
name: local-only
description: Must survive overlay.
---
# Local
EOF
cat >"$dest/alpha/SKILL.md" <<'EOF'
---
name: alpha
description: Stale catalog copy.
---
# Stale
EOF

"$script" vendor --source "$src" --dest "$dest"

[[ -f "$dest/alpha/SKILL.md" ]] || fail "alpha missing after vendor"
grep -q '# Alpha' "$dest/alpha/SKILL.md" || fail "alpha not replaced"
[[ -f "$dest/beta/SKILL.md" ]] || fail "beta missing after vendor"
[[ -f "$dest/beta/notes.txt" ]] || fail "beta bundled file missing"
[[ ! -e "$dest/beta/notes.test.ts" ]] || fail "test-only *.test.* was vendored"
[[ ! -e "$dest/beta/test_helper.py" ]] || fail "test-only test_*.py was vendored"
[[ -f "$dest/local-only/SKILL.md" ]] || fail "local-only skill was clobbered"
grep -q 'Must survive overlay' "$dest/local-only/SKILL.md" || fail "local-only content changed"
pass "overlay replaces catalog skills and keeps local-only dirs"

"$script" vendor --source "$src" --dest "$dest" --dry-run >/dev/null
grep -q 'Must survive overlay' "$dest/local-only/SKILL.md" || fail "dry-run mutated local skill"
pass "dry-run does not write"

mkdir -p "$tmp/empty-dest"
"$script" vendor --source "$src" --dest "$tmp/empty-dest/.agents/skills" --dry-run \
  2>&1 | grep -q 'would create' || fail "dry-run did not report create"
[[ ! -e "$tmp/empty-dest/.agents/skills" ]] || fail "dry-run created dest"
pass "dry-run create is a no-op"

enabled="$("$script" print-consumers --manifest "$repo/consumers.yml" | awk '{print $1}')"
echo "$enabled" | grep -qx 'iurysza/termscope' || fail "termscope missing from enabled consumers"
echo "$enabled" | grep -qx 'iurysza/visual-artifact-renderer' || fail "visual-artifact-renderer should be enabled (overlay)"
echo "$enabled" | grep -qx 'iurysza/pi-extensions' || fail "pi-extensions should be enabled"
echo "$enabled" | grep -qx 'iurysza/plannotator' || fail "plannotator should be enabled"
echo "$enabled" | grep -qx 'iurysza/clockwork' || fail "clockwork missing"
if echo "$enabled" | grep -qx 'iurysza/pi-ext'; then
  fail "pi-ext should be disabled"
fi
if echo "$enabled" | grep -qx 'iurysza/agent-skills'; then
  fail "agent-skills must not be a consumer"
fi
"$script" print-consumers --manifest "$repo/consumers.yml" | awk -F'\t' '$2 != ".agents/skills" {exit 1}' \
  || fail "enabled consumers must target .agents/skills"
all="$("$script" print-consumers --all --manifest "$repo/consumers.yml")"
echo "$all" | grep -q $'iurysza/pi-ext\t.agents/skills\t0' || fail "pi-ext should appear as disabled"
pass "consumers.yml lists active repos at .agents/skills"

git_dir="$tmp/git-consumer"
mkdir -p "$git_dir"
git -C "$git_dir" init -b main >/dev/null
git -C "$git_dir" config user.name "Test"
git -C "$git_dir" config user.email "test@example.com"
mkdir -p "$git_dir/.agents/skills/local-only"
cat >"$git_dir/.agents/skills/local-only/SKILL.md" <<'EOF'
---
name: local-only
description: Keep me.
---
# Local
EOF
echo 'readme' >"$git_dir/README.md"
git -C "$git_dir" add .
git -C "$git_dir" commit -m 'init' >/dev/null

"$script" prepare-pr --repo-dir "$git_dir" --source "$src" --path .agents/skills --commit \
  | grep -q $'committed\tlocal\t.agents/skills' || fail "prepare-pr did not commit"
[[ -f "$git_dir/.agents/skills/alpha/SKILL.md" ]] || fail "committed tree missing alpha"
[[ -f "$git_dir/.agents/skills/local-only/SKILL.md" ]] || fail "prepare-pr dropped local skill"
git -C "$git_dir" show --stat --oneline HEAD | grep -q 'vendor iurysza/agent-skills' \
  || fail "expected vendor commit message"
"$script" prepare-pr --repo-dir "$git_dir" --source "$src" --path .agents/skills --commit \
  | grep -q $'unchanged\t' || fail "second prepare-pr should be unchanged"
pass "prepare-pr commits overlay and is idempotent"

"$script" prepare-pr --repo-dir "$git_dir" --source "$src" --path .agents/skills --dry-run \
  | grep -q $'unchanged\t' || fail "dry-run prepare-pr should be unchanged after sync"
pass "dry-run prepare-pr reports unchanged when catalog matches"

if SKILLS_SYNC_TOKEN= "$script" fanout --manifest "$repo/consumers.yml" 2>"$tmp/fanout.err"; then
  fail "fanout without token should fail"
fi
grep -q 'SKILLS_SYNC_TOKEN is not set' "$tmp/fanout.err" || fail "missing-token error is unclear"
pass "fanout fails clearly without SKILLS_SYNC_TOKEN"

real_dest="$tmp/real-overlay/.agents/skills"
mkdir -p "$real_dest/impeccable"
echo 'local' >"$real_dest/impeccable/SKILL.md"
"$script" vendor --source "$repo/skills" --dest "$real_dest"
[[ -f "$real_dest/impeccable/SKILL.md" ]] || fail "real overlay dropped impeccable stand-in"
[[ -f "$real_dest/better-ui/SKILL.md" ]] || fail "real overlay missing better-ui"
[[ -f "$real_dest/reply-bro/SKILL.md" ]] || fail "real overlay missing reply-bro"
pass "overlay of the real catalog keeps a local sibling skill"

printf 'sync-skills tests passed\n'
