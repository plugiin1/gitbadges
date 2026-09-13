#!/usr/bin/env bash
# Galaxy Brain: 2 respostas aceitas em GitHub Discussions.
# Pre-requisito: Discussions habilitado (Settings > General > Features > Discussions)
# e uma categoria do tipo "Answerable" (Q&A).
# Este script cria a discussao e posta a resposta; MARCAR como resposta e feito na web.
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/lib.sh
require_gh

TITLE="${1:-Duvida $(date -u +%FT%TZ)}"
TMP="$(mktemp)"
gh api graphql -f query='
  query($owner:String!,$name:String!){
    repository(owner:$owner,name:$name){
      id
      discussionCategories(first:20){nodes{id name isAnswerable}}
    }
  }' -F owner="${REPO%%/*}" -F name="${REPO##*/}" > "$TMP"

REPO_ID="$(jq -r .data.repository.id "$TMP")"
CAT_ID="$(jq -r '.data.repository.discussionCategories.nodes[] | select(.isAnswerable) | .id' "$TMP" | head -1)"
[ -n "$CAT_ID" ] && [ "$CAT_ID" != "null" ] || { echo "Nenhuma categoria Q&A. Habilite Discussions e crie uma categoria 'Answerable'."; exit 1; }

D_ID="$(gh api graphql -f query='
  mutation($r:ID!,$c:ID!,$t:String!,$b:String!){
    createDiscussion(input:{repositoryId:$r,categoryId:$c,title:$t,body:$b}){discussion{id url}}
  }' -F r="$REPO_ID" -F c="$CAT_ID" -F t="$TITLE" -F b="Pergunta aberta para documentar a resposta." \
  --jq .data.createDiscussion.discussion.id)"

gh api graphql -f query='
  mutation($d:ID!,$b:String!){ addDiscussionComment(input:{discussionId:$d,body:$b}){comment{id url}} }' \
  -F d="$D_ID" -F b="Resposta detalhada aqui." --jq .data.addDiscussionComment.comment.url

log "Agora abra a discussao e clique em 'Mark as answer' na resposta. Repita 2x no total."
