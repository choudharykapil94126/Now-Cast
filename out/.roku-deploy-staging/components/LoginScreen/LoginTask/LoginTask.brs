sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    loginUserResponse = LoginUserApi( ApiUrl().authenticationServiceUrl + "user/loginUser?organizationId=" + utility().organizationId, m.top.callType, m.top.data, m.top.headerData)
    if loginUserResponse.jsonResponse.success
        subscriptionDetailResponse = GetUserSubscriptionDetailByUserId(Str(loginUserResponse.jsonResponse.data.userDetails.id), loginUserResponse.jsonResponse.data.token)
        if subscriptionDetailResponse.jsonResponse.data.id <> invalid 
            m.global.addFields({ userSubscriptionId: subscriptionDetailResponse.jsonResponse.data.id })
        else 
            m.global.addFields({ userSubscriptionId: 0 })
        end if
        sec = CreateObject("roRegistrySection", "Authentication")
        sec.Write("loggedUserId", str(loginUserResponse.jsonResponse.data.userDetails.id))
        print subscriptionDetailResponse.jsonResponse.data
        print Type(subscriptionDetailResponse.jsonResponse.data.vastTagEnabled)
        m.global.vastTagUrlLogedInFirstTime = subscriptionDetailResponse.jsonResponse.data.vastTagEnabled
    end if
    m.top.response = loginUserResponse.jsonResponse
end sub

