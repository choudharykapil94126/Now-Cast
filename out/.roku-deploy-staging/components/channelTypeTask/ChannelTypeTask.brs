' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    channelData = GetChannelDetailByOrgId()
    print channelData.jsonResponse.data, "CHANLLE"

    if channelData.jsonResponse.data.isChannel and channelData.jsonResponse.data.isVod
        mediaDetails = GetChannelByMediaItemId(Str(channelData.jsonResponse.data.id).trim())
        print mediaDetails.jsonResponse.data.channelInfoDTO, "Channele"
        if mediaDetails.jsonResponse.data.channelInfoDTO.channelType = "CUSTOM"
            m.top.bothChannelAndVideo = mediaDetails
        else
            m.top.bothChannelAndVideo = mediaDetails
        end if
        ' m.top.bothChannelAndVideo = true
        return
    end if

    if(channelData.jsonResponse.data.isChannel)
        mediaDetails = GetChannelByMediaItemId(Str(channelData.jsonResponse.data.id).trim())
        ' print mediaDetails.jsonResponse.data.channelInfoDTO, "Channele"
        if mediaDetails.jsonResponse.data.channelInfoDTO.channelType = "CUSTOM"
            m.top.data = mediaDetails
        else
            m.top.m3u8Data = mediaDetails
        end if
    else
        m.top.vodData = {
            isChannel: false
        }
    end if
end sub

function GetChannelDetailByOrgId() as object
    GetUserSubscriptionDetailById = CreateObject("roURLTransfer")
    GetUserSubscriptionDetailById.SetCertificatesFile("common:/certs/ca-bundle.crt")
    port = CreateObject("roMessagePort")
    GetUserSubscriptionDetailById.setMessagePort(port)
    GetUserSubscriptionDetailById.addHeader("deviceType", "ROKU")
    GetUserSubscriptionDetailById.SetURL(ApiUrl().adminServiceUrl + "tab/tvAppContent?organizationId=" + utility().organizationId)
    req = GetUserSubscriptionDetailById.AsyncGetToString()

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

function GetChannelByMediaItemId(media as string) as object
    sec = CreateObject("roRegistrySection", "Authentication")
    GetUserSubscriptionDetailById = CreateObject("roURLTransfer")
    GetUserSubscriptionDetailById.SetCertificatesFile("common:/certs/ca-bundle.crt")
    port = CreateObject("roMessagePort")
    GetUserSubscriptionDetailById.setMessagePort(port)
    GetUserSubscriptionDetailById.addHeader("deviceType", "ROKU")
    ' if user is logged in
    ' if no login found
    if sec.Read("loginToken") = ""
        GetUserSubscriptionDetailById.SetURL(ApiUrl().adminServiceUrl + "mediaItem/mediaItemId/" + media + "?organizationId=" + utility().organizationId)
    else
        GetUserSubscriptionDetailById.SetURL(ApiUrl().adminServiceUrl + "mediaItem/" + media)
        GetUserSubscriptionDetailById.addHeader("Authorization", "Bearer " + sec.Read("loginToken").Trim())
    end if
    req = GetUserSubscriptionDetailById.AsyncGetToString()

    if req
        while true
            msg = Wait(0, port)
            if Type(msg) = "roUrlEvent"
                responseJson = {}
                if msg.GetResponseCode() = 200
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





