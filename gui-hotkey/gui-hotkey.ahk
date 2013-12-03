#NoEnv
#SingleInstance force
#KeyHistory 0
ListLines, Off

;---------------------------------------
strIniFilename := A_ScriptDir . "\gui-hotkey.ini"
strMouseButtons := " |LButton|MButton|RButton|XButton1|XButton2|WheelUp|WheelDown|WheelLeft|WheelRight|" ; leave last | to enable default value

;---------------------------------------
; Ini key names, matching hotkey variables names and default values for hotkeys
strIniKeyNames := "PopupHotkey|NewExplorerHotkey|SettingsHotkey"
StringSplit, arrIniKeyNames, strIniKeyNames, |
strHotkeyVarNames := "strHotkeyPopup|strHotkeyNewExplorer|strHotkeySettings"
StringSplit, arrHotkeyVarNames, strHotkeyVarNames, |
strHotkeyDefaults := "MButton|+MButton|^#f"
StringSplit, arrHotkeyDefaults, strHotkeyDefaults, |

;---------------------------------------
; Gui hotkey titles and descriptions
strTitles := "Folders Popup|New Explorer|Settings"
StringSplit, arrTitles, strTitles, |
strDescriptions1 := "Choose the hotkey or mouse button combination that will open the folders popup menu in Windows Explorer or file dialog boxes. By default, this is the middle mouse button (MButton) without any modifier key."
strDescriptions2 := "Choose the hotkey or mouse button combination that will open the folders popup menu over any window and navigate to the selected folder in a new Windows Explorer window."
strDescriptions3 := "Choose the hotkey or mouse button combination that will open the Folders Popup setting dialog box. By default, this is Control+Windows+F."
; Need more hotkey? Add it above...

;---------------------------------------
; Build Gui header
Gui, Font, s8 w700
Gui, Add, Text, x5 y10, GUI-HOTKEY Demo
Gui, Font
; Build Hotkey gui lines
loop, % arrIniKeyNames%0%
{
	; Read the first hotkey in the ini file
	IniRead, arrHotkeyVarNames%A_Index%, %strIniFilename%, Global, % arrIniKeyNames%A_Index%, % arrHotkeyDefaults%A_Index%
	; Prepare global arrays used by GuiHotkey function
	SplitHotkey(arrHotkeyVarNames%A_Index%, strMouseButtons
		, strModifiers%A_Index%, strKey%A_Index%, strMouseButton%A_Index%, strMouseButtonsWithDefault%A_Index%)
	; Code it
	GuiHotkey(A_Index)
}
;---------------------------------------
; Gui footer
Gui, Add, Button, y+10 x5 vbtnSave gButtonSave, Save
GuiControl, Focus, btnSave

;---------------------------------------
; Show until user click Save
Gui, Show
return
; End of script startup
;---------------------------------------



;---------------------------------------
GuiHotkey(intIndex)
;---------------------------------------
{
	global

	; Hotkey Header
	Gui, Add, Text, y+20 x98 w25 center, Shift
	Gui, Add, Text, yp x+11 w25 center, Ctrl
	Gui, Add, Text, yp x+10 w25 center, Alt
	Gui, Add, Text, yp x+10 w25 center, Win
	Gui, Add, Text, yp x+10 w100 center, Keyboard
	Gui, Add, Text, yp x+30 w80 center, Mouse

	Gui, Font, s8 w700
	Gui, Add, Text, x5 y+5 w90 right, % arrTitles%intIndex%
	Gui, Font
	Gui, Add, CheckBox, yp x+10 vblnShift%intIndex%, %A_Space%
		; if we have no text to put at the right of the ckeckbox
		; would it be possible to eliminate the dotted area ?
		; intIndex put a space becauyse this is what intIndex found the less visible.
	GuiControl, , blnShift%intIndex%, % InStr(strModifiers%intIndex%, "+") ? 1 : 0
	Gui, Add, CheckBox, yp x+10 vblnCtrl%intIndex%, %A_Space%
	GuiControl, , blnCtrl%intIndex%, % InStr(strModifiers%intIndex%, "^") ? 1 : 0
	Gui, Add, CheckBox, yp x+10 vblnAlt%intIndex%, %A_Space%
	GuiControl, , blnAlt%intIndex%, % InStr(strModifiers%intIndex%, "!") ? 1 : 0
	Gui, Add, CheckBox, yp x+10 vblnWin%intIndex%, %A_Space%
	GuiControl, , blnWin%intIndex%, % InStr(strModifiers%intIndex%, "#") ? 1 : 0
	Gui, Add, Hotkey, yp x+10 w100 vstrKey%intIndex% gHotkeyChanged
	GuiControl, , strKey%intIndex%, % strKey%intIndex%
	Gui, Add, Text, yp x+5, %A_Space%%A_Space%or
	Gui, Add, DropDownList, yp x+10 w80 vstrMouse%intIndex% gMouseChanged, % strMouseButtonsWithDefault%intIndex%
	Gui, Add, Text, x5 y+5 w440, % arrDescriptions%intIndex%
}
;---------------------------------------



;---------------------------------------
ButtonSave:
;---------------------------------------
Gui, Submit

strIniVarNames := "PopupHotkey|NewExplorerHotkey|SettingsHotkey"
StringSplit, arrIniVarNames, strIniVarNames, |

Loop, % arrIniVarNames%0%
{
	strHotkey%A_Index% := Trim(strKey%A_Index% . strMouse%A_Index%)
	if StrLen(strHotkey%A_Index%)
	{
		if (blnCtrl%A_Index%)
			strHotkey%A_Index% := "^" . strHotkey%A_Index%
		if (blnShift%A_Index%)
			strHotkey%A_Index% := "+" . strHotkey%A_Index%
		if (blnAlt%A_Index%)
			strHotkey%A_Index% := "!" . strHotkey%A_Index%
		if (blnWin%A_Index%)
			strHotkey%A_Index% := "#" . strHotkey%A_Index%
		IniWrite, % strHotkey%A_Index%, %strIniFilename%, Global, % arrIniVarNames%A_Index%
	}
}
ExitApp
return
;---------------------------------------



;---------------------------------------
HotkeyChanged:
;---------------------------------------
strHotkeyControl := A_GuiControl ; hotkey var name
strHotkey := %strHotkeyControl% ; hotkey content

if !StrLen(strHotkey)
	return

SplitModifiersFromKey(strHotkey, strModifiers, strKey)

if StrLen(strModifiers) ; we have a modifier and we dont want it, reset keyboard to none and return
	GuiControl, , %A_GuiControl%, None
else ; we have a valid key, empty the mouse dropdown and return
{
	StringReplace, strMouseControl, strHotkeyControl, Key, Mouse ; get the matching mouse dropdown var
	GuiControl, ChooseString, %strMouseControl%, %A_Space%
}
return
;---------------------------------------



;---------------------------------------
MouseChanged:
;---------------------------------------
strMouseControl := A_GuiControl ; mouse dropdown var name
StringReplace, strHotkeyControl, strMouseControl, Mouse, Key ; get the hotkey var
; we have a mouse button, empty the hotkey control
GuiControl, , %strHotkeyControl%, % ""
return
;---------------------------------------



;---------------------------------------
SplitHotkey(strHotkey, strMouseButtons, ByRef strModifiers, ByRef strKey, ByRef strMouseButton, ByRef strMouseButtonsWithDefault)
;---------------------------------------
{
	SplitModifiersFromKey(strHotkey, strModifiers, strKey)

	if InStr(strMouseButtons . "|", "|" . strKey . "|") ;  we have a mouse button
	{
		strMouseButton := strKey
		strKey := ""
		StringReplace, strMouseButtonsWithDefault, strMouseButtons, %strMouseButton%|, %strMouseButton%|| ; with default value
	}
	else ; we have a key
		strMouseButtonsWithDefault := strMouseButtons ; no default value
}
;---------------------------------------



;---------------------------------------
SplitModifiersFromKey(strHotkey, ByRef strModifiers, ByRef strKey)
;---------------------------------------
{
	intModifiersEnd := GetFirstNotModifier(strHotkey)
	StringLeft, strModifiers, strHotkey, %intModifiersEnd%
	StringMid, strKey, strHotkey, % (intModifiersEnd + 1)
}
;---------------------------------------



;---------------------------------------
GetFirstNotModifier(strHotkey)
;---------------------------------------
{
	intPos := 0
	loop, Parse, strHotkey
		if (A_LoopField = "^") or (A_LoopField = "!") or (A_LoopField = "+") or (A_LoopField = "#")
			intPos := intPos + 1
		else
			return intPos
	return intPos
}
;---------------------------------------
