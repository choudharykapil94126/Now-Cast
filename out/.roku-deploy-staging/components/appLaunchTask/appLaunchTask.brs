sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    appLaunchTask = appLaunchAndDownloadApi(ApiUrl().adminServiceUrl + "appInfo", m.top.data, utility().organizationId)
    setVideoUrl = ""
    isVideo = false
    m.global.isWhiteLabel = appLaunchTask.jsonResponse.data.isWhiteLabel

    if appLaunchTask.jsonResponse.data.splashScreenType = "VIDEO" and appLaunchTask.jsonResponse.data.splashScreenContentUrl <> invalid
        isVideo = true
        setVideoUrl = appLaunchTask.jsonResponse.data.splashScreenContentUrl
    end if
    m.global.addFields({ setVideoUrl: setVideoUrl, isVideo: isVideo })
    m.top.response = appLaunchTask.jsonResponse

end sub

