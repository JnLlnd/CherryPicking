-------------------------------------------------------------------------------------------------------
Source: jaco0646 (http://www.autohotkey.com/board/topic/47439-user-defined-dynamic-hotkeys/) 
-------------------------------------------------------------------------------------------------------
EXAMPLE 1
-------------------------------------------------------------------------------------------------------

#SingleInstance force
#NoEnv
SetBatchLines, -1

Gui, Add, Hotkey,   vHK gLabel     ;add a hotkey control
Gui, Add, CheckBox, vCB x+5, Win   ;add a checkbox to allow the Windows key (#) as a modifier.
Gui, Show,,Dynamic Hotkeys
return
GuiClose:
 ExitApp

Label:
 If HK in +,^,!,+^,+!,^!,+^!            ;If the hotkey contains only modifiers, return to wait for a key.
  return
 If (savedHK) {                         ;If a hotkey was already saved...
  Hotkey, %savedHK%, Label1, Off        ;     turn the old hotkey off
  savedHK .= " OFF"                     ;     add the word 'OFF' to display in a message.
 }
 If (HK = "") {                         ;If the new hotkey is blank...
  TrayTip, Label1, %savedHK%, 5         ;     show a message: the old hotkey is OFF
  savedHK =                             ;     save the hotkey (which is now blank) for future reference.
  return                                ;This allows an old hotkey to be disabled without enabling a new one.
 }
 Gui, Submit, NoHide
 If CB                                  ;If the 'Win' box is checked, then add its modifier (#).
  HK := "#" HK
 If StrLen(HK) = 1                      ;If the new hotkey is only 1 character, then add the (~) modifier.
  HK := "~" HK                          ;     This prevents any key from being blocked.
 Hotkey, %HK%, Label1, On               ;Turn on the new hotkey.
 TrayTip, Label1,% HK " ON`n" savedHK   ;Show a message: the new hotkey is ON.
 savedHK := HK                          ;Save the hotkey for future reference.
return

;This label may contain any commands for its hotkey to perform.
Label1:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return




-------------------------------------------------------------------------------------------------------
EXAMPLE 2
-------------------------------------------------------------------------------------------------------




#SingleInstance force
#NoEnv
SetBatchLines, -1

Loop,5 {
 Gui, Add, Text, xm, Enter Hotkey #%A_Index%:
 Gui, Add, Hotkey, x+5 vHK%A_Index% gLabel     ;add some hotkey controls
 Gui, Add, CheckBox, x+5 vCB%A_Index%, Win     ;add checkboxes to allow the Windows key (#) as a modifier.
}
Gui, Show,,Dynamic Hotkeys
return
GuiClose:
 ExitApp

Label:
 If %A_GuiControl% in +,^,!,+^,+!,^!,+^!     ;If the hotkey contains only modifiers, then return to wait for a key.
  return
 num := SubStr(A_GuiControl,3)               ;Get the number of the hotkey control.  
 If (savedHK%num%) {                         ;If a hotkey was already saved in this control...
  Hotkey,% savedHK%num%, Label%num%, Off     ;     turn the old hotkey off
  savedHK%num% .= " OFF"                     ;     add the word 'OFF' to display in a message.
 }
 If (%A_GuiControl% = "") {                  ;If the new hotkey is blank...
  TrayTip, Label%num%,% savedHK%num%, 5      ;     show a message: the old hotkey is OFF
  savedHK%num% =                             ;     save the hotkey (which is now blank) for future reference.
  return                                     ;This allows an old hotkey to be disabled without enabling a new one.
 }
 Gui, Submit, NoHide
 If CB%num%                                  ;If the 'Win' box is checked, then add its modifier (#).
  %A_GuiControl% := "#" %A_GuiControl%
 If StrLen(%A_GuiControl%) = 1               ;If the new hotkey is only 1 character, then add the (~) modifier.
  %A_GuiControl% := "~" %A_GuiControl%       ;     This prevents any key from being blocked.
 Hotkey,% %A_GuiControl%, Label%num%, On     ;Turn on the new hotkey.
 TrayTip, Label%num%
  ,% %A_GuiControl% " ON`n" savedHK%num%, 5  ;Show a message: the new hotkey is ON.
 savedHK%num% := %A_GuiControl%              ;Save the hotkey for future reference.
return

;These labels may contain any commands for their respective hotkeys to perform.
Label1:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label2:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label3:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label4:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label5:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return




-------------------------------------------------------------------------------------------------------
EXAMPLE 3
-------------------------------------------------------------------------------------------------------




#SingleInstance force
#NoEnv
SetBatchLines, -1

#ctrls = 5  ;How many Hotkey controls to add.
Loop,% #ctrls {
 Gui, Add, Text, xm, Enter Hotkey #%A_Index%:
 IniRead, savedHK%A_Index%, Hotkeys.ini, Hotkeys, %A_Index%, %A_Space%
 If savedHK%A_Index%                                       ;Check for saved hotkeys in INI file.
  Hotkey,% savedHK%A_Index%, Label%A_Index%                 ;Activate saved hotkeys if found.
 StringReplace, noMods, savedHK%A_Index%, ~                  ;Remove tilde (~) and Win (#) modifiers...
 StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
 Gui, Add, Hotkey, x+5 vHK%A_Index% gLabel, %noMods%           ;Add hotkey controls and show saved hotkeys.
 Gui, Add, CheckBox, x+5 vCB%A_Index% Checked%ErrorLevel%, Win  ;Add checkboxes to allow the Windows key (#) as a modifier...
}                                                                ;Check the box if Win modifier is used.
Gui, Show,,Dynamic Hotkeys
return
GuiClose:
 ExitApp

Label:
 If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
  return
 num := SubStr(A_GuiControl,3)              ;Get the index number of the hotkey control.
 If (HK%num% != "") {                       ;If the hotkey is not blank...
  Gui, Submit, NoHide
  If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
   HK%num% := "#" HK%num%
  If !RegExMatch(HK%num%,"[#!\^\+]")        ;  If the new hotkey has no modifiers, add the (~) modifier.
   HK%num% := "~" HK%num%                   ;    This prevents any key from being blocked.
  Loop,% #ctrls
   If (HK%num% = savedHK%A_Index%) {        ;  Check for duplicate hotkey...
    dup := A_Index
    Loop,6 {
     GuiControl,% "Disable" b:=!b, HK%dup%  ;    Flash the original hotkey to alert the user.
     Sleep,200
    }
    GuiControl,,HK%num%,% HK%num% :=""      ;    Delete the hotkey and clear the control.
    break
   }
 }
 If (savedHK%num% || HK%num%)
  setHK(num, savedHK%num%, HK%num%)
return

setHK(num,INI,GUI) {
 If INI
  Hotkey, %INI%, Label%num%, Off
 If GUI
  Hotkey, %GUI%, Label%num%, On
 IniWrite,% GUI ? GUI:null, Hotkeys.ini, Hotkeys, %num%
 savedHK%num%  := HK%num%
 TrayTip, Label%num%,% !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF"
}

;These labels may contain any commands for their respective hotkeys to perform.
Label1:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label2:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label3:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label4:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label5:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return




-------------------------------------------------------------------------------------------------------
EXAMPLE 4
-------------------------------------------------------------------------------------------------------




#SingleInstance force
#NoEnv
SetBatchLines, -1

#ctrls = 5  ;How many Hotkey controls to add?
Loop,% #ctrls {
 Gui, Add, Text, xm, Enter Hotkey #%A_Index%:
 IniRead, savedHK%A_Index%, Hotkeys.ini, Hotkeys, %A_Index%, %A_Space%
 If savedHK%A_Index%                                       ;Check for saved hotkeys in INI file.
  Hotkey,% savedHK%A_Index%, Label%A_Index%                 ;Activate saved hotkeys if found.
 StringReplace, noMods, savedHK%A_Index%, ~                  ;Remove tilde (~) and Win (#) modifiers...
 StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
 Gui, Add, Hotkey, x+5 vHK%A_Index% gGuiLabel, %noMods%        ;Add hotkey controls and show saved hotkeys.
 Gui, Add, CheckBox, x+5 vCB%A_Index% Checked%ErrorLevel%, Win  ;Add checkboxes to allow the Windows key (#) as a modifier...
}                                                                ;Check the box if Win modifier is used.
Gui, Show,,Dynamic Hotkeys
return
GuiClose:
 ExitApp

GuiLabel:
 If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
  return
 If InStr(%A_GuiControl%,"vk07")            ;vk07 = MenuMaskKey (see below)
  GuiControl,,%A_GuiControl%, % lastHK      ;Reshow the hotkey, because MenuMaskKey clears it.
 Else
  validateHK(A_GuiControl)
return

validateHK(GuiControl) {
 global lastHK
 Gui, Submit, NoHide
 lastHK := %GuiControl%                     ;Backup the hotkey, in case it needs to be reshown.
 num := SubStr(GuiControl,3)                ;Get the index number of the hotkey control.
 If (HK%num% != "") {                       ;If the hotkey is not blank...
  StringReplace, HK%num%, HK%num%, SC15D, AppsKey      ;Use friendlier names,
  StringReplace, HK%num%, HK%num%, SC154, PrintScreen  ;  instead of these scan codes.
  If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
   HK%num% := "#" HK%num%
  If !RegExMatch(HK%num%,"[#!\^\+]")        ;  If the new hotkey has no modifiers, add the (~) modifier.
   HK%num% := "~" HK%num%                   ;    This prevents any key from being blocked.
  checkDuplicateHK(num)
 }
 If (savedHK%num% || HK%num%)               ;Unless both are empty,
  setHK(num, savedHK%num%, HK%num%)         ;  update INI/GUI
}

checkDuplicateHK(num) {
 global #ctrls
 Loop,% #ctrls
  If (HK%num% = savedHK%A_Index%) {
   dup := A_Index
   Loop,6 {
    GuiControl,% "Disable" b:=!b, HK%dup%   ;Flash the original hotkey to alert the user.
    Sleep,200
   }
   GuiControl,,HK%num%,% HK%num% :=""       ;Delete the hotkey and clear the control.
   break
  }
}

setHK(num,INI,GUI) {
 If INI                           ;If previous hotkey exists,
  Hotkey, %INI%, Label%num%, Off  ;  disable it.
 If GUI                           ;If new hotkey exists,
  Hotkey, %GUI%, Label%num%, On   ;  enable it.
 IniWrite,% GUI ? GUI:null, Hotkeys.ini, Hotkeys, %num%
 savedHK%num%  := HK%num%
 TrayTip, Label%num%,% !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF"
}

#MenuMaskKey vk07                 ;Requires AHK_L 38+
#If ctrl := HotkeyCtrlHasFocus()
 *AppsKey::                       ;Add support for these special keys,
 *BackSpace::                     ;  which the hotkey control does not normally allow.
 *Delete::
 *Enter::
 *Escape::
 *Pause::
 *PrintScreen::
 *Space::
 *Tab::
  modifier := ""
  If GetKeyState("Shift","P")
   modifier .= "+"
  If GetKeyState("Ctrl","P")
   modifier .= "^"
  If GetKeyState("Alt","P")
   modifier .= "!"
  Gui, Submit, NoHide             ;If BackSpace is the first key press, Gui has never been submitted.
  If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)   ;If the control has text but no modifiers held,
   GuiControl,,%ctrl%                                       ;  allow BackSpace to clear that text.
  Else                                                     ;Otherwise,
   GuiControl,,%ctrl%, % modifier SubStr(A_ThisHotkey,2)  ;  show the hotkey.
  validateHK(ctrl)
 return
#If

HotkeyCtrlHasFocus() {
 GuiControlGet, ctrl, Focus       ;ClassNN
 If InStr(ctrl,"hotkey") {
  GuiControlGet, ctrl, FocusV     ;Associated variable
  Return, ctrl
 }
}

;These labels may contain any commands for their respective hotkeys to perform.
Label1:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label2:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label3:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label4:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return

Label5:
 MsgBox,% A_ThisLabel "`n" A_ThisHotkey
return