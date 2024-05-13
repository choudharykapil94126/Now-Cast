sub init ()
    ' print "AudioScreen.brs = > Init"
    m.top.ObserveField("itemFocused", "OnItemFocusedChange")
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.videoPlayer. observeField("state", "onPlayerState")
end sub

sub OnItemFocusedChange(event as object)' invoked when another item is focused
    ' print "AudioScreen.brs = > OnItemFocusedChange"
    if m.top.itemFocused
        details = event.GetRoSGNode()
        audiocontent = createObject("RoSGNode", "ContentNode")
        audiocontent.url = details.content.url
        audiocontent.streamformat = details.content.streamformat
        m.videoPlayer.content = audiocontent
        m.videoPlayer.seekMode = "accurate"
        m.videoPlayer.control = "play"
    end if
end sub

sub onPlayerState ()
    ' print "AudioScreen.brs = > onPlayerState"
    state = m.videoPlayer.state
    if state = "playing"
        m.top.itemPlayed = true
    end if
end sub
