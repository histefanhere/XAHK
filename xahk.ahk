;==================================================================================================

#NoEnv

SetBatchLines -1
SetTitleMatchMode 2
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

wintitle = Minecraft X-AHK V0.1
targettitle = none
targetwinclass = GLFW30
id = 0

ProgState = 0
;===================================================================================================
;List of ProgState's
;
; 0: Start         - Program called for first time and setting default state. Hotkeys set, menu
;                    configured and default welcome GUI
; 1: Selected      - User has selected the target window to send key/mouse activity too


;===================================================================================================
;Shortcuts
;===================================================================================================
Hotkey	!^f,	Fishing			; Pressing ctrl + alt + f will start fishing
Hotkey  !^e,	JumpFly			; Pressing ctrl + alt + e will dubble hit space and fire a rockct in
								; main hand
Hotkey  !^c,	Concrete		; Pressing ctrl + alt + c will start concrete farming
Hotkey	!^s,	Stop			; Pressing ctrl + alt + s will stop it
Hotkey  !^w,    SelectWindow 	;Allows user to select window to control by hovering mouse over it and
								;Pressing ctrl + alt + w

;===================================================================================================
;Menu
;===================================================================================================
Menu, FileMenu, Add, Open, MenuFileOpen
Menu, FileMenu, Add, Exit, MenuHandler
Menu, HelpMenu, Add, About, MenuHandler
Menu, OptionsMenu, Add, Fishing, MenuFishing
Menu, OptionsMenu, Add, AFK Mob, MenuAFK
Menu, OptionsMenu, Add, Concrete, MenuConcrete
Menu, ClickerMenu, Add, File, :FileMenu
Menu, ClickerMenu, Add, Help, :HelpMenu
Menu, ClickerMenu, Add, Options, :OptionsMenu

;===================================================================================================
;GUI-Default Welcome Screen
;===================================================================================================
if %ProgState% != 0
	Return
	
Gui, Show, w300 h300, Shortcuts
;Gui, Add, Button, x10 y10 w100 gFishing, % "Fishing farm"
;Gui, Add, Button, yp+40 w100 gStop, % "Stop"
Gui, Add, Pic, w280 h290 vpic_get, welcomepic.png
Gui, Show,, Minecraft X-AHK V0.1
return
;===================================================================================================
SelectWindow:
{
	;Get mouse pos on screen and grab details of program
	MouseGetPos, , , id, control
	WinGetTitle, targettitle, ahk_id %id%
	WinGetClass, targetclass, ahk_id %id%
	;MsgBox, ahk_id %id%`nahk_class %targetclass%`n%targettitle%`nControl: %control%
	
	;Check is Class of program is a Minecraft Java Class
	if InStr(targetclass, targetwinclass)
	{
		;Target window found, swop to next screen
		ProgState = 1
		Gui, Destroy
		Gui, Show, w500 h500, Temp
		Gui, Menu, ClickerMenu
		Gui, Add, Text,, Target Window Title : %targettitle%
		Gui, Add, Text,, Windows HWIND is : %id%
		Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
		Gui, Add, Text,, o- Pressing ctrl + alt + f will start fishing
		Gui, Add, Text,, o- Pressing ctrl + alt + c will start concrete farming *See below!
		Gui, Add, Text,, o- Pressing ctrl + alt + s will stop any AutoKey funtion above
		Gui, Add, Text,, o- Pressing ctrl + alt + e will dubble hit space and fire a rocket in main hand
		Gui, Add, Text,, NOTES:
		Gui, Add, Text,, .... To use the Auto Concrete first set yourself up inminecraft and point
		Gui, Add, Text,, crosshairs at a block to break (holding pick) with more powder in your off hand.
		Gui, Add, Text,, Alt-Tab away from the screen BEFORE pressing Ctrl + Alt + called
		Gui, Show,, Minecraft X-AHK V0.1
	}
	Else
	{
		;Class of target program not a match so give warning message
		MsgBox, You do not seam to have selected a Minecraft window. Please check before you continue.
	}
	Return
}
;===================================================================================================
;Menu Functions
;===================================================================================================
MenuFileOpen:
{
	Return
}
;===================================================================================================
MenuHandler:
{
	Return
}
;===================================================================================================
MenuFishing:
{
	Return
}
;===================================================================================================
MenuAFK:
{
	Return
}
;===================================================================================================
MenuConcrete:
{
	Return
}
;===================================================================================================
JumpFly:
{
	Sleep 500
	Send {Space down}
	Sleep 75
	Send {Space up}
	Sleep 200
	Send {Space down}
	Sleep 75
	Send {Space up}
	Sleep 50
	ControlClick, , ahk_id %id%, ,Right, , NAD
	Sleep 100
	ControlClick, , ahk_id %id%, ,Right, , NAU
	Return
}
;===================================================================================================
Concrete:
{
	if (ProgState !=)
		Return
		
	BreakLoop = 0
	
	ControlClick, , ahk_id %id%, ,Right, , NAD
	Sleep 500
	ControlClick, , ahk_id %id%, ,Left, , NAD
	sleep 100
	While (BreakLoop = 0)
	{
		if BreakLoop = 1)
		{
			BreakLoop = 0
		}
	}
	ControlClick, , ahk_id %id%, ,Left, , NAU
	Sleep 100
	ControlClick, , ahk_id %id%, ,Right, , NAU
	Return
}
;===================================================================================================
Fishing:
{
	if (ProgState != 1)
		Return

	BreakLoop = 0
		Loop
		{
			if (BreakLoop = 1)
			{
				BreakLoop = 0
				break
			}

			Sleep 100
				ControlClick, , ahk_id %id%, ,Right, , NAD
			Sleep 500
				ControlClick, , ahk_id %id%, ,Right, , NAU
		}
	Return
}

;==================================================================================================
Stop:
BreakLoop = 1
return

;===================================================================================================
ESC:
GuiClose:
GuiEscape:
ExitApp