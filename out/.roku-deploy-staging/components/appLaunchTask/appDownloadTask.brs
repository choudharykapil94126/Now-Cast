sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
        appDownloadtask = appLaunchAndDownloadApi(ApiUrl().adminServiceUrl + "appInfo", m.top.data, utility().organizationId)
end sub

