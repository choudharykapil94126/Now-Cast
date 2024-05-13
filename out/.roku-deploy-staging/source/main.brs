' ********** Copyright 2020 Roku Corp.  All Rights Reserved. **********

' Channel entry point
sub Main(args)
  ShowChannelRSGScreen(args)
end sub
sub ShowChannelRSGScreen(args as dynamic)
  ' The roSGScreen object is a SceneGraph canvas that displays the contents of a Scene node instance
  screen = CreateObject("roSGScreen")
  ' message port is the place where events are sent
  m.port = CreateObject("roMessagePort")
  port = createobject("romessageport")
  ' sets the message port which will be used for events from the screen
  screen.SetMessagePort(m.port)
  ' every screen object must have a Scene node, or a node that derives from the Scene node
  ' screen.CreateScene("MainScene")
  ' screen.observeField("exitApp", m.port)
  ' screen.Show() ' Init method in MainScene.brs is invoked
  scene = screen.CreateScene("MainScene")
  screen.show()
  scene.observeField("exitApp", m.port)
  print args , "args"

  scene.signalBeacon("AppLaunchComplete")
  scene.setFocus(true)


  m.global = screen.getGlobalNode()
  m.global.addfield("audioToListenBtn", "string", false)
  m.global.addfield("loginToSignInBtn", "string", false)
  m.global.addfield("isWhiteLabel", "string", false)
  m.global.addfield("addUrl" , "string" , false)

  m.global.addfield("organizationColor", "string", false)
  m.global.addfield("organizationLogo", "string", false)
  m.global.addfield("organizationName", "string", false)
  m.global.addfield("organizationUrl", "string", false)
  m.global.addfield("enableVastTag", "boolean", false)
  m.global.addfield("vastTagUrl", "string", false)
  m.global.addfield("vastTagUrlMiddle", "string" , false)
  m.global.addfield("vastTagUrlLogedInAndAgainCome", "boolean" , false)
  m.global.addfield("vastTagUrlLogedInFirstTime", "boolean" , false)



  m.global.addfield("checkVideoBeforeMiddleAds", "boolean" , false)


  m.global.addfield("loginToken", "string", false)
  m.global.addfield("userSubscriptionDetail", "", false)

  m.global.addfield("channelUrl", "string", false)
  m.global.addfield("channelUrlFormat", "string", false)
  m.global.addfield("middleVideoPlayCheck", "boolean", false)

  m.global.addfield("gridTypeContent", "node", false)



  InputObject = createobject("roInput")
  InputObject.setmessageport(port)


  ' For Deep Linking
  while true
    msg = port.waitmessage(500)
    if type(msg) = "roInputEvent" then
      print "INPUT EVENT!"
      if msg.isInput()
        inputData = msg.getInfo()
        'print inputData'
        for each item in inputData
          print item + ": " inputData[item]
        end for

        ' pass the deeplink to UI
        if inputData.DoesExist("mediaType") and inputData.DoesExist("contentID")
          deeplink = {
            id: inputData.contentID
            type: inputData.mediaType
          }
          print "got input deeplink= "; deeplink
          m.top.inputData = deeplink
        end if
      end if
    end if
  end while

  ' event loop
  while(true)
    ' waiting for events from screen
    msg = wait(0, m.port)
    msgType = type(msg)
    if msgType = "roSGScreenEvent"
      if msg.IsScreenClosed() then return
    else if msgType = "roSGNodeEvent" then
      field = msg.getField()
      if field = "exitApp" then
        return
      end if
    end if
  end while
end sub
