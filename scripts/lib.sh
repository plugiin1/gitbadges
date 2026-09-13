#!/usr/bin/env bash
# Funcoes comuns aos scripts de conquistas.
set -euo pipefail

REPO="${REPO:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"
BASE="${BASE:-$(gh repo view "$REPO" --json defaultBranchRef -q .defaultBranchRef.name)}"

log() { printf '\033[36m==>\033[0m %s\n' "$*"; }

require_gh() {
  command -v gh >/dev/null || { echo "gh CLI nao encontrado. Instale: winget install GitHub.cli"; exit 1; }
  gh auth status >/dev/null 2>&1 || { echo "Faca login: gh auth login"; exit 1; }
}

# cria branch, commit, PR e ecoa o numero do PR
# uso: open_pr <slug> <mensagem-commit> [trailer]
open_pr() {
  local slug="$1" msg="$2" trailer="${3:-}"
  local branch="badge/${slug}-$(date +%s)-$RANDOM"

  git fetch origin "$BASE" --quiet
  git switch --quiet -c "$branch" "origin/$BASE"

  mkdir -p farm
  printf '%s | %s\n' "$(date -u +%FT%TZ)" "$slug" >> "farm/${slug}.log"
  git add farm

  if [ -n "$trailer" ]; then
    git commit --quiet -m "$msg" -m "$trailer"
  else
    git commit --quiet -m "$msg"
  fi

  git push --quiet -u origin "$branch"
  gh pr create --base "$BASE" --head "$branch" --title "$msg" --body "Automatizado por scripts/ deste repo." \
    | tail -1
}
