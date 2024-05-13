' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub

sub GetContent()

    if m.top.socketType = "analytical"
        data = {
            "type": "analytical",
            "data": {
                "userId": m.top.userId.toInt(),
                "mediaId": m.top.mediaId.toInt(),
                "orgId": m.top.orgId.toInt(),
                "usage": m.top.usage,
                "device": "ROKU",
                "mediaType": m.top.mediaType,
                "duration": m.top.duration,
                "createdAt": m.top.createdAt
            }
        }
        mediaDetails = GetChannelByMediaItemId(data)
        ' print mediaDetails
    else
        data = {
            "type": "viewer",
            "data": {
                "userId": m.top.userId.toInt(),
                "mediaId": m.top.mediaId.toInt(),
                "randomId": m.top.randomId,
                "type": m.top.type
            }
        }
        mediaDetails = GetChannelByMediaItemId(data)
        ' print mediaDetails
    end if

   
end sub

function GetChannelByMediaItemId(media as object) as object
    ' print media.data , "media.data"
    sec = CreateObject("roRegistrySection", "Authentication")
    GetUserSubscriptionDetailById = CreateObject("roURLTransfer")
    GetUserSubscriptionDetailById.SetCertificatesFile("common:/certs/ca-bundle.crt")
    port = CreateObject("roMessagePort")
    GetUserSubscriptionDetailById.SetURL("https://socket.nowcast.cc/api/analytics")
    GetUserSubscriptionDetailById.addHeader("Content-Type", "application/json")
    GetUserSubscriptionDetailById.addHeader("Accept", "application/json")
    GetUserSubscriptionDetailById.setMessagePort(port)
    GetUserSubscriptionDetailById.initClientCertificates()
    GetUserSubscriptionDetailById.enableEncodings(true)
    GetUserSubscriptionDetailById.RetainBodyOnError(true)
    GetUserSubscriptionDetailById.SetRequest("POST")
    ' req = GetUserSubscriptionDetailById.AsyncGetToString()
    req = GetUserSubscriptionDetailById.AsyncPostFromString(FormatJson(media))

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
            end if
        end while
    else
        ' print req
    end if
end function





