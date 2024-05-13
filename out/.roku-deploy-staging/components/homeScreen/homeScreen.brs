
sub init()
    di = CreateObject("roDeviceInfo")
    tvWidth = di.getDisplaySize().w / 2
    m.header = m.top.findNode("header")
    m.header.translation = [tvWidth, 30]
    m.channelLabel = m.top.findNode("channelLabel")
    m.channelLabel.font = getFont(16, fontSet().regular)
    m.vodLabel = m.top.findNode("vodLabel")
    m.vodLabel.font = getFont(16, fontSet().regular)
    m.channelLabel.font = getFont(25, fontSet().bold)
    m.vodLabel.font = getFont(16, fontSet().regular)
    m.timerForHeaderUi = m.top.findNode("timerForHeaderUi")
    m.timerForHeaderUi.observeField("fire", "onTimerForHeaderUi")
    m.top.ObserveField("visible", "onVisibleScreen")

    m.panelList = m.top.findNode("panelList")
    m.channelScreen = createObject("RoSGNode", "channelScreen")
    m.panelList.appendChild(m.channelScreen)
    m.channelScreen.ObserveField("hideHeader", "onTimerForHeaderUi")
    m.channelScreen.observeField("focusedChild", "slidepanels")
    m.channelScreen.ObserveField("itemFocused", "OnScreenVisible")

    m.activeTab = "Channel"
    m.vodScreen = createObject("roSGNode", "vodScreen")
    m.vodScreen.ObserveField("rowItemSelected", "OnGridScreenItemSelected")
    m.vodScreen.ObserveField("signInButtonSelected", "signInButtonClicked")
    m.vodScreen.content = m.global.gridTypeContent ' populate GridScreen with content
    m.vodScreen.ObserveField("panelListFocus", "onPanelListFocus")
    m.panelList.setFocus(true)
end sub


sub onPanelListFocus()
    if m.vodScreen.panelListFocus
        m.panelList.setFocus(true)
    end if
    ' m.channelScreen.setFocus(true)
end sub


sub onVisibleScreen()
    if m.top.visible
        m.vodScreen.rowListFocus = true
    end if
end sub

sub onTimerForHeaderUi()
    if m.activeTab = "Vod"
        m.header.visible = true
    else
        m.header.visible = false
    end if
end sub

sub slidepanels()
    if not m.panelList.isGoingBack
        m.activeTab = "Vod"
        m.panelList.appendChild(m.vodScreen)
        m.header.visible = true
        m.channelScreen.changeUi = "Vod"
        m.vodScreen.panelListFocus = false
        m.vodScreen.setFocus(true)
        m.vodLabel.font = getFont(20, fontSet().bold)
        m.channelLabel.font = getFont(16, fontSet().regular)
    else
        m.activeTab = "Channel"
        m.header.visible = true
        m.channelScreen.changeUiTimer = "normal"
        m.channelScreen.setFocus(true)
        m.channelLabel.font = getFont(20, fontSet().bold)
        m.vodLabel.font = getFont(16, fontSet().regular)
    end if
end sub

sub OnGridScreenItemSelected(event as object)
    m.vodScreen.bannerVideoControl = "stop"
    grid = event.GetRoSGNode()
    ' extract the row and column indexes of the item the user selected
    m.selectedIndex = event.GetData()
    ' the entire row from the RowList will be used by the Video node
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    m.top.vodScreenItemSelect = {
        rowContent: rowContent,
        selectedItem: m.selectedIndex[1]
    }
    ' ShowDetailsScreen(rowContent, m.selectedIndex[1])
end sub

function signInButtonClicked()
    print "signInButtonClicked"
    ' ShowLoginScreen()
    m.top.vodSigninButtonSelect = true
end function


function getFont(fontSize as integer, fontUri as string) as object
    Font = CreateObject("roSGNode", "Font")
    Font.uri = fontUri
    Font.size = fontSize
    return Font
end function

function fontSet()
    font = {
        bold: "pkg:/source/fonts/MYRIADPRO-BOLD.OTF",
        regular: "pkg:/source/fonts/MYRIADPRO-REGULAR.OTF"
    }
    return font
end function

function OnkeyEvent(key as string, press as boolean) as boolean
    print "HomeScreen" key, press, m.header.hasFocus(), m.channelScreen.hasFocus(), m.vodScreen.hasFocus()
    result = false
    if press

        if key = "left"
            if m.panelList.hasFocus()
                m.activeTab = "Channel"
                m.header.visible = true
                m.channelScreen.playVideo = "play"
                m.vodLabel.font = getFont(16, fontSet().regular)
                m.channelLabel.font = getFont(20, fontSet().bold)
                result = true
            end if
        end if

        ' if key = "right"
        '     if m.channelLabel.hasFocus()
        '         m.vodLabel.font = getFont(20, fontSet().bold)
        '         m.channelLabel.font = getFont(16, fontSet().regular)
        '         m.vodLabel.setFocus(true)
        '         m.channelLabel.setFocus(false)
        '         result = true
        '     end if
        ' end if

        if key = "up"
            if m.channelScreen.hasFocus() or m.panelList.hasFocus()
                m.header.visible = true
                m.channelScreen.changeVedioUi = "change"
                result = true
            end if
        end if

        ' if key = "down"
        '     if m.channelLabel.hasFocus() or m.vodLabel.hasFocus()
        '         m.panelList.setFocus(true)
        '         result = true
        '     end if
        ' end if

    end if
    return result
end function