sub init()
    di = CreateObject("roDeviceInfo")
    tvWidth = di.getDisplaySize().w
    tvHeight = di.getDisplaySize().h
    m.top.panelSize = "full"
    m.top.isFullScreen = true
    m.top.hasNextPanel = false
    m.top.suppressLeftArrow = true
    m.top.width = tvWidth
    m.top.leftPosition = "0"
    m.timerForVideoUi = m.top.findNode("timerForVideoUi")
    m.timerForVideoUi.observeField("fire", "onTimerForVideoUi")

    di = CreateObject("roDeviceInfo")
    tvWidth = di.getDisplaySize().w
    tvHeight = di.getDisplaySize().h
    ' Center Spinner

    m.videoPlayer = m.top.findNode("videoPlayer")
    m.videoPlayer. observeField("state", "onPlayerState")
    m.videoPlayer.translation = "[0,-115]"
    m.videoPlayer.height = tvHeight
    m.videoPlayer.width = tvWidth

    m.loadingIndicator = m.top.findNode("loadingSpinner")

    centerx = (tvWidth - m.loadingIndicator.poster.bitmapWidth) / 2.1
    centery = (tvHeight - m.loadingIndicator.poster.bitmapHeight) / 3
    m.loadingIndicator.translation = [centerx, centery]
    m.loadingIndicator.poster.uri = "pkg:/images/localImages/spinner1.png"

    audiocontent = createObject("RoSGNode", "ContentNode")
    audiocontent.url = m.global.channelUrl
    audiocontent.streamformat = m.global.channelUrlFormat
    m.videoPlayer.content = audiocontent
    m.videoPlayer.seekMode = "accurate"
    m.videoPlayer.control = "play"

end sub


sub onTimerForVideoUi()
    m.top.hideHeader = "hide"
end sub

sub onPlayerState ()
    state = m.videoPlayer.state
    if state = "buffering"
        m.loadingIndicator.visible = true
    end if
    if state = "playing"
        m.timerForVideoUi.control = "start"
        m.loadingIndicator.visible = false
    end if
end sub

sub changeUi()
    m.timerForVideoUi.control = "start"
end sub

sub changeUiNormal()
    if m.top.changeUi = "Vod"
        m.videoPlayer.control = "stop"
    end if
    ' di = CreateObject("roDeviceInfo")
    ' tvWidth = di.getDisplaySize().w
    ' tvHeight = di.getDisplaySize().h
    ' m.videoPlayer.translation = "[0,-50]"
    ' m.videoPlayer.height = tvHeight - 65
    ' m.videoPlayer.width = tvWidth
end sub

sub onPlayVideo()
    ' m.videoPlayer.control = "play"
    audiocontent = createObject("RoSGNode", "ContentNode")
    audiocontent.url = m.global.channelUrl
    audiocontent.streamformat = m.global.channelUrlFormat
    m.videoPlayer.content = audiocontent
    m.videoPlayer.seekMode = "accurate"
    m.videoPlayer.control = "play"
end sub


sub changeUiTimer()
    m.timerForVideoUi.control = "start"
end sub



