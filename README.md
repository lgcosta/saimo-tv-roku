# Saimo TV para Roku

Cliente pessoal, não oficial, para Roku TV. Lê listas M3U de canais ao vivo e
um catálogo VOD público (filmes, séries e episódios), e acrescenta a lista
portuguesa do [M3UPT](https://github.com/LITUATUI/M3UPT) como categoria fixa.

## O que faz

- **Ao vivo** — grelha de canais com o logótipo, o nome, a categoria e o
  programa em direto. Canais prioritários (Globo, SBT, Band, Record…) no topo.
- **Descobrir** — prateleiras editoriais do catálogo público.
- **Catálogo A–Z** — filmes e séries por letra, com capas carregadas em
  segundo plano.
- **Listas M3U do utilizador** — cada lista que acrescentares em Ajustes entra
  na grelha como mais um grupo, ao lado da tua e dos Canais de Portugal.
- **Favoritos, Busca, Guia de TV e Ajustes** — lista M3U configurável, EPG
  XMLTV, agente HTTP e diagnóstico.
- **Canais de Portugal** — 432 canais do M3UPT, ao lado da sua lista.

## Requisitos

- Roku TV ou Roku player com **Roku OS 11 ou superior**.
- Resolução nativa **1280 × 720** (`ui_resolutions=hd`).
- Fontes TrueType incluídas (Roboto, Apache 2.0).

## Instalação

**Na TV (modo desenvolvedor):**

1. No comando remoto: `Home ×3`, `Up ×2`, `Right`, `Left`, `Right`, `Left`,
   `Right`.
2. Aceite a licença e defina uma palavra-passe. A TV reinicia em modo
   desenvolvedor.
3. Abra `http://<IP-DA-TV>` no browser, entre com `rokudev` e a palavra-passe
   e use **Development Application Installer → Upload** com o `.zip` das
   releases.

**Linha de comandos:**

```bash
curl -X POST --digest -u "rokudev:<PASSWORD>" \
     -F "mysubmit=Install" -F "archive=@saimo-tv-pkg.zip" \
     "http://<IP-DA-TV>/plugin_install"
```

O instalador responde na **porta 80** (na 8060 devolve 404) e confirma com
`Install Success.`.

## Diagnóstico

```bash
telnet <IP-DA-TV> 8085     # consola BrightScript
curl http://<IP-DA-TV>:8060/query/active-app
```

A app imprime marcadores na consola (`SAIMO init`, `SAIMO Portugal`,
`SAIMO letra …`), úteis para confirmar que cada etapa arrancou.

## Estrutura

```
manifest            metadados do pacote Roku
source/
  main.brs           ponto de entrada
  bslib.brs          biblioteca: parsers, HTTP, catálogo Saimo, M3UPT
  theme.brs          paleta e cores
components/
  MainScene.*        tela principal (brs + xml)
  ChannelCard.*      cartão de canal (logo, nome, programa)
  VodCard.*          cartão de filme/série
  EpisodeCard.*      cartão de episódio
  ShelfCard.*        cartão de prateleira
  ActionPill.*       botão de ação
  SeasonChip.*      botão de temporada
  FetchTask.*        tarefa de fundo: lista, índice, letras, capas
  EpgTask.*          tarefa de fundo: guia XMLTV
images/  fonts/      recursos
```

## Limitações conhecidas

- O **EPG do M3UPT** é servido comprimido em gzip (37,9 MB descomprimido). O
  Roku não sabe descomprimir nem guardar um guia desse tamanho; para ter guia,
  aponte um XMLTV em texto puro em **Ajustes → URL do EPG**.
- Canais com DRM **ClearKey** e o conteúdo *on demand* do M3UPT ficam de fora:
  o Roku só reproduz Widevine, PlayReady e AES-128.
- Ao vivo não pausa nem faz busca, como em qualquer transmissão em direto.
- Sem DRM, telemetria, atualizador do APK ou integração com o Saimo Connect.

## Licença

Código sob licença MIT. As fontes Roboto estão sob Apache 2.0
(`fonts/Roboto-LICENSE.txt`).

Este projeto não é afiliado à Saimo. Use apenas fontes de conteúdo que tenha
permissão para aceder e distribuir.
