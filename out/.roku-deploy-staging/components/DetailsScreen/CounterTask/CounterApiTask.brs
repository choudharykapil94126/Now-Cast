sub Init()
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    subscriptionDetailResponse = countApi(m.top.itemId, utility().organizationId)
end sub

