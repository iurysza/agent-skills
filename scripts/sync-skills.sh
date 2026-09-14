#!/usr/bin/env bash
# Overlay this catalog's skills/ into consumer .agents/skills (always-latest, no pin).
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
default_manifest="$repo_root/consumers.yml"

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

log() {
  printf '%s\n' "$*" >&2
}

usage() {
  cat <<'EOF'
Usage:
  sync-skills.sh vendor [--source DIR] --dest DIR [--dry-run]
  sync-skills.sh print-consumers [--manifest FILE] [--all]
  sync-skills.sh prepare-pr --repo-dir DIR [--source DIR] [--path PATH] [--dry-run] [--commit] [--push]
  sync-skills.sh fanout [--manifest FILE] [--dry-run] [--only owner/name]

vendor      Overlay each catalog skill directory into DEST (default source:
            <repo>/skills). DEST/<name>/ is replaced for catalog names only.
            Other directories in DEST (local-only skills) are left in place.
            No lockfile or SHA pin is written.

print-consumers
            Print consumers as TSV: repo<TAB>path<TAB>enabled.
            Default lists enabled consumers; --all includes disabled.

prepare-pr  Overlay into an existing git checkout. --commit creates a local
            commit. --push force-pushes the bot branch and opens or updates a PR.

fanout      Clone each enabled consumer and run prepare-pr.
            Push/PR requires SKILLS_SYNC_TOKEN (PAT or GitHub App token with
            contents:write and pull-requests:write on each consumer).
            GITHUB_TOKEN cannot open PRs in other repositories.
            --dry-run clones public repos read-only and does not need the token.
EOF
}

parse_manifest() {
  local manifest="$1"
  python3 - "$manifest" <<'PY'
import json
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

def parse_scalar(raw: str):
    raw = raw.strip()
    if raw in ("true", "True", "yes"):
        return True
    if raw in ("false", "False", "no"):
        return False
    if len(raw) >= 2 and raw[0] == raw[-1] and raw[0] in "\"'":
        return raw[1:-1]
    return raw

data = {
    "default_path": ".agents/skills",
    "source": "skills",
    "pr_branch": "chore/vendor-agent-skills",
    "pr_title": "chore(skills): sync iurysza/agent-skills from main",
    "consumers": [],
}
known_top = set(data)
in_consumers = False
current = None

for lineno, raw in enumerate(text.splitlines(), 1):
    stripped = raw.split("#", 1)[0].rstrip()
    if not stripped.strip():
        continue
    if not in_consumers:
        if stripped.strip() == "consumers:":
            in_consumers = True
            continue
        if ":" not in stripped:
            raise SystemExit(f"{path}:{lineno}: expected key: value")
        key, val = stripped.split(":", 1)
        key = key.strip()
        if key not in known_top:
            raise SystemExit(f"{path}:{lineno}: unknown key {key!r}")
        data[key] = parse_scalar(val)
        continue

    content = stripped.strip()
    if content.startswith("- "):
        current = {"enabled": True}
        data["consumers"].append(current)
        rest = content[2:].strip()
        if ":" not in rest:
            raise SystemExit(f"{path}:{lineno}: expected '- repo: owner/name'")
        key, val = rest.split(":", 1)
        current[key.strip()] = parse_scalar(val)
        continue
    if current is not None and stripped[:1] in " \t":
        if ":" not in content:
            raise SystemExit(f"{path}:{lineno}: expected key: value under consumer")
        key, val = content.split(":", 1)
        current[key.strip()] = parse_scalar(val)
        continue
    raise SystemExit(f"{path}:{lineno}: unrecognized line")

repo_re = re.compile(r"^[^/\s]+/[^/\s]+$")
for index, consumer in enumerate(data["consumers"]):
    repo = consumer.get("repo")
    if not isinstance(repo, str) or not repo_re.match(repo):
        raise SystemExit(f"{path}: consumer {index} has invalid repo {repo!r}")
    if "path" not in consumer or consumer["path"] in (None, ""):
        consumer["path"] = data["default_path"]
    if not isinstance(consumer["path"], str) or consumer["path"].startswith("/"):
        raise SystemExit(f"{path}: consumer {repo} path must be a relative directory")
    if consumer["path"] in (".", ".."):
        raise SystemExit(f"{path}: consumer {repo} path {consumer['path']!r} is not allowed")

print(json.dumps(data, indent=2, sort_keys=True))
PY
}

source_sha() {
  git -C "$repo_root" rev-parse HEAD
}

skill_dirs() {
  local source="$1"
  find "$source" -mindepth 2 -maxdepth 2 -name SKILL.md \
    | sed 's#/SKILL.md$##' \
    | sort
}

skill_names() {
  local dir
  while IFS= read -r dir; do
    basename "$dir"
  done < <(skill_dirs "$1")
}

catalog_current() {
  local source="$1" dest="$2" dir name
  [[ -d "$dest" ]] || return 1
  while IFS= read -r dir; do
    name="$(basename "$dir")"
    [[ -d "$dest/$name" ]] || return 1
    diff -rq "$dir" "$dest/$name" >/dev/null || return 1
  done < <(skill_dirs "$source")
}

vendor_tree() {
  local source="$1" dest="$2" dry_run="$3"
  local dir name count
  [[ -d "$source" ]] || die "source is not a directory: $source"
  [[ -n "$dest" ]] || die "destination is empty"
  [[ "$dest" != "/" ]] || die "refusing to write /"
  count="$(skill_dirs "$source" | wc -l | tr -d ' ')"
  [[ "$count" -gt 0 ]] || die "no SKILL.md files under $source"

  if [[ "$dry_run" == "1" ]]; then
    if catalog_current "$source" "$dest"; then
      log "dry-run: catalog skills in $dest already match $source ($count skills)"
    elif [[ ! -e "$dest" ]]; then
      log "dry-run: would create $dest and overlay $count skills from $source"
    else
      log "dry-run: would overlay $count catalog skills into $dest (local-only dirs kept)"
      while IFS= read -r dir; do
        name="$(basename "$dir")"
        if [[ ! -d "$dest/$name" ]]; then
          log "  + $name"
        elif ! diff -rq "$dir" "$dest/$name" >/dev/null; then
          log "  ~ $name"
        fi
      done < <(skill_dirs "$source")
    fi
    return 0
  fi

  mkdir -p "$dest"
  while IFS= read -r dir; do
    name="$(basename "$dir")"
    rm -rf "$dest/$name"
    cp -a "$dir" "$dest/$name"
  done < <(skill_dirs "$source")
  log "overlaid $count catalog skills into $dest"
}

cmd_vendor() {
  local source="$repo_root/skills" dest="" dry_run=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --source) source="$2"; shift 2 ;;
      --dest) dest="$2"; shift 2 ;;
      --dry-run) dry_run=1; shift ;;
      -h|--help) usage; return 0 ;;
      *) die "unknown vendor argument: $1" ;;
    esac
  done
  [[ -n "$dest" ]] || die "vendor requires --dest"
  vendor_tree "$source" "$dest" "$dry_run"
}

cmd_print_consumers() {
  local manifest="$default_manifest" include_all=0 json
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --manifest) manifest="$2"; shift 2 ;;
      --all) include_all=1; shift ;;
      -h|--help) usage; return 0 ;;
      *) die "unknown print-consumers argument: $1" ;;
    esac
  done
  json="$(parse_manifest "$manifest")"
  INCLUDE_ALL="$include_all" CONSUMERS_JSON="$json" python3 - <<'PY'
import json, os
include_all = os.environ["INCLUDE_ALL"] == "1"
data = json.loads(os.environ["CONSUMERS_JSON"])
for consumer in data["consumers"]:
    enabled = "1" if consumer.get("enabled", True) else "0"
    if include_all or enabled == "1":
        print(f"{consumer['repo']}\t{consumer['path']}\t{enabled}")
PY
}

pr_body() {
  local sha="$1" dest_path="$2" source="$3"
  local names
  names="$(skill_names "$source" | sed 's/^/- /')"
  cat <<EOF
## Skills sync

This PR overlays the current \`skills/\` tree from [iurysza/agent-skills](https://github.com/iurysza/agent-skills) \`main\` into \`${dest_path}/<skill-name>/\`.

Cursor Cloud Agents load project skills from \`.agents/skills/\` (also \`.cursor/skills/\`). This copy uses \`${dest_path}\` so those agents see the catalog from the repo checkout.

- Source commit: [\`${sha}\`](https://github.com/iurysza/agent-skills/commit/${sha})
- Target path: \`${dest_path}\`
- Mode: **always-latest overlay** (no lockfile, no SHA pin)
- Local skill directories whose names are not in the catalog are kept

Do not edit catalog skills here. Change them in iurysza/agent-skills. Add or remove this repo in \`consumers.yml\`.

### Catalog skills in this copy

${names}

---
_Opened by the agent-skills fan-out workflow._
EOF
}

git_configure_bot() {
  git -C "$1" config user.name "github-actions[bot]"
  git -C "$1" config user.email "41898282+github-actions[bot]@users.noreply.github.com"
}

cmd_prepare_pr() {
  local repo_dir="" source="$repo_root/skills" dest_path=".agents/skills"
  local dry_run=0 do_commit=0 do_push=0
  local pr_branch="chore/vendor-agent-skills"
  local pr_title="chore(skills): sync iurysza/agent-skills from main"
  local consumer_repo=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --repo-dir) repo_dir="$2"; shift 2 ;;
      --source) source="$2"; shift 2 ;;
      --path) dest_path="$2"; shift 2 ;;
      --pr-branch) pr_branch="$2"; shift 2 ;;
      --pr-title) pr_title="$2"; shift 2 ;;
      --consumer-repo) consumer_repo="$2"; shift 2 ;;
      --dry-run) dry_run=1; shift ;;
      --commit) do_commit=1; shift ;;
      --push) do_push=1; shift ;;
      -h|--help) usage; return 0 ;;
      *) die "unknown prepare-pr argument: $1" ;;
    esac
  done
  [[ -n "$repo_dir" && -d "$repo_dir/.git" ]] || die "prepare-pr requires --repo-dir GIT_DIR"
  [[ "$dest_path" != /* ]] || die "path must be relative: $dest_path"

  local dest="$repo_dir/$dest_path"
  local sha
  sha="$(source_sha)"

  if [[ "$dry_run" == "1" ]]; then
    vendor_tree "$source" "$dest" 1
    if catalog_current "$source" "$dest"; then
      log "prepare-pr: no catalog changes for ${consumer_repo:-$repo_dir}"
      printf 'unchanged\t%s\t%s\n' "${consumer_repo:-local}" "$dest_path"
    else
      log "prepare-pr: would commit and open/update PR for ${consumer_repo:-$repo_dir}"
      printf 'would-update\t%s\t%s\n' "${consumer_repo:-local}" "$dest_path"
    fi
    return 0
  fi

  vendor_tree "$source" "$dest" 0

  if [[ "$do_commit" != "1" ]]; then
    if [[ -z "$(git -C "$repo_dir" status --porcelain -- "$dest_path")" ]]; then
      printf 'unchanged\t%s\t%s\n' "${consumer_repo:-local}" "$dest_path"
    else
      printf 'dirty\t%s\t%s\n' "${consumer_repo:-local}" "$dest_path"
    fi
    return 0
  fi

  git_configure_bot "$repo_dir"
  local default_branch
  default_branch="$(git -C "$repo_dir" rev-parse --abbrev-ref HEAD)"
  git -C "$repo_dir" checkout -B "$pr_branch"
  git -C "$repo_dir" add --all -- "$dest_path"
  if git -C "$repo_dir" diff --cached --quiet; then
    log "prepare-pr: already current ${consumer_repo:-$repo_dir}"
    printf 'unchanged\t%s\t%s\n' "${consumer_repo:-local}" "$dest_path"
    return 0
  fi
  git -C "$repo_dir" commit --message "$(cat <<EOF
chore(skills): vendor iurysza/agent-skills from main

Source: iurysza/agent-skills@${sha}
Target: ${dest_path}
Always-latest overlay; no lockfile.
EOF
)"

  if [[ "$do_push" != "1" ]]; then
    printf 'committed\t%s\t%s\n' "${consumer_repo:-local}" "$dest_path"
    return 0
  fi

  [[ -n "${SKILLS_SYNC_TOKEN:-}" ]] || die "SKILLS_SYNC_TOKEN is not set. Cross-repo PRs require a PAT or GitHub App token with contents:write and pull-requests:write on each consumer. Add it as the agent-skills repository secret SKILLS_SYNC_TOKEN. GITHUB_TOKEN cannot open PRs in other repositories."
  [[ -n "$consumer_repo" ]] || die "--push requires --consumer-repo owner/name"

  GH_TOKEN="$SKILLS_SYNC_TOKEN" gh auth setup-git >/dev/null
  if ! git -C "$repo_dir" push --force origin "HEAD:refs/heads/${pr_branch}"; then
    log "failed to push ${pr_branch} to $consumer_repo"
    return 1
  fi

  local body pr_number
  body="$(pr_body "$sha" "$dest_path" "$source")"
  pr_number="$(GH_TOKEN="$SKILLS_SYNC_TOKEN" gh pr list --repo "$consumer_repo" --head "$pr_branch" --json number --jq '.[0].number // empty')"
  if [[ -n "$pr_number" ]]; then
    log "updated existing PR #$pr_number on $consumer_repo"
    printf 'updated-pr\t%s\t%s\n' "$consumer_repo" "$dest_path"
    return 0
  fi
  GH_TOKEN="$SKILLS_SYNC_TOKEN" gh pr create \
    --repo "$consumer_repo" \
    --base "$default_branch" \
    --head "$pr_branch" \
    --title "$pr_title" \
    --body "$body"
  printf 'opened-pr\t%s\t%s\n' "$consumer_repo" "$dest_path"
}

clone_consumer() {
  local repo="$1" dest="$2" token="${3:-}"
  if [[ -n "$token" ]]; then
    GH_TOKEN="$token" gh repo clone "$repo" "$dest" -- --depth 1
  else
    git clone --depth 1 "https://github.com/${repo}.git" "$dest"
  fi
}

require_sync_token() {
  if [[ -z "${SKILLS_SYNC_TOKEN:-}" ]]; then
    die "SKILLS_SYNC_TOKEN is not set. Cross-repo PRs require a PAT or GitHub App token with contents:write and pull-requests:write on each enabled consumer (and metadata read). Add it as the agent-skills repository secret named SKILLS_SYNC_TOKEN. A workflow GITHUB_TOKEN cannot open pull requests in other repositories. Re-run with --dry-run to plan without credentials."
  fi
}

cmd_fanout() {
  local manifest="$default_manifest" dry_run=0 only=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --manifest) manifest="$2"; shift 2 ;;
      --dry-run) dry_run=1; shift ;;
      --only) only="$2"; shift 2 ;;
      -h|--help) usage; return 0 ;;
      *) die "unknown fanout argument: $1" ;;
    esac
  done

  local json source_rel pr_branch pr_title source
  json="$(parse_manifest "$manifest")"
  export CONSUMERS_JSON="$json"
  source_rel="$(python3 -c 'import json,os; print(json.loads(os.environ["CONSUMERS_JSON"])["source"])')"
  pr_branch="$(python3 -c 'import json,os; print(json.loads(os.environ["CONSUMERS_JSON"])["pr_branch"])')"
  pr_title="$(python3 -c 'import json,os; print(json.loads(os.environ["CONSUMERS_JSON"])["pr_title"])')"
  source="$repo_root/$source_rel"
  [[ -d "$source" ]] || die "source directory missing: $source"

  if [[ "$dry_run" != "1" ]]; then
    require_sync_token
  fi

  local workdir
  workdir="$(mktemp -d "${TMPDIR:-/tmp}/skills-fanout.XXXXXX")"
  trap 'rm -rf "'"$workdir"'"' RETURN

  local failures=0 matched=0
  while IFS=$'\t' read -r repo path enabled; do
    [[ -n "$repo" ]] || continue
    if [[ -n "$only" && "$repo" != "$only" ]]; then
      continue
    fi
    if [[ "$enabled" != "1" ]]; then
      if [[ -n "$only" ]]; then
        die "consumer $repo is disabled in $manifest"
      fi
      continue
    fi
    matched=$((matched + 1))
    log "=== $repo -> $path ==="
    local checkout="$workdir/$repo"
    mkdir -p "$(dirname "$checkout")"
    if ! clone_consumer "$repo" "$checkout" "${SKILLS_SYNC_TOKEN:-}"; then
      log "failed to clone $repo"
      failures=$((failures + 1))
      continue
    fi
    local args=(--repo-dir "$checkout" --source "$source" --path "$path"
                --pr-branch "$pr_branch" --pr-title "$pr_title" --consumer-repo "$repo")
    if [[ "$dry_run" == "1" ]]; then
      args+=(--dry-run)
    else
      args+=(--commit --push)
    fi
    if ! cmd_prepare_pr "${args[@]}"; then
      log "failed to sync $repo"
      failures=$((failures + 1))
    fi
  done < <(CONSUMERS_JSON="$json" python3 - <<'PY'
import json, os
data = json.loads(os.environ["CONSUMERS_JSON"])
for consumer in data["consumers"]:
    enabled = "1" if consumer.get("enabled", True) else "0"
    print(f"{consumer['repo']}\t{consumer['path']}\t{enabled}")
PY
)

  if [[ -n "$only" && "$matched" -eq 0 ]]; then
    die "no enabled consumer matched --only $only"
  fi
  if [[ "$matched" -eq 0 ]]; then
    die "no enabled consumers in $manifest"
  fi
  if [[ "$failures" -gt 0 ]]; then
    die "$failures consumer(s) failed"
  fi
}

main() {
  [[ $# -gt 0 ]] || { usage; exit 1; }
  case "$1" in
    vendor) shift; cmd_vendor "$@" ;;
    print-consumers) shift; cmd_print_consumers "$@" ;;
    prepare-pr) shift; cmd_prepare_pr "$@" ;;
    fanout) shift; cmd_fanout "$@" ;;
    -h|--help) usage ;;
    *) die "unknown command: $1" ;;
  esac
}

main "$@"
