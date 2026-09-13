#!/usr/bin/env bash
# Pair Extraordinaire: PR merged com um commit co-autorado.
# O co-autor precisa ser uma conta REAL do GitHub, com o e-mail que ela usa
# (pode ser o e-mail noreply: ID+usuario@users.noreply.github.com).
# Uso: ./scripts/pair-extraordinaire.sh "Nome" "email@do.coautor"
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/lib.sh
require_gh

NAME="${1:-}"; EMAIL="${2:-}"
if [ -z "$NAME" ] || [ -z "$EMAIL" ]; then
  echo "uso: $0 \"Nome do co-autor\" \"email@do.coautor\"" >&2
  exit 1
fi

START_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
trap 'git switch --quiet "$START_BRANCH" || true' EXIT

url="$(open_pr "pair-extraordinaire" "chore: pair programming" "Co-authored-by: $NAME <$EMAIL>")"
git switch --quiet "$START_BRANCH"
gh pr merge "$url" --merge --delete-branch >/dev/null
log "PR co-autorado mesclado: $url"
log "Confira na pagina do commit se o avatar do co-autor aparece; se nao, o e-mail esta errado."
