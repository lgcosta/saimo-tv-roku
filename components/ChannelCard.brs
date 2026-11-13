sub init()
    m.logo = m.top.findNode("logo")
    m.title = m.top.findNode("title")
    m.meta = m.top.findNode("meta")
    m.program = m.top.findNode("program")
    m.focusHalo = m.top.findNode("focusHalo")
    m.logoUri = ""
    m.logo.observeField("loadStatus", "onLogoLoadStatus")
end sub

sub showItem()
    item = m.top.itemContent
    if item = invalid then return
    m.logoUri = strField(item, "hdGridPosterUrl")
    if m.logoUri = "" then m.logoUri = strField(item, "hdPosterUrl")
    m.title.text = strField(item, "shortDescriptionLine1")
    if m.title.text = "" then m.title.text = strField(item, "title")
    m.meta.text = strField(item, "shortDescriptionLine2")
    m.program.text = strField(item, "shortDescriptionLine3")
    m.logo.uri = "pkg:/images/placeholder.png"
    loadLogo()
end sub

sub updateFocus()
    if m.top.itemHasFocus then
        m.focusHalo.opacity = 0.2 + (m.top.focusPercent * 0.8)
        loadLogo()
    else
        m.focusHalo.opacity = 0
    end if
end sub

sub loadLogo()
    if m.logoUri <> "" and m.logo.uri <> m.logoUri then m.logo.uri = m.logoUri
end sub

sub onLogoLoadStatus()
    status = m.logo.loadStatus
    uri = m.logo.uri
    if Left(LCase(uri), 7) <> "http://" and Left(LCase(uri), 8) <> "https://" then return
    if status = "loading" or status = "ready" or status = "failed" then
        print "SAIMO_IMAGE channel " + status + " " + uri
    end if
end sub
