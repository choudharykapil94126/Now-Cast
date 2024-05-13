' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.
sub ShowVideowithAds(contents as object)
    m.data = contents
    ' finding full url of add
    ' adUrl = m.global.vastTagUrl
    ' adUrl = ""
    print m.data, "which video is coming"
    print Left(m.data.url, 23)
    if m.global.enableVastTag = true and Left(m.data.url, 23) <> "https://www.youtube.com" and m.data.livetype <> "broadcasting"
        if m.global.loginToken <> ""
            if m.global.vastTagUrlLogedInFirstTime = true or m.global.vastTagUrlLogedInAndAgainCome = true
                if m.global.vastTagUrl <> "" and m.global.vastTagUrl <> invalid
                    ShowAdVideoScreen()
                else
                    ShowVideo()
                end if
            else
                ShowVideo()
            end if
        else
            if m.global.vastTagUrl <> "" and m.global.vastTagUrl <> invalid
                ShowAdVideoScreen()
            else
                ShowVideo()
            end if
        end if
    else
        ShowVideo()
    end if
    ' m.array = []
    ' m.array.push("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    ' dataResponse()
end sub


sub ShowAdVideoScreen()
    m.LoginTask = CreateObject("roSGNode", "AdsLogic")
    m.LoginTask.preRollAdd = m.global.vastTagUrl
    m.LoginTask.control = "RUN"
    m.LoginTask.observeField("data", "dataResponse")
    ' m.array = []
    ' m.array.push("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    ' dataResponse()

end sub

sub gettingAdsDataBetweenVideo()

    m.global.middleVideoPlayCheck = true
    m.global.checkVideoBeforeMiddleAds = true
    m.videoPreogress = m.videoPlayer.progress
    adUrl = m.global.vastTagUrlMiddle
    m.LoginTask = CreateObject("roSGNode", "AdsLogic")
    m.LoginTask.preRollAdd = adUrl
    m.LoginTask.control = "RUN"
    m.LoginTask.observeField("data", "dataResponse")
    ' m.array= []
    ' m.array.push("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    ' dataResponse()
end sub


sub dataResponse(event as object)
    ' sub dataResponse()
    if event.getData()[0] = ""
        ShowVideo()
    else
        if m.global.middleVideoPlayCheck = true
            CloseScreen(m.videoPlayer)
        end if
    
        playVideoAsMiddle = true
        m.adsVideoPlayer = CreateObject("roSGNode", "AdsScreen")
        m.adsVideoPlayer.urlArray = event.getData()
        ' m.adsVideoPlayer.urlArray = m.array
        m.adsVideoPlayer.observeField("checkBackButtonPress", "ShowVideo")
        m.adsVideoPlayer.observeField("backButtonOnAd", "backPrevScreenWhileClick")
        ShowScreen(m.adsVideoPlayer)
    end if
end sub

sub ShowVideo()

    CloseScreen(m.adsVideoPlayer)
    print "blablablabla",
    m.videoPlayer = CreateObject("roSGNode", "VideoScreen") ' create new instance of video node for each playback
    m.videoPlayer.content = m.data
    m.videoPlayer.itemFocused = true
    if m.videoPreogress <> invalid and m.videoPreogress > 0
        m.videoPlayer.progress = m.videoPreogress
    end if
    m.videoPlayer.ObserveField("itemFocused", "OnVideoPlayerVisibleChange")
    m.videoPlayer.ObserveField("itemFocusedInMiddle", "gettingAdsDataBetweenVideo")
    ShowScreen(m.videoPlayer) ' show video screen
end sub

sub backPrevScreenWhileClick()
    CloseScreen(m.adsVideoPlayer)
end sub

sub OnVideoPlayerVisibleChange() ' invoked when video state is changed
    print "AudioPlayerLogic : - OnAudioPlayerVisibleChange"
    if m.videoPlayer.itemFocused = false
        m.global.audioToListenBtn = ""
        CloseScreen(m.videoPlayer)
    end if
end sub




