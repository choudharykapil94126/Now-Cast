sub init ()
    m.top.ObserveField("itemFocused", "OnItemFocusedChange")
    m.top.ObserveField("visible", "OnAudioVisibleChange")
    m.top.findNode("AudioBottomGradient").uri = UI_CONSTANTS().audioScreenBottomGradient
    m.top.findNode("selectedItemPoster").uri = UI_CONSTANTS().defaultSelectedImageForDetailScreen
    m.top.findNode("audioLoadingSpinner").uri = UI_CONSTANTS().spinnerLoader
    m.duration = 0
    ' ***********Accessing_XML_Values**********
 
    m.selectedItemPoster = m.top.findNode("selectedItemPoster")
    m.skipBackBtn = m.top.findNode("skipBackBtn")
    m.skipBackBtn.focusFootprintBitmapUri = UI_CONSTANTS().backwardBtn
    m.playPauseBtn = m.top.findNode("playPauseBtn")
    m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().playButton
    m.skipForwardBtn = m.top.findNode("skipForwardBtn")
    m.skipForwardBtn.focusFootprintBitmapUri = UI_CONSTANTS().forwardBtn
    m.audioLoadingSpinner = m.top.findNode("audioLoadingSpinner")
    m.progressBarImageCircle = m.top.findNode("progressBarImageCircle")
    m.timerForPlayingAudio = m.top.findNode("timerForPlayingAudio")
    m.audioLoadingSpinner.poster.width = "30"
    m.audioLoadingSpinner.poster.height = "30"
    m.timingLayout = m.top.findNode("timingLayout")

    ' ************AccessingXML_values_related_to_Timer**********

    m.progressBar = m.top.findNode("progressBar")
    m.progressBarBackground = m.top.findNode("progressBarBackground")
    m.itemCurPosition = m.top.findNode("itemCurPosition")
    m.songDuration = m.top.findNode("songDuration")
    m.playPauseBtn.observeField("buttonSelected", "playpauseAudio")
    m.timerForPlayingAudio.observeField("fire", "onTimerForPlayingAudio")
    m.progressBarImageCircle.uri = UI_CONSTANTS().whiteCircle
end sub

sub onTimerForPlayingAudio()
    m.audio.control = "play"
end sub

sub OnItemFocusedChange(event as object)' invoked when another item is focused
    if m.top.itemFocused
        details = event.GetRoSGNode()
        m.audio = createObject("roSGNode", "Audio")
        audiocontent = createObject("RoSGNode", "ContentNode")
        audiocontent.url = details.content.audiodata
        m.duration = details.content.duration
        m.selectedItemPoster.uri = details.content.detailPageBannerImage
        m.audio.content = audiocontent
        ' m.audio.control = "play"
        m.timerForPlayingAudio.control = "start"
        m.audio.observeField("state", "onPlayerState")
        m.audio.observeField("position", "onPlayerPosition")
    end if
end sub

sub onPlayerState ()
    state = m.audio.state
    if state = "playing"
        m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().playButton
    end if
    ' close video screen in case of error or end of playback
    if state = "error" or state = "finished" or state = "stopped"
        if state = "finished"
            m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().pauseButton
            if m.duration > 3600
                m.songDuration.text = "- 00:00:00"
                m.itemCurPosition.text = timeValue(Str(int(m.duration / 3600))).trim() + ":" + timeValue(Str(int(m.duration / 60) mod 60)).trim() + ":" + timeValue(Str(int(m.duration mod 60))).trim()
            else
                m.songDuration.text = "- 00:00"
                m.itemCurPosition.text = timeValue(Str(int(m.duration / 60) mod 60)).trim() + ":" + timeValue(Str(int(m.duration mod 60))).trim()
            end if
            passedProgreesBar = (820 / 100) * 100
            m.progressBar.width = passedProgreesBar
            m.progressBarImageCircle.translation = [(-3 + passedProgreesBar), -3]
        else
            m.top.itemFocused = false
        end if
    end if
end sub

function timeValue(s as string)
    if Len(s) = 2
        return "0" + s.trim()
    end if
    return s.trim()
end function

sub onPlayerPosition()
    if m.audio.position < 1
        m.audioLoadingSpinner.visible = false
        m.skipBackBtn.visible = true
        m.playPauseBtn.visible = true
        m.skipForwardBtn.visible = true
        m.progressBarBackground.visible = true
        m.progressBar.visible = true
        m.playPauseBtn.setFocus(true)
    end if
    if m.duration > 3600
        if m.duration > m.audio.position
            m.songDuration.text = "- " + timeValue(Str(int((m.duration - m.audio.position) / 3600))).trim() + ":" + timeValue(Str((int((m.duration - m.audio.position) / 60)) mod 60)).trim() + ":" + timeValue(Str(int((m.duration - m.audio.position) mod 60))).trim()
            m.itemCurPosition.text = timeValue(Str(int(m.audio.position / 3600))).trim() + ":" + timeValue(Str(int(m.audio.position / 60) mod 60)).trim() + ":" + timeValue(Str(int(m.audio.position mod 60))).trim()
        end if
    else
        if m.duration > m.audio.position
            m.songDuration.text = "- " + timeValue(Str((int((m.duration - m.audio.position) / 60)) mod 60)).trim() + ":" + timeValue(Str(int((m.duration - m.audio.position) mod 60))).trim()
            m.itemCurPosition.text = timeValue(Str(int(m.audio.position / 60) mod 60)).trim() + ":" + timeValue(Str(int(m.audio.position mod 60))).trim()
        end if
    end if
    passedAudioProgress = (m.audio.position / m.duration) * 100
    passedProgreesBar = (820 / 100) * passedAudioProgress
    m.progressBar.width = passedProgreesBar
    m.progressBarImageCircle.translation = [(-3 + passedProgreesBar), -3]
end sub

sub OnAudioVisibleChange() ' invoked when video node visibility is changed
    m.timerForPlayingAudio.control = "stop"
    m.audio.control = "stop"
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    result = false
    if press then
        if(key = "right" or key = "fastforward") and m.audio.control <> "pause"
            if m.audio.position = m.duration or (m.audio.position < m.duration and m.audio.position > m.duration - 1)
                return true
            end if
            if m.audio.position + 15 > m.duration
                m.audio.seek = m.duration
            else
                m.audio.seek = m.audio.position + 15
            end if
            if (m.audio.control = "resume" or m.audio.control = "play")
                m.audio.control = "resume"
            else
                m.audio.control = "pause"
            end if
            result = true
        else if(key = "left" or key = "rewind") and m.audio.control <> "pause"
            if m.audio.position = m.duration or (m.audio.position < m.duration and m.audio.position > m.duration - 1)
                m.audio.seek = m.audio.position - 10
                return true
            end if
            if m.audio.position - 15 < 0
                m.audio.seek = 0
            else
                m.audio.seek = m.audio.position - 15
            end if
            if (m.audio.control = "resume" or m.audio.control = "play")
                m.audio.control = "resume"
            else
                m.audio.control = "pause"
            end if
            result = true
        else if (key = "play") or (key = "OK" and m.playPauseBtn.hasFocus())
            playpauseAudio()
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
    if m.audio.state = "finished"
        m.audio.seek = 0
    else
        if m.audio.control = "play"
            m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().pauseButton
            m.audio.control = "pause"
        else if m.audio.control = "resume"
            m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().pauseButton
            m.audio.control = "pause"
        else
            m.playPauseBtn.focusBitmapUri = UI_CONSTANTS().playButton
            m.audio.control = "resume"
        end if
    end if
end function
