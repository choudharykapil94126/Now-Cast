' Copyright (c) 2020 Roku, Inc. All rights reserved.

sub OnContentSet() ' invoked when item metadata retrieved
   ' print "RowlistComponent.brs = > OnContentSet"
    content = m.top.itemContent
    m.di = CreateObject("roDeviceInfo")
    
    if content <> invalid
    '   print content.fulldataforselecteditem "content "
        m.top.FindNode("poster").uri = content.thumbnailBanner
        m.top.FindNode("posterBackground").color = content.backgroundColor
        m.top.FindNode("poster").width = int(calculateThumbnailHeightWidth(m.di.GetDisplaySize().w))
        m.top.FindNode("poster").height = int(calculateThumbnailHeightWidth(m.di.GetDisplaySize().h))
        m.liveIndication = m.top.FindNode("liveIndication")

        m.top.FindNode("posterBackground").width = int(calculateThumbnailHeightWidth(m.di.GetDisplaySize().w))
        m.top.FindNode("posterBackground").height = int(calculateThumbnailHeightWidth(m.di.GetDisplaySize().h))

        m.rowListLabel = m.top.FindNode("rowListLabel")
        m.rowListLabel.text = content.title
        m.rowListLabel.font = getFont(18, fontSet().regular)

        if(content.fulldataforselecteditem.itemType = "LIVE_STREAMING")
            m.liveIndication.visible = "true"
        end if
    end if
end sub
