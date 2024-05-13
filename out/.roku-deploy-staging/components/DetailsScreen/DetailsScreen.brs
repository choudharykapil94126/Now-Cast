' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' entry point of detailsScreen
function Init()
    m.di = CreateObject("roDeviceInfo")

    ' observe "visible" so we can know when DetailsScreen change visibility
    m.top.ObserveField("visible", "OnVisibleChange")
    ' observe "itemFocused" so we can know when another item gets in focus
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")
    m.top.findNode("popUpRect").uri = UI_CONSTANTS().transparentPopUpBackground
    m.top.findNode("watchBtnId").focusBitmapUri = UI_CONSTANTS().focusedWatchedButton
    m.top.findNode("watchBtnId").focusFootprintBitmapUri = UI_CONSTANTS().unFocusedWatchButton

    m.top.findNode("listenBtnId").focusBitmapUri = UI_CONSTANTS().focusedListenButton
    m.top.findNode("listenBtnId").focusFootprintBitmapUri = UI_CONSTANTS().unFocusedListenButton

    ' m.top.findNode("leftGradient").uri = UI_CONSTANTS().leftGradient
    ' m.top.findNode("bottomGradient").uri = UI_CONSTANTS().bottomGradient

    ' save a references to the DetailsScreen child components in the m variable
    ' so we can access them easily from other functions
    m.detailPageLogo = m.top.FindNode("detailPageLogo")
    m.backgroundimageForBroadcast = m.top.FindNode("backgroundimageForBroadcast")
    m.popUpMessageForBroadcast = m.top.FindNode("popUpMessageForBroadcast")

    m.detailData = m.top.FindNode("detailData")
    m.titleLabel = m.top.FindNode("titleLabel")
    m.detailSubTitle = m.top.FindNode("detailSubTitle")
    m.description = m.top.FindNode("descriptionLabel")
    m.watchBtnId = m.top.FindNode("watchBtnId")
    m.listenBtnId = m.top.FindNode("listenBtnId")
    m.poster = m.top.FindNode("poster")
    m.backgroundimageForBroadcast = m.top.findNode("backgroundimageForBroadcast")

    m.top.FindNode("detailLeftGradient").uri = UI_CONSTANTS().detailScreenGradientImage

    ' popUpRect and its translation
    m.accessRequiredPopupForFreeContent = m.top.FindNode("accessRequiredPopupForFreeContent")
    m.popUpRect = m.top.FindNode("popUpRect")
    m.popUpTitle = m.top.FindNode("popUpTitle")
    m.popUpMessage = m.top.FindNode("popUpMessage")
    m.popUpButton = m.top.FindNode("popUpButton")
    m.popUpButtonRect = m.top.FindNode("popUpButtonRect")
    m.popUpButtonText = m.top.FindNode("popUpButtonText")
    m.organisationSite = m.top.FindNode("organisationSite")
    m.accessRequiredPopupForFreeContent.ObserveField("visible", "onPopUpVisible")
    m.backgroundimageForBroadcast.ObserveField("visible", "onBroadcastingVideo")

    m.videoUnavailablePopup = m.top.FindNode("videoUnavailablePopup")
    m.videoUnavailablePopupRect = m.top.FindNode("videoUnavailablePopupRect")
    m.videoUnavailableText = m.top.FindNode("videoUnavailableText")
    m.videoUnavailableMessage = m.top.FindNode("videoUnavailableMessage")
    m.videoUnavailableButton = m.top.FindNode("videoUnavailableButton")


    '***************** fontStyling ***************

    m.titleLabel.font = getFont(31, fontSet().bold)
    m.detailSubTitle.font = getFont(28, fontSet().regular)
    m.description.font = getFont(28, fontSet().regular)

    ' color and fonts to PopUps
    m.popUpMessage.font = getFont(24, fontSet().bold)
    m.popUpTitle.font = getFont(24, fontSet().bold)
    m.popUpButtonText.font = getFont(18, fontSet().bold)
    m.organisationSite.font = getFont(37, fontSet().bold)
    m.videoUnavailableText.font = getFont(23, fontSet().bold)
    m.videoUnavailableMessage.font = getFont(21, fontSet().regular)
    m.videoUnavailableButton.font = getFont(21, fontSet().bold)
    m.popUpButtonRect.color = m.global.organizationColor
    m.organisationSite.color = "#fae902"
    m.videoUnavailablePopup.ObserveField("visible", "setPopUpVideoUnavailablePop")
    m.top.FindNode("signInFocusDetailScreen").uri = UI_CONSTANTS().signInFocused

end function

sub onBroadcastingVideo ()
    if m.backgroundimageForBroadcast.visible
        m.backgroundimageForBroadcast.uri = UI_CONSTANTS().transparentPopUpBackground
        di = CreateObject("roDeviceInfo")
        tvWidth = di.getDisplaySize().w
        tvHeight = di.getDisplaySize().h
        centerX = (tvWidth - m.backgroundimageForBroadcast.width) / 2
        centerY = (tvHeight - m.backgroundimageForBroadcast.height) / 2
        m.backgroundimageForBroadcast.translation = [centerX, centerY]
        popUpTitle = m.popUpMessageForBroadcast.boundingRect()
        centerXM = ((tvWidth - popUpTitle.width) / 2) - (popUpTitle.width / 4)
        m.popUpMessageForBroadcast.translation = [centerXM, 60]
        m.backgroundimageForBroadcast.visible = true
    end if
end sub

sub onPopUpVisible()
    if m.accessRequiredPopupForFreeContent.visible
        m.watchBtnId.SetFocus(false)
        m.popUpButton.SetFocus(true)
    else
        m.popUpButton.SetFocus(false)
        if m.global.audioToListenBtn = "fromAudioPage"
            m.listenBtnId.SetFocus(true)
            m.watchBtnId.SetFocus(false)
        else
            m.watchBtnId.SetFocus(true)
            m.listenBtnId.SetFocus(false)
        end if
    end if
end sub

sub setPopUpVideoUnavailablePop()
    m.videoUnavailableMessage.text = m.top.action + " not available for this item"
    if m.videoUnavailablePopup.visible
        m.watchBtnId.SetFocus(false)
        m.listenBtnId.SetFocus(false)
        m.videoUnavailableButton.SetFocus(true)
    else
        m.videoUnavailableButton.SetFocus(false)
        if m.global.audioToListenBtn = "fromAudioPage"
            m.listenBtnId.SetFocus(true)
            m.watchBtnId.SetFocus(false)
        else
            m.watchBtnId.SetFocus(true)
            m.listenBtnId.SetFocus(false)
        end if
    end if
end sub

' -->it set focus on play button when details screen(second screen opens)
sub OnVisibleChange() ' invoked when DetailsScreen visibility is changed
    ' set focus for buttons list when DetailsScreen become visible
    if m.top.visible = true
        if m.global.audioToListenBtn = "fromAudioPage"
            m.listenBtnId.SetFocus(true)
        else
            m.watchBtnId.SetFocus(true)
        end if
    end if
end sub

' Populate content details information
' --> when a item(poster) get focused there details change on the screen, (this is responsible for this)
sub SetDetailsContent(content as object)
    if content.detailPageLogoImage <> invalid
        m.detailPageLogo.uri = content.detailPageLogoImage
        m.detailPageLogo.visible = true
        m.titleLabel.visible = false
        m.detailData.translation = [97, ((50 * m.di.GetDisplaySize().h) / 100)]
    else
        m.titleLabel.width = 390
        m.titleLabel.wrap = true
        m.titleLabel.maxLines = 2
        m.detailData.translation = [97, ((45 * m.di.GetDisplaySize().h) / 100)]
    end if
    m.poster.uri = content.detailPageBannerImage
    m.titleLabel.text = content.title
    m.detailSubTitle.text = content.newsubtitle
    m.description.text = content.description ' set description of content
end sub


' --> when you watched the video and press the back button, this help to bring you to the grid screen agian
sub OnJumpToItem() ' invoked when jumpToItem field is populated
    m.content = m.top.content.GetChild(m.top.jumpToItem) ' get metadata of focused item
    SetDetailsContent(m.content) ' populate DetailsScreen with item metadata
end sub

sub setPopUp()
    if m.content.fulldataforselecteditem.mediaAccessType = "ACCESSREQUIRED"
        m.popUpButton.height = 34
        m.popUpTitle.text = "To " + m.top.actionType + " this free " + m.top.action
        m.popUpMessage.text = "or create an account by downloading " + m.global.organizationName + "'s mobile app or visit our website at"
        m.organisationSite.text = m.global.organizationUrl
    else if m.content.fulldataforselecteditem.mediaAccessType = "PAID" and m.global.loginToken = ""
        m.popUpButton.height = 34
        m.popUpTitle.text = "To " + m.top.actionType + " this " + m.top.action
        m.popUpMessage.text = "or subscribe by downloading " + m.global.organizationName + "'s mobile app or visit our website at"
        m.organisationSite.text = m.global.organizationUrl
    else if m.content.fulldataforselecteditem.mediaAccessType = "PAID" and m.global.loginToken <> "" and ArrayContainValue(m.content.fulldataforselecteditem.subscriptionPlanIds, m.global.getFields().userSubscriptionId) <> true
        m.popUpButton.visible = false
        m.popUpButton.height = 0
        m.popUpTitle.text = "To " + m.top.actionType + " this " + m.top.action
        m.popUpMessage.text = "subscribe by downloading " + m.global.organizationName + "'s mobile app or visit our website at"
        m.organisationSite.text = m.global.organizationUrl
    end if


    ' getTvDetails
    di = CreateObject("roDeviceInfo")
    tvWidth = di.getDisplaySize().w
    tvHeight = di.getDisplaySize().h

    centerX = (tvWidth - m.popUpRect.width) / 2
    centerY = (tvHeight - m.popUpRect.height) / 2
    m.popUpRect.translation = [centerX, centerY]


    popUpTitle = m.popUpTitle.boundingRect()
    centerXM = (tvWidth - popUpTitle.width) / 2.13
    if m.content.fulldataforselecteditem.mediaAccessType = "PAID" and m.global.loginToken <> "" and ArrayContainValue(m.content.fulldataforselecteditem.subscriptionPlanIds, m.global.getFields().userSubscriptionId) <> true
        m.popUpTitle.translation = [centerXM, 95]
    else
        m.popUpTitle.translation = [centerXM, 50]
    end if
    
    popUpButton = m.popUpButton.boundingRect()
    centerXB = (tvWidth - popUpButton.width) / 2.12
    m.popUpButton.translation = [centerXB, 80]

    popUpMessage = m.popUpMessage.boundingRect()
    centerXM = (tvWidth - popUpMessage.width) / 2.55
    m.popUpMessage.translation = [centerXM, 130]

    organisationSite = m.organisationSite.boundingRect()
    centerXO = (tvWidth - organisationSite.width) / 2.2
    m.organisationSite.translation = [centerXO, 160]

    centerXV = (tvWidth - m.videoUnavailablePopupRect.width) / 2
    centerYV = (tvHeight - m.videoUnavailablePopupRect.height) / 2
    m.videoUnavailablePopupRect.translation = [centerXV, centerYV]
end sub


'--> it show how focus changes when you press left right buttons
' The OnKeyEvent() function receives remote control key events
function OnkeyEvent(key as string, press as boolean) as boolean

    result = false
    if press
        if key = "left" and m.accessRequiredPopupForFreeContent.visible = false and m.videoUnavailablePopup.visible = false
            m.watchBtnId.SetFocus(true)
            result = true
        else if key = "right" and m.accessRequiredPopupForFreeContent.visible = false and m.videoUnavailablePopup.visible = false
            m.listenBtnId.SetFocus(true)
            result = true

        else if key = "back" and m.accessRequiredPopupForFreeContent.visible
            if m.global.audioToListenBtn = "fromAudioPage"
                m.accessRequiredPopupForFreeContent.visible = false
                m.popUpButton.SetFocus(false)
                m.listenBtnId.SetFocus(true)
            else
                m.accessRequiredPopupForFreeContent.visible = false
                m.popUpButton.SetFocus(false)
                m.watchBtnId.SetFocus(true)
            end if

            result = true
        else if key = "OK" and m.videoUnavailableButton.hasFocus()
            m.videoUnavailablePopup.visible = false
            result = true
        else if key = "back" and m.backgroundimageForBroadcast.visible
            m.backgroundimageForBroadcast.visible = false
            m.watchBtnId.SetFocus(true)
            result = true
        end if

    end if
    return result
end function










