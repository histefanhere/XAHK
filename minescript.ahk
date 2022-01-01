; AHK settings
#NoEnv
SetBatchLines -1
SetTitleMatchMode 2
#SingleInstance Force
SetWorkingDir %A_ScriptDir%


; Global variables
wintitle := "Minescript v0.4"
targetwinclass := "GLFW30" ; This is the Class of a Java program used to check we have a Minecraft program
targettitle := ""
ModeText := ""
id := 0

ProgState := 0
; 0: Start			  - Program called for first time and setting default state. Hotkeys set, menu
;						configured and default welcome GUI
; 1: Selected		  - User has selected the target window to send key/mouse activity too
;						will use option Menu to slect mode. Note that JumpFlying is only
;						avalible while in this state!
; 2: FishingMode	  - Enter Fishing Mode
; 3: ConcreteMode	  - Enter Concrete Mode
; 4: MobGrindMode	  - Enter Mob Grinder Mode
; 5: KillingMode	  - Enter Killing Mode


; Hotkeys
Hotkey	!^f,	Fishing			; Pressing ctrl + alt + f will start fishing
Hotkey  !^e,	JumpFly			; Pressing ctrl + alt + e will dubble hit space and fire a rockct in main hand
Hotkey  !^c,	Concrete		; Pressing ctrl + alt + c will start concrete farming
Hotkey  !^m,	MobGrind		; Pressing ctrl + alt + m will start mob grinding
Hotkey	!^k,	MobKill			; Pressing ctrl + alt + k will start mob killing
Hotkey	!^s,	Stop			; Pressing ctrl + alt + s will stop it
Hotkey  !^w,    SelectWindow 	; Allows user to select window to control by hovering mouse over it and pressing ctrl + alt + w


; Menu Setup
Menu, Tray, icon, XisumaVoid_Face.ico
Menu, Tray, Add ; Adds sepearter line
Menu, Tray, Add, UnHide, ShowGUI

Menu, FileMenu, Add, Open, MenuFileOpen
Menu, FileMenu, Add, Hide, HideGUI
Menu, FileMenu, Add, Exit, GUIClose

Menu, HelpMenu, Add, About, MenuHandler

Menu, OptionsMenu, Add, Fishing, MenuFishing
Menu, OptionsMenu, Add, AFK Mob, MenuAFK
Menu, OptionsMenu, Add, Concrete, MenuConcrete
Menu, OptionsMenu, Add, JumpFlying, MenuJumpFly
Menu, OptionsMenu, Add, MobKill, MenuMobKill

Menu, ClickerMenu, Add, File, :FileMenu
Menu, ClickerMenu, Add, Help, :HelpMenu
Menu, ClickerMenu, Add, Options, :OptionsMenu

;===================================================================================================
; GUI-Default Welcome Screen
; Start screen asking user to select the target window to send keys to
;===================================================================================================
If (%ProgState% != 0)
{
	Return
}

Gui, Start:Show, Center W300 H300, %wintitle%
; Gui, Start:Add, Pic, W280 H290 vpic_get, welcomepic.png
If FileExist("welcomepic.png")
{
	Gui, Start:Add, Pic, W280 H290 vpic_get, welcomepic.png
}
Else
{
	Gui, Start:Add, Text, , Select Minecraft Window and press Ctrl+Alt+W
}
; Gui, Add, Text, , %SplashPic%
Return

;===================================================================================================
; Called when Ctrl+Alt+W is pressed and captures target window information, checks its a java prog
; and then creates the first window.
SelectWindow:
{
	; Get mouse pos on screen and grab details of program
	MouseGetPos, , , id, control
	WinGetTitle, targettitle, ahk_id %id%
	WinGetClass, targetclass, ahk_id %id%

	; DEBUGGING: Show information about the window such as it's title, ID, class, etc.
	MsgBox, ahk_id %id%`nahk_class %targetclass%`n%targettitle%`nControl: %control%

	; TODO: Get rid of this check maybe? Does this even work?
	;       maybe ask the user if they know what they're doing and continue or quit the program?
	; Check if the class of the program is a Minecraft Java Class
	If InStr(targetclass, targetwinclass)
	{
		; Target window found, swap to next screen
		ProgState = 1
		Gui, Start:Destroy
		Gui, Main:New, , %wintitle%
		Gui, Main:Menu, ClickerMenu

		; Left GUI element group
		Gui, Main:Add, Text, X10 Y15 , Target Window Title :
		Gui, Main:Add, Text, , Windows HWIND is :
		Gui, Main:Add, Text, , CURRENT MODE:
		Gui, Main:Add, Text, W370 R3 vReminderText, To change mode of operation please select from Option menu.
		Gui, Main:Add, Text, ,
		Gui, Add, Slider, vMySlider gOnSliderChange W375 ToolTip Range0-1000 TickInterval100, MySlider

		; Right GUI element group
		Gui, Main:Add, Text, X150 Y15 vtargettitleText, %targettitle%
		Gui, Main:Add, Text, vIDText, %id%
		Gui, Main:Add, Text, vMode w100, None

		GuiControl, Main:Hide, MySlider
		Gui, Main: Show, H400 H210

		; Clear mouse clicks to target by sending UP to the keys:
		; - `Right` and `Left` specifies which mouse button to press
		; - the `NA` option improves reliability when the window isn't active, and
		; - the `U` letter sends an up-event
		ControlClick, , ahk_id %id%, , Right, , NAU
		ControlClick, , ahk_id %id%, , Left, , NAU
		Sleep 500
	}
	Else
	{
		; Class of target program not a match so give a warning message
		ErrorMsg := "You do not seem to have selected a Minecraft window. Please check before you continue."
		MsgBox, %ErrorMsg%
	}
	Return
}

;===================================================================================================
;Menu Functions
; Place holder - will allow users to load saved values
;===================================================================================================
MenuFileOpen:
{
	;ModeText := JumpFlying
	;GuiControl,,Mode, %ModeText%
	Return
}
;===================================================================================================
ShowGUI:
{
	Gui, Main:Show, H400 H210
	Return
}
;===================================================================================================
HideGUI:
{
	Gui, Main:Hide
	Return
}
;===================================================================================================
MenuHandler:
{
	; TODO: About menu action here
	Return
}

; When the slider value is changed, 'submit' the GUI which saves all the values to their variables and hence gets the value of the slider.
OnSliderChange:
{
	Gui, Submit, NoHide
	Return
}

;===================================================================================================
; Switch to Fishing mode and update window
MenuFishing:
{
	; Stop any current active AHK process
	BreakLoop := 1

	; Uses `n to insert line feeds in multi line text box.
	GuiControl, Main:Text, Mode, Fishing
	GuiControl, Main:Show, MySlider
	GuiControl, Main:Text, ReminderText, CURRENT AVALIBLE OPTIONS:`no- Pressing ctrl + alt + f will start fishing`no- Pressing ctrl + alt + s will stop any AutoKey function above

	ProgState := 2
	Return
}

;===================================================================================================
; Switch to AFK mode and update window
MenuAFK:
{
	; Stop and current active AHK process
	BreakLoop := 1

	; Uses `n to insert line feeds in multi line text box.
	GuiControl, Main:Text, Mode, AFK Mob
	GuiControl, Main:Hide, MySlider
	GuiControl, Main:Text, ReminderText, CURRENT AVALIBLE OPTIONS:`no- Pressing ctrl + alt + m will start Mob Grinding`no- Pressing ctrl + alt + s will stop any AutoKey function above

	ProgState := 4
	Return
}

;===================================================================================================
; Switch to Concrete mode and update window
MenuConcrete:
{
	; Stop and current active AHK process
	BreakLoop := 1

	; Uses `n to insert line feeds in multi line text box.
	GuiControl, Main:Text, Mode, Concrete
	GuiControl, Main:Hide, MySlider
	GuiControl, Main:Text, ReminderText, CURRENT AVALIBLE OPTIONS:`no- Pressing ctrl + alt + c will start concrete farming`no- Pressing ctrl + alt + s will stop any AutoKey function above

	ProgState := 3
	Return
}

;===================================================================================================
; Switch to Flying mode and update window
MenuJumpFly:
{
	; Stop and current active AHK process
	BreakLoop := 1

	; Uses `n to insert line feeds in multi line text box.
	GuiControl, Main:Text, Mode, JumpFly
	GuiControl, Main:Hide, MySlider
	GuiControl, Main:Text, ReminderText, CURRENT AVALIBLE OPTIONS:`no- Pressing ctrl + alt + e will double hit space and fire a rocket in main hand

	ProgState := 1
	Return
}

MenuMobKill:
{
	BreakLoop := 1

	GuiControl, Main:Text, Mode, MobKill
	GuiControl, Main:Hide, MySlider
	GuiControl, Main:Text, ReminderText, CURRENT AVALIBLE OPTIONS:`no- Pressing ctrl + alt + k will start killing mobs`no- Pressing ctrl + alt + s will stop any AutoKey function above

	ProgState := 5
	Return
}

;===================================================================================================
; Called when Ctrl+Alt+E is pressed.
; NOTE: Target window MUST be in focus for this to work
JumpFly:
{
	If (ProgState != 1)
	{
		Return
	}

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
	If (ProgState != 3)
	{
		Return
	}

	BreakLoop := 0

	ControlClick, , ahk_id %id%, ,Right, , NAD
	Sleep 500
	ControlClick, , ahk_id %id%, ,Left, , NAD
	sleep 100

	While (BreakLoop = 0)
	{
		If (BreakLoop = 1)
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
	If (ProgState != 2)
	{
		Return
	}

	BreakLoop := 0
	Loop
	{
		If (BreakLoop = 1)
		{
			BreakLoop := 0
			Break
		}

		Sleep %MySlider%
		ControlClick, , ahk_id %id%, ,Right, , NAD
		Sleep 100
		ControlClick, , ahk_id %id%, ,Right, , NAU
	}
	Return
}

;==================================================================================================
; Called when Ctrl+Alt+M is pressed
MobGrind:
{
	If (ProgState != 4)
	{
		Return
	}

	BreakLoop := 0
	Delay := 0
	Sleep 500
	While (BreakLoop = 0)
	{
		; On each loop send RIGHT key down as it can be lost when switching focus
		ControlClick, , ahk_id %id%, , Right, , NAD

		if (BreakLoop = 1)
		{
			; On Ctrl+Alt+S detected forces a RIGHT mouse key UP
			ControlClick, , ahk_id %id%, , Right, , NAU
			Return
		}

		Sleep 100 ;100 ms
		; Delay between LEFT clicks is controled by sleep delay above * value tested here (ie 12)
		; Example = 100ms * 12 = 1.2 seconds
		; This method allows AHK to better exit this mode and respond quicker to Stop command
		If (Delay >= 12)
		{
			; If delay counter reached, reset counter and send a LEFT click
			Delay := 0
			Sleep 50
			ControlClick, , ahk_id %id%, , Left, , NAD
			Sleep 50
			ControlClick, , ahk_id %id%, , Left, , NAU
		}
		Else
		{
			Delay++ ; Increase delay counter by 1
		}

	}

	Sleep 100
	; Force mouse keys UP at exit
	ControlClick, , ahk_id %id%, , Right, , NAU
	ControlClick, , ahk_id %id%, , Left, , NAU
	Return
}

MobKill:
{
	if (ProgState != 5)
	{
		Return
	}

	BreakLoop := 0
	Delay := 0
	Sleep 500
	While (BreakLoop = 0)
	{
		Sleep 100 ;100 ms
		; Delay between LEFT clicks is controled by sleep delay above * value tested here (ie 12)
		; Example = 100ms * 12 = 1.2 seconds
		; This method allows AHK to better exit this mode and respond quicker to Stop command
		If (Delay >= 12)
		{
			; If delay counter reached, reset counter and send a LEFT click
			Delay := 0
			Sleep 50
			ControlClick, , ahk_id %id%, , Left, , NAD
			Sleep 50
			ControlClick, , ahk_id %id%, , Left, , NAU
		}
		Else
		{
			Delay++ ; Increase delay counter by 1
		}
	}

	Sleep 100
	; Force mouse keys UP at exit
	ControlClick, , ahk_id %id%, , Left, , NAU
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
	ControlClick, , ahk_id %id%, ,Left, , NAU
	Sleep 500
	Return
}

ESC:
GuiClose:
GuiEscape:
ExitApp
