;==================================================================================================
; AHK setting
#NoEnv
SetBatchLines -1
SetTitleMatchMode 2
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
;==================================================================================================
; Globle values
wintitle := Minecraft X-AHK V0.4
targettitle := none
targetwinclass := GLFW30 ;This is the Class of a Java program used to check we have a Minecraft prog
ModeText := Empty
id := 0

ProgState := 0
;===================================================================================================
;List of ProgState's
;
; 0: Start			- Program called for first time and setting default state. Hotkeys set, menu
;						configured and default welcome GUI
; 1: Selected		- User has selected the target window to send key/mouse activity too
;						will use option Menu to slect mode. Note that JumpFlying is only
;						avalible while in this state!
; 2: FishingMode	- Enter Fishing Mode
; 3: KillingMode	- Enter Killing Mode
; 4: ConcreteMode	- Enter Concrete Mode
; 5: MobGrindMode	- Enter Mob Grinder Mode

;===================================================================================================
;Shortcuts
;===================================================================================================
Hotkey	!^f,	Fishing			; Pressing ctrl + alt + f will start fishing
Hotkey	!^k,	MobKill			; Pressing ctrl + alt + k will start killing
Hotkey  !^e,	JumpFly			; Pressing ctrl + alt + e will dubble hit space and fire a rockct in
								; main hand
Hotkey  !^c,	Concrete		; Pressing ctrl + alt + c will start concrete farming
Hotkey  !^m,	MobGrind		; Pressing ctrl + alt + m will start mob grinding
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
Menu, OptionsMenu, Add, MobKill, MenuMobKill
Menu, OptionsMenu, Add, AFK Mob, MenuAFK
Menu, OptionsMenu, Add, Concrete, MenuConcrete
Menu, OptionsMenu, Add, JumpFlying, MenuJumpFly
Menu, ClickerMenu, Add, File, :FileMenu
Menu, ClickerMenu, Add, Help, :HelpMenu
Menu, ClickerMenu, Add, Options, :OptionsMenu

;===================================================================================================
;GUI-Default Welcome Screen
; Start screen asking user to select the target window to send keys to
;===================================================================================================
if %ProgState% != 0
	Return


Gui, Show, w300 h300, Shortcuts
if FileExist("welcomepic.png") {
	Gui, Add, Pic, w280 h290 vpic_get, welcomepic.png
 }
 else{
	Gui, Add, Text,, Select Minecraft Window and press Ctrl+Alt+W
 }
Gui, Add, Text,, %SplashPic%
Gui, Show,, Minecraft X-AHK V0.4
return
;===================================================================================================
; Called when Ctrl+Alt+W is pressed and captures target window information, checks its a java prog
;and then creates the first window.
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
		Gui, Add, Text,, To change mode of opperation please select from Option menu.
		Gui, Add, Text,, MODE:
		Gui, Add, Text, vMode w30, None
		Gui, Show,, Minecraft X-AHK V0.4
		;clear mouse clicks to target by sending UP to the keys
		ControlClick, , ahk_id %id%, ,Right, , NAU
		ControlClick, , ahk_id %id%, ,Left, ,NAU
		sleep 500
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
; Place holder - will allow users to load saved values
;===================================================================================================
MenuFileOpen:
{
	ModeText := JumpFlying
	GuiControl,,Mode, %ModeText%
	Return
}
;===================================================================================================
MenuHandler:
{
	ExitApp
	Return
}
;===================================================================================================
; Switch to Fishing mode and update window
MenuFishing:
{
	; Stop and current active AHK process
	BreakLoop := 1

		Gui, Destroy
		Gui, Show, w500 h500, Temp
		Gui, Menu, ClickerMenu
		Gui, Add, Text,, Target Window Title : %targettitle%
		Gui, Add, Text,, Windows HWIND is : %id%
		Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
		Gui, Add, Text,, o- Pressing ctrl + alt + f will start fishing
		Gui, Add, Text,, o- Pressing ctrl + alt + s will stop any AutoKey funtion above
		Gui, Add, Text,,
		Gui, Add, Slider, vMySlider w200 ToolTip Range0-1000 TickInterval100, 500
		Gui, Show,, Minecraft X-AHK V0.4

	ProgState := 2
	Return
}
;===================================================================================================
; Switch to MobKill mode and update window
MenuMobKill:
{
	; Stop and current active AHK process
	BreakLoop := 1

		Gui, Destroy
		Gui, Show, w500 h500, Temp
		Gui, Menu, ClickerMenu
		Gui, Add, Text,, Target Window Title : %targettitle%
		Gui, Add, Text,, Windows HWIND is : %id%
		Gui, Add, Text,, With MobKill active, your mouse will simulate a left click every 1.5 seconds.
		Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
		Gui, Add, Text,, Pressing ctrl + alt + k will start Mob Kill
		Gui, Add, Text,, Pressing ctrl + alt + s will stop any AutoKey funtion above
		Gui, Add, Text,,
		Gui, Show,, Minecraft X-AHK V0.4

	ProgState := 3
	Return
}
;===================================================================================================
; Switch to AFK mode and update window
MenuAFK:
{
	; Stop and current active AHK process
	BreakLoop := 1

	Gui, Destroy
	Gui, Show, w500 h500, Temp
	Gui, Menu, ClickerMenu
	Gui, Add, Text,, Target Window Title : %targettitle%
	Gui, Add, Text,, Windows HWIND is : %id%
	Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
	Gui, Add, Text,, o- Pressing ctrl + alt + m will start Mod Grinding
	Gui, Add, Text,, o- Pressing ctrl + alt + s will stop any AutoKey funtion above
	Gui, Show,, Minecraft X-AHK V0.4

	ProgState := 5
	Return
}
;===================================================================================================
; Switch to Concrete mode and update window
MenuConcrete:
{
	; Stop and current active AHK process
	BreakLoop := 1

	Gui, Destroy
	Gui, Show, w500 h500, Temp
	Gui, Menu, ClickerMenu
	Gui, Add, Text,, Target Window Title : %targettitle%
	Gui, Add, Text,, Windows HWIND is : %id%
	Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
	Gui, Add, Text,, o- Pressing ctrl + alt + c will start concrete farming
	Gui, Add, Text,, o- Pressing ctrl + alt + s will stop any AutoKey funtion above
	Gui, Show,, Minecraft X-AHK V0.4

	ProgState := 4
	Return
}
;===================================================================================================
; Switch to Flying mode and update window
MenuJumpFly:
{
	; Stop and current active AHK process
	BreakLoop := 1

	Gui, Destroy
	Gui, Show, w500 h500, Temp
	Gui, Menu, ClickerMenu
	Gui, Add, Text,, Target Window Title : %targettitle%
	Gui, Add, Text,, Windows HWIND is : %id%
	Gui, Add, Text,, CURRENT AVALIBLE OPTIONS:
	Gui, Add, Text,, o- Pressing ctrl + alt + e will dubble hit space and fire a rocket in main hand
	Gui, Show,, Minecraft X-AHK V0.4

	ProgState := 1
	Return
}
;===================================================================================================
; Called when Ctrl+Alt+E is pressed.
; NOTE: Target window MUST be in focus for this to work
JumpFly:
{
	if (ProgState != 1)
		Return

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
; Called when Ctrl+Alt+C is pressed. Hold both RIGHT and LEFT click down.
Concrete:
{
	if (ProgState != 4)
		Return

	BreakLoop := 0

	ControlClick, , ahk_id %id%, ,Right, , NAD
	Sleep 500
	ControlClick, , ahk_id %id%, ,Left, , NAD
	sleep 100
	While (BreakLoop = 0)
	{
		if BreakLoop = 1)
		{
			sleep 10
		}
	}
	ControlClick, , ahk_id %id%, ,Left, , NAU
	Sleep 100
	ControlClick, , ahk_id %id%, ,Right, , NAU
	Return
}
;===================================================================================================
; Called when Ctrl+Alt+F is pressed and continuly clicks RIGHT mouse key
Fishing:
{
	if (ProgState != 2)
		Return

	BreakLoop := 0
		Loop
		{
			if (BreakLoop = 1)
			{
				BreakLoop := 0
				break
			}

			Sleep 100
				ControlClick, , ahk_id %id%, ,Right, , NAD
			Sleep 500
				ControlClick, , ahk_id %id%, ,Right, , NAU
		}
	Return
}
;===================================================================================================
; Called when Ctrl+Alt+K is pressed and continuly clicks Left mouse key
MobKill:
{
	if (ProgState != 3)
		Return

	BreakLoop := 0
		Loop
		{
			if (BreakLoop = 1)
			{
				BreakLoop := 0
				break
			}

			Sleep 1500
				ControlClick, , ahk_id %id%, ,Left, , NAD
			Sleep 1500
				ControlClick, , ahk_id %id%, ,Left, , NAU
		}
	Return
}
;==================================================================================================
; Called when Ctrl+Alt+M is pressed
MobGrind:
{
	if (ProgState != 5)
		Return

	BreakLoop := 0
	Delay := 0
	Sleep 500
	While (BreakLoop = 0)
	{
		;on each loop send RIGHT key down as it can be lost when switching focus
		ControlClick, , ahk_id %id%, ,Right, , NAD

		if (BreakLoop = 1)
		{
			; On Ctrl+Alt+S detected forces a RIGHT mouse key UP
			ControlClick, , ahk_id %id%, ,Right, , NAU
			Return
		}

		Sleep 100 ;100 ms
		;Delay between LEFT clicks is controled by sleep delay above * value tested here (ie 12)
		; Example = 100ms * 12 = 1.2 seconds
		;This method allows AHK to better exit this mode and respond quicker to Stop command
		if (Delay >= 12)
		{
			; If delay counter reached, reset counter and send a LEFT click
			Delay := 0
			sleep 50
			ControlClick, , ahk_id %id%, ,Left, ,NAD
			Sleep 50
			ControlClick, , ahk_id %id%, ,Left, ,NAU
		}
		else
			Delay++ ;Increase delay counter by 1

	}
	Sleep 100
	;Force mouse keys UP at exit
	ControlClick, , ahk_id %id%, ,Right, , NAU
	ControlClick, , ahk_id %id%, ,Left, ,NAU
	Return
}
;==================================================================================================
; Called when Ctrl+Alt+S is pressed at ANYTIME
; By setting the globle value of 'BreakLoop' to 1 this causes any running mode to exit under its own
;control without leaving key states in correctly. Due to Mouse loss of focus STOP will also force
;mouse keys UP.
Stop:
{
	BreakLoop := 1
	ControlClick, , ahk_id %id%, ,Right, , NAU
	ControlClick, , ahk_id %id%, ,Left, ,NAU
	sleep 500
	return
}

;===================================================================================================
ESC:
GuiClose:
GuiEscape:
ExitApp