# gitbadges

Scripts para obter as conquistas (Achievements) do GitHub neste repositório.

> Ative primeiro em **Settings → Profile → Show Achievements**, senão nada aparece no perfil.
> Os badges costumam levar de alguns minutos até ~24h para aparecer.

## Pré-requisitos

```bash
winget install GitHub.cli     # Windows
gh auth login
```

Rode os scripts no Git Bash, a partir da raiz do repositório.

## O que dá para conseguir

| Conquista | Como | Script |
|---|---|---|
| **Pull Shark** | 2 PRs merged (16 = prata, 128 = ouro, 1024 = diamante) | `./scripts/pull-shark.sh 2` |
| **YOLO** | Mesclar um PR sem review | `./scripts/yolo.sh` |
| **Quickdraw** | Fechar uma issue/PR em < 5 min | `./scripts/quickdraw.sh` |
| **Pair Extraordinaire** | PR merged com commit co-autorado | `./scripts/pair-extraordinaire.sh "Nome" "email"` |
| **Galaxy Brain** | 2 respostas aceitas em Discussions | `./scripts/galaxy-brain.sh` |

### Tudo de uma vez

```bash
./scripts/yolo.sh
./scripts/quickdraw.sh
./scripts/pull-shark.sh 16
```

## O que **não** dá para fazer aqui

- **Starstruck** (16 stars num repo) — depende de outras pessoas darem star. Comprar/trocar stars viola os Termos de Serviço do GitHub e pode custar a conta; não há script para isso.
- **Public Sponsor** — exige patrocinar alguém de verdade no GitHub Sponsors (dinheiro real, feito na web).
- **Heart On Your Sleeve**, **Open Sourcerer**, **Arctic Code Vault Contributor**, **Mars 2020 Contributor** — aposentadas pelo GitHub; não são mais concedidas.

## Detalhes por conquista

### Pair Extraordinaire
O e-mail do co-autor precisa estar ligado a uma conta real do GitHub. O mais seguro é
o e-mail `noreply`, que aparece em **Settings → Emails** da conta do co-autor, no formato
`12345678+usuario@users.noreply.github.com`. Se o avatar do co-autor não aparecer na
página do commit, o e-mail está errado e a conquista não conta.

### Galaxy Brain
Requer **Discussions** habilitado (Settings → General → Features) e uma categoria do tipo
*Answerable* (Q&A). O script cria a discussão e posta a resposta; marcar como **Mark as answer**
é feito na interface web. São necessárias 2 respostas aceitas.

### Sobre os limites
Os scripts inserem uma pausa entre PRs (`DELAY=5` por padrão) para não bater no rate limit
da API. Para 128 ou 1024 PRs, aumente: `DELAY=15 ./scripts/pull-shark.sh 128`.
