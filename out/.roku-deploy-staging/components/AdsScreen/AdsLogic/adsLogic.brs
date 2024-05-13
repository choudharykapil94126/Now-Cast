Library "Roku_Ads.brs"

sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    try
        m.ads = Roku_Ads() 'RAF initialize
        m.ads.enableAdMeasurements(true)
        m.ads.setContentGenre("Entertainment")
        m.ads.setContentId("CSASAdSample")
        m.ads.setContentLength(600)

        m.ads.SetDebugOutput(true) 'for debug purpose
        m.ads.SetAdPrefs(false)
        m.ads.SetAdURL(m.top.preRollAdd)

        m.adPods = m.ads.GetAds()
        array = m.adPods[0].ads
        allUrls = []
        ' m.adsVideoPlayer.observeField("backButtonOnAd", "")
        for each i in m.adPods[0].ads[0].streams
            allUrls.push(i.url)
        end for
        m.top.data = allUrls
    catch e
        print "ad urls timer over"
        m.top.data = [""]
    end try
end sub

