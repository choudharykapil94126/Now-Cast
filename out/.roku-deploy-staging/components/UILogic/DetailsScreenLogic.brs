' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********
'--> in this file three function is used
'--> first function will show the details screen which find the detail screen node. ans set to observer.
'> it takes the contect node and index of the column , containing the selected content.
' Note that we need to import this file in MainScene.xml using relative path.
'--> this show item focus in details screen
sub ShowDetailsScreen(content as object, selectedItem as integer)
    ' print "DetailScreenLogic : - ShowDetailsScreen"

    ' create new instance of details screen
    '> details screen created {"roSGNode" ,"details screen"} in detailsScreen Variable
    m.detailsScreen = CreateObject("roSGNode", "DetailsScreen")
    '> setting details screen content in rowlist contactNode
    m.detailsScreen.content = content
    m.detailsScreen.jumpToItem = selectedItem ' set index of item which should be focused
    m.detailsScreen.ObserveField("visible", "OnDetailsScreenVisibilityChanged")
    m.detailsScreen.ObserveField("watchButtonSelected", "OnWatchButtonSelected")
    m.detailsScreen.ObserveField("listenButtonSelected", "onListenButtonSelected")
    m.detailsScreen.ObserveField("popUpBtnSelected", "onpopUpBtnSelected")
    ' // Capture Detail screen itemFocused Event and set data of poster in mainscene.xml  *********** End
    ShowScreen(m.detailsScreen) '> calling show screen method show detail screen.
end sub

sub onpopUpBtnSelected()
    ' print "DetailScreenLogic : -onpopUpBtnSelected"
    m.detailsScreen.accessRequiredPop = false
    ShowLoginScreen()
end sub

function getMediaItemDetails(item as object)
    ' print "DetailScreenLogic : -getMediaItemDetails"
    m.DetailScreenTask = CreateObject("roSGNode", "DetailScreenTask")
    m.DetailScreenTask.mediaItemId = item.id
    m.DetailScreenTask.control = "RUN"
    m.DetailScreenTask.observeField("response", "DetailScreenTaskResponse")
end function

function setUrlForVideo(mediaDTOValue as object)
    item = {}

    if mediaDTOValue.videoDTO <> invalid
        findUrl = findMaxResolutionPath(mediaDTOValue.videoDTO.flavourList)
        if findUrl = "" or findUrl = invalid
            item.length = mediaDTOValue.videoDTO.size
            item.url = mediaDTOValue.videoDTO.path
            item.streamFormat = "HLS"
        else
            item.length = mediaDTOValue.videoDTO.size
            item.url = findUrl
            item.streamFormat = "HLS"
        end if
    else
        if mediaDTOValue.videoUrl <> invalid
            item.length = 0
            item.url = mediaDTOValue.videoUrl
            item.streamFormat = mediaDTOValue.videoUrl.Right(3)
        else
            item.length = 0
            item.url = mediaDTOValue.videoUrl
            item.streamFormat = "HLS"
        end if
    end if

    return item
end function

' ************** VideoPlayer Screen Start ***************
sub OnWatchButtonSelected(event) ' invoked when button in DetailsScreen is pressed
    ' print "DetailScreenLogic : -OnWatchButtonSelected"
    m.global.audioToListenBtn = ""
    details = event.GetRoSGNode()
    m.content = details.content
    m.selectedItem = details.jumpToItem
    m.detailsScreen.actionType = "watch"
    m.detailsScreen.action = "video"
    m.detailsScreen.setpopup = true
    getMediaItemDetails(m.content.getChild(m.selectedItem).fulldataforselecteditem)
end sub

function getBroadcastingDetail(item as object)
    ' print "DetailScreenLogic : -getMediaItemDetailsForAudio"
    m.DetailScreenTask = CreateObject("roSGNode", "BroadcastingTask")
    m.DetailScreenTask.mediaItemId = item.id
    m.DetailScreenTask.control = "RUN"
    m.DetailScreenTask.observeField("response", "BroadcastingTaskResponse")
end function

sub BroadcastingTaskResponse (response as object)
    responses = response.getData()
    print responses.data , "Response"
    print m.detailPageBannerImage , "Response"
    print m.GetItemByIdResponse , "Response"

    if responses.data.status = "finished" and m.GetItemByIdResponse.videoUrl <> invalid
        ShowVideowithAds({ adsurl : "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4" , url: m.GetItemByIdResponse.videoUrl, detailPageBannerImage: m.detailPageBannerImage, streamFormat: m.GetItemByIdResponse.videoUrl.Right(3), itemId: m.itemSelectedIdForLiveItem, liveType: "pre-recorded" })
    else if responses.data.status = "broadcasting"
        ShowVideowithAds({ adsurl : "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4" , url: m.liveStreamDataDTO.m3u8Url, detailPageBannerImage: m.detailPageBannerImage, streamFormat: "HLS", itemId: m.itemSelectedIdForLiveItem, liveType: "broadcasting" })
    else
        m.detailsScreen.broadcastingVideo = true
    end if
end sub

sub DetailScreenTaskResponse(responsData as object)
    ' print "DetailScreenLogic : -DetailScreenTaskResponse"
    response = responsData.getData()
    m.GetItemByIdResponse = response.data
    m.detailPageBannerImage = m.content.getChild(m.selectedItem).detailPageBannerImage
    m.itemSelectedIdForLiveItem = response.data.id
    m.global.middleVideoPlayCheck = false
    m.global.checkVideoBeforeMiddleAds = false

    print response.data , "DetailScreenTaskResponse"

    if response.data.itemType = "LIVE_STREAMING"
        m.liveStreamDataDTO = response.data.liveStreamDataDTO
        getBroadcastingDetail(response.data)
    else

        if response.data.isVideoAvailable
            if response.data.mediaAccessType = "FREE"
                ' print "Free"
                ShowVideowithAds({ adsurl : "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4" ,url: setUrlForVideo(response.data).url, detailPageBannerImage: m.detailPageBannerImage, streamFormat: setUrlForVideo(response.data).streamFormat, itemId: response.data.id, liveType: "pre-recorded" })
            else if response.data.mediaAccessType = "ACCESSREQUIRED"
                ' print "ACCESSREQUIRED"
                if m.global.loginToken = ""
                    m.detailsScreen.accessRequiredPop = true
                else
                    ShowVideowithAds({ adsurl : "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4" ,url: setUrlForVideo(response.data).url, detailPageBannerImage: m.detailPageBannerImage, streamFormat: setUrlForVideo(response.data).streamFormat, itemId: response.data.id, liveType: "pre-recorded" })
                end if
            else if response.data.mediaAccessType = "PAID"
                ' print "PAID"
                if m.global.loginToken = ""
                    m.detailsScreen.accessRequiredPop = true
                else
                    if ArrayContainValue(response.data.subscriptionPlanIds, m.global.getFields().userSubscriptionId) or response.data.isOneTimePurchasePaymentDone
                        ShowVideowithAds({ adsurl : "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4" ,url: setUrlForVideo(response.data).url, detailPageBannerImage: m.detailPageBannerImage, streamFormat: setUrlForVideo(response.data).streamFormat, itemId: response.data.id, liveType: "pre-recorded" })
                    else
                        m.detailsScreen.accessRequiredPop = true
                    end if
                end if
            end if

        else ' print "Video not available for item"
            if response.data.liveStreamDataDTO = invalid
                m.detailsScreen.action = "Video"
                m.global.audioToListenBtn = ""
                m.detailsScreen.videoUnavailablePop = true
            end if
        end if

    end if
end sub

' ************** VideoPlayer Screen End ***************

sub onListenButtonSelected(event)
    ' print "onListenButtonSelected"
    m.global.audioToListenBtn = "fromAudioPage"
    details = event.GetRoSGNode()
    content = details.content
    selectedItem = details.jumpToItem
    m.selectedData = content.getChild(selectedItem)
    m.detailsScreen.actionType = "listen"
    m.detailsScreen.action = "audio"
    m.detailsScreen.setpopup = true
    getMediaItemDetailsForAudio(content.getChild(selectedItem).fulldataforselecteditem)
end sub

function getMediaItemDetailsForAudio(item as object)
    ' print "DetailScreenLogic : -getMediaItemDetailsForAudio"
    m.DetailScreenTask = CreateObject("roSGNode", "DetailScreenTask")
    m.DetailScreenTask.mediaItemId = item.id
    m.DetailScreenTask.control = "RUN"
    m.DetailScreenTask.observeField("response", "DetailScreenTaskResponseAudio")
end function

sub DetailScreenTaskResponseAudio(responsData as object)
    ' print "DetailScreenLogic : -DetailScreenTaskResponseAudio"
    data = responsData.getData()
    item = data.data
    if item.isAudioAvailable
        if item.mediaAccessType = "FREE"
            ' print "FREE"
            ShowAudioScreen({ audiodata: item.audioDTO.path, detailPageBannerImage: m.selectedData.detailPageBannerImage, duration: item.audioDTO.duration })
        else if item.mediaAccessType = "ACCESSREQUIRED"
            if m.global.loginToken = ""
                m.detailsScreen.accessRequiredPop = true
            else
                ShowAudioScreen({ audiodata: item.audioDTO.path, detailPageBannerImage: m.selectedData.detailPageBannerImage, duration: item.audioDTO.duration })
            end if
        else if item.mediaAccessType = "PAID"
            ' print "PAID" m.global.loginToken
            if m.global.loginToken = ""
                m.detailsScreen.accessRequiredPop = true
            else
                if ArrayContainValue(item.subscriptionPlanIds, m.global.getFields().userSubscriptionId) or item.isOneTimePurchasePaymentDone
                    ShowAudioScreen({ audiodata: item.audioDTO.path, detailPageBannerImage: m.selectedData.detailPageBannerImage, duration: item.audioDTO.duration })
                else
                    m.detailsScreen.accessRequiredPop = true
                end if
            end if
        end if

    else ' print "Video not available for item"
        m.detailsScreen.action = "Audio"
        m.global.audioToListenBtn = "fromAudioPage"
        m.detailsScreen.videoUnavailablePop = true
    end if
end sub

sub OnDetailsScreenVisibilityChanged() ' invoked when DetailsScreen "visible" field is changed
    ' print "DetailScreenLogic : -OnDetailsScreenVisibilityChanged"
    m.global.loginToSignInBtn = ""
end sub


