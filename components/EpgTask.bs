sub init()
    m.top.functionName = "runTask"
end sub

sub runTask()
    url = m.top.url.Trim()
    if url = "" then
        m.top.error = "Nenhuma URL de EPG configurada."
        return
    end if

    response = httpGet(url, m.top.userAgent, "")
    if not response.ok then
        m.top.error = "Não foi possível baixar o EPG: " + response.error
        return
    end if

    text = response.body
    if text = invalid or text = "" then
        m.top.error = "O EPG veio vazio."
        return
    end if
    if isGzipData(text) then
        ' O EPG do M3UPT e servido comprimido em gzip. O Roku nao tem
        ' inflator em BrightScript, entao o conteudo chega como bytes.
        m.top.unsupported = true
        m.top.error = "O EPG está comprimido (gzip) e o Roku não sabe descomprimir. Informe um XMLTV em texto puro em Ajustes."
        return
    end if
    if looksLikeHtml(text) then
        m.top.error = "O endereço do EPG retornou uma página HTML."
        return
    end if
    ' Um guia enorme nao cabe neste aparelho: avisar em vez de ficar minutos
    ' a processar e acabar morto pelo sistema.
    if Len(text) > 12582912 then
        m.top.error = "O EPG tem " + Str(Int(Len(text) / 1048576)).Trim() + " MB, demasiado para a memória do Roku. Use um guia mais curto."
        return
    end if

    now = getNowSeconds()
    epg = {}
    count = 0

    ' Um guia grande tem dezenas de milhares de linhas. Percorrer linha a
    ' linha, sem Split(), evita criar um array com todas elas e mantem a
    ' memoria baixa em aparelhos com pouca RAM.
    cursor = 1
    total = Len(text)
    current = invalid
    while cursor <= total
        newline = Instr(cursor, text, Chr(10))
        if newline = 0 then
            line = Mid(text, cursor)
            cursor = total + 1
        else
            line = Mid(text, cursor, newline - cursor)
            cursor = newline + 1
        end if
        line = line.Trim()
        if line <> "" then
            if Instr(1, line, "<programme") > 0 then
                current = {
                    channel: epgTagAttr(line, "channel")
                    start: xmltvEpoch(epgTagAttr(line, "start"))
                    stop: xmltvEpoch(epgTagAttr(line, "stop"))
                    title: ""
                }
                title = xmltvTitleOf(line)
                if title <> "" then
                    current.title = title
                    storeProgram(epg, current, now)
                    count = count + 1
                    current = invalid
                end if
            else if current <> invalid then
                title = xmltvTitleOf(line)
                if title <> "" then
                    current.title = title
                    if current.channel <> "" and current.start > 0 then
                        storeProgram(epg, current, now)
                        count = count + 1
                    end if
                    current = invalid
                end if
            end if
        end if
    end while

    if count = 0 then
        m.top.error = "O EPG não possui programas reconheciveis."
        return
    end if

    m.top.resultJson = FormatJson(epg)
    m.top.count = count
    m.top.success = true
end sub

sub storeProgram(epg as object, program as object, now as integer)
    if program.channel = "" or program.title = "" then return
    entry = epg[program.channel]
    if entry = invalid then
        entry = {
            nowTitle: ""
            nowStart: 0
            nowStop: 0
            nextTitle: ""
            nextStart: 0
        }
        epg[program.channel] = entry
    end if

    if program.start <= now and program.stop > now then
        entry.nowTitle = program.title
        entry.nowStart = program.start
        entry.nowStop = program.stop
    else if program.start > now then
        if entry.nextStart = 0 or program.start < entry.nextStart then
            entry.nextTitle = program.title
            entry.nextStart = program.start
        end if
    end if
end sub

function getNowSeconds() as integer
    dt = CreateObject("roDateTime")
    dt.Mark()
    return dt.AsSeconds()
end function
