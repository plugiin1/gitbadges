#!/usr/bin/env bash
# Quickdraw: fechar uma issue (ou PR) em menos de 5 minutos apos abrir.
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/lib.sh
require_gh

url="$(gh issue create --repo "$REPO" --title "Quickdraw $(date -u +%FT%TZ)" \
      --body "Issue criada e fechada em seguida para a conquista Quickdraw." | tail -1)"
log "Issue aberta: $url"
sleep 5
gh issue close "$url" --repo "$REPO" --reason completed >/dev/null
log "Fechada em segundos. Quickdraw garantido."
