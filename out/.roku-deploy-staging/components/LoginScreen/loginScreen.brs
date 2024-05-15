sub init()
    ' print "LoginScreen.brs: - Init"
    m.top.findNode("audioLoadingSpinner").uri = UI_CONSTANTS().spinnerLoader

    m.brandColorRectangle = m.top.FindNode("brandColorRectangle")
    m.logInPageLogo = m.top.FindNode("logInPageLogo")
    m.LogInAlertPoster = m.top.FindNode("LogInAlertPoster")
    m.LogInAlertText = m.top.FindNode("LogInAlertText")
    m.emailText = m.top.FindNode("emailText")
    m.emailBox = m.top.FindNode("emailBox")
    m.emailBoxPoster = m.top.FindNode("emailBoxPoster")
    m.audioLoadingSpinner = m.top.findNode("audioLoadingSpinner")

    m.logInPageLogo.loadHeight = utility().loginScreenLogoSize
    m.logInPageLogo.loadWidth = utility().loginScreenLogoSize * 2
    m.logInPageLogo.height = utility().loginScreenLogoSize

    m.audioLoadingSpinner.poster.width = "25"
    m.audioLoadingSpinner.poster.height = "25"

    m.passwordText = m.top.FindNode("passwordText")
    m.passwordBox = m.top.FindNode("passwordBox")
    m.passwordBoxPoster = m.top.FindNode("passwordBoxPoster")

    m.logInBtn = m.top.FindNode("logInBtn")
    m.LoginValidationPoster = m.top.FindNode("LoginValidationPoster")
    m.LoginValidationText = m.top.FindNode("LoginValidationText")
    m.logInBtn.observeField("buttonSelected", "onLoginPress")

    m.emailKeyboard = m.top.FindNode("emailKeyboard")
    m.passwordKeyboard = m.top.findNode("passwordKeyboard")
    m.keyboardPoster = m.top.FindNode("keyboardPoster")
    m.logInBorder = m.top.FindNode("logInBorder")

    m.emailBox.setFocus(true)
    m.checked = m.top.findNode("checked")
    m.unchecked = m.top.findNode("unchecked")
    m.checkBoxBorder = m.top.findNode("checkBoxBorder")

    m.emailKeyboard.observeField("text", "emailKeyboardText")
    m.emailKeyboard.observeField("textEditBox", "emailKeyboardTextCursor")
    m.passwordKeyboard.observeField("text", "passwordKeyboardText")
    m.passwordKeyboard.observeField("textEditBox", "passwordKeyboardTextCursor")

    m.emailText.font = getFont(18, fontSet().bold)
    m.passwordText.font = getFont(18, fontSet().bold)
    m.LoginValidationText.font = getFont(18, fontSet().regular)
    m.top.findNode("showPassword").font = getFont(18, fontSet().regular)
    m.LoginValidationText.color = "#B4020F"
    m.brandColorRectangle.color = m.global.organizationColor
    m.logInPageLogo.uri = m.global.organizationLogo
    m.keyboardPoster.uri = UI_CONSTANTS().keyboardBackground
    m.checked.uri = UI_CONSTANTS().checked
    m.logInBtn.focusBitmapUri = UI_CONSTANTS().logBtn
    m.logInBtn.focusFootprintBitmapUri = UI_CONSTANTS().logBtn
    m.logInBorder.uri = UI_CONSTANTS().logInBorder
    m.emailBoxPoster.uri = UI_CONSTANTS().logInBorder
    m.passwordBoxPoster.uri = UI_CONSTANTS().logInBorder
    m.unchecked.uri = UI_CONSTANTS().unchecked
    m.checkBoxBorder.uri = UI_CONSTANTS().unchecked
    m.LoginValidationPoster.uri = UI_CONSTANTS().whiteRBG
    m.emailBox.backgroundUri = UI_CONSTANTS().whiteRBG
    m.passwordBox.backgroundUri = UI_CONSTANTS().whiteRBG


end sub


function onKeyEvent(key as string, press as boolean) as boolean
    ' print "LoginScreen.brs: - okKeyEvent" press, key

    result = false
    if press then

        if key = "down"
            pressDown()
            result = true
        else if (key = "up")
            pressUp()
            result = true
        else if (key = "OK")
            pressOk()
            result = true
        else if (m.emailBox.active or m.passwordBox.active) and key = "back"
            keyboardClose()
            result = true
            ' else if (key = "right")
            '     pressRight()
            '     result = true
            ' else if (key = "left")
            '     pressLeft()
            '     result = true
        else if (key = "back")
            m.top.backToPreviousPage = true
            result = true
        end if
    end if
    return result
end function

function pressDown() as boolean
    ' print "LoginScreen.brs: - pressDown"

    if m.emailBox.hasFocus()
        m.passwordBox.setFocus(true)
        m.emailBox.setFocus(false)
        m.passwordBoxPoster.visible = true
        m.emailBoxPoster.visible = false
    else if m.passwordBox.hasFocus()
        m.passwordBoxPoster.visible = false
        m.passwordBox.setFocus(false)

        if (m.unchecked.hasFocus() or m.checked.visible)
            m.checked.setFocus(true)
            m.checkBoxBorder.visible = true
        else
            m.unchecked.setFocus(true)
            m.checkBoxBorder.visible = true
            return true
        end if
        ' m.unchecked.setFocus(true)
        m.checkBoxBorder.visible = true
        ' m.logInBtn.setFocus(true)
        ' m.logInBorder.visible = true
        ' m.passwordBoxPoster.visible = false

    else if (m.checked.hasFocus() or m.unchecked.hasFocus())
        m.checked.setFocus(false)
        m.unchecked.setFocus(false)
        m.checkBoxBorder.visible = false
        m.logInBtn.setFocus(true)
        m.logInBorder.visible = true
        m.passwordBoxPoster.visible = false
        return true
    end if
end function

sub onLoginPress()
    ' print "LoginScreen.brs: - onLoginPress"

    m.LoginValidationPoster.visible = false
    m.audioLoadingSpinner.visible = true
    m.logInBtn.visible = false
    m.LoginTask = CreateObject("roSGNode", "LoginTask")
    data = {}
    ' data["username"] = ("test+9@yopmail.com").Trim()
    ' data["password"] = ("123456").Trim()
    data["username"] = (m.emailBox.text).Trim()
    data["password"] = (m.passwordBox.text).Trim()
    m.LoginTask.callType = "POST"
    m.LoginTask.data = data
    m.LoginTask.control = "RUN"
    m.LoginTask.observeField("response", "LoginResponse")
end sub

sub LoginResponse(responsData as object)
    ' print "LoginScreen.brs: - LoginResponse"

    response = responsData.getData()
    ' print "responsData.getData()" , response.data

    if response.success = true
        m.global.loginToken = response.data.token
        sec = CreateObject("roRegistrySection", "Authentication")
        sec.Write("loginToken", response.data.token)
        m.audioLoadingSpinner.visible = false
        m.logInBtn.visible = true
        m.top.backToPreviousPage = true
    else
        m.LoginValidationPoster.visible = true
        m.audioLoadingSpinner.visible = false
        m.logInBtn.visible = true
    end if
end sub

function pressUp() as boolean
    ' print "LoginScreen.brs: - pressUp"

    if m.logInBtn.hasFocus()
        m.logInBtn.setFocus(false)
        m.logInBorder.visible = false
        if (m.unchecked.hasFocus() or m.checked.visible)
            m.checked.setFocus(true)
            m.checkBoxBorder.visible = true
        else
            m.unchecked.setFocus(true)
            m.checkBoxBorder.visible = true
            return true
        end if
        m.checkBoxBorder.visible = true
        return true

    else if m.passwordBox.hasFocus()
        m.emailBox.setFocus(true)
        m.passwordBox.setFocus(false)
        m.emailBoxPoster.visible = true
        m.passwordBoxPoster.visible = false
        return true

    else if (m.checked.hasFocus() or m.unchecked.hasFocus())
        m.checked.setFocus(false)
        m.unchecked.setFocus(false)
        m.checkBoxBorder.visible = false
        m.passwordBox.setFocus(true)
        m.passwordBoxPoster.visible = true
        return true

    end if
end function

function pressRight() as boolean
    ' print "LoginScreen.brs: - pressRight"

    if (m.passwordBox.hasFocus() and m.checked.visible)
        m.checked.setFocus(true)
        m.checkBoxBorder.visible = true

    else if (m.passwordBox.hasFocus())
        m.unchecked.setFocus(true)
        m.checkBoxBorder.visible = true
        return true
    end if
end function

function pressLeft() as boolean
    ' print "LoginScreen.brs: - pressLeft"
    if (m.checked.hasFocus() or m.unchecked.hasFocus())
        m.passwordBox.setFocus(true)
        m.checked.setFocus(false)
        m.unchecked.setFocus(false)
        m.checkBoxBorder.visible = false
        return true
    end if
end function

' **************************************************


function pressOk() as boolean
    if m.emailKeyboard.hasFocus() = false and m.passwordKeyboard.hasFocus() = false
        ' print "LoginScreen.brs: - pressOk"
        if m.emailBox.hasFocus()
            m.emailBox.setFocus(false)
            m.emailKeyboard.setFocus(true)
            m.passwordKeyboard.setFocus(false)
            m.emailKeyboard.visible = true
            m.passwordKeyboard.visible = false
            m.passwordBox.active = false
            m.emailBox.active = true
            m.keyboardPoster.visible = true
            m.LoginValidationPoster.visible = false
        else if m.passwordBox.hasFocus()
            m.passwordBox.setFocus(false)
            m.emailKeyboard.setFocus(false)
            m.passwordKeyboard.setFocus(true)
            m.emailKeyboard.visible = false
            m.passwordKeyboard.visible = true
            m.emailBox.active = false
            m.passwordBox.active = true
            m.keyboardPoster.visible = true
            m.LoginValidationPoster.visible = false
        else if m.checked.hasFocus()
            m.unchecked.visible = true
            m.checked.visible = false
            m.passwordBox.secureMode = true
            m.checked.setFocus(false)
            m.unchecked.setFocus(true)
        else if m.unchecked.hasFocus()
            m.checked.visible = true
            m.checked.setFocus(true)
            m.unchecked.visible = false
            m.unchecked.setFocus(false)
            m.passwordBox.secureMode = false
        end if
    end if
end function

function keyboardClose() as boolean
    ' print "LoginScreen.brs: - keyboardClose"

    if m.emailBox.active
        m.emailBox.setFocus(true)
        m.emailKeyboard.visible = false
        m.emailBox.active = false
        m.keyboardPoster.visible = false
    else if m.passwordBox.active
        m.passwordBox.setFocus(true)
        m.passwordKeyboard.visible = false
        m.passwordBox.active = false
        m.keyboardPoster.visible = false
    end if
end function

sub emailKeyboardText(event as object)
    m.emailBox.text = event.getData()
end sub

sub emailKeyboardTextCursor(event as object)
    m.emailBox.cursorPosition = event.getData().cursorPosition
end sub

sub passwordKeyboardTextCursor(event as object)
    m.passwordBox.cursorPosition = event.getData().cursorPosition
end sub

sub passwordKeyboardText (event as object)
    ' print "LoginScreen.brs: - passwordKeyboardText"

    m.passwordBox.text = event.getData()
    m.passwordBox.cursorPosition = m.passwordBox.text.Len()
end sub