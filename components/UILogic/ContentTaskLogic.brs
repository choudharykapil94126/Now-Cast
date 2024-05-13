' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub RunContentTask()
    ' print "ContentPlayerLogic : - RunContentTask"
    m.contentChannelTask = CreateObject("roSGNode", "ChannelTypeTask") ' create task for feed retrieving
    m.contentChannelTask.ObserveField("data", "OnChannelContentLoaded")
    m.contentChannelTask.ObserveField("vodData", "OnVODContentLoaded")
    m.contentChannelTask.ObserveField("m3u8Data", "Onm3u8DataLoaded")
    m.contentChannelTask.ObserveField("bothChannelAndVideo", "OnBothChannelAndVideo")
    m.contentChannelTask.control = "run" ' GetContent(see MainLoaderTask.brs) method is executed
    m.backgroundImageLaunchScreen.visible = false
    m.loadingIndicator.visible = true ' show loading indicator while content is loadin
end sub

sub OnChannelContentLoaded(response as object) ' invoked when content is ready to be used
    ShowChannelVideoScreen({ url: response.getData().jsonResponse.data.channelInfoDTO.streamUrl, streamFormat: "HLS" })
end sub

sub Onm3u8DataLoaded(response as object) ' invoked when content is ready to be used
    ShowChannelVideoScreen({ url: response.getData().jsonResponse.data.channelInfoDTO.m3u8Url, streamFormat: "HLS" })
end sub

sub OnBothChannelAndVideo(response as object)
    print response.getData(), "BOtH TRUE"

    m.global.channelUrl = response.getData().jsonResponse.data.channelInfoDTO.m3u8Url
    m.global.channelUrlFormat = "HLS"
    m.contentTaskData = CreateObject("roSGNode", "MainLoaderTask") ' create task for feed retrieving
    ' observe content so we can know when feed content will be parsed
    m.contentTaskData.ObserveField("content", "OnVodDataLoaded")
    m.contentTaskData.ObserveField("errorLoadingContent", "OnErrorContentLoaded")
    m.contentTaskData.control = "run" ' GetContent(see MainLoaderTask.brs) method is executed
end sub

sub OnVodDataLoaded()
    m.global.gridTypeContent = m.contentTaskData.content ' populate GridScreen with content
    ShowHomeScreen()
    m.loadingIndicator.visible = false ' hide loading indicator because content was retrieved
end sub

sub OnVODContentLoaded ()
    ShowGridScreen()
    m.contentTask = CreateObject("roSGNode", "MainLoaderTask") ' create task for feed retrieving
    ' observe content so we can know when feed content will be parsed
    m.contentTask.ObserveField("content", "OnMainContentLoaded")
    m.contentTask.ObserveField("errorLoadingContent", "OnErrorContentLoaded")
    m.contentTask.ObserveField("organizationContent", "OnOrganizationContent")
    m.contentTask.control = "run" ' GetContent(see MainLoaderTask.brs) method is executed
end sub

sub OnMainContentLoaded() ' invoked when content is ready to be used
    ' print "ContentPlayerLogic : - OnMainContentLoaded"
    m.GridScreen.SetFocus(true) ' set focus to GridScreen
    m.loadingIndicator.visible = false ' hide loading indicator because content was retrieved
    m.GridScreen.content = m.contentTask.content ' populate GridScreen with content
end sub

sub OnErrorContentLoaded()
    m.loadingIndicator.visible = false ' hide loading indicator because content was retrieved
    m.videoUnavailablePopup.visible = true
end sub


