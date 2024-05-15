' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub ShowGridScreen()
    ' print "GridScreenLogic: - ShowGridScreen"
    m.GridScreen = CreateObject("roSGNode", "GridScreen")
    m.GridScreen.ObserveField("rowItemSelected", "OnGridScreenItemSelected")
    m.GridScreen.ObserveField("signInButtonSelected", "signInButtonClicked")
    ShowScreen(m.GridScreen) ' show GridScreen
end sub


sub OnGridScreenItemSelected(event as object)
    ' print "GridScreenLogic: - OnGridScreenItemSelected"
    print event.getData()
    m.GridScreen.bannerVideoControl = "stop"
    grid = event.GetRoSGNode()
    ' extract the row and column indexes of the item the user selected
    m.selectedIndex = event.GetData()
    ' the entire row from the RowList will be used by the Video node
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    print rowContent , "rowContent"
    ShowDetailsScreen(rowContent, m.selectedIndex[1])
end sub

function signInButtonClicked()
    ' print "GridScreenLogic: - signInButtonClicked"
    ShowLoginScreen()
end function
