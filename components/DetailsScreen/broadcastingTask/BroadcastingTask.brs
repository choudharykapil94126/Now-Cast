sub Init()
    m.top.functionName = "BroadcastingApiContent"
end sub

sub BroadcastingApiContent()
   resp =  getBroadcastingStatus(m.top.mediaItemId)
   m.top.response = resp
end sub





