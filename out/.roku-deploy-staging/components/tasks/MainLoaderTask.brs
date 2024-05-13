' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    ' request the content feed from the API
    xfer = CreateObject("roURLTransfer")
    refreshTokenApi = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.addHeader("deviceType", "ROKU")
    refreshTokenApi.SetCertificatesFile("common:/certs/ca-bundle.crt")
    refreshTokenApi.addHeader("deviceType", "ROKU")
    sec = CreateObject("roRegistrySection", "Authentication")


    m.di = CreateObject("roDeviceInfo")

    if sec.Read("organizationId") = ""
        sec.Write("organizationId", utility().organizationId)
    else if sec.Read("organizationId") <> utility().organizationId
        sec.Delete("loginToken")
        sec.Delete("loggedUserId")
        sec.Delete("userSubscriptionId")
        sec.Delete("organizationId")
        sec.Write("organizationId", utility().organizationId)
    end if

    if sec.Read("loginToken") = ""
        xfer.SetURL(ApiUrl().adminServiceUrl + "tab/getTvAppAllDetails?organizationId=" + utility().organizationId)
    else
        xfer.SetURL(ApiUrl().adminServiceUrl + "tab/getTvAppAllDetailsWithLogin")
        xfer.addHeader("Authorization", "Bearer " + sec.Read("loginToken"))
        demo = ParseJson(xfer.GetToString())

        ' Check Token is Expired or Not if condition token expired condition and else handle valid case
        if demo = invalid
            sec.Delete("loginToken")
            sec.Delete("userSubscriptionId")
            sec.Delete("loggedUserId")
            xfer.SetURL(ApiUrl().adminServiceUrl + "tab/getTvAppAllDetails?organizationId=" + utility().organizationId)
        else
            ' this is used to refresh token if previous token is valid ***************
            refreshTokenApi.SetURL(ApiUrl().authenticationServiceUrl + "refreshToken?tokenString=" + sec.Read("loginToken"))
            refreshTokenApi.addHeader("Authorization", "Bearer " + sec.Read("loginToken"))
            refreshTokenApiResponse = ParseJson(refreshTokenApi.GetToString())
            sec.Write("loginToken", refreshTokenApiResponse.data)

            ' Get Fresh SUbscription Detail for logged in User  ****************
            subscriptionDetailResponse = GetUserSubscriptionDetailByUserId(sec.Read("loggedUserId"), sec.Read("loginToken"))
            print subscriptionDetailResponse.jsonResponse.data , "When user again login"
            print type(subscriptionDetailResponse.jsonResponse.data.vastTagEnabled)
            m.global.vastTagUrlLogedInAndAgainCome = subscriptionDetailResponse.jsonResponse.data.vastTagEnabled

            if subscriptionDetailResponse.jsonResponse.data.id <> invalid
                m.global.addFields({ userSubscriptionId: subscriptionDetailResponse.jsonResponse.data.id })
            else
                m.global.addFields({ userSubscriptionId: 0 })
            end if

        end if
    end if

    rsp = xfer.GetToString()
    rootChildren = []

    if ParseJson(rsp) <> invalid

        ' parse the feed and build a tree of ContentNodes to populate the GridView
        json = ParseJson(rsp)
        if json <> invalid
            for each category in json
                value = json.Lookup(category)
                if Type(value) = "roArray" ' if parsed key value having other objects in it
                    mediaSeriesDTOList = value[0].mediaSeriesDTOList
                    for each item in mediaSeriesDTOList ' parse items and push them to row
                        row = {}
                        row.children = []
                        row.title = item.title
                        ' print "hello" item.mediaItemDTO, item.mediaItemDTO.Count()
                        if item.mediaItemDTO.Count() > 0
                            for each mediaItemDto in item.mediaItemDTO
                                itemData = GetItemData(mediaItemDto)
                                row.children.Push(itemData)
                            end for
                            rootChildren.Push(row)
                        end if

                    end for
                end if
            end for
            ' set up a root ContentNode to represent rowList on the GridScreen
            contentNode = CreateObject("roSGNode", "ContentNode")

            contentNode.Update({
                children: rootChildren
            }, true)

            ' populate content field with root content node.
            ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
            m.top.content = contentNode
        end if
    else
        m.top.errorLoadingContent = true
    end if

end sub

function GetItemData(mediaDTOValue as object) as object
    item = {}

    ' populate some standard content metadata fields to be displayed on the GridScreen
    item.description = mediaDTOValue.description
    item.title = mediaDTOValue.title
    item.releaseDate = mediaDTOValue.publishedDate
    item.id = mediaDTOValue.id
    item.fullDataForSelectedItem = mediaDTOValue

    bannerString = ""
    if mediaDTOValue.wideArtwork <> invalid
        height = 1080 / 9
        width = 1920 / 16
        if utility().useBannerArtwork
            bannerString = str(mediaDTOValue.bannerArtwork.document.id).Replace(" ", "")
        else
            bannerString = str(mediaDTOValue.wideArtwork.document.id).Replace(" ", "")
        end if

        item.detailPageBannerImage = ApiUrl().imageServiceUrl + "upload/load/" + str(mediaDTOValue.wideArtwork.document.id).Replace(" ", "") + "?height=" + str(m.di.GetUIResolution().height).Trim() + "&width=" + str(m.di.GetUIResolution().width).Trim()
        item.bannerImage = ApiUrl().imageServiceUrl + "upload/load/" + bannerString + "?height=" + str(int(calculateBannerHeightWidth(m.di.GetUIResolution().height))).Trim() + "&width=" + str(int(calculateBannerHeightWidth(m.di.GetUIResolution().width))).Trim()
        item.thumbnailBanner = ApiUrl().imageServiceUrl + "upload/load/" + str(mediaDTOValue.wideArtwork.document.id).Replace(" ", "") + "?height=" + str(int(calculateThumbnailHeightWidth(m.di.GetUIResolution().height))).Trim() + "&width=" + str(int(calculateThumbnailHeightWidth(m.di.GetUIResolution().width))).Trim()
        item.backgroundColor = mediaDTOValue.wideArtwork.document.imageColur
    else
        ' dev: 8507
        item.detailPageBannerImage = ApiUrl().imageServiceUrl + "upload/load/" + str(findId(8507, 6)).Trim() + "?height=" + "1080" + "&width=" + "1920"
        item.bannerImage = ApiUrl().imageServiceUrl + "upload/load/" + str(findId(8507, 6)).Trim() + "?height=" + str(int(calculateBannerHeightWidth(1080))).Trim() + "&width=" + str(int(calculateBannerHeightWidth(1920))).Trim()
        item.thumbnailBanner = ApiUrl().imageServiceUrl + "upload/load/" + str(findId(8507, 6)).Trim() + "?height=" + str(int(calculateThumbnailHeightWidth(1080))).Trim() + "&width=" + str(int(calculateThumbnailHeightWidth(1920))).Trim()
        item.backgroundColor = "#878787"
    end if

    if mediaDTOValue.tvLogoId <> invalid
        item.detailPageLogoImage = ApiUrl().imageServiceUrl + "upload/loadPng/" + str(mediaDTOValue.tvLogoId).Trim()
    else
        item.detailPageLogoImage = invalid
    end if

    if mediaDTOValue.subTitle <> invalid 'condition to replace special charecter from subtitle
        item.newsubtitle = mediaDTOValue.subTitle.Replace(Chr(8231), "·")
    else
        item.newsubtitle = invalid
    end if

    return item
end function





