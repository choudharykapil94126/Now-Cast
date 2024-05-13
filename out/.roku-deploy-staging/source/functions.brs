function AppUrl()
    api = {
        ' domainNameApi: "https://dashboard.nowcast.cc/"
        ' domainNameApi: "http://52.71.217.35:8082/"
        domainNameApi: "https://dev.nowcast.cc/"
    }
    return api
end function

function ApiUrl()
    url = {
        adminServiceUrl: AppUrl().domainNameApi + "admin-service/api/v1/",
        authenticationServiceUrl: AppUrl().domainNameApi + "authentication-service/api/v1/",
        imageServiceUrl: AppUrl().domainNameApi + "image-service/api/v1/",
    }
    return url
end function

function GetTime(length as integer) as string
    minutes = (length \ 60).ToStr()
    seconds = length mod 60
    if seconds < 10
        seconds = "0" + seconds.ToStr()
    else
        seconds = seconds.ToStr()
    end if
    return minutes + ":" + seconds
end function

function getFont(fontSize as integer, fontUri as string) as object
    Font = CreateObject("roSGNode", "Font")
    Font.uri = fontUri
    Font.size = fontSize
    return Font
end function

function UI_CONSTANTS()
    m.di = CreateObject("roDeviceInfo")
    data = {

        spinnerLoader: "pkg:/images/localImages/spinner1.png",
        signInBtn: "pkg:/images/localImages/signIn1.png",
        signInFocused: "pkg:/images/localImages/signInFocused.png",
        signOutBtn: "pkg:/images/localImages/signOutBtn.png",

        keyboardBackground: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["black1.png"]).Trim() + "?height=390&width=1480",
        checked: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["checked.png"]).Trim(),
        unchecked: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["unchecked.png"]).Trim(),
        logBtn: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["logBtn.png"]).Trim(),
        logInBorder: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["logInBorder.png"]).Trim(),
        whiteCircle: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["whiteCircle.png"]).Trim(),
        whiteRBG: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["WhiteRBG.png"]).Trim(),

        ' audio/video screens button
        playButton: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["PlayBtn.png"]).Trim(),
        pauseButton: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["PauseBtn.png"]).Trim()

        ' 15Sec Skip Button
        backwardBtn: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["BackwardBtn.png"]).Trim(),
        skipBackButton: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["Backward.png"]).Trim(),
        forwardBtn: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["ForwardBtn.png"]).Trim(),
        skipForwardButton: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["Fordward.png"]).Trim(),
        detailScreenGradientImage: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["radial7680.png"]).Trim() + "?height=" + str(m.di.GetUIResolution().height).Trim() + "&width=" + str(m.di.GetUIResolution().width).Trim(),
        ' leftGradient: ApiUrl().adminServiceUrl + "upload/load/" + str(m.global["leftGradient7680.png"]).Trim() + "?height=" + str(m.di.GetUIResolution().height).Trim() + "&width=" + str(m.di.GetUIResolution().width).Trim()
        ' bottomGradient: ApiUrl().adminServiceUrl + "upload/load/" + str(m.global["bottomGradient7680.png"]).Trim() + "?height=" + str(m.di.GetUIResolution().height).Trim() + "&width=" + str(m.di.GetUIResolution().width).Trim()
        leftGradient: "pkg:/images/localImages/32.jpeg",
        bottomGradient: "pkg:/images/localImages/28.jpeg",
        ' detailScreenGradientImage: "pkg:/images/localImages/40.jpeg",
        focusedWatchedButton: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["WatchWhite.png"]).Trim(),
        unFocusedWatchButton: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["WatchGrey.png"]).Trim(),
        focusedListenButton: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["ListenWhite.png"]).Trim(),
        unFocusedListenButton: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["ListenGrey.png"]).Trim(),
        ' transparentPopUpBackground: ApiUrl().adminServiceUrl + "upload/load/" + str(m.global["popUpRect3.png"]).Trim()
        transparentPopUpBackground: "pkg:/images/localImages/png.png"
        
        ' Audio Screen
        defaultSelectedImageForDetailScreen: ApiUrl().imageServiceUrl + "upload/load/" + str(m.global["black1.png"]).Trim() + "?height=" + str(m.di.GetUIResolution().height).Trim() + "&width=" + str(m.di.GetUIResolution().width).Trim(),
        ' 8508 Dev
        ' 24 Prod
        audioScreenBottomGradient: ApiUrl().imageServiceUrl + "upload/load/" + str(findId(8508, 24)).Trim() + "?height=" + str(m.di.GetUIResolution().height).Trim() + "&width=" + str(m.di.GetUIResolution().height).Trim()
    }
    return data
end function

function fontSet()
    font = {
        bold: "pkg:/source/fonts/MYRIADPRO-BOLD.OTF",
        regular: "pkg:/source/fonts/MYRIADPRO-REGULAR.OTF"
    }
    return font
end function

function ArrayContainValue(arr as object, value as integer) as boolean
    if value = 0 ' Invalid check
        return false
    end if
    if arr.Count() = 0
        ' print "This item is accessed to all"
        return false
    end if
    for each entry in arr
        if entry = value
            return true
        end if
    end for
    return false
end function

function findId(dev as integer, prod as integer) as integer
    if AppUrl().domainNameApi = "https://dashboard.nowcast.cc/"
        return prod
    else
        return dev
    end if
end function

function LoginUserApi(url as string, callType as string, data as object, parameters as object) as object
    requestObject = CreateObject("roUrlTransfer")
    urlParameters = ""
    if parameters <> invalid and parameters.Count() > 0
        for each parameter in parameters.Keys()
            urlParameters = (parameter).toStr() + "=" + (parameters[parameter]).toStr() + "&" + urlParameters
        end for
    end if

    if urlParameters <> ""
        url = url + "?" + urlParameters
        requestObject.SetUrl(url)
    else
        requestObject.SetUrl(url)
    end if
    requestObject.addHeader("Content-Type", "application/json")
    requestObject.addHeader("Accept", "application/json")
    requestObject.addHeader("deviceType", "ROKU")
    requestObject.setCertificatesFile("common:/certs/ca-bundle.crt")
    requestObject.initClientCertificates()
    requestObject.enableEncodings(true)
    requestObject.RetainBodyOnError(true)
    requestObject.SetRequest(callType)
    port = CreateObject("roMessagePort")
    requestObject.setMessagePort(port)
    requestBodyData = {}
    if callType = "POST"
        requestObject.SetRequest(callType)
        requestBodyData = data
        req = requestObject.AsyncPostFromString(FormatJson(requestBodyData))
    else if callType = "GET"
        requestObject.SetRequest(callType)
        req = requestObject.AsyncGetToString()
    end if

    if req
        while true
            msg = Wait(0, port)
            if Type(msg) = "roUrlEvent"

                responseJson = {}

                if msg.GetResponseCode() = 201

                    responseJson["responseCode"] = msg.GetResponseCode()
                    responseJson["jsonResponse"] = ParseJson(msg.GetString())
                    return responseJson
                else
                    responseJson["responseCode"] = msg.GetResponseCode()
                    responseJson["jsonResponse"] = ParseJson(msg.GetString())
                    responseJson["Failure"] = msg.GetFailureReason()
                    return responseJson
                end if
            else
                ' print msg.GetResponseCode()
                ' print msg.GetFailureReason()
            end if
        end while
    else
        ' print req
    end if
end function

function GetUserSubscriptionDetailByUserId(userId as string, token as string) as object
    GetUserSubscriptionDetailById = CreateObject("roURLTransfer")
    GetUserSubscriptionDetailById.SetCertificatesFile("common:/certs/ca-bundle.crt")
    port = CreateObject("roMessagePort")
    GetUserSubscriptionDetailById.setMessagePort(port)
    GetUserSubscriptionDetailById.addHeader("deviceType", "ROKU")
    GetUserSubscriptionDetailById.SetURL(ApiUrl().adminServiceUrl + "user/userPlanDetails/" + userId.Trim())
    GetUserSubscriptionDetailById.addHeader("Authorization", "Bearer " + token.Trim())
    req = GetUserSubscriptionDetailById.AsyncGetToString()

    if req
        while true
            msg = Wait(0, port)
            if Type(msg) = "roUrlEvent"
                responseJson = {}
                if msg.GetResponseCode() = 201
                    print ParseJson(msg.GetString()) , "LoginUser"
                    responseJson["responseCode"] = msg.GetResponseCode()
                    responseJson["jsonResponse"] = ParseJson(msg.GetString())
                    return responseJson
                else
                    responseJson["responseCode"] = msg.GetResponseCode()
                    responseJson["jsonResponse"] = ParseJson(msg.GetString())
                    responseJson["Failure"] = msg.GetFailureReason()
                    return responseJson
                end if
            else
                ' print msg.GetResponseCode()
                ' print msg.GetFailureReason()
            end if
        end while
    else
        ' print req
    end if
end function

function countApi(itemId as string, organizationid as string) as object
    sec = CreateObject("roRegistrySection", "Authentication")
    request = CreateObject("roUrlTransfer")
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.addHeader("Content-Type", "application/json")
    request.addHeader("Accept", "application/json")
    request.addHeader("deviceType", "ROKU")
    request.initClientCertificates()
    request.enableEncodings(true)
    request.RetainBodyOnError(true)
    data = {}
    data["deviceType"] = "ROKU"
    data["mediaItemId"] = itemId.toInt()
    data["mediaType"] = "VIDEO"

    request.SetRequest("POST")

    if sec.Read("loginToken") <> ""
        request.SetURL(ApiUrl().adminServiceUrl + "mediaPlay")
        request.addHeader("Authorization", "Bearer " + sec.Read("loginToken"))
    else
        request.SetURL(ApiUrl().adminServiceUrl + "mediaPlay/mediaPlayWithoutLogin?organizationId=" + organizationid)
    end if



    port = CreateObject("roMessagePort")
    request.setMessagePort(port)
    req = request.AsyncPostFromString(FormatJson(data))


    if req
        while true
            msg = Wait(0, port)
            if Type(msg) = "roUrlEvent"

                responseJson = {}

                if msg.GetResponseCode() = 201
                    responseJson["responseCode"] = msg.GetResponseCode()
                    responseJson["jsonResponse"] = ParseJson(msg.GetString())
                    return responseJson
                else
                    responseJson["responseCode"] = msg.GetResponseCode()
                    responseJson["jsonResponse"] = ParseJson(msg.GetString())
                    responseJson["Failure"] = msg.GetFailureReason()
                    return responseJson
                end if
            else
                ' print msg.GetResponseCode()
                ' print msg.GetFailureReason()
            end if
        end while
    else
        ' print req
    end if
end function

function appLaunchAndDownloadApi(url as string, data as object, organizationId as string) as object
    '   Brading Api  start ****************************
    brandingData = CreateObject("roURLTransfer")
    brandingData.SetCertificatesFile("common:/certs/ca-bundle.crt")
    ' print "Branding Api Hit From applaunch api with OrgId = ", utility().organizationId
    brandingData.SetURL(ApiUrl().adminServiceUrl + "branding/getBrandingInfo?organizationId=" + utility().organizationId)
    brandingData.addHeader("deviceType", "ROKU")
    brandingDataResponse = brandingData.GetToString()
    brandingDataResponseJson = ParseJson(brandingDataResponse)
    if brandingDataResponseJson <> invalid
        if brandingDataResponse <> invalid
            print brandingDataResponseJson.data, "adasdasdas"

            m.global.organizationColor = brandingDataResponseJson.data.brandColor
            m.global.organizationName = brandingDataResponseJson.data.organizationName
            m.global.organizationUrl = brandingDataResponseJson.data.organizationUrl
            m.global.addFields(brandingDataResponseJson.data.gradientImages)
            m.global.enableVastTag = brandingDataResponseJson.data.enableVastTag
            m.global.vastTagUrl = brandingDataResponseJson.data.adExchangeUrl
            m.global.vastTagUrlMiddle = brandingDataResponseJson.data.midRangeExchangeUrl
            m.global.organizationLogo = ApiUrl().adminServiceUrl + "upload/loadPng/" + str(brandingDataResponseJson.data.logo.id).Replace(" ", "")
        else
            m.global.organizationColor = "#fcba03"
            m.global.organizationName = "Oodles Technologies"
            m.global.organizationUrl = "www.oodles.com"
            m.global.organizationLogo = "pkg:/images/launchScreen/nowcastlogo1.png"
        end if
    end if

    '   Brading Api  E ****************************

    requestObject = CreateObject("roUrlTransfer")
    requestObject.SetUrl(url + "/saveAppInfo?organizationId=" + organizationId)
    requestObject.addHeader("Content-Type", "application/json")
    requestObject.addHeader("Accept", "application/json")
    requestObject.addHeader("deviceType", "ROKU")
    requestObject.setCertificatesFile("common:/certs/ca-bundle.crt")
    requestObject.initClientCertificates()
    requestObject.enableEncodings(true)
    requestObject.RetainBodyOnError(true)
    port = CreateObject("roMessagePort")
    requestObject.setMessagePort(port)
    requestBodyData = {}
    requestObject.SetRequest("POST")
    requestBodyData = data
    req = requestObject.AsyncPostFromString(FormatJson(requestBodyData))

    if req
        while true
            msg = Wait(0, port)
            if Type(msg) = "roUrlEvent"

                responseJson = {}

                if msg.GetResponseCode() = 201

                    responseJson["responseCode"] = msg.GetResponseCode()
                    responseJson["jsonResponse"] = ParseJson(msg.GetString())
                    return responseJson
                else
                    responseJson["responseCode"] = msg.GetResponseCode()
                    responseJson["jsonResponse"] = ParseJson(msg.GetString())
                    responseJson["Failure"] = msg.GetFailureReason()
                    return responseJson
                end if
            else
                ' print msg.GetResponseCode()
                ' print msg.GetFailureReason()
            end if
        end while
    else
        ' print req
    end if
end function

function getBroadcastingStatus(itemId as string) as object
    '   Brading Api  start ****************************
    brodcastingData = CreateObject("roURLTransfer")
    brodcastingData.SetCertificatesFile("common:/certs/ca-bundle.crt")
    brodcastingData.addHeader("deviceType", "ROKU")
    brodcastingData.SetURL(ApiUrl().adminServiceUrl + "liveStreaming/broadCastStatus/" + itemId)
    rsp = brodcastingData.GetToString()
    if ParseJson(rsp) <> invalid
        ' parse the feed and build a tree of ContentNodes to populate the GridView
        json = ParseJson(rsp)
        if json <> invalid
            responseJson = {}
            if json.httpStatus = 200
                responseJson["data"] = json.data
                responseJson["responseCode"] = json.httpStatus
                return responseJson
            else
                responseJson["responseCode"] = json.httpStatus
                return responseJson
            end if
        end if
    end if
end function

function calculateBannerHeightWidth(value as integer)
    return (58.75 * value) / 100
end function

function calculateThumbnailHeightWidth(value as integer)
    return (20 * value) / 100
end function

function distanceOfRowlistFromTop(value as integer)
    return (52.7777778 * value) / 100
end function

function rowListItemWidth(value as integer)
    return (94.375 * value) / 100
end function

function rowListItemHeight(value as integer)
    return (43.0555556 * value) / 100
end function

function findMaxResolutionPath(array as object)
    final = ""
    objects = {}
    for each resolution in array
        if resolution.size <> invalid
            name = resolution.size
            objects[name + "p"] = resolution.src
        end if
    end for
    ' print objects, "**************" , m.di.GetVideoMode()
    screenResolution = m.di.GetVideoMode()
    if objects[screenResolution] <> invalid
        final = objects[screenResolution]
        ' else if objects["2160"] <> invalid
        '     final = objects["2160"]
        ' else if objects["1080"] <> invalid
        '     final = objects["1080"]
        ' else if objects["720"] <> invalid
        '     final = objects["720"]
        ' else if objects["480"] <> invalid
        '     final = objects["480"]
        ' else if objects["360"] <> invalid
        '     final = objects["360"]
    end if
    ' print final
    return final
end function

function IsString(value as dynamic) as boolean
    return IsValid(value) and GetInterface(value, "ifString") <> invalid
end function

function IsValid(value as dynamic) as boolean
    return Type(value) <> "<uninitialized>" and value <> invalid
end function