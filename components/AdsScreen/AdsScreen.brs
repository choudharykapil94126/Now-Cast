
sub init ()
    m.label = m.top.findNode("label")
    m.adVideoPlayer = m.top.findNode("adVideoPlayer")
    m.adVideoPlayer.observeField("state", "onPlayerState")
    m.skipButton = m.top.findNode("skipButton")
    m.skipButton.ObserveField("buttonSelected","goToBUttonSelected")
    m.timerskipButton = m.top.findNode("timerskipButton")
    m.textTimer = m.top.findNode("textTimer")
    m.textTimer.duration = 1
    m.textTimer.observeField("fire", "onTimerViewSkipButton")
    m.AdsArray = []
    m.count = 1
end sub

function changesDone(event as object)
    for each i in m.top.urlArray
        m.AdsArray.push(i)
    end for
    m.SizeOfArray = m.AdsArray.ifArray.Count()
    getAdsScreen()
end function


function getAdsScreen()
    ' for top display ads label only
    m.dataoflabel = m.count.ToStr()+" of "+m.SizeOfArray.ToStr()
    m.label.text = m.dataoflabel
    m.count++
    ' end top display ads label part
    audio = CreateObject("RoSGNode","ContentNode")
    audio.streamformat = "mp4"
    audio.url = m.AdsArray.Peek()
    if m.AdsArray.Peek() <> invalid
        m.AdsArray.Pop()
    end if
    m.adVideoPlayer.content = audio
    m.adVideoPlayer.control = "play"
end function

function onPlayerState()
    ' print m.adVideoPlayer.state , "state of firstAdScreen"
    if m.adVideoPlayer.state = "playing"
        getTimerBeforeAdScreen()
    end if
    if m.adVideoPlayer.state = "buffering"
        m.skipButton.visible = false
    end if
    if m.adVideoPlayer.state = "finished"
        if m.AdsArray.Peek() <> invalid
            m.adVideoPlayer.control = "stop"
            getAdsScreen()
        else
            m.adVideoPlayer.control = "stop"
            m.top.checkBackButtonPress = true
        end if
    end if
end function

function goToButtonSelected()   
    if m.AdsArray.Peek() <> invalid
        m.adVideoPlayer.control = "stop"
        getAdsScreen()
    else                       
        m.adVideoPlayer.control = "stop"
        m.top.checkBackButtonPress = true
    end if
end function


function getTimerBeforeAdScreen()
    m.skipButton.visible = false
    m.skipButton.setFocus(false)
    m.timercount = 5
    m.textTimer.control = "start"
end function

function onTimerViewSkipButton()
    print m.timercount
    m.timerskipButton.text = "skip "+m.timercount.ToStr()+"s"
    m.timerskipButton.visible = true
    m.timerskipButton.setFocus(true)
    if m.timercount = 0
        m.textTimer.control = "stop"
        m.timerskipButton.visible = false
        m.timerskipButton.setFocus(false)
        m.skipButton.visible = true
        m.skipButton.setFocus(true)
    end if
    m.timercount--
end function

function onKeyEvent(key as string, press as boolean) as boolean
    ' print "AudioScreen.brs = > onKeyEvent", key, press

    result = false
    if press then

        if(key = "back")
            m.adVideoPlayer.control = "stop"
            m.top.backButtonOnAd = true
            result = true
        end if
    end if
    return result
end function


