' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********
'--> in this file three function is used
'--> first function will show the details screen which find the detail screen node. ans set to observer.
'> it takes the contect node and index of the column , containing the selected content.


' Note that we need to import this file in MainScene.xml using relative path.
'--> this show item focus in details screen
sub ShowLoginScreen()
    ' print "LoginScreenLogic: - ShowLoginScreen"

    ' create new instance of details screen
    m.loginScreen = CreateObject("roSGNode", "LoginScreen")
    m.loginScreen.ObserveField("backToPreviousPage", "OnLoginScreenVisibilityChanged")
    m.loginScreen.backToPreviousPage = false
    ShowScreen(m.loginScreen) '> calling show screen method show detail screen.
end sub

sub OnLoginScreenVisibilityChanged()
    ' print "LoginScreenLogic: - OnLoginScreenVisibilityChanged" m.loginScreen.backToPreviousPage
    if m.loginScreen.backToPreviousPage
        m.global.loginToSignInBtn = "fromLoginPage"
        CloseScreen(m.loginScreen)
    end if
end sub




