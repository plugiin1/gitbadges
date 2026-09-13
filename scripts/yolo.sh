#!/usr/bin/env bash
# YOLO: mesclar um PR sem nenhuma review aprovando.
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/lib.sh
require_gh

START_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
trap 'git switch --quiet "$START_BRANCH" || true' EXIT

url="$(open_pr "yolo" "chore: yolo merge")"
git switch --quiet "$START_BRANCH"
gh pr merge "$url" --merge --delete-branch >/dev/null
log "YOLO garantido: $url"
