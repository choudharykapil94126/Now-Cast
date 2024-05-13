' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub ShowAudioScreen(rowContent as object)
    ' print "AudioPlayerLogic : - ShowAudioScreen"
    if rowContent.audioData <> invalid
        m.audioPlayer = CreateObject("roSGNode", "audioScreen") ' create new instance of video node for each playback
        m.audioPlayer.content = rowContent
        m.audioPlayer.itemFocused = true
        m.audioPlayer.ObserveField("itemFocused", "OnAudioPlayerVisibleChange")
        ShowScreen(m.audioPlayer) ' show video screen
    end if
end sub

sub OnAudioPlayerVisibleChange() ' invoked when video state is changed
    ' print "AudioPlayerLogic : - OnAudioPlayerVisibleChange" m.audioPlayer.visible , m.audioPlayer.itemFocused

    if m.audioPlayer.itemFocused = false 
        m.global.audioToListenBtn = "fromAudioPage"
        CloseScreen(m.audioPlayer)
    end if
   
end sub




