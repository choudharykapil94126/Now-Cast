' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainScene.xml using relative path.

sub ShowSplashScreen()
    ' print "SplashScreenLogic: - ShowSplashScreen"

    m.SplashScreen = CreateObject("roSGNode", "SplashScreen")
    ' m.SplashScreen.SetField("transitionEffect", "none")
    m.SplashScreen.observeField("stopSplashScreen", "onStopSpalshScreen")
    m.backgroundImageLaunchScreen.visible = false
    ShowScreen(m.SplashScreen) ' show GridScreen
end sub


sub onStopSpalshScreen ()
    ' print "Splsh Screen Logic -> onStopSpalshScreen"
    CloseSplashScreen()
    m.splashScreenDisplayTime.control = "stop"
    ' ShowGridScreen()
    RunContentTask()
end sub


sub CloseSplashScreen()
    ' print "SplashScreenLogic: - CloseSplashScreen"
    CloseScreen(m.SplashScreen) ' show GridScreen
    ' m.SplashScreen.splashVideo = "stop"
    m.SplashScreen.splashContent = invalid
    ' m.SplashScreen.splashTimerExample = "Stop"

end sub

