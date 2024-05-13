
sub init ()
    ' print "AudioScreen.brs = > Init"
    ' m.di = CreateObject("roDeviceInfo")
    checkMiddleAdUrl()
    m.top.ObserveField("itemFocused", "OnItemFocusedChange")
    m.top.ObserveField("hitApi", "onHitApi")
    m.top.ObserveField("visible", "OnAudioVisibleChange")
    m.isLive = false
    ' ***********Accessing_XML_Values**********
    m.imageWhileLoading = m.top.findNode("imageWhileLoading")

    m.selectedItemPoster = m.top.findNode("selectedItemPoster")
    m.skipBackBtn = m.top.findNode("skipBackBtn")
    m.playPauseBtn = m.top.findNode("playPauseBtn")
    m.skipForwardBtn = m.top.findNode("skipForwardBtn")
    m.audioLoadingSpinner = m.top.findNode("audioLoadingSpinner")
    m.progressBarImageCircle = m.top.findNode("progressBarImageCircle")
    m.audioLoadingSpinner.poster.width = "30"
    m.audioLoadingSpinner.poster.height = "30"
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.timingLayout = m.top.findNode("timingLayout")
    m.videoUi = m.top.findNode("videoUi")
    m.backgroundimage = m.top.findNode("backgroundimage")
    m.timerForVideoUi = m.top.findNode("timerForVideoUi")
    m.timerForPlayingVideo = m.top.findNode("timerForPlayingVideo")
    m.liveLabel = m.top.findNode("liveLabel")

    m.timerForVideoUi.observeField("fire", "onTimerForVideoUi")
    m.timerForPlayingVideo.observeField("fire", "onTimerForPlayingVideo")
    m.popUpMessage = m.top.findNode("popUpMessage")
    m.popUpMessage.font = getFont(30, fontSet().bold)
    m.liveLabel.font = getFont(30, fontSet().bold)
    ' ************AccessingXML_values_related_to_Timer**********

    m.progressBar = m.top.findNode("progressBar")
    m.progressBarBackground = m.top.findNode("progressBarBackground")
    m.itemCurPosition = m.top.findNode("itemCurPosition")
    m.songDuration = m.top.findNode("songDuration")
    m.playPauseBtn.observeField("buttonSelected", "playpauseAudio")
    m.skipBackBtn.focusFootprintBitmapUri = UI_CONSTANTS().skipBackButton
    m.skipForwardBtn.focusFootprintBitmapUri = UI_CONSTANTS().skipForwardButton
    m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().playButton
    m.progressBarImageCircle.uri = UI_CONSTANTS().whiteCircle
    m.audioLoadingSpinner.uri = UI_CONSTANTS().spinnerLoader

    ' m.imageWhileLoading.width = int(calculateBannerHeightWidth(m.di.GetDisplaySize().w))
    ' m.imageWhileLoading.height = int(calculateBannerHeightWidth(m.di.GetDisplaySize().h))
end sub

sub checkMiddleAdUrl()
    m.LoginTask = CreateObject("roSGNode", "AdsLogic")
    m.LoginTask.preRollAdd = m.global.vastTagUrlMiddle
    m.LoginTask.control = "RUN"
    m.LoginTask.observeField("data", "dataResponse")
end sub

sub dataResponse(event as object)
    m.middleAdsUrls =  event.getData()
end sub

sub onTimerForVideoUi()
    m.videoUi.visible = false
end sub

sub onTimerForPlayingVideo()
    m.videoPlayer.control = "play"
end sub

sub onHitApi()
    if m.top.hitApi = true
        m.value = CreateObject("roSGNode", "CounterApiTask")
        m.value.itemId = m.itemId
        m.value.control = "RUN"
    end if
end sub

sub OnItemFocusedChange(event as object)' invoked when another item is focused
    ' print "AudioScreen.brs = > OnItemFocusedChange"
    if m.top.itemFocused
        details = event.GetRoSGNode()
        m.itemId = details.content.itemId
        m.selectedItemPoster.uri = details.content.detailPageBannerImage
        if m.top.content.liveType = "broadcasting"
            m.isLive = true
            m.liveLabel.visible = true
        end if
        audiocontent = createObject("RoSGNode", "ContentNode")
        audiocontent.url = details.content.url
        audiocontent.streamformat = details.content.streamformat
        m.videoPlayer.content = audiocontent
        m.videoPlayer.seekMode = "accurate"
        ' m.videoPlayer.control = "play"
        m.timerForPlayingVideo.control = "start"
        m.videoPlayer.observeField("state", "onPlayerState")
        m.videoPlayer.observeField("position", "onPlayerPosition")
        m.videoPlayer.observeField("downloadedSegment", "onDownloadedSegment")
    end if
end sub

sub onDownloadedSegment(event as object)
    if m.isLive = false

        print event.GetData(), "Download segment"
        sec = CreateObject("roRegistrySection", "Authentication")

        date = CreateObject("roDateTime")
        day = Str(date.GetDayOfMonth()).trim()
        month = Str(date.GetMonth()).trim()
        year = Str(date.GetYear()).trim()
        if date.GetMonth() < 10
            month = "0" + month
        end if

        if date.GetDayOfMonth() < 10
            day = "0" + day
        end if

        m.contentChannelTask = CreateObject("roSGNode", "DataTypeTask") ' create task for feed retrieving
        m.contentChannelTask.userId = sec.Read("loggedUserId").toInt()
        m.contentChannelTask.mediaId = m.itemId
        m.contentChannelTask.orgId = utility().organizationId.toInt()
        m.contentChannelTask.usage = event.GetData().segSize
        m.contentChannelTask.mediaType = "VOD"
        m.contentChannelTask.duration = m.itemCurPosition.text
        m.contentChannelTask.createdAt = year + "-" + month + "-" + day
        m.contentChannelTask.randomId = "123451234215"
        m.contentChannelTask.type = "ADD"
        m.contentChannelTask.socketType = "analytical"
        m.contentChannelTask.control = "run" ' GetContent(see MainLoaderTask.brs) method is executed
    end if
end sub

sub taskStateChanged(event as object)
    print "Player: taskStateChanged(), id = "; event.getNode(); ", "; event.getField(); " = "; event.getData()
    state = event.GetData()
    if state = "done" or state = "stop"
        ' exitPlayer()
        print "GET OUT IDIOT"
        ' m.videoPlayer.content = audiocontent
        ' m.videoPlayer.seekMode = "accurate"
        ' m.videoPlayer.control = "play"
    end if
end sub

sub onPlayerState ()
    ' print "AudioScreen.brs = > onPlayerState", m.top.content
    state = m.videoPlayer.state
    sec = CreateObject("roRegistrySection", "Authentication")
    ' print m.videoPlayer.playStartInfo , "VIDEO PLAYER"
    if m.isLive = false
        if state = "playing"
            m.top.hitApi = true
            m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().playButton
            m.selectedItemPoster.visible = false
            m.timerForVideoUi.control = "start"
            m.audioLoadingSpinner.visible = false
            m.skipBackBtn.visible = true
            m.playPauseBtn.visible = true
            m.skipForwardBtn.visible = true
        end if
        if state = "buffering" or state = "paused"
            m.timerForVideoUi.control = "stop"
            m.videoUi.visible = true
        end if
        if state = "buffering"
            m.audioLoadingSpinner.visible = true
            m.skipBackBtn.visible = false
            m.playPauseBtn.visible = false
            m.skipForwardBtn.visible = false
        end if
        ' close video screen in case of error or end of playback

        ' if state = "error" or state = "finished" or state = "stopped"
        if state = "error" or state = "finished"

            ' m.checkBroadcastingStatusTimer.control = "stop"
            ' CloseScreen(m.videoPlayer)\
            if state = "finished"
                m.timerForVideoUi.control = "stop"
                m.top.hitApi = false
                m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().pauseButton
                m.videoUi.visible = true
                if m.videoPlayer.duration > 3600
                    m.itemCurPosition.text = timeValue(Str(int(m.videoPlayer.duration / 3600))).trim() + ":" + timeValue(Str(int(m.videoPlayer.duration / 60) mod 60)).trim() + ":" + timeValue(Str(((m.videoPlayer.duration mod 60)))).trim()
                else
                    m.itemCurPosition.text = timeValue(Str(int(m.videoPlayer.duration / 60) mod 60)).trim() + ":" + timeValue(Str(((m.videoPlayer.duration mod 60)))).trim()
                end if
                passedProgreesBar = (820 / 100) * 100
                m.progressBar.width = passedProgreesBar
                m.progressBarImageCircle.translation = [(-3 + passedProgreesBar), -3]
            else
                m.videoPlayer.control = "stop"
                m.top.itemFocused = false
            end if
        end if
    else
        if state = "error" or state = "finished" or state = "stopped"
            if m.isLive
                m.top.itemFocused = false

                m.contentChannelTask = CreateObject("roSGNode", "DataTypeTask") ' create task for feed retrieving
                m.contentChannelTask.userId = sec.Read("loggedUserId").toInt()
                m.contentChannelTask.mediaId = m.itemId
                m.contentChannelTask.orgId = utility().organizationId.toInt()
                m.contentChannelTask.usage = ""
                m.contentChannelTask.mediaType = ""
                m.contentChannelTask.duration = ""
                m.contentChannelTask.createdAt = ""
                m.contentChannelTask.randomId = Rnd(10000)
                m.contentChannelTask.type = "REMOVE"
                m.contentChannelTask.socketType = "viewer"
                m.contentChannelTask.control = "run"

            end if
        else if state = "playing"
            m.selectedItemPoster.visible = false
            m.playPauseBtn.visible = true
            m.audioLoadingSpinner.visible = false
            m.playPauseBtn.setFocus(true)
            m.timerForVideoUi.control = "start"

            m.contentChannelTask = CreateObject("roSGNode", "DataTypeTask") ' create task for feed retrieving
            m.contentChannelTask.userId = sec.Read("loggedUserId").toInt()
            m.contentChannelTask.mediaId = m.itemId
            m.contentChannelTask.orgId = utility().organizationId.toInt()
            m.contentChannelTask.usage = ""
            m.contentChannelTask.mediaType = ""
            m.contentChannelTask.duration = ""
            m.contentChannelTask.createdAt = ""
            m.contentChannelTask.randomId = Rnd(10000)
            m.contentChannelTask.type = "ADD"
            m.contentChannelTask.socketType = "viewer"
            m.contentChannelTask.control = "run"

        else if state = "buffering" or state = "paused"
            m.timerForVideoUi.control = "stop"
            m.videoUi.visible = true


            m.contentChannelTask = CreateObject("roSGNode", "DataTypeTask") ' create task for feed retrieving
            m.contentChannelTask.userId = sec.Read("loggedUserId").toInt()
            m.contentChannelTask.mediaId = m.itemId
            m.contentChannelTask.orgId = utility().organizationId.toInt()
            m.contentChannelTask.usage = ""
            m.contentChannelTask.mediaType = ""
            m.contentChannelTask.duration = ""
            m.contentChannelTask.createdAt = ""
            m.contentChannelTask.randomId = Rnd(10000)
            m.contentChannelTask.type = "REMOVE"
            m.contentChannelTask.socketType = "viewer"
            m.contentChannelTask.control = "run"
        else if state = "buffering"
            m.audioLoadingSpinner.visible = true
            m.playPauseBtn.visible = false
        end if
    end if
    ' print m.audio.state
end sub

function timeValue(s as string)
    if Len(s) = 2
        return "0" + s.trim()
    end if
    return s.trim()
end function

sub onPlayerPosition()
    ' print "AudioScreen.brs = > onPlayerPosition"
    if m.global.enableVastTag = true and m.middleAdsUrls[0] <> "" and Left(m.top.content.url, 23) <> "https://www.youtube.com" and m.top.content.livetype <> "broadcasting"
        if m.global.loginToken <> ""
            if m.global.vastTagUrlLogedInFirstTime = true or m.global.vastTagUrlLogedInAndAgainCome = true
                if m.global.vastTagUrlMiddle <> invalid and m.global.vastTagUrlMiddle <> ""
                    goToAfterMiddleAdsVideo()
                end if
            end if
        else 
            if m.global.vastTagUrlMiddle <> invalid and m.global.vastTagUrlMiddle <> ""
                goToAfterMiddleAdsVideo()
            end if
        end if
    end if

    if m.isLive <> true
        if m.videoPlayer.position < 1
            m.audioLoadingSpinner.visible = false
            m.skipBackBtn.visible = true
            m.playPauseBtn.visible = true
            m.skipForwardBtn.visible = true
            m.progressBarBackground.visible = true
            m.progressBar.visible = true
            m.playPauseBtn.setFocus(true)
        end if
        if m.videoPlayer.duration > 3600
            m.songDuration.text = timeValue(Str(int(m.videoPlayer.duration / 3600))).trim() + ":" + timeValue(Str(int(m.videoPlayer.duration / 60) mod 60)).trim() + ":" + timeValue(Str(((m.videoPlayer.duration mod 60)))).trim()
            m.itemCurPosition.text = timeValue(Str(int(m.videoPlayer.position / 3600))).trim() + ":" + timeValue(Str(int(m.videoPlayer.position / 60) mod 60)) + ":" + timeValue(Str(m.videoPlayer.position mod 60)).trim()
        else
            m.songDuration.text = timeValue(Str(int(m.videoPlayer.duration / 60) mod 60)).trim() + ":" + timeValue(Str(((m.videoPlayer.duration mod 60)))).trim()
            m.itemCurPosition.text = timeValue(Str(int(m.videoPlayer.position / 60) mod 60)).trim() + ":" + timeValue(Str(m.videoPlayer.position mod 60)).trim()
        end if

        passedAudioProgress = (m.videoPlayer.position / m.videoPlayer.duration) * 100
        passedProgreesBar = (820 / 100) * passedAudioProgress
        m.progressBar.width = passedProgreesBar
        m.progressBarImageCircle.translation = [(-3 + passedProgreesBar), -3]
    end if

end sub

sub goToAfterMiddleAdsVideo()
    if m.global.middleVideoPlayCheck = true
        m.videoPlayer.seek = m.top.progress
        m.global.middleVideoPlayCheck = false
    end if
    if m.global.checkVideoBeforeMiddleAds = false
        if INT(m.videoPlayer.position) >=  m.videoPlayer.duration/2
            print "we are inside the middleads"
            m.videoPlayer.control = "stop"
            m.top.progress = m.videoPlayer.position
            m.top.itemFocusedInMiddle = true
        end if
    end if
end sub

sub OnAudioVisibleChange() ' invoked when video node visibility is changed
    ' print "AudioScreen.brs = > OnAudioVisibleChange"
    m.timerForPlayingVideo.control = "stop"
    m.videoPlayer.control = "stop"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    ' print "AudioScreen.brs = > onKeyEvent", key, press

    result = false
    if press then

        if(key = "back")
            m.top.itemFocused = false
        end if

        if(key = "right" or key = "fastforward") and m.videoPlayer.state <> "buffering" and m.videoPlayer.control <> "pause"
            if m.videoPlayer.position = m.videoPlayer.duration or (m.videoPlayer.position < m.videoPlayer.duration and m.videoPlayer.position > m.videoPlayer.duration - 1)
                return true
            end if
            if m.videoPlayer.position + 10 > m.videoPlayer.duration
                m.videoPlayer.seek = m.videoPlayer.duration
            else
                m.videoPlayer.seek = m.videoPlayer.position + 10
            end if
            if (m.videoPlayer.control = "resume" or m.videoPlayer.control = "play")
                m.videoPlayer.control = "resume"
            else
                m.videoPlayer.control = "pause"
            end if
            result = true
        else if(key = "left" or key = "rewind") and m.videoPlayer.state <> "buffering" and m.videoPlayer.control <> "pause"
            if m.videoPlayer.position = m.videoPlayer.duration or (m.videoPlayer.position < m.videoPlayer.duration and m.videoPlayer.position > m.videoPlayer.duration - 1)
                m.videoPlayer.seek = m.videoPlayer.position - 10
                return true
            end if
            if m.videoPlayer.position - 10 < 0
                m.videoPlayer.seek = 0
            else
                m.videoPlayer.seek = m.videoPlayer.position - 10
            end if
            if (m.videoPlayer.control = "resume" or m.videoPlayer.control = "play")
                m.videoPlayer.control = "resume"
            else
                m.audio.control = "pause"
            end if
            result = true
        else if (key = "play") or (key = "OK" and m.playPauseBtn.hasFocus())
            playpauseAudio()
            result = true
            ' else if key = "onKeyEventplay"
            '        return true
        else if key = "up"
            m.timerForVideoUi.control = "stop"
            m.videoUi.visible = true
            m.timerForVideoUi.control = "start"
            result = true
        else if key = "down"
            m.timerForVideoUi.control = "stop"
            m.videoUi.visible = true
            m.timerForVideoUi.control = "start"
            result = true
        end if
    end if
    return result
end function

' '  /*
' '  Developed By: Oodles Technologies
' '  Dated On: 25-August-2022
' '  Description:this function is responsible to play/plause the audio.
' '  */

function playpauseAudio()
    ' print "AudioScreen.brs = > playpauseAudio", m.videoPlayer.state
    if m.videoPlayer.state = "finished"
        m.videoPlayer.seek = 0
    else
        if m.videoPlayer.control = "play"
            m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().pauseButton
            m.videoPlayer.control = "pause"
        else if m.videoPlayer.control = "resume"
            m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().pauseButton
            m.videoPlayer.control = "pause"
        else
            m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().playButton
            m.videoPlayer.control = "resume"
        end if
    end if

end function
