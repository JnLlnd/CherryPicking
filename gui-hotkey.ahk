#NoEnv
#SingleInstance force
#KeyHistory 0
ListLines, Off

strIniFilename := A_ScriptDir . "\gui-hotkey.ini"
IniRead, strHotkeyPopup, %strIniFilename%, Global, PopupHotkey, MButton
IniRead, strHotkeyNewExplorer, %strIniFilename%, Global, NewExplorerHotkey, +MButton
IniRead, strHotkeySettings, %strIniFilename%, Global, SettingsHotkey, ^#f

strMouseButtons := " |LButton|RButton|MButton|XButton1|XButton2|WheelUp|WheelDown|WheelLeft|WheelRight|" ; leave last | to enable default value

Gui, Font, s8 w700
Gui, Add, Text, x5 y10, GUI-HOTKEY Demo
Gui, Font

Gosub, HotkeyHeader
SplitModifierHotkey(strHotkeyPopup, strModifiers, strKey)
if InStr(strMouseButtons . "|", "|" . strKey . "|") ;  we have a mouse button
{
	strMouseButton := strKey
	strKey := ""
	StringReplace, strMouseButtonsWithDefault, strMouseButtons, %strMouseButton%|, %strMouseButton%|| ; default value
}
else ; we have a key
	strMouseButtonsWithDefault := strMouseButtons ; no default value

Gui, Font, s8 w700
Gui, Add, Text, x5 y+5 w90 right, Folders Popup
Gui, Font
Gui, Add, CheckBox, yp x+10 vblnShift1, %A_Space%
	; if we have no text to put at the right of the ckeckbox
	; would it be possible to eliminate the dotted area ?
	; I put a space becauyse this is what I found the less visible.
GuiControl, , blnShift1, % InStr(strModifiers, "+") ? 1 : 0
Gui, Add, CheckBox, yp x+10 vblnCtrl1, %A_Space%
GuiControl, , blnCtrl1, % InStr(strModifiers, "^") ? 1 : 0
Gui, Add, CheckBox, yp x+10 vblnAlt1, %A_Space%
GuiControl, , blnAlt1, % InStr(strModifiers, "!") ? 1 : 0
Gui, Add, CheckBox, yp x+10 vblnWin1, %A_Space%
GuiControl, , blnWin1, % InStr(strModifiers, "#") ? 1 : 0
Gui, Add, Hotkey, yp x+10 w100 vstrKey1 gHotkeyChanged
GuiControl, , strKey1, %strKey%
Gui, Add, Text, yp x+5, %A_Space%%A_Space%or
Gui, Add, DropDownList, yp x+10 w80 vstrMouse1 gMouseChanged, %strMouseButtonsWithDefault%
Gui, Add, Text, x5 y+5 w440, Choose the hotkey or mouse button combination that will open the folders popup menu in Windows Explorer or file dialog boxes. By default, this is the middle mouse button (MButton) without any modifier key.

Gosub, HotkeyHeader
SplitModifierHotkey(strHotkeyNewExplorer, strModifiers, strKey)
if InStr(strMouseButtons . "|", "|" . strKey . "|")
{
	strMouseButton := strKey
	strKey := ""
	StringReplace, strMouseButtonsWithDefault, strMouseButtons, %strMouseButton%|, %strMouseButton%||
}
else
	strMouseButtonsWithDefault := strMouseButtons

Gui, Font, s8 w700
Gui, Add, Text, x5 y+5 w90 right, New Explorer
Gui, Font
Gui, Add, CheckBox, yp x+10 vblnShift2, %A_Space%
GuiControl, , blnShift2, % InStr(strModifiers, "+") ? 1 : 0
Gui, Add, CheckBox, yp x+10 vblnCtrl2, %A_Space%
GuiControl, , blnCtrl2, % InStr(strModifiers, "^") ? 1 : 0
Gui, Add, CheckBox, yp x+10 vblnAlt2, %A_Space%
GuiControl, , blnAlt2, % InStr(strModifiers, "!") ? 1 : 0
Gui, Add, CheckBox, yp x+10 vblnWin2, %A_Space%
GuiControl, , blnWin2, % InStr(strModifiers, "#") ? 1 : 0
Gui, Add, Hotkey, yp x+10 w100 vstrKey2 gHotkeyChanged
GuiControl, , strKey2, % strKey
Gui, Add, Text, yp x+5, %A_Space%%A_Space%or
Gui, Add, DropDownList, yp x+10 w80 vstrMouse2 gMouseChanged, %strMouseButtonsWithDefault%
Gui, Add, Text, x5 y+5 w440, Choose the hotkey or mouse button combination that will open the folders popup menu over any window and navigate to the selected folder in a new Windows Explorer window.


Gosub, HotkeyHeader
SplitModifierHotkey(strHotkeySettings, strModifiers, strKey)
if InStr(strMouseButtons . "|", "|" . strKey . "|")
{
	strMouseButton := strKey
	strKey := ""
	StringReplace, strMouseButtonsWithDefault, strMouseButtons, %strMouseButton%|, %strMouseButton%||
}
else
	strMouseButtonsWithDefault := strMouseButtons

Gui, Font, s8 w700
Gui, Add, Text, x5 y+5 w90 right, Settings
Gui, Font
Gui, Add, CheckBox, yp x+10 vblnShift3, %A_Space%
GuiControl, , blnShift3, % InStr(strModifiers, "+") ? 1 : 0
Gui, Add, CheckBox, yp x+10 vblnCtrl3, %A_Space%
GuiControl, , blnCtrl3, % InStr(strModifiers, "^") ? 1 : 0
Gui, Add, CheckBox, yp x+10 vblnAlt3, %A_Space%
GuiControl, , blnAlt3, % InStr(strModifiers, "!") ? 1 : 0
Gui, Add, CheckBox, yp x+10 vblnWin3, %A_Space%
GuiControl, , blnWin3, % InStr(strModifiers, "#") ? 1 : 0
Gui, Add, Hotkey, yp x+10 w100 vstrKey3 gHotkeyChanged
GuiControl, , strKey3, % strKey
Gui, Add, Text, yp x+5, %A_Space%%A_Space%or
Gui, Add, DropDownList, yp x+10 w80 vstrMouse3 gMouseChanged, %strMouseButtonsWithDefault%
Gui, Add, Text, x5 y+5 w440, Choose the hotkey or mouse button combination that will open the Folders Popup setting dialog box. By default, this is Control+Windows+F.

Gui, Add, Button, y+10 x5 vbtnSave gButtonSave, Save
GuiControl, Focus, strKey1
Gui, Show
return



HotkeyHeader:
Gui, Add, Text, y+20 x98 w25 center, Shift
Gui, Add, Text, yp x+11 w25 center, Ctrl
Gui, Add, Text, yp x+10 w25 center, Alt
Gui, Add, Text, yp x+10 w25 center, Win
Gui, Add, Text, yp x+10 w100 center, Keyboard
Gui, Add, Text, yp x+30 w80 center, Mouse
return



ButtonSave:
Gui, Submit

strIniVarNames := "PopupHotkey|NewExplorerHotkey|SettingsHotkey"
StringSplit, arrIniVarNames, strIniVarNames, |

Loop, 3
{
	strHotkey%A_Index% := Trim(strKey%A_Index% . strMouse%A_Index%)
	if StrLen(strHotkey%A_Index% )
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



HotkeyChanged:

strHotkeyControl := A_GuiControl ; hotkey var name
strHotkey := %strHotkeyControl% ; hotkey content

if !StrLen(strHotkey)
	return

intModifiersEnd := GetFirstNotModifier(strHotkey)
StringLeft, strModifiers, strHotkey, %intModifiersEnd%
StringMid, strKey, strHotkey, % (intModifiersEnd + 1)

if StrLen(strModifiers) ; we have a modifier and we dont want it, reset keyboard to none
	GuiControl, , %A_GuiControl%, None
else ; we have a valid key, empty the mouse dropdown
{
	StringReplace, strMouseControl, strHotkeyControl, Key, Mouse ; get the matching mouse dropdown var
	GuiControl, ChooseString, %strMouseControl%, %A_Space%
}

return



MouseChanged:
strMouseControl := A_GuiControl ; mouse dropdown var name
StringReplace, strHotkeyControl, strMouseControl, Mouse, Key ; get the hotkey var
; we have mouse button, empty the hotkey control
GuiControl, , %strHotkeyControl%, % ""
return



SplitModifierHotkey(strHotkey, ByRef strModifiers, ByRef strKey)
{
	intModifiersEnd := GetFirstNotModifier(strHotkey)
	StringLeft, strModifiers, strHotkey, %intModifiersEnd%
	StringMid, strKey, strHotkey, % (intModifiersEnd + 1)
}



GetFirstNotModifier(strHotkey)
{
	intPos := 0
	loop, Parse, strHotkey
		if (A_LoopField = "^") or (A_LoopField = "!") or (A_LoopField = "+") or (A_LoopField = "#")
			intPos := intPos + 1
		else
			return intPos
	return intPos
}

