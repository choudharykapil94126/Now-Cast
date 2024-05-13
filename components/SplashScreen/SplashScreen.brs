sub init()
    ' print "Spalsh screen loded"
    m.roAppInfo = CreateObject("roAppInfo")
    m.di = CreateObject("roDeviceInfo")

    m.dynamicCenterLogo = m.top.findNode("dynamicLogo")
    m.backgroundImage = m.top.findNode("backgroundImage")
    m.nowcastLogo = m.top.findNode("nowcastLogo")
    m.video = m.top.findNode("splashVideoPlayer")
    m.waitingTimerForBuffer = m.top.findNode("waitingTimerForBuffer")
    m.waitingTimerForBuffer.ObserveField("fire", "onBufferWatingTimerEnd")

    if m.di.GetUIResolution().name = "HD"
        m.backgroundImage.uri = m.roAppInfo.GetValue("splash_screen_hd")
    else
        m.backgroundImage.uri = m.roAppInfo.GetValue("splash_screen_fhd")
    end if

    m.dynamicCenterLogo.width = utility().orgLogoSize

    m.dynamicCenterLogo.uri = utility().orgLogoSplashScreen
    m.nowcastLogo.uri = utility().nowcastLogo

    di = CreateObject("roDeviceInfo")
    tvWidth = di.getDisplaySize().w / 2
    tvHeight = di.getDisplaySize().h / 2

    '  transaltion for organization Log
    centerX = tvWidth - (utility().orgLogoSize / 2)
    centerY = tvHeight - (m.dynamicCenterLogo.bitmapHeight / 2)
    m.dynamicCenterLogo.translation = [centerX, centerY + utility().orgLogoPosition]

    ' transalation for nowcastLogo
    nowcastX = tvWidth - (m.nowcastLogo.bitmapWidth / 2)
    nowcasty = di.getDisplaySize().h - m.nowcastLogo.bitmapHeight - utility().nowcastLogoSpaceFromBottom
    m.nowcastLogo.translation = [nowcastX, nowcastY]

    videoContentSplash = createObject("RoSGNode", "ContentNode")
    videoContentSplash.url = utility().setVideoUrl
    videoContentSplash.streamformat = utility().streamFormat
    m.video.enableUI = false
    m.video.content = videoContentSplash
    m.video.control = "prebuffer"

    m.top.findNode("leftGradientSplash").uri = UI_CONSTANTS().leftGradient
    m.top.findNode("bottomGradientSplash").uri = UI_CONSTANTS().bottomGradient

    if utility().isVideo
        m.video.mute = true
        m.video.visible = utility().isVideo
        m.video.observeField("state", "onPlayerState")
        m.video.observeField("position", "onPlayerPosition")
        setVideo()
    else
        m.waitingTimerForBuffer.duration = utility().bufferWaitingTimeForSplashScreenVideo
        m.waitingTimerForBuffer.control = "start"
        if m.global.isWhiteLabel = "false"
            m.nowcastLogo.visible = true
        end if
        m.dynamicCenterLogo.visible = utility().orgLogoVisible
        m.backgroundImage.uri = utility().backgroundBannerUrl
        m.video.visible = utility().isVideo
        m.backgroundImage.visible = utility().backgroundBannerVisible
        m.dynamicCenterLogo.visible = utility().orgLogoVisible
    end if

end sub

function onPlayerState()
    state = m.video.state
    ' print state, "splash screen player state"
    if state = "buffering"
        m.waitingTimerForBuffer.duration = utility().bufferWaitingTimeForSplashScreenVideo
        m.waitingTimerForBuffer.control = "start"
    end if
    if state = "playing"
        m.top.findNode("waitingTimerForBuffer").control = "stop"
    end if
    if state = "finished"
        m.dynamicCenterLogo.visible = false
        m.nowcastLogo.visible = false
        m.top.stopSplashScreen = true
        m.video.mute = false
    end if
end function

sub onPlayerPosition ()
    ' print m.video.position
    if m.video.position > 0.5
        m.backgroundImage.visible = false
        ' m.nowcastLogo.visible = true
        if m.global.isWhiteLabel = "false"
            m.nowcastLogo.visible = true
        end if
        m.dynamicCenterLogo.visible = utility().orgLogoVisible
    end if
end sub

sub onBufferWatingTimerEnd ()
    ' print "waiting time end"
    m.top.stopSplashScreen = true
    m.video.mute = false
    m.video.control = "stop"
    m.video.content = invalid
end sub

function setVideo() as void
    m.video.control = "play"
end function





