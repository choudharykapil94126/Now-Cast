' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********
'--> in this file three function is used
'--> first function will show the details screen which find the detail screen node. ans set to observer.
'> it takes the contect node and index of the column , containing the selected content.
' Note that we need to import this file in MainScene.xml using relative path.
'--> this show item focus in details screen
sub ShowHomeScreen()
    ' print "DetailScreenLogic : - ShowDetailsScreen"

    ' create new instance of details screen
    m.homeScreen = CreateObject("roSGNode", "homeScreen")
    m.homeScreen.ObserveField("vodScreenItemSelect", "OnVODScreenItemSelected")
    m.homeScreen.ObserveField("vodSigninButtonSelect", "VodSignInButtonClicked")



    ShowScreen(m.homeScreen) '> calling show screen method show detail screen.
end sub



sub OnVODScreenItemSelected(event as object)
    print "OnVODScreenItemSelected: - OnVODScreenItemSelected", event.getData()
    ShowDetailsScreen(event.getData().rowContent, event.getData().selectedItem)
end sub



function VodSignInButtonClicked()
    print "signInButtonClicked"
    ShowLoginScreen()
end function


