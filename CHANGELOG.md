# Changelog

Todas as alterações relevantes do Saimo TV para Roku.
O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e
o versionamento segue [SemVer](https://semver.org/lang/pt-BR/).

## [Não publicado]

## [2.7.0] — 2026-11-13

### Removido
- **Preview do canal em foco.** A janela de vídeo que acompanhava o cursor na
  grelhe gastava um segundo descodificador no aparelho e tapava os cartões de
  canal. O nome, o grupo e o programa em andamento passaram para a barra
  lateral, que é onde o utilizador já procura o estado da app.

### Adicionado
- **★ Favoritos de canais no menu.** A tecla de informação numa grelhe marca ou
  desmarca o canal em foco; a categoria aparece no menu logo abaixo de "Todos
  os canais" e o cartão passa a mostrar uma estrela antes do grupo. Usa os
  favoritos que a app já guardava, agora acessíveis sem passar pela vista de
  lista.
- **Recentes.** Os últimos 12 canais sintonizados ficam numa categoria própria,
  por ordem de utilização, para trocar entre os canais do dia sem percorrer 641
  cartões.
- **BrighterScript** como linguagem do projecto: `.bs` compilado para `.brs`
  pelo `bsc`, com validação de funções e tipos antes de empacotar.

### Corrigido
- **Títulos das categorias sobrepostos no "Descobrir".** A fileira do `RowList`
  tinha 204 px de altura e os cartões 306 px, pelo que cada fileira invadia o
  título da seguinte. A fileira passou a ser rótulo (24) + espaço (28) + cartão
  (196) = 252 px, e os cartões passaram a 118 px de largura, sem a folga morta
  de 50 px que os afastava.
- O cabeçalho do "Descobrir" saltava 64 px para a direita ao entrar na tela e
  voltava ao sítio ao sair; passou a ficar fixo.

### Alterado
- O `MainScene.brs` (4 300 linhas) foi repartido por onze ficheiros, um por
  responsabilidade (`scene-channels`, `scene-vod`, `scene-settings`,
  `scene-player`, `scene-keys`, …). As scripts de um componente partilham o
  mesmo âmbito, por isso o comportamento não muda.

## [2.6.0] — 2026-11-13

### Adicionado
- **Listas M3U do utilizador**: em *Ajustes → Adicionar lista M3U* guarda-se o
  endereço de uma lista, que passa a aparecer na grelha de canais como mais um
  grupo, ao lado da lista principal e dos Canais de Portugal. Cada lista tem
  *Actualizar*, *Remover* e *Cancelar*; se deixar de responder, o grupo
  desaparece em vez de ficar a mostrar canais velhos. Ficam guardadas no
  registry e são sincronizadas em fila (lista principal → Portugal → listas
  externas → catálogo VOD).
- A preview do canal em foco foi redimensionada e reposicionada (240 × 135 px,
  no canto inferior direito, por baixo da grelha), para deixar de cobrir os
  cartões de canal.

### Corrigido
- **App vazia depois de uma actualização**: o cache em `cachefs` é apagado
  quando a app é reinstalada, mas o registry sobrevive. A app via "sincronizado
  há pouco" e não voltava a descarregar nada, pelo que a grelha ficava a vazia
  até passarem as seis horas. Passa a sincronizar sempre que não há canais em
  cache.
- **Os diálogos não recebiam as teclas**: o `KeyboardDialog` era acrescentado
  como filho da cena (`appendChild`), o que não o torna modal — o foco ficava
  na lista de ajustes e as letras faziam pesquisa por inicial. Passa a ser
  atribuído ao campo `dialog` da cena, como manda a documentação da Roku, e a
  app acompanha o fecho automático com Back ou Home. Afectava a busca e todos
  os campos de texto dos Ajustes (URL da lista, fonte do catálogo, EPG e
  agente HTTP).
- **O programa em directo e o progresso nunca apareciam no cartão do canal**:
  `shortDescriptionLine3`, `shortDescriptionLine4` e `shortDescription` não
  existem no `ContentNode` deste firmware, que também não aceita campos com
  nome próprio. O programa passou a ir no campo standard `description`.
- **`Remove()` não existe no `roArray`**: a API é `Delete(index)`. Remover uma
  lista externa rebentava com um erro de runtime.
- A consola deixa de mostrar um aviso por canal sobre o campo inexistente.

## [2.5.44] — 2026-11-13

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

[2.5.44]: https://github.com/lgcosta/saimo-tv-roku/releases/tag/v2.5.44
[2.5.37]: https://github.com/lgcosta/saimo-tv-roku/releases/tag/v2.5.37
