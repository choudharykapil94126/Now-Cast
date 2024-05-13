' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub ShowChannelVideoScreen(contents as object)
    ' print "VideoPlayerLogic: - ShowVideoScreen"
    m.videoPlayerChannel = CreateObject("roSGNode", "ChannelVideoScreen") ' create new instance of video node for each playback
    m.videoPlayerChannel.content = contents
    m.videoPlayerChannel.itemFocused = true
    m.videoPlayerChannel.ObserveField("itemFocused", "OnChannelVideoPlayerVisibleChange")
    m.videoPlayerChannel.ObserveField("itemPlayed", "OnItemStartPlaying")
end sub

sub OnItemStartPlaying()
    ' print "PLAY HONA CHALU HO GAYA"
    m.loadingIndicator.visible = false ' hide loading indicator because content was retrieved
    ShowScreen(m.videoPlayerChannel) ' show video screen
end sub


sub OnChannelVideoPlayerVisibleChange() ' invoked when video state is changed
    ' print "AudioPlayerLogic : - OnAudioPlayerVisibleChange"
    if m.videoPlayerChannel.itemFocused = false
        m.videoPlayerChannel.control = "stop"
        CloseScreen(m.videoPlayerChannel)
    end if

end sub
