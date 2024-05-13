' entry point of  MainScene
' Note that we need to import this file in MainScene.xml using relative path.
'--> it finds the details screen
sub Init()
    sec = CreateObject("roRegistrySection", "Authentication")
    m.di = CreateObject("roDeviceInfo")
    m.roAppInfo = CreateObject("roAppInfo")
    m.backgroundImageLaunchScreen = m.top.FindNode("backgroundImageLaunchScreen")
    if m.di.GetUIResolution().name = "HD"
        m.backgroundImageLaunchScreen.uri = m.roAppInfo.GetValue("splash_screen_hd")
    else
        m.backgroundImageLaunchScreen.uri = m.roAppInfo.GetValue("splash_screen_fhd")
    end if
    ' App launch and App Download Api Start
    ' print m.roAppInfo.GetValue("splash_screen_fhd")
    if sec.Read("AppDownload") = ""
        m.appDownloadTask = CreateObject("roSGNode", "AppDownloadTask")
        sec.write("AppDownload", "True")
        data = {}
        data["appInfoType"] = "APP_DOWNLOAD"
        data["appVersion"] = m.roAppInfo.GetVersion()
        data["deviceId"] = m.di.GetChannelClientId()
        data["deviceType"] = "ROKU"
        m.appDownloadTask.data = data
        m.appDownloadTask.control = "RUN"
    end if
    if sec.Read("AppDownload") = "True"
        m.appLaunchTask = CreateObject("roSGNode", "AppLaunchTask")
        data = {}
        data["appInfoType"] = "APP_LAUNCHES"
        data["appVersion"] = m.roAppInfo.GetVersion()
        data["deviceId"] = m.di.GetChannelClientId()
        data["deviceType"] = "ROKU"
        m.appLaunchTask.data = data
        m.appLaunchTask.control = "RUN"
        m.appLaunchTask.observeField("response", "launchResponse")
    end if
end sub

sub launchResponse(responsData as object)
    ' print "MaiScene.brs: - launchResponse"
    response = responsData.getData()
    InitScreenStack()
    m.splashScreenDisplayTime = m.top.FindNode("splashScreenDisplayTime")
    m.videoUnavailablePopup = m.top.FindNode("videoUnavailablePopup")
    m.videoUnavailablePopupRect = m.top.FindNode("videoUnavailablePopupRect")
    m.videoUnavailableText = m.top.FindNode("videoUnavailableText")
    m.videoUnavailableMessage = m.top.FindNode("videoUnavailableMessage")
    m.videoUnavailableButton = m.top.FindNode("videoUnavailableButton")
    m.videoUnavailablePopup.ObserveField("visible", "setPopUpVideoUnavailablePop")
    ' prod: 41
    ' dev: 8619
    m.top.backgroundUri = ApiUrl().imageServiceUrl + "upload/load/" + str(findId(8619, 41)).Trim() + "?height=" + str(m.di.GetUIResolution().height).Trim() + "&width=" + str(m.di.GetUIResolution().height).Trim()
    m.loadingIndicator = m.top.FindNode("loadingIndicator") ' store loadingIndicator node to m
    di = CreateObject("roDeviceInfo")
    tvWidth = di.getDisplaySize().w
    tvHeight = di.getDisplaySize().h
    ' Center Spinner
    centerx = (tvWidth - m.loadingIndicator.poster.bitmapWidth) / 2.2
    centery = (tvHeight - m.loadingIndicator.poster.bitmapHeight) / 2.2
    m.loadingIndicator.translation = [centerx, centery]
    centerXV = (tvWidth - m.videoUnavailablePopupRect.width) / 2
    centerYV = (tvHeight - m.videoUnavailablePopupRect.height) / 2
    m.videoUnavailablePopupRect.translation = [centerXV, centerYV]
    m.loadingIndicator.poster.uri = "pkg:/images/localImages/spinner1.png"

    if response.data.splashScreenContentUrl = invalid
        ' ShowGridScreen() ///WHEN WE WERE HANDLING VOD WE INITIATE TO SHOW GRID SCREEN
        RunContentTask()
    else
        ShowSplashScreen()
        m.splashScreenDisplayTime.duration = utility().maximumSplashScreenDuration
        m.splashScreenDisplayTime.control = "start"
        m.splashScreenDisplayTime.ObserveField("fire", "onSplashScreenTimerStop")
    end if

end sub

sub setPopUpVideoUnavailablePop()
    ' print "setPopUpVideoUnavailablePop"
end sub


sub onSplashScreenTimerStop()
    ' print "MainScene.brs = > onSplashScreenTimerStop"
    ' print "Default timer Stop"

    CloseSplashScreen()
    ShowGridScreen()
    RunContentTask() ' retrieving content
end sub


' The OnKeyEvent() function receives remote control key events
function OnkeyEvent(key as string, press as boolean) as boolean
    print "MainScene.brs = > OnkeyEvent"

    result = false
    if press
        ' handle "back" key press
        if key = "back"
            numberOfScreens = m.screenStack.Count()
            ' close top screen if there are two or more screens in the screen stack
            if numberOfScreens > 1
                CloseScreen(invalid)
                result = true
            end if
        else if key = "OK" and m.videoUnavailablePopup.visible
            m.top.exitApp = true
        end if
    end if
    ' The OnKeyEvent() function must return true if the component handled the event,
    ' or false if it did not handle the event.
    return result
end function




