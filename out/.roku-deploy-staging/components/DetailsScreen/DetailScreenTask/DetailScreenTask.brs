sub Init()
    m.top.functionName = "MediaItemContent"
end sub

sub MediaItemContent()
    if m.global.loginToken <> ""
        tokenFound = CreateObject("roURLTransfer")
        tokenFound.SetCertificatesFile("common:/certs/ca-bundle.crt")
        tokenFound.SetURL(ApiUrl().adminServiceUrl + "mediaItem/" + m.top.mediaItemId)
        tokenFound.addHeader("Authorization", "Bearer " + m.global.loginToken)
        rsp = tokenFound.GetToString()
        json = ParseJson(rsp)
        m.top.response = json
    else
        xfer = CreateObject("roURLTransfer")
        xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
        xfer.SetURL(ApiUrl().adminServiceUrl + "mediaItem/mediaItemId/" + m.top.mediaItemId +"?organizationId="+ utility().organizationId)
        rsp = xfer.GetToString()
        json = ParseJson(rsp)
        m.top.response = json
    end if
 
end sub





