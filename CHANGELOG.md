# Changelog

Todas as alterações relevantes do Saimo TV para Roku.
O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e
o versionamento segue [SemVer](https://semver.org/lang/pt-BR/).

## [Não publicado]

## [2.5.43] — 2026-11-13

### Adicionado
- **Preview do canal em foco**: ao abrir a app, o primeiro canal da grelhe
  começa a reproduzir numa janela no canto inferior direito (332 × 187 px), com
  o logótipo, o nome do canal e a fonte em uso. Cada canal novo focado troca a
  preview; ao carregar em **OK** o canal abre em ecrã inteiro, no mesmo ponto
  da reprodução. Só na grelhe de canais — as restantes telas não são afectadas.
- A preview não tem som (`mute`) e a moldura e os rótulos desaparecem quando
  o canal passa a ecrã inteiro.

### Corrigido
- O vídeo do player é um nó próprio da app, separado da preview: a Roku só
  permite um `Video` a tocar de cada vez, por isso a preview é parada antes
  de o player arrancar.

## [2.5.37] — 2026-11-12

### Corrigido
- **Grade de canais vazia no ecrã "Ao vivo"**: a grelhe era mostrada *antes* de
  `setViewHeader`, que a esconde de novo ao trocar de vista. Passou a ser
  mostrada depois.
- **Logos dos canais sobrepostos no "Descobrir"**: `setViewHeader` só
  escondia as prateleiras, pelo que a grelhe de canais ficava por cima delas.
  Passa a esconder todas as listas.
- **Contagens das letras do catálogo a zero**: o `FormatJson` do Roku escreve as
  chaves em minúsculas (`moviescount`), pelo que a leitura de `moviesCount`
  falhava e todas as contagens davam 0 — o ecrã mostrava "contagens
  indisponíveis". O `strField` passou a procurar também em minúsculas.
- **`strField` com valores numéricos**: chamava `ToStr()`, que não existe em
  inteiros no BrightScript (erro de runtime). Passa a usar `Str()`.
- **Letra do catálogo travada para sempre**: a varredura do ficheiro de fichas
  (4,2 MB, 51 mil linhas) usava `Instr` com posição, o que percorria o texto
  inteiro 51 mil vezes. Passou a usar `Split`, uma passagem nativa.
- **Carga de memória no catálogo**: o payload de cada letra desceu de 4,69 MB
  para 2,36 MB, deixando de repetir o User-Agent em cada fonte.
- **Cache inútil**: `roFileSystem` só pode ser criado nas threads MAIN e TASK;
  na thread de render dava erro em cada leitura, pelo que o cache nunca
  funcionava.
- **Atributos XML inválidos**: `width`/`height` em `LabelList`, `MarkupGrid`,
  `RowList` e `BusySpinner` não existem no Roku e eram descartados com aviso.

### Adicionado
- **Grelha de canais** no ecrã "Ao vivo": 4 × 4 cartões com o logótipo oficial,
  o nome, a categoria e o programa em direto com progresso.
- **Canais prioritários** no topo: Globo, Globo SP, Globo RJ, Globo RS,
  Globo MG, Globo ES, Globo DF, SBT, SBT News, Band, Band SP, Band News,
  Record, Record SP, Record News e outros. A comparação ignora acentos,
  espaços e pontuação.
- **Categoria fixa "Canais de Portugal"**: lista pública do M3UPT
  (https://m3upt.com/iptv) com 432 canais de TV, rádios e beachcams, com os
  cabeçalhos HTTP que cada emissor exige. Entra ao lado da lista do utilizador,
  sem a substituir.
- **Barra de progresso** ao abrir uma letra do catálogo, uma série ou uma
  busca, com texto do que está a ser carregado.
- **Contadores nas categorias** do menu lateral.

### Alterado
- **Resolução nativa a 1280 × 720** (`ui_resolutions=hd`). A app desenhava a
  1920 × 1080 e o Roku reduzia; agora coordena, dimensões e imagens estão
  dimensionados para 720p. As fontes passaram a valores nativos maiores
  (corpo 16 → 22 px, títulos 24 → 32 px, ficha 43 → 52 px).
- **Menu lateral**: item alargado para 224 px e fonte própria, para que os
  nomes longos com contador caibam.
- **Grelha de filmes**: 6 colunas de 140 px, títulos em duas linhas.
- **Cache das letras**: só se guarda a letra aberta, porque o `cachefs` vive
  na RAM do aparelho.
- **EPG**: mensagem clara quando o endereço serve gzip (o Roku não sabe
  descomprimir) e recusa guias com mais de 12 MB.

## [2.5.19] — 2026-11-12

### Corrigido
- **Congelamento no arranque**: comparar dois `roAssociativeArray` com `<>`
  dá erro de tipo em BrightScript; o debugger do Roku suspendia as threads.
  O mesmo padrão existia no `parseM3u` original.
- **`roArray.Remove`/`Insert`**: não existem no Roku; o agrupamento das
  categorias passou a ser feito em duas passagens.

## [2.5.0] — 2026-11-12

### Adicionado
- Primeira versão pública: lista M3U de canais, catálogo VOD por letra
  (filmes, séries e episódios), favoritos, busca, guia de TV, ajustes e
  sincronização automática.

[2.5.43]: https://github.com/lgcosta/saimo-tv-roku/releases/tag/v2.5.43
[2.5.37]: https://github.com/lgcosta/saimo-tv-roku/releases/tag/v2.5.37
[2.5.19]: https://github.com/lgcosta/saimo-tv-roku/releases/tag/v2.5.19
[2.5.0]: https://github.com/lgcosta/saimo-tv-roku/releases/tag/v2.5.0
