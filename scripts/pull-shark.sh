#!/usr/bin/env bash
# Pull Shark: PRs merged no repo. 2 = bronze, 16 = prata, 128 = ouro, 1024 = diamante.
# Uso: ./scripts/pull-shark.sh [quantidade]  (padrao: 2)
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/lib.sh
require_gh

N="${1:-2}"
START_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
trap 'git switch --quiet "$START_BRANCH" || true' EXIT

log "Abrindo e mesclando $N PR(s) em $REPO (base: $BASE)"
for i in $(seq 1 "$N"); do
  url="$(open_pr "pull-shark" "chore: pull shark $i/$N")"
  git switch --quiet "$START_BRANCH"
  merge_pr "$url"
  log "[$i/$N] merged: $url"
  sleep "${DELAY:-5}"
done
log "Pronto. O badge costuma aparecer no perfil em ate ~24h."
