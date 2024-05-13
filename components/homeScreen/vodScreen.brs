sub init()
    print "VOD SCREEN VISIBLE"

    di = CreateObject("roDeviceInfo")
    tvWidth = di.getDisplaySize().w
    tvHeight = di.getDisplaySize().h

    m.top.panelSize = "full"
    m.top.isFullScreen = true
    m.top.hasNextPanel = false
    m.top.suppressLeftArrow = true
    m.top.width = tvWidth
    m.top.leftPosition = "0"
    m.di = CreateObject("roDeviceInfo")
    m.rowList = m.top.FindNode("rowList")
    ' label with item description
    m.descriptionLabel = m.top.FindNode("descriptionLabel")
    ' m.top.ObserveField("visible", "onVisibleChange")
    ' label with item title
    m.titleLabel = m.top.FindNode("titleLabel")
    m.subTitleLable = m.top.FindNode("subTitleLable")
    m.descriptionLabel = m.top.FindNode("descriptionLabel")
    m.signInButton = m.top.FindNode("signInButton")
    m.signOutButton = m.top.FindNode("signOutButton")
    m.signOutButton.ObserveField("buttonSelected", "OnSignout")
    m.signInPoster = m.top.FindNode("signInPoster")
    m.signOutConfirmationBox = m.top.FindNode("signOutConfirmationBox")
    m.signoutAlertTitle = m.top.FindNode("signoutAlertTitle")
    m.signoutAlertMsg = m.top.FindNode("signoutAlertMsg")
    m.signOutCancelBtn = m.top.FindNode("signOutCancelBtn")
    m.signOutConfirmBtn = m.top.FindNode("signOutConfirmBtn")
    m.darkBackground = m.top.FindNode("darkBackground")
    m.gridScreenPosters = m.top.findNode("gridScreenPosters")

    m.top.ObserveField("panelListFocus", "onFocusScreen")

    m.nowCastLogo = m.top.FindNode("nowCastLogo")
    m.bannerVideo = m.top.findNode("bannerVideo")
    m.bannerImage = m.top.FindNode("bannerImage")
    m.top.findNode("leftGradient").uri = UI_CONSTANTS().leftGradient
    m.top.findNode("unusedGradient").uri = UI_CONSTANTS().detailScreenGradientImage
    m.top.findNode("bottomGradient").uri = UI_CONSTANTS().bottomGradient
    m.bannerImage.width = int(calculateBannerHeightWidth(m.di.GetDisplaySize().w))
    m.bannerImage.height = int(calculateBannerHeightWidth(m.di.GetDisplaySize().h))

    m.bannerVideo.width = int(calculateBannerHeightWidth(m.di.GetDisplaySize().w))
    m.bannerVideo.height = int(calculateBannerHeightWidth(m.di.GetDisplaySize().h))

    m.bannerVideo. observeField("state", "onPlayerState")

    ' print int(calculateThumbnailHeightWidth(m.di.GetDisplaySize().w)) ,int(calculateThumbnailHeightWidth(m.di.GetDisplaySize().h))

    m.rowList.translation = [90, int(distanceOfRowlistFromTop(m.di.GetDisplaySize().h))]
    m.rowList.rowItemSize = [[int(calculateThumbnailHeightWidth(m.di.GetDisplaySize().w)), int(calculateThumbnailHeightWidth(m.di.GetDisplaySize().h))]]
    m.rowList.itemSize = [int(rowListItemWidth(m.di.GetDisplaySize().w)), int(rowListItemHeight(m.di.GetDisplaySize().h))]

    ' observe rowItemFocused so we can know when another item of rowList will be focused
    m.rowList.ObserveField("rowItemFocused", "OnItemFocused")


    ' Banner Video
    m.timerForPlayingBannerVideo = m.top.findNode("timerForPlayingBannerVideo")
    m.timerForPlayingBannerVideo.ObserveField("fire", "onTimerEnd")
    m.videoContent = createObject("RoSGNode", "ContentNode") 'video Node

    ' *************font_Styling**************
    m.titleLabel.font = getFont(28, fontSet().bold)
    m.subTitleLable.font = getFont(22, fontSet().regular)
    m.descriptionLabel.font = getFont(22, fontSet().regular)
    m.rowList.rowLabelFont = getFont(21, fontSet().bold)

    m.signoutAlertTitle.font = getFont(25, fontSet().bold)
    m.signoutAlertMsg.font = getFont(20, fontSet().regular)
    m.signOutCancelBtn.font = getFont(19, fontSet().regular)
    m.signOutConfirmBtn.font = getFont(19, fontSet().regular)
    ' ************************SignOut Dialoge Box****************************

    m.signInButton.focusBitmapUri = UI_CONSTANTS().signInBtn
    m.signInButton.focusFootprintBitmapUri = UI_CONSTANTS().signInBtn
    m.signInPoster.uri = UI_CONSTANTS().signInFocused

    m.signOutButton.focusFootprintBitmapUri = UI_CONSTANTS().signOutBtn
    m.signOutButton.focusBitmapUri = UI_CONSTANTS().signOutBtn
end sub

sub onFocusScreen()
    if m.top.panelListFocus = false
        m.rowList.SetFocus(true)
    end if
end sub

sub focusRowlist()
    ' m.rowList.SetFocus(true)
    if m.top.visible = true
        if m.global.loginToSignInBtn <> "fromLoginPage"
            m.rowList.SetFocus(true) ' set focus to rowList if GridScreen visible
            if m.global.loginToken <> ""
                m.signInButton.visible = false
                m.signOutButton.visible = true
            else
                m.signInButton.visible = true
                m.signOutButton.visible = false

            end if
        else
            if m.global.loginToken <> ""
                m.signInButton.visible = false
                m.signOutButton.visible = true
                m.signInButton.SetFocus(false)
                m.signOutButton.SetFocus(true)
            else
                m.signInButton.visible = true
                m.signOutButton.visible = false
                m.signInButton.SetFocus(true)
                m.signOutButton.SetFocus(false)
            end if
        end if
    else
        m.timerForPlayingBannerVideo.control = "stop"
        m.bannerVideo.control = "stop"
        m.bannerVideo.content = invalid
    end if
end sub

sub onPlayerState ()
    state = m.bannerVideo.state
    if state = "buffering"
        m.bannerVideo.visible = false
        m.bannerImage.visible = true
    end if
    if state = "playing"
        m.bannerVideo.visible = true
        m.bannerImage.visible = false
    end if
end sub

sub OnSignout()

    m.signOutConfirmationBox.visible = true
    m.signOutCancelBtn.visible = true
    m.signOutConfirmBtn.visible = true
    m.signOutConfirmBtn.SetFocus(false)
    m.signOutCancelBtn.SetFocus(true)
    m.signOutCancelBtn.color = "#03AF8F"
    m.signOutConfirmBtn.color = "#000000"
    m.signOutButton.SetFocus(false)
    m.signInPoster.visible = false
    m.darkBackground.visible = true
end sub

sub signOutCancelBtnSelected()

    m.signOutConfirmationBox.visible = false
    m.signOutCancelBtn.visible = false
    m.signOutConfirmBtn.visible = false
    m.signOutCancelBtn.SetFocus(false)
    m.signOutButton.SetFocus(true)
    m.signInPoster.visible = true
    m.darkBackground.visible = false
end sub

sub signOutConfirmBtnSelected()

    m.signOutConfirmationBox.visible = false
    m.signOutCancelBtn.visible = false
    m.signOutConfirmBtn.visible = false
    m.darkBackground.visible = false

    ' signOutLogic
    sec = CreateObject("roRegistrySection", "Authentication")
    sec.Delete("loginToken")
    sec.Delete("organizationId")
    sec.Delete("loggedUserId")
    m.global.loginToken = ""
    m.global.removeField("userSubscriptionId")
    m.signInButton.visible = true
    m.signOutButton.visible = false
    m.signInButton.SetFocus(true)
    m.signOutButton.SetFocus(false)
    m.signInPoster.visible = true
end sub

sub onTimerEnd()
    m.bannerVideo.control = "play"
end sub

' sub OnVisibleChange() ' invoked when GridScreen change visibility
'     print "jhjjvjvjvjvjvhvhj"
'     if m.top.visible = true
'         if m.global.loginToSignInBtn <> "fromLoginPage"
'             m.rowList.SetFocus(true) ' set focus to rowList if GridScreen visible
'             if m.global.loginToken <> ""
'                 m.signInButton.visible = false
'                 m.signOutButton.visible = true
'             else
'                 m.signInButton.visible = true
'                 m.signOutButton.visible = false
'             end if
'         else
'             if m.global.loginToken <> ""
'                 m.signInButton.visible = false
'                 m.signOutButton.visible = true
'                 m.signInButton.SetFocus(false)
'                 m.signOutButton.SetFocus(true)
'             else
'                 m.signInButton.visible = true
'                 m.signOutButton.visible = false
'                 m.signInButton.SetFocus(true)
'                 m.signOutButton.SetFocus(false)
'             end if
'         end if
'     else
'         m.timerForPlayingBannerVideo.control = "stop"
'         m.bannerVideo.control = "stop"
'         m.bannerVideo.content = invalid
'     end if
' end sub

sub OnItemFocused() ' invoked when another item is focused
    m.nowCastLogo.uri = utility().orgLogoForMainScreen
    focusedIndex = m.rowList.rowItemFocused ' get position of focused item
    row = m.rowList.content.GetChild(focusedIndex[0]) ' get all items of row
    item = row.GetChild(focusedIndex[1]) ' get focused item
    m.timerForPlayingBannerVideo.control = "stop"

    if m.bannerVideo.visible
        m.bannerVideo.visible = false
        m.bannerImage.visible = true
    end if
    m.bannerImage.uri = item.bannerImage
    m.descriptionLabel.text = item.description
    m.titleLabel.text = item.title
    m.subTitleLable.text = item.newsubtitle

    if m.signInButton.visible <> true and m.signOutButton.visible <> true
        m.gridScreenPosters.visible = true
        sec = CreateObject("roRegistrySection", "Authentication")
        if sec.Read("loginToken") <> ""
            m.global.loginToken = sec.Read("loginToken")
            m.signInButton.visible = false
            m.signOutButton.visible = true
        else
            m.signInButton.visible = true
            m.signOutButton.visible = false
        end if
    end if

    if item.fulldataforselecteditem.isVideo <> invalid and item.fulldataforselecteditem.isVideo
        m.bannerVideo.control = "stop"
        m.videoContent.url = item.fulldataforselecteditem.bannerVideoUrl 'bannerVideoURL fetched from getRowlistIndex1,
        m.videoContent.streamformat = "HLS"
        m.bannerVideo.content = m.videoContent
        m.timerForPlayingBannerVideo.control = "start"
    end if
end sub

function OnkeyEvent(key as string, press as boolean) as boolean
    print "VODScreen.brs = > OnkeyEvent"

    result = false
    if press
        if key = "up"
            if m.rowList.hasFocus()
                m.signInPoster.visible = true
                if m.global.loginToken <> ""
                    m.signInButton.SetFocus(false)
                    m.signOutButton.SetFocus(true)
                else
                    m.signOutButton.SetFocus(false)
                    m.signInButton.SetFocus(true)
                end if
            end if
            result = true
        end if

        if key = "down"
            if (m.signInButton.hasFocus() or m.signOutButton.hasFocus())
                m.rowList.SetFocus(true)
                m.signInPoster.visible = false
            end if
            result = true
        end if

        if key = "right"
            if m.signOutCancelBtn.hasFocus()
                m.signOutConfirmBtn.SetFocus(true)
                m.signOutConfirmBtn.color = "#03AF8F"
                m.signOutCancelBtn.color = "#000000"


            end if
            result = true
        end if

        if key = "left"
            if m.signOutConfirmBtn.hasFocus()
                m.signOutCancelBtn.SetFocus(true)
                m.signOutCancelBtn.color = "#03AF8F"
                m.signOutConfirmBtn.color = "#000000"
            end if
            if m.signInButton.hasFocus() or m.signOutButton.hasFocus()
                m.top.panelListFocus = true
                m.signInPoster.visible = false
            end if
            result = true
        end if


        if key = "OK" and m.signOutCancelBtn.hasFocus()
            signOutCancelBtnSelected()
            result = true
        end if

        if key = "OK" and m.signOutConfirmBtn.hasFocus()
            signOutConfirmBtnSelected()
            result = true
        end if


        if (key = "back" and m.signOutConfirmationBox.visible)
            m.signOutConfirmationBox.visible = false
            m.signOutCancelBtn.visible = false
            m.signOutConfirmBtn.visible = false
            m.signOutCancelBtn.SetFocus(false)
            m.signOutButton.SetFocus(true)
            m.signInPoster.visible = true
            m.darkBackground.visible = false

            result = true
        end if


    else
        if key = "right"
            if m.top.panelListFocus = true
                m.top.panelListFocus = false
                m.signInPoster.visible = true
                if m.global.loginToken <> ""
                    m.signInButton.SetFocus(false)
                    m.signOutButton.SetFocus(true)
                else
                    m.signOutButton.SetFocus(false)
                    m.signInButton.SetFocus(true)
                end if
            end if
            result = true
        end if
    end if

    return result
end function
