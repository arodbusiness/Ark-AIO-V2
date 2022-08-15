#Persistent
#NoEnv
#SingleInstance Force
#MaxThreads 25
#MaxThreadsPerHotkey 1000
#MaxHotkeysPerInterval 5000
#MaxMem 128
#Include Gdip_All.ahk
#Include Vis2.ahk

StartTime := A_TickCount

CurrentVer := 2.75

DebugDrawn := 0

;Gui, 1			Main Program
;Gui, 2			pixel coords & helena
;Gui, 3			MsgBox
;Gui, 4			Overlay Info
;Gui, 5			Notify Gui / Countdown
;Gui, 6			Crosshair
;Gui, 7			Dino Export
;Gui, 8			AutoClickGui
;Gui, 9			Food & Water
;Gui, 11		Timed Alerts Gui




If !pToken := Gdip_Startup(){
	MsgBox, No Gdiplus 
	ExitApp
}


IconW := 512
FirstPass := 1
SetBatchLines -1
Process, Priority,, A
SetKeyDelay, -1
SetWinDelay, -1
SetControlDelay, -1

CoordMode, Mouse, Screen
CoordMode, Pixel, Client

global ShowingMsgBox


OnExit, ExitSub
DetectHiddenWindows, On


HookProcAdr := RegisterCallback("HookProc", "F" )
API_SetWinEventHook(4,5,0,HookProcAdr,0,0,0)
API_SetWinEventHook(0xA,0xB,0,HookProcAdr,0,0,0)

OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x84, "WM_NCHITTEST")
OnMessage(0x83, "WM_NCCALCSIZE")

FishingColor := "0xFFFFFF"
FishingSpeed := 250
DisplayingMessage := 0

Menu, Tray, Click, 1
Menu, Tray, NoStandard
Menu, Tray, Tip, Ark AIO



global CapDir := A_ScriptDir "\Captures"
if (!FileExist(CapDir))
	FileCreateDir, %CapDir%

global DebugDir := A_ScriptDir "\Captures\Debug"
if (!FileExist(DebugDir))
	FileCreateDir, %DebugDir%

IconsDir := A_ScriptDir "\Captures\Icons"
if (!FileExist(DebugDir))
	FileCreateDir, %DebugDir%
	
if (!FileExist(A_ScriptDir "\DebugSplash"))
	FileCreateDir, %A_ScriptDir%\DebugSplash

SoundDir := A_ScriptDir "\Sounds"
if (!FileExist(SoundDir))
	FileCreateDir, %SoundDir%

A_Temp2 := A_Temp "\Ark-AIO"
if (!FileExist(A_Temp2))
	FileCreateDir, %A_Temp2%

ScreenshotsDir := A_Temp2 "\Screenshots"
if (!FileExist(ScreenshotsDir))
	FileCreateDir, %ScreenshotsDir%

ClipsDirFood := A_Temp2 "\Food"
if (!FileExist(ClipsDirFood))
	FileCreateDir, %ClipsDirFood%

ClipsDirWater := A_Temp2 "\Water"
if (!FileExist(ClipsDirWater))
	FileCreateDir, %ClipsDirWater%

ClipsDirBrew := A_Temp2 "\Brew"
if (!FileExist(ClipsDirBrew))
	FileCreateDir, %ClipsDirBrew%

ClipsDirASB := A_Temp2 "\ASB"
if (!FileExist(ClipsDirASB))
	FileCreateDir, %ClipsDirASB%

global ImagesTempDir := A_Temp2 "\ImagesTemp"
if (!FileExist(ImagesTempDir))
	FileCreateDir, %ImagesTempDir%

ServerPath := A_ScriptDir "\FavoriteServers"
if (!FileExist(ServerPath))
	FileCreateDir, %ServerPath%

MapImagesPath := A_ScriptDir "\FavoriteServers\Images"
if (!FileExist(MapImagesPath))
	FileCreateDir, %MapImagesPath%

arrowSize := 26
Loop, 19 {
	if (A_Index=1){
		ImgFile := CapDir "\YellowBar.png"
		X := 5, Y := 25, IColor := "FFFF00"
	}else if (A_Index=2){
		ImgFile := CapDir "\OrangeBar.png"
		X := 3, Y := 15, IColor := "FD8306"
	}else if (A_Index=3){
		ImgFile := CapDir "\CyanBar.png"
		X := 3, Y := 20, IColor := "00FFE9"
	}else if (A_Index=4){
		ImgFile := CapDir "\LowerButton.png"
		X := 60, Y := 1, IColor := "175F78"
	}else if (A_Index=5){
		ImgFile := CapDir "\UpperButton.png"
		X := 60, Y := 1, IColor := "1D6F89"
	}else if (A_Index=6){
		ImgFile := CapDir "\CyanX.png"
		X := 22, Y := 22, IColor := "0089A8", W := 3
	}else if (A_Index=7){
		ImgFile := CapDir "\BlackBox1.png"
		X := 22, Y := 22, IColor := "000000"
	}else if (A_Index=8){
		ImgFile := CapDir "\BlackBox2.png"
		X := 44, Y := 44, IColor := "000000"
	}else if (A_Index=9){
		ImgFile := CapDir "\RedBar.png"
		X := 3, Y := 18, IColor := "FC0303"
	}else if (A_Index=10){
		ImgFile := CapDir "\HelenaCyanBar.png"
		X := 310, Y := 2, IColor := "2C8196"
	}else if (A_Index=11){
		ImgFile := CapDir "\HelenaCyanBar2.png"
		X := 16, Y := 7, IColor := "078CB3"



	}else if (A_Index=12){
		ImgFile := CapDir "\Arrow0.png"
		X := arrowSize, Y := arrowSize, IColor := "FFFFFF"
	}else if (A_Index=13){
		ImgFile := CapDir "\Arrow1.png"
		X := arrowSize, Y := arrowSize, IColor := "FFFFFF"
	}else if (A_Index=14){
		ImgFile := CapDir "\Arrow2.png"
		X := arrowSize, Y := arrowSize, IColor := "FFFFFF"
	}else if (A_Index=15){
		ImgFile := CapDir "\Arrow3.png"
		X := arrowSize, Y := arrowSize, IColor := "FFFFFF"



	}else if (A_Index=16){
		ImgFile := CapDir "\Arrow0i.png"			;right
		X := arrowSize, Y := arrowSize, IColor := "000000"
	}else if (A_Index=17){
		ImgFile := CapDir "\Arrow1i.png"			;down
		X := arrowSize, Y := arrowSize, IColor := "000000"
	}else if (A_Index=18){
		ImgFile := CapDir "\Arrow2i.png"			;left
		X := arrowSize, Y := arrowSize, IColor := "000000"
	}else if (A_Index=19){
		ImgFile := CapDir "\Arrow3i.png"			;up
		X := arrowSize, Y := arrowSize, IColor := "000000"
	}



	;if (!FileExist(ImgFile)){

		pBitmap := Gdip_CreateBitmap(X, Y)
		G := Gdip_GraphicsFromImage(pBitmap), Gdip_SetSmoothingMode(G, 4), Gdip_SetInterpolationMode(G, 7)
		pBrush := Gdip_BrushCreateSolid("0x0F" IColor)
		


		if (A_Index=6){
			pPen:=Gdip_CreatePenFromBrush(pBrush, W)
			Gdip_DrawLine(G, pPen, 2, 2, X-2, Y-2)
			Gdip_DrawLine(G, pPen, 2, Y-2, X-2, 2)
			Gdip_DeletePen(pPen)
		}


		if (RegexMatch(A_Index, "^1[2-9]$")){

			Gdip_TranslateWorldTransform(G, X*0.5, Y*0.5)
			,Gdip_RotateWorldTransform(G, A_Index=12 || A_Index=16 ? -90 : A_Index=13 || A_Index=17 ? 0 : A_Index=14 || A_Index=18 ? 90 : 180)
			,Gdip_TranslateWorldTransform(G, -X*0.5, -Y*0.5)


			Loop, 3 {
				Radius := A_Index=1 ? X*0.4 : A_Index=2 ? X*0.5 : X*0.33
				,RadialFadeScale := A_Index=1 ? 0 : A_Index=2 ? 0 : 1
				,IColorA := A_Index=1 ? "0x2F" IColor : A_Index=2 ? "0x9F" IColor : "0x7F" IColor
				,PPathCurrent := Gdip_CreatePath(G)
				,PathPoints := ""
				,CurrentAngle := 0
				,AngleInc := A_Index=1 ? 20 : 120
				,LoopN := A_Index=1 ? 18 : 4
				Temp := ""
				Loop % LoopN ;(CurrentAngle+AngleInc<360)
				{				
					Temp := Temp CurrentAngle "`n"
					PathCurrentX := (X*0.5+Radius*sin((CurrentAngle + AngleInc)*0.01745329))
					,PathCurrentY := (X*0.5+Radius*cos((CurrentAngle + AngleInc)*0.01745329))
					,CurrentAngle := CurrentAngle+AngleInc>360 ? CurrentAngle+AngleInc-360 : CurrentAngle+AngleInc
					,PathPoints := PathPoints "|" PathCurrentX "," PathCurrentY

				}
				;Tooltip, %PathPoints%`n`n`n%Temp%

				Gdip_AddPathPolygon(PPathCurrent, substr(PathPoints, 2)), PathPoints := ""

				,DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", "Ptr", PPathCurrent, "PtrP", SplashBrush)
				,VarSetCapacity(POINT, 8),	NumPut((X*0.5), POINT, 0, "Float"),	NumPut((X*0.5), POINT, 4, "Float")
				,DllCall("Gdiplus.dll\GdipSetPathGradientCenterPoint", "Ptr", SplashBrush, "Ptr", &POINT)
				,DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", "Ptr", SplashBrush, "UInt", IColorA), POINT := ""
				,VarSetCapacity(COLOR, 4, 0)
				,NumPut("0x00000000", COLOR, 0, "UInt"), COLORS := 1
				,DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", "Ptr", SplashBrush, "Ptr", &Color, "IntP", COLORS)
				,DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", SplashBrush, "Float", RadialFadeScale, "Float", RadialFadeScale)
				,Gdip_FillPath(G, SplashBrush, PPathCurrent)
				,Gdip_DeleteBrush(SplashBrush)
				,Gdip_DeletePath(PPathCurrent)
			}
		}
/*
		else if (A_Index=12 || A_Index=16)
			Gdip_FillPolygon(G, pBrush, 0 "," 0 "|" X "," Y/2 "|" 0 "," Y "|" 0 "," 0, 1)
		else if (A_Index=13 || A_Index=17)
			Gdip_FillPolygon(G, pBrush, 0 "," 0 "|" X/2 "," Y "|" X "," 0 "|" 0 "," 0 , 1)
		else if (A_Index=14 || A_Index=18)
			Gdip_FillPolygon(G, pBrush, 0 "," Y/2 "|" X "," 0 "|" X "," Y "|" 0 "," Y/2 , 1)
		else if (A_Index=15 || A_Index=19)
			Gdip_FillPolygon(G, pBrush, X/2 "," 0 "|" X "," Y "|" 0 "," Y "|" X/2 "," 0, 1)
		else
			Gdip_FillRectangle(G, pBrush, -2, -2, X+2, Y+2)
*/

		Gdip_DeleteBrush(pBrush)
		Gdip_SaveBitmapToFile(pBitmap, ImgFile)
		Gdip_DeleteGraphics(G)
		Gdip_DisposeImage(pBitmap)
		
	;}
}



global FileSettings := A_ScriptDir "\Ark-AIO.ini"
if (!FileExist(FileSettings)){
;	;MsgBox, 0,, Failed to find %FileSettings%
;	RetVal := MsgBox2("Failed to find " FileSettings, "0 r2")
;	;IfMsgBox OK 
;	if (RetVal)
;		ExitApp
	file := FileOpen(FileSettings, "w")
	file.Write("[Main]`r`nWindowX=0`r`nWindowY=0`r`nWindowW=325`r`nWindowH=900`r`nShowingSplashImageButton=1`r`nShowingAlertsButton=1`r`nShowingAutoClickButton=1`r`nShowingAutoFoodWaterButton=1`r`nShowingCrosshairButton=1`r`nShowingDinoExportButton=1`r`nShowingFeedBabiesButton=1`r`nShowingFishingButton=1`r`nShowingQuickTransferButton=1`r`nShowingServerInfoButton=1`r`nShowingDebugButton=0`r`nCheckInvX=1815`r`nCheckInvY=33`r`nYourSearchX=245`r`nYourSearchY=178`r`nYourTransferAllX=353`r`nYourTransferAllY=191`r`nYourDropAllX=407`r`nYourDropAllY=183`r`nTheirSearchX=1324`r`nTheirSearchY=178`r`nTheirTransferAllX=1479`r`nTheirTransferAllY=198`r`nTheirDropAllX=1537`r`nTheirDropAllY=188`r`nStructureHPX=762`r`nStructureHPY=479`r`nYourTransferSlotX=259`r`nYourTransferSlotY=277`r`nTheirTransferSlotX=1380`r`nTheirTransferSlotY=273`r`nIconColor1=FF6040`r`nIconColor2=40FF60`r`nIconColor3=20CCFF`r`nasbx=25`r`nasby=215`r`nasbw=300`r`nasbh=400")
	file.Close()
}

/*
FileSettings2 := A_ScriptDir "\Ark-AIO-New.ini"
if (!FileExist(FileSettings2)){
	;MsgBox, 0,, Failed to find %FileSettings2%
	RetVal := MsgBox2("Failed to find " FileSettings2, "0 r2")
	;IfMsgBox OK 
	if (RetVal)
		ExitApp
}
*/

;Better way to add variables below
FileSettings2 := A_ScriptDir "\Ark-AIO-New.ini"
FileDelete, %FileSettings2%




IniRead, ShowingSplashImageButton, %FileSettings%, Main, ShowingSplashImageButton
IniRead, AlwaysonTop, %FileSettings%, Main, AlwaysonTop
if (AlwaysonTop)
	Gui, 1:+Resize +HwndMainHwnd +AlwaysOnTop ;+LastFound
else
	Gui, 1:+Resize +HwndMainHwnd ;+LastFound

global MainHwnd              ;;;;;;;;;For HookProc
Gui, 1:Color, 000000
;Gui, Color, 00FF00

ButtonW := 28
ButtonY := 2
HTMLY := ButtonW + ButtonY

Gui, 1:Add, ActiveX, X0 vHTMLDisplay2 Y%HTMLY%, Shell.Explorer   ;use this as initial starting and Validation Info. then delete when normal is ready. smooth transition
Gui, 1:Add, ActiveX, X200 vHTMLDisplay Y%HTMLY%, Chrome.Browser ;Chrome.Browser Shell.Explorer Mozilla.Browser 

global HTMLDisplay										;At Least for Presets Functions
ComObjConnect(HTMLDisplay, WB_events)


OnMessage(0x100, Func("gui_KeyDown").Bind(HTMLDisplay), 2)			;this is for normal browser functions like tab shift+tab ctrl+c ctrl+v

HTMLDisplay.silent := HTMLDisplay2.silent := 1				


IniRead, FontFace, %FileSettings%, Main, FontFace
FontFace := FontFace!="ERROR" ? FontFace : "Times New Roman"
global FontFace

Gui, 1:Font, s18 w600, %FontFace%
Gui, 1:Add, Text, cWhite  vMover BackgroundTrans, Ark AIO v%CurrentVer%
;;Gui 1:Color, %GUIBackColor%, %GUIBackColor%

Gui, 1:Add, Picture, y%ButtonY% w%ButtonW% h%ButtonW% vCloseButton gExitSub BackgroundTrans 0xE,
Gui, 1:Add, Picture, y%ButtonY% w%ButtonW% h%ButtonW% vMinButton gActivateMainWindow BackgroundTrans 0xE,
Gui, 1:Add, Picture, y%ButtonY% w%ButtonW% h%ButtonW% vRestartButton gReloadSub BackgroundTrans 0xE,
Gui, 1:Add, Picture, x2 y%ButtonY% w%ButtonW% h%ButtonW% vIconButton 0xE,


IniRead, CurrentMonth, %FileSettings%, Main, CurrentMonth
IniRead, CurrentDay, %FileSettings%, Main, CurrentDay

CurrentMonth := CurrentMonth!="ERROR" ? CurrentMonth : RegexReplace(A_MM, "^0")
CurrentDay := CurrentDay!="ERROR" ? CurrentDay : RegexReplace(A_DD, "^0")


ColorMod := 0
IconColors := ""
if (CurrentMonth=2 && RegexMatch(CurrentDay, "1[1-8]{1}")){																										;ARK: Love Evolved 
	IconColors := ["FF6040", "C94789", "FFFFFF"]
	SplashColors := ["FF6040", "C94789", "FFFFFF"]	
	ColorMod := -110
}else if ((RegexMatch(CurrentMonth, "^3$") && RegexMatch(CurrentDay, "^31$")) || RegexMatch(CurrentMonth, "^4$")){												;ARK: Eggcellent Adventure
	IconColors := ["FFFF00", "FF00FF", "00FFFF"]
	SplashColors := ["FF00FF", "FFFF00", "00FFFF", "00FF00", "d9e0ff", "ffb46c"]	
	ColorMod := -150
}else if (CurrentMonth=6 && RegexMatch(CurrentDay, "1[1-9]{1}|2[0-4]{1}")){																						;Anniversary
	IconColors := ["FF00ff", "FF9900", "00CCFF"]
	SplashColors := ["FF00ff", "FF9900", "00CCFF"]	
	ColorMod := -130
}else if ((CurrentMonth=6 && RegexMatch(CurrentDay, "2[5-9]{1}|3[0-1]{1}")) || (CurrentMonth=7 && RegexMatch(CurrentDay, "^[1-9]{1}$|1[0-9]{1}|2[0-1]{1}"))){	;ARK: Summer Bash
	IconColors := ["FF0000", "3366FF", "FFFFFF"]
	SplashColors := ["FF0000", "3366FF", "FFFFFF", "a8ff43", "ffb46c"]	
	ColorMod := -40
}else if ((CurrentMonth=10 && RegexMatch(CurrentDay, "2[2-9]{1}|3[0-1]{1}")) || (CurrentMonth=11 && RegexMatch(CurrentDay, "^[1-6]{1}$"))){						;ARK: Fear Evolved
	IconColors := ["ffb46c", "FFFF22", "FFFFFF"]	
	SplashColors := ["5e275f", "ffb46c", "ef3100", "000000", "008840"]	
	ColorMod := -160
}else if ((CurrentMonth=11 && RegexMatch(CurrentDay, "19|2[0-9]{1}|3[0-1]{1}")) || (CurrentMonth=12 && RegexMatch(CurrentDay, "^[1-8]{1}$"))){					;ARK: Turkey Trial
	IconColors := ["ff756c", "FF9900", "FFFFFF"]
	SplashColors := ["ff756c", "FF9900", "FFFFFF", "FFFF00"]	
	ColorMod := -60
}else if ((CurrentMonth=12 && RegexMatch(CurrentDay, "1[7-9]{1}|2[0-9]{1}|3[0-1]{1}")) || (CurrentMonth=1 && RegexMatch(CurrentDay, "^[1-7]{1}$"))){			;ARK: Winter Wonderland
	IconColors := ["ff756c", "008840", "FFFFFF"]
	SplashColors := ["ff756c", "008840", "FFFFFF", "aceaff"]	
	ColorMod := -60
}







if (IconColors=""){
	IniRead, IconColor1, %FileSettings%, Main, IconColor1
	IniRead, IconColor2, %FileSettings%, Main, IconColor2
	IniRead, IconColor3, %FileSettings%, Main, IconColor3

	IconColors := {}
	IconColors[1] := RegexMatch(IconColor1, "i)([0-9a-f]{6})$", Match) ? Match1 : "FF6040" 	;Red
	IconColors[2] := RegexMatch(IconColor2, "i)([0-9a-f]{6})$", Match) ? Match1 : "40FF60"	;Green
	IconColors[3] := RegexMatch(IconColor3, "i)([0-9a-f]{6})$", Match) ? Match1 : "20CCFF"	;Blue


	;IconColors := [RegexMatch(IconColor1, "i)([0-9a-f]{6})$", Match) ? Match1 : "FF6040", RegexMatch(IconColor2, "i)([0-9a-f]{6})$", Match) ? Match1 : "40FF60", RegexMatch(IconColor3, "i)([0-9a-f]{6})$", Match) ? Match1 : "20CCFF"]

	;SplashColor1 := "533070" ;9933DD"     	;purple/pink
	;SplashColor2 := "306e75" ;33AACC"		;blue
	;SplashColor3 := ""

	SplashColors := ["533070", "22CCEE", "9933DD", "1C4FC7", "601B80", "338FCC"]
	SplashBool := 1
}else{
	SplashBool := 0


	Loop % SplashColors.MaxIndex(){
		Temp1 := substr(SplashColors[1], 1, 2), Temp2 := substr(SplashColors[1], 3, 2), Temp3 := substr(SplashColors[1], 5, 2)
		SplashColors[i] := Dec2Hex(Min(255,Max(Hex2Dec(Temp1)+ColorMod,0))) Dec2Hex(Min(255,Max(Hex2Dec(Temp2)+ColorMod,0))) Dec2Hex(Min(255,Max(Hex2Dec(Temp3)+ColorMod,0)))
	
	}

}

global IconColors


GuiControlGet, Pos, Pos, CloseButton
GuiControlGet, hwnd, hwnd, CloseButton 
pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
Gdip_SetSmoothingMode(G,4), Gdip_SetInterpolationMode(G, 7)
pPen:=Gdip_CreatePen("0xFF" IconColors[1], 3) 
;pPen2:=Gdip_CreatePen("0xFF" IconColors[1], 2), Gdip_DrawRectangle(G, pPen2, 0, 0, PosW, PosH), Gdip_DeletePen(pPen2)
Gdip_DrawLines(G, pPen, 0.2*PosW "," 0.2*PosH "|" 0.8*PosW "," 0.8*PosH)
Gdip_DrawLines(G, pPen, 0.2*PosW "," 0.8*PosH "|" 0.8*PosW "," 0.2*PosH)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
Gdip_DeletePen(pPen), Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GuiControlGet, hwnd, hwnd, MinButton 
pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
Gdip_SetSmoothingMode(G,4), Gdip_SetInterpolationMode(G, 7)
pPen:=Gdip_CreatePen("0xFF" IconColors[3], 3) 
;pPen2:=Gdip_CreatePen("0xFF" IconColors[3], 2), Gdip_DrawRectangle(G, pPen2, 0, 0, PosW, PosH), Gdip_DeletePen(pPen2)
Gdip_DrawLines(G, pPen, 0.15*PosW "," 0.75*PosH "|" 0.85*PosW "," 0.75*PosH)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
Gdip_DeletePen(pPen), Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GuiControlGet, hwnd, hwnd, RestartButton 
pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
Gdip_SetSmoothingMode(G,4), Gdip_SetInterpolationMode(G, 7)
pPen:=Gdip_CreatePen("0xFF" IconColors[2], 3)
pBrush:=Gdip_BrushCreateSolid("0xFF" IconColors[2])
;pPen2:=Gdip_CreatePen("0xFF" IconColors[2], 2), Gdip_DrawRectangle(G, pPen2, 0, 0, PosW, PosH), Gdip_DeletePen(pPen2)
Gdip_DrawArc(G, pPen, 0.17*PosW, 0.175*PosH, 0.6*PosW, 0.6*PosH, 0, 290)
Gdip_FillPolygon(G, pBrush, 0.55*PosW "," 0.5*PosH "|" 0.75*PosW "," 0.3*PosH "|" 0.95*PosW "," 0.5*PosH "|" 0.55*PosW "," 0.5*PosH)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
Gdip_DeletePen(pPen), Gdip_DeleteBrush(pBrush), Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



IniRead, WindowX, %FileSettings%, Main, WindowX
IniRead, WindowY, %FileSettings%, Main, WindowY
IniRead, WindowW, %FileSettings%, Main, WindowW
IniRead, WindowH, %FileSettings%, Main, WindowH
IniRead, WindowTrans, %FileSettings%, Main, WindowTrans

if (WindowX is not number) {
	WindowX := 0
	IniWrite, %WindowX%, %FileSettings%, Main, WindowX
}

if (WindowY is not number) {
	WindowY := 0
	IniWrite, %WindowY%, %FileSettings%, Main, WindowY
}

if (WindowW<300){
	WindowW := 420
	IniWrite, %WindowW%, %FileSettings%, Main, WindowW
}

if (WindowH<300){
	WindowH := 1000
	IniWrite, %WindowH%, %FileSettings%, Main, WindowH
}


FileRead, HTML, %A_ScriptDir%\Ark-AIO.html
HTML := RegexReplace(HTML, """Captures", """" CapDir)
HTML := RegexReplace(HTML, "'Captures", "'" RegexReplace(CapDir, "\\", "\\"))
HTML := RegexReplace(HTML, "body\{", "* {`n`tfont-family: " FontFace ";}`nbody{")
;Clipboard := HTML

;;;;Adding CSS takes along time, so display to user first and say working.
;HTML := RegexReplace(HTML, <tr id="ValidationInfo" ></tr>.+?
HTML2 := substr(HTML, 1, InStr(HTML,"ValidationInfo")+24) "</table></body></html>"
HTML2 := RegexReplace(HTML2, "\/\*SPECIFIC BUTTON CSS HERE\*\/")
;Clipboard := HTML2


Count:=0
while % FileExist(g:=A_Temp2 "\" A_TickCount A_NowUTC "-tmp" Count "-2.DELETEME.html")
	Count+=1
sleep 100
FileAppend,%HTML2%,%g%
HTMLDisplay2.Navigate("file://" g)
;HTMLDisplay2.Navigate("http://www.google.com")				HTMLDisplay2.Navigate("about:blank")
HTML2 := ""

While (HTMLDisplay2.ReadyState<3){
	Sleep 10
}


HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"" align=""center"">Validating User....<br>This may take a while depending on your internet.</td>"
HTMLDisplay2.document.getElementById("ValidationInfo").style.display := "table-row"


;;;POTENTIAL TO HANG FROM BELOW?????
UUID()
{
	For obj in ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" A_ComputerName "\root\cimv2").ExecQuery("Select * From Win32_ComputerSystemProduct")
		return obj.UUID	; http://msdn.microsoft.com/en-us/library/aa394105%28v=vs.85%29.aspx
}

/*
	;;;USE THIS WHEN HANGING?????
if (RegexMatch(A_ScriptName, "\.ahk$"))
	ThisUUID := "03AA02FC-0414-059E-4406-4F0700080009"
else
	
*/


ThisUUID := UUID()

global SplashImagePath := A_ScriptDir "\icon.png"
GoSub, MakeSplashImage
HTMLDisplay2.document.getElementById("SplashImageTop").src := HTMLDisplay2.document.getElementById("SplashImageBottom").src := SplashImagePath
HTMLDisplay2.document.getElementById("SplashImageTop").style.opacity := HTMLDisplay2.document.getElementById("SplashImageBottom").style.opacity := "100%"
HTMLDisplay2.document.getElementById("SplashImageContent").style.display := "block"


if (WindowTrans<255 && WindowTrans!="ERROR")
	Winset, Transparent, %WindowTrans%, ahk_id %MainHwnd%


;WindowH2 := ShowingSplashImageButton ? WindowW+ButtonW : ButtonW+50
WindowH2 := WindowW+ButtonW


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;FIRST TIME WINDOW IS SHOWN
;;QUICK THINGS BEFORE THIS LINE PLS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


IniRead, DesiredWindows, %FileSettings%, Main, DesiredWindows


if (WinsActive())
	Gui, 1:Show, X%WindowX% Y%WindowY% W%WindowW% H%WindowH2% NA, Ark AIO
Else
	Gui, 1:Show, X%WindowX% Y%WindowY% W%WindowW% H%WindowH2%, Ark AIO		

GoSub, SaveWindowPos




;Tooltip % ComObjCreate("Scriptlet.TypeLib").Guid 			Unique ID?


;03AA02FC-0414-059E-4406-4F0700080009    should be admin

if (RegexMatch(ThisUUID,"03AA02FC\-0414\-059E\-4406\-4F0700080009")){
;if (0){
	HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Welcome Master!</td>"
	;Menu, Tray, Add, Show Variables, ShowVars
	Menu, Tray, Add, List Vars, ListVarsFn
	Menu, Tray, Add, Window Spy, WindowSpyFn
	Menu, Tray, Add, Copy HTML, ClipHTMLFn
	Menu, Tray, Add
	Sleep, 250

	InitialUpdateCheck := 0
}else{
	HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Validating User....<br>This may take a while depending on your internet.</td>"

	;reqVerify := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	;reqVerify.Option(4) := 0x0100  + 0x0200 + 0x1000 + 0x2000

	reqVerify := ComObjCreate("Msxml2.XMLHTTP")
	reqVerify.Open("GET", "https://raw.githubusercontent.com/arodbusiness/Ark-AIO-V2/master/PrivateUsersUUID.txt?abc=" A_Now, 0)

	reqVerify.SetRequestHeader("Pragma", "no-cache")
	reqVerify.SetRequestHeader("Cache-Control", "no-cache, no-store")
	reqVerify.SetRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT")

	reqVerify.send()								
	While (reqVerify.readyState != 4)
		Sleep 20

	Sleep 1000
	;UUIDs := reqVerify.ResponseText
	UUIDs := reqVerify.responseText
	;Tooltip, %UUIDs%
	if (RegexMatch(UUIDs, "i)Page Not Found")){
		HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Error 404: Page Not Found<br>Try again later</td>"
		Sleep 5000
		ExitApp
	}else if (RegexMatch(UUIDs, "i)Internal Server Error|error_500|500 Error")){
		HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Error aquiring UUIDs<br>500 Internal Server Error<br>Try again later</td>"
		Sleep 7000
		ExitApp
	}else if (!RegexMatch(UUIDs, ThisUUID)){	
		;Clipboard := ThisUUID
		Clipboard := ThisUUID
		;MsgBox, This Program is for Private Usage Only`nYour UUID has been copied to your clipboard.`n%ThisUUID%
		
		HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">This Program is for Private Usage Only.<br>Your UUID has been copied to your clipboard.<br>" ThisUUID "</td>"
		Sleep 7000

		ExitApp
	}else{
		HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">User Validated!</td>"
		Sleep 1500
	}

	if (RegexMatch(A_ScriptName, "debug12342069")){
		Menu, Tray, Add, List Vars, ListVarsFn
		Menu, Tray, Add, Window Spy, WindowSpyFn
		Menu, Tray, Add, Copy HTML, ClipHTMLFn
		Menu, Tray, Add
	}
	reqVerify := ""
	HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Checking for Update.</td>"

	InitialUpdateCheck := 1
	GoSub, CheckForUpdate
	InitialUpdateCheck := 0

	HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := CurrentVer<LatestVer ? "<td colspan=""2"">Ark AIO is on an older Version.<br>v" CurrentVer " < v" LatestVer "</td>" : "<td colspan=""2"">Ark AIO is up to Date.<br>v" LatestVer "</td>"
	Sleep 1500
}

HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Preparing Program: Generating CSS</td>"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


SplashColors2 := [], SplashColorImages := [], SplashColorBackgrounds := []
Loop % SplashColors.MaxIndex(){
	R := Hex2Dec(substr(SplashColors[A_Index],1,2))
	G := Hex2Dec(substr(SplashColors[A_Index],3,2))
	B := Hex2Dec(substr(SplashColors[A_Index],5,2))
	if(!(R<20 && G<20 && B<20) && !(R>200 && G>200 && B>200))
		SplashColors2.push(SplashColors[A_Index])
}

;TempStr := SplashColors2.MaxIndex() "`n`n`n"			ImagesTempDir
Loop % SplashColors.MaxIndex(){
	ColorIndex2 := A_Index+2>SplashColors.MaxIndex() ? A_Index - 2 : A_Index + 2
	;MakeSplashImageFn(512, SplashPatterns, 0 ,[SplashColors[A_Index], "000000", SplashColors[ColorIndex2], "000000"], 0, Temp1, Temp2)
	MakeSplashImageFn(A_Index, 512, SplashPatterns, 0 ,[SplashColors[A_Index], SplashColors[ColorIndex2], SplashColors[A_Index], SplashColors[ColorIndex2], SplashColors[A_Index], SplashColors[ColorIndex2], SplashColors[A_Index], SplashColors[ColorIndex2]], 0, Temp1, Temp2)
	

	;b64 css
	SplashColorImages[A_Index] := "data:image/png;base64," Temp1
	SplashColorBackgrounds[A_Index] := "data:image/png;base64," Temp2

	;file reference
	SplashColorImages[A_Index] := RegexReplace(Temp1, "\\", "/")
	SplashColorBackgrounds[A_Index] := RegexReplace(Temp2, "\\", "/")

	;TempStr := TempStr StrLen(SplashColorImages[A_Index]) " - " StrLen(SplashColorBackgrounds[A_Index]) "`n"
}
Temp1 := Temp2 := ""
;Tooltip % TempStr

ColorIndex := 1

;This is for all or non specific checkboxes ----- TEmpHTMLsize is 7763468 at end.
;VarSetCapacity(TempHTML, 8000000)
TempHTML := ""
;TempHTML := TempHTML "div div.button.r .checkbox:checked ~ .layer {`n`tbackground-color: #" SplashColors2[ColorIndex] ";`n}`n"
;TempHTML := TempHTML "div div.button.r .checkbox:checked + .knobs:before {`n`tbackground-image: url(""" SplashColorImages[ColorIndex] """);background-color: #" SplashColors2[ColorIndex] ";background-position: center;background-size: 20px 20px;background-attachment: scroll;`n}`n"

;;background properties here
CSSBackgroundSize := "background-blend-mode: normal;`nbackground-position: left top;`nbackground-size: 500px 300px;`nbackground-attachment: scroll;"		;Table Background
,CSSIconBackgroundSize := "background-blend-mode: multiply;`nbackground-position: right top;`nbackground-size: 450px;`nbackground-attachment: scroll;"	;Toggle Background
,CSSIconBackgroundSize2 := "background-blend-mode: multiply;`nbackground-position: center;`nbackground-size: 500px;`nbackground-attachment: scroll;" ;Radio Background
,CSSIconSize := "background-position: left;`nbackground-size: 100px;`nbackground-attachment: scroll;"												;Toggle Knob
,CSSIconSize2 := "background-position: center;`nbackground-size: 140px;`nbackground-attachment: scroll;"											;Radio Icon - 2 pos
,CSSIconSize3 := "background-blend-mode: multiply;`nbackground-position: right;`nbackground-size: 150px;`nbackground-attachment: scroll;`n"		;Radio Icon - 3 pos
,CSSCheckBoxSize := "background-position: center;`nbackground-size: 150px;`nbackground-attachment: scroll;"											;Simple Checkboxes

,CSSBackgroundA := ""   ;dont work
,CSSIconA := ""			;dont work



;;;;Put any (check on main dropdown line) here
Elements := ["AutoClickDropDown", "AutoFoodWaterDropDown", "BloodPackDropDown", "CrosshairDropDown", "DinoExportDropDown", "ECDropDown", "FeedBabiesDropDown", "FishingDropDown", "GachaFarmingDropDown", "QuickTransferDropDown"]

Loop % Elements.MaxIndex(){
	;TempHTML := TempHTML "tr#" Elements[A_Index] " td:nth-child(2) div div.button.r .checkbox:checked ~ .layer {`n`tbackground-color: #" SplashColors2[ColorIndex] " !important;`n}`n"
	
	TempHTML := TempHTML "tr#" Elements[A_Index] " td:nth-child(2) div.button.r .checkbox:checked ~ .layer {`n`tbackground-image: url(""" SplashColorBackgrounds[ColorIndex] """) !important;`nbackground-color: #" SplashColors2[ColorIndex] ";`n" CSSIconBackgroundSize "`n}`n"
	TempHTML := TempHTML "tr#" Elements[A_Index] " td:nth-child(2) div.button.r .checkbox:checked + .knobs:before {`n`tbackground-image: url(""" SplashColorImages[ColorIndex] """) !important;`nbackground-color: #" SplashColors2[ColorIndex] ";`n" CSSIconSize "`n`n}`n"
	;TempHTML := TempHTML "tr#" Elements[A_Index] " td:nth-child(2) div div.button.r {`nbox-shadow:0 0 5px #" SplashColors2[ColorIndex] " !important;`n}`n"

	ColorIndex := ColorIndex+1>SplashColors.MaxIndex() ? 1 : ColorIndex + 1
}

;;;;;`ncccccccccccccccccccccccccccccccccccccccccccccccc
;`nSplashColors2 := ["ff0000", "00ff00", "0000ff", "ffff00", "00ffff", "ff00ff"]

;`nthis is for console variables - OPTOMIZE THIS SEESH
ColorIndex := InnerIndex := 1, ColorIndex2 := 3
Loop, 4 {
	Loop % SplashColors2.MaxIndex() {

		;regular checkboxes 1
		TempHTML1 := TempHTML1 "tr.subrow:nth-child(" InnerIndex ") td div.box input.checkbox2:checked ~ .check {`n`tbackground-image: url(""" SplashColorImages[ColorIndex] """);`n " CSSCheckBoxSize "`nbox-shadow:0 0 15px #" SplashColors2[ColorIndex] ";`nborder: 2px solid transparent;`n}`n"
		,TempHTML1 := TempHTML1 "tr.subrow:nth-child(" InnerIndex ") td div.box span.check {`nborder: 2px solid #" SplashColors2[ColorIndex] ";`n}`n"
		;regular checkboxes 2
		,TempHTML1 := TempHTML1 "tr.subrow:nth-child(" InnerIndex ") td:nth-child(1) div.box input.checkbox2:checked ~ .check {`n`tbackground-image: url(""" SplashColorImages[ColorIndex] """);`n" CSSCheckBoxSize "`nbox-shadow:0 0 15px #" SplashColors2[ColorIndex] ";`nborder: 2px solid transparent;`n}`n"
		,TempHTML1 := TempHTML1 "tr.subrow:nth-child(" InnerIndex ") td:nth-child(1) div.box span.check {`nborder: 2px solid #" SplashColors2[ColorIndex] ";`n}`n"
		;regular checkboxes 3
		,TempHTML1 := TempHTML1 "tr.subrow:nth-child(" InnerIndex ") td:nth-child(2) div.box input.checkbox2:checked ~ .check {`n`tbackground-image: url(""" SplashColorImages[ColorIndex2] """);`n" CSSCheckBoxSize "`nbox-shadow:0 0 15px #" SplashColors2[ColorIndex2] ";`nborder: 2px solid transparent;`n}`n"
		,TempHTML1 := TempHTML1 "tr.subrow:nth-child(" InnerIndex ") td:nth-child(2) div.box span.check {`nborder: 2px solid #" SplashColors2[ColorIndex2] ";`n}`n"
		;regular checkboxes Auto FWB dropdownline
		,TempHTML1 := TempHTML1 "tr.dropdownline td div.box:nth-child(" InnerIndex ") input.checkbox2:checked ~ .check {`n`tbackground-image: url(""" SplashColorImages[ColorIndex] """);`n" CSSCheckBoxSize "`nbox-shadow:0 0 15px #" SplashColors2[ColorIndex] ";`nborder: 2px solid transparent;`n}`n"
		,TempHTML1 := TempHTML1 "tr.dropdownline td div.box:nth-child(" InnerIndex ") span.check {`nborder: 2px solid #" SplashColors2[ColorIndex] ";`n}`n"
		


		;`ntable content toggles - inside collapsable - careful with this - interfere with autoclicksenabled
		TempHTML2 := TempHTML2 "table.tablecontent:nth-child(" InnerIndex ") div.button.r .checkbox:checked ~ .layer {`n`tbackground-color: #" SplashColors2[ColorIndex] ";`n`n}`n"
		,TempHTML2 := TempHTML2 "table.tablecontent:nth-child(" InnerIndex ") div.button.r .checkbox:checked + .knobs:before {`n`tbackground-image: url(""" SplashColorImages[ColorIndex] """);`nbackground-color: #" SplashColors2[ColorIndex] CSSIconA ";`n" CSSIconSize "`n`n}`n"
	
		;`nthis is for console variables toggles
		,TempHTML2 := TempHTML2 "div#ConsoleVarsDiv" InnerIndex " div.button.r .checkbox:checked ~ .layer {`n`tbackground-image: url(""" SplashColorBackgrounds[ColorIndex] """) !important;`nbackground-color: #" SplashColors2[ColorIndex] CSSIconA " !important;`n" CSSIconBackgroundSize "`n}`n"
		,TempHTML2 := TempHTML2 "div#ConsoleVarsDiv" InnerIndex " div.button.r .checkbox:checked + .knobs:before {`n`tbackground-image: url(""" SplashColorImages[ColorIndex] """) !important;`nbackground-color: #" SplashColors2[ColorIndex] CSSIconA " !important;`n" CSSIconSize "`n`n}`n"
	
		;`nthis does "tabbeddiv" background for autoclicks and timed alerts
		,TempHTML2 := TempHTML2 "div.tabbeddiv:nth-child(" InnerIndex ")  {`n`tbackground-image: url(""" SplashColorBackgrounds[ColorIndex] """) !important;`n`n`n`n`n`n`n`n`n`nbackground-color: #" SplashColors2[ColorIndex] ";`n" CSSBackgroundSize "`n}`n" ;background-color: #" SplashColors2[ColorIndex] "


		TempHTML3 := TempHTML3 "div#AutoClicksEnabledDiv" InnerIndex " .checkbox:checked ~ .layer {`n`tbackground-image: url(""" SplashColorBackgrounds[ColorIndex] """) !important;`nbackground-color: #" SplashColors2[ColorIndex] CSSIconA " !important;`n" CSSIconBackgroundSize "`n}`n"
		,TempHTML3 := TempHTML3 "div#AutoClicksEnabledDiv" InnerIndex " .checkbox:checked + .knobs:before {`n`tbackground-image: url(""" SplashColorImages[ColorIndex] """) !important;`nbackground-color: #" SplashColors2[ColorIndex] CSSIconA " !important;`n" CSSIconSize "`n`n}`n"


		;`nthis is for button r2 - "radio" choose one or other - AutoClicksToggleDiv" A_Index
		,TempHTML3 := TempHTML3 "div#AutoClicksToggleDiv" InnerIndex " .checkbox:checked ~ .layer {`n`tbackground-image: url(""" SplashColorBackgrounds[ColorIndex] """) !important;`nbackground-color: #" SplashColors2[ColorIndex] CSSIconA " !important;`n" CSSIconBackgroundSize2 "`n}`n"
		,TempHTML3 := TempHTML3 "div#AutoClicksToggleDiv" InnerIndex " .checkbox:checked + .knobs:before {`n`tbackground-image: url(""" SplashColorImages[ColorIndex] """) !important;`nbackground-color: #" SplashColors2[ColorIndex] CSSIconA " !important;`n" CSSIconSize2 "`nbox-shadow:0 0 25px #" SplashColors2[ColorIndex2] " !important;`n`n`n}`n"

		,TempHTML3 := TempHTML3 "div#AutoClicksToggleDiv" InnerIndex " .checkbox ~ .layer {`n`tbackground-image: url(""" SplashColorBackgrounds[ColorIndex2] """) !important;`nbackground-color: #" SplashColors2[ColorIndex2] CSSIconA " !important;`n" CSSIconBackgroundSize2 "`n}`n"
		,TempHTML3 := TempHTML3 "div#AutoClicksToggleDiv" InnerIndex " .checkbox + .knobs:before {`n`tbackground-image: url(""" SplashColorImages[ColorIndex2] """) !important;`nbackground-color: #" SplashColors2[ColorIndex2] CSSIconA " !important;`n" CSSIconSize2 "`nbox-shadow:0 0 25px #" SplashColors2[ColorIndex] " !important;`n`n}`n"

		,ColorIndex := ColorIndex+1>SplashColors.MaxIndex() ? 1 : ColorIndex + 1
		,ColorIndex2 := ColorIndex+2>SplashColors.MaxIndex() ? ColorIndex - 2 : ColorIndex + 2
		,InnerIndex := InnerIndex+1
	}
}
	

;`nthis is for button r2 - "radio" choose one or other
TempHTML4 := TempHTML4 "div.button.r2 .checkbox:checked ~ .layer {`n`tbackground-image: url(""" SplashColorBackgrounds[1] """);`nbackground-color: #" SplashColors[1] CSSIconA ";`n" CSSIconBackgroundSize2 "`n}`n"
TempHTML4 := TempHTML4 "div.button.r2 .checkbox:checked + .knobs:before {`n`tbackground-image: url(""" SplashColorImages[1] """);`nbackground-color: #" SplashColors[1] CSSIconA ";`n" CSSIconSize2 "`n}`n"

TempHTML4 := TempHTML4 "div.button.r2 .checkbox ~ .layer {`n`tbackground-image: url(""" SplashColorBackgrounds[2] """);`nbackground-color: #" SplashColors[2] CSSIconA ";`n" CSSIconBackgroundSize2 "`n}`n"
TempHTML4 := TempHTML4 "div.button.r2 .checkbox + .knobs:before {`n`tbackground-image: url(""" SplashColorImages[2] """);`nbackground-color: #" SplashColors[2] CSSIconA ";`n" CSSIconSize2 "`n}`n"

;;`nthis is for 3 position toggles
TempHTML5 := TempHTML5 ".yes:checked + label {`n`tbackground-image: url(""" SplashColorImages[1] """) !important;`nbackground-color: #" SplashColors[1] CSSIconA " !important;`n" CSSIconSize3 "`n}`n"
TempHTML5 := TempHTML5 ".neutral:checked + label {`n`tbackground-image: url(""" SplashColorImages[2] """) !important;`nbackground-color: #" SplashColors[2] CSSIconA " !important;`n" CSSIconSize3 "`n}`n"
TempHTML5 := TempHTML5 ".no:checked + label {`n`tbackground-image: url(""" SplashColorImages[3] """) !important;`nbackground-color: #" SplashColors[3] CSSIconA " !important;`n" CSSIconSize3 "`n}`n"


;TempHTML := TempHTML TempHTML1 TempHTML2 TempHTML3 TempHTML4 TempHTML5
;Clipboard := SplashColorBackgrounds[2]
;Clipboard := TempHTML


;FinishTime := (A_TickCount - StartTime)
;Tooltip, %FinishTime%ms

HTML := RegexReplace(HTML, "\/\*SPECIFIC BUTTON CSS HERE\*\/", TempHTML TempHTML1 TempHTML2 TempHTML3 TempHTML4 TempHTML5)
TempHTML := TempHTML := TempHTML1 := TempHTML2 := TempHTML3 := TempHTML4 := TempHTML5 := ""



Count:=0
while % FileExist(f:=A_Temp2 "\" A_TickCount A_NowUTC "-tmp" Count ".DELETEME.html")
	Count+=1
FileAppend,%HTML%,%f%
HTMLDisplay.Navigate("file://" f)
Loop, Files, %A_Temp2%\*.html 
{
	if (f!=A_LoopFileFullPath && g!=A_LoopFileFullPath)
		FileDelete, %A_LoopFileFullPath%
}
HTML := f := g := ""

While (HTMLDisplay.ReadyState<3){
	Sleep 20
}

HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Preparing Program: Locating Game Files</td>"


HTMLDisplay.document.getElementById("SplashImageBottom").src := HTMLDisplay.document.getElementById("SplashImageTop").src := SplashImagePath
HTMLDisplay.document.getElementById("SplashImageContent").style.display := "block"


Elements := HTMLDisplay.document.getElementsbyClassName("dropdownline")
Loop % Elements.Length	{	
	Elements[A_Index-1].style.display := "none"
}


FirstPass := ModTimeCVLatest := ModTimeCVLatest := ModTimeSGLatest := 0

Alphabet := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
AlphabetArr := StrSplit(Alphabet)
Loop % AlphabetArr.MaxIndex(){
	if (!FileExist(AlphabetArr[A_Index] ":\"))
		Alphabet := RegexReplace(Alphabet, AlphabetArr[A_Index])
}
Drives := StrSplit(Alphabet)


if (FileExist(ASBvaluesFile))
	FileGetTime, ModTimeASBLatest, %ASBvaluesFile%
else
	ModTimeASBLatest := 0


ModTimeExportLatest := FoundNodeJS := FoundNodeGamedig := 0

Loop % Drives.MaxIndex()					;;;;Locate Files
{

	;;FIND VALUES.JSON SMART BREEDER
	CurrentDir := Drives[A_Index] ":\Users"
	if (FileExist(CurrentDir)){
		Loop, Files, %CurrentDir%\*, D
		{
			CurrentFile := A_LoopFileFullPath "\AppData\Local\ARK Smart Breeding\json\values\values.json"
			if (FileExist(CurrentFile)){
				FileGetTime, ModTimeASBCurrent, %CurrentFile%
				if (ModTimeASBCurrent>ModTimeASBLatest){
					ASBvaluesFile := CurrentFile
					ModTimeASBLatest := ModTimeASBCurrent
				}
			}

			CurrentFile := A_LoopFileFullPath "\node_modules\gamedig\bin\gamedig.js"
			if (FileExist(CurrentFile)){
				FoundNodeGamedig := 1
				;break
			}
		}
	}

	;;;FIND EXPORT FOLDER
	if(ExportDir=""){
		CurrentDir := Drives[A_Index] ":\Program Files (x86)\Steam\steamapps\common\ARK\ShooterGame\Saved\DinoExports"
		,CurrentDir := !FileExist(CurrentDir) ? Drives[A_Index] ":\SteamLibrary\steamapps\common\ARK\ShooterGame\Saved\DinoExports" : CurrentDir
		,CurrentDir := !FileExist(CurrentDir) ? Drives[A_Index] ":\Games\Steam\steamapps\common\ARK\ShooterGame\Saved\DinoExports" : CurrentDir

		if (FileExist(CurrentDir)){	
			Loop, Files, %CurrentDir%\*, D
			{
				ModTimeExportCurrentLoop := 0
				CurrentPath := A_LoopFileFullPath
				
				Loop, Files, %CurrentPath%\*.ini, F
					ModTimeExportCurrentLoop := A_LoopFileTimeModified>ModTimeExportCurrentLoop ? A_LoopFileTimeModified : ModTimeExportCurrentLoop


				if (ModTimeExportCurrentLoop>ModTimeExportLatest){
					ModTimeExportLatest := ModTimeExportCurrentLoop
					ExportDir := CurrentPath
					FoundPos := RegexMatch(ExportDir, "([0-9]{16,})", Match)
					ExportUser := Match1
				}
			}
		}
	}



	;;;ConsoleVars
	if (ConsoleVarsPath=""){
		CurrentDir := Drives[A_Index] ":\Program Files (x86)\Steam\steamapps\common\ARK\Engine\Config\ConsoleVariables.ini"
		,CurrentDir := !FileExist(CurrentDir) ? Drives[A_Index] ":\SteamLibrary\steamapps\common\ARK\Engine\Config\ConsoleVariables.ini" : CurrentDir
		,CurrentDir := !FileExist(CurrentDir) ? Drives[A_Index] ":\Games\Steam\steamapps\common\ARK\Engine\Config\ConsoleVariables.ini" : CurrentDir
		if (FileExist(CurrentDir)){
			FileGetTime, ModTimeCVCurrent, %CurrentDir%
			if (ModTimeCVCurrent>ModTimeCVLatest){
				ConsoleVarsPath := CurrentDir 
				ModTimeCVLatest := ModTimeCVCurrent
			}
		}
	}

	;;;ShooterGame.exe
	CurrentDir := Drives[A_Index] ":\Program Files (x86)\Steam\steamapps\common\ARK\ShooterGame\Binaries\Win64\ShooterGame_BE.exe"
	,CurrentDir := !FileExist(CurrentDir) ? Drives[A_Index] ":\SteamLibrary\steamapps\common\ARK\ShooterGame\Binaries\Win64\ShooterGame_BE.exe" : CurrentDir
	,CurrentDir := !FileExist(CurrentDir) ? Drives[A_Index] ":\Games\Steam\steamapps\common\ARK\ShooterGame\Binaries\Win64\ShooterGame_BE.exe" : CurrentDir
	if (FileExist(CurrentDir)){
		FileGetTime, ModTimeSGCurrent, %CurrentDir%
		if (ModTimeSGCurrent>ModTimeSGLatest){
			ShooterGameEXE := CurrentDir 
			ModTimeSGLatest := ModTimeSGCurrent
		}
	}


	;;;Node JS
	CurrentDir := Drives[A_Index] ":\Program Files (x86)\nodejs\node.exe"
	if (FileExist(CurrentDir)){
		FoundNodeJS := 1
	}

}
;ASBvaluesFile := ASBvaluesFile="" ? A_ScriptDir "\values.json" : ASBvaluesFile
CurrentFile := RegexReplace(A_AppData, "\\Roaming\\?") "\AppData\Local\ARK Smart Breeding\json\values\values.json"
if (FileExist(CurrentFile)){
	FileGetTime, ModTimeASBCurrent, %CurrentFile%
	if (ModTimeASBCurrent>ModTimeASBLatest){
		ASBvaluesFile := CurrentFile
		ModTimeASBLatest := ModTimeASBCurrent
	}
}

if (ModTimeASBLatest=0){
	FileURL := "https://raw.githubusercontent.com/arodbusiness/Ark-AIO-V2/master/values.json"
	FilePath := A_ScriptDir "\values.json"
	UrlDownloadToFile, %FileURL%, %FilePath%
	ASBvaluesFile := FilePath
}


CurrentFile := CurrentDir := ""

;Tooltip, %A_ScriptDir%\*.mp3`n%A_ScriptDir%\*.mp3
;if (FileExist(A_ScriptDir "\Disconnected.mp3"))
FileMove, %A_ScriptDir%\*.mp3 ,%A_ScriptDir%\Sounds\*.mp3



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DOWNLOAD NEW THINGS HERE
;;;;;;;;;;;;;;;;;;;;;;;;;Get Crumple Corn Page
CrumpleCornFilePath := A_ScriptDir "\crumplecorn.js"
if (!FileExist(CrumpleCornFilePath)){
	HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Downloading crumplecorn.js</td>"
	UrlDownloadToFile, http://ark.crumplecorn.com/breeding/controller.js, %CrumpleCornFilePath%
}
if (FileExist(CrumpleCornFilePath))
	FileRead, CrumpleCornFile, %CrumpleCornFilePath%
;;;;;;;;;;;;;;;;;;;;;;;;;Update/Fix Crumple Corn

if (!RegexMatch(CrumpleCornFile, "'Plant Y Seed': \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.Defaultfoods=\{", "$scope.Defaultfoods={`r`n`r`n`t`t'Plant Y Seed': {`r`n`t`t`tfood: 65,`r`n`t`t`tstack: 100,`r`n`t`t`tspoil: 0,`r`n`t`t`tweight: 0.01,`r`n`t`t`twaste: 0`r`n`t`t},")
if (!RegexMatch(CrumpleCornFile, "'Rare Mushroom': \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.Defaultfoods=\{", "$scope.Defaulfoods={`r`n`r`n`t`t'Rare Mushroom': {`r`n`t`t`tfood: 75,`r`n`t`t`tstack: 100,`r`n`t`t`tspoil: 0,`r`n`t`t`tweight: 0.2,`r`n`t`t`twaste: 0`r`n`t`t},")
/*
if (!RegexMatch(CrumpleCornFile, "Magmasaur: \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tMagmasaur: {`r`n`t`t`tbirthtype: ""Incubation"",`r`n`t`t`ttype: ""Ambergris"",`r`n`t`t},")
if (!RegexMatch(CrumpleCornFile, "Ferox: \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tFerox: {`r`n`t`t`tbirthtype: ""Gestation"",`r`n`t`t`ttype: ""Seed"",`r`n`t`t},")
if (!RegexMatch(CrumpleCornFile, "BloodStalker: \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tBloodStalker: {`r`n`t`t`tbirthtype: ""Incubation"",`r`n`t`t`ttype: ""Blood"",`r`n`t`t},")
if (!RegexMatch(CrumpleCornFile, "Hyaenodon: \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tHyaenodon: {`r`n`t`t`tbirthtype: ""Gestation"",`r`n`t`t`ttype: ""Carnivore"",`r`n`t`t},")
if (!RegexMatch(CrumpleCornFile, "Crystal Wyvern: \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tCrystal Wyvern: {`r`n`t`t`tbirthtype: ""Incubation"",`r`n`t`t`ttype: ""PrimalCrystal"",`r`n`t`t},")
if (!RegexMatch(CrumpleCornFile, "Wyvern: \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tWyvern: {`r`n`t`t`tbirthtype: ""Incubation"",`r`n`t`t`ttype: ""WyvernMilk"",`r`n`t`t},")
if (!RegexMatch(CrumpleCornFile, "Spider: \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tSpider: {`r`n`t`t`tbirthtype: ""Incubation"",`r`n`t`t`ttype: ""Carrion"",`r`n`t`t},")
if (!RegexMatch(CrumpleCornFile, "Mantis: \{"))
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tMantis: {`r`n`t`t`tbirthtype: ""Incubation"",`r`n`t`t`ttype: ""Carrion"",`r`n`t`t},")
;;;;;;;;;;;;
*/
file := FileOpen(CrumpleCornFilePath, "w")
file.Write(CrumpleCornFile)
file.Close()
file := CrumpleCornFile := ""

if(!FileExist("NeededColors.ini"))
	FileAppend, ,NeededColors.ini


MapURLs := [	"https://i.imgur.com/KaHkuMx.png" 			;Ab
				,"https://i.imgur.com/9eMiuft.png" 			;Ab 		grey
				,"https://i.imgur.com/H1EjwCA.png" 			;Center
				,"https://i.imgur.com/HzcOfcw.png" 			;Center 	grey
				,"https://i.imgur.com/yiG1qvK.png" 			;CI
				,"https://i.imgur.com/Mu54Mfn.png" 			;CI      	grey
				,"https://i.imgur.com/ENU09pl.png" 			;Ext
				,"https://i.imgur.com/k7Lyro9.png" 			;Ext 		grey
				,"https://i.imgur.com/3xhzxky.png" 			;gen
				,"https://i.imgur.com/HvO2j4e.png" 			;gen 		grey
				,"https://i.imgur.com/5eUR3jC.png" 			;gen 2
				,"https://i.imgur.com/y3GZuUV.png" 			;gen 2 		grey
				,"https://i.imgur.com/rd6BXHm.png" 			;Island
				,"https://i.imgur.com/H84sbPj.png" 			;Island 	grey
				,"https://i.imgur.com/HnrGOJs.png" 			;rag
				,"https://i.imgur.com/N9uJ3Z5.png" 			;rag 		grey
				,"https://i.imgur.com/FYVCcwj.png" 			;SE
				,"https://i.imgur.com/xHjNbMn.png" 			;SE 		grey
				,"https://i.imgur.com/v683LSL.png" 			;Valg
				,"https://i.imgur.com/bsoqNNU.png" 			;Valg 		grey
				,"https://i.imgur.com/TtkGzl6.png" 			;LostIsland 
				,"https://i.imgur.com/NRlj0oy.png" 			;LostIsland grey
				,"https://i.imgur.com/UAHuUol.png" 			;Fjordur
				,"https://i.imgur.com/QSdv4Q9.png"] 		;Fjordur 		grey
MaxMapWidth := 0
Loop % MapURLs.MaxIndex(){
	ImageURL := MapURLs[A_Index]
	,ImageName := MapURLs[A_Index] := RegexReplace(ImageURL,"^https:\/\/i\.imgur\.com\/")				;MapURLs[A_Index] := 
	,ImagePath := MapImagesPath "\" ImageName
	if (!FileExist(ImagePath)){
		HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Downloading " ImageName "</td>"
		UrlDownloadToFile, %ImageURL%, %ImagePath%
	}
	pBitmap := Gdip_CreateBitmapFromFile(ImagePath)                 
	,MaxMapWidth := Gdip_GetImageWidth(pBitmap)>MaxMapWidth ? Gdip_GetImageWidth(pBitmap) : MaxMapWidth
	,Gdip_DisposeImage(pBitmap)  
}




;;;;;;This will be for spawn map later.... maybe
/*
MapImagesPath2 := CapDir "\Maps\"
if (!FileExist(MapImagesPath2))
	FileCreateDir, %MapImagesPath2%


MapURLs2 := [	"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/4/44/Genesis_Part_2_Map.jpg"
				,"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/0/04/The_Island_Topographic_Map.jpg"
				,"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/5/58/The_Center_Topographic_Map.jpg"
				,"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/3/39/Scorched_Earth_Topographic_Map.jpg"
				,"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/c/cf/Ragnarok_Ocean_Topographic_Map.jpg"
				,"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/0/0b/Extinction_Topographic_Map.jpg"
				,"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/d/de/Valguero_Topographic_Map.jpg"
				,"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/3/37/Genesis_Part_1_Topographic_Map.jpg"
				,"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/7/70/Crystal_Isles_Topographic_Map.jpg"
				,"https://static.wikia.nocookie.net/arksurvivalevolved_gamepedia/images/3/36/Aberration_Topographic_Map.jpg"] 

Loop % MapURLs.MaxIndex(){
	ImageURL := MapURLs2[A_Index]
	,ImageName := RegexReplace(ImageURL, "^.+?\/[0-9a-z]{1}\/[0-9a-z]{2}\/(.+?)_(Top|Map).+?$", "$1")
	,ImageName := RegexReplace(ImageName, "_", " ")
	,ImagePath := MapImagesPath2 "\" ImageName ".jpg"
	if (!FileExist(ImagePath)){
		HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Downloading " ImageName " Map</td>"
		UrlDownloadToFile, %ImageURL%, %ImagePath%
	} 
}
*/


ColorIDstr := "1`tRed`tff0000`n2`tBlue`t0000ff`n3`tGreen`t00ff00`n4`tYellow`tffff00`n5`tCyan`t00ffff`n6`tMagenta`tff00ff`n7`tLight Green`tc0ffba`n8`tLight Grey`tc8caca`n9`tLight Brown`t786759`n10`tLight Orange`tffb46c`n11`tLight Yellow`tfffa8a`n12`tLight Red`tff756c`n13`tDark Grey`t7b7b7b`n14`tBlack`t3b3b3b`n15`tBrown`t593a2a`n16`tDark Green`t224900`n17`tDark Red`t812118`n18`tWhite`tffffff`n19`tDino Light Red`tffa8a8`n20`tDino Dark Red`t592b2b`n21`tDino Light Orange`tffb694`n22`tDino Dark Orange`t88532f`n23`tDino Light Yellow`tcacaa0`n24`tDino Dark Yellow`t94946c`n25`tDino Light Green`te0ffe0`n26`tDino Medium Green`t799479`n27`tDino Dark Green`t224122`n28`tDino Light Blue`td9e0ff`n29`tDino Dark Blue`t394263`n30`tDino Light Purple`te4d9ff`n31`tDino Dark Purple`t403459`n32`tDino Light Brown`tffe0ba`n33`tDino Medium Brown`t948575`n34`tDino Dark Brown`t594e41`n35`tDino Darker Grey`t595959`n36`tDino Albino`tffffff`n37`tBig Foot 0`tb79683`n38`tBig Foot 4`teadad5`n39`tBig Foot 5`td0a794`n40`tWolf Fur`tc3b39f`n41`tDark Wolf Fur`t887666`n42`tDragon Base 0`ta0664b`n43`tDragon Base 1`tcb7956`n44`tDragon Fire`tbc4f00`n45`tDragon Green 0`t79846c`n46`tDragon Green 1`t909c79`n47`tDragon Green 2`ta5a48b`n48`tDragon Green 3`t74939c`n49`tWyvern Purple 0`t787496`n50`tWyvern Purple 1`tb0a2c0`n51`tWyvern Blue 0`t6281a7`n52`tWyvern Blue 1`t485c75`n53`tDino Medium Blue`t5fa4ea`n54`tDino Deep Blue`t4568d4`n55`tNear White`tededed`n56`tNear Black`t515151`n57`tDark Turquoise`t184546`n58`tMedium Turquoise`t007060`n59`tTurquoise`t00c5ab`n60`tGreen Slate`t40594c`n61`tSage`t3e4f40`n62`tDark Warm Gray`t3b3938`n63`tMedium Warm Gray`t585553`n64`tLight Warm Gray`t9b9290`n65`tDark Cement`t525b56`n66`tLight Cement`t8aa196`n67`tLight Pink`te8b0ff`n68`tDeep Pink`tff119a`n69`tDark Violet`t730046`n70`tDark Magenta`tb70042`n71`tBurnt Sienna`t7e331e`n72`tMedium Autumn`ta93000`n73`tVermillion`tef3100`n74`tCoral`tff5834`n75`tOrange`tff7f00`n76`tPeach`tffa73b`n77`tLight Autumn`tae7000`n78`tMustard`t949428`n79`tActual Black`t000000`n80`tMidnight Blue`t191d36`n81`tDark Blue`t152b39`n82`tBlack Sands`t302531`n83`tLemon Lime`ta8ff43`n84`tMint`t38e985`n85`tJade`t008840`n86`tPine Green`t0f552e`n87`tSpruce Green`t005b45`n88`tLeaf Green`t5b9724`n89`tDark Lavender`t5e275f`n90`tMedium Lavender`t853587`n91`tLavender`tbd77be`n92`tDark Teal`t0e404a`n93`tMedium Teal`t105563`n94`tTeal`t14849c`n95`tPowder Blue`t82a7ff`n96`tGlacial`taceaff`n97`tCammo`t505118`n98`tDry Moss`t766e3f`n99`tCustard`tc0bd5e`n100`tCream`tf4ffc0`n201`tBlack Coloring`t1f1f1f`n202`tBlue Coloring`t0000ff`n203`tBrown Coloring`t756147`n204`tCyan Coloring`t00ffff`n205`tForest Coloring`t006c00`n206`tGreen Coloring`t00ff00`n207`tPurple Coloring`t6c00ba`n208`tOrange Coloring`tff8800`n209`tParchment Coloring`tffffba`n210`tPink Coloring`tff7be1`n211`tPurple Coloring`t7b00e0`n212`tRed Coloring`tff0000`n213`tRoyalty Coloring`t7b00a8`n214`tSilver Coloring`te0e0e0`n215`tSky Coloring`tbad4ff`n216`tTan Coloring`tffedb2`n217`tTangerine Coloring`tad652c`n218`tWhite Coloring`tfefefe`n219`tYellow Coloring`tffff00`n220`tMagenta Coloring`te71fd9`n221`tBrick Coloring`t94341f`n222`tCantaloupe Coloring`tff9a00`n223`tMud Coloring`t473b2b`n224`tNavy Coloring`t34346c`n225`tOlive Coloring`tbaba59`n226`tSlate Coloring`t595959"
Files2DL := [	"\Captures\OK.png"
				,"\Captures\accept.png"
				,"\Captures\cancel.png"
				,"\Captures\ArkNews2.png"]
				;,"\ColorIDs.txt"] 

Loop % Files2DL.MaxIndex(){
	FilePath := A_ScriptDir Files2DL[A_Index]
	if (RegexMatch(FilePath, "\\([A-z0-9_]{1,})\.(exe|dll|png|traineddata|manifest)$", Match)){
		FileName := Match1 "." Match2
		FileURL := "https://raw.githubusercontent.com/arodbusiness/Ark-AIO-V2/master" RegexReplace(Files2DL[A_Index], "\\", "/")
		;Tooltip, %FileName%`n%FilePath%`n%FileURL%
		;Sleep 5000


		if (!FileExist(FilePath)){
			HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Downloading " FileName "</td>"
			UrlDownloadToFile, %FileURL%, %FilePath%
			If (ErrorLevel)
				MsgBox2("Warning: " FilePath " does not exist!`nThere was an error trying to download it.", "0 r3")
		}
	}
}
;FilePath := A_ScriptDir "\bin"
;if (!FileExist(FilePath))
;	FileCreateDir, %FilePath%

FilePath := A_ScriptDir "\bin\leptonica_util"
if (!FileExist(FilePath))
	FileCreateDir, %FilePath%

;FilePath := A_ScriptDir "\bin\tesseract"
;if (!FileExist(FilePath))
;	FileCreateDir, %FilePath%

FilePath := A_ScriptDir "\bin\tesseract\tessdata_best"
if (!FileExist(FilePath))
	FileCreateDir, %FilePath%

FilePath := A_ScriptDir "\bin\tesseract\tessdata_fast"
if (!FileExist(FilePath))
	FileCreateDir, %FilePath%

;Files for VIS2 OCR - Egg Checker
Files2DL := [	"\bin\leptonica_util\leptonica_util.exe"
				,"\bin\leptonica_util\liblept168.dll"
				,"\bin\leptonica_util\Microsoft.VC90.CRT.manifest"
				,"\bin\tesseract\tesseract.exe"
				,"\bin\tesseract\tessdata_best\eng.traineddata"
				,"\bin\tesseract\tessdata_fast\eng.traineddata"] 

Loop % Files2DL.MaxIndex(){
	FilePath := A_ScriptDir Files2DL[A_Index]
	if (RegexMatch(FilePath, "\\([A-z0-9_]{1,})\.(exe|dll|png|traineddata|manifest)$", Match)){
		FileName := Match1 "." Match2
		FileURL := "https://github.com/iseahound/Vis2/blob/master" RegexReplace(Files2DL[A_Index], "\\", "/") "?raw=true" 
		
		;Tooltip, %FileName%`n%FilePath%`n%FileURL%
		;Sleep 5000


		if (!FileExist(FilePath)){
			HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">Downloading " FileName "</td>"
			UrlDownloadToFile, %FileURL%, %FilePath%
			If (ErrorLevel)
				MsgBox2("Warning: " FilePath " does not exist!`nThere was an error trying to download it.", "0 r3")
		}
	}
}
Files2DL := ""





HTMLDisplay.document.getElementById("ValidationInfo").style.display := "none"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Done with downloads, hide "status bar"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HTMLDisplay2.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"">You should not see this anymore...</td>"

;if (WinsActive())
;	Gui, 1:Show, X%WindowX% Y%WindowY% W%WindowW% H%WindowH% NA, Ark AIO
;Else
;	Gui, 1:Show, X%WindowX% Y%WindowY% W%WindowW% H%WindowH%, Ark AIO
;GoSub, SaveWindowPos

WinMove, ahk_id %MainHwnd%, , WindowX, WindowY, WindowW+16, WindowH+39			;;;;;;;;;;;;Resize Window to make normal size. shorttty
GoSub, SaveWindowPos

;Gui, 1:Remove, ActiveX, vHTMLDisplay2
GuiControl, 1: Hide, HTMLDisplay2

Menu, TreeToggleFunctions, Add, Splash Image, MenuHandler
Menu, TreeToggleFunctions, Add
Menu, TreeToggleFunctions, Add, Alerts, MenuHandler
Menu, TreeToggleFunctions, Add, Auto Click, MenuHandler
Menu, TreeToggleFunctions, Add, Auto Food Water, MenuHandler
Menu, TreeToggleFunctions, Add, Blood Pack, MenuHandler
Menu, TreeToggleFunctions, Add, Console Variables, MenuHandler
Menu, TreeToggleFunctions, Add, Crosshair, MenuHandler
Menu, TreeToggleFunctions, Add, Dino Export, MenuHandler
Menu, TreeToggleFunctions, Add, Egg Checker, MenuHandler
Menu, TreeToggleFunctions, Add, Feed Babies, MenuHandler
Menu, TreeToggleFunctions, Add, Fishing, MenuHandler
Menu, TreeToggleFunctions, Add, Gacha Farming, MenuHandler
Menu, TreeToggleFunctions, Add, Quick Transfer, MenuHandler
Menu, TreeToggleFunctions, Add, Server Info, MenuHandler
;Menu, TreeToggleFunctions, Add, Spawn Map, MenuHandler
Menu, Tray, Add, Toggle Functions, :TreeToggleFunctions

Menu, TreeUpdatePixels, Add, Check Inventory, MenuHandler
Menu, TreeUpdatePixels, Add
Menu, TreeUpdatePixels, Add, Your Search Bar, MenuHandler
Menu, TreeUpdatePixels, Add, Your Transfer All, MenuHandler
Menu, TreeUpdatePixels, Add, Your Drop All, MenuHandler
Menu, TreeUpdatePixels, Add, Your Transfer Slot, MenuHandler
Menu, TreeUpdatePixels, Add
Menu, TreeUpdatePixels, Add, Their Search Bar, MenuHandler
Menu, TreeUpdatePixels, Add, Their Transfer All, MenuHandler
Menu, TreeUpdatePixels, Add, Their Drop All, MenuHandler
Menu, TreeUpdatePixels, Add, Their Transfer Slot, MenuHandler
Menu, TreeUpdatePixels, Add
Menu, TreeUpdatePixels, Add, Structure Health - Dino XP, MenuHandler
Menu, Tray, Add, Update Pixel Coords, :TreeUpdatePixels
Menu, Tray, Add
Menu, Tray, Add, Restore, ActivateMainWindow
Menu, Tray, Default, Restore


Menu, Tray, Add, Check For Updates, CheckForUpdate
Menu, Tray, Add, Reload, ReloadSub
Menu, Tray, Add, Exit, ExitSub


oVoice := ComObjCreate("SAPI.SpVoice")
VoicesHTML := ""
Loop % oVoice.GetVoices.Count{
	VoicesHTML := VoicesHTML "`n<option value=""" A_Index """>" RegexReplace(oVoice.GetVoices.Item(A_Index-1).GetAttribute("Name"), " Desktop") "</option>"
	;oVoice.Voice := oVoice.GetVoices.Item(A_Index-1)
	;oVoice.Speak("testing 123")
}

HTMLDisplay.document.getElementById("oVoiceSelect").innerHTML := VoicesHTML
VoicesHTML := ""



Devices := {}
IMMDeviceEnumerator := ComObjCreate("{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}")
DllCall(NumGet(NumGet(IMMDeviceEnumerator+0)+3*A_PtrSize), "UPtr", IMMDeviceEnumerator, "UInt", 0, "UInt", 0x1, "UPtrP", IMMDeviceCollection, "UInt")
ObjRelease(IMMDeviceEnumerator), IMMDeviceEnumerator := ""
DllCall(NumGet(NumGet(IMMDeviceCollection+0)+3*A_PtrSize), "UPtr", IMMDeviceCollection, "UIntP", Count, "UInt")
Loop % (Count)
{
    ; IMMDeviceCollection::Item
    DllCall(NumGet(NumGet(IMMDeviceCollection+0)+4*A_PtrSize), "UPtr", IMMDeviceCollection, "UInt", A_Index-1, "UPtrP", IMMDevice, "UInt")

    ; IMMDevice::GetId
    DllCall(NumGet(NumGet(IMMDevice+0)+5*A_PtrSize), "UPtr", IMMDevice, "UPtrP", pBuffer, "UInt")
    DeviceID := StrGet(pBuffer, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "UPtr", pBuffer)

    ; IMMDevice::OpenPropertyStore
    ; 0x0 = STGM_READ
    DllCall(NumGet(NumGet(IMMDevice+0)+4*A_PtrSize), "UPtr", IMMDevice, "UInt", 0x0, "UPtrP", IPropertyStore, "UInt")
    ObjRelease(IMMDevice)

    ; IPropertyStore::GetValue
    VarSetCapacity(PROPVARIANT, A_PtrSize == 4 ? 16 : 24)
    VarSetCapacity(PROPERTYKEY, 20)
    DllCall("Ole32.dll\CLSIDFromString", "Str", "{A45C254E-DF1C-4EFD-8020-67D146A850E0}", "UPtr", &PROPERTYKEY)
    NumPut(14, &PROPERTYKEY + 16, "UInt")
    DllCall(NumGet(NumGet(IPropertyStore+0)+5*A_PtrSize), "UPtr", IPropertyStore, "UPtr", &PROPERTYKEY, "UPtr", &PROPVARIANT, "UInt")
    DeviceName := StrGet(NumGet(&PROPVARIANT + 8), "UTF-16")    ; LPWSTR PROPVARIANT.pwszVal
    DllCall("Ole32.dll\CoTaskMemFree", "UPtr", NumGet(&PROPVARIANT + 8))    ; LPWSTR PROPVARIANT.pwszVal
    ObjRelease(IPropertyStore)

    SoundDevices .= DeviceName "`n",ObjRawSet(Devices, DeviceName, DeviceID)
}
ObjRelease(IMMDeviceCollection), IMMDeviceCollection := "", pBuffer := ""

EachSoundDevice := StrSplit(substr(SoundDevices,1,strLen(SoundDevices)-2), "`n")
Loop % EachSoundDevice.MaxIndex(){
	EachSoundDevice[A_Index] := substr(EachSoundDevice[A_Index], 1, InStr(EachSoundDevice[A_Index], "(")-2)
	HTMLSoundDevices := HTMLSoundDevices "`t<option id=""" A_Index """ value=""" A_Index """ >" EachSoundDevice[A_Index] "</option>`n"
}

HTMLDisplay.document.getElementById("DefaultSoundSelect").innerHTML := HTMLDisplay.document.getElementById("OutputSoundSelect").innerHTML := HTMLSoundDevices
SoundDevices := EachSoundDevice := DeviceID := DeviceName := HTMLSoundDevices := ""



/*
IniRead, IniContents, %FileSettings2%, Main
IniLines := StrSplit(IniContents, "`n")
Loop % IniLines.MaxIndex(){
	FoundPos := RegexMatch(IniLines[A_Index], "^(.+?)=(.+?)$", Match)
	if (StrLen(Match1)>0 && StrLen(Match2)>0){
		IniRead, Temp, %FileSettings%, Main, %Match1%
		if (Temp = "ERROR")
			IniWrite, %Match2%, %FileSettings%, Main, %Match1%
	}
}
*/
iniStr := "[Main]`nAlwaysonTop=0`nWindowTrans=255`nWindowX=0`nWindowY=0`nWindowW=304`nWindowH=1009`nCrosshairCheck=1`nXhairD=8`nXhairR=255`nXhairG=0`nXhairB=24`nXhairOffsetX=0`nXhairOffsetY=-1`nWaterDelay=10000`nFoodDelay=20000`nWaterKey=8`nFoodKey=9`nQTCheck=0`nQTHotkey=F8`nQTPresetNumber=2`nQTPresetStr=Gacha Crystals`nQTDrop=0`nQTFromYou=1`nQTSearch=fab,pump,riot,mine,ass`nQTDelay=500`nQTPresetsStr=\/\/Bronto Berries||1||0||500||s,na,tha,woo\/\/Gacha Crystals||0||1||500||fab,pump,riot,mine,ass\/\/Theri Meat Farm||1||0||350||i,wo,th\/\/Theri Meat Farm||1||0||350||i,wo,th\/\/Raw Feeder||0||1||0||raw\/\/`nAlertsCheck=0`nAlertsDelay=20`nAlertsInput1=0`nAlertsInput2=0`nAlertsInput3=0`nAlertsInput4=0`nAlertsInput5=0`nAlertsInput6=0`nAlertsInput7=0`nAlertsInput8=0`nAlertAltSound=1`nFeedBabiesCheck=1`nFeedBabiesHotkey=F11`nSpinDir=0`nSpinPixels=200`nAutoClickCheck=1`nAutoClickPresetNumber=2`nAutoClickPresetsStr=\/\/Hold W||1||w||0||0\/\/Spam Left Click||0||LButton||25||0\/\/Spam F||1||f||50||0\/\/Spam e||1||e||50||0\/\/Spam t||1||t||50||0\/\/Pooper E||1||e||1000||0\/\/e||1||500||50||0\/\/e||1||500||50||0\/\/`nAutoClickPresetStr=Hold W`nAutoClickKey=f`nAutoClickHotkey=XButton2`nAutoClickSpamDelay=50`nAutoClickHoldDelay=0`nServerString=853`nServerRefresh=150`nServerInfoCheck=0`nDinoExportCheck=1`nLatestFile=E:\Program Files (x86)\Steam\steamapps\common\ARK\ShooterGame\Saved\DinoExports\76561198044849815\DinoExport_470783680204101655.ini`nCheckInvX=1814`nCheckInvY=34`nShowingSplashImageButton=1`nShowingAlertsButton=1`nShowingAutoClickButton=1`nShowingAutoFoodWaterButton=1`nShowingCrosshairButton=1`nShowingDinoExportButton=1`nShowingECButton=1`nShowingFeedBabiesButton=1`nShowingFishingButton=0`nShowingGachaFarmingButton=1`nShowingQuickTransferButton=1`nShowingServerInfoButton=1`nShowingSpawnMapButton=0`nShowingDebugButton=0`nShowingBloodPackButton=1`nYourSearchX=245`nYourSearchY=178`nYourTransferAllX=353`nYourTransferAllY=191`nYourDropAllX=407`nYourDropAllY=183`nTheirSearchX=1324`nTheirSearchY=178`nTheirTransferAllX=1479`nTheirTransferAllY=198`nTheirDropAllX=1537`nTheirDropAllY=188`nStructureHPX=793`nStructureHPY=483`nYourTransferSlotX=345`nYourTransferSlotY=278`nTheirTransferSlotX=1380`nTheirTransferSlotY=273`nAutoQTSlotCap=0`nAutoQTCapDelay=15`nAutoClickToggle=1`nFishingHotkey=F10`nFishingCheck=0`nGachaFarmingHotkey=F9`nGachaFarmingCheck=1`nCDCheck=0`nCDScreenDisp=1`nCDX=960`nCDY=995`nCDSize=24`nCDToggle=0`nCDTimeDisp=10m`nCDNotify=Hello World`nCDResetKey=f`nCDResetNumber=5`nCDFood=5000`nCDFoodRate=0.1`nCDFoodNotify=FEED BABY`nIconColor1=FF6040`nIconColor2=40FF60`nIconColor3=20CCFF`nASBinvertR=-100`nASBinvertG=-100`nASBinvertB=-100`nASBalphaR=100`nASBalphaG=100`nASBalphaB=100`nASBalpha=85`nASBgreyscale=1`nASBtime=10`nExportRaising=1`nExportStats=1`nExportColors=1`nAutoClickGuiX=1870`nAutoClickGuiY=305`nAutoClickGuiW=50`nAutoClickGuiH=230`nAutoClickGuiFontSize=12`nAutoClickUpperFill=FF0000`nAutoClickLowerFill=00FF00`nAutoClickBarFill=00FFFF`nFoodWaterGuiX=1835`nFoodWaterGuiY=855`nFoodWaterGuiW=30`nFoodWaterGuiH=115`nFeedBabiesDebugCheck=0`nFoodWaterOverlayCheck=1`nAutoClickOverlayCheck=1`nGuiMargin=5`nAutoClickSpamEpiThreshold=1000`nasbx=25`nasby=215`nasbw=300`nasbh=400`nSplashPatterns=6|7|8|9|10|30|31|32|33|34|35|36|37|38|40|42|43|44|45|51`nNameYourCheck=0`nGachaFarmingO1=0`nGachaFarmingO2=0`nGachaFarmingO3=0`nGachaFarmingDebugCheck=1`nShowingConsoleVariablesButton=1`nDebugSplash=0`nClipMutNumsCheck=1`nOfficialRatesCheck=1`nServerInfoMainCheck=0`nDebugDinoExportCheck=0`nHelenaTime=15`nHelenaXoff=-32`nHelenaYoff=-82`nHelenaX=0`nHelenaY=120`nHelenaW=400`nHelenaH=275`nHelenaA=80`nHelenaVariation=55`nCaptureHelenaCheck=1`nAutoDinoExportCheck=1`nFontFace=Times New Roman`nTAScreenDisp=1`nTAAnchor=1`nTAX=0`nTAY=0`nTASize=20`nOfficialRatesRefresh=10m`nServerFavoritesRefresh=2m`nServerFavoritesCheck=1`nDebugBabyAge=20`nDebugBaby=0`nServerFavoritesSort=1`nDefaultSoundSelect=5`nOutputSoundSelect=2`noVoiceSelect=1`nExportAnchor=2`nExportX=0`nExportY=1080`nJoinSimCheck=0`nJoinSimString=Island1`nJoinSimRefresh=2m`nBabyRates=1`nBabyRatesMult=1.0`nDebugCheckDC=0`nAlertsInput9=0`nPopcornCheck=1`nPopcornHotkey=z`nPopcornRows=3`nPopcornDelay=35`nASBLibraryX=380`nASBLibraryY=900`nExportAddLibrary=0`nExportBringFront=0`nECCurrentVal=100`nECHotkey=F5`nECCheck=0`nECLocX=382`nECLocY=408`nJoinSimVariation=75`nDesiredWindows=ahk_class UnrealWindow`nBloodPackHotkey=F5`nPlayerHP=450`nTekPodX=480`nTekPodY=1065`nTekPodX2=1236`nTekPodY2=483`nTAchosen=1`nAutoClicksAnchor=2`nAutoClicksX=1262`nAutoClicksY=1079`nExportAnchor=2`nExportX=1`nExportY=1079`nFoodCheck=0`nFoodDelay=30m`nFoodKey=9`nWaterCheck=0`nWaterDelay=15m`nWaterKey=8`nBrewCheck=0`nBrewDelay=5s`nBrewKey=0`nHPX=1888`nWaterX=1889`nWaterY=901`nFoodX=1886`nFoodY=958`nGuiOverInfoX=65`nGuiOverInfoY=3`nIconSmallW=30`nExportTextSizeTitle=16`nExportTextSize=14"
iniArr := StrSplit(iniStr, "`n")

Loop % iniArr.MaxIndex() {
	FoundPos := RegexMatch(iniArr[A_Index], "^(.+?)=(.+?)$", Match)
	if (StrLen(Match1)>0 && StrLen(Match2)>0){
		IniRead, Temp, %FileSettings%, Main, %Match1%
		if (Temp = "ERROR")
			IniWrite, %Match2%, %FileSettings%, Main, %Match1%
	}
}
iniStr := iniArr := ""

IniRead, IniContents, %FileSettings%, Main
IniLines := StrSplit(IniContents, "`n")
Loop % IniLines.MaxIndex(){
	FoundPos := RegexMatch(IniLines[A_Index], "^(.+?)=(.+?)$", Match)
	if (StrLen(Match1)>0 && StrLen(Match2)>0 && !RegexMatch(Match1, "i)FavoriteServers")){
		;Tooltip, %Match1% = %Match2%
		%Match1% := Match2
		if (Match1="AutoClickCheck")
			global AutoClickCheck := Match2
		if (RegexMatch(Match1, "Showing(.+?)Button", Matcher)){
			if (!Match2){
				HTMLDisplay.document.getElementById(Matcher1 "DropDown").style.display := "none"
			}else{
				HTMLDisplay.document.getElementById(Matcher1 "DropDown").style.display := "block"
				
				,Matcher1 := RegexReplace(Matcher1, "([A-Z]{1})([a-z]{1,})( )?([A-Z]{1})?([a-z]{1,})?( )?([A-Z]{1})?([a-z]{1,})?", "$1$2 $4$5 $7$8")
				,Matcher1 := RegexReplace(Matcher1, "([ ]{1,10})$")
				,Matcher1 := RegexReplace(Matcher1, "EC", "Egg Checker")

				try Menu, TreeToggleFunctions, Check, %Matcher1%
			}

		}else if (!RegexMatch(Match1, "Toggle|GachaFarmingO3")){
			if (RegexMatch(Match1, "AlertsInput|Check|ScreenDisp|ASBgreyscale|^DebugBaby$|^BabyRates$|Export(Raising|Stats|Colors|Add|Bring)|SpinDir|GachaFarming|QT(FromYou|Drop)|AutoQTSlotCap|ServerFavoritesSort")){
				if (Match2){
					if (RegexMatch(Match1, "^(Food|Water|Brew)Check")){
						HTMLDisplay.document.getElementById(Match1 "2").checked := Match2
					}
					HTMLDisplay.document.getElementById(Match1).checked := Match2
				}
			}else{
				if(RegexMatch(Match1, "Hotkey"))
					Match2 := RegExReplace(Match2, "~")
				HTMLDisplay.document.getElementById(Match1).value := Match2
			}
			
		}else{
			HTMLDisplay.document.getElementById(Match1 Match2).checked := 1
		}
	}
}

global DebugCheckDC
global DesiredWindows


IniLines := IniContents := ""

;;;;Need to keep this here or else
CDCheck := HTMLDisplay.document.getElementById("CDCheck").checked := 0
IniWrite, %CDCheck%, %FileSettings%, Main, CDCheck


;;;;asdfasdfasdfasdf
;;;CHECK OFFICIAL RATES ONE TIME EVEN IF UNCHECKED
;BabyMatureSpeed := EggHatchSpeed := 1.0

GoSub, GetOfficialRates


LastExportTime := ModTimeLatest := A_Now
,Exporting := 0
SetTimer, CheckDinoExport, 1000






;Font := "Arial"
Bold := ""
,TC := "FFFFFFFF"
,SC := "FF000000"
,TS := "24"
,GuiOverInfoW := A_ScreenWidth*0.75
,GuiOverInfoH := 30
,SquareSize := 18
,SquareSize2 := floor(SquareSize*0.8)
,margin := 6

ToggleKey := GachaFarmingCheck ? GachaFarmingHotkey : FeedBabiesCheck ? FeedBabiesHotkey : FishingCheck ? FishingHotkey : BloodPackCheck ? BloodPackHotkey : ""
LastTSTEnabled := 0 
LastDisplayStr := ""


DCY := 0.555*A_ScreenHeight ;;;;.551-.574
,DCX1 := 0.390*A_ScreenWidth ;;;;.368
,DCX2 := 0.450*A_ScreenWidth ;;;;;.470
,DCX3 := 0.550*A_ScreenWidth ;;;;;.528
,DCX4 := 0.600*A_ScreenWidth ;;;;;.629

,NameYourX1 := round(0.45*A_ScreenWidth)
,NameYourY1 := round(0.6*A_ScreenHeight)
,NameYourX2 := round(0.55*A_ScreenWidth)
,NameYourY2 := round(0.7*A_ScreenHeight)


global NewURL 								;DO NOT REMOVE GLOBAL				"AutoClickPreset/" AutoClickPresetNumber, "QTPreset/" QTPresetNumber, "UpdateAutoClick",  "UpdateQT",
NewURLs := [	"CDToggle" CDToggle 				;display
				,"ExportColoringToggle"				;display
				,"GachaFarmingO1"					;display
				,"UpdateAlerts"						;timer set and update
				,"UpdateCountdown"					;update
				,"UpdateSoundDevices"
				,"UpdateFeedBabies"					;hotkey set
				,"UpdateGachaFarming"				;hotkey set - display
				,"UpdateEC"							;hotkey set
				,"UpdateFishing"					;hotkey set
				,"UpdateJoinSimSettings"			;timer set and update
				,"UpdateServerFavoritesSettings" 	;timer set and update
				,"UpdateOfficialRatesSettings" 		;timer set and update
				,"UpdateBloodPack"]					;hotkey set

Loop % NewURLs.MaxIndex(){
	NewURL := NewURLs[A_Index]
	GoSub, myappBrowserFunction
	;if (RegexMatch(A_Index, "1|2"))						;CDToggle
	;	HTMLDisplay.document.getElementById(NewURL).checked := 1
	;;;;;;;;9-10 RAM JUMP
	;Tooltip, Test - %A_Index%
	;Sleep 3000
}
NewURLs := NewURL := ""

GoSub, UpdatePresets

NewURL := "UpdateAutoClick"
GoSub, myappBrowserFunction
HTMLDisplay.document.getElementById("AutoClickPresetNumber").value := AutoClickPresetNumber

NewURL := "UpdateQT"
GoSub, myappBrowserFunction
HTMLDisplay.document.getElementById("QTPresetNumber").value := QTPresetNumber

HTMLDisplay.document.getElementById("ExportRaisingContent").style.display := ExportRaising ? "table" : "none"
HTMLDisplay.document.getElementById("ExportRaisingContent").width := "100%"
HTMLDisplay.document.getElementById("ExportStatsContent").style.display := ExportStats ? "table" : "none"
HTMLDisplay.document.getElementById("ExportStatsContent").width := "100%"
HTMLDisplay.document.getElementById("ExportColorsContent").style.display := ExportColors ? "table" : "none"
HTMLDisplay.document.getElementById("ExportColorsContent").width := "100%"


if (FileExist(ExportDir)){
	TotalExportFiles := 0
	Loop, Files, %ExportDir%\*.ini, R 
		TotalExportFiles := TotalExportFiles + 1
}
HTMLDisplay.document.getElementById("TotalExports").value := "Clean Exports (" TotalExportFiles ")"


GuiBackgroundBrush := Gdip_BrushCreateSolid("0x66000000")		;BackGround
,AutoClickBrush := Gdip_BrushCreateSolid("0x66" AutoClickUpperFill)		;Red
,AutoClickBrush2 := Gdip_BrushCreateSolid("0x66" AutoClickLowerFill)		;Green
;,FoodWaterBrush := Gdip_BrushCreateSolid("0x0A" FoodWaterColor)
;,FoodWaterBrush2 := Gdip_BrushCreateSolid("0x66" FoodWaterColor)


TAmarginX := 1
TAmarginY := 2
LineLen := TASize*1.5
TASX := floor(TASize/12)				;BuildTimedAlertsGUI
TASY := floor(TASize/12)				;BuildTimedAlertsGUI
UpdateingTA := 0
GoSub, BuildTimedAlertsGUI
GoSub, UpdateTimedAlerts
SetTimer, UpdateTimedAlerts, 2000


QTinProgress := 0
EnabledText := "OFF"



SetTimer, UpdateGUI, 50

NotActive := 0
SetTimer, Loop1Sec, 1000
SetTimer, NotifyFinishCheck, 10000

;SetTimer, MakeSplashImage, 5000      ;cpu usage about 5% out of game....
SetTimer, MakeSplashImage, 5000
;Causing weird windows issue and splash icon to disapear?


SlotInc := A_ScreenHeight=1080 || A_ScreenHeight=1440 ? 93 : 82



;REMOVE LATER
global AutoClicksActiveArr := []
global AutoClicksHoldingArr := []
global AutoClicksPressKeyArr := []
global AutoClicksNextTimeArr := []
global AutoClicksNextTimeMSArr := []
global AutoClicksKeyUpTimeArr := []
global AutoClicksKeyUpTimeMSArr := []
global AutoClicksActiveHotkeys := []

GoSub, BuildAutoClicks

LastFood := LastWater := LastBrew := 0
NextFoodTime := NextWaterTime := NextBrewTime := NextSSTime := A_Now
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;ALL ABOVE IS START UP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Loop{												;;;MAIN LOOP HERE
	if (PopcornCheck && WinsActive()){
		Popcorning := GetKeyState(PopcornHotkey, P) && GetKeyState("LShift", P) && GetKeyState("LControl", P) && CheckInv() ? 1 : 0
		PopcornI := 1
		While (GetKeyState(PopcornHotkey, P) && GetKeyState("LShift", P) && GetKeyState("LControl", P) && CheckInv()){
			

			if (PopcornI=1){
				Sleep % PopcornDelay
				MouseClick, Left, TheirTransferAllX, TheirTransferAllY, 3, 2
				Sleep % PopcornDelay
			}else{
				CurrentSlotY := YourTransferSlotY+PopcornRows*SlotInc-(PopcornI-1)*SlotInc
				,CurrentSlotX := YourTransferSlotX+5*SlotInc
				if (PopcornI!=1){
					Loop, 6 {	;;;N Columns
						
						MouseMove, %CurrentSlotX%, %CurrentSlotY%, 1
						Sleep % PopcornDelay
						Send {o 5}

						CurrentSlotX := CurrentSlotX-SlotInc
					}
				}
			}
			PopcornI := PopcornI=PopcornRows+1 ? 1 : PopcornI+1
		}
	}

	if (WinsActive()){
		Loop % AutoClicksArr.MaxIndex() {
			FoundPos := RegexMatch(AutoClicksArr[A_Index], "^(.+?)\|\|(.+?)\|\|(.+?)\|\|(.+?)$", AutoClicksMatch)
			if (FoundPos && StrLen(AutoClicksArr[A_Index])>6){
				AutoClicksPresetNum := AutoClicksMatch1
				AutoClicksHotkey := AutoClicksMatch2
				AutoClicksEnabled := AutoClicksMatch3
				AutoClicksToggle := AutoClicksMatch4

				if (AutoClicksHotkey!="..."){
					;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
					;;This is for Holding
					if (!AutoClicksToggle && AutoClicksEnabled){
						if (GetKeyState(AutoClicksHotkey, P)){
							if (!AutoClicksActiveArr[A_Index]){
								FoundPos := RegexMatch(AutoClickPresetsArr[AutoClicksPresetNum], "\-\-\-(.+?)\|\|(.+?)\|\|(.+?)\|\|(.+?)\|\|(.+?)$", AutoClicksMatch)
								AutoClicksPressKey := Func("AutoClicksPressKey").bind(A_Index, AutoClicksMatch3, AutoClicksMatch4, AutoClicksMatch5)
								AutoClicksPressKeyArr[A_Index] := AutoClicksPressKey
								AutoClicksActiveArr[A_Index] := 1
								SetTimer, %AutoClicksPressKey%, %AutoClicksMatch4%
							}
						}else{
							if (AutoClicksActiveArr[A_Index]){
								AutoClicksActiveArr[A_Index] := 0
								SetTimer, %AutoClicksPressKey%, off
							}
						}
					}
				}
			}	

		}
	}



	if (BloodPackCheck && BloodPackEnabled && WinsActive() && ReplenishReadyTime<A_Now){

		if (BloodPackCheck && BloodPackEnabled && WinsActive()){
			BloodPackDispStr := "Get out of Pod and Wait"
			Send {e down}
			sleep 40
			Send {e up}
			Sleep 3000
		}


		if (BloodPackCheck && BloodPackEnabled && WinsActive()){
			BloodPackDispStr := "Look at Pod"
			Sleep 500
			;MouseMove, TekPodX, TekPodY, 15, R

			DllCall("mouse_event", "UInt", 1, "UInt", TekPodX, "UInt", TekPodY)


			Sleep 1250
		}


		if (BloodPackCheck && BloodPackEnabled && WinsActive()){
			BloodPackDispStr := "Open Inventory"
			Sleep 250
			Send {i}
			Sleep 500
		}



		Loop % MaxPacks-1
		{
			if (BloodPackCheck && BloodPackEnabled && WinsActive()){
				if (CheckInv()){
					MouseClick, Left, YourTransferSlotX, YourTransferSlotY
					Sleep 100
					Send {e}
					BloodPackDispStr  := "Making Blood Packs " A_Index "/" MaxPacks
					Sleep 6000
				}else{
					BloodPackDispStr  := "Unable to find Inventory"
				}
			}
			
		}




		if (BloodPackCheck && BloodPackEnabled && WinsActive() && CheckInv()){
			MouseClick, Left, YourTransferSlotX, YourTransferSlotY, 1, 3
			Sleep 100
			Send {e}
			BloodPackDispStr := "Making Blood Packs " MaxPacks "/" MaxPacks
			Sleep 500
			Send {Esc}
			Sleep 1000
		}



		if (BloodPackCheck && BloodPackEnabled && WinsActive()){
			BloodPackDispStr := "Get Back in Pod"
			Send {e down}
			Sleep 1000
			MouseMove, TekPodX2, TekPodY2, 5, R
			Sleep 300
			Send {e up}
		}
		
		ReplenishReadyTime := A_Now
		EnvAdd, ReplenishReadyTime, floor(ReplenishTime/1000), s
		

	}else if (BloodPackCheck && BloodPackEnabled && ReplenishReadyTime>A_Now){

		if (WinsActive()){
			ReplenishRemaining := ReplenishReadyTime
			EnvSub, ReplenishRemaining, A_Now, s

			BloodPackDispStr := "Laying in Pod for " ReplenishRemaining "s"
		}else{
			ReplenishRemaining := 0
		}
	}




	if (FeedBabiesCheck){
		if (FeedBabiesEnabled && WinsActive() && !QTinProgress && !GachaFarming){
			FeedBabiesDispStr := "Rotating"
			;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr		
			,SpinKey := SpinDir ? "Right" : "Left"
			
			Send {%SpinKey% down}
			Sleep %SpinPixels%
			Send {%SpinKey% up}
			

			;ActualSpin := SpinDir ? SpinPixels : -SpinPixels
			;DllCall("mouse_event", "UInt", 0x01, "UInt", ActualSpin, "UInt", 0)
			Sleep 250
			Send {f}
			FeedBabiesDispStr := "Looking For Inventory"
			;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
			Sleep 1500
		}
		if (FeedBabiesEnabled && CheckInv() && WinsActive() && !QTinProgress && !GachaFarming){
			FeedBabiesDispStr := "Found Inventory"
			;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
			
			PixelGetColor, Color, %StructureHPX%, %StructureHPY%
			B := Color >> 16 & 0xFF, G := Color >> 8 & 0xFF, R := Color & 0xFF
			if (FeedBabiesEnabled && WinsActive() && !QTinProgress && !GachaFarming){
				;BlockInput, MouseMove
				;if (R<20 && G>65 && B>100){							;;;;;;IN Food Supply
				if (R<30 && G>35 && B<55){
					FeedBabiesDispStr := "Food Supply"
					;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
					;,babiesX := TheirTransferSlotX
					;,babiesY := TheirTransferSlotY
					,babiesX := TheirTransferAllX
					,babiesY := TheirTransferAllY

					Sleep 1000

					if (FeedBabiesString!=""){
						MouseClick, Left, YourSearchX, YourSearchY, 1
						Sleep 250
						Send %FeedBabiesString%
						Sleep 500
					}

					;MouseClick, Left, YourTransferAllX, YourTransferAllY, 1
					;Sleep 250

					if (FeedBabiesString!=""){
						MouseClick, Left, TheirSearchX, TheirSearchY, 1
						Sleep 250
						Send %FeedBabiesString%
						Sleep 500
					}

					MouseClick, Left, TheirTransferSlotX, TheirTransferSlotY, 1
					

					Sleep 500
				}else{												;;;;;;IN Baby
					FeedBabiesDispStr := "Feed Baby"
					;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
					;,babiesX := YourTransferSlotX
					;,babiesY := YourTransferSlotY
					,babiesX := YourTransferAllX
					,babiesY := YourTransferAllY




					Sleep 1000
					if (FeedBabiesString!=""){
						MouseClick, Left, YourSearchX, YourSearchY, 1
						Sleep 250
						Send %FeedBabiesString%
						Sleep 500
					}

					MouseClick, Left, YourTransferSlotX, YourTransferSlotY, 1
					
					Sleep 500
				}
			}
			if (FeedBabiesEnabled && CheckInv() && WinsActive() && !QTinProgress && !GachaFarming){
				FeedBabiesDispStr := "Transfering Food"
				;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
				MouseClick, Left, babiesX, babiesY, 1
				Sleep 1000
			
			}
/*
			if (FeedBabiesEnabled && CheckInv() && WinsActive() && !QTinProgress && !GachaFarming){
				FeedBabiesDispStr := "Transfering Food"
				;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
				MouseMove, babiesX, babiesY, 5
				Sleep 100
				Loop, 5{
					if (FeedBabiesEnabled && WinsActive() && !QTinProgress && !GachaFarming)
						Send {t}
					Else
						break
					Sleep 500
				}
			}
*/


			if (FeedBabiesEnabled && WinsActive() && !QTinProgress && !GachaFarming)
				Send {f}
			FeedBabiesDispStr := "Exit Inventory"
			;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
			Sleep 500
		}else{
			if (FeedBabiesEnabled && WinsActive() && !QTinProgress && !GachaFarming){
				FeedBabiesDispStr := "No Inventory Found"
				;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
			}
		}
	}else{
		FeedBabiesDispStr := "Waiting..."
		;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
	}




	if (CDCheck){
		if (CDToggle=0 || CDToggle=1){
			if(NotifySpamN<=CDResetNumber || CDToggle=1){
				
				CurrentTimeNotify := A_Now
				EnvSub, CurrentTimeNotify, NotifyAFKTime, Seconds

				;Tooltip, %MaxTimeNotify%`n%CurrentTimeNotify%
				if (MaxTimeNotify<CurrentTimeNotify)
					CurrentTimeNotify := MaxTimeNotify
				NotifyAFKTimeStr := SecondsToString(MaxTimeNotify-CurrentTimeNotify)
				,HTMLDisplay.document.getElementById("CDRemTime").value := NotifyAFKTimeStr
				,NotifyCurrentR := Min(0.0256*Exp(3.667*CurrentTimeNotify/MaxTimeNotify), 1)
				,NotifyCurrentG := 1-NotifyCurrentR
			}
		}else if(CDToggle=2){
			SecondsSince := A_Now
			EnvSub, SecondsSince, NotifyFoodStartT, s



			CDFoodRem := round(CDFood - CDFoodRate * SecondsSince,1)
			,HTMLDisplay.document.getElementById("CDFoodRem").value := CDFoodRem

			,CDRemTime := CDFoodRem/CDFoodRate>0 ? SecondsToString(CDFoodRem/CDFoodRate) : "OUT OF FOOD!"
			,HTMLDisplay.document.getElementById("CDRemTime").value := CDRemTime

			,FoodNotifyText := "Food Left: " CDFoodRem
			,FoodNotifyText := CDFoodRem<=0 ? FoodNotifyText "   -   " CDFoodNotify : FoodNotifyText
			,NotifyCurrentR := CDFoodRem>0 ? Min(0.0256*Exp(3.667*(1.0-(CDFoodRem/CDFood))), 1.0) : 1.0
		}


		NotifyCurrentG := 1.0-NotifyCurrentR
		,NotifyR := Dec2Hex(255*NotifyCurrentR)
		,NotifyG := Dec2Hex(255*NotifyCurrentG)
		,NotifyB := "00"
		,NotifyColor := NotifyR NotifyG NotifyB
	
		;Tooltip, %NotifyR%`n%NotifyG%`n%NotifyB%

		,NotifyColorLast := NotifyColorLast!=NotifyColor ? NotifyColor : NotifyColorLast
		,NotifyText := CDToggle=1 ? "Closing Game in " NotifyAFKTimeStr : CDToggle=2 ? FoodNotifyText : RegexReplace(CDResetKey, "([a-z]{1})", "$U1") ": " NotifySpamN "    " CDNotify " - " NotifyAFKTimeStr
	}
		
	Sleep 20   ;;;If no SLeep.... CPU Hog
}
Return


WindowSpyFn:
	Drives := StrSplit(Alphabet)
	Loop % Drives.MaxIndex(){
		CurrentFile := Drives[A_Index] ":\Program Files\AutoHotkey\WindowSpy.ahk"
		if (FileExist(CurrentFile)){
			Run, %CurrentFile%
			break
		}
	}
	Drives := ""
Return


EndCancelNameYour:
	SetTimer, CancelNameYour, off
	CancelingName := 0
	if (DebugNamingWindowCheck)
		Tooltip
return

CancelNameYour:
	;ArkhwndNY := WinsActive()
	if (WinsActive() && CancelingName){
		pBitmapHaystackNameYour := Gdip_BitmapFromHWND(WinsActive())
		,pBitmapNeedleNameYour1 := Gdip_CreateBitmapFromFile(CapDir "\accept.png")
		,pBitmapNeedleNameYour2 := Gdip_CreateBitmapFromFile(CapDir "\cancel.png")
		,Gdip_ImageSearch(pBitmapHaystackNameYour, pBitmapNeedleNameYour1, OutputListNameYour, NameYourX1, NameYourY1, NameYourX2, NameYourY2, 72)

		;ImageSearch, NameYourX, NameYourY, NameYourX1, NameYourY1, NameYourX2, NameYourY2, *69 %CapDir%\accept.png
		;ErrorLevel3 := ErrorLevel
		;if (!ErrorLevel3){

		if (OutputListNameYour!=""){	
			NameYourX := SubStr(OutputListNameYour, 1, InStr(OutputListNameYour, ",")-1), NameYourY := SubStr(OutputListNameYour, InStr(OutputListNameYour, ",")+1)
			if (DebugNamingWindowCheck)
				Tooltip, Accept, NameYourX+100, NameYourY+20

			;ImageSearch, NameYourX, NameYourY, NameYourX1, NameYourY1, NameYourX2, NameYourY2, *69 %CapDir%\cancel.png
			;ErrorLevel4 := ErrorLevel
			;if (!ErrorLevel4){

			Gdip_ImageSearch(pBitmapHaystackNameYour, pBitmapNeedleNameYour2, OutputListNameYour, NameYourX1, NameYourY1, NameYourX2, NameYourY2, 72)
			if (OutputListNameYour!=""){	
				NameYourX := SubStr(OutputListNameYour, 1, InStr(OutputListNameYour, ",")-1), NameYourY := SubStr(OutputListNameYour, InStr(OutputListNameYour, ",")+1)
				if (DebugNamingWindowCheck)
					Tooltip, Accept, NameYourX+100, NameYourY+20
				GoSub, EndCancelNameYour
				GoSub, KillDebugGUI
				MouseMove, NameYourX, NameYourY, 0
				Send {LButton 2}
				;Sleep 50
				;Send {LButton up}
				;Sleep 50
				;ErrorLevel4 := 1
			}
			;ErrorLevel3 := 1
		}
		Gdip_DisposeImage(pBitmapHaystackNameYour)
		,Gdip_DisposeImage(pBitmapNeedleNameYour1)
		,Gdip_DisposeImage(pBitmapNeedleNameYour2)
	}else{
		if (DebugNamingWindowCheck)
			Tooltip, No Window Found..
	}
return


BuildNotifyGUI: 							;COUNTDOWN
	NotifySX := floor(CDSize/12)
	NotifySY := floor(CDSize/12)


	ShowingGuiNotify := 1
	Gui, 5:Destroy
	Gui, 5:New, -Caption +E0x80000 +E0x20 +AlwaysOnTop +ToolWindow +OwnDialogs +LastFound +HwndNotifyHwnd ; Create GUI
	Gui, 5:Show, NA, Notify GUI
	;Gui, 5:New, +HwndNotifyHwnd

	;Calculate WIDTH AND HEIGHT
	CDX := CDX="" ? 0 : CDX
	CDY := CDY="" ? 0 : CDY
	CDW := 600
	CDH := CDSize+10
	hbm5 := CreateDIBSection(CDW+2, CDW+2) ; Create a gdi bitmap drawing area
	,hdc5 := CreateCompatibleDC() ; Get a device context compatible with the screen
	,obm5 := SelectObject(hdc5, hbm5) ; Select the bitmap into the device context
	,pGraphics5 := Gdip_GraphicsFromHDC(hdc5) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	,Gdip_SetSmoothingMode(pGraphics5, 4) ; Set the smoothing mode to antialias = 4 to make shapes appear smother

	
return

BuildTimedAlertsGUI:
;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

	ShowingGuiTA := 1
	Gui, 11:Destroy
	Gui, 11:New, -Caption +E0x80000 +E0x20 +AlwaysOnTop +ToolWindow +OwnDialogs +LastFound +HwndTAHwnd ; Create GUI
	Gui, 11:Show, NA, Timed Alerts GUI

	;Calculate WIDTH AND HEIGHT
	IniRead, TimedAlerts, %FileSettings%, Main, TimedAlerts
	TempArr := StrSplit(substr(TimedAlerts, 4, StrLen(TimedAlerts)-6),"~~~")
	,Rows := TempArr.MaxIndex()
	,LongestTAtitle := LongestOutputTime := 0
	Loop % TempArr.MaxIndex(){
		FoundPos := RegexMatch(TempArr[A_Index], "^(.+?)\|\|\|(.+?)$", TAMatch)
		LongestTAtitle := FoundPos && StrLen(TAMatch2)>LongestTAtitle ? StrLen(TAMatch2) : LongestTAtitle
		,EndTime := EndTime2 := TAMatch1
		,StartTime := StartTime2 := A_Now
		if (EndTime2>StartTime){
			EnvSub, EndTime, StartTime, s
			;Tooltip, %EndTime%
			OutputTimeD := EndTime/60/60/24
		}
		else{
			EnvSub, StartTime, EndTime, s
			;Tooltip, -%StartTime%
			OutputTimeD := StartTime/60/60/24
		}
		LongestOutputTime := LongestOutputTime<OutputTimeD ? OutputTimeD : LongestOutputTime
	}
	OutputTimeD := LongestOutputTime
	OutputTimeH := (OutputTimeD - floor(OutputTimeD))*24,OutputTimeM := (OutputTimeH - floor(OutputTimeH))*60,OutputTimeS := (OutputTimeM - floor(OutputTimeM))*60
	,OutputTimeDDisp := floor(OutputTimeD),OutputTimeHDisp := floor(OutputTimeH),OutputTimeMDisp := floor(OutputTimeM),OutputTimeSDisp := floor(OutputTimeS)

	,OutputTimeDDisp := OutputTimeDDisp != "" && OutputTimeDDisp != 0 ? OutputTimeDDisp "d " : ""
	,OutputTimeHDisp := OutputTimeHDisp != "" && OutputTimeHDisp != 0 ? OutputTimeHDisp "h " : ""
	,OutputTimeMDisp := OutputTimeMDisp != "" && OutputTimeMDisp != 0 ? OutputTimeMDisp "m " : ""
	,OutputTimeSDisp := OutputTimeSDisp != "" && OutputTimeSDisp != 0 ? OutputTimeSDisp "s" : "0s"
	;Tooltip, %OutputTimeDDisp%`n%OutputTimeHDisp%`n%OutputTimeMDisp%`n%OutputTimeSDisp%


	OutputTimeSDisp := StrLen(OutputTimeDDisp)>0 ? "" : OutputTimeSDisp


	LongestOutputTime := StrLen(OutputTimeDDisp OutputTimeHDisp OutputTimeMDisp OutputTimeSDisp)

	TempArr := ""
	TAW := round((TASize*0.48*LongestTAtitle))+180+TASize
	;TAW := 250+(TASize*0.57*LongestTAtitle)
	,TAH := 10+(TASize+2)*Rows

	;Tooltip, %Rows%`n%TAH%
	,hbm11 := CreateDIBSection(TAW+2, TAW+2) ; Create a gdi bitmap drawing area
	,hdc11 := CreateCompatibleDC() ; Get a device context compatible with the screen
	,obm11 := SelectObject(hdc11, hbm11) ; Select the bitmap into the device context
	,pGraphics11 := Gdip_GraphicsFromHDC(hdc11) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	,Gdip_SetSmoothingMode(pGraphics11, 4) ; Set the smoothing mode to antialias = 4 to make shapes appear smother
	
return




UpdateGUI:
	if (DisplayingMessage){
		if (!OverlayShowing){
			GoSub, TST_On
		}
	}else if (WinsActive()){

		if (CDCheck && CDScreenDisp){
			if (!ShowingNotifyGui){
				Gui, 5:Show, NA
				ShowingNotifyGui := 1
			}

			if (NotifyTextLast!=NotifyText && !QTinProgress){
				NotifyTextLast := NotifyText

				Gdip_GraphicsClear(pGraphics5, 0x00000000)
				,Gdip_TextToGraphics(pGraphics5, NotifyText, "x" NotifySX " y" NotifySY " w" CDW " h" CDH " Left vCenter Bold cFF000000 s" CDSize, FontFace)
				,Gdip_TextToGraphics(pGraphics5, NotifyText, "x" 0 " y" 0 " w" CDW " h" CDH " Left vCenter Bold cFF" NotifyColor " s" CDSize, FontFace)
				,UpdateLayeredWindow(NotifyHwnd, hdc5, CDX, CDY, CDW, CDH)
			}
		}


		if (!OverlayShowing && (DebugCheck || (FeedBabiesCheck && FeedBabiesDebugCheck) || (GachaFarmingCheck && GachaFarmingDebugCheck) || (FishingCheck && FishingDebugCheck) || (ECCheck) || (BloodPackCheck && BloodPackDebugCheck))){
			GoSub, TST_On
			ForceShow := 1
		}

		;Tooltip, %ToggleKey%`n%FeedBabiesHotkey%`n%FeedBabiesCheck%`n%FeedBabiesDebugCheck%`n%LastTSTEnabled%`n%LastDisplayStr%

		if (!DisplayingMessage){	
			if (DebugCheck && (LastDisplayStr!=DebugDispStr || ForceShow)){
				ForceShow := 0
				TSTEnabled := 1
				,TSTHotkey := ""
				;,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
				,TSTText := DebugDispStr
				GoSub, TST_Update
			}else if (ToggleKey=FeedBabiesHotkey && FeedBabiesCheck && FeedBabiesDebugCheck && (LastTSTEnabled!=FeedBabiesEnabled || LastDisplayStr!=FeedBabiesDispStr || ForceShow)){
				ForceShow := 0
				TSTEnabled := FeedBabiesEnabled
				,TSTHotkey := FeedBabiesHotkey
				,FeedBabiesDispStr := FeedBabiesEnabled ? FeedBabiesDispStr : "Waiting to start Feed Babies Spinner"
				,HTMLDisplay.document.getElementById("FeedBabiesDebugInfo").value := FeedBabiesDispStr
				,TSTText := FeedBabiesDispStr
				GoSub, TST_Update
			}else if (ToggleKey=GachaFarmingHotkey && GachaFarmingCheck && GachaFarmingDebugCheck && (LastTSTEnabled!=GachaFarming || LastDisplayStr!=GachaFarmingDispStr || ForceShow)){
				ForceShow := 0
				TSTEnabled := GachaFarming
				,TSTHotkey := GachaFarmingHotkey
				,GachaFarmingDispStr := GachaFarming ? GachaFarmingDispStr : "Waiting to start Gacha Farming"
				,HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
				,TSTText := GachaFarmingDispStr
				GoSub, TST_Update
			}else if (ToggleKey=FishingHotkey && FishingCheck && FishingDebugCheck && !DisplayingMessage && (LastTSTEnabled!=FishingEnabled || LastDisplayStr!=FishingDispStr || ForceShow)){
				ForceShow := 0
				TSTEnabled := FishingEnabled
				,TSTHotkey := FishingHotkey
				,FishingDispStr := FishingEnabled ? FishingDispStr : "Waiting to start Fishing"
				,HTMLDisplay.document.getElementById("FishingDebugInfo").value := FishingDispStr
				,TSTText := FishingDispStr
				GoSub, TST_Update
			}else if (ToggleKey=BloodPackHotkey && BloodPackCheck && BloodPackDebugCheck && (LastTSTEnabled!=BloodPackEnabled || LastDisplayStr!=BloodPackDispStr || ForceShow)){
				ForceShow := 0
				TSTEnabled := BloodPackEnabled
				,TSTHotkey := BloodPackHotkey
				,BloodPackDispStr := BloodPackEnabled ? BloodPackDispStr : "Lay in Tek Pod then start Blood Pack"
				,HTMLDisplay.document.getElementById("BloodPackDebugInfo").value := BloodPackDispStr
				,TSTText := BloodPackDispStr
				GoSub, TST_Update
			}
		}


		if (CrosshairCheck && !ReticleDrawn){
			GoSub, drawCrosshair
			ReticleDrawn := 1
		}



		if (AutoClickOverlayCheck && AutoClickCheck && !ShowingAutoClickGui){
			ShowingAutoClickGui := 1
			Gui, 8:Destroy
			Gui, 8:-Caption +E0x80000 +E0x20 +HwndAutoClickhwnd +AlwaysOnTop +ToolWindow +OwnDialogs -Caption -DPIScale +LastFound ; Create GUI
			Gui, 8:Show, NA


			AutoClickGuiActualW := AutoClicksArr.MaxIndex()*AutoClickGuiW

			AutoClicksActualX := AutoClicksAnchor=1 || AutoClicksAnchor=2 ? AutoClicksX : AutoClicksX-AutoClickGuiActualW
			AutoClicksActualY := AutoClicksAnchor=1 || AutoClicksAnchor=3 ? AutoClicksY : AutoClicksY-AutoClickGuiH

			hbm8 := CreateDIBSection(AutoClickGuiActualW, AutoClickGuiH) ; Create a gdi bitmap drawing area
			,hdc8 := CreateCompatibleDC() ; Get a device context compatible with the screen
			,obm8 := SelectObject(hdc8, hbm8) ; Select the bitmap into the device context
			
			,pGraphics8 := Gdip_GraphicsFromHDC(hdc8) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
			,Gdip_SetSmoothingMode(pGraphics8, 4)

		}else if(ShowingAutoClickGui && !AutoClickOverlayCheck){
			Gui, 8:Destroy
			ShowingAutoClickGui := 0

			,SelectObject(hdc8, obm8) ; Select the object back into the hdc
			,DeleteObject(hbm8) ; Now the bitmap may be deleted
			,DeleteDC(hdc8) ; Also the device context related to the bitmap may be deleted
			,Gdip_DeleteGraphics(pGraphics8)
		}
		

		if (AutoClickOverlayCheck && AutoClickCheck && ShowingAutoClickGui){
			Gdip_GraphicsClear(pGraphics8, 0x00000000)
			Temp := "AutoClickGuiActualW := " AutoClickGuiActualW "`nAutoClickGuiW := " AutoClickGuiW "`n"
			AutoClickToggleColor := AutoClickEnabled ? "FF00FF00" : "77FFFFFF"  ;"FF666666"
			Loop % AutoClicksArr.MaxIndex(){

				FoundPos := RegexMatch(AutoClicksArr[A_Index], "^(.+?)\|\|(.+?)\|\|(.+?)\|\|(.+?)$", AutoClicksMatch)
				if (FoundPos && StrLen(AutoClicksArr[A_Index])>6 && AutoClicksMatch3){
					AutoClicksPresetNum := AutoClicksMatch1
					AutoClicksHotkeyDisp := AutoClicksMatch2
					AutoClicksHotkeyDisp := RegexReplace(AutoClicksHotkeyDisp, "i)Button", "MB")
					AutoClicksHotkeyDisp := RegexReplace(AutoClicksHotkeyDisp, "([a-z])", "$U1")

					AutoClicksEnabled := AutoClicksMatch3
					AutoClicksToggle := AutoClicksMatch4
					AutoClicksChecked := AutoClicksEnabled ? "checked" : ""
					FoundPos := RegexMatch(AutoClickPresetsArr[AutoClicksPresetNum], "\-\-\-(.+?)\|\|(.+?)\|\|(.+?)\|\|(.+?)\|\|(.+?)$", AutoClicksMatch)
					AutoClicksKeyDisp := AutoClicksMatch3
					AutoClicksKeyDisp := RegexReplace(AutoClicksKeyDisp, "i)Button", "MB")
					AutoClicksKeyDisp := RegexReplace(AutoClicksKeyDisp, "([a-z])", "$U1")

					AutoClicksKeyDisp := GachaFarmingCheck ? RegexReplace(AutoClicksKeyDisp, "i)" GachaFarmingHotkey, "gacha") : AutoClicksKeyDisp
					AutoClicksKeyDisp := QTCheck ? RegexReplace(AutoClicksKeyDisp, "i)" QTHotkey, "QT") : AutoClicksKeyDisp

					if (AutoClicksKeyDisp!="..."){

						AutoClicksSpamDelay := AutoClicksMatch4
						AutoClicksHoldDelay := AutoClicksMatch5

						;global TSTText := "Choose Growth Direction: 1)Up     2)Right     3)Down     4)Left"
						;global TSTText := "Choose Anchor Point: 1)Top Left     2)Bottom Left     3)Top Right     4)Bottom Right"

						AutoClicksBackgroundSmallH := 2*AutoClickGuiFontSize+4*GuiMargin

						

						AutoClicksCurrX := AutoClicksAnchor=1 || AutoClicksAnchor=2 ? AutoClickGuiW*(A_Index-1)-(A_Index-1) : AutoClickGuiActualW-(AutoClickGuiW*(A_Index)-(A_Index))
						AutoClicksCurrY := AutoClicksAnchor=1 || AutoClicksAnchor=3 ? 0 : AutoClickGuiH


						AutoClicksHotkeyDispY := AutoClicksAnchor=1 || AutoClicksAnchor=3 ? AutoClicksCurrY+1.5*GuiMargin : AutoClicksCurrY-GuiMargin-AutoClickGuiFontSize
						AutoClicksKeyDispY := AutoClicksAnchor=1 || AutoClicksAnchor=3 ? AutoClicksCurrY+3*GuiMargin+AutoClickGuiFontSize : AutoClicksCurrY-2*GuiMargin-2*AutoClickGuiFontSize
						AutoClicksWrapperBarY := AutoClicksAnchor=1 || AutoClicksAnchor=3 ? AutoClicksCurrY+2*GuiMargin+AutoClickGuiFontSize : AutoClicksCurrY-2.5*GuiMargin-2*AutoClickGuiFontSize
						AutoClicksBackgroundY := AutoClicksAnchor=1 || AutoClicksAnchor=3 ? AutoClicksCurrY :  AutoClicksCurrY-AutoClickGuiH
						AutoClicksBackgroundMiniY := AutoClicksAnchor=1 || AutoClicksAnchor=3 ? 0 :  AutoClicksKeyDispY-GuiMargin

						AutoClicksSpamKeyColor := AutoClicksActiveArr[A_Index] ? "FF" AutoClickBarFill : "77FFFFFF"
						AutoClicksHotKeyColor := AutoClicksActiveArr[A_Index] ? "FF00FF00" : "77FFFFFF"  ;"FF666666"

						;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
						AutoClickTempH := AutoClickGuiH-3*GuiMargin-AutoClickGuiFontSize
						if(AutoClicksActiveArr[A_Index] && AutoClicksSpamDelay>=AutoClickSpamEpiThreshold){			;;;Expanded Bar
							;Whole Background Bar
							Gdip_FillRectangle(pGraphics8, GuiBackgroundBrush, AutoClicksCurrX, AutoClicksBackgroundY, AutoClickGuiW, AutoClickGuiH)
							
							if(AutoClicksKey="t" && !CheckInv()){
								AutoClickGuiBarH := AutoClickTempH
								,AutoClickGuiBarH2 := 0
							}else if (AutoClicksHoldDelay!=0){														
								if (AutoClicksSpamDelay!=0){				;Hold Wait Scenario
									if (AutoClicksHoldingArr[A_Index]){
										RemainingSec := A_Now
										AutoClicksKeyUpTime := AutoClicksKeyUpTimeArr[A_Index]
										EnvSub, RemainingSec, %AutoClicksKeyUpTime%, s
										RemainingMS := 0 - (RemainingSec*1000 + (A_MSec - AutoClicksKeyUpTimeMSArr[A_Index]))

										,AutoClickGuiBarH := min(max(1,round((AutoClickTempH)*(RemainingMS/AutoClicksHoldDelay))), (AutoClickTempH))
										,AutoClickGuiBarH2 := (AutoClickTempH)-AutoClickGuiBarH
									}else{
										RemainingSec := AutoClicksNextTimeArr[A_Index]
										EnvSub, RemainingSec, %A_Now%, s
										RemainingMS := (RemainingSec*1000 - (A_MSec - AutoClicksKeyUpTimeMSArr[A_Index]))

										,AutoClickGuiBarH := min(max(1,round((AutoClickTempH)*(1-RemainingMS/AutoClicksSpamDelay))), (AutoClickTempH))
										,AutoClickGuiBarH2 := (AutoClickTempH)-AutoClickGuiBarH
									}
								}else{									;Indefinite Hold Scenario
									AutoClickGuiBarH := round(AutoClickTempH)
									,AutoClickGuiBarH2 := 0
								}
							}else{										;Quick Spam Scenario
								if (AutoClicksSpamDelay>=AutoClickSpamEpiThreshold && AutoClicksSpamDelay!=0){
									RemainingSec := A_Now
									AutoClickNextTime := AutoClicksNextTimeArr[A_Index]
									EnvSub, RemainingSec, %AutoClickNextTime%, s
									RemainingMS := (0 - RemainingSec)*1000 - (A_MSec - AutoClicksNextTimeMSArr[A_Index])
									,AutoClickGuiBarH := min(max(1,round((AutoClickTempH)*(1-RemainingMS/AutoClicksSpamDelay))), (AutoClickTempH))
									,AutoClickGuiBarH2 := (AutoClickTempH)-AutoClickGuiBarH

								}Else{
									AutoClickGuiBarH := round(AutoClickTempH)
									,AutoClickGuiBarH2 := 0
								}
							}
							;Tooltip, %AutoClickHolding%`n%RemainingMS%`n%AutoClickNextTime%`n%AutoClickSpamDelay%
							

							AutoClicksTopFillBarY := AutoClicksAnchor=1 || AutoClicksAnchor=3 ? AutoClicksCurrY+2*GuiMargin+AutoClickGuiFontSize : AutoClicksCurrY+GuiMargin-AutoClickGuiH
							,AutoClicksLowerFillBarY := AutoClicksAnchor=1 || AutoClicksAnchor=3 ? AutoClicksCurrY+2*GuiMargin+AutoClickGuiFontSize+AutoClickGuiBarH : AutoClicksTopFillBarY+AutoClickGuiBarH
							,AutoClickIndiY := AutoClickGuiBarH > AutoClickGuiFontSize ? AutoClickGuiBarH-AutoClickGuiFontSize : 0

							if (AutoClickGuiBarH>1)			;Top Fill Bar
								Gdip_FillRectangle(pGraphics8, (AutoClicksSpamDelay=0 && AutoClicksHoldDelay=0) ? AutoClickBrush2 : AutoClickBrush, AutoClicksCurrX+GuiMargin, AutoClicksTopFillBarY, AutoClickGuiW-2*GuiMargin, AutoClickGuiBarH)
							if (AutoClickGuiBarH2>1)		;Lower Fill Bar
								Gdip_FillRectangle(pGraphics8, (AutoClicksHoldDelay!=0 && !AutoClicksHoldingArr[A_Index]) || (AutoClicksHoldDelay=0) ? AutoClickBrush : AutoClickBrush2, AutoClicksCurrX+GuiMargin, AutoClicksLowerFillBarY, AutoClickGuiW-2*GuiMargin, AutoClickGuiBarH2)
							
							;Indicator Bar/Line
							AutoClickIndiColor := AutoClicksHoldDelay!=0 ? Dec2Hex(50+255*AutoClickGuiBarH/AutoClickGuiH) AutoClickBarFill : "FF" AutoClickBarFill
							,AutoClickPen:=Gdip_CreatePen("0x" AutoClickIndiColor, 2)
							,Gdip_DrawLine(pGraphics8, AutoClickPen, AutoClicksCurrX+GuiMargin, AutoClicksTopFillBarY+AutoClickGuiBarH-1, AutoClicksCurrX+AutoClickGuiW-GuiMargin, AutoClicksTopFillBarY+AutoClickGuiBarH-1)
							,Gdip_DeletePen(AutoClickPen)

							;Spam Key Indicator
							if(AutoClicksKey="t" && !CheckInv()){
								Gdip_TextToGraphics(pGraphics8, "No Inv", "x" AutoClicksCurrX " y" AutoClicksCurrY+2*GuiMargin+AutoClickGuiFontSize+AutoClickGuiBarH-AutoClickGuiFontSize*2 " w" AutoClickGuiW " h" AutoClickGuiFontSize " Center vCenter Bold c" AutoClickIndiColor " s" AutoClickGuiFontSize, FontFace)
								,Gdip_TextToGraphics(pGraphics8, "Found", "x" AutoClicksCurrX " y" AutoClicksCurrY+2*GuiMargin+AutoClickGuiFontSize+AutoClickGuiBarH-AutoClickGuiFontSize*1 " w" AutoClickGuiW " h" AutoClickGuiFontSize " Center vCenter Bold c" AutoClickIndiColor " s" AutoClickGuiFontSize, FontFace)
							}
							else{
								;if (AutoClickGuiBarH>AutoClickGuiFontSize)
								Gdip_TextToGraphics(pGraphics8, AutoClicksKeyDisp, "x" AutoClicksCurrX " y" AutoClicksTopFillBarY+AutoClickIndiY " w" AutoClickGuiW " h" AutoClickGuiFontSize " Center vCenter Bold c" AutoClickIndiColor " s" AutoClickGuiFontSize, FontFace)
							}
						}else{									;Collapsed Bar
							;Whole Background Bar
							Gdip_FillRectangle(pGraphics8, GuiBackgroundBrush, AutoClicksCurrX, AutoClicksBackgroundMiniY, AutoClickGuiW, AutoClicksBackgroundSmallH)
							;wrapper for Spam Key text
							Gdip_FillRectangle(pGraphics8, GuiBackgroundBrush, AutoClicksCurrX+GuiMargin, AutoClicksWrapperBarY, AutoClickGuiW-2*GuiMargin, AutoClickGuiFontSize+GuiMargin)

							;Spam Key Indicator
							Gdip_TextToGraphics(pGraphics8, AutoClicksKeyDisp, "x" AutoClicksCurrX " y" AutoClicksKeyDispY " w" AutoClickGuiW " h" AutoClickGuiFontSize " Center vCenter Bold c" AutoClicksSpamKeyColor " s" AutoClickGuiFontSize, FontFace)
						}
					}
					Temp := Temp "AutoClicksCurrX: " AutoClicksCurrX "`nAutoClicksSpamDelay: " AutoClicksSpamDelay "`nAutoClicksHoldDelay: " AutoClicksHoldDelay "`nAutoClicksHotkeyDisp: " AutoClicksHotkeyDisp "`nAutoClicksKeyDisp: " AutoClicksKeyDisp "`nAutoClicksHoldingArr[A_Index]: " AutoClicksHoldingArr[A_Index] "`nAutoClicksKeyUpTimeMSArr[A_Index]: " AutoClicksKeyUpTimeMSArr[A_Index] "`nAutoClicksKeyUpTimeArr[A_Index]: " AutoClicksKeyUpTimeArr[A_Index] "`nAutoClicksNextTimeMSArr[A_Index]: " AutoClicksNextTimeMSArr[A_Index] "`nAutoClicksNextTimeArr[A_Index]: " AutoClicksNextTimeArr[A_Index] "`nAutoClicksNextTimeArr[A_Index]: " AutoClicksNextTimeArr[A_Index] "`nAutoClicksNextTimeMSArr[A_Index]: " AutoClicksNextTimeMSArr[A_Index] "`nRemainingMS: " RemainingMS "`n`n`n"
					
				}
				;;Hotkey Display
				Gdip_TextToGraphics(pGraphics8, AutoClicksHotkeyDisp, "x" AutoClicksCurrX " y" AutoClicksHotkeyDispY " w" AutoClickGuiW " h" AutoClickGuiFontSize " Center vCenter Bold c" AutoClicksHotKeyColor " s" AutoClickGuiFontSize, FontFace)
			}
			
			UpdateLayeredWindow(AutoClickhwnd, hdc8, AutoClicksActualX, AutoClicksActualY, AutoClickGuiActualW, AutoClickGuiH)
		}



		Temp := Temp "`nAutoClicksArr.MaxIndex()=" AutoClicksArr.MaxIndex() "`nAutoClicksCurrY: " AutoClicksCurrY "`nGuiMargin: " GuiMargin "`nAutoClickGuiFontSize: " AutoClickGuiFontSize "`nAutoClickSpamEpiThreshold: " AutoClickSpamEpiThreshold
		;Tooltip % Temp




/*
		if (FoodWaterOverlayCheck && AutoFoodWaterCheck && !ShowingFoodWaterGui){
			ShowingFoodWaterGui := 1
			Gui, 9:Destroy
			Gui, 9:-Caption +E0x80000 +E0x20 +HwndFoodWaterhwnd +AlwaysOnTop +ToolWindow +OwnDialogs -Caption -DPIScale +LastFound ; Create GUI
			Gui, 9:Show, NA

			hbm9 := CreateDIBSection(FoodWaterGuiW, FoodWaterGuiH) ; Create a gdi bitmap drawing area
			,hdc9 := CreateCompatibleDC() ; Get a device context compatible with the screen
			,obm9 := SelectObject(hdc9, hbm9) ; Select the bitmap into the device context
			
			,pGraphics9 := Gdip_GraphicsFromHDC(hdc9) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
			,Gdip_SetSmoothingMode(pGraphics9, 4)

		}else if(ShowingFoodWaterGui && !FoodWaterOverlayCheck){
			Gui, 9:Destroy
			ShowingFoodWaterGui := 0

			,SelectObject(hdc9, obm9) ; Select the object back into the hdc
			,DeleteObject(hbm9) ; Now the bitmap may be deleted
			,DeleteDC(hdc9) ; Also the device context related to the bitmap may be deleted
			,Gdip_DeleteGraphics(pGraphics9)
		}

		if (FoodWaterOverlayCheck && AutoFoodWaterCheck && ShowingFoodWaterGui && !QTinProgress){
			Gdip_GraphicsClear(pGraphics9, 0x00000000)
			
			;if (GuiMargin>3)				;Background
			;	Gdip_FillRoundedRectangle(pGraphics9, GuiBackgroundBrush, 0, 0, FoodWaterGuiW, FoodWaterGuiH, GuiMargin)
			;else if (GuiMargin>0)
				,Gdip_FillRectangle(pGraphics9, GuiBackgroundBrush, 0, 0, FoodWaterGuiW, FoodWaterGuiH)
			
			;UnFilled Bars
			,Gdip_FillRectangle(pGraphics9, FoodWaterBrush, GuiMargin, GuiMargin, FoodWaterGuiW-2*GuiMargin, (FoodWaterGuiH-3*GuiMargin)/2)
			,Gdip_FillRectangle(pGraphics9, FoodWaterBrush, GuiMargin, (FoodWaterGuiH-3*GuiMargin)/2+2*GuiMargin, FoodWaterGuiW-2*GuiMargin, (FoodWaterGuiH-3*GuiMargin)/2)
			Loop, 2			;1 = WaterBar 				2 = FoodBar
			{
				FoodWaterGuiBarH := A_Index=1 ? round(((FoodWaterGuiH-3*GuiMargin)/2)*(1-DrinkTime/WaterDelay)) : round(((FoodWaterGuiH-3*GuiMargin)/2)*(1-EatTime/FoodDelay))
				,FoodWaterGuiBarH2 := round((FoodWaterGuiH-3*GuiMargin)/2)-FoodWaterGuiBarH
				;Tooltip, %FoodWaterGuiBarH%`n%FoodWaterGuiBarH2%
				;Tooltip, %WaterDelay%`n%DrinkTime%
				if ((DrinkTime<=0 && A_Index=1) || (EatTime<=0 && A_Index=2)){
					FoodWaterGuiStrY := A_Index=1 ? GuiMargin+FoodWaterGuiBarH-10 : (FoodWaterGuiH-3*GuiMargin)/2+2*GuiMargin+FoodWaterGuiBarH-10
					,Gdip_TextToGraphics(pGraphics9, A_Index=1 ? "SLURP" : "NOM", "x" 0 " y" FoodWaterGuiStrY " w" FoodWaterGuiW " h" 10 " Center vCenter Bold cFF" FoodWaterColor " s10", FontFace)
				}
				
				if (FoodWaterGuiBarH2>=1)
					Gdip_FillRectangle(pGraphics9, FoodWaterBrush2, GuiMargin, A_Index=1 ? GuiMargin+FoodWaterGuiBarH : (FoodWaterGuiH-3*GuiMargin)/2+2*GuiMargin+FoodWaterGuiBarH, FoodWaterGuiW-2*GuiMargin, FoodWaterGuiBarH2)
			}
			UpdateLayeredWindow(FoodWaterhwnd, hdc9, FoodWaterGuiX, FoodWaterGuiY, FoodWaterGuiW, FoodWaterGuiH)
		}
*/
	}else{
		if (OverlayShowing){
			GoSub, TST_Off
		}
		if (ShowingNotifyGui){
			Gui, 5:Hide
			ShowingNotifyGui := 0
		}
		if (ReticleDrawn){
			Gui, 6:Destroy
			ReticleDrawn := 0
		}
		if(ShowingAutoClickGui){
			Gui, 8:Destroy
			ShowingAutoClickGui := 0

			,SelectObject(hdc8, obm8) ; Select the object back into the hdc
			,DeleteObject(hbm8) ; Now the bitmap may be deleted
			,DeleteDC(hdc8) ; Also the device context related to the bitmap may be deleted
			,Gdip_DeleteGraphics(pGraphics8)
			;,Gdip_DeleteBrush(AutoClickBrush)
			;,Gdip_DeleteBrush(AutoClickBrush2)
		}
/*
		if(ShowingFoodWaterGui){
			Gui, 9:Destroy
			ShowingFoodWaterGui := 0

			,SelectObject(hdc9, obm9) ; Select the object back into the hdc
			,DeleteObject(hbm9) ; Now the bitmap may be deleted
			,DeleteDC(hdc9) ; Also the device context related to the bitmap may be deleted
			,Gdip_DeleteGraphics(pGraphics9)
			;,Gdip_DeleteBrush(FoodWaterBrush)
			;,Gdip_DeleteBrush(FoodWaterBrush2)
		}
*/
	}
Return


Loop1Sec:
	
	Steamhwnd := WinExist("Game Info")
	if (Steamhwnd){
		;Tooltip, %Steamhwnd%
		;DllCall("SetForegroundWindow", UInt, Steamhwnd) 		;;;;;Activates Window is BAD
		WinGetPos, SteamX, SteamY, SteamW, SteamH, ahk_id %Steamhwnd%
		DllCall("SetWindowPos"
		, "UInt", Steamhwnd ;handle
		, "UInt", -1 ;HWND_TOP
		, "Int",  SteamX ;x
		, "Int",  SteamY ;y
		, "Int",  SteamW ;width
		, "Int",  SteamH ;height
		, "UInt", 0x4010) ;SWP_ASYNCWINDOWPOS-0x4000		SWP_NOACTIVATE-0x0010

	}


	;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 		Take Screenshots every x and save for y total.
	;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 		Will use this later for seeing reason for death for example.
	if (A_Now>=NextSSTime && WinsExist()){
		Capturedbitmap := Gdip_BitmapFromHWND(WinsExist())
		Gdip_SaveBitmapToFile(Capturedbitmap, ScreenshotsDir "\" A_Now ".jpg", 66)
		NextSSTime := A_Now
		EnvAdd, NextSSTime, 120, s 				;;;;;;;;;;;;;;SS every 2 min

		Loop, Files, %ScreenshotsDir%\*.jpg 
		{
			OldestFileTime := A_Now
			EnvAdd, OldestFileTime, -6, h 		;;;;;Keep Files that are 6 hours old or less
			if (A_LoopFileTimeModified<OldestFileTime)
				FileDelete, %A_LoopFileFullPath%
		}
	}

	;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 		AUTO FOOD WATER BREW
	;bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb			capture bitmap if any are checked - check each case
	if (WinsActive() && !QTinProgress){
		if ((A_Now>=NextBrewTime && BrewCheck) || (A_Now>=NextFoodTime && FoodCheck) || (A_Now>=NextWaterTime && WaterCheck)){
			AFWCapturedbitmap := Gdip_BitmapFromHWND(WinsActive())
			Gdip_GetImageDimensions(AFWCapturedbitmap, AFWwidth, AFWheight)
			if (A_Now>=NextBrewTime && BrewCheck){
				HPlowRGB1 := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, HPX, HPlowY))
				,HPlowRGB2 := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, HPX+3, HPlowY))
				,HPlowRGB3 := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, HPX-3, HPlowY))

				,HPlowR := round(((HPlowRGB1 >> 16 & 0xFF) + (HPlowRGB1 >> 16 & 0xFF) + (HPlowRGB1 >> 16 & 0xFF))*0.333,0)
				,HPlowG := round(((HPlowRGB1 >> 8 & 0xFF) + (HPlowRGB1 >> 8 & 0xFF) + (HPlowRGB1 >> 8 & 0xFF))*0.333,0)
				,HPlowB := round(((HPlowRGB1 & 0xFF) + (HPlowRGB1 & 0xFF) + (HPlowRGB1 & 0xFF))*0.333,0)


				,HPlowBGratio := round(HPlowB/HPlowG,2)

				HPhighRGB1 := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, HPX, HPhighY))
				,HPhighRGB2 := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, HPX+3, HPhighY))
				,HPhighRGB3 := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, HPX-3, HPhighY))

				,HPhighR := round(((HPhighRGB1 >> 16 & 0xFF) + (HPhighRGB1 >> 16 & 0xFF) + (HPhighRGB1 >> 16 & 0xFF))*0.333,0)
				,HPhighG := round(((HPhighRGB1 >> 8 & 0xFF) + (HPhighRGB1 >> 8 & 0xFF) + (HPhighRGB1 >> 8 & 0xFF))*0.333,0)
				,HPhighB := round(((HPhighRGB1 & 0xFF) + (HPhighRGB1 & 0xFF) + (HPhighRGB1 & 0xFF))*0.333,0)

				,HPhighBGratio := round(HPhighB/HPhighG,2)

				;HPlowBMin := Min(HPlowB,HPlowBMin)   ;~125
				;HPhighBMin := Min(HPhighB,HPhighBMin)

				HPBGdiff := HPhighBGratio-HPhighBGratio


				;HPhighR>=2*HPlowR   HPhighR>=2*HPlowR ? "HPR:" HPhighR "-" 2*HPlowR : 
				BrewBool := (HPBGdiff>=0.16 || HPhighB<118 || HPhighR>100) ;&& (HPlowR<=200 && HPlowG<=240 && HPlowB<=240) ;do not include flashing white
				BrewReason := HPBGdiff>=0.16 ? "HPBGdiff:" HPBGdiff : HPhighB<118 ? "HPhigh:" HPhighB : HPhighR>100 ? "HPhighR:" HPhighR : ""
				BrewDispStr := BrewBool ? "BREW!!! " BrewReason : ""



				if (BrewBool){
					BrewBitmap := Gdip_CreateBitmap(70, 70)
					,BrewG := Gdip_GraphicsFromImage(BrewBitmap)
					,BrewSnip := Gdip_CloneBitmapArea(AFWCapturedbitmap, AFWwidth-75, AFWheight-75, 70, 70)
					;BrewSnipB64 := "data:image/png;base64," RegexReplace(Vis2.stdlib.Gdip_EncodeBitmapTo64string(BrewSnip, "PNG", 50), "\r?\n")

					,Gdip_DrawImage(BrewG, BrewSnip)
					,Gdip_DisposeImage(BrewSnip)
					;IniWrite, %BrewSnipB64%, %FileSettings%, Main, BrewSnipB64
					;BrewSnipB64 := ""


					Gdip_TextToGraphics(BrewG, "R:" HPlowR, "x2 y1 w50 h25 cff000000 s10 Left", FontFace)
					,Gdip_TextToGraphics(BrewG, "G:" HPlowG, "x2 y11 w50 h25 cff000000 s10 Left", FontFace)
					,Gdip_TextToGraphics(BrewG, "B:" HPlowB, "x2 y21 w50 h25 cff000000 s10 Left", FontFace)


					Gdip_TextToGraphics(BrewG, "R:" HPlowR, "x1 y0 w50 h25 cffffffff s10 Left", FontFace)
					,Gdip_TextToGraphics(BrewG, "G:" HPlowG, "x1 y10 w50 h25 cffffffff s10 Left", FontFace)
					,Gdip_TextToGraphics(BrewG, "B:" HPlowB, "x1 y20 w50 h25 cffffffff s10 Left", FontFace)

					

					,Gdip_SaveBitmapToFile(BrewBitmap, ClipsDirBrew "\" A_Now ".jpg", 90)
					,Gdip_DisposeImage(BrewBitmap)
					,Gdip_DeleteGraphics(BrewG)


					NextBrewTime := A_Now
					EnvAdd, NextBrewTime, StringToSeconds(BrewDelay), s

					Send {%BrewKey%}


					Loop, Files, %ClipsDirBrew%\*.jpg 
					{
						OldestFileTime := A_Now
						EnvAdd, OldestFileTime, -6, h 		;;;;;Keep Files that are 6 hours old or less
						if (A_LoopFileTimeModified<OldestFileTime)
							FileDelete, %A_LoopFileFullPath%
					}


					;SoundBeep
				}
				;DebugCheck := 1
				;DebugDispStr := BrewDispStr "  R:" HPlowR " G:" HPlowG " B:" HPlowB " B-G:" HPlowBGratio "         R:" HPhighR " G:" HPhighG " B:" HPhighB " B-G:" HPhighBGratio "        HPBGdiff:" HPBGdiff " HPlowBMin:" HPlowBMin " HPhighBMin:" HPhighBMin


				LastBrewStatus := "RL:" HPlowR " GL:" HPlowG " BL:" HPlowB " B-GL:" HPlowBGratio "`nRU:" HPhighR " GU:" HPhighG " BU:" HPhighB " B-GU:" HPhighBGratio "`nHPhighBGratio:" HPhighBGratio " HPlowBGratio:" HPlowBGratio
			}
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			if (A_Now>=NextWaterTime && WaterCheck){
				WaterlowRGB := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, WaterX, WaterY))
				,WaterlowR := WaterlowRGB >> 16 & 0xFF
				,WaterlowG := WaterlowRGB >> 8 & 0xFF
				,WaterlowB := WaterlowRGB & 0xFF

				;WaterhighRGB := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, WaterX, WaterY-5))
				;,WaterhighR := WaterhighRGB >> 16 & 0xFF
				;,WaterhighG := WaterhighRGB >> 8 & 0xFF
				;,WaterhighB := WaterhighRGB & 0xFF

				;WaterBool := (WaterlowR>45 && WaterlowG<130 && WaterlowB<120) && (WaterlowR<=WaterlowWhiteR) ;do not include flashing white
				WaterBool := (WaterlowR>round(WaterlowB*0.77) && WaterlowR<200 && WaterlowR>55 && WaterlowB<180)  ;do not include flashing white

				

				if (WaterBool){
					WaterBitmap := Gdip_CreateBitmap(70, 70)
					,WaterG := Gdip_GraphicsFromImage(WaterBitmap)
					,WaterSnip := Gdip_CloneBitmapArea(AFWCapturedbitmap, AFWwidth-75, WaterY-60, 70, 70)
					;WaterSnipB64 := "data:image/png;base64," RegexReplace(Vis2.stdlib.Gdip_EncodeBitmapTo64string(WaterSnip, "PNG", 50), "\r?\n")

					,Gdip_DrawImage(WaterG, WaterSnip)
					,Gdip_DisposeImage(WaterSnip)
					;IniWrite, %WaterSnipB64%, %FileSettings%, Main, WaterSnipB64
					;WaterSnipB64 := ""

					Gdip_TextToGraphics(WaterG, "R:" WaterlowR, "x2 y1 w50 h25 cff000000 s10 Left", FontFace)
					,Gdip_TextToGraphics(WaterG, "G:" WaterlowG, "x2 y11 w50 h25 cff000000 s10 Left", FontFace)
					,Gdip_TextToGraphics(WaterG, "B:" WaterlowB, "x2 y21 w50 h25 cff000000 s10 Left", FontFace)

					Gdip_TextToGraphics(WaterG, "R:" WaterlowR, "x1 y0 w50 h25 cffffffff s10 Left", FontFace)
					,Gdip_TextToGraphics(WaterG, "G:" WaterlowG, "x1 y10 w50 h25 cffffffff s10 Left", FontFace)
					,Gdip_TextToGraphics(WaterG, "B:" WaterlowB, "x1 y20 w50 h25 cffffffff s10 Left", FontFace)

					

					,Gdip_SaveBitmapToFile(WaterBitmap, ClipsDirWater "\" A_Now ".jpg", 90)
					,Gdip_DisposeImage(WaterBitmap)
					,Gdip_DeleteGraphics(WaterG)

					NextWaterTime := A_Now
					EnvAdd, NextWaterTime, StringToSeconds(WaterDelay), s

					Send {%WaterKey%}
					;SoundBeep


					Loop, Files, %ClipsDirWater%\*.jpg 
					{
						OldestFileTime := A_Now
						EnvAdd, OldestFileTime, -6, h 		;;;;;Keep Files that are 6 hours old or less
						if (A_LoopFileTimeModified<OldestFileTime)
							FileDelete, %A_LoopFileFullPath%
					}
				}
			}
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			if (A_Now>=NextFoodTime && FoodCheck){
				FoodlowRGB := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, FoodX, FoodY))
				,FoodlowR := FoodlowRGB >> 16 & 0xFF
				,FoodlowG := FoodlowRGB >> 8 & 0xFF
				,FoodlowB := FoodlowRGB & 0xFF

				;FoodhighRGB := "0x" int2hex(Gdip_GetPixel(AFWCapturedbitmap, FoodX, FoodY-5))
				;,FoodhighR := FoodhighRGB >> 16 & 0xFF
				;,FoodhighG := FoodhighRGB >> 8 & 0xFF
				;,FoodhighB := FoodhighRGB & 0xFF

				;FoodBool := (FoodlowR>45 && FoodlowG<130 && FoodlowB<120) && (FoodlowR<=FoodlowWhiteR) ;do not include flashing white
				FoodBool := (FoodlowR>round(FoodlowB*0.77) && FoodlowR<200 && FoodlowR>55 && FoodlowB<180)  ;do not include flashing white

				

				if (FoodBool){
					FoodBitmap := Gdip_CreateBitmap(70, 70)
					,FoodG := Gdip_GraphicsFromImage(FoodBitmap)
					,FoodSnip := Gdip_CloneBitmapArea(AFWCapturedbitmap, AFWwidth-75, FoodY-60, 70, 70)
					;FoodSnipB64 := "data:image/png;base64," RegexReplace(Vis2.stdlib.Gdip_EncodeBitmapTo64string(FoodSnip, "PNG", 50), "\r?\n")

					,Gdip_DrawImage(FoodG, FoodSnip)
					,Gdip_DisposeImage(FoodSnip)
					;IniWrite, %FoodSnipB64%, %FileSettings%, Main, FoodSnipB64
					;FoodSnipB64 := ""


					Gdip_TextToGraphics(FoodG, "R:" FoodlowR, "x2 y1 w50 h25 cff000000 s10 Left", FontFace)
					,Gdip_TextToGraphics(FoodG, "G:" FoodlowG, "x2 y11 w50 h25 cff000000 s10 Left", FontFace)
					,Gdip_TextToGraphics(FoodG, "B:" FoodlowB, "x2 y21 w50 h25 cff000000 s10 Left", FontFace)

					Gdip_TextToGraphics(FoodG, "R:" FoodlowR, "x1 y0 w50 h25 cffffffff s10 Left", FontFace)
					,Gdip_TextToGraphics(FoodG, "G:" FoodlowG, "x1 y10 w50 h25 cffffffff s10 Left", FontFace)
					,Gdip_TextToGraphics(FoodG, "B:" FoodlowB, "x1 y20 w50 h25 cffffffff s10 Left", FontFace)


					,Gdip_SaveBitmapToFile(FoodBitmap, ClipsDirFood "\" A_Now ".jpg", 90)
					,Gdip_DisposeImage(FoodBitmap)
					,Gdip_DeleteGraphics(FoodG)

					NextFoodTime := A_Now
					EnvAdd, NextFoodTime, StringToSeconds(FoodDelay), s

					Send {%FoodKey%}
					;SoundBeep

					Loop, Files, %ClipsDirFood%\*.jpg 
					{
						OldestFileTime := A_Now
						EnvAdd, OldestFileTime, -6, h 		;;;;;Keep Files that are 6 hours old or less
						if (A_LoopFileTimeModified<OldestFileTime)
							FileDelete, %A_LoopFileFullPath%
					}
				}
			}
			Gdip_DisposeImage(AFWCapturedbitmap)	
		}

	}
	;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 		AUTO FOOD WATER BREW
	;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 		always update waiting/ready timer on gui



	if (FoodCheck){
		FoodTime := NextFoodTime
		EnvSub, FoodTime, %A_Now%, seconds 
		FoodTimeDisp := FoodTime>0 ? SecondsToString(FoodTime,0) : "Ready to Eat"
		HTMLDisplay.document.getElementById("FoodTimer").value := FoodTimeDisp
	}
	if (WaterCheck){
		WaterTime := NextWaterTime
		EnvSub, WaterTime, %A_Now%, seconds 
		WaterTimeDisp := WaterTime>0 ? SecondsToString(WaterTime,0) : "Ready to Drink"
		HTMLDisplay.document.getElementById("WaterTimer").value := WaterTimeDisp
	}
	if (BrewCheck){
		BrewTime := NextBrewTime
		EnvSub, BrewTime, %A_Now%, seconds 
		BrewTimeDisp := BrewTime>=0 ? SecondsToString(BrewTime,0) : "Ready to Brew"
		HTMLDisplay.document.getElementById("BrewTimer").value := BrewTimeDisp
	}
/*

	if (AutoFoodWaterCheck && !QTinProgress){
		if (DrinkTime<=0){	
			if (WinsActive()){
				Send {%WaterKey%}
				DrinkTimeDisp := "GLUG GLUG GLUG"
				,LastDrink := A_Now
				,DrinkTime := StringToSeconds(WaterDelay)
			}else 
				DrinkTimeDisp := "Waiting to Drink"
		}else{
			DrinkTime := LastDrink
			EnvSub, DrinkTime, %A_Now%, seconds 
			DrinkTime := WaterDelay + DrinkTime
			,DrinkTimeDisp := SecondsToString(DrinkTime,0)
		}

		if (EatTime<=0){	
			if (WinsActive()){
				Send {%FoodKey%}
				EatTimeDisp := "NOM NOM NOM"
				,LastEat := A_Now
				,EatTime := StringToSeconds(FoodDelay)
			}else
				EatTimeDisp := "Waiting to Eat"
		}else{
			EatTime := LastEat
			EnvSub, EatTime, %A_Now%, seconds
			EatTime := FoodDelay + EatTime
			,EatTimeDisp := SecondsToString(EatTime,0)
		}
		HTMLDisplay.document.getElementById("WaterTimer").value := DrinkTimeDisp
		,HTMLDisplay.document.getElementById("FoodTimer").value := EatTimeDisp
	}
*/

	if (CDCheck && CDToggle=0)
		NotifySpamN := NotifySpamN="" ? 0 : NotifySpamN>0 ? NotifySpamN - 1 : NotifySpamN

	if (WinsExist() && AlertsCheck && AlertsInput6 && !AlertRedText && !QTinProgress){
		pBitmapHaystackRed := Gdip_BitmapFromHWND(WinsExist())
		,pBitmapNeedleRed := Gdip_CreateBitmapFromFile(CapDir "\RedBar.png")
		,Gdip_ImageSearch(pBitmapHaystackRed, pBitmapNeedleRed, OutputListRed, 0, 0, A_ScreenWidth, 0.2*A_ScreenHeight, 5)
		,OutputListRed := RegexReplace(OutputListRed, "0\,0")
		if(OutputListRed!=""){
			Tooltip % OutputListRed
			FoundRedX := SubStr(OutputListRed, 1, InStr(OutputListRed, ",")-1), FoundRedY := SubStr(OutputListRed, InStr(OutputListRed, ",")+1)
			,Gdip_ImageSearch(pBitmapHaystackRed, pBitmapNeedleRed, OutputListRed, FoundRedX, 0, A_ScreenWidth, 0.2*A_ScreenHeight, 5)

				if(OutputListRed!=""){
				;Wait until AlertsFunction and check FoundRed
				AlertRedText := 1
			}
		}

		Gdip_DisposeImage(pBitmapHaystackRed)
		Gdip_DisposeImage(pBitmapNeedleRed)
	}
	if (Arkhwnd2 && !WinsActive() && AlertsInput8){
		MouseGetPos, MouseX, MouseY
		NotActive := MouseX=LastMouseX && MouseY=LastMouseY && LastKey=A_PriorKey ? NotActive + 1 : 0
		,LastMouseX := MouseX
		,LastMouseY := MouseY
		,LastKey := A_PriorKey
	}else{
		NotActive := 0
	}
	if (WinsActive()){
		if (TAScreenDisp){
			if (!ShowingTAGui && !CheckInv()){
				Gui, 11:Show, NA
				ShowingTAGui := 1
			}else if (ShowingTAGui && CheckInv()){
				Gui, 11:Hide
				ShowingTAGui := 0
			}
		}
		else{
			if (ShowingTAGui){
				Gui, 11:Hide
				ShowingTAGui := 0
			}
		}
	}
return

AlertsFunction:
	if (AlertsCheck && !GachaFarming){
		;ArkhwndA := WinsExist()
		;Tooltip, Checking for Alerts`n%AlertsInput1%
		if (WinsExist() && !WinsActive() && AlertsInput8 && NotActive>60){
			WinGet, gameHwnd, ID, ahk_exe ShooterGame.exe
			DllCall("SetForegroundWindow", UInt, gameHwnd)
			SoundBeep
			;Tooltip, are we in game?
		}
		if (AlertsInput1){
			pBitmapHaystackCyan := Gdip_BitmapFromHWND(WinsExist())
			,pBitmapNeedleCyan := Gdip_CreateBitmapFromFile(CapDir "\CyanBar.png")
			,Gdip_ImageSearch(pBitmapHaystackCyan, pBitmapNeedleCyan, OutputListCyan, 0, 0, A_ScreenWidth, 0.3*A_ScreenHeight, 10)
			,OutputListCyan := RegexReplace(OutputListCyan, "0\,0")
			if (OutputListCyan!=""){
				SoundFile := "EnemySpotted"
				GoSub, MakeSound
			}
			Gdip_DisposeImage(pBitmapHaystackCyan)
			Gdip_DisposeImage(pBitmapNeedleCyan)
		}

		if (AlertsInput2 && !JoinSimCheck){
			if (!CheckInv() && CheckDC()){
				SoundFile := "Disconnected"
				GoSub, MakeSound
			}
		}else
			DCRetVal := false
		if (AlertsInput3 && WinExist("The UE4-ShooterGame Game has crashed and will close")){
			SoundFile := "Game has Crashed!"
			GoSub, MakeSound
		}
		if (AlertsInput4 && StrLen(NotifyServersCrash)>5){
			SoundFile := NotifyServersCrash
			GoSub, MakeSound
		}
		if (AlertsInput5 && StrLen(NotifyServersRecover)>5){
			SoundFile := NotifyServersRecover
			GoSub, MakeSound
		}
		if (AlertsInput6 && AlertRedText){
			AlertRedText := 0
			,SoundFile := "Something has died!"
			GoSub, MakeSound
		}
		if (AlertsInput7 && TimedAlertstoNotify.MaxIndex()>0){
			Loop % TimedAlertstoNotify.MaxIndex(){
				SoundFile := TimedAlertstoNotify[A_Index]
				GoSub, MakeSound
			}
		}
	}Else{
		;Tooltip
	}





Return


NotifyFinishCheck:
	if (CDCheck){
		if (CurrentTimeNotify>=MaxTimeNotify){
			if (CDToggle=1){
				CDCheck := HTMLDisplay.document.getElementById("CDCheck").checked := 0
				IniWrite, %CDCheck%, %FileSettings%, Main, CDCheck

				JoinSimCheck := HTMLDisplay.document.getElementById("JoinSimCheck").checked := 0
				IniWrite, %JoinSimCheck%, %FileSettings%, Main, JoinSimCheck

				
				NotifyText := "Goodbye!"
				Sleep, 1500
				if WinsExist()
	   				WinClose
	   			Sleep 1000
	   			NotifyAFKTime := A_Now

			}else if (CDToggle=0){
				;SoundFile := round(Min((CurrentTimeNotify-MaxTimeNotify)*250+525, 20000))
				SoundFile := CDNotify
				GoSub, MakeSound
			}
		}
		if (CDFoodRem<=0 && CDToggle=2){
			;SoundFile := round(Min((0-CDFoodRem)*250+525, 20000))
			SoundFile := CDFoodNotify	
			GoSub, MakeSound
		}
	}
Return



*~e::
	if (NameYourCheck && !AutoClickEnabled && !Edown && !Exporting){
		if (WinsActive()){
			Edown := 1
			,EdownTime := A_Now
			,EdownTimeMS := A_MSec
			GoSub, EndCancelNameYour
		}
	}
return

*~e UP::
	if (NameYourCheck && !AutoClickEnabled){
		;ArkhwndE := WinsActive()
		if (WinsActive()){
			Edown := 0
			,EheldTime := A_Now
			EnvSub, EheldTime, %EdownTime%, s
			EheldTime := EheldTime*1000 - (EdownTimeMS - A_MSec)
			
			if(EheldTime<350 && !CancelingName){
				if (DebugNamingWindowCheck){
					DebugGUIX := NameYourX1
					,DebugGUIY := NameYourY1
					,DebugGUIW := NameYourX2-NameYourX1
					,DebugGUIH := NameYourY2-NameYourY1
					GoSub, DrawDebugGUI
					SetTimer, KillDebugGUI, -1500
				}

				pBitmapHaystackNameYour := Gdip_BitmapFromHWND(WinsActive())
				,pBitmapNeedleNameYour1 := Gdip_CreateBitmapFromFile(CapDir "\accept.png")
				,pBitmapNeedleNameYour2 := Gdip_CreateBitmapFromFile(CapDir "\cancel.png")
				,Gdip_ImageSearch(pBitmapHaystackNameYour, pBitmapNeedleNameYour1, OutputListNameYour1, NameYourX1, NameYourY1, NameYourX2, NameYourY2, 72)
				,Gdip_ImageSearch(pBitmapHaystackNameYour, pBitmapNeedleNameYour2, OutputListNameYour2, NameYourX1, NameYourY1, NameYourX2, NameYourY2, 72)

				if (OutputListNameYour1="" && OutputListNameYour2=""){
					CancelingName := 1
					SetTimer, CancelNameYour, 50
					SetTimer, EndCancelNameYour, 3000
					if (DebugNamingWindowCheck)
						Tooltip, Pressed E`nNo Window Found Yet
				
				}
				Gdip_DisposeImage(pBitmapHaystackNameYour)
				Gdip_DisposeImage(pBitmapNeedleNameYour1)
				Gdip_DisposeImage(pBitmapNeedleNameYour2)
			}
		}
	}
return	

DrawDebugGUI:
	Gui, 2:Destroy
	Gui, 2:New, -Caption +E0x80000 +E0x20 +AlwaysOnTop +ToolWindow +OwnDialogs +LastFound +HwndPixelhwnd ; Create GUI
	Gui, 2:Show, NA, ChoosePixel ; Show GUI

	hbm2 := CreateDIBSection(DebugGUIW+2, DebugGUIH+2) ; Create a gdi bitmap drawing area
	,hdc2 := CreateCompatibleDC() ; Get a device context compatible with the screen
	,obm2 := SelectObject(hdc2, hbm2) ; Select the bitmap into the device context
	,pGraphics2 := Gdip_GraphicsFromHDC(hdc2) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	,Gdip_SetSmoothingMode(pGraphics2, 4) ; Set the smoothing mode to antialias = 4 to make shapes appear smother
	
	
	,pPen := Gdip_CreatePen(0xFFFF0000, 2)
	,Gdip_DrawRectangle(pGraphics2, pPen, 0, 0, DebugGUIW, DebugGUIH)
	,Gdip_DeletePen(pPen)


	,UpdateLayeredWindow(Pixelhwnd, hdc2, DebugGUIX, DebugGUIY, DebugGUIW+1, DebugGUIH+1)
	,SelectObject(hdc2, obm2) ; Select the object back into the hdc
	,DeleteObject(hbm2) ; Now the bitmap may be deleted
	,DeleteDC(hdc2) ; Also the device context related to the bitmap may be deleted
	,Gdip_DeleteGraphics(pGraphics2) ;
return 

KillDebugGUI:
	DebugDrawn := 0
	ShowingHelenaOverlay := 0
	Gui, 2:Destroy
	Tooltip
return


*~LButton::
	if (ShowingExportOverlay){
		MouseGetPos, MouseX, MouseY
		BoundX1 := floor(ExportXactual + ExportOverlayW - SquareSize2 - 2*margin)
		,BoundX2 := floor(ExportXactual + ExportOverlayW)
		,BoundY1 := floor(ExportYactual)
		,BoundY2 := floor(ExportYactual + SquareSize2 + 2*margin)

		;Tooltip, %BoundX1%<%MouseX%<%BoundX2%`n%BoundY1%<%MouseY%<%BoundY2%

		if (MouseX>BoundX1 && MouseX<BoundX2 && MouseY>BoundY1 && MouseY<BoundY2){
			;SoundBeep
			SetTimer, DeleteOverlay, off
			GoSub, DeleteOverlay
		}
	}


	if (ShowingHelenaOverlay){
		MouseGetPos, MouseX, MouseY
		BoundX1 := floor(HelenaX + HelenaW - SquareSize2 - 2*margin)
		,BoundX2 := floor(HelenaX + HelenaW)
		,BoundY1 := floor(HelenaY)
		,BoundY2 := floor(HelenaY + SquareSize2 + 2*margin)

		;Tooltip, %BoundX1%<%MouseX%<%BoundX2%`n%BoundY1%<%MouseY%<%BoundY2%

		if (MouseX>BoundX1 && MouseX<BoundX2 && MouseY>BoundY1 && MouseY<BoundY2){
			;SoundBeep
			SetTimer, KillDebugGUI, off
			GoSub, KillDebugGUI
		}
	}

	NotActive := AlertsInput8 ? 0 : NotActive
return


*~h::
	;ArkhwndH := WinsActive()
	if (WinsActive() && CaptureHelenaCheck && !CheckInv()){
		Sleep 650
		HelenaStartTime := A_TickCount

		,pBitmapHaystackHelena := Gdip_BitmapFromHWND(WinsActive())
		,pBitmapNeedleHelena := Gdip_CreateBitmapFromFile(CapDir "\HelenaCyanBar.png")
		,pBitmapNeedleHelena2 := Gdip_CreateBitmapFromFile(CapDir "\HelenaCyanBar2.png")


		,Gdip_ImageSearch(pBitmapHaystackHelena, pBitmapNeedleHelena, OutputListHelena, 0, 0, A_ScreenWidth, A_ScreenHeight, HelenaVariation, , 2, 0)
		;Gdip_ImageSearch(pBitmapHaystack,pBitmapNeedle,ByRef OutputList="",OuterX1=0,OuterY1=0,OuterX2=0,OuterY2=0,Variation=0,Trans="",SearchDirection=1,Instances=1,LineDelim="`n",CoordDelim=",") {

		if (OutputListHelena!=""){
			;Clipboard := OutputList
			CoordLines := StrSplit(OutputListHelena, "`n")
			;Tooltip % CoordLines.MaxIndex()
			Loop % CoordLines.MaxIndex(){
				HelenaElapsedTime := A_TickCount - HelenaStartTime
				if (WinsActive() && HelenaElapsedTime<5000){
					Coords := StrSplit(CoordLines[A_Index], ",")
					;Temp := Coords[1] "-" Coords[2] "`n" Coords[1]+380 "-" Coords[2]+260
					;Tooltip, %Temp%
					;Sleep 1000
					,Gdip_ImageSearch(pBitmapHaystackHelena, pBitmapNeedleHelena2, OutputListHelena, Coords[1], Coords[2], Coords[1]+380, Coords[2]+260, HelenaVariation, , 1, 0)
					,HelenaFoundPos := HelenaMatch4 := ""
					,HelenaFoundPos := RegexMatch(OutputListHelena, "([0-9]{1,},[0-9]{1,}\n){15,}")

					if (HelenaFoundPos){
						;Tooltip, Helena Found!
						SetTimer, KillDebugGUI, Off
						GoSub, KillDebugGUI

						Gui, 2:Destroy
						Gui, 2:New, -Caption +E0x80000 +E0x20 +AlwaysOnTop +ToolWindow +OwnDialogs +LastFound +HwndPixelhwnd ; Create GUI
						Gui, 2:Show, NA, Helena ; Show GUI

						hbm2 := CreateDIBSection(HelenaW+2, HelenaH+2) ; Create a gdi bitmap drawing area
						,hdc2 := CreateCompatibleDC() ; Get a device context compatible with the screen
						,obm2 := SelectObject(hdc2, hbm2) ; Select the bitmap into the device context
						,pGraphics2 := Gdip_GraphicsFromHDC(hdc2) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
						,Gdip_SetSmoothingMode(pGraphics2, 4) ; Set the smoothing mode to antialias = 4 to make shapes appear smother


						,HelenaX2 := Coords[1]+HelenaXoff
						,HelenaY2 := Coords[2]+HelenaYoff
						,Gdip_DrawImage(pGraphics2, pBitmapHaystack, 0, 0, HelenaW, HelenaH, HelenaX2, HelenaY2, HelenaW, HelenaH, round(HelenaA/100,1))

						,HelenaElapsedTime := A_TickCount - HelenaStartTime
						,HelenaTextColor := Dec2Hex(round(255*HelenaA/100,1)) "00FFFF"
						,Gdip_TextToGraphics(pGraphics2, HelenaElapsedTime " ms", "x" 2 " y" HelenaH-26 " w" HelenaW " h" 25 " " Bold " c" HelenaTextColor " s" 18 " Left", FontFace)

						;Close Window X
						,pPen:=Gdip_CreatePen("0x" HelenaTextColor, 2)
						,Gdip_DrawLines(pGraphics2, pPen, HelenaW-SquareSize2-margin "," margin "|" HelenaW-margin "," margin+SquareSize2)
						,Gdip_DrawLines(pGraphics2, pPen, HelenaW-margin "," margin "|" HelenaW-SquareSize2-margin "," margin+SquareSize2)
						,Gdip_DeletePen(pPen)

						,UpdateLayeredWindow(Pixelhwnd, hdc2, HelenaX, HelenaY, HelenaW+1, HelenaH+1)
						,SelectObject(hdc2, obm2) ; Select the object back into the hdc
						,DeleteObject(hbm2) ; Now the bitmap may be deleted
						,DeleteDC(hdc2) ; Also the device context related to the bitmap may be deleted
						,Gdip_DeleteGraphics(pGraphics2) ;
						,ShowingHelenaOverlay := 1
						,HelenaTimeout := -HelenaTime*1000
						SetTimer, KillDebugGUI, %HelenaTimeout%
						break
					}
				}else{
					break
				}
			}
		}
		else{
			;Tooltip, Helena Nope
		}
		OutputListHelena := ""
		Gdip_DisposeImage(pBitmapHaystackHelena)
		Gdip_DisposeImage(pBitmapNeedleHelena)
		Gdip_DisposeImage(pBitmapNeedleHelena2)
		

		;sleep 3000
		;Tooltip

	}
return



*~Esc::
	if (CancelingName && NameYourCheck)
		GoSub, EndCancelNameYour

	if (ShowingMsgBox)
		GoSub, MsgBoxClose
return



*~NumpadEnter::
*~Enter::
	if (ShowingMsgBox)
		GoSub, MsgBoxOK
return


GuiClose:
;GuiEscape:
	GoSub, SaveWindowPos
	GoSub, ExitSub

return

ListVarsFn:
	ListVars
return

ClipHTMLFn:
	SoundBeep
	Clipboard := "<style>`n" HTMLDisplay.document.getElementsByTagName("style")[0].innerHTML "`n</style>`n<body>n`" HTMLDisplay.document.getElementsByTagName("body")[0].innerHTML "</body>`n"
return


TST_On:
	Gui, 4:Destroy
	Gui, 4:-Caption +E0x80000 +E0x20 +HwndTSThwnd +AlwaysOnTop +ToolWindow +OwnDialogs ;+LastFound Create GUI
	Gui, 4:Show, NA ; Show GUI

	hbm4 := CreateDIBSection(GuiOverInfoW, GuiOverInfoH) ; Create a gdi bitmap drawing area
	,hdc4 := CreateCompatibleDC() ; Get a device context compatible with the screen
	,obm4 := SelectObject(hdc4, hbm4) ; Select the bitmap into the device context
	,pGraphics4 := Gdip_GraphicsFromHDC(hdc4) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	,Gdip_SetSmoothingMode(pGraphics4, 4) ; Set the smoothing mode to antialias = 4 to make shapes appear smoother

	OverlayShowing := 1
return

TST_Off:
	Gui, 4:Destroy
	OverlayShowing := 0
	,SelectObject(hdc4, obm4) ; Select the object back into the hdc
	,DeleteObject(hbm4) ; Now the bitmap may be deleted
	,DeleteDC(hdc4) ; Also the device context related to the bitmap may be deleted
return

TST_Update:
	Gdip_GraphicsClear(pGraphics4, 0x00000000)
	,TSTMatrix := TSTEnabled="ON" || TSTEnabled=1 ? "1" : "0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1"

	TSTIconBitmap := GdipCreateFromBase64(SplashImageSimpleB64)
	,Gdip_DrawImage(pGraphics4, TSTIconBitmap, -2, -2, IconSmallW, IconSmallW, , , , , TSTMatrix)
	,Gdip_DisposeImage(TSTIconBitmap)

	If SC != 0
		Gdip_TextToGraphics(pGraphics4, TSTHotkey!="" ? RegexReplace(TSTHotkey, "([a-z0-9]{1,})", "$U1") ": " TSTText : TSTText, "x" IconSmallW + 7 " y" 2 " w" floor(GuiOverInfoW-IconSmallW+2) " h" GuiOverInfoH " " Bold " c" SC " s" TS, FontFace)
	Gdip_TextToGraphics(pGraphics4, TSTHotkey!="" ? RegexReplace(TSTHotkey, "([a-z0-9]{1,})", "$U1") ": " TSTText : TSTText, "x" IconSmallW + 5 " y" 0 " w" floor(GuiOverInfoW-IconSmallW) " h" GuiOverInfoH " " Bold " c" TC " s" TS, FontFace)
	UpdateLayeredWindow(TSThwnd, hdc4, GuiOverInfoX, GuiOverInfoY, GuiOverInfoW, GuiOverInfoH)


	LastDisplayStr := TSTText
	LastTSTEnabled := TSTEnabled
	;Tooltip, %TSTEnabled%`n%TSTText%`n%DisplayingMessage%
	;SoundBeep
return






CheckInv(){
	;;;;;;;;;;;;;;;;;;;USING X BUTTON AT TOP RIGHT CORNER

	global CheckInvX, CheckInvY
	if (WinsActive()){
		PixelGetColor, Color, %CheckInvX%, %CheckInvY%
		B := Color >> 16 & 0xFF, G := Color >> 8 & 0xFF, R := Color & 0xFF
		;Tooltip, R%R%`nG%G%`nB%B%

		if (R<5 && G>110 && G<190 && B>145 && B<210)
			return true
	}

	CIHaystack := Gdip_BitmapFromHWND(WinsExist())


	CIRGB := "0x" int2hex(Gdip_GetPixel(Capturedbitmap, CheckInvX, HPlowY))
	,HPR := CIRGB >> 16 & 0xFF
	,HPG := CIRGB >> 8 & 0xFF
	,HPB := CIRGB & 0xFF

	if (R<5 && G>110 && G<190 && B>145 && B<210){
		Gdip_DisposeImage(CIHaystack)	
		return true
	}else{
		CINeedle := Gdip_CreateBitmapFromFile(CapDir "\CyanX.png")
		,Gdip_ImageSearch(CIHaystack, CINeedle, CINeedleList, 0.80*A_ScreenWidth, 0, A_ScreenWidth, 0.20*A_ScreenHeight, 25)
		,Gdip_DisposeImage(CINeedle)	
		,Gdip_DisposeImage(CIHaystack)	

		;Tooltip, CINeedleList: %CINeedleList%

		if (CINeedleList!="")
			return true

		return false
	}
}

CheckDC(ByRef Reason:=""){				;;;;CHECK LOST CONNECTION

	if (WinExist("Json Error")){
		;RetVal := true
		;WinClose, Json Error
		WinActivate, ahk_exe ShooterGame.exe
		Reason := "json Error"
		return true
	}

	global JoinSimVariation

	DCHaystack := Gdip_BitmapFromHWND(WinsExist())
	if (DebugCheckDC)
		DCgraphics := Gdip_GraphicsFromImage(DCHaystack)


	DCAccept := Gdip_CreateBitmapFromFile(CapDir "\accept.png")
	,Gdip_GetImageDimensions(DCAccept, DCAcceptW, DCAcceptH)
	,Gdip_ImageSearch(DCHaystack, DCAccept, DCAcceptList, 0.33*A_ScreenWidth, 0.5*A_ScreenHeight, 0.66*A_ScreenWidth, 0.66*A_ScreenHeight, JoinSimVariation)
	,Gdip_DisposeImage(DCAccept)

	,DCAcceptX := SubStr(DCAcceptList, 1, InStr(DCAcceptList, ",")-1), DCAcceptY := SubStr(DCAcceptList, InStr(DCAcceptList, ",")+1)

	,DCAcceptRGB1 := int2hex(Gdip_GetPixel(DCHaystack, floor(DCAcceptX+DCAcceptW/2+100), floor(DCAcceptY+DCAcceptH/2)))
	,DCAcceptRGB1R := hex2dec(substr(DCAcceptRGB1, 1, 2)), DCAcceptRGB1G := hex2dec(substr(DCAcceptRGB1, 3, 2)), DCAcceptRGB1B := hex2dec(substr(DCAcceptRGB1, 5, 2))

	,DCAcceptRGB2 := int2hex(Gdip_GetPixel(DCHaystack, floor(DCAcceptX+DCAcceptW/2-100), floor(DCAcceptY+DCAcceptH/2)))
	,DCAcceptRGB2R := hex2dec(substr(DCAcceptRGB2, 1, 2)), DCAcceptRGB2G := hex2dec(substr(DCAcceptRGB2, 3, 2)), DCAcceptRGB2B := hex2dec(substr(DCAcceptRGB2, 5, 2))				

	;Tooltip, %DCAcceptRGB1%`t%DCAcceptRGB1R%`t%DCAcceptRGB1G%`t%DCAcceptRGB1B%`n%DCAcceptRGB2%`t%DCAcceptRGB2R%`t%DCAcceptRGB2G%`t%DCAcceptRGB2B%


	DCAcceptBool := DCAcceptRGB1R<35 && DCAcceptRGB2R<35 && DCAcceptRGB1G>35 && DCAcceptRGB2G>35 && DCAcceptRGB1B>35 && DCAcceptRGB2B>35


	DCCancel := Gdip_CreateBitmapFromFile(CapDir "\cancel.png")
	,Gdip_GetImageDimensions(DCCancel, DCCancelW, DCCancelH)
	,Gdip_ImageSearch(DCHaystack, DCCancel, DCCancelList, 0.33*A_ScreenWidth, 0.5*A_ScreenHeight, 0.66*A_ScreenWidth, 0.66*A_ScreenHeight, JoinSimVariation)
	,Gdip_DisposeImage(DCCancel)

	,DCCancelX := SubStr(DCCancelList, 1, InStr(DCCancelList, ",")-1), DCCancelY := SubStr(DCCancelList, InStr(DCCancelList, ",")+1)

	,DCCancelRGB1 := int2hex(Gdip_GetPixel(DCHaystack, floor(DCCancelX+DCCancelW/2+100), floor(DCCancelY+DCCancelH/2)))	
	,DCCancelRGB1R := hex2dec(substr(DCCancelRGB1, 1, 2)), DCCancelRGB1G := hex2dec(substr(DCCancelRGB1, 3, 2)), DCCancelRGB1B := hex2dec(substr(DCCancelRGB1, 5, 2))

	,DCCancelRGB2 :=  int2hex(Gdip_GetPixel(DCHaystack, floor(DCCancelX+DCCancelW/2-100), floor(DCCancelY+DCCancelH/2)))
	,DCCancelRGB2R := hex2dec(substr(DCCancelRGB2, 1, 2)), DCCancelRGB2G := hex2dec(substr(DCCancelRGB2, 3, 2)), DCCancelRGB2B := hex2dec(substr(DCCancelRGB2, 5, 2))

	
	DCCancelBool := DCCancelRGB1R<35 && DCCancelRGB2R<35 && DCCancelRGB1G>35 && DCCancelRGB2G>35 && DCCancelRGB1B>35 && DCCancelRGB2B>35


	;Tooltip, DCAcceptRGB1: %DCAcceptRGB1%`t%DCAcceptRGB1R%`t%DCAcceptRGB1G%`t%DCAcceptRGB1B%`nDCAcceptRGB1: %DCAcceptRGB2%`t%DCAcceptRGB2R%`t%DCAcceptRGB2G%`t%DCAcceptRGB2B%`nDCCancelRGB1: %DCCancelRGB1%`t%DCCancelRGB1R%`t%DCCancelRGB1G%`t%DCCancelRGB1B%`nDCCancelRGB2: %DCCancelRGB2%`t%DCCancelRGB2R%`t%DCCancelRGB2G%`t%DCCancelRGB2B%

	;Tooltip, %DCAcceptReturn% DCAcceptList: %DCAcceptList%`t%DCAcceptRGB1%`t%DCAcceptRGB2%`n%DCCancelReturn% DCCancelList: %DCCancelList%`t%DCCancelRGB1%`t%DCCancelRGB2%
	;Tooltip, %DCAcceptX%`t%DCAcceptY%`t%DCAcceptW%`t%DCAcceptRGB1%`t%DCAcceptRGB2%`n%DCCancelX%`t%DCCancelY%`t%DCCancelW%`t%DCCancelRGB1%`t%DCCancelRGB2%


	if (DCAcceptList!="" && DCCancelList!="" && DCAcceptX<DCCancelX-200 && DCAcceptBool && DCCancelBool ){ ; && DCAcceptRGB1=DCAcceptRGB2 && DCCancelRGB1=DCCancelRGB2){

		if (DebugCheckDC){
			pPen := Gdip_CreatePen(0xFFFF0000, 4)
			,Gdip_DrawRectangle(DCgraphics, pPen, DCAcceptX, DCAcceptY, DCAcceptW, DCAcceptH)
			,Gdip_DrawRectangle(DCgraphics, pPen, DCCancelX, DCCancelY, DCCancelW, DCCancelH)
			,Gdip_DeletePen(pPen)


			,GuiBackgroundBrush2 := Gdip_BrushCreateSolid("0xCC00FF00")
			,Gdip_FillRectangle(DCgraphics, GuiBackgroundBrush2, DCAcceptX, DCAcceptY+DCAcceptH, DCCancelX-DCAcceptX+DCCancelW, 90)
			,Gdip_DeleteBrush(GuiBackgroundBrush2)


			,Gdip_TextToGraphics(DCgraphics, DCAcceptRGB1, "x" DCAcceptX " y" DCAcceptY+DCAcceptH " Left Bold cFF" DCAcceptRGB1 " s28", FontFace)
			,Gdip_TextToGraphics(DCgraphics, DCAcceptRGB2, "x" DCAcceptX " y" DCAcceptY+DCAcceptH+50 " Left Bold cFF" DCAcceptRGB2 " s28", FontFace)

			,Gdip_TextToGraphics(DCgraphics, DCCancelRGB1, "x" DCCancelX-DCCancelW " y" DCCancelY+DCCancelH " Left Bold cFF" DCCancelRGB1 " s28", FontFace)
			,Gdip_TextToGraphics(DCgraphics, DCCancelRGB2, "x" DCCancelX-DCCancelW " y" DCCancelY+DCCancelH+50 " Left Bold cFF" DCCancelRGB2 " s28", FontFace)
		
			
			Gdip_SaveBitmapToFile(DCHaystack, DebugDir "\" A_Now "AcceptCancel.jpg", 33)
		}

		Gdip_DeleteGraphics(DCgraphics)
		Gdip_DisposeImage(DCHaystack)
		
		Reason := "Found Accept and Cancel"
		return true
	}



	DCok := Gdip_CreateBitmapFromFile(CapDir "\OK.png")
	,Gdip_GetImageDimensions(DCok, DCokW, DCokH)
	,Gdip_ImageSearch(DCHaystack, DCok, DCokList, 0.4*A_ScreenWidth, 0.5*A_ScreenHeight, 0.6*A_ScreenWidth, 0.66*A_ScreenHeight, JoinSimVariation)
	,Gdip_DisposeImage(DCok)

	,DCokX := SubStr(DCokList, 1, InStr(DCokList, ",")-1), DCokY := SubStr(DCokList, InStr(DCokList, ",")+1)
	
	,DCokRGB1 := int2hex(Gdip_GetPixel(DCHaystack, floor(DCokX+DCokW/2+100), floor(DCokY+DCokH/2)))
	,DCokRGB1R := hex2dec(substr(DCokRGB1, 1, 2)), DCokRGB1G := hex2dec(substr(DCokRGB1, 3, 2)), DCokRGB1B := hex2dec(substr(DCokRGB1, 5, 2))

	,DCokRGB2 := int2hex(Gdip_GetPixel(DCHaystack, floor(DCokX+DCokW/2-100), floor(DCokY+DCokH/2)))
	,DCokRGB2R := hex2dec(substr(DCokRGB2, 1, 2)), DCokRGB2G := hex2dec(substr(DCokRGB2, 3, 2)), DCokRGB2B := hex2dec(substr(DCokRGB2, 5, 2))	

	DCokBool := DCokRGB1R<35 && DCokRGB2R<35 && DCokRGB1G>35 && DCokRGB2G>35 && DCokRGB1B>35 && DCokRGB2B>35

	if (DCokList!="" && DCokBool){
		if (DebugCheckDC){

			pPen := Gdip_CreatePen(0xFFFF0000, 4)
			Gdip_DrawRectangle(DCgraphics, pPen, DCokX, DCokY, DCokW, DCokH)
			Gdip_DeletePen(pPen)

			,GuiBackgroundBrush2 := Gdip_BrushCreateSolid("0xCC000000")
			,Gdip_FillRectangle(DCgraphics, GuiBackgroundBrush2, DCokX, DCokY+DCokH, 110, 90)
			,Gdip_DeleteBrush(GuiBackgroundBrush2)

			,Gdip_TextToGraphics(DCgraphics, DCokRGB1, "x" DCokX " y" DCokY+DCokH " w200 h200 Left Bold cFF" DCokRGB1 " s28", FontFace)
			,Gdip_TextToGraphics(DCgraphics, DCokRGB2, "x" DCokX " y" DCokY+DCokH+50 " w200 h200 Left Bold cFF" DCokRGB1 " s28", FontFace)

			Gdip_SaveBitmapToFile(DCHaystack, DebugDir "\" A_Now "-OK.jpg", 33)
		}

		Gdip_DeleteGraphics(DCgraphics)
		Gdip_DisposeImage(DCHaystack)
		
		Reason := "Found ok"
		return true
	}
	Gdip_DeleteGraphics(DCgraphics)
	Gdip_DisposeImage(DCHaystack)

	return false
}


int2hex(int){
    HEX_INT := 8
    while (HEX_INT--)
    {
        n := (int >> (HEX_INT * 4)) & 0xf
        h .= n > 9 ? chr(0x37 + n) : n
        if (HEX_INT == 0 && HEX_INT//2 == 0)
            h .= " "
    }
    return substr(h, 3)
}

Dec2Hex(Dec,Pad=2){
	Hex := Format("{:X}", round(max(0,min(Dec,255))))
	AddZeros := Pad-StrLen(Hex)
	if (AddZeros>0){
		Loop % AddZeros{
			Hex := "0" Hex
		}
	}
	return Hex
}


Hex2Dec(Hex){
	Dec := 0
	,Array := StrSplit(Hex)
	Loop % Array.MaxIndex(){
		Int := Array[Array.MaxIndex()-A_Index+1]
		,Int := Int="a"?10:Int="b"?11:Int="c"?12:Int="d"?13:Int="e"?14:Int="f"?15:Int

		Loop % A_Index-1{
			Int := Int*16
		}

		Dec := Dec+Int
	}
	return Dec
}


;;;;if (red*0.299 + green*0.587 + blue*0.114) > 186 use #000000 else use #ffffff        stackoverflow

;;;;;L = 0.2126 * R + 0.7152 * G + 0.0722 * B 											W3C
;;if L > 0.179 use #000000 else use #ffffff

ChooseTextColor(ColorInt){
	R := substr(ColorInt, 1, 2)
	G := substr(ColorInt, 3, 2)
	B := substr(ColorInt, 5, 2)
	ColorHexOut := ((R*0.299) + (G*0.587) + (B*0.114)) > 186 ? "000000" : "FFFFFF"

	;L := (0.2126 * R) + (0.7152 * G) + (0.0722 * B)			;using "luminance"
	;ColorHexOut := L > 0.179 ? "000000" : "FFFFFF"
	;ColorHexOut := (R + G*1.15 + B)<1.05 ? "FFFFFF" : "000000"   ;-personal attempt bad
	return ColorHexOut
}

ChooseTextColor2(ColorHexIn){
	R := Hex2Dec(substr(ColorHexIn, 1, 2))
	G := Hex2Dec(substr(ColorHexIn, 3, 2))
	B := Hex2Dec(substr(ColorHexIn, 5, 2))
	ColorHexOut := ((R*0.299) + (G*0.587) + (B*0.114)) > 186 ? "000000" : "FFFFFF"

	;L := (0.2126 * R) + (0.7152 * G) + (0.0722 * B)			;using "luminance"
	;ColorHexOut := L > 0.179 ? "000000" : "FFFFFF"
	;ColorHexOut := (R + G*1.15 + B)<255*1.05 ? "FFFFFF" : "000000" ;-personal attempt bad
	return ColorHexOut
}


StringToSeconds(Str){
	OutputSeconds := 0

	FoundPos1 := RegexMatch(Str, "i)([0-9.]{0,})[ ]{0,}d", Match)
	if (FoundPos1)
		OutputSeconds := OutputSeconds + floor(Match1*24*60*60)
	FoundPos2 := RegexMatch(Str, "i)([0-9.]{0,})[ ]{0,}h", Match)
	if (FoundPos2)
		OutputSeconds := OutputSeconds + floor(Match1*60*60)
	FoundPos3 := RegexMatch(Str, "i)([0-9.]{0,})[ ]{0,}m", Match)
	if (FoundPos3)
		OutputSeconds := OutputSeconds + floor(Match1*60)
	FoundPos4 := RegexMatch(Str, "i)([0-9.]{0,})[ ]{0,}s", Match)
	if (FoundPos4)
		OutputSeconds := OutputSeconds + floor(Match1)

	if (!FoundPos1 && !FoundPos2 && !FoundPos3 && !FoundPos4){
		FoundPos4 := RegexMatch(Str, "i)([0-9]{0,})", Match)
		OutputSeconds := floor(Match1)
	}
	return OutputSeconds
}
SecondsToString(InputTime, HTMLbool=0){

	OutputTime := round(InputTime)

	,OutputTimeD := OutputTime/60/60/24
	,OutputTimeH := (OutputTimeD - floor(OutputTimeD))*24
	,OutputTimeM := (OutputTimeH - floor(OutputTimeH))*60
	,OutputTimeS := (OutputTimeM - floor(OutputTimeM))*60
	
	,OutputTimeDDisp := floor(OutputTimeD)
	,OutputTimeHDisp := floor(OutputTimeH)
	,OutputTimeMDisp := floor(OutputTimeM)
	,OutputTimeSDisp := floor(OutputTimeS)

	,align := "center"

	if (HTMLbool){
		OutputTimeDDisp := OutputTimeDDisp != "" && OutputTimeDDisp != 0 ? "<td align=""" align """>" OutputTimeDDisp "d</td>" : "" ;"<td align=""" align """></td>"
		,OutputTimeHDisp := OutputTimeHDisp != "" && OutputTimeHDisp != 0 ? "<td align=""" align """>" OutputTimeHDisp "h</td>" : "" ;"<td align=""" align """></td>"
		,OutputTimeMDisp := OutputTimeMDisp != "" && OutputTimeMDisp != 0 ? "<td align=""" align """>" OutputTimeMDisp "m</td>" : "" ;"<td align=""" align """></td>"
		,OutputTimeSDisp := OutputTimeSDisp != "" && OutputTimeSDisp != 0 ? "<td align=""" align """>" OutputTimeSDisp "s</td>" : "" ;"<td align=""" align """>0s</td>"
	}else{
		OutputTimeDDisp := OutputTimeDDisp != "" && OutputTimeDDisp != 0 ? OutputTimeDDisp "d " : ""
		,OutputTimeHDisp := OutputTimeHDisp != "" && OutputTimeHDisp != 0 ? OutputTimeHDisp "h " : ""
		,OutputTimeMDisp := OutputTimeMDisp != "" && OutputTimeMDisp != 0 ? OutputTimeMDisp "m " : ""
		,OutputTimeSDisp := OutputTimeSDisp != "" && OutputTimeSDisp != 0 ? OutputTimeSDisp "s" : "0s"
	}
	OutputTime := OutputTimeDDisp OutputTimeHDisp OutputTimeMDisp OutputTimeSDisp

	return OutputTime
}


ParseHotkey(HotkeyInput){
	;;SoundBeep
	HotkeyOutput := HotkeyInput

	;;HotkeyOutput := RegExReplace(HotkeyOutput, "2B", "+")
	,HotkeyOutput := RegExReplace(HotkeyOutput, "%2B", "+")
	,HotkeyOutput := RegExReplace(HotkeyOutput, "%21", "!")
	,HotkeyOutput := RegExReplace(HotkeyOutput, "%5e", "^")
	,HotkeyOutput := RegExReplace(HotkeyOutput, "%26", "&")
	;;HotkeyOutput := RegExReplace(HotkeyOutput, "%7E", "~")
	,HotkeyOutput := RegExReplace(HotkeyOutput, "%7E")
	,HotkeyOutput := RegExReplace(HotkeyOutput, "%24", "$")


	,HotkeyOutput := RegExReplace(HotkeyOutput,"i)lmb|lbutton|m(ouse)?1", "LButton")
	,HotkeyOutput := RegExReplace(HotkeyOutput,"i)rmb|rbutton|m(ouse)?2", "RButton")
	,HotkeyOutput := RegExReplace(HotkeyOutput,"i)m(ouse)?3", "MButton")
	
	,HotkeyOutput := RegExReplace(HotkeyOutput,"i)xbutton1|mouse5|thumbmousebutton1", "XButton1")
	,HotkeyOutput := RegExReplace(HotkeyOutput,"i)xbutton2|mouse4|thumbmousebutton2", "XButton2")
	

	;;HotkeyOutput := "Test"
	;;Tooltip, %HotkeyInput%`n%HotkeyOutput%
	Return HotkeyOutput
}

SetDefaultEndpoint(DeviceID){
    try IPolicyConfig := ComObjCreate("{870af99c-171d-4f9e-af0d-e63df40c2bc9}", "{F8679F50-850A-41CF-9C72-430F290290C8}")
    try DllCall(NumGet(NumGet(IPolicyConfig+0)+13*A_PtrSize), "UPtr", IPolicyConfig, "UPtr", &DeviceID, "UInt", 0, "UInt")
    try ObjRelease(IPolicyConfig)
}

GetDeviceID(Devices, Name){
    For DeviceName, DeviceID in Devices
        If (InStr(DeviceName, Name))
            Return DeviceID
}



HookProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime ){
	s := event = 4 ? "Menu start" : event = 5 ? "Menu close" : event = 10 ? "Moving started" : "Moving stoped"
	if (WinActive("ahk_id " MainHwnd) && s="Moving stoped")
		GoSub, SaveWindowPos
}

API_SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
	DllCall("CoInitialize", "uint", 0)
	return DllCall("SetWinEventHook", "uint", eventMin, "uint", eventMax, "uint", hmodWinEventProc, "uint", lpfnWinEventProc, "uint", idProcess, "uint", idThread, "uint", dwFlags)
}





WM_LBUTTONDOWN(){
	MouseGetPos,,,,ctrl
	;Tooltip, %ctrl%
    if (WinActive("ahk_id" MainHwnd) && (ctrl="Static1" || ctrl="Static5")){ ;;;;Mover TitleBar
       PostMessage, 0xA1, 2,,, A ; WM_NCLBUTTONDOWN
		;PostMessage, 0xA1, 2
    }
}

WM_NCCALCSIZE(){
    if (A_Gui)
        return 0    ; Sizes the client area to fill the entire window.
}

WM_NCHITTEST(wParam, lParam){
    static border_size = 12
    MouseGetPos,,,,ctrl
    if !A_Gui
        return
    WinGetPos, gX, gY, gW, gH
    x := lParam<<48>>48, y := lParam<<32>>48
    hit_left := x < gX+border_size, hit_right := x >= gX+gW-border_size
    hit_top := y < gY+border_size, hit_bottom := y >= gY+gH-border_size
    if hit_top {
        if hit_left
            return 0xD
        else if hit_right
            return 0xE
        else
            return 0xC
    }else if hit_bottom {
        if hit_left
            return 0x10
        else if hit_right
            return 0x11
        else
            return 0xF
    }
    else if hit_left
        return 0xA
    else if hit_right
        return 0xB

}



drawCrosshair:
	Gui, 6:Destroy
	Gui, 6:-Caption +E0x80000 +E0x20 +HwndCrosshairhwnd +AlwaysOnTop +ToolWindow +OwnDialogs ;+LastFound Create GUI
	Gui, 6:Show, NA ; Show GUI

	XhairX := (0.5*A_ScreenWidth-XhairD/2)+XhairOffsetX
	,XhairY := (0.5*A_ScreenHeight-XhairD/2)+XhairOffsetY
	,XhairARGB := "0x" Dec2Hex(XhairA) Dec2Hex(XhairR) Dec2Hex(XhairG) Dec2Hex(XhairB)

	,hbm6 := CreateDIBSection(XhairD+1, XhairD+1) ; Create a gdi bitmap drawing area
	,hdc6 := CreateCompatibleDC() ; Get a device context compatible with the screen
	,obm6 := SelectObject(hdc6, hbm6) ; Select the bitmap into the device context
	,GCrosshair := Gdip_GraphicsFromHDC(hdc6) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	,Gdip_SetSmoothingMode(GCrosshair, 4) ; Set the smoothing mode to antialias = 4 to make shapes appear smoother
	,pBrush := Gdip_BrushCreateSolid(XhairARGB)
	,Gdip_FillEllipse(GCrosshair, pBrush, 0, 0, XhairD, XhairD)
	,Gdip_DeleteBrush(pBrush)
	,UpdateLayeredWindow(Crosshairhwnd, hdc6, XhairX, XhairY, XhairD+1, XhairD+1)

	,SelectObject(hdc6, obm6) ; Select the object back into the hdc
	,DeleteObject(hbm6) ; Now the bitmap may be deleted
	,DeleteDC(hdc6) ; Also the device context related to the bitmap may be deleted
	,Gdip_DeleteGraphics(GCrosshair) ; The graphics may now be deleted
	,XhairX := XhairY := XhairARGB := ""
return



CheckDinoExport:
	if ((DinoExportCheck && !GachaFarming && !Popcorning) || FirstPass){
		if (WinsActive() || FirstPass){
			if (!Exporting){
				if (FileExist(ExportDir)){
					TotalExportFiles := 0
					Loop, Files, %ExportDir%\*.ini, R 
					{
						TotalExportFiles := TotalExportFiles + 1
						;if(A_LoopFileTimeModified>=A_Now-4){
							,ModTimeLatest := A_LoopFileTimeModified>=A_Now-2 || A_LoopFileTimeModified>ModTimeLatest ? A_LoopFileTimeModified : ModTimeLatest
							,LatestFile := A_LoopFileTimeModified>=A_Now-2 || A_LoopFileTimeModified>ModTimeLatest ? A_LoopFileFullPath : LatestFile
							;break
						;}
						;if (A_LoopFileTimeModified>ModTimeLatest){
						;	ModTimeLatest := A_LoopFileTimeModified
						;	LatestFile := A_LoopFileFullPath
						;}
					}
				}
				HTMLDisplay.document.getElementById("TotalExports").value := "Clean Exports (" TotalExportFiles ")"

				if (LastExportTime != ModTimeLatest){
					Exporting := 1
					,LastExportTime := ModTimeLatest
					GoSub, DinoExportFunction 
				}
			}
		}
	}
return


CleanExportFolder:
	if (FileExist(ExportDir)){
		if (DinoExportCheck)
			SetTimer, CheckDinoExport, Off

		FileDelete, %ExportDir%\*.ini
		FileDelete, %ClipsDirASB%\*.jpg

		HTMLDisplay.document.getElementById("TotalExports").value := "Clean Exports (0)"
		;MsgBox, %TotalExportFiles% files have been deleted.
		MsgBox2(TotalExportFiles " files have been deleted.", "0 r1")

		;if (DinoExportCheck)
		SetTimer, CheckDinoExport, 1000
	}Else{
		;MsgBox, Cannot find export folder.
		MsgBox2("Cannot find export folder.", "0 r1")
	}
return





DinoExportFunction:	
	IniWrite, %LatestFile%, %FileSettings%, Main, LatestFile

	;Run, %LatestFile%


	if (ExportStats || ExportAddLibrary || ExportBringFront){
		ASBhwnd := WinExist("ARK Smart")
		if (ASBhwnd){
			WinGetPos, ASBGX, ASBGY, ASBGW, ASBGH, ahk_id %ASBhwnd%
			if (ASBGX=-32000 && ASBGY=-32000){
				WinRestore, ahk_id %ASBhwnd%
				WinGetPos, ASBGX, ASBGY, ASBGW, ASBGH, ahk_id %ASBhwnd%
			}
			;ControlClick, Last Export, ahk_id %ASBhwnd%,,,, NA 			CANNOT CLICK BUTTONS IF NOT ON TOP

			;0 ;HWND_TOP
			;1 ;HWND_BOTTOM

			DllCall("SetWindowPos"
			, "UInt", ASBhwnd ;handle
			, "UInt", 0 ;HWND_TOP
			, "Int", 50000 ;x
			, "Int", 0 ;y
			, "Int", ASBGW ;width
			, "Int", ASBGH ;height
			, "UInt", 0x4010) ;SWP_ASYNCWINDOWPOS-0x4000		SWP_NOACTIVATE-0x0010
			

			;Sleep 50
			;ControlClick, X415 Y105, ahk_id %ASBhwnd%,,,, NA
			;ControlClick, Last Export, ahk_id %ASBhwnd%,,,2, NA
			ControlClick, Last Export, ahk_id %ASBhwnd%,,,, NA



			DllCall("SetWindowPos"
			, "UInt", ASBhwnd ;handle
			, "UInt", ExportBringFront ? -1 : 0 ;z
			, "Int", ASBGX ;x
			, "Int", ASBGY ;y
			, "Int", ASBGW ;width
			, "Int", ASBGH ;height
			, "UInt", 0x4010) ;SWP_ASYNCWINDOWPOS-0x4000		SWP_NOACTIVATE-0x0010

			if (ExportBringFront){
				DllCall("SetWindowPos"
				, "UInt", ASBhwnd ;handle
				, "UInt", -2 ;z
				, "Int", ASBGX ;x
				, "Int", ASBGY ;y
				, "Int", ASBGW ;width
				, "Int", ASBGH ;height
				, "UInt", 0x4012) ;SWP_ASYNCWINDOWPOS-0x4000		SWP_NOACTIVATE-0x0010
			}

		}
	}

	IniRead, RandomMutationsMale, %LatestFile%, Dino Data, RandomMutationsMale
	IniRead, RandomMutationsFemale, %LatestFile%, Dino Data, RandomMutationsFemale

	
	if (ClipMutNumsCheck && !FirstPass){
		TotalMuts := RandomMutationsMale+RandomMutationsFemale>2147483647 ? RandomMutationsMale+RandomMutationsFemale-2147483647*2-2 : RandomMutationsMale+RandomMutationsFemale<0 && abs(RandomMutationsMale+RandomMutationsFemale)>2147483647 ? RandomMutationsMale+RandomMutationsFemale+2147483647*2+2 : RandomMutationsMale+RandomMutationsFemale
		;Tooltip, %RandomMutationsMale%`n%RandomMutationsFemale%`n%TotalMuts%
		if (TotalMuts!=0)
			Clipboard := TotalMuts "Mut"
		;SetTimer, KillTooltip, -5000
	}else{
		TotalMuts := 0
	}

	IniRead, DinoClass, %LatestFile%, Dino Data, DinoClass
	IniRead, DinoNameTag, %LatestFile%, Dino Data, DinoNameTag
	IniRead, Gender, %LatestFile%, Dino Data, bIsFemale		;♂♀		♂♀   ♂♀			♪♫☼►◄↕‼¶§▬↨↑↓→←∟↔▲
	IniRead, BabyAge, %LatestFile%, Dino Data, BabyAge
	IniRead, DinoLevel, %LatestFile%, Dino Data, CharacterLevel
	IniRead, DinoImprintingQuality, %LatestFile%, Dino Data, DinoImprintingQuality
	IniRead, Weight, %LatestFile%, Max Character Status Values, Weight
	IniRead, Food, %LatestFile%, Max Character Status Values, food

	ExportHTML := ""
	,DinoClass := substr(DinoClass,1, strLen(DinoClass)-2)

	,FoundPos := RegexMatch(DinoClass, "s)\.([A-z_]{1,})_Char", Match)
	,DinoNameTag2 := Match1


	,DinoNameTag := DinoNameTag == "Pug" ? "Bulbdog" : DinoNameTag
	,DinoNameTag := DinoNameTag == "Lantern Bird" ? "Featherlight" : DinoNameTag
	,DinoNameTag := DinoNameTag == "CaveWolf" ? "Ravager" : DinoNameTag
	,DinoNameTag := DinoNameTag == "Gremlin" ? "Ferox" : DinoNameTag
	,DinoNameTag := DinoNameTag == "LavaLizard" ? "Magmasaur" : DinoNameTag
	,DinoNameTag := DinoNameTag == "Bigfoot" ? "Gigantopithecus" : DinoNameTag
	,DinoNameTag := DinoNameTag == "Gigant" ? "Giganotosaurus" : DinoNameTag
	,DinoNameTag := DinoNameTag == "Para" ? "Parasaur" : DinoNameTag
	,DinoNameTag := DinoNameTag == "Sheep" ? "Ovis" : DinoNameTag
	,DinoNameTag := DinoNameTag == "Kangaroo" ? "Procoptodon" : DinoNameTag
	,DinoNameTag := DinoNameTag == "GasBags" ? "Gasbag" : DinoNameTag
	,DinoNameTag := DinoNameTag == "Lionfish Lion" ? "Shadowmane" : DinoNameTag
	,DinoNameTag := DinoNameTag == "Sino" ? "Sinomacrops" : DinoNameTag
	,DinoNameTag := DinoNameTag == "TekWyvern" ? "Voidwyrm" : DinoNameTag

	,DinoNameDisplay := DinoNameTag
	,DinoNameDisplay := RegexMatch(DinoClass, "i)Wyvern_Character_BP_(Lightning|Poison|Fire)", Match) ? Match1 " Wyvern" : DinoNameDisplay
	,DinoNameDisplay := RegexMatch(DinoClass, "i)Wyvern_Character_BP_Zombie(Lightning|Poison|Fire)", Match) ? "Zombie " Match1 " Wyvern" : DinoNameDisplay
	,DinoNameDisplay := RegexMatch(DinoClass, "i)CrystalWyvern_Character_BP_(Blood|Tropical|Ember)", Match) ? Match1 " Crystal Wyvern" : DinoNameDisplay


	GenderSimp := RegexMatch(Gender, "False") ? "M" : "F"
	;"CP0"		"UTF-8"		"UTF-16"
	GenderHolder := RegexMatch(Gender, "False") ? "♂" : "♀"
	GenderSize := StrPut(GenderHolder, "CP0")
	VarSetCapacity(vUtf, GenderSize)
	GenderSize := StrPut(GenderHolder, &vUtf, GenderSize, "CP0")
	Gender := StrGet(&vUtf, "UTF-8")

	,Weight := round(Weight,1)
	,Food := round(Food)


	if (ExportRaising || ExportStats || ExportColors){
		ExportHTML := ExportHTML "`r`n<tr>`r`n<td colspan=""20"" align=""center"">`r`n<table width=""100%"">`r`n"
		,ImprintedStr := DinoImprintingQuality ? round(DinoImprintingQuality*100) "% Imprint" : ""
		,ExportTitle := Gender " " DinoNameDisplay "  -  Lvl " DinoLevel
		,ExportHTML := ImprintedStr!="" ? ExportHTML "`r`n`r`n<tr>`r`n`t<th colspan=""6"">" Gender " " DinoNameDisplay "  -  Lvl " DinoLevel "</th>`r`n`t</tr>`r`n`t<tr>`r`n`t<th colspan=""6"">" ImprintedStr "</th>`r`n</tr>`r`n" : ExportHTML "`r`n`r`n<tr>`r`n`t<th colspan=""6"">" ExportTitle "</th>`r`n</tr>`r`n"
	}





	if (ExportColors && !RegexMatch(DinoClass, "i)zombie")){
		FileRead, ASBvaluesJSON, %ASBvaluesFile%
		FoundPosExport := RegExMatch(ASBvaluesJSON, DinoClass)
		,FoundPosC := RegExMatch(ASBvaluesJSON, "s)""colors"":(.+?)""taming""", Match, FoundPosExport)
		,Colors := Match1

		;Tooltip, %DinoClass%`n%FoundPosExport%`n%FoundPosC%

/*		
		FilePath := "ColorIDs.txt"
		if (FileExist(FilePath)){
			FileRead, FileContents, %FilePath%
			ColorIDs := StrSplit(RegexReplace(FileContents,"Unused"), "`n")
			,FileContents := ""
		}
*/
		FoundPosC := 1
		,ASBvaluesJSON := ExportColorHTML := Color1Name := Color2Name := Color3Name := Color4Name := Color5Name := Color6Name := ""
		Loop, 6 {
			i := A_Index-1
			,FoundPosC := RegExMatch(Colors, "s)(name|null)", ColorMatch, FoundPosC+1)
			,Colors%A_Index%Bool := FoundPosC && ColorMatch1="null" ? 0 : 1
	
			if (Colors%A_Index%Bool){ 		 ;;|| ASBvaluesJSON=""
				IniRead, Color%i%, %LatestFile%, Colorization, ColorSet[%i%]
				;FoundPos%A_Index% := 
				RegExMatch(Color%i%, "\(R=(.+?),G=(.+?),B=(.+?),A=(.+?)\)" , ColorMatch%A_Index%)
				;,Alpha := ColorMatch%A_Index%4=0 || ColorMatch%A_Index%4=1 ? 1.0 : ColorMatch%A_Index%4

				,Color%A_Index%Rd := round(255*ColorMatch%A_Index%1**0.456)
				,Color%A_Index%Gd := round(255*ColorMatch%A_Index%2**0.456)
				,Color%A_Index%Bd := round(255*ColorMatch%A_Index%3**0.456)

				,Color%A_Index%Hex := Dec2Hex(Color%A_Index%Rd) Dec2Hex(Color%A_Index%Gd) Dec2Hex(Color%A_Index%Bd)
				;,Color%A_Index%Hex2 := ChooseTextColor(ColorMatch%A_Index%1 ColorMatch%A_Index%2 ColorMatch%A_Index%3)
				,Color%A_Index%Hex2 := ChooseTextColor2(Color%A_Index%Hex)

				,Color%A_Index%Name := Color%A_Index%Hex
				,ColorMatch%A_Index%raw := ColorMatch%A_Index%1 "," ColorMatch%A_Index%2 "," ColorMatch%A_Index%3 "," ColorMatch%A_Index%4

				;Temp := ColorMatch%A_Index%raw
				;Tooltip, %Temp%
				;Sleep 1000

				if (RegexMatch(ColorMatch%A_Index%raw, "0\.0{6},0\.0{6},0\.0{6},1\.0{6}")){
					;Color%A_Index%Name := "No Color (" Color%A_Index%Hex ")"
					Color%A_Index%Name := "No Color (!)"
					,Color%A_Index%Hex := "D3D3D3"
					,Color%A_Index%Hex2 := "000000"
				}else if (RegexMatch(ColorMatch%A_Index%raw, "0\.005000,0\.005000,0\.005000,0\.0{6}")){
					Color%A_Index%Name := "Actual Black (79)"
					,Color%A_Index%Hex := "000000"
					,Color%A_Index%Hex2 := "FFFFFF"
				}else{
					RedMatch := Dec2Hex(Color%A_Index%Rd) "|" Dec2Hex(Color%A_Index%Rd-1) "|" Dec2Hex(Color%A_Index%Rd+1) ;"|" Dec2Hex(Color%A_Index%Rd-2) "|" Dec2Hex(Color%A_Index%Rd+2)
					,GreenMatch := Dec2Hex(Color%A_Index%Gd) "|" Dec2Hex(Color%A_Index%Gd-1) "|" Dec2Hex(Color%A_Index%Gd+1) ;"|" Dec2Hex(Color%A_Index%Gd-2) "|" Dec2Hex(Color%A_Index%Gd+2)
					,BlueMatch := Dec2Hex(Color%A_Index%Bd) "|" Dec2Hex(Color%A_Index%Bd-1) "|" Dec2Hex(Color%A_Index%Bd+1) ;"|" Dec2Hex(Color%A_Index%Bd-2) "|" Dec2Hex(Color%A_Index%Bd+2)

					,ColorMatch := "(" RedMatch ")(" GreenMatch ")(" BlueMatch ")" 

					;Tooltip % ColorMatch
					,CurrentIndex := A_Index


					
					if (RegexMatch(ColorIDstr, "i)([0-9]{1,3})\t([A-z0-9 ]{1,})\t" ColorMatch "`n", Color2Match)){
						Color%CurrentIndex%Name := RegexReplace(Color2Match2 " (" Color2Match1 ")", "^ ")

						if(FileExist("NeededColors.ini")){
							IniRead, ColorsNeeded%i%, NeededColors.ini, %DinoNameDisplay%, %i%
							ColorsNeeded%i% := "," ColorsNeeded%i% ","

							FoundPosC2 := RegExMatch(ColorsNeeded%i%, "," Color2Match1 ",", Color3Match)
							Color%CurrentIndex%Name := FoundPosC2 ? Color%CurrentIndex%Name " *NEEDED*" : Color%CurrentIndex%Name
							if (FoundPosC2)
								SoundBeep
							;Temp := ColorsNeeded%i% "`n" Color2Match1 "`n" Color2Match
							;Tooltip, %i%`n%Temp%
							;Sleep 1500
						}
						ColorMatch := Color2Match := Color3Match := ""
					}

/*
					Loop % ColorIDs.MaxIndex(){
						if (RegexMatch(ColorIDs[A_Index], "i)^(.+?)\t{1,}(.+?)\t{1,}(.+?)\t{1,}" ColorMatch "$", Color2Match)){
							Color%CurrentIndex%Name := RegexReplace(Color2Match2 " (" Color2Match1 ")", "^ ")

							if(FileExist("NeededColors.ini")){
								IniRead, ColorsNeeded%i%, NeededColors.ini, %DinoNameDisplay%, %i%
								ColorsNeeded%i% := "," ColorsNeeded%i% ","

								FoundPosC2 := RegExMatch(ColorsNeeded%i%, "," Color2Match1 ",", Color3Match)
								Color%CurrentIndex%Name := FoundPosC2 ? Color%CurrentIndex%Name " *NEEDED*" : Color%CurrentIndex%Name
								if (FoundPosC2)
									SoundBeep
								;Temp := ColorsNeeded%i% "`n" Color2Match1 "`n" Color2Match
								;Tooltip, %i%`n%Temp%
								;Sleep 1500
							}
							ColorMatch := Color2Match := Color3Match := ""
							break
						}
					}
*/



				}
				ExportColorHTML := ExportColorHTML "`r`n`t<td>`r`n`t`t<button style=""background-color:#" Color%A_Index%Hex ";color:#" Color%A_Index%Hex2 ";border:none"" title=""" Color%CurrentIndex%Name """ disabled>" i "</button>`r`n`t</td>`r`n"
			}else
				Color%A_Index%Hex := ""
		}
		;ColorIDs := FileContents := ""
	}

	ActualBabyMatureSpeed := BabyRates ? BabyRatesMult : BabyMatureSpeed
	HandFeedMaturation := HandFeedMaturation2 := 0
	if (ExportRaising){
		FileRead, ASBvaluesJSON, %ASBvaluesFile%

		FoundPos2 := RegExMatch(ASBvaluesJSON, "s)""gestationTime"": ([0-9.]{1,}).+?""incubationTime"": ([0-9.]{1,}).+?""maturationTime"": ([0-9.]{1,})", RaisingMatch, FoundPosExport)
		,GestationTime := RaisingMatch1, GestationTime := GestationTime ? SecondsToString(EggHatchSpeed ? GestationTime / EggHatchSpeed : GestationTime,1) : GestationTime
		,IncubationTime := RaisingMatch2, IncubationTime := IncubationTime ? SecondsToString(EggHatchSpeed ? IncubationTime / EggHatchSpeed : IncubationTime,1) : IncubationTime
		,MaturationTime := RaisingMatch3
		,ExportHTML := ExportHTML "`r`n<tr>`r`n<td>`r`n`r`n"

		BabyAge := DebugBaby && DebugBabyAge!="" ? round(DebugBabyAge/100,2) : BabyAge
		if (MaturationTime){
			MaturationTime := ActualBabyMatureSpeed!=1.0 ? MaturationTime / ActualBabyMatureSpeed : MaturationTime
			;Tooltip, %MaturationTime%
			
			if (BabyAge<1.0){
				FoundPosHandFeed := RegexMatch(DinoNameTag,"Wyvern|Drake|Magma")
				if (BabyAge<0.1 || FoundPosHandFeed){
					BabySpecialPercentage := 0.117 + 0.825*BabyAge + 0.0597*BabyAge*BabyAge

					,CreatureBaseFoodRate := CreatureMultFoodRate := 0
					,FoundPos2 := RegExMatch(ASBvaluesJSON, "s)""foodConsumptionBase"": ([0-9.]{1,20}).+?""foodConsumptionMult"": ([0-9.]{1,20})", RaisingMatch, FoundPosExport)
					,CreatureBaseFoodRate := RaisingMatch1 ;;;;Same values ASB & Crumple
					,CreatureMultFoodRate := RaisingMatch2 ;;;;;not used???

					if (FileExist(CrumpleCornFilePath)){
						FileRead, CrumpleCornFile, %CrumpleCornFilePath%



						FoundPos := RegexMatch(CrumpleCornFile, "i)\t(" DinoNameTag "|" DinoNameTag2 "): {")
						,FoundPos2 := RegExMatch(CrumpleCornFile, "s)\ttype: ""([A-z]{1,20})""", RaisingMatch, FoundPos)
						,CreatureType := RaisingMatch1!="" ? RaisingMatch1 : "Carnivore"
						,CreatureBabyFoodRate := RegexMatch(DinoNameTag, "i)Giganoto") ? 45.0 : 25.5
						,CreatureExtraBabyFoodRate := 20.0

						;Tooltip, %DinoNameTag%|%DinoNameTag2%`n%CreatureType%


						CreatureMaxFoodRate := RegexMatch(DinoNameTag,"i)Chalico|Hyaen|Megatherium") ? 0.5*CreatureBaseFoodRate*CreatureBabyFoodRate*CreatureExtraBabyFoodRate : CreatureBaseFoodRate*CreatureBabyFoodRate*CreatureExtraBabyFoodRate
						,DinoSitter := RegexMatch(DinoNameTag,"i)Chalico|Hyaen|Megatherium") ? " (Sit)" : ""
						;Tooltip, %CreatureBaseFoodRate%`n%CreatureBabyFoodRate%`n%CreatureExtraBabyFoodRate%`n%CreatureMultFoodRate%`n%BabySpecialPercentage%
						;Tooltip, %DinoNameTag%`n%CreatureMaxFoodRate%
						FoundPos := RegexMatch(CrumpleCornFile, "i)" CreatureType ": \['([A-z ]{1,})'", RaisingMatch)
						,FoodType := RaisingMatch1!="" ? RaisingMatch1 : "Raw Meat"

						


						;;Dino FOOD EXCEPTIONS
						;,FoodType := InStr(DinoNameTag,"Crystal") ? "Primal Crystal" : InStr(DinoNameTag,"Wyvern") ? "Wyvern Milk" : DinoNameTag="Daeodon" ? "Cooked Meat" : DinoNameTag="Kangaroo" ? "Rare Mushroom" : DinoNameTag="Microraptor" ? "Rare Flower" : CreatureType="Carrion" ? "Spoiled Meat" : CreatureType="Piscivore" ? "Raw Fish Meat" : CreatureType="Seed" ? "Plant Y Seed" : CreatureType="Ambergris" ? "Ambergris" : RegexMatch(CreatureType,"i)Herbivore|Omnivore") ? "Mejoberry" : "Raw Meat"
						FoodType := RegexMatch(DinoNameTag, "i)Procop") ? "Rare Mushroom" : RegexMatch(DinoNameTag, "i)Daeodon") ? "Cooked Meat" : FoodType


							;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
/*
						https://en.wikipedia.org/wiki/Exponential_decay


						FOOD RATE changes wrt time
						differential equation for FOOD RATE



						FRt := FR0 * e^-(lambda*t)
						SOLVE FOR LAMBDA

						FRt/FR0 := e^-(lambda*t)				ln(e^x)=x

						ln(FRt/FR0) := lambda * t

						lambda := ln(FRt/FR0)/t

						USE:
							FR0 := Base/Current Food Rate
							t := Last Time when out of food
							FRt := Last Food Rate



							Returns e (which is approximately 2.71828182845905) raised to the Nth power.
							Value := Exp(N)


							Returns the natural logarithm (base e) of Number.
							Value := Ln(Number)


*/	

							TestBabyFoodMax := TestBabyFood := HTMLDisplay.document.getElementById("ExportCurrentFood").value
							TestSecondsInterval := 120
							TestBabyAge := BabyAge
							

							;TestBabyArr1 := []
							;TestBabyArr2 := []
							;TestBabyArr3 := []
							TestFoodRateMin := 999999999
							TestBabyIndex := 1
							TestStarvingTotalTime := TestFoodRateMax := TestBabyLambdasSum := 0 
							TestFoodRate0 := -CreatureBaseFoodRate*400*BabyAge+CreatureBaseFoodRate*400
							;TestBabyLambdas := ""
							
							While (TestBabyFood>0 && TestBabyAge<1.0){
								TestStarvingTotalTime := TestStarvingTotalTime + TestSecondsInterval
								TestBabyAge := TestBabyAge + TestSecondsInterval/MaturationTime
								TestFoodRate := -CreatureBaseFoodRate*400*TestBabyAge+CreatureBaseFoodRate*400
								TestBabyFood := TestBabyFood - TestFoodRate*TestSecondsInterval

								TestFoodRateMin := Min(TestFoodRateMin,TestFoodRate)
								TestFoodRateMax := Max(TestFoodRateMax,TestFoodRate)

								;TestBabyArr1[TestBabyIndex] := TestStarvingTotalTime
								;TestBabyArr2[TestBabyIndex] := TestFoodRate
								;TestBabyArr3[TestBabyIndex] := TestBabyFood

								TestBabyLambdasSum := TestBabyLambdasSum + Ln(TestFoodRate/TestFoodRate0)/TestStarvingTotalTime
								;TestBabyLambdas := TestBabyLambdas Ln(TestFoodRate/TestFoodRate0)/TestStarvingTotalTime "`n"

								
								TestBabyIndex++
								
							}
							TestBabyLambda := TestBabyLambdasSum/TestBabyIndex
							;Clipboard := TestBabyLambdas


/*
							TestBabyLine1 := TestBabyLine2 := ""
							Loop % TestBabyArr1.MaxIndex(){

								;Temp := (TestBabyArr2[A_Index]-TestFoodRateMin)/(TestFoodRateMax-TestFoodRateMin)
								;Temp2 := TestBabyArr2[A_Index] "-" TestFoodRateMin "/" TestFoodRateMax "-" TestFoodRateMin
								; Tooltip, %Temp%`n%Temp2%
								;Sleep 100

								;Temp := (TestBabyArr3[A_Index]/TestBabyFoodMax)
								;Temp2 := TestBabyArr3[A_Index] "/" TestBabyFoodMax
								;Tooltip, %Temp%`n%Temp2%
								;Sleep 100



								TestCurrentTime := round(TestBabyW*TestBabyArr1[A_Index]/TestStarvingTotalTime)
								TestCurrentFoodRate := round(TestBabyH*(TestBabyArr2[A_Index]-TestFoodRateMin)/(TestFoodRateMax-TestFoodRateMin))
								TestCurrentBabyFood := TestBabyH-round(TestBabyH*TestBabyArr3[A_Index]/TestBabyFoodMax)
								
								TestBabyCurrentFoodRateEXP := round(TestBabyH*(TestFoodRate0 * exp(TestBabyLambda*TestCurrentTime))/(TestFoodRateMax-TestFoodRateMin))

								TestBabyLine1 := TestBabyLine1 TestCurrentTime "," TestCurrentFoodRate "|"
								TestBabyLine2 := TestBabyLine2 TestCurrentTime "," TestCurrentBabyFood "|"
								TestBabyLine3 := TestBabyLine2 TestCurrentTime "," TestBabyCurrentFoodRateEXP "|"
								
							}

							TestBabyArr1 := TestBabyArr2 := TestBabyArr3 := ""

							TestBabyLine1 := subStr(TestBabyLine1, 1, StrLen(TestBabyLine1)-1)
							TestBabyLine2 := subStr(TestBabyLine2, 1, StrLen(TestBabyLine2)-1)
							TestBabyLine3 := subStr(TestBabyLine3, 1, StrLen(TestBabyLine3)-1)

							TestBabyW := TestBabyH := 500
							TestBabyBitmap := Gdip_CreateBitmap(TestBabyW, TestBabyH)
							,TestBabyG := Gdip_GraphicsFromImage(TestBabyBitmap)
							,Gdip_SetSmoothingMode(TestBabyG, 2)
							,Gdip_SetInterpolationMode(asbGTestBabyG, 7)
							,Gdip_FillRectangle(TestBabyG, GuiBackgroundBrush, 0, 0, TestBabyW, TestBabyH)

							TestBabyPen1 := Gdip_CreatePen("0x44FF0000", 2)
							TestBabyPen2 := Gdip_CreatePen("0x446600FF00", 2)
							TestBabyPen3 := Gdip_CreatePen("0x44660000FF", 2)
							Gdip_DrawLines(TestBabyG, TestBabyPen1, TestBabyLine1)
							Gdip_DrawLines(TestBabyG, TestBabyPen2, TestBabyLine2)
							Gdip_DrawLines(TestBabyG, TestBabyPen3, TestBabyLine3)
							Gdip_DeletePen(TestBabyPen1)
							Gdip_DeletePen(TestBabyPen2)
							Gdip_DeletePen(TestBabyPen3)

							Gdip_SaveBitmapToFile(TestBabyBitmap, CapDir "\LastExportBabyFood.jpg", 100)	
*/
	
						if (TestBabyFood<=0 && TestBabyAge<1.0)
							ExportHTML := ExportHTML "<tr><td>`r`n`t`tTime To Starving*`r`n</td>`r`n`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t`t" SecondsToString(TestStarvingTotalTime,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
						else if (TestBabyFood>0 && TestBabyAge>=1.0)
							ExportHTML := ExportHTML "<tr><td>`r`n`t`tFully Raised*`r`n</td>`r`n`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t`t" round(TestBabyFood,1) " food`r`n`t</table>`r`n</td>`r`n</tr>`r`n"



						;Tooltip, %CreatureType%`n%FoodType%
						FoundPos3 := RegExMatch(CrumpleCornFile, "s)'" FoodType "'.+?food: ([0-9.*]{0,20}).+?stack: ([0-9.*]{0,20}).+?spoil: ([0-9.*]{0,20}).+?weight: ([0-9.*]{0,20}).+?waste: ([0-9.*]{0,20})", RaisingMatch)
						if (FoundPos3){
							FoodTypeAmount := RaisingMatch1
							,FoodTypeStack := RaisingMatch2
							,FoodTypeSpoil := RaisingMatch3
							,FoodTypeWeight := RaisingMatch4
							,FoodTypeWaste := RaisingMatch5

							;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
							,ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`r`n</tr>`r`n`r`n"
							;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
							if (FoundPosHandFeed){
								TimeToStarving := Food*(0.25+0.75*BabyAge)/CreatureMaxFoodRate
								,ExportHTML := ExportHTML "<tr><td>`r`n`t`tTime To Starving`r`n</td>`r`n`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t`t" SecondsToString(TimeToStarving,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
							}else{

								HandFeedMaturation := round(100*(FoodTypeWeight*CreatureMaxFoodRate*MaturationTime)/(10*Weight*FoodTypeAmount+10*FoodTypeWeight*CreatureMaxFoodRate*MaturationTime),2)
								,ExportHTML := ExportHTML "<tr><td>`r`n`t`tHand Feed Until" DinoSitter "`r`n</td>`r`n<td colspan=""100"" align=""right"">`r`n`t`t" HandFeedMaturation " %`r`n</td>`r`n</tr>`r`n"

								,HandFeedMaturation2 := round(HandFeedMaturation - (100*(Food*BabyAge)/CreatureMaxFoodRate/MaturationTime),2)
								,ExportHTML := ExportHTML "<tr><td>`r`n`t`tHand Feed Until" DinoSitter "`r`n</td>`r`n<td colspan=""100"" align=""right"">`r`n`t`t" HandFeedMaturation2 " %`r`n</td>`r`n</tr>`r`n"
							}
*/

							ExportHTML := ExportHTML "<tr><td>`r`n`t`tFood Type`r`n</td>`r`n<td colspan=""100"" align=""right"">`r`n`t`t" FoodType "`r`n</td>`r`n</tr>`r`n"
							;,ExportHTML := ExportHTML "<tr><td>`r`n`t`tFood Rate" DinoSitter "`r`n</td>`r`n<td align=""right"">`r`n`t`t" round(CreatureMaxFoodRate,4) " (f/s)`r`n</td>`r`n</tr>`r`n"
							



							,CreatureCurrentFoodRate := round(-CreatureBaseFoodRate*400*BabyAge+CreatureBaseFoodRate*400,3)
							,ExportHTML := ExportHTML "<tr><td>`r`n`t`tFood Rate *" DinoSitter "`r`n</td>`r`n<td align=""right"">`r`n`t`t" round(CreatureCurrentFoodRate,4) " (f/s)`r`n</td>`r`n</tr>`r`n"
							
							HTMLDisplay.document.getElementById("CDFoodRate").value := round(CreatureCurrentFoodRate,4)



							,CurrentTimeMaxFood := (FoodTypeAmount*floor((Weight*BabyAge)/FoodTypeWeight))/CreatureMaxFoodRate
							,ExportHTML := BabyAge<HandFeedMaturation/100 && !FoundPosHandFeed ? ExportHTML "<tr><td>`r`n`t`tCurrent Weight Time`r`n</td>`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t`t" SecondsToString(CurrentTimeMaxFood,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n" : ExportHTML

						}
					}
					CrumpleCornFile := ""
					;,ExportHTML := !FoundPosHandFeed ? ExportHTML "<tr><td>`r`n`t`tJuvenile Remaining`r`n</td>`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t`t" SecondsToString(MaturationTime*(0.1-BabyAge),1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n" : ExportHTML
					
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;,ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`r`n</tr>`r`n`r`n"
					;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

					;,ExportHTML := !FoundPosHandFeed ? ExportHTML "<tr><td>`r`n`t`tJuvenile Time`r`n</td>`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t`t" SecondsToString(MaturationTime*0.1,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n" : ExportHTML
				}
				ExportHTML := ExportHTML "<tr><td>`r`n`t`tCurrent Maturation`r`n</td>`r`n<td colspan=""100"" align=""right"">`r`n`t`t" round(BabyAge*100,2) " %`r`n</td>`r`n</tr>`r`n"
				ExportHTML := ExportHTML "<tr><td>`r`n`t`tMaturation Remaining`r`n</td>`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t`t" SecondsToString((1.0-BabyAge)*MaturationTime,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"

			}
			
			ExportHTML := ExportHTML "<tr><td>`r`n`t`tMaturation Time Total`r`n</td>`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t`t" SecondsToString(MaturationTime,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			,ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`r`n</tr>`r`n`r`n"
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		}
		ExportHTML := GestationTime ? ExportHTML "<tr><td>`r`n`t`tGestation Time`r`n</td>`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t" GestationTime "`r`n`t</table>`r`n</td>`r`n</tr>`r`n" : ExportHTML
		,ExportHTML := IncubationTime ? ExportHTML "<tr><td>`r`n`t`tIncubation Time`r`n</td>`r`n<td align=""right"">`r`n`t<table width=""1px"">`r`n`t" IncubationTime "`r`n`t</table>`r`n</td>`r`n</tr>`r`n" : ExportHTML
		,ExportHTML := ExportHTML "`r`n</table>`r`n</td>`r`n</tr>`r`n`r`n`r`n"
		,ASBvaluesJSON := ""
	}





	if ((ExportStats || ExportAddLibrary) && ASBhwnd){
		;;Check that ASB its done extracting.
		CapturedRGB := ""
		,PixelWait := PixelsOT1 := PixelsOT2 := 0
		Sleep 100
		While (PixelsOT1<24 && PixelsOT2<24 && PixelWait<100){
			CapturedASBbitmap := Gdip_BitmapFromHWND(ASBhwnd)
			,CapturedRGB := int2hex(Gdip_GetPixel(CapturedASBbitmap, ASBLibraryX, ASBLibraryY))
			;CapturedRGB := int2hex(Gdip_GetPixel(CapturedASBbitmap, 150, 860))
			,Gdip_DisposeImage(CapturedASBbitmap), CapturedASBbitmap := ""
			,PixelsOT1 := RegexMatch(CapturedRGB, "90EE90") ? PixelsOT1 + 1 : 0 		;;green
			,PixelsOT2 := RegexMatch(CapturedRGB, "87CEFA") ? PixelsOT2 + 1 : 0 		;;blue
			,PixelWait := PixelWait + 1

			Sleep 25
		}

		if (ExportStats){
			CapturedASBbitmap := Gdip_BitmapFromHWND(ASBhwnd)

			,pBitmapStats := Gdip_CloneBitmapArea(CapturedASBbitmap, asbx, asby, asbw, asbh)
			,Gdip_DisposeImage(CapturedASBbitmap), CapturedASBbitmap := ""

			;,Gdip_SaveBitmapToFile(pBitmapStats, CapDir "\LastExport.jpg", 100)
			,Gdip_SaveBitmapToFile(pBitmapStats, ClipsDirASB "\LastExport.jpg", 80)


			;,Gdip_DeleteGraphics(Gstats)
			,Gdip_DisposeImage(pBitmapStats)


			;Run, ClipsDirASB "\LastExport2.jpg"

			GoSub, MakeASBSnip
		}


		if(ExportAddLibrary && (PixelsOT1>=15 || PixelsOT2>=15)){
			DllCall("SetWindowPos"
			, "UInt", ASBhwnd ;handle
			, "UInt", 0 ;HWND_TOP
			, "Int", 50000 ;x
			, "Int", 0 ;y
			, "Int", ASBGW ;width
			, "Int", ASBGH ;height
			, "UInt", 0x4010) ;SWP_ASYNCWINDOWPOS-0x4000		SWP_NOACTIVATE-0x0010

			Sleep 20
			ControlClick, X%ASBLibraryX% Y%ASBLibraryY%, ahk_id %ASBhwnd%,,,, NA


			DllCall("SetWindowPos"
			, "UInt", ASBhwnd ;handle
			, "UInt", ExportBringFront ? -1 : 0 ;z
			, "Int", ASBGX ;x
			, "Int", ASBGY ;y
			, "Int", ASBGW ;width
			, "Int", ASBGH ;height
			, "UInt", 0x4010) ;SWP_ASYNCWINDOWPOS-0x4000		SWP_NOACTIVATE-0x0010

			if (ExportBringFront){
				DllCall("SetWindowPos"
				, "UInt", ASBhwnd ;handle
				, "UInt", -2 ;z
				, "Int", ASBGX ;x
				, "Int", ASBGY ;y
				, "Int", ASBGW ;width
				, "Int", ASBGH ;height
				, "UInt", 0x4012) ;SWP_ASYNCWINDOWPOS-0x4000		SWP_NOACTIVATE-0x0010
			}

		}
		
	}else
		ASBhwnd := ""

	ExportHTML := ASBhwnd && ExportStats ? ExportHTML "`r`n`r`n<tr>`r`n`t<td colspan=""6"" style=""text-align:center;""><img id=""LastExport"" max-width=""100%"" height=""auto"" src=""" asbSnipB64 """></td>`r`n</tr>`r`n" : ExportHTML


	,ExportHTML := ExportColors ? ExportHTML "`r`n`r`n<tr>`r`n<td colspan=""20"">`t`n<table width=""1px"" align=""center"">`r`n<tr>" ExportColorHTML "`r`n</tr>`r`n</table>`r`n</td>`r`n</tr>`r`n" : ExportHTML
	,ExportColorHTML := ""

	,HTMLDisplay.document.getElementById("DinoExportTable").innerHTML := "<tr>`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`n</tr>`n`n" ExportHTML
	,ExportHTML := ""

	,HTMLDisplay.document.getElementById("AutoDinoExportContent").style.display := "table"
	,HTMLDisplay.document.getElementById("DinoExportTable").style.display := "table"
	,HTMLDisplay.document.getElementById("AutoDinoExportContent").style.width := "100%"
	,HTMLDisplay.document.getElementById("DinoExportTable").style.width := "100%"
	,HTMLDisplay.document.getElementById("AutoDinoExportArrow").src := CapDir "\Arrow1.png"


	if (ExportRaising || ExportStats || ExportColors){
		MaxChars := 0
		Loop, 6
			MaxChars := StrLen(Color%A_Index%Name)>MaxChars ? StrLen(Color%A_Index%Name) : MaxChars
		MaxChars := StrLen(ExportTitle)>MaxChars ? StrLen(ExportTitle) : MaxChars

		,ExportOverlayW := asbw
		,ExportOverlayW := MaxChars*9+SquareSize2+margin*2>ExportOverlayW ? MaxChars*9+SquareSize2+margin*2 : ExportOverlayW

		,ExportOverlayH := margin + SquareSize
		,ExportOverlayH := ASBhwnd && ExportStats ? ExportOverlayH + asbh + margin : ExportOverlayH
		,ExportOverlayH := ImprintedStr!="" ? ExportOverlayH + SquareSize+margin : ExportOverlayH
		;,ExportOverlayH := ExportRaising && ((BabyAge>0.1 && BabyAge<1.0) || BabyAge<0.1) ? ExportOverlayH+ExportTextSize+margin : ExportOverlayH
		,ExportOverlayH := ExportRaising && BabyAge<1.0 && (BabyAge<0.1 || FoundPosHandFeed) ? ExportOverlayH+2*(ExportTextSize+margin) : ExportOverlayH
		,ExportOverlayH := ExportRaising && HandFeedMaturation2/100>BabyAge && BabyAge<1.0 ? ExportOverlayH+ExportTextSize+margin : ExportOverlayH
		,ExportOverlayH := ClipMutNumsCheck && TotalMuts!=0 ? ExportOverlayH+ExportTextSize+margin : ExportOverlayH
		,ExportOverlayH := (ExportRaising && BabyAge<1.0) && ((TestBabyFood<=0 && TestBabyAge<1.0) || (TestBabyFood>0 && TestBabyAge>=1.0)) ? ExportOverlayH+ExportTextSize+margin : ExportOverlayH


		if (ExportColors){
			Loop, 6
				if (Color%A_Index%Hex || Color%A_Index%Name)
					ExportOverlayH := ExportOverlayH + margin + SquareSize
		}
		ExportOverlayH := ExportOverlayH+margin
		;,ExportY := A_ScreenHeight - ExportOverlayH 

		SetTimer, DeleteOverlay, off
		Gui, 7:Destroy
		Gui, 7:-Caption +E0x80000 +E0x20 +HwndExporthwnd +AlwaysOnTop +ToolWindow +OwnDialogs ;+LastFound Create GUI
		Gui, 7:Show, NA
		ShowingExportOverlay := 1
		,hbm7 := CreateDIBSection(ExportOverlayW, ExportOverlayH) ; Create a gdi bitmap drawing area
		,hdc7 := CreateCompatibleDC() ; Get a device context compatible with the screen
		,obm7 := SelectObject(hdc7, hbm7) ; Select the bitmap into the device context
		,GSnip := Gdip_GraphicsFromHDC(hdc7) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
		,Gdip_SetSmoothingMode(GSnip, 4)
		;Gdip_SetInterpolationMode(GSnip, 7)


		;;pBrush := Gdip_BrushCreateSolid("0xCC000000")
		,pBrushasb := Gdip_BrushCreateSolid("0xFF000000")
		,Gdip_FillRoundedRectangle(GSnip, pBrushasb, 0, 0, ExportOverlayW, ExportOverlayH, ceil(SquareSize/2))
		,Gdip_DeleteBrush(pBrushasb)

		;Close Window X
		,pPenasb:=Gdip_CreatePen("0xFFFFFFFF", 2)
		,Gdip_DrawLines(GSnip, pPenasb, ExportOverlayW-SquareSize2-margin "," margin "|" ExportOverlayW-margin "," margin+SquareSize2)
		,Gdip_DrawLines(GSnip, pPenasb, ExportOverlayW-margin "," margin "|" ExportOverlayW-SquareSize2-margin "," margin+SquareSize2)
		,Gdip_DeletePen(pPenasb)


		,ExportY2 := margin
		,Gdip_TextToGraphics(GSnip, ExportTitle, "x" 0 " y" ExportY2 " w" ExportOverlayW " h" ExportOverlayH " Center Bold cFFFFFFFF s" ExportTextSizeTitle, FontFace)
		,ExportY2 := ExportY2 + margin + SquareSize

		if(ImprintedStr!=""){
			Gdip_TextToGraphics(GSnip, ImprintedStr, "x" 0 " y" ExportY2 " w" ExportOverlayW " h" ExportOverlayH " Center Bold cFFFFFFFF s" ExportTextSizeTitle, FontFace)
			,ExportY2 := ExportY2 + margin + SquareSize
		}
		if (ASBhwnd && ExportStats){
			;CapturedASBbitmap := Gdip_CreateBitmapFromFile(CapDir "\LastExport2.jpg")
			CapturedASBbitmap := Gdip_CreateBitmapFromFile(ClipsDirASB "\LastExport2.jpg")
			,Gdip_DrawImage(GSnip, CapturedASBbitmap, ExportOverlayW/2-asbw/2, ExportY2, asbw, asbh)
			,Gdip_DisposeImage(CapturedASBbitmap), CapturedASBbitmap := ""
			,ExportY2 := ExportY2 + margin + asbh
		}

		if (ExportRaising){
			if (BabyAge<1.0 ){
				if (BabyAge<0.1 || FoundPosHandFeed){
					Gdip_TextToGraphics(GSnip, "Food Rate *" DinoSitter, "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Left Bold cFFFFFFFF s" ExportTextSize, FontFace)
					Gdip_TextToGraphics(GSnip, round(CreatureCurrentFoodRate,4) " (f/s)", "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Right Bold cFFFFFFFF s" ExportTextSize, FontFace)
					ExportY2 := ExportY2 + margin + ExportTextSize

					if (TestBabyFood<=0 && TestBabyAge<1.0){
						Gdip_TextToGraphics(GSnip, "Time To Starving*", "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Left Bold cFFFFFFFF s" ExportTextSize, FontFace)
						Gdip_TextToGraphics(GSnip, SecondsToString(TestStarvingTotalTime,0), "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Right Bold cFFFFFFFF s" ExportTextSize, FontFace)
						ExportY2 := ExportY2 + margin + ExportTextSize
					}else if (TestBabyFood>0 && TestBabyAge>=1.0){
						Gdip_TextToGraphics(GSnip, "Fully Raised*", "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Left Bold cFFFFFFFF s" ExportTextSize, FontFace)
						Gdip_TextToGraphics(GSnip, round(TestBabyFood,1) " food", "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Right Bold cFFFFFFFF s" ExportTextSize, FontFace)
						ExportY2 := ExportY2 + margin + ExportTextSize
					}
				}

				Gdip_TextToGraphics(GSnip, "Maturation Remaining", "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Left Bold cFFFFFFFF s" ExportTextSize, FontFace)
				,Gdip_TextToGraphics(GSnip, SecondsToString((1.0-BabyAge)*MaturationTime,0), "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Right Bold cFFFFFFFF s" ExportTextSize, FontFace)
				,ExportY2 := ExportY2 + margin + ExportTextSize
			
			}

/*
			if (BabyAge<0.1){


				if (HandFeedMaturation2/100>BabyAge){
					Gdip_TextToGraphics(GSnip, "Hand Feed Until" DinoSitter, "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Left Bold cFFFFFFFF s" ExportTextSize, FontFace)
					,Gdip_TextToGraphics(GSnip, HandFeedMaturation2 " %", "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Right Bold cFFFFFFFF s" ExportTextSize, FontFace)
					,ExportY2 := ExportY2 + margin + ExportTextSize
				}

				Gdip_TextToGraphics(GSnip, "Juvenile Remaining", "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Left Bold cFFFFFFFF s" ExportTextSize, FontFace)
				,Gdip_TextToGraphics(GSnip, SecondsToString((0.1-BabyAge)*MaturationTime,0), "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Right Bold cFFFFFFFF s" ExportTextSize, FontFace)
				,ExportY2 := ExportY2 + margin + ExportTextSize


			}else{
				if (BabyAge<1.0){
					Gdip_TextToGraphics(GSnip, "Maturation Remaining", "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Left Bold cFFFFFFFF s" ExportTextSize, FontFace)
					,Gdip_TextToGraphics(GSnip, SecondsToString((1.0-BabyAge)*MaturationTime,0), "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Right Bold cFFFFFFFF s" ExportTextSize, FontFace)
					,ExportY2 := ExportY2 + margin + ExportTextSize
				}
			}
*/
		}

		if (TotalMuts!=0 && ClipMutNumsCheck){
			Gdip_TextToGraphics(GSnip, "Total Mutations", "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Left Bold cFFFFFFFF s" ExportTextSize, FontFace)
			,Gdip_TextToGraphics(GSnip, TotalMuts, "x" margin " y" ExportY2 " w" ExportOverlayW-2*margin " h" ExportTextSize " Right Bold cFFFFFFFF s" ExportTextSize, FontFace)
			,ExportY2 := ExportY2 + margin + ExportTextSize
			,TotalMuts := 0
		}

		if (ExportColors){
			Loop, 6{
				if (Color%A_Index%Hex || Color%A_Index%Name){
					pBrushasb := Gdip_BrushCreateSolid("0xFF" Color%A_Index%Hex)
					,Gdip_FillRoundedRectangle(GSnip, pBrushasb, margin, ExportY2, SquareSize, SquareSize, ceil(SquareSize/6))
					,Gdip_DeleteBrush(pBrushasb)
					,Gdip_TextToGraphics(GSnip, A_Index - 1, "x" margin " y" ExportY2+3 " w" SquareSize " h" SquareSize " cFF" Color%A_Index%Hex2 " s" ExportTextSize " r4 Center vCenter", FontFace)
					
					,Gdip_TextToGraphics(GSnip, Color%A_Index%Name, "x" SquareSize + 2*margin + 1 " y" ExportY2+4 " cFF" Color%A_Index%Hex2 " s" ExportTextSize " r4", FontFace)
					,Gdip_TextToGraphics(GSnip, Color%A_Index%Name, "x" SquareSize + 2*margin " y" ExportY2+3 " cFF" Color%A_Index%Hex " s" ExportTextSize " r4", FontFace)
				
					,ExportY2 := ExportY2 + margin + SquareSize
				}
			}
			
		}

		;CapturedSplashBitmap := Gdip_CreateBitmapFromFile(SplashImagePath)
		;,Gdip_DrawImage(GSnip, CapturedSplashBitmap, 0, 0, ButtonW, ButtonW)

		
		CapturedSplashBitmap := GdipCreateFromBase64(SplashImageSimpleB64)
		,Gdip_DrawImage(GSnip, CapturedSplashBitmap, 0, 0, ButtonW, ButtonW)
		,Gdip_DisposeImage(CapturedSplashBitmap), CapturedSplashBitmap := ""

		;global TSTText := "Choose Growth Direction: 1)Up     2)Right     3)Down     4)Left"
		;global TSTText := "Choose Anchor Point: 1)Top Left     2)Bottom Left     3)Top Right     4)Bottom Right"
		ExportXactual := ExportAnchor=1 || ExportAnchor=2 ? ExportX : ExportX-ExportOverlayW
		ExportYactual := ExportAnchor=1 || ExportAnchor=3 ? ExportY : ExportY-ExportOverlayH

		
		;Make asb clip save file name easier to find


		ASBbitmap := Gdip_CreateBitmapFromHBITMAP(hbm7)
		;Gdip_SaveBitmapToFile(ASBbitmap, ClipsDirASB "\" A_Now ".jpg", 80)
		Gdip_SaveBitmapToFile(ASBbitmap, ClipsDirASB "\" DinoNameDisplay "-" GenderSimp DinoLevel "-" A_Now ".jpg", 80)
		Gdip_DisposeImage(ASBbitmap)

		ASBalphaActual := round(ASBalpha*255*0.01)
		UpdateLayeredWindow(Exporthwnd, hdc7, ExportXactual, ExportYactual, ExportOverlayW, ExportOverlayH, ASBalphaActual)
		,SelectObject(hdc7, obm7) ; Select the object back into the hdc
		,DeleteObject(hbm7) ; Now the bitmap may be deleted
		,DeleteDC(hdc7) ; Also the device context related to the bitmap may be deleted
		,Gdip_DeleteGraphics(GSnip) ; The graphics may now be deleted

		,ASBtimeMS := ASBtime*1000
		SetTimer, DeleteOverlay, -%ASBtimeMS%
	}

	



	Exporting := 0
return

MakeASBSnip:
	ASBhwnd := WinExist("ARK Smart")
	if (ASBhwnd){
		CapturedASBbitmap := Gdip_BitmapFromHWND(ASBhwnd)

		,pBitmapstats := Gdip_CloneBitmapArea(CapturedASBbitmap, asbx, asby, asbw, asbh)
		,Gdip_DisposeImage(CapturedASBbitmap), CapturedASBbitmap := ""

		;,Gdip_SaveBitmapToFile(pBitmapstats, CapDir "\LastExport.jpg", 100)
		,Gdip_SaveBitmapToFile(pBitmapstats, ClipsDirASB "\LastExport.jpg" 80)
		
		;,Gdip_DeleteGraphics(Gstats)
	}else{
		;pBitmapstats := Gdip_CreateBitmapFromFile(CapDir "\LastExport.jpg")
		pBitmapstats := Gdip_CreateBitmapFromFile(ClipsDirASB "\LastExport.jpg")
	}

	asbpBitmap := Gdip_CreateBitmap(asbw, asbh)
	,asbG := Gdip_GraphicsFromImage(asbpBitmap)
	,Gdip_SetSmoothingMode(asbG, 2)
	,Gdip_SetInterpolationMode(asbG, 7)

	,ASBinvertR := HTMLDisplay.document.getElementById("ASBinvertR").value/100
	,ASBinvertG := HTMLDisplay.document.getElementById("ASBinvertG").value/100
	,ASBinvertB := HTMLDisplay.document.getElementById("ASBinvertB").value/100

	,ASBalphaR := HTMLDisplay.document.getElementById("ASBalphaR").value/100
	,ASBalphaG := HTMLDisplay.document.getElementById("ASBalphaG").value/100
	,ASBalphaB := HTMLDisplay.document.getElementById("ASBalphaB").value/100
	
	,ASBgreyscale := RegexMatch(HTMLDisplay.document.getElementById("ASBgreyscale").checked, "1|on") ? 1 : 0


	if (ASBgreyscale){
		asbMatrix := "0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1"
		,Gdip_DrawImage(asbG, pBitmapstats, 0, 0, asbw, asbh, 0, 0, asbw, asbh, asbMatrix)
		,Gdip_DisposeImage(pBitmapstats)
		,Gdip_DeleteGraphics(asbG)

		pBitmapstats := asbpBitmap

		,asbpBitmap := Gdip_CreateBitmap(asbw, asbh)
		,asbG := Gdip_GraphicsFromImage(asbpBitmap)
		,Gdip_SetSmoothingMode(asbG, 2)
		,Gdip_SetInterpolationMode(asbG, 7)
	}

	asbMatrix := ASBinvertR "|0|0|0|0|0|" ASBinvertG "|0|0|0|0|0|" ASBinvertB "|0|0|0|0|0|1|0|" ASBalphaR "|" ASBalphaG "|" ASBalphaB "|0|1"
	,Gdip_DrawImage(asbG, pBitmapstats, 0, 0, asbw, asbh, 0, 0, asbw, asbh, asbMatrix)
	,Gdip_DisposeImage(pBitmapstats)
	,Gdip_DeleteGraphics(asbG)

	;,Gdip_SaveBitmapToFile(asbpBitmap, CapDir "\LastExport2.jpg", 100)
	,Gdip_SaveBitmapToFile(asbpBitmap, ClipsDirASB "\LastExport2.jpg", 80)
	asbSnipB64 := ClipsDirASB "\LastExport2.jpg"

	;asbSnipB64 := "data:image/png;base64," Vis2.stdlib.Gdip_EncodeBitmapTo64string(asbpBitmap, "PNG", 75)
	;HTMLDisplay.document.getElementById("LastExport").src := asbSnipB64
	Gdip_DisposeImage(asbpBitmap)

Return

DeleteOverlay:
	ShowingExportOverlay := 0
	Gui, 7:Destroy
return

/*
ResetFWCounters:
	LastEat := LastDrink := A_Now
	DrinkTime := EatTime := 1
return
*/
CDResetKeyFunction:
	if (WinsActive() && CDToggle=0){
		NotifySpamN := NotifySpamN>=CDResetNumber ? NotifySpamN : NotifySpamN + 1
		NotifyAFKTime := NotifySpamN>=CDResetNumber ? A_Now : NotifyAFKTime
	}
return


QTHotkeyFunction:
	ToggleKey := QTHotkey
	WaitingForInv := 0
	GoSub, QTHotkeyFunctionActual
return

QTHotkeyFunctionActual:

	if (QTCheck && WinsActive()){
		QTinProgress := 1
		SetTimer, WatchingForSlotCap, Off

		;if (AutoClickEnabled)
		;	SetTimer, AutoClickPressKey, Off
		
		;;;;;;;;;;;;;;;;;;;;;;Regular Quick Transfer Function
		if (!CheckInv()){
			if(QTFromYou=0 && QTDrop=0)
				Send {i}
			else
				Send {f}
		}
		CheckInvI := 1
		WaitingForInv := 1
		While (!CheckInv() && CheckInvI<200 && WaitingForInv){
			CheckInvI++
			Sleep 1
		}
		WaitingForInv := 0
		
		if (CheckInv() && WinsActive()){
			if (QTFromYou=0){
				QTX1 := YourSearchX
				,QTY1 := YourSearchY
				,QTX2 := QTDrop=0 ? YourDropAllX : YourTransferAllX
				,QTY2 := QTDrop=0 ? YourDropAllY : YourTransferAllY
			}else{
				QTX1 := TheirSearchX
				,QTY1 := TheirSearchY
				,QTX2 := QTDrop=0 ? TheirDropAllX : TheirTransferAllX
				,QTY2 := QTDrop=0 ? TheirDropAllY : TheirTransferAllY
			}			
			
			if (InStr(QTSearch,",")){
				QTSearchArr := StrSplit(QTSearch, ",")
				Loop %	QTSearchArr.MaxIndex(){
					QTSearchStr := QTSearchArr[A_Index]
					if (StrLen(QTSearchStr)>0){
						MouseMove, QTX1, QTY1, 1
						Sleep 50
						MouseClick, Left,,, 2
						Sleep 50
						if (CheckInv())
							Send %QTSearchStr%
						Else
							break
						if (CheckInv()){
							Sleep 50
							MouseClick, Left, QTX2, QTY2, 1, 3
							Sleep 25
							MouseMove, QTX1, QTY1, 0
						}
					}
					Sleep %QTDelay%
				}
			}else{
				MouseMove, QTX1, QTY1, 2
				Sleep 50
				MouseClick, Left,,, 2
				Sleep 50
				if (CheckInv())
					Send %QTSearch%
				Else
					return
				Sleep 50
				if (CheckInv()){
					MouseClick, Left, QTX2, QTY2, 1, 3
					Sleep 25
					MouseMove, QTX1, QTY1, 0
				}
			}
			;Sleep 30
			if (CheckInv()){
				if(QTFromYou=0 && QTDrop=0)
					Send {i}
				else
					Send {f}
			}
		}

		;if (AutoClickEnabled){
		;	SetTimer, AutoClickPressKey, %AutoClickTimer%
		;	GoSub, AutoClickPressKey
		;}
	
		QTinProgress := 0
		if (AutoQTSlotCap){
			SetTimer, WatchingForSlotCap, %AutoQTCapDelayMS%
		}
	}
return



WatchingForSlotCap:
	if (AutoQTSlotCap){
		;ArkhwndSC := WinsActive()
		if (WinsActive()){
			pBitmapHaystackBlack := Gdip_BitmapFromHWND(WinsActive())
			
			
				;OutputListCyan := RegexReplace(OutputListCyan, "0\,0")
			if (QTFromYou=0){


				pBitmapNeedleBlack2 := Gdip_CreateBitmapFromFile(CapDir "\BlackBox2.png")
				Gdip_ImageSearch(pBitmapHaystackBlack, pBitmapNeedleBlack2, OutputListBlack1, 0.75*A_ScreenWidth, 0.75*A_ScreenHeight, A_ScreenWidth, A_ScreenHeight, 2)

				Gdip_ImageSearch(pBitmapHaystackBlack, pBitmapNeedleBlack2, OutputListBlack2, 0, 0, 0.25*A_ScreenWidth, 0.25*A_ScreenHeight, 2)
				Gdip_ImageSearch(pBitmapHaystackBlack, pBitmapNeedleBlack2, OutputListBlack3, 0, 0.75*A_ScreenHeight, 0.25*A_ScreenWidth, A_ScreenHeight, 2)
				Gdip_ImageSearch(pBitmapHaystackBlack, pBitmapNeedleBlack2, OutputListBlack4, 0.75*A_ScreenWidth, 0, A_ScreenWidth, 0.25*A_ScreenHeight, 2)
				Gdip_DisposeImage(pBitmapNeedleBlack2)

			}else{
				pBitmapNeedleBlack1 := Gdip_CreateBitmapFromFile(CapDir "\BlackBox1.png")
				Gdip_ImageSearch(pBitmapHaystackBlack, pBitmapNeedleBlack1, OutputListBlack1, 0.75*A_ScreenWidth, 0, A_ScreenWidth, 0.25*A_ScreenHeight, 2)

				Gdip_ImageSearch(pBitmapHaystackBlack, pBitmapNeedleBlack2, OutputListBlack2, 0, 0, 0.25*A_ScreenWidth, 0.25*A_ScreenHeight, 2)
				Gdip_ImageSearch(pBitmapHaystackBlack, pBitmapNeedleBlack2, OutputListBlack3, 0, 0.75*A_ScreenHeight, 0.25*A_ScreenWidth, A_ScreenHeight, 2)
				Gdip_ImageSearch(pBitmapHaystackBlack, pBitmapNeedleBlack2, OutputListBlack4, 0.75*A_ScreenWidth, 0.75*A_ScreenHeight, A_ScreenWidth, A_ScreenHeight, 2)
				Gdip_DisposeImage(pBitmapNeedleBlack1)
			}

			Gdip_DisposeImage(pBitmapHaystackBlack)
			
			


			if (!QTinProgress && OutputListBlack1 && !OutputListBlack2 && !OutputListBlack3 && !OutputListBlack4){
				QTinProgress := 1
				GoSub, QTHotkeyFunction
			}
		}
	}
return

GachaFarmingHotkeyFunction:
	ToggleKey := GachaFarmingHotkey
	if (WinsActive() && GachaFarmingCheck && !GachaFarming){
		GachaFarming := 1
		if (GachaFarmingO1){												;Crystals
			FilePath := CapDir "\GachaCrystal.png"
			if (!FileExist(FilePath)){		;check for gacha crystal image
				MsgBox2("File does not exist:`n""" FilePath """", "0 r3")
				GachaFarmingDispStr := "You need to create or get ""GachaCrystal.png"""
				HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
			}else{
				if (GachaFarmingO3=0){															;Transfer Items
					GachaFarmingDispStr := "Accessing Remote Invenory"
					HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
					if (!CheckInv())
						Send {f}
				}else{																			; Craft Ele or Do Nothing
					GachaFarmingDispStr := "Accessing Personal Invenory"
					HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
					if (!CheckInv())
						Send {i}
				}
				CheckInvI := 1
				WaitingForInv := 1
				While (!CheckInv() && CheckInvI<200 && WaitingForInv && WinsActive() && GachaFarming){
					CheckInvI++
					Sleep 10
				}
				WaitingForInv := 0
				
				if (CheckInv() && WinsActive() && GachaFarming){
					GachaFarmingDispStr := "Opening Gacha Crystals"
					HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
					MouseClick, Left, YourSearchX, YourSearchY, 2, 3
					Sleep 200
					if (CheckInv())
						Send gacha
					Else
						return


					
					MouseClick, Left, A_ScreenWidth/2, A_ScreenHeight/2
					Sleep 1000


					;Crack Crystals

					
					pBitmapNeedleGF := Gdip_CreateBitmapFromFile(CapDir "\GachaCrystal.png")
					OutputListGF := 1

					While (OutputListGF!="" && WinsActive() && GachaFarming){			;Crack Crystals

						pBitmapHaystackGF := Gdip_BitmapFromHWND(WinsActive())
						Gdip_ImageSearch(pBitmapHaystackGF, pBitmapNeedleGF, OutputListGF, 0, 0, 0.5*A_ScreenWidth, A_ScreenHeight, 15)
						OutputListGF := RegexReplace(OutputListGF, "0\,0")
						if (OutputListGF!="" && WinsActive() && GachaFarming){
							FoundPosGF := RegexMatch(OutputListGF, "^([0-9]{1,}),([0-9]{1,})", MatchGF)
							CurrentSlotY := FoundPosGF ? MatchGF2 : YourTransferSlotY
							Loop, 1 {	;;;N Rows
								CurrentSlotX := FoundPosGF ? MatchGF1 : YourTransferSlotX
								Loop, 6 {	;;;N Columns
									
									MouseMove, %CurrentSlotX%, %CurrentSlotY%, 1
									;Sleep 5
									Send {e 4}

									CurrentSlotX := CurrentSlotX+SlotInc
									Sleep 15
								}
								CurrentSlotY := CurrentSlotY+SlotInc
							}
						}
					}
					
					Gdip_DisposeImage(pBitmapHaystackGF)
					Gdip_DisposeImage(pBitmapNeedleGF)
					;Done Cracking Crystals
					GachaFarmingDispStr := "No more Gacha Crystals"
					HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr

					Sleep 300
					if (WinsActive() && GachaFarming){
						if (GachaFarmingO3=1){											;Craft Element
							GachaFarmingDispStr := "Craft Element"
							,HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr


							,CurrentSlotX :=	YourSearchX + 3*SlotInc					;Click on Crafting
							,CurrentSlotY :=	YourSearchY	- SlotInc/2
							MouseClick, Left, CurrentSlotX, CurrentSlotY, 2, 3
							Sleep 300

							MouseClick, Left, YourSearchX, YourSearchY, 2, 3
							Sleep 300

							if (CheckInv() && GachaFarming)								;Search Element
								Send element
							Sleep 300

							if (CheckInv() && GachaFarming){
								MouseClick, Left, %YourTransferSlotX%, %YourTransferSlotY%
								Sleep 300

								Send {a 5}
								sleep 250
								Send {Esc}
							}
						}else if (GachaFarmingO3=0){															;Transfer Items
							GachaFarmingDispStr := "Transfer All to Remote"
							HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr

							MouseClick, Left, YourSearchX, YourSearchY, 2, 3
							Sleep 300

							if (CheckInv() && GachaFarming)								;Search Element
								Send element

							Sleep 300
							if (CheckInv() && GachaFarming){
								MouseClick, Left, YourTransferAllX, YourTransferAllY, 1, 5
								MouseMove, A_ScreenWidth/2, A_ScreenHeight/2, 3
								Sleep 300
								Send {Esc}
							}
						}else{
							Sleep 300
							if (CheckInv() && GachaFarming)
								Send {Esc}
						}
					}
				}else{
					GachaFarmingDispStr := "Accessing Invenory timed out"
					,HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
				}
			}
		}else{																;Iguana

			GachaFarmingDispStr := "Accessing Iguanadon Invenory"
			,HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
			if (!CheckInv() && GachaFarming)
				Send {f}
			
			CheckInvI := WaitingForInv := 1
			While (!CheckInv() && CheckInvI<200 && WaitingForInv && GachaFarming){
				CheckInvI++
				Sleep 10
			}
			WaitingForInv := 0
			Sleep 2000
			if (CheckInv() && WinsActive() && GachaFarming){

				GachaFarmingDispStr := "Take a Stack"
				HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
				MouseClick, Left, TheirTransferSlotX, TheirTransferSlotY, 1, 3
				Sleep 100
				Send {t}
			}
			if (CheckInv() && WinsActive() && GachaFarming){
				Sleep 500
				GachaFarmingDispStr := "Replace a Stack"
				HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
				Sleep 500
			}
			if (CheckInv() && WinsActive() && GachaFarming){
				MouseClick, Left, YourSearchX, YourSearchY, 2, 3
				Sleep 50
				Send err
				Sleep 50
				MouseClick, Left, YourTransferSlotX, YourTransferSlotY, 1, 3
				Sleep 100
				Send {t}
				Sleep 50
			}
			if (CheckInv() && WinsActive() && GachaFarming){
				Send {Esc}
				GachaFarmingDispStr := "Make Seeds"
				HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
				Sleep 250
			}
			if (!CheckInv() && WinsActive() && GachaFarming){
				Send {e down}
				Sleep 500
				MouseMove, 0.5*A_ScreenWidth, 0.33*A_ScreenHeight, 3
				Sleep 30
				Send {e up}
				Sleep 500
				Send {f}

				CheckInvI=1
				While (!CheckInv() && WinsActive() && CheckInvI<100 && GachaFarming)
				{
					CheckInvI++
					Sleep 5
				}
				if (CheckInv() && GachaFarming && WinsActive()){

					if (GachaFarmingO2){												;Drop Seeds
						GachaFarmingDispStr := "Drop All Seeds"
						HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
						MouseClick, Left, TheirDropAllX, TheirDropAllY, 3, 3
					}else{																;Take Seeds
						GachaFarmingDispStr := "Take All Seeds"
						HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
						MouseClick, Left, TheirSearchX, TheirSearchY, 2, 3
						Sleep 50
						Send seed
						Sleep 50
						MouseClick, Left, TheirTransferAllX, TheirTransferAllY, 1, 3

						Sleep 50

						Send {Esc}
					}
					Send {f}
				}else
					GachaFarmingDispStr := "Accessing Invenory timed out"
					HTMLDisplay.document.getElementById("GachaFarmingDebugInfo").value := GachaFarmingDispStr
			}
		}
		GachaFarming := 0
	}else{
		GachaFarming := 0
	}

Return

FeedBabiesHotkeyFunction:
	ToggleKey := FeedBabiesHotkey
	if (WinsActive() && FeedBabiesCheck)
		FeedBabiesEnabled := FeedBabiesEnabled ? 0 : 1
	else
		FeedBabiesEnabled := 0
return
	
;asdfasdfasdf
JoinSimFunction:
	JoinSimNow := 0	
	MMList := ""
	;WinsActive()
	if (JoinSimCheck && JoinSimURL!="" ){
		if (!WinsExist()){
			if (AlertsCheck && AlertsInput9){
				SoundFile := "Game is not Running. Launching Now"
				GoSub, MakeSound
			}
			Run, %ShooterGameEXE%
			Sleep, 20000
			JoinSimNow := 1
		}else if (!WinExist("Game Info") && !CheckInv() && CheckDC(JoinSimReason)){
			if (AlertsCheck && AlertsInput9){
				SoundFile := JoinSimReason
				GoSub, MakeSound
			}
			JoinSimNow := 1
		}else if (!WinExist("Game Info")){
			MMHaystack := Gdip_BitmapFromHWND(WinsExist())
			,MMNeedle := Gdip_CreateBitmapFromFile(CapDir "\ArkNews2.png")
			,Gdip_ImageSearch(MMHaystack, MMNeedle, MMList, 0.66*A_ScreenWidth, 0, A_ScreenWidth, 0.25*A_ScreenHeight, JoinSimVariation)

			if (MMList!=""){
				if (AlertsCheck && AlertsInput9){
					SoundFile := "Main Menu"
					GoSub, MakeSound
				}

				JoinSimNow := 1
			}

			Gdip_DisposeImage(MMHaystack)
			Gdip_DisposeImage(MMNeedle)
		}


		if(JoinSimNow && JoinSimCheck){
			if (AlertsCheck && AlertsInput9){
				SoundFile := "Joining " JoinSimString
				GoSub, MakeSound
			}
			Run, steam://connect/%JoinSimURL%
		}

	}

return


ChooseServer:
;asdfasdf
	SearchFilePath := A_Temp2 "\SearchServer.json"
	SearchURL := "https://api.battlemetrics.com/servers?fields[server]=name,ip,portQuery&page[size]=100&sort=rank&filter[game]=ark&filter[search]=" ServerString
	UrlDownloadToFile, %SearchURL%, %SearchFilePath%
	FileRead, ServersJSON, %SearchFilePath%
	ServersResults := ""
	ServersArr := StrSplit(ServersJSON, "},{")
	if (ServersArr.MaxIndex()>0){
		Loop % ServersArr.MaxIndex(){
			ServerName := ServerIP := ServerPort := ""
			,FoundPos := RegexMatch(ServersArr[A_Index], """name"":""(.+?) - (.+?)""\,", ServersMatch)
			,ServerName := RegexReplace(ServersMatch1, "(....................)", "$1-<br>")
			,FoundPos := RegexMatch(ServersArr[A_Index], """ip"":""(.+?)""\,", ServersMatch)
			,ServerIP := ServersMatch1
			,FoundPos := RegexMatch(ServersArr[A_Index], """portQuery"":([0-9]{1,})\}", ServersMatch)
			,ServerPort := ServersMatch1

			ServersResults := ServersResults "`n<tr>`n`t<td style=""width:66%;"">" ServerName "</td>`n`t<td><input type=""button"" onclick=""window.location.href = 'myapp://' + this.id;"" id=""connect/" ServerIP ":" ServerPort """ value=""Connect""><input type=""button"" onclick=""window.location.href = 'myapp://' + this.id;"" name=""" ServerName """ id=""AddFavoriteServer/" ServerIP ":" ServerPort """ value=""Add""></td>`n</tr>"

		}
		ServersResults := "<tr><td colspan=""2"" style=""border-top:solid 2px""></td></tr>" ServersResults
		HTMLDisplay.document.getElementById("ServersResultsContent").innerHTML := ServersResults
		HTMLDisplay.document.getElementById("ServersResultsContent").style.display := "table"
		HTMLDisplay.document.getElementById("ServersResultsArrow").src := CapDir "\Arrow1.png"
	}

	ServersJSON := ServersResults := ""
return


UpdateFavoriteServers:
IniRead, FavoriteServers, %FileSettings%, Main, FavoriteServers
FSarr := StrSplit(substr(FavoriteServers, 4, StrLen(FavoriteServers)-6),"~~~")
if (FSarr.MaxIndex()>0){
	FavoriteServersHTML := ""
	Loop % FSarr.MaxIndex(){
		FoundPos := RegexMatch(FSarr[A_Index], "^(.+?)\|\|\|(.+?)$", FSMatch)
		if (FoundPos && StrLen(FSarr[A_Index])>10){
			ServerIP := FSMatch2
			,ServerName := ServerNameDisp := FSMatch1
			,ServerNameDisp := RegexReplace(ServerNameDisp, "(..................................)", "$1-<br>")
			,ServerNameDisp := RegexReplace(ServerNameDisp, "(NA|OC|EU)\-PV(P|E)\-Official\-", "$1-PV$2-Official-<br>")
			,ServerID := RegexReplace(ServerIP, "\.|:")
			,%ServerID%DOWN := 0

			;ServerNumber := RegexReplace(ServerName, "^.+?([0-9]{1,3}).+?", "$1")
			,FoundPos := RegexMatch(ServerName, "^.+?([0-9]{1,})", FSMatch)
			,ServerNumber := FSMatch1
			While (StrLen(ServerNumber)<3){
				ServerNumber := "0" ServerNumber
			}
			

			FileMapName := RegexMatch(ServerName, "Aberration") ? MapURLs[1] : RegexMatch(ServerName, "Center") ? MapURLs[3] : RegexMatch(ServerName, "Crystal") ? MapURLs[5] : RegexMatch(ServerName, "Extinction") ? MapURLs[7] : RegexMatch(ServerName, "GenOne") ? MapURLs[9] : RegexMatch(ServerName, "GenTwo") ? MapURLs[11] : RegexMatch(ServerName, "Ragnarok") ? MapURLs[15] : RegexMatch(ServerName, "Scorched") ? MapURLs[17] : RegexMatch(ServerName, "Valguero") ? MapURLs[19] : RegexMatch(ServerName, "Lost") ? MapURLs[21] : RegexMatch(ServerName, "Fjordur") ? MapURLs[23] : MapURLs[13]
			FileMapName := MapImagesPath "\" FileMapName			


			;FavoriteServersHTML := FavoriteServersHTML ServerNumber "<tr id=""" ServerID """ >`t<th id=""" ServerID "col"" style=""text-align:left;""><button type=""button"" onclick=""buttonpress2(this)"" id=""" ServerID "image"" class=""ServerImageButton""><div style=""width:" MaxMapWidth "px""><img id=""" ServerID "imageimage"" src=""" FileMapName """ style=""vertical-align:middle;width:" MaxMapWidth "px;""></div></button></th><th>" RegexReplace(ServerName, "(..................................)", "$1-<br>") "<br><h id=""" ServerID "Players""></h></th></tr>"
			;,FavoriteServersHTML := FavoriteServersHTML "<tr id=""" ServerID "imageContent"" class=""collapseablecontent"" style=""display:none;"">`t<td id=""" ServerID "col-2"" colspan=""10""></td></tr>"
			;,FavoriteServersHTML := FavoriteServersHTML "<tr id=""" ServerID "2"">`t<td colspan=""2""><table style=""width:100%;""><tr class=""submitCellDouble""><td><input type=""button"" onclick=""window.location.href = 'myapp://' + this.id;"" id=""connect/" ServerIP """ value=""Connect"" title=""" ServerIP """></td><td><input type=""button"" onclick=""window.location.href = 'myapp://' + this.id;"" id=""RemoveFavoriteServer/" ServerIP """ value=""Remove""></td></tr></td></tr></table>" 
			;,FavoriteServersHTML := FavoriteServersHTML "<tr><td colspan=""2"" style=""border-top:solid 2px""></td></tr>`n"


			FavoriteServersHTML := FavoriteServersHTML ServerNumber "<tr id=""" ServerID """ >`t<th id=""" ServerID "col"" style=""text-align:left;""><button type=""button"" onclick=""buttonpress2(this)"" id=""" ServerID "image"" class=""ServerImageButton""><div style=""width:" MaxMapWidth "px""><img id=""" ServerID "imageimage"" src=""" FileMapName """ style=""vertical-align:middle;width:" MaxMapWidth "px;""></div></button></th><th>" ServerNameDisp " <h id=""" ServerID "Players""></h><br><input type=""button"" onclick=""window.location.href = 'myapp://' + this.id;"" id=""connect/" ServerIP """ value=""Connect"" title=""" ServerIP """>&nbsp;<input type=""button"" onclick=""window.location.href = 'myapp://' + this.id;"" id=""RemoveFavoriteServer/" ServerIP """ value=""Remove""></th></tr>"
			FavoriteServersHTML := FavoriteServersHTML "<tr id=""" ServerID "imageContent"" class=""collapseablecontent"" style=""display:none;"">`t<td id=""" ServerID "col-2"" colspan=""10""></td></tr><td></tr></table>" 
			FavoriteServersHTML := FavoriteServersHTML "<tr><td colspan=""2"" style=""border-top:solid 2px""></td></tr>`n"


		}
	}
	if (ServerFavoritesSort)
		Sort, FavoriteServersHTML, N
	FavoriteServersHTML := RegexReplace(FavoriteServersHTML, "[0-9]{1,}<tr id", "<tr id")
	FavoriteServersHTML := Substr(FavoriteServersHTML, 1, StrLen(FavoriteServersHTML)-60)
	HTMLDisplay.document.getElementById("FavoriteServersContentInner").innerHTML := "<tr>`n`t<td colspan=""2"" style=""border-top:solid 4px""></td>`n</tr>`n" FavoriteServersHTML 
}else{
	HTMLDisplay.document.getElementById("FavoriteServersContentInner").innerHTML := "<tr>`n`t<td colspan=""2"" style=""text-align:center;"">No Servers Added</td>`n</tr>`n<tr>`n`t<td colspan=""2"" style=""text-align:center;"">Use Server Lookup</td>`n</tr>"
}
;Clipboard := FavoriteServersHTML
HTMLDisplay.document.getElementById("FavoriteServersContentInner").style.display := "table"
HTMLDisplay.document.getElementById("FavoriteServersContentInner").style.width := "100%"
FSarr := ""
return


CheckServers:
;;;;FIX TO RAM HOG!
	if (ServerFavoritesCheck || QueryOnce){			 ;|| UpdatingFavoriteServers
		if (!FoundNodeJS || !FoundNodeGamedig){
			HTMLDisplay.document.getElementById("ServerFavoritesCheck").checked := 0
			ServerFavoritesCheck := 0
		}else{
			IniRead, FavoriteServersStatus, %FileSettings%, Main, FavoriteServers
			CurrentServer1 := CurrentServer2 := NotifyServersCrash := NotifyServersRecover := ""
			,ServerFoundPos := RegexMatch(FavoriteServersStatus, "~~~(.+?)\|\|\|(.+?):(.+?)~~~", CurrentServer)

			While (ServerFoundPos){
				if (CurrentServer2!="" && CurrentServer3!=""){
					ServerID := RegexReplace(CurrentServer2 CurrentServer3, "\.|:")
					Run %ComSpec% /c "gamedig --type arkse %CurrentServer2%:%CurrentServer3% --debug >"%A_ScriptDir%\FavoriteServers\%ServerID%.txt"",,Hide

					ServerPath := A_ScriptDir "\FavoriteServers\" ServerID ".txt"
					
					if (FileExist(ServerPath)){
						FileRead, CurrentServerText, %ServerPath%
						CurrentServerStatus := RegexMatch(CurrentServerText, "Query failed") ? 0 : 1

						LastDOWN := %ServerID%DOWN
						%ServerID%DOWN := CurrentServerStatus ? 0 : %ServerID%DOWN + 1


						if (%ServerID%DOWN>=3){
							NotifyServersCrash := NotifyServersCrash RegexReplace(CurrentServer1, "^.+?\-([A-z]{1,})([0-9]{1,})", "$1$2") " has crashed..."
						}else if (%ServerID%DOWN=0 && LastDOWN>=3)
							NotifyServersRecover := NotifyServersRecover RegexReplace(CurrentServer1, "^.+?\-([A-z]{1,})([0-9]{1,})", "$1$2") " has recovered..."


						if (CurrentServerStatus)
							FileMapName := RegexMatch(CurrentServer1, "Aberration") ? MapURLs[1] : RegexMatch(CurrentServer1, "Center") ? MapURLs[3] : RegexMatch(CurrentServer1, "Crystal") ? MapURLs[5] : RegexMatch(CurrentServer1, "Extinction") ? MapURLs[7] : RegexMatch(CurrentServer1, "GenOne") ? MapURLs[9] : RegexMatch(CurrentServer1, "GenTwo") ? MapURLs[11] : RegexMatch(CurrentServer1, "Ragnarok") ? MapURLs[15] : RegexMatch(CurrentServer1, "Scorched") ? MapURLs[17] : RegexMatch(CurrentServer1, "Valguero") ? MapURLs[19] : RegexMatch(ServerName, "Lost") ? MapURLs[21] : RegexMatch(ServerName, "Fjordur") ? MapURLs[23] : MapURLs[13]
						else
							FileMapName := RegexMatch(CurrentServer1, "Aberration") ? MapURLs[2] : RegexMatch(CurrentServer1, "Center") ? MapURLs[4] : RegexMatch(CurrentServer1, "Crystal") ? MapURLs[6] : RegexMatch(CurrentServer1, "Extinction") ? MapURLs[8] : RegexMatch(CurrentServer1, "GenOne") ? MapURLs[10] : RegexMatch(CurrentServer1, "GenTwo") ? MapURLs[12] : RegexMatch(CurrentServer1, "Ragnarok") ? MapURLs[16] : RegexMatch(CurrentServer1, "Scorched") ? MapURLs[18] : RegexMatch(CurrentServer1, "Valguero") ? MapURLs[20] : RegexMatch(ServerName, "Lost") ? MapURLs[22] : RegexMatch(ServerName, "Fjordur") ? MapURLs[24] : MapURLs[14]

						FileMapName := MapImagesPath "\" FileMapName

						PlayersFoundPos := 1, TotalPlayers := 0
						,Players := PlayersMatch := PlayersMatch1 := PlayersMatch2 := ""
						While (PlayersFoundPos){
							
							PlayersMatch2 := RegexReplace(PlayersMatch2, "\.[0-9]{1,}$")
							;Players := PlayersMatch1!="" ? "<tr><td class=""temp"">" PlayersMatch2 "</td><td>" PlayersMatch1 "</td><td><table width=""1px"" align=""right"">" SecondsToString(PlayersMatch2,1) "</table></td></tr>`n" Players : Players
							;Players := PlayersMatch1!="" ? PlayersMatch2 "<td>" PlayersMatch1 "</td><td><table width=""1px"" align=""right"">" SecondsToString(PlayersMatch2,1) "</table></td></tr>`n" Players : Players
							Players := PlayersMatch1!="" ? "<td>" PlayersMatch1 "</td><td><table width=""1px"" align=""right"">" SecondsToString(PlayersMatch2,1) "</table></td></tr>`n" Players : Players
							TotalPlayers := PlayersMatch1!="" ? TotalPlayers + 1 : TotalPlayers

							PlayersFoundPos := RegexMatch(CurrentServerText, "i)Found player: (.*?) 0 ([0-9.]{1,})\n", PlayersMatch, PlayersFoundPos+1)
						}
						;Clipboard := Players
						;Players := Substr(Players, 1, StrLen(Players)-1)
						;Sort, Players, N R
						Players := RegExReplace(Players, "<td class=""temp"">[0-9]{1,}<\/td>")
						
						HTMLDisplay.document.getElementById(ServerID "imageContent").innerHTML := "<td colspan=""10"">`n<table style=""width:95%;text-align:center;"">`n`t<tr><td colspan=""2"" style=""border-top:solid 1px;""></td></tr>`n`t<tr>`n`t`t<th style=""text-align:center;"">Steam ID</th>`n`t`t<th style=""text-align:center;"">Play Time</th>`n`t</tr>`n" Players "`n</table>`n</td>"
						HTMLDisplay.document.getElementById(ServerID "imageimage").src := FileMapName
						HTMLDisplay.document.getElementById(ServerID "imageimage").title := RegexMatch(CurrentServerText, "Query failed") ? "Offline" : "Online"
						HTMLDisplay.document.getElementById(ServerID "Players").innerHTML := "(" TotalPlayers "/70)"

					}
					;Tooltip, %ServerPath%
				}
				CurrentServer := CurrentServer1 := CurrentServer2 := CurrentServer3 := CurrentServerText := Players := ""

				ServerFoundPos := RegexMatch(FavoriteServersStatus, "~~~(.+?)\|\|\|(.+?):(.+?)~~~", CurrentServer, ServerFoundPos+1)
			}
		}
	}
return






GetOfficialRates:
	if (OfficialRatesCheck || !RatesUptoDate){
		RatesUptoDate := 0
		reqRates := ComObjCreate("Msxml2.XMLHTTP.6.0")
		; Open a reqRatesuest with async enabled.

		;URL := "http://arkdedicated.com/dynamicconfig.ini"
		;URL := "https://raw.githubusercontent.com/arodbusiness/Ark-AIO-V2/master/dynamicconfig.ini"

		reqRates.open("GET", "http://arkdedicated.com/dynamicconfig.ini", true)
		;reqRates.open("GET", "https://raw.githubusercontent.com/arodbusiness/Ark-AIO-V2/master/dynamicconfig.ini", false)

		reqRates.SetRequestHeader("Pragma", "no-cache")
		reqRates.SetRequestHeader("Cache-Control", "no-cache, no-store")
		reqRates.SetRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT")


		reqRates.onreadystatechange := Func("Ready").bind(reqRates)		; Set our callback function [requires v1.1.17+].
		reqRates.send()									; Send the request.  Ready() will be called when it's complete.
	}
return


Ready(reqRates) {
    if (reqRates.readyState != 4){
    	  ; Not done yet.
        return
    }else if (reqRates.status == 200){ ; OK.
    	GoSub, ObjReady
    }
}

ObjReady:
if (!RatesUptoDate){
	if (StrLen(rawRatesLast)<1)
		rawRatesLast := reqRates.responseText
	else if(reqRates.responseText != rawRatesLast && StrLen(rawRatesLast)>20 && !NotifyRates && !AutoClickEnabled && !FeedBabiesEnabled){
		rawRatesLast := reqRates.responseText
		NotifyRates := AlertsInput10 ? 1 : 0
	}

    OfficialRates := reqRates.responseText

    ,reqRates := ""
    ,OfficialRates := RegExReplace(OfficialRates, "[A-z:]{1,}=[A-z:]{1,}")


    ;=[0-9\.]{3,}.+?$
    ;,OfficialRates := RegExReplace(OfficialRates, "(HexagonRewardMultiplier=[0-9.]{3,})(.+?)", "$1")
    FoundPosOR := RegexMatch(OfficialRates, "\n\,")
    if (FoundPosOR)
    	OfficialRates := SubStr(OfficialRates, 1, FoundPosOR-2)


    ;Clipboard := OfficialRates
	;SoundBeep

    OfficialRates := RegExReplace(OfficialRates, "`r?`n", "</td></tr>`n<tr><td>")
    ,OfficialRates := RegExReplace(OfficialRates, "=", ":</td><td style=""text-align:center;width:25%"">")
    ,OfficialRates := RegExReplace(OfficialRates, "Multiplier")
    ,OfficialRates := RegExReplace(OfficialRates, "([a-z])([A-Z])", "$1 $2")

	,FoundPos := RegexMatch(OfficialRates, "Baby Mature Speed:</td><td.+?>([0-9.]{1,})</td>", MatchServer)
	,BabyMatureSpeed := FoundPos ? MatchServer1 : BabyMatureSpeed
	,FoundPos := RegexMatch(OfficialRates, "Egg Hatch Speed:</td><td.+?>([0-9.]{1,})</td>", MatchServer)
	,EggHatchSpeed := FoundPos ? MatchServer1 : EggHatchSpeed

	FormatTime, RatesUpdatedTime, , hh:mmtt M/d/yyyy



	OfficialRates := "<tr><td colspan=""100"" style=""border-top:solid 2px""></td></tr>`n<tr><td>" OfficialRates "</td></tr>`n<tr><td colspan=""2"" style=""text-align:center;"">Last Checked: " RatesUpdatedTime "</td></tr>"

    HTMLDisplay.document.getElementById("OfficialRatesContentInner").innerHTML := OfficialRates
    ,HTMLDisplay.document.getElementById("OfficialRatesContentInner").style.display := "table"
	,HTMLDisplay.document.getElementById("OfficialRatesContentInner").style.width := "100%"
    ,OfficialRates := ""
    ,RatesUptoDate := 1

	if (NotifyRates && AlertsInput10){
		NotifyRates := 0
		SoundBeep
		SoundBeep
		SoundBeep
		;HTMLDisplay.document.getElementById("OfficialRatesContent").style.display := "block"
	    ;MsgBox, Ark Official Rates have been changed!
	    MsgBox2("Ark Official Rates have been changed!`n" RatesUpdatedTime, "0 r2")
	    
	}
}
return





UpdatePresets:
	Loop, 2
	{
		PresetName := A_Index=1 ? "AutoClick" : "QT"

		TempVar := A_Index=1 ? 1 : 0

		IniRead, %PresetName%PresetsStr, %FileSettings%, Main, %PresetName%PresetsStr
		PresetsArr := StrSplit(SubStr(%PresetName%PresetsStr, 5, StrLen(%PresetName%PresetsStr)-8), "\/\/")
		PresetsHTML := PresetsStr := NewPresetsStr := ""
		i := 1
	  	Loop % PresetsArr.MaxIndex(){
	  		if (StrLen(PresetsArr[A_Index])>6){
	  			PresetsArr[A_Index] := !RegexMatch(PresetsArr[A_Index], "^[0-9]{1,}\-\-\-") ? i "---" PresetsArr[A_Index] : PresetsArr[A_Index]
	  			PresetsArr[A_Index] := RegexReplace(PresetsArr[A_Index], "^([0-9]{1,})\-\-\-", i "---")
	  			NewPresetsStr := NewPresetsStr "\/\/" PresetsArr[A_Index] 
				FoundPos := RegexMatch(PresetsArr[A_Index], "---(.+?)\|\|", PresetMatch)
				PresetsHTML := PresetsHTML  "<option id=""" PresetName i """ value=""" i """ label=""" PresetMatch1 """>" PresetsArr[A_Index] "</option>`n"
				i := i+1
			}
		}
		i := i-1
		NewPresetsStr := NewPresetsStr "\/\/"
		;if (PresetName="AutoClick")
		;	Clipboard := NewPresetsStr
		NewPresetsStr := RegexReplace(NewPresetsStr, "\\/\\/\\/\\/", "\/\/")

		IniWrite, %NewPresetsStr%, %FileSettings%, Main, %PresetName%PresetsStr

		%PresetName%PresetsHTMLinner := PresetsHTML
		PresetsHTML := "`n" PresetsHTML "<option value=""0"">Add New</option>`n"
		HTMLDisplay.document.getElementById(PresetName "PresetNumber").innerHTML := PresetsHTML
		if (A_Index=1)
			AutoClickPresetsArr := PresetsArr
		PresetsArr := Presets2Arr := PresetsHTML := ""
		if (%PresetName%PresetNumber=0){
			%PresetName%PresetNumber := i
			IniWrite, %i%, %FileSettings%, Main, %PresetName%PresetNumber
			HTMLDisplay.document.getElementById(PresetName "PresetNumber").value := i

		}
	}
return




SaveWindowPos:
	WinGetPos, GX, GY, GW, GH, ahk_id %MainHwnd%
	if(GX!=-32000 && GY!=-32000){
		GW2 := GW - 16
		GH2 := GH - 39

		if GX is number
			IniWrite, %GX%, %FileSettings%, Main, WindowX
		if GY is number
			IniWrite, %GY%, %FileSettings%, Main, WindowY
		if (GX>300)
			IniWrite, %GW2%, %FileSettings%, Main, WindowW
		if (!FirstPass)
			IniWrite, %GH2%, %FileSettings%, Main, WindowH

		TitleBarX := ButtonW+8
		,TitleBarY := 2
		,TitleBarW := GW-ButtonW*4-6
		,TitleBarH := 30
		,ButtonX1 := GW-ButtonW
		,ButtonX2 := ButtonX1-ButtonW
		,ButtonX3 := ButtonX2-ButtonW
		,ButtonX4 := ButtonX3-ButtonW
		,HTMLx := 8
		,HTMLy := TitleBarH
		,HTMLw := GW-HTMLx*2
		,HTMLh := GH-HTMLy-HTMLx

		GuiControl, 1:Move, Mover, x%TitleBarX% y%TitleBarY% w%TitleBarW% h%TitleBarH%
	    GuiControl, 1:Move, HTMLDisplay, xX%HTMLx% y%HTMLy% w%HTMLw% h%HTMLh%
	    GuiControl, 1:Move, HTMLDisplay2, xX%HTMLx% y%HTMLy% w%HTMLw% h%HTMLh%

	    GuiControl, 1:+Redraw, CloseButton
	    GuiControl, 1:Move, CloseButton, x%ButtonX1%
	    
	    GuiControl, 1:+Redraw, MinButton
	    GuiControl, 1:Move, MinButton, x%ButtonX2%

	    GuiControl, 1:+Redraw, RestartButton
	    GuiControl, 1:Move, RestartButton, x%ButtonX3%


		ActualImageW := GW>IconW ? IconW : GW
		,HTMLDisplay.document.getElementById("SplashImageContent").style.left := GW/2 - ActualImageW/2 + HTMLx/2 "px"
		,HTMLDisplay.document.getElementById("SplashImageContent").width := HTMLDisplay.document.getElementById("SplashImageContent").height := ActualImageW 
		,HTMLDisplay.document.getElementById("SplashImageTop").width := HTMLDisplay.document.getElementById("SplashImageTop").height := ActualImageW-25
		,HTMLDisplay.document.getElementById("SplashImageBottom").width := HTMLDisplay.document.getElementById("SplashImageBottom").height := ActualImageW-25
		,HTMLDisplay.document.getElementById("MainTable").style.top := ShowingSplashImageButton || FirstPass ? ActualImageW-65 "px" : 0 "px"
		,HTMLDisplay.document.getElementById("SplashImageContent").style.display := ShowingSplashImageButton || FirstPass ? "block" : "none"

		,HTMLDisplay2.document.getElementById("SplashImageContent").style.left := GW/2 - ActualImageW/2 + HTMLx/2 "px"
		,HTMLDisplay2.document.getElementById("SplashImageContent").width := HTMLDisplay2.document.getElementById("SplashImageContent").height := ActualImageW 
		,HTMLDisplay2.document.getElementById("SplashImageTop").width := HTMLDisplay2.document.getElementById("SplashImageTop").height := ActualImageW-25
		,HTMLDisplay2.document.getElementById("SplashImageBottom").width := HTMLDisplay2.document.getElementById("SplashImageBottom").height := ActualImageW-25

		,HTMLDisplay.document.getElementById("SpawnMapMapdiv").width := HTMLDisplay.document.getElementById("SpawnMapMapdiv").height := ActualImageW-30 "px"
		,HTMLDisplay.document.getElementById("SpawnMapMapImage").width := HTMLDisplay.document.getElementById("SpawnMapMapImage").height := ActualImageW-45
		,HTMLDisplay.document.getElementById("SpawnMapMapOverlay").width := HTMLDisplay.document.getElementById("SpawnMapMapOverlay").height := ActualImageW-45
		,HTMLDisplay.document.getElementById("SpawnMapTable").style.height := ActualImageW + 60 "px"

		,HTMLDisplay.document.getElementById("MainBody").style.height := HTMLh
	}
return

ActivateMainWindow:
	WinGetPos, GX, GY, GW, GH, ahk_id %MainHwnd%
	;Tooltip, %GX%`n%GY%`n%GW%`n%GH%
	if(GX=-32000 || GY=-32000 || GW=0 || GH=0){
		WinRestore, ahk_id %MainHwnd%
		WinActivate, ahk_id %MainHwnd%
	}else{
		WinMinimize, ahk_id %MainHwnd%
	}
return

ExitSub:
	if (FileExist(FileSettings))
		GoSub, SaveWindowPos
	ExitApp
return

ReloadSub:
	if (FileExist(FileSettings))
		GoSub, SaveWindowPos
	Reload
return

MakeSound:

	if (AlertAltCheck)
		SetDefaultEndpoint( GetDeviceID(Devices, OutputSoundName) )

	Sleep 300

/*
	SoundSplit := StrSplit(SoundFile, " ")
	Loop % SoundSplit.MaxIndex(){
		oVoice.Speak(SoundSplit[A_Index], 1)
	}
*/
	SoundFile := RegexReplace(SoundFile, "!([0-9]{1})([0-9]{1})([0-9]{1})!([0-9]{1})", "$1 $2 $3 $4")
	SoundFile := RegexReplace(SoundFile, "(?<![0-9])([0-9]{1})([0-9]{1})([0-9]{1})(?![0-9])", "$1 $2 $3") 	;;Speak Out 3 digit number like 1 2 3
	SoundFile := RegexReplace(SoundFile, "(?<![0-9])([0-9]{2})([0-9]{2})(?![0-9])", "$1 $2") 				;;Speak Out 4 digit number like 12 34



	SoundSplitLocs := []
	,SoundSplitLens := []
	,SoundSplitName := []
	,SoundTotalLen := StrLen(SoundFile)

	Loop, Files, %SoundDir%\*.mp3
	{
		FoundPosSound := RegexMatch(SoundFile, "i)" RegexReplace(A_LoopFileName, "\.mp3"))
		while (FoundPosSound && StrLen(A_LoopFileName)>6)
		{
			SoundSplitLocs.push(FoundPosSound)
			SoundSplitLens.push(StrLen(A_LoopFileName))
			SoundSplitName.push(A_LoopFileName)
			FoundPosSound := RegexMatch(SoundFile, "i)" RegexReplace(A_LoopFileName, "\.mp3"), SoundMatch, FoundPosSound+1)
		}
	}

	if(SoundSplitLocs.MaxIndex()>0){
		if(SoundSplitLocs[1]>1){
			SoundPiece := RegexReplace(SubStr(SoundFile,1,SoundSplitLocs[1]-1), " $")

			oVoice.Speak(SoundPiece, 2)
		}


		Loop % SoundSplitLocs.MaxIndex()
		{
			SoundCurrentFile := SoundDir "\" SoundSplitName[A_Index]

			SoundPlay, %SoundCurrentFile%, WAIT

			NextIndex := A_Index+1
			SoundFilePos := SoundSplitLocs[A_Index]+SoundSplitLens[A_Index]-3

			if (NextIndex<=SoundSplitLocs.MaxIndex() && SoundTotalLen>SoundFilePos)
			{
				SoundPieceStart := SoundSplitLocs[A_Index]+SoundSplitLens[A_Index]-3
				SoundPieceLen := SoundSplitLocs[A_Index+1]-SoundPieceStart
				SoundPiece := RegexReplace(SubStr(SoundFile, SoundPieceStart, SoundPieceLen), " $")

				oVoice.Speak(SoundPiece, 2)
			}else if (SoundTotalLen>SoundFilePos){
				SoundPiece := RegexReplace(SubStr(SoundFile, SoundSplitLocs[A_Index]+SoundSplitLens[A_Index]-3), " $")
				;Tooltip, oVoice: ""%SoundPiece%""
				oVoice.Speak(SoundPiece, 1)
			}
		}
	}else{
		if (FileExist(SoundDir "\" SoundFile ".mp3"))
			SoundPlay, %SoundDir%\%SoundFile%.mp3, 1
		else{
			oVoice.Speak(SoundFile, 1)
		}

	}

	if (AlertAltCheck)
		SetDefaultEndpoint( GetDeviceID(Devices, DefaultSoundName) )

return

gui_KeyDown(wb, wParam, lParam, nMsg, hWnd) {
	if (Chr(wParam) ~= "[BD-UW-Z]" || wParam = 0x74) ; Disable Ctrl+O/L/F/N and F5.
		return
	Gui +OwnDialogs ; For threadless callbacks which interrupt this.
	pipa := ComObjQuery(wb, "{00000117-0000-0000-C000-000000000046}")
	VarSetCapacity(kMsg, 48), NumPut(A_GuiY, NumPut(A_GuiX
	, NumPut(A_EventInfo, NumPut(lParam, NumPut(wParam
	, NumPut(nMsg, NumPut(hWnd, kMsg)))), "uint"), "int"), "int")
	Loop 2
	r := DllCall(NumGet(NumGet(1*pipa)+5*A_PtrSize), "ptr", pipa, "ptr", &kMsg)
	; Loop to work around an odd tabbing issue (it's as if there
	; is a non-existent element at the end of the tab order).
	until wParam != 9 || wb.Document.activeElement != ""
	ObjRelease(pipa)
	if r = 0 ; S_OK: the message was translated to an accelerator.
		return 0
}



class WB_events {
	BeforeNavigate2(wb, InputURL) {
		;wb.Stop()
		
		if (InStr(InputURL,"myapp")) {
			NewURL := InputURL
			GoSub, myappBrowserFunction
		}
	}
}

myappBrowserFunction:
	;Tooltip % NewURLL
	;Tooltip % NewURL
	if (InStr(NewURL,"SpawnMap",1)){
		CurrentMap := HTMLDisplay.document.getElementById("SpawnMapMap").value
		;UrlDownloadToFile, %CurrentMap%, %A_Temp%\CurrentMap.jpg
		;Tooltip, %CurrentMap%`n%A_Temp%\CurrentMap.jpg
		;Sleep 5000
		;HTMLDisplay.document.getElementById("SpawnMapMapImage").src := A_Temp "\CurrentMap.jpg"



		;CurrentOverlay := HTMLDisplay.document.getElementById("SpawnMapDino").value

		
	}else if (RegexMatch(NewURL, "AutoClicks/(Update|Remove)/([0-9]{1,})", MatchURL)){
		AutoClicksPreset := HTMLDisplay.document.getElementById("AutoClicksPreset" MatchURL2).value

		FoundPos := RegexMatch(AutoClickPresetsStr, "\\/\\/" AutoClicksPreset "\-\-\-(.+?)\|\|", MatchURLA)
		AutoClicksPresetName := MatchURLA1
		HotkeyTemp := !RegexMatch(HTMLDisplay.document.getElementById("AutoClicksHotkey" MatchURL2).value, "|\.\.\.") ? ParseHotkey(HTMLDisplay.document.getElementById("AutoClicksHotkey" MatchURL2).value) : HTMLDisplay.document.getElementById("AutoClicksHotkey" MatchURL2).value
		AutoClicksHotkey := HotkeyTemp 
		if (MatchURL1="Remove"){
			if (MsgBox2("Are you sure you want to Remove this Auto Click?`n" AutoClicksPresetName " - " AutoClicksHotkey, "2 r2 center"))
			{
				AutoClicksArr.RemoveAt(MatchURL2)
				AutoClickschosen := 1
			}
		}else if (MatchURL1="Update"){
			

			AutoClicksToggle := RegexMatch(HTMLDisplay.document.getElementById("AutoClicksToggle" MatchURL2).checked, "1|on") ? 1 : 0


			AutoClicksEnabled := RegexMatch(HTMLDisplay.document.getElementById("AutoClicksEnabled" MatchURL2).checked, "1|on") ? 1 : 0
			AutoClicksArr[MatchURL2] := AutoClicksPreset "||" AutoClicksHotkey "||" AutoClicksEnabled "||" AutoClicksToggle

		}

		NewAutoClicks := "\/\/"
		Loop % AutoClicksArr.MaxIndex(){
			NewAutoClicks := NewAutoClicks AutoClicksArr[A_Index] "\/\/"
		}
		IniWrite, %NewAutoClicks%, %FileSettings%, Main, AutoClicks


		GoSub, BuildAutoClicks


	}else if (RegexMatch(NewURL, "AutoClicks/Add")){
		AutoClicksArr.push(HTMLDisplay.document.getElementById("AutoClickPresetNumber").value "||...||0||1")


		NewAutoClicks := "\/\/"
		Loop % AutoClicksArr.MaxIndex(){
			NewAutoClicks := NewAutoClicks AutoClicksArr[A_Index] "\/\/"
		}
		IniWrite, %NewAutoClicks%, %FileSettings%, Main, AutoClicks

		GoSub, BuildAutoClicks

	}else if (RegexMatch(NewURL, "openTab/([A-z0-9]{1,})/([A-z0-9]{1,})", MatchURL)){
		;function openTab(section, tabID, contentID) {
		section := MatchURL1
		tabID := MatchURL2
		if(section="TA"){
			TAchosen := tabID
			IniWrite, %TAchosen%, %FileSettings%, Main, TAchosen

			GoSub, UpdateTimedAlerts
		}else {

			AutoClickschosen := tabID
			IniWrite, %AutoClickschosen%, %FileSettings%, Main, AutoClickschosen

			GoSub, BuildAutoClicks
		}

	}else if (InStr(NewURL,"ChooseConsoleVariables")){

		;Run ::{20d04fe0-3aea-1069-a2d8-08002b30309d}  ;;My Computer
		if (FileExist(ConsoleVarsPath))
			FileSelectFile, ConsoleVarsPathTemp, 1, %ConsoleVarsPath%, Select your "ConsoleVariables.ini", *.ini
		else
			FileSelectFile, ConsoleVarsPathTemp, 1, ::{645ff040-5081-101b-9f08-00aa002f954e}, Select your "ConsoleVariables.ini", *.ini
		;Tooltip, TEST: %ExportDirTemp%
		if (ConsoleVarsPathTemp!="")
			IniWrite, %ConsoleVarsPath%, %FileSettings%, Main, ConsoleVarsPath
	
	}else if (InStr(NewURL,"RunConsoleVariables",1)){
		Run, %ConsoleVarsPath%
	}else if (InStr(NewURL,"OfficialRatesNow",1)){
		OfficialRatesCheck := 1
		GoSub, GetOfficialRates
		OfficialRatesCheck := 0

	}else if (RegexMatch(NewURL, "(Add|Remove)TimedAlert([0-9{1,}])?", MatchURL)){
		;Tooltip, %MatchURL1%`n%MatchURL2%

		
		IniWrite, %TAchosen%, %FileSettings%, Main, TAchosen


		IniRead, TimedAlerts2, %FileSettings%, Main, TimedAlerts
		;fdsafdsa
		TimedAlerts2 := TimedAlerts2="" ? "~~~" : TimedAlerts2

		if (MatchURL1="Add"){				;ADD
			TAchosen := 1
			Title := HTMLDisplay.document.getElementById("TimedAlertsTitle").value
			Remaining := HTMLDisplay.document.getElementById("TimedAlertsRemaining").value
			if(Title!="" && Remaining!=""){
				Remaining := StringToSeconds(Remaining)
				CurrentTime := A_Now
				EnvAdd, CurrentTime, Remaining, s
				TimedAlerts2 := TimedAlerts2 CurrentTime "|||" Title "~~~"
			}
		}else{							;REMOVE
			Title := HTMLDisplay.document.getElementById("TimedAlertsTitle" MatchURL2).value
			Remaining := HTMLDisplay.document.getElementById("TimedAlertsRemaining" MatchURL2).name	
			if(Remaining<A_Now || MsgBox2("Are you sure you want to Remove this Timed Alert?`n""" Title """", "2 r2 center")){
				TAchosen := 1
				;Tooltip, %Title%`n%Remaining%


				;NOTE: 12 characters that need escaping in RegEx generally: \.*?+[{|()^$
				Title := RegexReplace(Title, "\\", "\\")
				,Title := RegexReplace(Title, "\.", "\.")
				,Title := RegexReplace(Title, "\*", "\*")
				,Title := RegexReplace(Title, "\?", "\?")
				,Title := RegexReplace(Title, "\+", "\+")
				,Title := RegexReplace(Title, "\[", "\[")
				,Title := RegexReplace(Title, "\{", "\{")
				,Title := RegexReplace(Title, "\|", "\|")
				,Title := RegexReplace(Title, "\(", "\(")
				,Title := RegexReplace(Title, "\)", "\)")
				,Title := RegexReplace(Title, "\^", "\^")
				,Title := RegexReplace(Title, "\$", "\$")



				TimedAlerts2 := RegExReplace(TimedAlerts2, Remaining "\|\|\|" Title "~~~")
			}
			
		}

		TimedAlerts2 := RegexReplace(TimedAlerts2, "~~~~~~", "~~~")
		TimedAlerts2 := RegexReplace(TimedAlerts2, "^ERROR", "~~~")
		if (!RegexMatch(TimedAlerts2, "^~~~"))
			TimedAlerts2 := "~~~" TimedAlerts2

		if (!RegexMatch(TimedAlerts2, "~~~$"))
			TimedAlerts2 := TimedAlerts2  "~~~"

		IniWrite, %TimedAlerts2%, %FileSettings%, Main, TimedAlerts
		GoSub, BuildTimedAlertsGUI
		GoSub, UpdateTimedAlerts

	}else if (RegexMatch(NewURL, "i)TimedAlert([0-9]{1,})(M|H|D)(U|D)", MatchURL)){
		if (!UpdateingTA){
			UpdateingTA := 1
			IniRead, TimedAlertsTemp, %FileSettings%, Main, TimedAlerts

			;cccccccccccccccccccccccccccccccccccccccccc
			;TimedAlertsTemp := RegexReplace(substr(TimedAlertsTemp, 4, StrLen(TimedAlertsTemp)-3), "~~~", "~~~`n")
			;if (TAAnchor=1 || TAAnchor=3)
			;	Sort, TimedAlertsTemp, N R
			;else
			;	Sort, TimedAlertsTemp, N
			;TimedAlertsTemp := RegexReplace(TimedAlertsTemp, "\n")


			;Tooltip % substr(TimedAlertsTemp, 4, StrLen(TimedAlertsTemp)-6)
			TA2arr := StrSplit(substr(TimedAlertsTemp, 4, StrLen(TimedAlertsTemp)-6),"~~~")

			URLFoundPos := RegexMatch(TA2arr[MatchURL1], "^(.+?)\|\|\|", TA2Match)
			if (URLFoundPos){
				NewEndTime := OldEndTime := TA2Match1
				EnvAdd, NewEndTime, MatchURL3="U" ? 1 : -1, %MatchURL2%
				TA2arr[MatchURL1] := RegexReplace(TA2arr[MatchURL1], "^(.+?)\|\|\|", NewEndTime "|||")

				NewTA := "~~~"
				Loop % TA2arr.MaxIndex(){
					NewTA := NewTA TA2arr[A_Index] "~~~"
				}
				;Tooltip, %NewTA%`n%OldEndTime%`n%NewEndTime%`n%MatchURL1%`n%MatchURL2%
				IniWrite, %NewTA%, %FileSettings%, Main, TimedAlerts
			}

			TA2arr := ""
			UpdateingTA := 0
		}
	}else if (RegexMatch(NewURL, "i)asb(Pos|Size)(U|D|L|R)", MatchURL)){
		if (!UpdateingABSsnip){
			if (MatchURL1="Pos"){
				IniRead, asbx, %FileSettings%, Main, asbx
				asbx := MatchURL2="R" ? asbx-1 : MatchURL2="L" ? asbx+1 : asbx
				IniWrite, %asbx%, %FileSettings%, Main, asbx

				IniRead, asby, %FileSettings%, Main, asby
				asby := MatchURL2="D" ? asby-1 : MatchURL2="U" ? asby+1 : asby
				IniWrite, %asby%, %FileSettings%, Main, asby
			}else{
				IniRead, asbw, %FileSettings%, Main, asbw
				asbw := MatchURL2="L" ? asbw-1 : MatchURL2="R" ? asbw+1 : asbw
				IniWrite, %asbw%, %FileSettings%, Main, asbw

				IniRead, asbh, %FileSettings%, Main, asbh
				asbh := MatchURL2="D" ? asbh-1 : MatchURL2="U" ? asbh+1 : asbh
				IniWrite, %asbh%, %FileSettings%, Main, asbh
			}
			GoSub, MakeASBSnip

			UpdateingABSsnip := 0
		}
	;}else if (RegexMatch(NewURL, "GachaFarmingO1(0|1)", MatchURL)){
	}else if (RegexMatch(NewURL, "GachaFarmingO1(0|1)?", MatchURL)){
		MatchURL1 := RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingO1").checked, "1|on") ? 1 : 0
		IniWrite, %ServerString%, %FileSettings%, Main, GachaFarmingO1

		HTMLDisplay.document.getElementbyId("GachaFarmingO2info1").style.display := MatchURL1 ? "none" : "table-row"
		HTMLDisplay.document.getElementbyId("GachaFarmingO2info2").style.display := MatchURL1 ? "none" : "table-row"

		HTMLDisplay.document.getElementbyId("GachaFarmingO3info1").style.display := MatchURL1 ? "table-row" : "none"
		HTMLDisplay.document.getElementbyId("GachaFarmingO3info2").style.display := MatchURL1 ? "table-row" : "none"
		HTMLDisplay.document.getElementbyId("GachaFarmingO3info3").style.display := MatchURL1 ? "table-row" : "none"
		
	}else if (InStr(NewURL,"SearchServer",1)){
		ServerString := HTMLDisplay.document.getElementById("ServerString").value!="" ? HTMLDisplay.document.getElementById("ServerString").value : ServerString
		IniWrite, %ServerString%, %FileSettings%, Main, ServerString
		GoSub, ChooseServer
	}else if (RegexMatch(NewURL, "connect/([0-9.]{7,15}):([0-9]{1,})$", MatchURL)){
		RetVal := MsgBox2("Are you sure you want to Connect to:`n" MatchURL1 ":" MatchURL2, "2 r2 center")
		If (RetVal)
			Run, steam://connect/%MatchURL1%:%MatchURL2%
	}else if (RegexMatch(NewURL, "(Add|Remove)FavoriteServer\/([0-9.:]{1,})?$", MatchURL)){
		IniRead, FavoriteServers, %FileSettings%, Main, FavoriteServers
		if (RegexMatch(MatchURL1, "Add")){
			RetVal := MsgBox2("Are you sure you want to Add this Server to Favorites?", "2 r2 center")
			If (RetVal){
				ServerName :=  RegexReplace(HTMLDisplay.document.getElementById("AddFavoriteServer/" MatchURL2).name, "-<br>")
				ServerIP := RegexReplace(MatchURL2, "<br>")

				FoundPos := RegexMatch(FavoriteServers, "~~~" ServerName "\|\|\|" ServerIP "~~~")
				if (!FoundPos && ServerName!="" && ServerIP!=""){
					FavoriteServers := FavoriteServers ServerName "|||" ServerIP "~~~"
					FavoriteServers := RegexReplace(FavoriteServers, "~~~~~~", "~~~")
					FavoriteServers := RegexReplace(FavoriteServers, "^ERROR", "~~~")
					IniWrite, %FavoriteServers%, %FileSettings%, Main, FavoriteServers
					GoSub, UpdateFavoriteServers
				}
				ServerName := ServerIP := ""
			}
		}else if (RegexMatch(MatchURL1, "Remove")){
			RetVal := MsgBox2("Are you sure you want to Remove this Server from Favorites?", "2 r2 center")
			If (RetVal){
				;SoundBeep
				FavoriteServers := RegexReplace(FavoriteServers, "~~~[A-Za-z0-9_\- ]{1,}\|\|\|" MatchURL2 "~~~", "~~~")
				if (!RegexMatch(FavoriteServers,"^~~~"))
					FavoriteServers := "~~~" FavoriteServers
				if (!RegexMatch(FavoriteServers,"~~~$"))
					FavoriteServers := FavoriteServers "~~~" 
				IniWrite, %FavoriteServers%, %FileSettings%, Main, FavoriteServers
				GoSub, UpdateFavoriteServers
			}
		}
	}else if (InStr(NewURL,"rangerelease",1)){
		GoSub, MakeASBSnip

	}else if (RegexMatch(NewURL,"CDToggle(0|1|2)", MatchURL)){
		notifs := HTMLDisplay.document.getElementsbyClassName("alertnotify")
		Loop % notifs.Length
			notifs[A_Index-1].style.display := "none"
		notifs := ""
		HTMLDisplay.document.getElementbyId("alertnotify9").style.display := "table-row"
		if (MatchURL1="1"){								;Close Ark
			HTMLDisplay.document.getElementbyId("alertnotify1").style.display := "table-row"
		}else if (MatchURL1="2"){							;Food CD
			HTMLDisplay.document.getElementbyId("alertnotify5").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("alertnotify6").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("alertnotify7").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("alertnotify8").style.display := "table-row"
		}else{											;Notify
			HTMLDisplay.document.getElementbyId("alertnotify1").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("alertnotify2").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("alertnotify3").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("alertnotify4").style.display := "table-row"
		}
		IniWrite, %MatchURL1%, %FileSettings%, Main, CDToggle
	}else if (RegexMatch(NewURL,"ExportColoringToggle(0|1)?", MatchURL)){
		MatchURL1 := RegexMatch(HTMLDisplay.document.getElementById("ExportColoringToggle").checked, "1|on") ? 1 : 0
		notifs := HTMLDisplay.document.getElementsbyClassName("ExportColorRows")
		Loop % notifs.Length
			notifs[A_Index-1].style.display := "none"
		notifs := ""
		if (MatchURL1="1"){								;Overlay Color
			HTMLDisplay.document.getElementbyId("ASBinvertRrow").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("ASBinvertGrow").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("ASBinvertBrow").style.display := "table-row"
		}else{											;Alpha Color
			HTMLDisplay.document.getElementbyId("ASBalphaRrow").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("ASBalphaGrow").style.display := "table-row"
			HTMLDisplay.document.getElementbyId("ASBalphaBrow").style.display := "table-row"
		}
	}else if (RegexMatch(NewURL,"(QT|AutoClick)Preset/([0-9]{1,})$", MatchURL)){
		;asdfasdf
		if (MatchURL2!=0){
			PresetStr := HTMLDisplay.document.getElementById(MatchURL1 MatchURL2).innerHTML
			PresetFoundPos := InStr(PresetStr, "---")
			PresetArr := StrSplit(substr(PresetStr, PresetFoundPos+3, StrLen(PresetStr)-PresetFoundPos+4), "||")
			;Tooltip, %PresetStr%`n%MatchURL1%`n%MatchURL2%
			if (MatchURL1="QT"){
				HTMLDisplay.document.getElementById("QTPresetStr").value := PresetArr[1]
				;HTMLDisplay.document.getElementById("QTDrop0").checked := PresetArr[2] ? 0 : 1 
				;HTMLDisplay.document.getElementById("QTDrop1").checked := PresetArr[2] ? 1 : 0 
				HTMLDisplay.document.getElementById("QTDrop").checked := PresetArr[2] ? 1 : 0 
				;HTMLDisplay.document.getElementById("QTFromYou0").checked := PresetArr[3] ? 0 : 1
				;HTMLDisplay.document.getElementById("QTFromYou1").checked := PresetArr[3] ? 1 : 0 
				HTMLDisplay.document.getElementById("QTFromYou").checked := PresetArr[3] ? 1 : 0 
				HTMLDisplay.document.getElementById("QTDelay").value := PresetArr[4]
				HTMLDisplay.document.getElementById("QTSearch").value := PresetArr[5]
			}else if (MatchURL1="AutoClick"){
				HTMLDisplay.document.getElementById("AutoClickPresetStr").value := PresetArr[1]
				;HTMLDisplay.document.getElementById("AutoClickToggle0").checked := PresetArr[2] ? 0 : 1 
				;HTMLDisplay.document.getElementById("AutoClickToggle1").checked := PresetArr[2] ? 1 : 0 
				HTMLDisplay.document.getElementById("AutoClickKey").value := PresetArr[3]
				HTMLDisplay.document.getElementById("AutoClickSpamDelay").value := PresetArr[4]
				HTMLDisplay.document.getElementById("AutoClickHoldDelay").value := PresetArr[5]
			}
		}
	}
	else if (RegexMatch(NewURL,"(QT|AutoClick)RemovePreset", MatchURL)){
		PresetNumber := HTMLDisplay.document.getElementById(MatchURL1 "PresetNumber").value ? HTMLDisplay.document.getElementById(MatchURL1 "PresetNumber").value : PresetNumber
		;Tooltip, %PresetNumber%

		IniRead, %MatchURL1%PresetsStr, %FileSettings%, Main, %MatchURL1%PresetsStr
		NewPresetsStr := %MatchURL1%PresetsStr
		NewPresetsStr := RegexReplace(%MatchURL1%PresetsStr, "\\/\\/" PresetNumber "---.+?\|\|.+?\\/\\/", "\/\/")

		IniWrite, %NewPresetsStr%, %FileSettings%, Main, %MatchURL1%PresetsStr
		GoSub, UpdatePresets
	}else if (InStr(NewURL,"TestSound")){
		SoundFile := HTMLDisplay.document.getElementById("AlertTestString").value
		GoSub, MakeSound
	}else if (InStr(NewURL,"ResetTimersFW")){
		;GoSub, ResetFWCounters
	}else if (RegexMatch(NewURL,"Reset(Food|Water|Brew)", MatchURL)){
		Next%MatchURL1%Time := A_Now
	}else if (InStr(NewURL,"LastExport")){
		GoSub, DinoExportFunction
	}else if (InStr(NewURL,"TotalExports")){
		RetVal := MsgBox2("Are you sure you would like to Clean the export folder?`nThis will delete " TotalExportFiles " Files.", "2 r3 center")
		If (RetVal)
			GoSub, CleanExportFolder
	}else if (InStr(NewURL,"SelectExports")){
		FileSelectFolder, ExportDirTemp, , 0, Select your Dino Export Folder.
		;Tooltip, TEST: %ExportDirTemp%
		if (ExportDirTemp!=""){
			ExportDir := RegExReplace(ExportDirTemp, "\\$")
			IniWrite, %ExportDir%, %FileSettings%, Main, ExportDir
		}
	}else if (InStr(NewURL,"SelectASB")){
		FileSelectFile, ASBvaluesFileTemp, 1, %ASBvaluesFile%, Select Ark Smart Breeding "values.json"., *.ini
		;Tooltip, TEST: %ExportDirTemp%
		if (ASBvaluesFileTemp!=""){
			IniWrite, %ASBvaluesFile%, %FileSettings%, Main, ASBvaluesFile
		}
	}else if (InStr(NewURL,"QueryNow")){
		GoSub, VerifyGameDig
		if (FoundNodeGamedig && FoundNodeJS){
			QueryOnce := 1
			GoSub, CheckServers
			QueryOnce := 0
		}
	}else if (InStr(NewURL,"TAScreenDisp",1)){				;Timed Alerts
		TAScreenDisp := RegexMatch(HTMLDisplay.document.getElementById("TAScreenDisp").checked, "1|on") ? 1 : 0
		IniWrite, %TAScreenDisp%, %FileSettings%, Main, TAScreenDisp

		if (TAScreenDisp)
			GoSub, BuildTimedAlertsGUI

	}else if (RegexMatch(NewURL,"i)myapp:\/\/([A-z0-9]{1,}Check)([0-9]{1,})?/", TempInput)){				;;ALL CHECKS HERE ?checked= check(id) ^Check$
		;Tooltip, %NewURL%`n%TempInput1%`n%TempInput2%
		if (RegexMatch(TempInput1, "(Food|Water|Brew)Check", Matcher)){
			if (TempInput2!="")
				HTMLDisplay.document.getElementById(TempInput1).checked := HTMLDisplay.document.getElementById(TempInput1 "2").checked
			else
				HTMLDisplay.document.getElementById(TempInput1 "2").checked := HTMLDisplay.document.getElementById(TempInput1).checked
		}


		Value := RegexMatch(HTMLDisplay.document.getElementById(TempInput1).checked, "1|on") ? 1 : 0
		%TempInput1% := Value
		IniWrite, %Value%, %FileSettings%, Main, %TempInput1%


		;Tooltip, %TempInput1%=%Value%
		;sleep 500
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;;;;;;;;;;;;;;;Handle duplicate hotkeys - only on Check Enabled command tbh
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		if (Value){
			;SoundBeep
			AllHotkeysNames := ":"
			,AllHotkeysNames := ShowingAutoClickButton ? AllHotkeysNames "AutoClickHotkey:" : AllHotkeysNames
			,AllHotkeysNames := ShowingAutoClickButton ? AllHotkeysNames "BloodPackHotkey:" : AllHotkeysNames
			,AllHotkeysNames := ShowingAutoClickButton ? AllHotkeysNames "ECHotkey:" : AllHotkeysNames
			,AllHotkeysNames := ShowingFeedBabiesButton ? AllHotkeysNames "FeedBabiesHotkey:" : AllHotkeysNames
			,AllHotkeysNames := ShowingFishingButton ? AllHotkeysNames "FishingHotkey:" : AllHotkeysNames
			,AllHotkeysNames := ShowingGachaFarmingButton ? AllHotkeysNames "GachaFarmingHotkey:" : AllHotkeysNames
			,AllHotkeysNames := ShowingQuickTransferButton ? AllHotkeysNames "QTHotkey:" : AllHotkeysNames

			AllHotkeys := ":"
			,AllHotkeys := ShowingAutoClickButton ? AllHotkeys AutoClickHotkey ":" : AllHotkeys
			,AllHotkeys := ShowingAutoClickButton ? AllHotkeys BloodPackHotkey ":" : AllHotkeys
			,AllHotkeys := ShowingAutoClickButton ? AllHotkeys ECHotkey ":" : AllHotkeys
			,AllHotkeys := ShowingFeedBabiesButton ? AllHotkeys FeedBabiesHotkey ":" : AllHotkeys
			,AllHotkeys := ShowingFishingButton ? AllHotkeys FishingHotkey ":" : AllHotkeys
			,AllHotkeys := ShowingGachaFarmingButton ? AllHotkeys GachaFarmingHotkey ":" : AllHotkeys
			,AllHotkeys := ShowingQuickTransferButton ? AllHotkeys QTHotkey ":" : AllHotkeys

			AllHotkeysNamesArr := Strsplit(substr(AllHotkeysNames, 2, StrLen(AllHotkeysNames)-2), ":")
			AllHotkeysArr := Strsplit(substr(AllHotkeys, 2, StrLen(AllHotkeys)-2), ":")

			Loop % AllHotkeysArr.MaxIndex(){
				CurrentHotkeyTest := AllHotkeysArr[A_Index]
				if (StrLen(CurrentHotkeyTest)>=1 && CurrentHotkeyTest!=""){
					FoundIndicies := HasVal(AllHotkeysArr, CurrentHotkeyTest)
					FoundPosDup1 := RegexMatch(FoundIndicies, " ([0-9]) ", Dup1Index)
					if (FoundPosDup1){
						FoundPosDup2 := RegexMatch(FoundIndicies, " ([0-9]) ", Dup2Index, FoundPosDup1+1)
						if (FoundPosDup2){
							TempName := RegExReplace(AllHotkeysNamesArr[Dup1Index1], "Hotkey", "Check")
							TempName2 := RegExReplace(AllHotkeysNamesArr[Dup2Index1], "Hotkey", "Check")
							if (%TempName% || %TempName2%){
								%TempName% := %TempName2% := 0
								,HTMLDisplay.document.getElementById(TempName).checked := 0
								,HTMLDisplay.document.getElementById(TempName2).checked := 0
								IniWrite, 0, %FileSettings%, Main, %TempName%
								IniWrite, 0, %FileSettings%, Main, %TempName2%

								SLeep 100
								MsgBox2("Duplicate Hotkeys Found`n" CurrentHotkeyTest ": " AllHotkeysNamesArr[Dup1Index1] " - " AllHotkeysNamesArr[Dup2Index1], "0 r2")
							}

						}

					}
				}
				
			}
			AllHotkeysArr := AllHotkeysNamesArr := ""
		}
		if (InStr(NewURL,"AutoClick")){
			global AutoClickCheck
		}else if (InStr(NewURL,"CD")){
			;CDCheck := RegexMatch(HTMLDisplay.document.getElementById("CDCheck").checked, "1|on") ? 1 : 0
			if (CDCheck){

				;CDToggle := HTMLDisplay.document.getElementById("CDToggle1").checked ? 1 : HTMLDisplay.document.getElementById("CDToggle2").checked ? 2 : 0
				;IniWrite, %CDToggle%, %FileSettings%, Main, CDToggle

				if (CDToggle=0){
					Hotkey, %CDResetKey%, CDResetKeyFunction, off
					CDResetKey := HTMLDisplay.document.getElementById("CDResetKey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("CDResetKey").value) : CDResetKey
					IniWrite, %CDResetKey%, %FileSettings%, Main, CDResetKey
					Hotkey, *~%CDResetKey%, CDResetKeyFunction, on
				}


				NotifyFoodStartT := NotifyFoodEndT := A_Now
				EnvAdd, NotifyFoodEndT, CDFood/CDFoodRate, s

				MaxTimeNotify := StringToSeconds(CDTimeDisp)
				NotifyAFKTime := A_Now


				GoSub, BuildNotifyGUI
			}else{
				SelectObject(hdc5, obm5) ; Select the object back into the hdc
				,DeleteObject(hbm5) ; Now the bitmap may be deleted
				,DeleteDC(hdc5) ; Also the device context related to the bitmap may be deleted
				,Gdip_DeleteGraphics(pGraphics5) ;
				Gui, 5:Destroy
			}
		}else if (RegexMatch(NewURL,"(FeedBabies|Fishing|GachaFarming)", MatchURL)){
			ToggleKey := %MatchURL1%Check ? %MatchURL1%Hotkey : ""
		}else if (RegexMatch(NewURL,"ServerFavorites")){
			
			if (ServerFavoritesCheck){
				GoSub, VerifyGameDig
				if (FoundNodeGamedig && FoundNodeJS)
					GoSub, CheckServers
			}
		}
	}else if (InStr(NewURL,"Setup")){
		if (InStr(NewURL,"Countdown",1)){				;Countdown
			UpdatePixelLoc("CD", "Click where you would like the Top Left of the Countdown window.", CDX, CDY)
			IniWrite, %CDX%, %FileSettings%, Main, CDX
			IniWrite, %CDY%, %FileSettings%, Main, CDY
			if (CDScreenDisp)
				GoSub, BuildNotifyGUI
		}else if (InStr(NewURL,"TAScreen",1)){				;Timed Alerts
			UpdatePixelLoc("TA", "Click where you would like the ANCHOR of the Timed Alerts window.", TAX, TAY, 1, TAAnchor)
			IniWrite, %TAX%, %FileSettings%, Main, TAX
			IniWrite, %TAY%, %FileSettings%, Main, TAY
			IniWrite, %TAAnchor%, %FileSettings%, Main, TAAnchor
			if (TAScreenDisp)
				GoSub, BuildTimedAlertsGUI
		}else if (InStr(NewURL,"Export",1)){				;Dino Export
			UpdatePixelLoc("Export", "Click where you would like the ANCHOR of the Export window.", ExportX, ExportY, 1, ExportAnchor)
			IniWrite, %ExportX%, %FileSettings%, Main, ExportX
			IniWrite, %ExportY%, %FileSettings%, Main, ExportY
			IniWrite, %ExportAnchor%, %FileSettings%, Main, ExportAnchor
		}else if (InStr(NewURL,"Helena",1)){				;Helena
			UpdatePixelLoc("Helena", "Click where you would like the Top Left of the Helena window.", HelenaX, HelenaY)
			IniWrite, %HelenaX%, %FileSettings%, Main, HelenaX
			IniWrite, %HelenaY%, %FileSettings%, Main, HelenaY
		}else if (InStr(NewURL,"AutoClicks",1)){				;AutoClicks
			UpdatePixelLoc("AutoClicks", "Click where you would like the ANCHOR of the Auto Clicks Overlay.", AutoClicksX, AutoClicksY, 1, AutoClicksAnchor)
			IniWrite, %AutoClicksX%, %FileSettings%, Main, AutoClicksX
			IniWrite, %AutoClicksY%, %FileSettings%, Main, AutoClicksY
			IniWrite, %AutoClicksAnchor%, %FileSettings%, Main, AutoClicksAnchor
		}


		else if (InStr(NewURL,"Food",1)){				;Food
			UpdatePixelLoc("Food", "Click on the middle lowest section of your Food Bar.", FoodX, FoodY)
			IniWrite, %FoodX%, %FileSettings%, Main, FoodX
			IniWrite, %FoodY%, %FileSettings%, Main, FoodY
		}else if (InStr(NewURL,"Water",1)){				;Water
			UpdatePixelLoc("Water", "Click on the middle lowest section of your Water Bar.", WaterX, WaterY)
			IniWrite, %WaterX%, %FileSettings%, Main, WaterX
			IniWrite, %WaterY%, %FileSettings%, Main, WaterY
		}else if (InStr(NewURL,"Brew",1)){				;Brew
			UpdatePixelLoc("Brew", "Click on the middle lowest section of your Health Bar.", HPX1, HPlowY)
			UpdatePixelLoc("Brew", "Click on the upper section of your Health Bar, where you would like to maintain.", HPX2, HPhighY)
			HPX := round((HPX1+HPX2)*0.5,0)
			IniWrite, %HPX%, %FileSettings%, Main, HPX
			IniWrite, %HPlowY%, %FileSettings%, Main, HPlowY
			IniWrite, %HPhighY%, %FileSettings%, Main, HPhighY
		}







	}else if (InStr(NewURL,"Update")){
		if (InStr(NewURL,"Alerts",1)){
			AlertsDelay := HTMLDisplay.document.getElementById("AlertsDelay").value!="" ? HTMLDisplay.document.getElementById("AlertsDelay").value : AlertsDelay
			IniWrite, %AlertsDelay%, %FileSettings%, Main, AlertsDelay
			AlertsDelayMS := StringToSeconds(AlertsDelay)*1000
			if (AlertsCheck)
				GoSub, AlertsFunction
			SetTimer, AlertsFunction, %AlertsDelayMS%


			Loop, 10
			{
				Value := RegexMatch(HTMLDisplay.document.getElementById("AlertsInput" A_Index).checked, "1|on") ? 1 : 0
				AlertsInput%A_Index% := Value
				IniWrite, %Value%, %FileSettings%, Main, AlertsInput%A_Index%
			}

		}else if (InStr(NewURL,"Countdown",1)){				;Alerts Countdown

			CDScreenDisp := RegexMatch(HTMLDisplay.document.getElementById("CDScreenDisp").checked, "1|on") ? 1 : 0
			IniWrite, %CDScreenDisp%, %FileSettings%, Main, CDScreenDisp

			CDToggle := HTMLDisplay.document.getElementById("CDToggle1").checked ? 1 : HTMLDisplay.document.getElementById("CDToggle2").checked ? 2 : 0
			IniWrite, %CDToggle%, %FileSettings%, Main, CDToggle

			if (CDScreenDisp)
				GoSub, BuildNotifyGUI

			if (CDToggle=0 || CDToggle=1){				
				CDTimeDisp := HTMLDisplay.document.getElementById("CDTimeDisp").value!="" ? HTMLDisplay.document.getElementById("CDTimeDisp").value : CDTimeDisp
				IniWrite, %CDTimeDisp%, %FileSettings%, Main, CDTimeDisp

				MaxTimeNotify := StringToSeconds(CDTimeDisp)
				NotifyAFKTime := A_Now
			}

			if (CDToggle=1){					;Kill Ark
				HTMLDisplay.document.getElementById("CDRemTime").value := CDTimeDisp

			}else if (CDToggle=2){				;Food Countdown
				CDFoodNotify := HTMLDisplay.document.getElementById("CDFoodNotify").value
				IniWrite, %CDFoodNotify%, %FileSettings%, Main, CDFoodNotify

				CDFood := HTMLDisplay.document.getElementById("CDFood").value!="" ? HTMLDisplay.document.getElementById("CDFood").value : CDFood
				IniWrite, %CDFood%, %FileSettings%, Main, CDFood

				CDFoodRate := HTMLDisplay.document.getElementById("CDFoodRate").value!="" ? HTMLDisplay.document.getElementById("CDFoodRate").value : CDFoodRate
				IniWrite, %CDFoodRate%, %FileSettings%, Main, CDFoodRate

				NotifyFoodStartT := NotifyFoodEndT := A_Now
				EnvAdd, NotifyFoodEndT, CDFood/CDFoodRate, s

				TestBabyAge := BabyAge
				TestBabyFood := CDFood
				TestStarvingTotalTime := 0 

			}else{								;Notify
				CDNotify := HTMLDisplay.document.getElementById("CDNotify").value
				IniWrite, %CDNotify%, %FileSettings%, Main, CDNotify

				Hotkey, %CDResetKey%, CDResetKeyFunction, off
				CDResetKey := HTMLDisplay.document.getElementById("CDResetKey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("CDResetKey").value) : CDResetKey
				IniWrite, %CDResetKey%, %FileSettings%, Main, CDResetKey
				Hotkey, *~%CDResetKey%, CDResetKeyFunction, on
				
				CDResetNumber := HTMLDisplay.document.getElementById("CDResetNumber").value!="" ? HTMLDisplay.document.getElementById("CDResetNumber").value : CDResetNumber
				IniWrite, %CDResetNumber%, %FileSettings%, Main, CDResetNumber
			}
		}else if (InStr(NewURL,"SoundDevices",1)){				;Alerts Sound Devices
			AlertAltCheck := RegexMatch(HTMLDisplay.document.getElementById("AlertAltCheck").checked, "1|on") ? 1 : 0
			IniWrite, %AlertAltCheck%, %FileSettings%, Main, AlertAltCheck

			DefaultSoundSelect := HTMLDisplay.document.getElementById("DefaultSoundSelect").value
			IniWrite, %DefaultSoundSelect%, %FileSettings%, Main, DefaultSoundSelect

			OutputSoundSelect := HTMLDisplay.document.getElementById("OutputSoundSelect").value
			IniWrite, %OutputSoundSelect%, %FileSettings%, Main, OutputSoundSelect

			oVoiceSelect := HTMLDisplay.document.getElementById("oVoiceSelect").value
			IniWrite, %oVoiceSelect%, %FileSettings%, Main, oVoiceSelect
		
			DefaultSoundName := HTMLDisplay.document.getElementById("DefaultSoundSelect").namedItem(DefaultSoundSelect).innerHTML
			OutputSoundName := HTMLDisplay.document.getElementById("OutputSoundSelect").namedItem(OutputSoundSelect).innerHTML
			;Tooltip, TEST`n%DefaultSoundName%`n%OutputSoundName%

			oVoice.Voice := oVoice.GetVoices.Item(oVoiceSelect-1)
		}else if (InStr(NewURL,"ASBsnip",1)){

			ExportAddLibrary := RegexMatch(HTMLDisplay.document.getElementbyId("ExportAddLibrary").checked, "1|on") ? 1 : 0
			IniWrite, %ExportAddLibrary%, %FileSettings%, Main, ExportAddLibrary
			
			ExportBringFront := RegexMatch(HTMLDisplay.document.getElementbyId("ExportBringFront").checked, "1|on") ? 1 : 0
			IniWrite, %ExportBringFront%, %FileSettings%, Main, ExportBringFront
			

			ASBinvertR := HTMLDisplay.document.getElementbyId("ASBinvertR").value
			IniWrite, %ASBinvertR%, %FileSettings%, Main, ASBinvertR
			ASBinvertG := HTMLDisplay.document.getElementbyId("ASBinvertG").value
			IniWrite, %ASBinvertG%, %FileSettings%, Main, ASBinvertG
			ASBinvertB := HTMLDisplay.document.getElementbyId("ASBinvertB").value
			IniWrite, %ASBinvertB%, %FileSettings%, Main, ASBinvertB

			ASBalphaR := HTMLDisplay.document.getElementbyId("ASBalphaR").value
			IniWrite, %ASBalphaR%, %FileSettings%, Main, ASBalphaR
			ASBalphaG := HTMLDisplay.document.getElementbyId("ASBalphaG").value
			IniWrite, %ASBalphaG%, %FileSettings%, Main, ASBalphaG
			ASBalphaB := HTMLDisplay.document.getElementbyId("ASBalphaB").value
			IniWrite, %ASBalphaB%, %FileSettings%, Main, ASBalphaB

			ASBalpha := HTMLDisplay.document.getElementbyId("ASBalpha").value
			IniWrite, %ASBalpha%, %FileSettings%, Main, ASBalpha

			ASBgreyscale := RegexMatch(HTMLDisplay.document.getElementById("ASBgreyscale").checked, "1|on") ? 1 : 0
			IniWrite, %ASBgreyscale%, %FileSettings%, Main, ASBgreyscale

			ASBtime := HTMLDisplay.document.getElementbyId("ASBtime").value
			IniWrite, %ASBtime%, %FileSettings%, Main, ASBtime


			ExportRaising := RegexMatch(HTMLDisplay.document.getElementById("ExportRaising").checked, "1|on") ? 1 : 0
			IniWrite, %ExportRaising%, %FileSettings%, Main, ExportRaising
			ExportStats := RegexMatch(HTMLDisplay.document.getElementById("ExportStats").checked, "1|on") ? 1 : 0
			IniWrite, %ExportStats%, %FileSettings%, Main, ExportStats
			ExportColors := RegexMatch(HTMLDisplay.document.getElementById("ExportColors").checked, "1|on") ? 1 : 0
			IniWrite, %ExportColors%, %FileSettings%, Main, ExportColors

			BabyRates := RegexMatch(HTMLDisplay.document.getElementById("BabyRates").checked, "1|on") ? 1 : 0
			IniWrite, %BabyRates%, %FileSettings%, Main, BabyRates
			BabyRatesMult := HTMLDisplay.document.getElementbyId("BabyRatesMult").value
			IniWrite, %BabyRatesMult%, %FileSettings%, Main, BabyRatesMult


			DebugBaby := RegexMatch(HTMLDisplay.document.getElementById("DebugBaby").checked, "1|on") ? 1 : 0
			IniWrite, %DebugBaby%, %FileSettings%, Main, DebugBaby
			DebugBabyAge := HTMLDisplay.document.getElementbyId("DebugBabyAge").value
			IniWrite, %DebugBabyAge%, %FileSettings%, Main, DebugBabyAge

		}else if (InStr(NewURL,"AutoClick",1)){			;UpdateAutoClick
			
			AutoClickPresetNumber := HTMLDisplay.document.getElementById("AutoClickPresetNumber").value
			IniWrite, %AutoClickPresetNumber%, %FileSettings%, Main, AutoClickPresetNumber

			AutoClickPresetStr := HTMLDisplay.document.getElementById("AutoClickPresetStr").value
			IniWrite, %AutoClickPresetStr%, %FileSettings%, Main, AutoClickPresetStr

			AutoClickKey := HTMLDisplay.document.getElementById("AutoClickKey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("AutoClickKey").value) : AutoClickKey
			HTMLDisplay.document.getElementById("AutoClickKey").value := AutoClickKey
			AutoClickKeyDisp := AutoClickKey
			AutoClickKeyDisp := RegexReplace(AutoClickKeyDisp, "i)Button", "MB")
			AutoClickKeyDisp := RegexReplace(AutoClickKeyDisp, "([a-z])", "$U1")
			IniWrite, %AutoClickKey%, %FileSettings%, Main, autoclickkey
			
			AutoClickSpamDelay := HTMLDisplay.document.getElementById("AutoClickSpamDelay").value
			IniWrite, %AutoClickSpamDelay%, %FileSettings%, Main, autoclickspamdelay
			
			AutoClickHoldDelay := HTMLDisplay.document.getElementById("AutoClickHoldDelay").value
			IniWrite, %AutoClickHoldDelay%, %FileSettings%, Main, autoclickholddelay

			AutoClickOverlayCheck := RegexMatch(HTMLDisplay.document.getElementById("AutoClickOverlayCheck").checked, "1|on") ? 1 : 0
			IniWrite, %AutoClickOverlayCheck%, %FileSettings%, Main, AutoClickOverlayCheck


			AutoClickToggle := 0

			IniRead, AutoClickPresetsStr, %FileSettings%, Main, AutoClickPresetsStr
			if (AutoClickPresetNumber=0)
				AutoClickPresetsStr := AutoClickPresetsStr AutoClickPresetStr "||" AutoClickToggle "||" AutoClickKey "||" AutoClickSpamDelay "||" AutoClickHoldDelay "\/\/"
			else
				AutoClickPresetsStr := RegexReplace(AutoClickPresetsStr, "\\/\\/" AutoClickPresetNumber "---.+?\\/\\/","\/\/" AutoClickPresetNumber "---" AutoClickPresetStr "||" AutoClickToggle "||" AutoClickKey "||" AutoClickSpamDelay "||" AutoClickHoldDelay "\/\/")
			IniWrite, %AutoClickPresetsStr%, %FileSettings%, Main, AutoClickPresetsStr

			GoSub, UpdatePresets
			HTMLDisplay.document.getElementById("AutoClickPresetNumber").value := AutoClickPresetNumber

			GoSub, BuildAutoClicks
		}
/*
		else if (InStr(NewURL,"AutoFoodWater",1)){
			FoodKey := HTMLDisplay.document.getElementById("FoodKey").value
			IniWrite, %FoodKey%, %FileSettings%, Main, foodkey
			
			FoodDelayStr := HTMLDisplay.document.getElementById("FoodDelay").value!="" ? HTMLDisplay.document.getElementById("FoodDelay").value : FoodDelay
			IniWrite, %FoodDelayStr%, %FileSettings%, Main, fooddelay
			FoodDelay := StringToSeconds(FoodDelayStr)

			WaterKey := HTMLDisplay.document.getElementById("WaterKey").value
			IniWrite, %WaterKey%, %FileSettings%, Main, waterkey

			WaterDelayStr := HTMLDisplay.document.getElementById("WaterDelay").value!="" ? HTMLDisplay.document.getElementById("WaterDelay").value : WaterDelay
			IniWrite, %WaterDelayStr%, %FileSettings%, Main, WaterDelay
			WaterDelay := StringToSeconds(WaterDelayStr)

			FoodWaterOverlayCheck := RegexMatch(HTMLDisplay.document.getElementById("FoodWaterOverlayCheck").checked, "1|on") ? 1 : 0
			IniWrite, %FoodWaterOverlayCheck%, %FileSettings%, Main, FoodWaterOverlayCheck


			GoSub, ResetFWCounters
			;if (AutoFoodWaterCheck)
			;	SetTimer, FoodWaterFunction, 1000
		}
*/
		else if (InStr(NewURL,"Food",1)){
			;FoodCheck := RegexMatch(HTMLDisplay.document.getElementById("FoodCheck").checked, "1|on") ? 1 : 0

			FoodKey := HTMLDisplay.document.getElementById("FoodKey").value
			IniWrite, %FoodKey%, %FileSettings%, Main, foodkey
			
			FoodDelay := HTMLDisplay.document.getElementById("FoodDelay").value!="" ? HTMLDisplay.document.getElementById("FoodDelay").value : FoodDelay
			IniWrite, %FoodDelay%, %FileSettings%, Main, fooddelay
		}else if (InStr(NewURL,"Water",1)){
			;WaterCheck := RegexMatch(HTMLDisplay.document.getElementById("WaterCheck").checked, "1|on") ? 1 : 0

			WaterKey := HTMLDisplay.document.getElementById("WaterKey").value
			IniWrite, %WaterKey%, %FileSettings%, Main, waterkey

			WaterDelay := HTMLDisplay.document.getElementById("WaterDelay").value!="" ? HTMLDisplay.document.getElementById("WaterDelay").value : WaterDelay
			IniWrite, %WaterDelay%, %FileSettings%, Main, WaterDelay
		}else if (InStr(NewURL,"Brew",1)){
			;BrewCheck := RegexMatch(HTMLDisplay.document.getElementById("BrewCheck").checked, "1|on") ? 1 : 0

			BrewKey := HTMLDisplay.document.getElementById("BrewKey").value
			IniWrite, %BrewKey%, %FileSettings%, Main, Brewkey

			BrewDelay := HTMLDisplay.document.getElementById("BrewDelay").value!="" ? HTMLDisplay.document.getElementById("BrewDelay").value : BrewDelay
			IniWrite, %BrewDelay%, %FileSettings%, Main, BrewDelay
		}else if (InStr(NewURL,"BloodPack",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("BloodPackHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("BloodPackHotkey").value) : ECHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %BloodPackHotkey%, BloodPackHotkeyFunction, off 
				BloodPackHotkey := HotkeyTemp
				Hotkey, *~%BloodPackHotkey%, BloodPackHotkeyFunction, on
				IniWrite, %BloodPackHotkey%, %FileSettings%, Main, BloodPackHotkey
			}

			PlayerHP := HTMLDisplay.document.getElementById("PlayerHP").value!="" ? HTMLDisplay.document.getElementById("PlayerHP").value : PlayerHP
			IniWrite, %PlayerHP%, %FileSettings%, Main, PlayerHP
			
			TekPodX := HTMLDisplay.document.getElementById("TekPodX").value!="" ? HTMLDisplay.document.getElementById("TekPodX").value : TekPodX
			IniWrite, %TekPodX%, %FileSettings%, Main, TekPodX

			TekPodY := HTMLDisplay.document.getElementById("TekPodY").value!="" ? HTMLDisplay.document.getElementById("TekPodY").value : TekPodY
			IniWrite, %TekPodY%, %FileSettings%, Main, TekPodY

			TekPodX2 := HTMLDisplay.document.getElementById("TekPodX2").value!="" ? HTMLDisplay.document.getElementById("TekPodX2").value : TekPodX2
			IniWrite, %TekPodX2%, %FileSettings%, Main, TekPodX2

			TekPodY2 := HTMLDisplay.document.getElementById("TekPodY2").value!="" ? HTMLDisplay.document.getElementById("TekPodY2").value : TekPodY2
			IniWrite, %TekPodY2%, %FileSettings%, Main, TekPodY2

			BloodPackDebugCheck := RegexMatch(HTMLDisplay.document.getElementById("BloodPackDebugCheck").checked, "1|on") ? 1 : 0
			IniWrite, %BloodPackDebugCheck%, %FileSettings%, Main, BloodPackDebugCheck


			BloodHP := 25
			JuiceHP := PlayerHP-BloodHP*4
			ReplenishTime := floor(JuiceHP*1000/7)
			;;Tooltip, %ReplenishTime%
			MaxPacks := floor(JuiceHP/BloodHP)

		}else if (InStr(NewURL,"ConsoleVariables",1)){
			if (!UpdatingConsoleVars){
				UpdatingConsoleVars := 1
			
				;ConsoleVarsPath

				ConsoleVariables1 := RegexMatch(HTMLDisplay.document.getElementById("ConsoleVariables1").checked, "1|on") ? 0 : 2
				IniWrite, %ConsoleVariables1%, %ConsoleVarsPath%, Startup, foliage.UseOcclusionType
				ConsoleVariables7 := RegexMatch(ConsoleVariables1, "2") ? 1 : 2
				IniWrite, %ConsoleVariables7%, %ConsoleVarsPath%, Startup, foliage.DisableCull


				ConsoleVariables2 := RegexMatch(HTMLDisplay.document.getElementById("ConsoleVariables2").checked, "1|on") ? 0 : 2
				IniWrite, %ConsoleVariables2%, %ConsoleVarsPath%, Startup, ShowFlag.LightComplexity

				ConsoleVariables3 := RegexMatch(HTMLDisplay.document.getElementById("ConsoleVariables3").checked, "1|on") ? 0 : 2
				IniWrite, %ConsoleVariables3%, %ConsoleVarsPath%, Startup, ShowFlag.Materials

				ConsoleVariables4 := RegexMatch(HTMLDisplay.document.getElementById("ConsoleVariables4").checked, "1|on") ? 0 : 2
				IniWrite, %ConsoleVariables4%, %ConsoleVarsPath%, Startup, ShowFlag.Fog

				ConsoleVariables5 := RegexMatch(HTMLDisplay.document.getElementById("ConsoleVariables5").checked, "1|on") ? 0.0 : 1.0
				IniWrite, %ConsoleVariables5%, %ConsoleVarsPath%, Startup, FogDensity

				ConsoleVariables6 := HTMLDisplay.document.getElementById("ConsoleVariables6").value!="" ? HTMLDisplay.document.getElementById("ConsoleVariables6").value : ConsoleVariables6
				IniWrite, %ConsoleVariables6%, %ConsoleVarsPath%, Startup, FX.MaxCPUParticlesPerEmitter

				MsgBox2("ConsoleVariables.ini has been changed.`n Restart the game for the changes to take effect.", "0 r3")
			}
			UpdatingConsoleVars := 0
		}else if (InStr(NewURL,"Crosshair",1)){
			XhairD := HTMLDisplay.document.getElementById("XhairD").value!="" ? HTMLDisplay.document.getElementById("XhairD").value : XhairD
			IniWrite, %XhairD%, %FileSettings%, Main, XhairD

			XhairA := HTMLDisplay.document.getElementById("XhairA").value!="" ? HTMLDisplay.document.getElementById("XhairA").value : XhairA
			IniWrite, %XhairA%, %FileSettings%, Main, XhairA

			XhairR := HTMLDisplay.document.getElementById("XhairR").value!="" ? HTMLDisplay.document.getElementById("XhairR").value : XhairR
			IniWrite, %XhairR%, %FileSettings%, Main, XhairR

			XhairG := HTMLDisplay.document.getElementById("XhairG").value!="" ? HTMLDisplay.document.getElementById("XhairG").value : XhairG
			IniWrite, %XhairG%, %FileSettings%, Main, XhairG

			XhairB := HTMLDisplay.document.getElementById("XhairB").value!="" ? HTMLDisplay.document.getElementById("XhairB").value : XhairB
			IniWrite, %XhairB%, %FileSettings%, Main, XhairB

			XhairOffsetX := HTMLDisplay.document.getElementById("XhairOffsetX").value!="" ? round(HTMLDisplay.document.getElementById("XhairOffsetX").value,2) : XhairOffsetX
			IniWrite, %XhairOffsetX%, %FileSettings%, Main, XhairOffsetX

			XhairOffsetY := HTMLDisplay.document.getElementById("XhairOffsetY").value!="" ? round(HTMLDisplay.document.getElementById("XhairOffsetY").value,2) : XhairOffsetY
			IniWrite, %XhairOffsetY%, %FileSettings%, Main, XhairOffsetY
			;Tooltip, TEST: %XhairD%`n%XhairR%`n%XhairG%`n%XhairB%`n%XhairOffsetX%`n%XhairOffsetY%`n

			GoSub, drawCrosshair
		}else if (InStr(NewURL,"Helena",1)){
			HelenaTime := HTMLDisplay.document.getElementById("HelenaTime").value!="" ? HTMLDisplay.document.getElementById("HelenaTime").value : HelenaTime
			IniWrite, %HelenaTime%, %FileSettings%, Main, HelenaTime

			HelenaVariation := HTMLDisplay.document.getElementById("HelenaVariation").value!="" ? HTMLDisplay.document.getElementById("HelenaVariation").value : HelenaVariation
			IniWrite, %HelenaVariation%, %FileSettings%, Main, HelenaVariation

			HelenaXoff := HTMLDisplay.document.getElementById("HelenaXoff").value!="" ? HTMLDisplay.document.getElementById("HelenaXoff").value : HelenaXoff
			IniWrite, %HelenaXoff%, %FileSettings%, Main, HelenaXoff

			HelenaYoff := HTMLDisplay.document.getElementById("HelenaYoff").value!="" ? HTMLDisplay.document.getElementById("HelenaYoff").value : HelenaYoff
			IniWrite, %HelenaYoff%, %FileSettings%, Main, HelenaYoff

			HelenaA := HTMLDisplay.document.getElementById("HelenaA").value!="" ? HTMLDisplay.document.getElementById("HelenaA").value : HelenaA
			IniWrite, %HelenaA%, %FileSettings%, Main, HelenaA
		}else if (InStr(NewURL,"EC",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("ECHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("ECHotkey").value) : ECHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %ECHotkey%, ECHotkeyFunction, off 
				ECHotkey := HotkeyTemp
				Hotkey, *~%ECHotkey%, ECHotkeyFunction, on
				IniWrite, %ECHotkey%, %FileSettings%, Main, ECHotkey
			}


			ECCurrentVal := HTMLDisplay.document.getElementById("ECCurrentVal").value!="" ? HTMLDisplay.document.getElementById("ECCurrentVal").value : ECCurrentVal
			IniWrite, %ECCurrentVal%, %FileSettings%, Main, ECCurrentVal
			
		}else if (InStr(NewURL,"FeedBabies",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("FeedBabiesHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("FeedBabiesHotkey").value) : FeedBabiesHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %FeedBabiesHotkey%, FeedBabiesHotkeyFunction, off 
				FeedBabiesHotkey := HotkeyTemp
				Hotkey, *~%FeedBabiesHotkey%, FeedBabiesHotkeyFunction, on
				IniWrite, %FeedBabiesHotkey%, %FileSettings%, Main, FeedBabiesHotkey
			}
			SpinPixels := HTMLDisplay.document.getElementById("SpinPixels").value!="" ? HTMLDisplay.document.getElementById("SpinPixels").value : SpinPixels
			IniWrite, %SpinPixels%, %FileSettings%, Main, SpinPixels

			SpinDir := RegexMatch(HTMLDisplay.document.getElementById("SpinDir").checked, "1|on") ? 1 : 0
			IniWrite, %SpinDir%, %FileSettings%, Main, SpinDir

			FeedBabiesString := HTMLDisplay.document.getElementById("FeedBabiesString").value
			IniWrite, %FeedBabiesString%, %FileSettings%, Main, FeedBabiesString

			FeedBabiesDebugCheck := RegexMatch(HTMLDisplay.document.getElementById("FeedBabiesDebugCheck").checked, "1|on") ? 1 : 0
			IniWrite, %FeedBabiesDebugCheck%, %FileSettings%, Main, FeedBabiesDebugCheck
			
		}else if (InStr(NewURL,"Fishing",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("FishingHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("FishingHotkey").value) : FishingHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %FishingHotkey%, FishingHotkeyFunction, off 
				FishingHotkey := HotkeyTemp
				Hotkey, *~%FishingHotkey%, FishingHotkeyFunction, on
				IniWrite, %FishingHotkey%, %FileSettings%, Main, FishingHotkey
			}
			SetTimer, FishingLoop, %FishingSpeed%

			FishingDebugCheck := RegexMatch(HTMLDisplay.document.getElementById("FishingDebugCheck").checked, "1|on") ? 1 : 0
			IniWrite, %FishingDebugCheck%, %FileSettings%, Main, FishingDebugCheck

		}else if (InStr(NewURL,"GachaFarming",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("GachaFarmingHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("GachaFarmingHotkey").value) : GachaFarmingHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %GachaFarmingHotkey%, GachaFarmingHotkeyFunction, off 
				GachaFarmingHotkey := HotkeyTemp
				Hotkey, *~%GachaFarmingHotkey%, GachaFarmingHotkeyFunction, on
				IniWrite, %GachaFarmingHotkey%, %FileSettings%, Main, GachaFarmingHotkey
			}

/*
			GachaFarmingO1 := RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingO11").checked, "1|on") ? 1 : 0
			IniWrite, %GachaFarmingO1%, %FileSettings%, Main, GachaFarmingO1
			GachaFarmingO2 := RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingO21").checked, "1|on") ? 1 : 0
			IniWrite, %GachaFarmingO2%, %FileSettings%, Main, GachaFarmingO2
			GachaFarmingO3 := RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingO30").checked, "1|on") ? 0 : RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingO31").checked, "1|on") ? 1 : 2
			IniWrite, %GachaFarmingO3%, %FileSettings%, Main, GachaFarmingO3
*/
			GachaFarmingO1 := RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingO1").checked, "1|on") ? 1 : 0
			IniWrite, %GachaFarmingO1%, %FileSettings%, Main, GachaFarmingO1
			GachaFarmingO2 := RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingO2").checked, "1|on") ? 1 : 0
			IniWrite, %GachaFarmingO2%, %FileSettings%, Main, GachaFarmingO2
			GachaFarmingO3 := RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingO30").checked, "1|on") ? 0 : RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingO31").checked, "1|on") ? 1 : 2
			IniWrite, %GachaFarmingO3%, %FileSettings%, Main, GachaFarmingO3

			GachaFarmingDebugCheck := RegexMatch(HTMLDisplay.document.getElementById("GachaFarmingDebugCheck").checked, "1|on") ? 1 : 0
			IniWrite, %GachaFarmingDebugCheck%, %FileSettings%, Main, GachaFarmingDebugCheck

		}else if (InStr(NewURL,"QT",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("QTHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("QTHotkey").value) : QTHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %QTHotkey%, QTHotkeyFunction, off 
				QTHotkey := HotkeyTemp
				Hotkey, *~%QTHotkey%, QTHotkeyFunction, on
				IniWrite, %QTHotkey%, %FileSettings%, Main, QTHotkey
			}

			QTPresetNumber := HTMLDisplay.document.getElementById("QTPresetNumber").value
			IniWrite, %QTPresetNumber%, %FileSettings%, Main, QTPresetNumber

			QTPresetStr := HTMLDisplay.document.getElementById("QTPresetStr").value != "" ? HTMLDisplay.document.getElementById("QTPresetStr").value : QTPresetStr
			IniWrite, %QTPresetStr%, %FileSettings%, Main, QTPresetStr

			QTDrop := RegexMatch(HTMLDisplay.document.getElementById("QTDrop").checked, "1|on") ? 1 : 0
			IniWrite, %QTDrop%, %FileSettings%, Main, QTDrop

			QTFromYou := RegexMatch(HTMLDisplay.document.getElementById("QTFromYou").checked, "1|on") ? 1 : 0
			IniWrite, %QTFromYou%, %FileSettings%, Main, QTFromYou

			QTDelay := HTMLDisplay.document.getElementById("QTDelay").value
			IniWrite, %QTDelay%, %FileSettings%, Main, QTDelay

			QTSearch := HTMLDisplay.document.getElementById("QTSearch").value
			QTSearch := RegexReplace(QTSearch, "%2C|%7C", ",")
			IniWrite, %QTSearch%, %FileSettings%, Main, QTSearch


			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			AutoQTCapDelay := HTMLDisplay.document.getElementById("AutoQTCapDelay").value!="" ? HTMLDisplay.document.getElementById("AutoQTCapDelay").value : AutoQTCapDelay
			IniWrite, %AutoQTCapDelay%, %FileSettings%, Main, AutoQTCapDelay

			AutoQTSlotCap := RegexMatch(HTMLDisplay.document.getElementById("AutoQTSlotCap").checked, "1|on") ? 1 : 0
			AutoQTCapDelayMS := AutoQTCapDelay*1000
			SetTimer, WatchingForSlotCap, %AutoQTCapDelayMS%
			IniWrite, %AutoQTSlotCap%, %FileSettings%, Main, AutoQTSlotCap


			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			IniRead, QTPresetsStr, %FileSettings%, Main, QTPresetsStr
			if (QTPresetNumber=0){
				QTPresetsStr := QTPresetsStr QTPresetStr "||" QTDrop "||" QTFromYou "||" QTDelay "||" QTSearch "\/\/"
			}else
				QTPresetsStr := RegexReplace(QTPresetsStr, "\\/\\/" QTPresetNumber "---.+?\\/\\/","\/\/" QTPresetNumber "---" QTPresetStr "||" QTDrop "||" QTFromYou "||" QTDelay "||" QTSearch "\/\/")
			IniWrite, %QTPresetsStr%, %FileSettings%, Main, QTPresetsStr

			GoSub, UpdatePresets
			HTMLDisplay.document.getElementById("QTPresetNumber").value := QTPresetNumber
		}else if (InStr(NewURL,"OfficialRatesSettings",1)){
			OfficialRatesRefresh := HTMLDisplay.document.getElementById("OfficialRatesRefresh").value!="" ? HTMLDisplay.document.getElementById("OfficialRatesRefresh").value : "10m"
			IniWrite, %OfficialRatesRefresh%, %FileSettings%, Main, OfficialRatesRefresh
			OfficialRatesRefreshMS := StringToSeconds(OfficialRatesRefresh)*1000
			if (OfficialRatesCheck)
				GoSub, GetOfficialRates
			SetTimer, GetOfficialRates, %OfficialRatesRefreshMS%
		}else if (InStr(NewURL,"JoinSimSettings",1)){
			JoinSimString := HTMLDisplay.document.getElementById("JoinSimString").value!="" ? HTMLDisplay.document.getElementById("JoinSimString").value : JoinSimString
			IniWrite, %JoinSimString%, %FileSettings%, Main, JoinSimString

			;HTMLDisplay.document.getElementById("JoinSimName").style.display := "none"
			HTMLDisplay.document.getElementById("JoinSimName").innerHTML := "Error Choosing Server<br>Must be Favorited"
			JoinSimName := JoinSimURL := ""
			IniRead, FavoriteServers2, %FileSettings%, Main, FavoriteServers
			FSarr2 := StrSplit(substr(FavoriteServers2, 4, StrLen(FavoriteServers2)-6),"~~~")
			if (FSarr2.MaxIndex()>0){
				Loop % FSarr2.MaxIndex(){
					URLFoundPos := RegexMatch(FSarr2[A_Index], "^(.+?)\|\|\|(.+?)$", URLMatch)
    				if (URLFoundPos && StrLen(FSarr2[A_Index])>10 && RegexMatch(URLMatch1, JoinSimString)){
						JoinSimName := URLMatch1
						JoinSimURL := URLMatch2

						HTMLDisplay.document.getElementById("JoinSimName").innerHTML := JoinSimName
						;HTMLDisplay.document.getElementById("JoinSimName").style.display := "block"
						break
					}
				}
			}
			FSarr2 := ""

			JoinSimRefresh := HTMLDisplay.document.getElementById("JoinSimRefresh").value!="" ? HTMLDisplay.document.getElementById("JoinSimRefresh").value : "2m"
			IniWrite, %JoinSimRefresh%, %FileSettings%, Main, JoinSimRefresh
			JoinSimRefreshMS := StringToSeconds(JoinSimRefresh)*1000
			
			JoinSimVariation := HTMLDisplay.document.getElementById("JoinSimVariation").value!="" ? HTMLDisplay.document.getElementById("JoinSimVariation").value : "70"
			IniWrite, %JoinSimVariation%, %FileSettings%, Main, JoinSimVariation

			if (JoinSimCheck)
				GoSub, JoinSimFunction
			SetTimer, JoinSimFunction, %JoinSimRefreshMS%
		}else if (InStr(NewURL,"Popcorn",1)){

			PopcornHotkey := HTMLDisplay.document.getElementById("PopcornHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("PopcornHotkey").value) : PopcornHotkey
			IniWrite, %PopcornHotkey%, %FileSettings%, Main, PopcornHotkey

			PopcornRows := HTMLDisplay.document.getElementById("PopcornRows").value!="" ? HTMLDisplay.document.getElementById("PopcornRows").value : PopcornRows
			PopcornRows := PopcornRows>8 ? 8 : PopcornRows
			IniWrite, %PopcornRows%, %FileSettings%, Main, PopcornRows

			PopcornDelay := HTMLDisplay.document.getElementById("PopcornDelay").value!="" ? HTMLDisplay.document.getElementById("PopcornDelay").value : PopcornDelay
			IniWrite, %PopcornDelay%, %FileSettings%, Main, PopcornDelay


		}else if (InStr(NewURL,"ServerFavoritesSettings",1)){
			ServerFavoritesSort := RegexMatch(HTMLDisplay.document.getElementById("ServerFavoritesSort").checked, "1|on") ? 1 : 0
			IniWrite, %ServerFavoritesSort%, %FileSettings%, Main, ServerFavoritesSort
			ServerFavoritesRefresh := HTMLDisplay.document.getElementById("ServerFavoritesRefresh").value!="" ? HTMLDisplay.document.getElementById("ServerFavoritesRefresh").value : "5m"
			IniWrite, %ServerFavoritesRefresh%, %FileSettings%, Main, ServerFavoritesRefresh
			ServerFavoritesRefreshMS := StringToSeconds(ServerFavoritesRefresh)*1000

			GoSub, UpdateFavoriteServers

			if (ServerFavoritesCheck)
				GoSub, CheckServers
			SetTimer, CheckServers, %ServerFavoritesRefreshMS%
		}else if (InStr(NewURL,"SplashImage",1)){
			GoSub, MakeSplashImage
			;HTMLDisplay.document.getElementById("SplashImage").src := SplashImagePath "?" A_Now
		}
	}
return


VerifyGameDig:
if (!FoundNodeJS){
	Loop % Drives.MaxIndex()
	{
		CurrentDir := Drives[A_Index] ":\Program Files (x86)\nodejs\node.exe"
		if (FileExist(CurrentDir)){
			FoundNodeJS := 1
			break
		}
	}
	if (!FoundNodeJS){
		RetVal := MsgBox2("Could not find Node.js`nWould you like to Download and Install it now?", "2 r3")
		if (RetVal){
			HTMLDisplay.document.getElementById("ValidationInfo").style.display := "table-row"
			HTMLDisplay.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"" align=""center"">Downloading Node.js</td>"
			UrlDownloadToFile, https://nodejs.org/dist/v14.17.0/node-v14.17.0-x86.msi, %A_Temp%\node-v14.17.0-x86.msi
			Run, %A_Temp%\node-v14.17.0-x86.msi
			HTMLDisplay.document.getElementById("ValidationInfo").style.display := "none"
		}
	}
}
if (!FoundNodeGamedig && FoundNodeJS){
	Loop % Drives.MaxIndex(){
		CurrentDir := Drives[A_Index] ":\Users"
		if (FileExist(CurrentDir)){
			Loop, Files, %CurrentDir%\*, D
			{
				CurrentFile := A_LoopFileFullPath "\node_modules\gamedig\bin\gamedig.js"
				if (FileExist(CurrentFile)){
					CurrentPath := A_LoopFileFullPath
					FoundNodeGamedig := 1
					break
					break
				}
			}
		}
	}

	if (!FoundNodeGamedig && FoundNodeJS){
		RetVal := MsgBox2("Could not find gamedig.js`nWould you like to Download and Install it now?", "2 r3")
		if (RetVal){
			HTMLDisplay.document.getElementById("ValidationInfo").style.display := "table-row"
			HTMLDisplay.document.getElementById("ValidationInfo").innerHTML := "<td colspan=""2"" align=""center"">Downloading gamedig</td>"


			;need to run as admin
			Run *RunAs %ComSpec% /c "npm install gamedig", %CurrentPath%
			HTMLDisplay.document.getElementById("ValidationInfo").style.display := "none"
		}
	}
}
return

;z::
;	Run *RunAs %ComSpec% /c  "npm install gamedig", %CurrentPath%
;return


BuildAutoClicks:
	if (AutoClicksActiveHotkeys.MaxIndex()>0){
		Loop % AutoClicksActiveHotkeys.MaxIndex(){
			CurrentHotkey := AutoClicksActiveHotkeys[A_Index]
			if (StrLen(CurrentHotkey)>0){
				Hotkey, *~%CurrentHotkey%, AutoClicksHotkeyFunction, Off
				;SoundBeep
			}
		}
	}

	AutoClicksActiveHotkeys := []

	AutoClicksHTML := ""
	IniRead, AutoClicks, %FileSettings%, Main, AutoClicks

	;Tooltip % SubStr(AutoClicks, 5, StrLen(AutoClicks)-8), "\/\/"
	AutoClicksArr := StrSplit(SubStr(AutoClicks, 5, StrLen(AutoClicks)-8), "\/\/")
	AutoClicksColorIndex := 1
	if (AutoClicksArr.MaxIndex()>0){

		AutoClicksLinksHTML := "<table style=""width:98%;"">`n<tr>`n<td colspan=""2"" style=""border-top:solid 4px"" ></td>`n</tr>`n</table>`n`n<div class=""AutoClicksDiv"">`n"
		Loop % AutoClicksArr.MaxIndex(){
			AutoClicksActiveArr[A_Index] := 0
			
			FoundPos := RegexMatch(AutoClicksArr[A_Index], "^(.+?)\|\|(.+?)\|\|(.+?)\|\|(.+?)$", AutoClicksMatch)
			if (FoundPos && StrLen(AutoClicksArr[A_Index])>6){
				AutoClicksPresetNum := AutoClicksMatch1
				AutoClicksHotkey := AutoClicksMatch2
				AutoClicksEnabled := AutoClicksMatch3
				AutoClicksChecked := AutoClicksEnabled ? "checked" : ""
				AutoClicksToggle := AutoClicksMatch4
			
				FoundPos := RegexMatch(AutoClickPresetsArr[AutoClicksPresetNum], "\-\-\-(.+?)\|\|(.+?)\|\|(.+?)\|\|(.+?)\|\|(.+?)$", AutoClicksMatch)
				AutoClicksKey := AutoClicksMatch3
				if (AutoClicksToggle && AutoClicksHotkey!="..."){
					AutoClicksCurrentFunction := Func("AutoClicksHotkeyFunction").bind(A_Index, AutoClicksMatch3, AutoClicksMatch4, AutoClicksMatch5, AutoClicksToggle)
					AutoClicksActiveHotkeys.push(AutoClicksHotkey)
					Hotkey, *~%AutoClicksHotkey%, %AutoClicksCurrentFunction%, On
				}
				

				AutoClickscurrentDisp := A_Index=AutoClickschosen ? "block" : "none"

				,AutoClicksBgColor := SplashColors[AutoClicksColorIndex]
				,AutoClicksTextColor := ChooseTextColor2(AutoClicksBgColor)
				,AutoClicksToggleStr := AutoClicksToggle ? "checked" : ""

				,AutoClickPresetsHTMLinnerCurr := RegexReplace(AutoClickPresetsHTMLinner, "value=""" AutoClicksPresetNum """", "value=""" AutoClicksPresetNum """ selected ")
				,AutoClicksLinksHTML := AutoClicksLinksHTML "`n`t<button class=""tablinks"" onclick=""window.location.href = 'myapp://openTab/AutoClicks/" A_Index "'"" id=""AutoClickstablink" A_Index """ style=""background-color:#" AutoClicksBgColor "; color:#" AutoClicksTextColor ";"">" A_Index "</button>"
				;,AutoClicksHTML := AutoClicksHTML "<div id=""AutoClicksdiv" A_Index """ class=""tabbeddiv"" style=""display:" AutoClickscurrentDisp ";"">`n<table style=""background-color:#" AutoClicksBgColor ";width:100%;"">`n<tr>`n`t<td align=""left"" style=""color:#" AutoClicksTextColor ";width:33%;"">Preset:</td>`n`t<td style=""width:66%;""><select id=""AutoClicksPreset" A_Index """ class=""SelectDropdown"">" AutoClickPresetsHTMLinnerCurr "</select></td>`n</tr>`n<tr>`n`t<td align=""left"" style=""color:#" AutoClicksTextColor ";"">Hotkey:</td>`n`t<td style=""color:#" AutoClicksTextColor ";""><input type=""text"" id=""AutoClicksHotkey" A_Index """ value=""" AutoClicksHotkey """ ></td>`n</tr>`n<tr>`n`t<td align=""left"" style=""color:#" AutoClicksTextColor ";"">Spam Key:</td>`n`t<td style=""color:#" AutoClicksTextColor ";""><input disabled type=""text"" id=""AutoClicksKey" A_Index """ value=""" AutoClicksKey """ ></td>`n</tr>`n<tr>`n`t<td align=""center"" colspan=""2"" style=""color:#" AutoClicksTextColor ";""><table style=""width:100%;""><tr><td style=""text-align:center;""><input type=""radio"" name=""AutoClicksToggle" A_Index """ id=""AutoClicksToggleA" A_Index """ value=""1"" style=""background-color:#" AutoClicksBgColor """ " AutoClicksCurrentToggleA "><label for=""AutoClicksToggleA" A_Index """ style=""color:#" AutoClicksTextColor """> Toggle</label></td><td style=""text-align:center;""><input type=""radio"" name=""AutoClicksToggle" A_Index """ id=""AutoClickToggleB" A_Index """ value=""0"" style=""background-color:#" AutoClicksBgColor ";"" " AutoClicksCurrentToggleB "><label for=""AutoClicksToggleB" A_Index """ style=""color:#" AutoClicksTextColor """> Hold</label></td></tr></table></td>`n</tr>`n`n<tr>`n`t<td colspan=""2""><table style=""width:100%;""><tr><td style=""text-align:center;width:33%;""><input type=""button"" onclick=""window.location.href = 'myapp://AutoClicks/Remove/" A_Index "'"" value=""Remove"" id=""AutoClicksRemove" A_Index """></td><td style=""text-align:center;width:33%;""><input type=""button"" onclick=""window.location.href = 'myapp://AutoClicks/Update/" A_Index "'"" value=""Update"" id=""AutoClicksUpdate" A_Index """></td><td style=""text-align:center;""><div class=""button r"" id=""AutoClicksEnabledDiv" A_Index """>`n`t`t<input type=""checkbox"" class=""checkbox"" id=""AutoClicksEnabled" A_Index """ " AutoClicksChecked "/>`n`t`t<div class=""knobs""></div>`n`t`t<div class=""layer""></div>`n`t</div>`n</td></tr></table>`n</td>`n</tr>`n</table>`n</div>`n`n`n"
				,AutoClicksHTML := AutoClicksHTML "<div id=""AutoClicksdiv" A_Index """ class=""tabbeddiv"" style=""display:" AutoClickscurrentDisp ";"">`n<table style=""width:100%;"">`n<tr>`n`t<td align=""left"" style=""color:#" AutoClicksTextColor ";width:33%;"">Preset:</td>`n`t<td style=""width:66%;""><select id=""AutoClicksPreset" A_Index """ class=""SelectDropdown"">" AutoClickPresetsHTMLinnerCurr "</select></td>`n</tr>`n<tr>`n`t<td align=""left"" style=""color:#" AutoClicksTextColor ";"">Hotkey:</td>`n`t<td style=""color:#" AutoClicksTextColor ";""><input type=""text"" id=""AutoClicksHotkey" A_Index """ value=""" AutoClicksHotkey """ ></td>`n</tr>`n<tr>`n`t<td align=""left"" style=""color:#" AutoClicksTextColor ";"">Spam Key:</td>`n`t<td style=""color:#" AutoClicksTextColor ";""><input disabled type=""text"" id=""AutoClicksKey" A_Index """ value=""" AutoClicksKey """ ></td>`n</tr>`n<tr>`n`t<td align=""center"" colspan=""2"" style=""color:#" AutoClicksTextColor ";""><table style=""width:100%;""><tr><td colspan=""2"" style=""text-align: center;""><div style=""width:33%;display:inline-block;color:#" AutoClicksTextColor ";"">Hold</div><div style=""display:inline-block;top:5px;""><div class=""button r2"" id=""AutoClicksToggleDiv" A_Index """><input type=""checkbox"" class=""checkbox"" id=""AutoClicksToggle" A_Index """ " AutoClicksToggleStr "/><div class=""knobs""></div><div class=""layer""></div></div></div><div style=""width:33%;display:inline-block;color:#" AutoClicksTextColor ";"">Toggle</div></td></tr></table></td>`n</tr>`n`n<tr>`n`t<td colspan=""2""><table style=""width:100%;""><tr><td style=""text-align:center;width:33%;""><input type=""button"" onclick=""window.location.href = 'myapp://AutoClicks/Remove/" A_Index "'"" value=""Remove"" id=""AutoClicksRemove" A_Index """></td><td style=""text-align:center;width:33%;""><input type=""button"" onclick=""window.location.href = 'myapp://AutoClicks/Update/" A_Index "'"" value=""Update"" id=""AutoClicksUpdate" A_Index """></td><td style=""text-align:center;""><div class=""button r"" id=""AutoClicksEnabledDiv" A_Index """>`n`t`t<input type=""checkbox"" class=""checkbox"" id=""AutoClicksEnabled" A_Index """ " AutoClicksChecked "/>`n`t`t<div class=""knobs""></div>`n`t`t<div class=""layer""></div>`n`t</div>`n</td></tr></table>`n</td>`n</tr>`n</table>`n</div>`n`n`n"
				
				AutoClicksColorIndex := AutoClicksColorIndex+1>SplashColors.MaxIndex() ? 1 : AutoClicksColorIndex+1
			}
		}
		AutoClicksLinksHTML := AutoClicksLinksHTML "`n</div>"

		;Clipboard := AutoClicksLinksHTML "`n`n`n`n------------------------------------------------------------------------`n`n`n`n" AutoClicksHTML

		HTMLDisplay.document.getElementById("AutoClicksLinksHTML").innerHTML := AutoClicksLinksHTML
		HTMLDisplay.document.getElementById("AutoClicksHTML").innerHTML := AutoClicksHTML
		HTMLDisplay.document.getElementById("AutoClicksLinksHTML").style.display := HTMLDisplay.document.getElementById("AutoClicksHTML").style.display := "block"
	}else{
		HTMLDisplay.document.getElementById("AutoClicksLinksHTML").style.display := HTMLDisplay.document.getElementById("AutoClicksHTML").style.display := "none"
	}

	;AutoClicksArr := ""

return
;aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

AutoClicksHotkeyFunction(Index:=1, Key:="a", SpamDelay:=100, HoldDelay:=0){
	
	if (WinsActive() && AutoClickCheck){			;if Toggle, need this function. Otherwise Holding is done in main loop ;AutoClicksToggle
		global AutoClicksActiveArr
		AutoClicksActiveArr[Index] := AutoClicksActiveArr[Index] ? 0 : 1
		global AutoClicksPressKeyArr
		global AutoClicksHoldingArr
		if (AutoClicksActiveArr[Index] && !AutoClicksHoldingArr[Index]){ ; && !QTinProgress && !AutoClickHolding){
			
			AutoClicksTimer := HoldDelay ? SpamDelay + HoldDelay : SpamDelay
			if (SpamDelay!="0"){
				;Tooltip, Spamming %Key% - OFF

				global AutoClicksNextTimeMSArr
				AutoClicksNextTimeMSArr[Index] := Substr(SpamDelay, StrLen(SpamDelay)-2) + A_MSec
				TempTime := A_Now
				EnvAdd, TempTime, floor(SpamDelay/1000), s
				global AutoClicksNextTimeArr
				AutoClicksNextTimeArr[Index] := TempTime

				AutoClicksPressKey(Index, Key, SpamDelay, HoldDelay)


				AutoClicksPressKey := AutoClicksPressKeyArr[Index] := Func("AutoClicksPressKey").bind(Index, Key, SpamDelay, HoldDelay)
				SetTimer, %AutoClicksPressKey%, %AutoClicksTimer%

				;GoSub, %AutoClicksPressKey%					;;Target Label does not exist???????????
			}else{
				;Tooltip, Holding %Key% - ON
				Send {%Key% down}
			}
		}else{
			;Tooltip, Spamming %Key% - OFF
			AutoClicksPressKey := AutoClicksPressKeyArr[Index]
			;if (isLabel(AutoClicksPressKey))
			if(SpamDelay!="0")
				SetTimer, % AutoClicksPressKey, Off
			else
				Send {%Key% up}
			AutoClicksHoldingArr[Index] := 0
			;AutoClicksHolding := 0
			if (HoldDelay!="0" || SpamDelay="0"){
				Send {%Key% up}
				TempTime := A_Now
				global AutoClicksNextTimeMSArr
				AutoClicksNextTimeMSArr[Index] := Substr(SpamDelay, StrLen(SpamDelay)-2) + A_MSec
				EnvAdd, TempTime, SpamDelay/1000, s
				global AutoClicksNextTimeArr
				AutoClicksNextTimeArr[Index] := TempTime
			}
		}
	}
}


AutoClicksPressKey(Index:=1, Key:="a", SpamDelay:=100, HoldDelay:=0){
	if (WinsActive()){

		global GachaFarmingHotkey
		global GachaFarmingCheck
		global GachaFarming

		global QTHotkey
		global QTCheck
		global QTinProgress

		if (!GachaFarming && !QTinProgress){
			if ((Key="t" && CheckInv()) || Key!="t"){
				if (HoldDelay!="0"){
					Send, {%Key% down}

					global AutoClicksKeyUpTimeMSArr
					AutoClicksKeyUpTimeMSArr[Index] := Substr(HoldDelay, StrLen(HoldDelay)-2) + A_MSec


					TempTime := A_Now
					EnvAdd, TempTime, floor(HoldDelay/1000), s
					global AutoClicksKeyUpTimeArr
					AutoClicksKeyUpTimeArr[Index] := TempTime

					global AutoClicksHoldingArr
					AutoClicksHoldingArr[Index] := 1
					;AutoClickHolding := 1


					AutoClicksReleaseKey := Func("AutoClicksReleaseKey").bind(Index, Key, SpamDelay, HoldDelay)
					SetTimer, %AutoClicksReleaseKey%, -%HoldDelay%
					
				}else{
					if (RegexMatch(GachaFarmingHotkey, "i)^" Key "$") && GachaFarmingCheck){
						;GoSub, GachaFarmingHotkeyFunction
						SetTimer, GachaFarmingHotkeyFunction, -1
					}else if (RegexMatch(QTHotkeyHotkey, "i)^" Key "$") && QTCheck){
						;GoSub, QTHotkeyFunction
						SetTimer, QTHotkeyFunction, -1
					}else if (Key="Space"){
						Send, {%Key% down}
						Sleep, 50
						Send, {%Key% up}
					}else
						Send, {%Key%}
					global AutoClicksHoldingArr
					AutoClicksHoldingArr[Index] := 0
					;AutoClickHolding := 0
					global AutoClicksNextTimeMSArr
					AutoClicksNextTimeMSArr[Index] := Substr(SpamDelay, StrLen(SpamDelay)-2) + A_MSec
					,TempTime := A_Now
					EnvAdd, TempTime, floor(SpamDelay/1000), s
					global AutoClicksNextTimeArr
					AutoClicksNextTimeArr[Index] := TempTime
				}
			}
		}
	}

}

AutoClicksReleaseKey(Index:=1, Key:="a", SpamDelay:=100, HoldDelay:=0){
	global AutoClicksHoldingArr
	;if (AutoClickHolding)
	if (AutoClicksHoldingArr[Index])
		Send, {%Key% up}
	AutoClicksHoldingArr[Index] := 0
	;AutoClickHolding := 0
	global AutoClicksNextTimeMSArr
	AutoClicksNextTimeMSArr[Index] := Substr(SpamDelay, StrLen(SpamDelay)-2) + A_MSec
	,TempTime := A_Now
	EnvAdd, TempTime, floor(SpamDelay/1000), s
	global AutoClicksNextTimeArr
	AutoClicksNextTimeArr[Index] := TempTime
}






UpdateTimedAlerts:
	TimedAlertsHTML := ""
	TimedAlertstoNotify := []
	IniRead, TimedAlerts, %FileSettings%, Main, TimedAlerts

	TimedAlerts := TimedAlerts2 := RegexReplace(substr(TimedAlerts, 4, StrLen(TimedAlerts)-3), "~~~", "~~~`n")
	if (TAAnchor=1 || TAAnchor=3)
		Sort, TimedAlerts2, N R
	else
		Sort, TimedAlerts2, N
	TimedAlerts := RegexReplace(TimedAlerts, "\n")
	TimedAlerts2 := RegexReplace(TimedAlerts2, "\n")
	TAarr := StrSplit(SubStr(TimedAlerts, 1, StrLen(TimedAlerts)-3),"~~~")
	TAarr2 := StrSplit(SubStr(TimedAlerts2, 1, StrLen(TimedAlerts2)-3),"~~~")
	;Tooltip % substr(TimedAlerts, 4, StrLen(TimedAlerts)-6)

	Gdip_GraphicsClear(pGraphics11, 0x00000000)
	TABool := TAScreenDisp && WinsActive() && !CheckInv()

	if (TAarr2.MaxIndex()>0 && TABool){
		LastTAindex2 := TAarr2.MaxIndex()
		TAColorIndex := 2
		if(TABool)
			Gdip_FillRectangle(pGraphics11, GuiBackgroundBrush, 0, 0, TAW, TAH)
		Loop % TAarr2.MaxIndex(){
			
			FoundPos := RegexMatch(TAarr2[A_Index], "^(.+?)\|\|\|(.+?)$", TAMatch)
			if (FoundPos && StrLen(TAarr2[A_Index])>10){
				Title := TAMatch2
				,EndTime := EndTime2 := TAMatch1
				,StartTime := StartTime2 := A_Now
				if (EndTime2>StartTime){
					EnvSub, EndTime, StartTime, s
					;Tooltip, %EndTime%
					OutputTimeD := EndTime/60/60/24
				}
				else{
					EnvSub, StartTime, EndTime, s
					;Tooltip, -%StartTime%
					OutputTimeD := StartTime/60/60/24
				}
				
				OutputTimeH := (OutputTimeD - floor(OutputTimeD))*24, OutputTimeM := (OutputTimeH - floor(OutputTimeH))*60, OutputTimeS := (OutputTimeM - floor(OutputTimeM))*60
				;Tooltip, %OutputTimeD%`n%OutputTimeH%`n%OutputTimeM%`n%OutputTimeS%

				,OutputTimeDDisp := floor(OutputTimeD), OutputTimeHDisp := floor(OutputTimeH), OutputTimeMDisp := floor(OutputTimeM), OutputTimeSDisp := floor(OutputTimeS)

				,OutputTimeDDisp := OutputTimeDDisp != "" && OutputTimeDDisp != 0 ? OutputTimeDDisp "d " : ""
				,OutputTimeHDisp := OutputTimeHDisp != "" && OutputTimeHDisp != 0 ? OutputTimeHDisp "h " : ""
				,OutputTimeMDisp := OutputTimeMDisp != "" && OutputTimeMDisp != 0 ? OutputTimeMDisp "m " : ""
				,OutputTimeSDisp := OutputTimeSDisp != "" && OutputTimeSDisp != 0 ? OutputTimeSDisp "s" : "0s"
				;Tooltip, %OutputTimeDDisp%`n%OutputTimeHDisp%`n%OutputTimeMDisp%`n%OutputTimeSDisp%

				OutputTimeSDisp := StrLen(OutputTimeDDisp)>0 ? "" : OutputTimeSDisp

				RemainingTime := OutputTimeDDisp OutputTimeHDisp OutputTimeMDisp OutputTimeSDisp
				RemainingTime := EndTime2>StartTime2 ? RemainingTime : "-" RemainingTime


				;TAXcurr := (TASize*LongestOutputTime*0.77)+25
				TAXcurr := 150
				;,TAYcurr := TAAnchor=1 || TAAnchor=3 ? (TASize+2)*(A_Index-1)+4
				,TAYcurr := (TASize+2)*(A_Index-1)+4

				,TimedAlertColor := RegexMatch(RemainingTime, "-") ? "FF0000" : "FFFFFF"


				;pBitmapTA := GdipCreateFromBase64(SplashColorImages[TAColorIndex])
				pBitmapTA := Gdip_CreateBitmapFromFile(SplashColorImages[TAColorIndex])
				Gdip_DrawImage(pGraphics11, pBitmapTA, 0, TAYcurr, TASize+2, TASize+2)
				;Gdip_SaveBitmapToFile(pBitmapTA, A_ScriptDir "\test-" A_Index ".png", 100)
				Gdip_DisposeImage(pBitmapTA)


				;Time Left
				,Gdip_TextToGraphics(pGraphics11, RemainingTime, "x" 2+TASize+TASX " y" TAYcurr+TASY " Left vCenter Bold cFF000000 s" TASize, FontFace)
				,Gdip_TextToGraphics(pGraphics11, RemainingTime, "x" 2+TASize " y" TAYcurr " Left vCenter Bold cFF" TimedAlertColor " s" TASize, FontFace)


				;Title Right
				,Gdip_TextToGraphics(pGraphics11, Title, "x" 2+TASize+TAXcurr+TASX " y" TAYcurr+TASY " Left vCenter Bold cFF000000 s" TASize, FontFace)
				,Gdip_TextToGraphics(pGraphics11, Title, "x" 2+TASize+TAXcurr " y" TAYcurr " Left vCenter Bold cFF" TimedAlertColor " s" TASize, FontFace)


				TAColorIndex := TAColorIndex+1>SplashColors.MaxIndex() ? 1 : TAColorIndex+1
			}
		}

		pPenTA := Gdip_CreatePen("0x66FFFFFF", 2)
		Lines := TAAnchor="2" ? TAmarginX "," TAH-LineLen "|" TAmarginX "," TAH-TAmarginY "|" LineLen "," TAH-TAmarginY : TAAnchor="3" ? TAW-2*TAmarginX-LineLen "," TAmarginY "|" TAW-2*TAmarginX "," TAmarginY "|" TAW-2*TAmarginX "," LineLen : TAAnchor="4" ? TAW-LineLen "," TAH-TAmarginY	"|" TAW-2*TAmarginX "," TAH-TAmarginY "|" TAW-2*TAmarginX  "," TAH-LineLen : TAmarginX "," TAmarginY+LineLen "|" TAmarginX "," 0 "|" LineLen  "," 0
		Gdip_DrawLines(pGraphics11, pPenTA, Lines)
		Gdip_DeletePen(pPenTA)
	
	}
	TAarr2 := ""
	TABool := 0
	;global TSTText := "Choose Growth Direction: 1)Up     2)Right     3)Down     4)Left"
	;global TSTText := "Choose Anchor Point: 1)Top Left     2)Bottom Left     3)Top Right     4)Bottom Right"


	TAXactual := TAAnchor=1 || TAAnchor=2 ? TAX	: TAX-TAW
	TAYactual := TAAnchor=1 || TAAnchor=3 ? TAY	: TAY-TAH
	UpdateLayeredWindow(TAHwnd, hdc11, TAXactual, TAYactual, TAW, TAH)

	





	if (TAarr.MaxIndex()>0){
		LastTAindex := TAarr.MaxIndex()

		TimedAlertsLinksHTML := "<table style=""width:98%;"">`n<tr>`n<td colspan=""2"" style=""border-top:solid 4px"" ></td>`n</tr>`n</table>`n`n<div class=""tabLinks"">`n"
		TAColorIndex := 1
		Loop % TAarr.MaxIndex(){
			
			FoundPos := RegexMatch(TAarr[A_Index], "^(.+?)\|\|\|(.+?)$", TAMatch)
			if (FoundPos && StrLen(TAarr[A_Index])>10){
				Title := TAMatch2
				,EndTime := EndTime2 := TAMatch1
				,StartTime := StartTime2 := A_Now
				if (EndTime2>StartTime){
					EnvSub, EndTime, StartTime, s
					;Tooltip, %EndTime%
					OutputTimeD := EndTime/60/60/24
				}
				else{
					EnvSub, StartTime, EndTime, s
					;Tooltip, -%StartTime%
					OutputTimeD := StartTime/60/60/24
				}
				
				OutputTimeH := (OutputTimeD - floor(OutputTimeD))*24, OutputTimeM := (OutputTimeH - floor(OutputTimeH))*60, OutputTimeS := (OutputTimeM - floor(OutputTimeM))*60
				;Tooltip, %OutputTimeD%`n%OutputTimeH%`n%OutputTimeM%`n%OutputTimeS%

				,OutputTimeDDisp := floor(OutputTimeD), OutputTimeHDisp := floor(OutputTimeH), OutputTimeMDisp := floor(OutputTimeM), OutputTimeSDisp := floor(OutputTimeS)

				,OutputTimeDDisp := OutputTimeDDisp != "" && OutputTimeDDisp != 0 ? OutputTimeDDisp "d " : ""
				,OutputTimeHDisp := OutputTimeHDisp != "" && OutputTimeHDisp != 0 ? OutputTimeHDisp "h " : ""
				,OutputTimeMDisp := OutputTimeMDisp != "" && OutputTimeMDisp != 0 ? OutputTimeMDisp "m " : ""
				,OutputTimeSDisp := OutputTimeSDisp != "" && OutputTimeSDisp != 0 ? OutputTimeSDisp "s" : "0s"
				;Tooltip, %OutputTimeDDisp%`n%OutputTimeHDisp%`n%OutputTimeMDisp%`n%OutputTimeSDisp%

				OutputTimeSDisp := StrLen(OutputTimeDDisp)>0 ? "" : OutputTimeSDisp

				RemainingTime := OutputTimeDDisp OutputTimeHDisp OutputTimeMDisp OutputTimeSDisp
				RemainingTime := EndTime2>StartTime2 ? RemainingTime : "-" RemainingTime
				;Tooltip, %RemainingTime%

				TAcurrentBGcolor := A_Index=TAchosen ? "#777777" : "#333333"
				,TAcurrentDisp := A_Index=TAchosen ? "block" : "none"
				,TimedAlertBgColor := SplashColors[TAColorIndex]
				,TimedAlertTextColor := ChooseTextColor2(TimedAlertBgColor)
				,TimedAlertTextColor2 := TimedAlertTextColor="ffffff" ? "" : "i"

				,TimedAlertsLinksHTML := TimedAlertsLinksHTML "`n`t<button class=""tablinks"" onclick=""window.location.href = 'myapp://openTab/TA/" A_Index "'"" id=""TAtablink" A_Index "'"" style=""background-color:#" TimedAlertBgColor "; color:#" TimedAlertTextColor ";"">" A_Index "</button>"
				;,TimedAlertsHTML := TimedAlertsHTML "<div id=""TAdiv" A_Index """ class=""tabbeddiv"" style=""display:" TAcurrentDisp ";"">`n<table class=""TAtable"" style=""background-color:#" TimedAlertBgColor ";"">`n<tr>`n`t<td align=""left"" style=""color:#" TimedAlertTextColor ";"">Alert Title " A_Index ":</td>`n`t<td><input type=""text"" id=""TimedAlertsTitle" A_Index """ value=""" Title """ disabled></td>`n</tr>`n<tr>`n`t<td align=""left"" style=""color:#" TimedAlertTextColor ";"">Time Left " A_Index ":</td>`n`t<td><input type=""text"" name=""" EndTime2 """ id=""TimedAlertsRemaining" A_Index """ value=""" RemainingTime """  disabled></td>`n</tr>`n<tr>`n`t<td style=""text-align:center"" colspan=""2"">`n`t 				<table style=""width:100%;""><tr><td style=""width:60%;""><input type=""button"" onclick=""buttonpress(this)"" value=""Remove"" id=""RemoveTimedAlert" A_Index """></td>			<td style=""text-align:center;color:#" TimedAlertTextColor ";""><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "DU""><img src=""" CapDir "\Arrow3.png""></button><br>D<br><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "DD""><img src=""" CapDir "\Arrow1.png""></button></td>   		<td style=""text-align:center;color:#" TimedAlertTextColor ";""><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "HU""><img src=""" CapDir "\Arrow3.png""></button><br>H<br><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "HD""><img src=""" CapDir "\Arrow1.png""></button></td>		<td style=""text-align:center;color:#" TimedAlertTextColor ";""><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "MU""><img src=""" CapDir "\Arrow3.png""></button><br>M<br><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "MD""><img src=""" CapDir "\Arrow1.png""></button></td>   </tr></table>`n`t</td>`n</tr>`n</table>`n</div>`n`n`n"
				,TimedAlertsHTML := TimedAlertsHTML "<div id=""TAdiv" A_Index """ class=""tabbeddiv"" style=""display:" TAcurrentDisp ";"">`n<table class=""TAtable"">`n<tr>`n`t<td align=""left"" style=""color:#" TimedAlertTextColor ";"">Alert Title " A_Index ":</td>`n`t<td><input type=""text"" id=""TimedAlertsTitle" A_Index """ value=""" Title """ disabled></td>`n</tr>`n<tr>`n`t<td align=""left"" style=""color:#" TimedAlertTextColor ";"">Time Left " A_Index ":</td>`n`t<td><input type=""text"" name=""" EndTime2 """ id=""TimedAlertsRemaining" A_Index """ value=""" RemainingTime """  disabled></td>`n</tr>`n<tr>`n`t<td style=""text-align:center"" colspan=""2"">`n`t 				<table style=""width:100%;""><tr><td style=""width:60%;""><input type=""button"" onclick=""buttonpress(this)"" value=""Remove"" id=""RemoveTimedAlert" A_Index """></td>			<td style=""text-align:center;color:#" TimedAlertTextColor ";""><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "DU""><img class=""ArrowUD"" src=""" CapDir "\Arrow3" TimedAlertTextColor2 ".png""></button><br>D<br><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "DD""><img class=""ArrowUD"" src=""" CapDir "\Arrow1" TimedAlertTextColor2 ".png""></button></td>   		<td style=""text-align:center;color:#" TimedAlertTextColor ";""><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "HU""><img class=""ArrowUD"" src=""" CapDir "\Arrow3" TimedAlertTextColor2 ".png""></button><br>H<br><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "HD""><img class=""ArrowUD"" src=""" CapDir "\Arrow1" TimedAlertTextColor2 ".png""></button></td>		<td style=""text-align:center;color:#" TimedAlertTextColor ";""><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "MU""><img class=""ArrowUD"" src=""" CapDir "\Arrow3" TimedAlertTextColor2 ".png""></button><br>M<br><button class=""regularbutton"" type=""button"" onclick=""buttonpress(this)"" id=""TimedAlert" A_Index "MD""><img class=""ArrowUD"" src=""" CapDir "\Arrow1" TimedAlertTextColor2 ".png""></button></td>   </tr></table>`n`t</td>`n</tr>`n</table>`n</div>`n`n`n"
				
				if (EndTime2<=StartTime2)
					TimedAlertstoNotify.push(Title)
				TAColorIndex := TAColorIndex+1>SplashColors.MaxIndex() ? 1 : TAColorIndex+1
			}
		}
		TimedAlertsLinksHTML := TimedAlertsLinksHTML "`n</div>"

		;Clipboard := TimedAlertsLinksHTML
		HTMLDisplay.document.getElementById("TimedAlertsLinksHTML").innerHTML := TimedAlertsLinksHTML
		HTMLDisplay.document.getElementById("TimedAlertsHTML").innerHTML := TimedAlertsHTML
		HTMLDisplay.document.getElementById("TimedAlertsLinksHTML").style.display := HTMLDisplay.document.getElementById("TimedAlertsHTML").style.display := "block"

	}else{

		HTMLDisplay.document.getElementById("TimedAlertsLinksHTML").style.display := HTMLDisplay.document.getElementById("TimedAlertsHTML").style.display := "none"
	}
	
	

	TAarr := ""
return

UpdateDebug:
	if (ShowingDebugButton){
		HTMLDisplay.document.getElementById("DebugContent").innerHTML := DebugInfo
		HTMLDisplay.document.getElementById("DebugContent").style.display := "block"
		HTMLDisplay.document.getElementById("DebugArrow").src := CapDir "\Arrow1.png"
	}
return

MenuHandler:
;MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.


	if (A_ThisMenu="TreeToggleFunctions"){
		MenuItem := RegexReplace(A_ThisMenuItem, " ")
		MenuItem := RegexReplace(MenuItem, "EggChecker", "EC")
		if (Showing%MenuItem%Button){
			Menu, TreeToggleFunctions, Uncheck, %A_ThisMenuItem%
			Showing%MenuItem%Button := %MenuItem%Check := Showing := 0
			HTMLDisplay.document.getElementById(MenuItem "DropDown").style.display := HTMLDisplay.document.getElementById(MenuItem "Content").style.display := "none"
		}else{
			Menu, TreeToggleFunctions, Check, %A_ThisMenuItem%
			Showing%MenuItem%Button := %MenuItem%Check := Showing := 1
			HTMLDisplay.document.getElementById(MenuItem "DropDown").style.display := "block"
		}
		IniWrite, %Showing%, %FileSettings%, Main, Showing%MenuItem%Button

		if (A_ThisMenuItem="Splash Image"){
			HTMLDisplay.document.getElementById("MainTable").style.top := ShowingSplashImageButton ? GW-65 "px" : 0 "px"
			HTMLDisplay.document.getElementById(MenuItem "Content").style.display := ShowingSplashImageButton ? "block" : "none"
		}

		ServerFavoritesCheck := OfficialRatesCheck := ShowingServerInfoButton ? 1 : 0


	}else if (A_ThisMenu="TreeUpdatePixels"){
		if (A_ThisMenuItem="Check Inventory"){
			UpdatePixelLoc("CheckInv", "Click on the center of the X that closes the inventory.", CheckInvX, CheckInvY)
			IniWrite, %CheckInvX%, %FileSettings%, Main, CheckInvX
			IniWrite, %CheckInvY%, %FileSettings%, Main, CheckInvY
		}else if (A_ThisMenuItem="Your Search Bar"){
			UpdatePixelLoc("YourSearch", "Click on the center of YOUR search bar.", YourSearchX, YourSearchY)
			IniWrite, %YourSearchX%, %FileSettings%, Main, YourSearchX
			IniWrite, %YourSearchY%, %FileSettings%, Main, YourSearchY
		}else if (A_ThisMenuItem="Your Transfer All"){
			UpdatePixelLoc("YourTransferAll", "Click on the center of YOUR tranfser all button.",  YourTransferAllX, YourTransferAllY)
			IniWrite, %YourTransferAllX%, %FileSettings%, Main, YourTransferAllX
			IniWrite, %YourTransferAllY%, %FileSettings%, Main, YourTransferAllY
		}else if (A_ThisMenuItem="Your Drop All"){
			UpdatePixelLoc("YourDropAll", "Click on the center of YOUR drop all button.",  YourDropAllX, YourDropAllY)
			IniWrite, %YourDropAllX%, %FileSettings%, Main, YourDropAllX
			IniWrite, %YourDropAllY%, %FileSettings%, Main, YourDropAllY
		}else if (A_ThisMenuItem="Your Transfer Slot"){
			UpdatePixelLoc("YourTransferSlot", "Click on the center of YOUR first item slot used to transfer.",  YourTransferSlotX, YourTransferSlotY)
			IniWrite, %YourTransferSlotX%, %FileSettings%, Main, YourTransferSlotX
			IniWrite, %YourTransferSlotY%, %FileSettings%, Main, YourTransferSlotY
		

		}else if (A_ThisMenuItem="Their Search Bar"){
			UpdatePixelLoc("TheirSearch", "Click on the center of THEIR search bar.",  TheirSearchX, TheirSearchY)
			IniWrite, %TheirSearchX%, %FileSettings%, Main, TheirSearchX
			IniWrite, %TheirSearchY%, %FileSettings%, Main, TheirSearchY
		}else if (A_ThisMenuItem="Their Transfer All"){
			UpdatePixelLoc("TheirTransferAll", "Click on the center of THEIR tranfser all button.",  TheirTransferAllX, TheirTransferAllY)
			IniWrite, %TheirTransferAllX%, %FileSettings%, Main, TheirTransferAllX
			IniWrite, %TheirTransferAllY%, %FileSettings%, Main, TheirTransferAllY
		}else if (A_ThisMenuItem="Their Drop All"){
			UpdatePixelLoc("TheirDropAll", "Click on the center of THEIR drop all button.",  TheirDropAllX, TheirDropAllY)
			IniWrite, %TheirDropAllX%, %FileSettings%, Main, TheirDropAllX
			IniWrite, %TheirDropAllY%, %FileSettings%, Main, TheirDropAllY
		}else if (A_ThisMenuItem="Their Transfer Slot"){
			UpdatePixelLoc("TheirTransferSlot", "Click on the center of THEIR first item slot used to transfer.",  TheirTransferSlotX, TheirTransferSlotY)
			IniWrite, %TheirTransferSlotX%, %FileSettings%, Main, TheirTransferSlotX
			IniWrite, %TheirTransferSlotY%, %FileSettings%, Main, TheirTransferSlotY
		

		}else if (A_ThisMenuItem="Structure Health - Dino XP"){
			UpdatePixelLoc("StructureHP", "Click directly underneath the ""X"" in the XP bar of a dino.",  StructureHPX, StructureHPY)
			IniWrite, %StructureHPX%, %FileSettings%, Main, StructureHPX
			IniWrite, %StructureHPY%, %FileSettings%, Main, StructureHPY
		}
	}
return





UpdatePixelLoc(PixelName, PixelDesc, ByRef PixelX, ByRef PixelY, AnchorBool:=0, ByRef AnchorNum:="", ByRef GrowDir:="", KeepOpen:=0, PixelW:=6, PixelH:=6){
	global DisplayingMessage := 1
	GoSub, TST_On


	Gui, 2:Destroy
	Gui, 2:New, -Caption +E0x80000 +E0x20 +AlwaysOnTop +ToolWindow +OwnDialogs +LastFound +HwndPixelhwnd ; Create GUI
	Gui, 2:Show, , ChoosePixel ; Show GUI

	PixelX := PixelX="" || PixelX=0 ? A_ScreenWidth/2 : floor(PixelX)
	,PixelY := PixelY="" || PixelY=0 ? A_ScreenHeight/2 : floor(PixelY)

	,hbm2 := CreateDIBSection(PixelW+2, PixelH+2) ; Create a gdi bitmap drawing area
	,hdc2 := CreateCompatibleDC() ; Get a device context compatible with the screen
	,obm2 := SelectObject(hdc2, hbm2) ; Select the bitmap into the device context
	,pGraphics2 := Gdip_GraphicsFromHDC(hdc2) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	,Gdip_SetSmoothingMode(pGraphics2, 4) ; Set the smoothing mode to antialias = 4 to make shapes appear smother
	
	
	,pPen := Gdip_CreatePen(0xFFFF0000, 3)
	,Gdip_DrawRectangle(pGraphics2, pPen, 0, 0, PixelW, PixelH)
	,Gdip_DeletePen(pPen)
	,UpdateLayeredWindow(Pixelhwnd, hdc2, KeepOpen ? PixelX : PixelX-PixelW/2, KeepOpen ? PixelY : PixelY-PixelH/2, PixelW+1, PixelH+1)
	,SelectObject(hdc2, obm2) ; Select the object back into the hdc
	,DeleteObject(hbm2) ; Now the bitmap may be deleted
	,DeleteDC(hdc2) ; Also the device context related to the bitmap may be deleted
	,Gdip_DeleteGraphics(pGraphics2) ;


	if (!WinsExist()){
		global TSTText := "Could not find Game Window"
		global TSTEnabled := 1
		GoSub, TST_Update
		Sleep 2000
		global DisplayingMessage := 0
		return
	}




	if (AnchorBool>0){
		global TSTText := "Choose Anchor Point: 1)Top Left     2)Bottom Left     3)Top Right     4)Bottom Right"
		global TSTEnabled := 1
		GoSub, TST_Update


		LastKey := ""
		While (!RegexMatch(LastKey, "^(Numpad)?[1-4]$")){
			LastKey := A_PriorKey
			KeyInputAttempt := A_Now
			;Tooltip, %LastKey%
			Sleep 20
		}
		AnchorNum := LastKey
		;IniWrite, %AnchorNum%, %FileSettings%, Main, %PixelName%Anchor
		AnchorText := AnchorNum="2" ? "Bottom Left" : AnchorNum="3" ? "Top Right" : AnchorNum="4" ? "Bottom Right" : "Top Left"


		global TSTText := PixelName " ANCHOR has been set to " AnchorText ". Right Click to Continue..."
		global TSTEnabled := 1
		GoSub, TST_Update


		While (A_PriorKey!="RButton"){
			Sleep 20
		}

		if (AnchorBool=2){

			if (AnchorNum=1){ ;Anchor "Top Left"

				global TSTText := "Choose Growth Direction: 2)Right     3)Down"
				global TSTEnabled := 1
				GoSub, TST_Update


				LastKey := ""
				While (!RegexMatch(LastKey, "^(Numpad)?[23]$")){
					LastKey := A_PriorKey
					KeyInputAttempt := A_Now
					;Tooltip, %LastKey%
					Sleep 20
				}

			} else if (AnchorNum=2){ ;Anchor "Bottom Left"

				global TSTText := "Choose Growth Direction: 1)Up     2)Right"
				global TSTEnabled := 1
				GoSub, TST_Update


				LastKey := ""
				While (!RegexMatch(LastKey, "^(Numpad)?[12]$")){
					LastKey := A_PriorKey
					KeyInputAttempt := A_Now
					;Tooltip, %LastKey%
					Sleep 20
				}

			}else if (AnchorNum=3){ ;Anchor "Top Right"

				global TSTText := "Choose Growth Direction: 3)Down     4)Left"
				global TSTEnabled := 1
				GoSub, TST_Update


				LastKey := ""
				While (!RegexMatch(LastKey, "^(Numpad)?[34]$")){
					LastKey := A_PriorKey
					KeyInputAttempt := A_Now
					;Tooltip, %LastKey%
					Sleep 20
				}

			}else if (AnchorNum=4){ ;Anchor "Bottom Right"

				global TSTText := "Choose Growth Direction: 1)Up     4)Left"
				global TSTEnabled := 1
				GoSub, TST_Update


				LastKey := ""
				While (!RegexMatch(LastKey, "^(Numpad)?[14]$")){
					LastKey := A_PriorKey
					KeyInputAttempt := A_Now
					;Tooltip, %LastKey%
					Sleep 20
				}

			}

			GrowDir := LastKey
			;IniWrite, %GrowDir%, %FileSettings%, Main, %PixelName%GrowDir
			GrowDirText := GrowDir="2" ? "Right" : GrowDir="3" ? "Down" : GrowDir="4" ? "Left" : "Up"

			global TSTText := PixelName " GROWTH DIRECTION has been set to " GrowDirText ". Right Click to Continue..."
			global TSTEnabled := 1
			GoSub, TST_Update


			While (A_PriorKey!="RButton"){
				Sleep 20
			}
		}
	}



	global TSTText := PixelDesc
	global TSTEnabled := 1
	GoSub, TST_Update


	While (!WinsActive() && WinsExist())
		Sleep 10

	LastKey := ""
	While (LastKey!="LButton"){
		LastKey := A_PriorKey
		;Tooltip, %LastKey%
		Sleep 20
	}

	MouseGetPos, PixelX, PixelY


	if (PixelX!=0 && PixelY!=0 && PixelX>0 && PixelY>0){
		WinMove, ahk_id %Pixelhwnd%, , KeepOpen ? PixelX : PixelX-PixelW/2, KeepOpen ? PixelY : PixelY-PixelH/2
		;IniWrite, %PixelX%, %FileSettings%, Main, %PixelName%X
		;IniWrite, %PixelY%, %FileSettings%, Main, %PixelName%Y
	}
	global TSTText := PixelName " was updated to X:" PixelX " Y: " PixelY
	global TSTEnabled := 1
	GoSub, TST_Update

	if (!KeepOpen){
		Sleep 2500


		global DisplayingMessage := 0

		global TSTText := ""
		global TSTEnabled := 0

		GoSub, TST_Off

		Gui, 2:Destroy
	}
	return
}


IsProcessElevated(ProcessID){
    if !(hProcess := DllCall("OpenProcess", "uint", 0x1000, "int", 0, "uint", ProcessID, "ptr"))
        throw Exception("OpenProcess failed", -1)
    if !(DllCall("advapi32\OpenProcessToken", "ptr", hProcess, "uint", 0x0008, "ptr*", hToken))
        throw Exception("OpenProcessToken failed", -1), DllCall("CloseHandle", "ptr", hProcess)
    if !(DllCall("advapi32\GetTokenInformation", "ptr", hToken, "int", 20, "uint*", IsElevated, "uint", 4, "uint*", size))
        throw Exception("GetTokenInformation failed", -1), DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
    return IsElevated, DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
}


WinsActive(){
	if(InStr(DesiredWindows,",")){
		Wins := StrSplit(DesiredWindows, ",")
		Loop % Wins.MaxIndex() 
		{
			if(StrLen(Wins[A_Index])>2 && WinActive(Wins[A_Index]))
				return WinActive(Wins[A_Index])
		}
	}else{
		if(WinActive(DesiredWindows))
			return WinActive(DesiredWindows)
	}
	return false
}

WinsExist(){
	
	if(InStr(DesiredWindows,",")){
		Wins := StrSplit(DesiredWindows, ",")
		Loop % Wins.MaxIndex() 
		{
			if(StrLen(Wins[A_Index])>2 && WinExist(Wins[A_Index]))
				return WinExist(Wins[A_Index])
		}
	}else{
		if(WinExist(DesiredWindows))
			return WinExist(DesiredWindows)
	}
	return false
}



MakeSplashImage:
	if (!MakingSplash && !Exporting && !QTinProgress && !Popcorning && (FirstPass || ShowingSplashImageButton)){
		MakingSplash := 1
		,SplashPatterns := SplashPatterns="" ? "6|7|8|9|10|30|31|32|33|34|35|36|37|38|40|42|43|44|45|51" : SplashPatterns
		

		if (DebugSplash){

			DebugSplashDirSize := 0
			Loop, %A_ScriptDir%\DebugSplash\*.*, , 1
    			DebugSplashDirSize += A_LoopFileSize
    		DebugSplashDirSize := round(DebugSplashDirSize/1024/1024,2)	;bytes to MB
    		if (DebugSplashDirSize<100)
				FileCopy, %SplashImagePath%, %A_ScriptDir%\DebugSplash\%A_Now%.png 

		}
		if (FirstPass){
			MakeSplashImageFn("",IconW, SplashPatterns, SplashBool, SplashColors, 0, SplashImageSimpleB64)			;need to find what fucks windows - CLEAR
			global SplashImageSimpleB64
			SplashBitmapIcon := Gdip_CreateBitmapFromFile(SplashImagePath)
			;,SplashB64 := Vis2.stdlib.Gdip_EncodeBitmapTo64string(SplashBitmapIcon, "PNG", 75)






			hIcon := Gdip_CreateHICONFromBitmap(SplashBitmapIcon)

			if (hIcon){
				;WM_SETICON:=0x80, ICON_SMALL2:=0, ICON_BIG:=1
				SendMessage, 0x80, 1, hIcon,, ahk_id %MainHwnd%  ; Works for Alt+Tab List - does this fuck up windows? - CLEAR
				
			}
			DeleteObject(hIcon)


			pBitmapSplash := Gdip_CreateBitmap(PosW, PosH)
			,GSplash := Gdip_GraphicsFromImage(pBitmapSplash)
			,Gdip_DrawImage(GSplash, SplashBitmapIcon, 0, 0, PosW, PosH, 0, 0, IconW, IconW)
			,Gdip_DisposeImage(SplashBitmapIcon)
			
			hIcon2 := Gdip_CreateHICONFromBitmap(pBitmapSplash)
			if (hIcon2){
				SendMessage, 0x80, 0, hIcon2,, ahk_id %MainHwnd%  ; Set the window's small icon - does this fuck up windows? - Clear
				;try Menu, Tray, Icon, HICON:*%hIcon2%						THIS IS PROBLEM?
				
			}
			;Menu, Tray, Icon, HICON:*%hIcon2%
			;Menu, Tray, Icon
			DeleteObject(hIcon2)
			Gdip_DeleteGraphics(GSplash)
			Gdip_DisposeImage(pBitmapSplash)

			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;does this fuck up windows? ... this makes windows go haywire blank out. without this still messes up msgbox2 buttons


			SplashBitmapIcon2 := GdipCreateFromBase64(SplashImageSimpleB64)
			Gdip_SaveBitmapToFile(SplashBitmapIcon2, ImagesTempDir "\icon.png", 85)
			pBitmapSplash2 := Gdip_CreateBitmap(PosW, PosH)
			,GSplash2 := Gdip_GraphicsFromImage(pBitmapSplash2)
			,Gdip_DrawImage(GSplash2, SplashBitmapIcon2, 0, -2, PosW, PosH)

			;pBitmapSplash2 := GdipCreateFromBase64(SplashImageSimpleB64)

			hBitmapSplash := Gdip_CreateHBITMAPFromBitmap(pBitmapSplash2)
			if (hBitmapSplash){
				GuiControlGet, hwndSplash, hwnd, IconButton
				try SetImage(hwndSplash, hBitmapSplash)
				GuiControl, 1:+Redraw, IconButton
				;MAKE SURE WHEN EXE, icon is in tray
				Menu, Tray, Icon, HBITMAP:*%hBitmapSplash%
				Menu, Tray, Icon
			}

			DeleteObject(hBitmapSplash)
			Gdip_DeleteGraphics(GSplash2)
			Gdip_DisposeImage(pBitmapSplash2)
	
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			


			HTMLDisplay.document.getElementById("SplashImageTop").src := SplashImagePath "?" A_Now
			HTMLDisplay.document.getElementById("SplashImageBottom").src := SplashImagePath "?" A_Now

			if (RegexMatch(ThisUUID,"03AA02FC\-0414\-059E\-4406\-4F0700080009")){
				ConvertICO(ImagesTempDir "\icon.png")
			}


		}else if (HTMLDisplay.document.getElementsByTagName("html")[0].scrollTop<ActualImageW-70) {	;this is for settimer

			MakeSplashImageFn("",IconW, SplashPatterns, SplashBool, SplashColors, 1)
			;HTMLDisplay.document.parentWindow.transitionimage("data:image/png;base64," SplashB64)		;memory leak like this
			;SplashB64 := ""



			HTMLDisplay.document.parentWindow.transitionimage(SplashImagePath "?" A_Now)	;does this fuck up windows? - clear
			SplashModTime := 0
			While (SplashModTime=0 || A_Now<=SplashModTime){
				FileGetTime, SplashModTime, %SplashImagePath%
				Sleep 10
			}
		}

		MakingSplash := 0
	}
return




MakeSplashImageFn(OutputName:="", IconW:=512, SplashPatterns:="6|7|8|9|10|30|31|32|33|34|35|36|37|38|40|42|43|44|45|51", SplashBool:=0, SplashColors:="", ExtraFeatures:=0, ByRef IconB64:="", ByRef BackgroundB64:=""){
	global DebugSplash
	StartTime := A_TickCount

	pi := 4*ATan(1)				; pi := 3.1415927		4*ATan(1)			; RandA1 := 240
	,SplashR := IconW*0.3636 			; radius of imaginary circle for center of triangles

	Loop, 3     ;1 - Outer			;2 - Inner 			;3 - RadialFade
	{
		sizer := A_Index=1 ? IconW*0.1429 : A_Index=2 ? IconW*0.0833 : SplashR*0.66
		,PointsA%A_Index% := [IconW*0.5+sizer*cos(270*0.01745329) , (IconW*0.5-SplashR)-sizer*sin(270*0.01745329) , IconW*0.5+sizer*cos(150*0.01745329) , (IconW*0.5-SplashR)-sizer*sin(150*0.01745329) , IconW*0.5+sizer*cos(30*0.01745329) , (IconW*0.5-SplashR)-sizer*sin(30*0.01745329) ]
		;PointsA%A_Index% := [IconW/2+sizer*cos(270*pi/180) , (IconW/2-SplashR)-sizer*sin(270*pi/180) , IconW/2+sizer*cos(150*pi/180) , (IconW/2-SplashR)-sizer*sin(150*pi/180) , IconW/2+sizer*cos(30*pi/180) , (IconW/2-SplashR)-sizer*sin(30*pi/180) ]
				
		;Points%A_Index% := PointsA%A_Index%[1] "," PointsA%A_Index%[2] "|" PointsA%A_Index%[3] "," PointsA%A_Index%[4] "|" PointsA%A_Index%[5] "," PointsA%A_Index%[6]
	}

	Poly1 := round(PointsA1[3]) "," round(PointsA1[4]) "|" round(PointsA2[3]) "," round(PointsA2[4]) "|" round(PointsA2[5]) "," round(PointsA2[6]) "|" round(PointsA1[5]) "," round(PointsA1[6]) "|" round(PointsA1[3]) "," round(PointsA1[4])
	,Poly2 := round(PointsA1[3]) "," round(PointsA1[4]) "|" round(PointsA2[3]) "," round(PointsA2[4]) "|" round(PointsA2[1]) "," round(PointsA2[2]) "|" round(PointsA1[1]) "," round(PointsA1[2]) "|" round(PointsA1[3]) "," round(PointsA1[4])
	,Poly3 := round(PointsA2[1]) "," round(PointsA2[2]) "|" round(PointsA1[1]) "," round(PointsA1[2]) "|" round(PointsA1[5]) "," round(PointsA1[6]) "|" round(PointsA2[5]) "," round(PointsA2[6]) "|" round(PointsA2[1]) "," round(PointsA2[2])

	Poly4 := round(PointsA1[1]) "," round(PointsA1[2]) "|" round(PointsA1[3]) "," round(PointsA1[4]) "|" round(PointsA1[5]) "," round(PointsA1[6]) "|" round(PointsA1[1]) "," round(PointsA1[2])
	,Poly5 := round(PointsA2[1]) "," round(PointsA2[2]) "|" round(PointsA2[3]) "," round(PointsA2[4]) "|" round(PointsA2[5]) "," round(PointsA2[6]) "|" round(PointsA2[1]) "," round(PointsA2[2])
	,Poly6 := round(PointsA3[1]) "," round(PointsA3[2]) "|" round(PointsA3[3]) "," round(PointsA3[4]) "|" round(PointsA3[5]) "," round(PointsA3[6]) "|" round(PointsA3[1]) "," round(PointsA3[2])

	,PointsA1 := PointsA2 := PointsA3 := ""


	;;;;;;;;;;;;;This is Main Image to be saved
	SplashBitmapBig := Gdip_CreateBitmap(IconW, IconW), SplashGBig := Gdip_GraphicsFromImage(SplashBitmapBig), Gdip_SetSmoothingMode(SplashGBig, 4)
	




	;;;;;;;;;;;;;;;;;;Alpha Mask to make round splash image
	SplashBitmapMask := Gdip_CreateBitmap(IconW, IconW), SplashGMask := Gdip_GraphicsFromImage(SplashBitmapMask), Gdip_SetSmoothingMode(SplashGMask, 4)
	,SplashR := floor(IconW*0.1666)
	,RadialFadeScale := 0.5
	,PPathCurrent := Gdip_CreatePath(SplashGMask)
	,PathPoints := ""
	,CurrentAngle := 0
	Random, AngleInc, 5, 15
	While (CurrentAngle+AngleInc<360)
	{				
		;PathCurrentX := floor(IconW/2+SplashR*sin((CurrentAngle + AngleInc)*0.01745329))
		;PathCurrentY := floor(IconW/2+SplashR*cos((CurrentAngle + AngleInc)*0.01745329))
		Random, AngleRand1, -20, 20
		Random, AngleRand2, -20, 20
		PathCurrentX := floor(IconW*0.5+0.150*SplashR*sin(AngleRand1*0.01745329)+SplashR*sin((CurrentAngle + AngleInc)*0.01745329))
		,PathCurrentY := floor(IconW*0.5+0.150*SplashR*sin(AngleRand2*0.01745329)+SplashR*cos((CurrentAngle + AngleInc)*0.01745329))
		,CurrentAngle := CurrentAngle + AngleInc
		,PathPoints := PathPoints "|" PathCurrentX "," PathCurrentY
	}
	Gdip_AddPathPolygon(PPathCurrent, substr(PathPoints, 2)), PathPoints := ""
	;Gdip_AddPathEllipse(PPathCurrent, IconW/2-SplashR, IconW/2-SplashR, SplashR*2, SplashR*2)
	,DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", "Ptr", PPathCurrent, "PtrP", SplashBrush)
	VarSetCapacity(POINT, 8),	NumPut(IconW*0.5, POINT, 0, "Float"),	NumPut(IconW*0.5, POINT, 4, "Float")
	,DllCall("Gdiplus.dll\GdipSetPathGradientCenterPoint", "Ptr", SplashBrush, "Ptr", &POINT)
	,DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", "Ptr", SplashBrush, "UInt", 0xFF00FF00), POINT := ""
	,VarSetCapacity(COLOR, 4, 0)
	,NumPut(0x0000FF00, COLOR, 0, "UInt"), COLORS := 1
	,DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", "Ptr", SplashBrush, "Ptr", &Color, "IntP", COLORS)
	,DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", SplashBrush, "Float", RadialFadeScale, "Float", RadialFadeScale)

	,Gdip_FillPath(SplashGMask, SplashBrush, PPathCurrent)
	,Gdip_DeletePath(PPathCurrent)
	,Gdip_DeleteBrush(SplashBrush)


	FinishTime := round((A_TickCount - StartTime))			;62ms
	;Tooltip, %FinishTime%ms
	

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	DebugSplashInfo := ""
	;,SplashR := IconW/2.75   ; radius of imaginary circle for center of triangles


	;;;;;;;;;;;;;;;This is Main Splash Image ICON // Background
	,SplashBitmapIcon := Gdip_CreateBitmap(IconW, IconW), SplashGIcon := Gdip_GraphicsFromImage(SplashBitmapIcon), Gdip_SetSmoothingMode(SplashGIcon, 4)

	,SplashPatternsArr := StrSplit(SplashPatterns, "|")
	,SumR := SumG := SumB := ColorIndicies := 0
	,SumR2 := SumG2 := SumB2 := ColorIndicies2 := 0
	
	,SplashR := round(IconW*0.75)

	Magnitude := 0.001
	,MaxColor := 255

	CurrentIndex := 1
	,RandA1 := 60
	,SplashColors2 := {}	
	Loop % SplashColors.MaxIndex()*2 {
		RandA1 := Max(RandA1 - 10, 10)
		;RandA1 := 80
		Random, RandVal, 0.55, 0.725
		SplashR := floor(RandVal*SplashR)

		ColorR := Hex2Dec(SubStr(SplashColors[CurrentIndex], 1, 2)), ColorRmag := round(ColorR*Magnitude), ColorRmax := Min(ColorR+ColorRmag, MaxColor), ColorRmin := Max(0, ColorR-ColorRmag) 
		,ColorG := Hex2Dec(SubStr(SplashColors[CurrentIndex], 3, 2)), ColorGmag := round(ColorG*Magnitude), ColorGmax := Min(ColorG+ColorGmag, MaxColor), ColorGmin := Max(0, ColorG-ColorGmag) 
		,ColorB := Hex2Dec(SubStr(SplashColors[CurrentIndex], 5, 2)), ColorBmag := round(ColorB*Magnitude), ColorBmax := Min(ColorB+ColorBmag, MaxColor), ColorBmin := Max(0, ColorB-ColorBmag) 

		Random, RandR, ColorRmin, ColorRmax
		Random, RandG, ColorGmin, ColorGmax
		Random, RandB, ColorBmin, ColorBmax


		Random, RandA, 33, 55 											;Darken Some Color Patterns
		RandR := !mod(A_Index,3) ? RandR*RandA*0.01 : RandR
		,RandG := !mod(A_Index,3) ? RandG*RandA*0.01 : RandG
		,RandB := !mod(A_Index,3) ? RandB*RandA*0.01 : RandB


		if (SplashBool){
			Random, RandC, 30, 66
			RandB := RandG>=RandB ? Max(round(RandG*1.33), MaxColor) : RandB 			;Dont let Green over power Blue
			,RandG := RandG>=RandB*0.8 ? round(RandG*RandC*0.01) : RandG			;Dont let Green over power Blue
			,RandR := RandR>=RandB*0.8 ? round(RandR*RandC*0.01) : RandR			;Dont let Red over power Blue
		}


		SplashColors2[A_Index] := Dec2Hex(RandR) Dec2Hex(RandG) Dec2Hex(RandB)
		,SplashColorA := "0x" Dec2Hex(RandA1) Dec2Hex(RandR) Dec2Hex(RandG) Dec2Hex(RandB)

		Random, Rand, 1, % SplashPatternsArr.MaxIndex()
		Random, RandR, 0, 45
		Pattern := SplashPatternsArr[Rand]
		,SplashPatternsArr.Remove(Rand)

		,SplashBrush := Gdip_BrushCreateHatch(SplashColorA, "0x00000000", Pattern)
		,pBitmapTemp := Gdip_CreateBitmap(SplashR, SplashR)
		,GTemp := Gdip_GraphicsFromImage(pBitmapTemp), Gdip_SetSmoothingMode(GTemp, 4)
		;,Gdip_FillEllipse(GTemp, SplashBrush, 0, 0, SplashR, SplashR)
		Gdip_FillRectangle(GTemp, SplashBrush, 0, 0, SplashR, SplashR)
		,Gdip_DeleteBrush(SplashBrush)
		,Gdip_DrawImage(SplashGIcon, pBitmapTemp, 0, 0, IconW, IconW, 0, 0, SplashR, SplashR)
		,Gdip_DisposeImage(pBitmapTemp)
		,Gdip_DeleteGraphics(GTemp)

		,Gdip_TranslateWorldTransform(SplashGIcon, IconW*0.5, IconW*0.5)
		,Gdip_RotateWorldTransform(SplashGIcon, RandR)
		,Gdip_TranslateWorldTransform(SplashGIcon, -IconW*0.5, -IconW*0.5)

		
		Pattern := StrLen(Pattern)=1 ? "0" Pattern : Pattern
		if (DebugSplash){
			DebugSplashY := (A_Index-1)*22
			,DebugSplashInfo := A_Index " " Pattern ":" RegexReplace(SplashColorA, "0x") "-" RandR
			,DebugSplashInfo := !mod(A_Index,3) && SplashBool ? DebugSplashInfo "*" : DebugSplashInfo
			,Gdip_TextToGraphics(SplashGBig, DebugSplashInfo, "x" 0 " y" DebugSplashY " w" IconW " h" IconW " Bold cFF" substr(SplashColorA, 5) " s" 20, FontFace)
		}
		CurrentIndex := CurrentIndex+1>SplashColors.MaxIndex() ? 1 : CurrentIndex+1

	}
	SplashPatternsArr := "" 


	if (!ExtraFeatures){
		BackgroundSize := IconW*0.2
		;;Crop and make Background Image real quick
		pBitmapTemp := Gdip_CreateBitmap(BackgroundSize, BackgroundSize)
		,GTemp := Gdip_GraphicsFromImage(pBitmapTemp), Gdip_SetSmoothingMode(GTemp, 4)
		Loop, 9 {
			Gdip_TranslateWorldTransform(GTemp, BackgroundSize*0.5, BackgroundSize*0.5)
			,Gdip_RotateWorldTransform(GTris, 33)
			,Gdip_TranslateWorldTransform(GTemp, -BackgroundSize*0.5, -BackgroundSize*0.5)

			,Gdip_DrawImage(GTemp, SplashBitmapIcon, 0, 0, BackgroundSize, BackgroundSize, IconW*0.1, IconW*0.1, IconW*0.8, IconW*0.8)
		}
		if (OutputName="")
			BackgroundB64 := RegexReplace(Vis2.stdlib.Gdip_EncodeBitmapTo64string(pBitmapTemp, "PNG", 60), "\r?\n")
		else{
			Gdip_SaveBitmapToFile(pBitmapTemp, ImagesTempDir "\" OutputName "-background.png", 85)
			BackgroundB64 := ImagesTempDir "\" OutputName "-background.png"
		}

		Gdip_DisposeImage(pBitmapTemp)
		Gdip_DeleteGraphics(GTemp)
	}


	;Background Glow behing Main Splash Icon
	SplashBitmapIconGlow := Gdip_CreateBitmap(IconW, IconW), SplashGIconGlow := Gdip_GraphicsFromImage(SplashBitmapIconGlow), Gdip_SetSmoothingMode(SplashGIconGlow, 4)
	,RadialFadeScale := 0.444				;pi/255=0.01231997
	;,RandA1 := Max(floor((255/(SplashColors.MaxIndex()*pi))), 25)			;100
	,RandA1 := Max(floor((SplashColors.MaxIndex()*0.01231997)), 15)			;100
	,SplashR := floor(IconW*0.32)

	Loop % SplashColors2.MaxIndex() {
		SplashColorA := "0x00" SplashColors2[A_Index]
		SplashColorB := "0x" Dec2Hex(RandA1) SplashColors2[A_Index]

		,PPathCurrent := Gdip_CreatePath(SplashGIconGlow)
		,PathPoints := ""
		,CurrentAngle := 0
		Random, AngleInc, 5, 20
		While (CurrentAngle+AngleInc<360)				
		{			
			Random, AngleRand1, -30, 30
			Random, AngleRand2, -30, 30
			PathCurrentX := floor(IconW*0.5+0.18*SplashR*sin(AngleRand1*0.01745329)+SplashR*sin((CurrentAngle + AngleInc)*0.01745329))
			,PathCurrentY := floor(IconW*0.5+0.18*SplashR*sin(AngleRand2*0.01745329)+SplashR*cos((CurrentAngle + AngleInc)*0.01745329))
			,CurrentAngle := CurrentAngle + AngleInc
			,PathPoints := PathPoints "|" PathCurrentX "," PathCurrentY
		}
		Gdip_AddPathPolygon(PPathCurrent, substr(PathPoints, 2)), PathPoints := ""

		,DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", "Ptr", PPathCurrent, "PtrP", SplashBrush)
		VarSetCapacity(POINT, 8),	NumPut(IconW*0.5, POINT, 0, "Float"),	NumPut(IconW*0.5, POINT, 4, "Float")
		,DllCall("Gdiplus.dll\GdipSetPathGradientCenterPoint", "Ptr", SplashBrush, "Ptr", &POINT)
		,DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", "Ptr", SplashBrush, "UInt", SplashColorB), POINT := ""
		,VarSetCapacity(COLOR, 4, 0)
		,NumPut(SplashColorA, COLOR, 0, "UInt"), COLORS := 1
		,DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", "Ptr", SplashBrush, "Ptr", &Color, "IntP", COLORS)
		,DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", SplashBrush, "Float", RadialFadeScale, "Float", RadialFadeScale)
	
		,Gdip_FillPath(SplashGIconGlow, SplashBrush, PPathCurrent)
		,Gdip_DeletePath(PPathCurrent)
		,Gdip_DeleteBrush(SplashBrush)
	}

	;;;;;Draw BACKGROUND GLOW...Later for glow to be ABOVE tris



	

	if (ExtraFeatures){
		;;;;Highlight Glow on Icon
		RadialFadeScale := 0.05
		,SplashR := round(IconW*0.125)
		,SplashColorA := "0x00000000"
		,SplashColorB := "0x33FFFFFF" 

		,PPathCurrent := Gdip_CreatePath(SplashBitmapBig)
		,PathPoints := ""

		,CurrentAngle := 0
		;Random, AngleInc, 5, 15
		AngleInc := 20

		; pi / 180 = 0.01745329
		While (CurrentAngle+AngleInc<360)			
		{			
			Random, AngleRand1, -30, 30
			Random, AngleRand2, -30, 30
			PathCurrentX := floor(IconW*0.5+0.15*SplashR*sin(AngleRand1*0.01745329)+SplashR*sin((CurrentAngle + AngleInc)*0.01745329))
			,PathCurrentY := floor(IconW*0.5+0.15*SplashR*sin(AngleRand2*0.01745329)+SplashR*cos((CurrentAngle + AngleInc)*0.01745329))
			,CurrentAngle := CurrentAngle + AngleInc
			,PathPoints := PathPoints "|" PathCurrentX "," PathCurrentY
		}
		Gdip_AddPathPolygon(PPathCurrent, substr(PathPoints, 2)), PathPoints := ""
		,DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", "Ptr", PPathCurrent, "PtrP", SplashBrush)
		VarSetCapacity(POINT, 8),	NumPut(IconW*0.5, POINT, 0, "Float"),	NumPut(IconW*0.5, POINT, 4, "Float")
		,DllCall("Gdiplus.dll\GdipSetPathGradientCenterPoint", "Ptr", SplashBrush, "Ptr", &POINT)
		,DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", "Ptr", SplashBrush, "UInt", SplashColorB), POINT := ""
		,VarSetCapacity(COLOR, 4, 0)
		,NumPut(SplashColorA, COLOR, 0, "UInt"), COLORS := 1
		,DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", "Ptr", SplashBrush, "Ptr", &Color, "IntP", COLORS)
		,DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", SplashBrush, "Float", RadialFadeScale, "Float", RadialFadeScale)

		,Gdip_FillPath(SplashGBig, SplashBrush, PPathCurrent)
		,Gdip_DeletePath(PPathCurrent)
		,Gdip_DeleteBrush(SplashBrush)
	
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		SplashR := IconW*0.3636
		;;;;;;;;;;;;;;;This is Triangles around center
		SplashBitmapTris := Gdip_CreateBitmap(IconW, IconW), GTris := Gdip_GraphicsFromImage(SplashBitmapTris), Gdip_SetSmoothingMode(GTris, 4)
		Loop, 3
		{
			TriColor := A_Index=1 ? IconColors[3] : A_Index=2 ? IconColors[2] : IconColors[1]
			;TriColor := A_Index=1 ? SplashColors[3] : A_Index=2 ? SplashColors[2] : SplashColors[1]

			;TempR := Dec2Hex(Min(Hex2Dec(substr(TriColor, 1, 2)),255))
			;TempG := Dec2Hex(Min(Hex2Dec(substr(TriColor, 3, 2)),255))
			;TempB := Dec2Hex(Min(Hex2Dec(substr(TriColor, 5, 2)),255))

			,TriColor1 := "0xFF" TriColor
			,TriColor2 := "0x26" TriColor
			;,TriColor2 := "0xFF" TriColor

			;,TriColor1 := "0xff00ffff"
			;,TriColor2 := "0xff00ff00"

			,TempR := Dec2Hex(Max(Hex2Dec(substr(TriColor, 1, 2))-175,0))
			,TempG := Dec2Hex(Max(Hex2Dec(substr(TriColor, 3, 2))-175,0))
			,TempB := Dec2Hex(Max(Hex2Dec(substr(TriColor, 5, 2))-175,0))

			,TriColor3 := "0xFF" TempR TempG TempB
			,TriColor3 := "0x00" TempR TempG TempB
			;,TriColor3 := "0x00ffff00"

			;Triangle Background Glow
			RadialFadeScale := 0.3
			,PPathCurrent := Gdip_CreatePath(GTris)
			,Gdip_AddPathPolygon(PPathCurrent, Poly6), PathPoints := ""
			,DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", "Ptr", PPathCurrent, "PtrP", SplashBrush)
			VarSetCapacity(POINT, 8),	NumPut((IconW*0.5), POINT, 0, "Float"),	NumPut((IconW*0.5)-SplashR, POINT, 4, "Float")
			,DllCall("Gdiplus.dll\GdipSetPathGradientCenterPoint", "Ptr", SplashBrush, "Ptr", &POINT)
			,DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", "Ptr", SplashBrush, "UInt", TriColor2), POINT := ""
			,VarSetCapacity(COLOR, 4, 0)
			,NumPut("0x00000000", COLOR, 0, "UInt"), COLORS := 1
			,DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", "Ptr", SplashBrush, "Ptr", &Color, "IntP", COLORS)
			,DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", SplashBrush, "Float", RadialFadeScale, "Float", RadialFadeScale)
			,Gdip_FillPath(GTris, SplashBrush, PPathCurrent)
			,Gdip_DeleteBrush(SplashBrush)
			,Gdip_DeletePath(PPathCurrent)



			;Triangle Main little edge fade
			RadialFadeScale := 0.55
			;RadialFadeScale := 5.5
			,PPathCurrent := Gdip_CreatePath(GTris)
			,Gdip_AddPathPolygon(PPathCurrent, Poly4), PathPoints := ""
			,DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", "Ptr", PPathCurrent, "PtrP", SplashBrush)
			VarSetCapacity(POINT, 8),	NumPut((IconW*0.5), POINT, 0, "Float"),	NumPut((IconW*0.5)-SplashR, POINT, 4, "Float")
			,DllCall("Gdiplus.dll\GdipSetPathGradientCenterPoint", "Ptr", SplashBrush, "Ptr", &POINT)
			,DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", "Ptr", SplashBrush, "UInt", TriColor1), POINT := ""
			,VarSetCapacity(COLOR, 4, 0)
			,NumPut(TriColor3, COLOR, 0, "UInt"), COLORS := 1
			,DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", "Ptr", SplashBrush, "Ptr", &Color, "IntP", COLORS)
			,DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", SplashBrush, "Float", RadialFadeScale, "Float", RadialFadeScale)
			,Gdip_FillPath(GTris, SplashBrush, PPathCurrent)
			,Gdip_DeleteBrush(SplashBrush)
			,Gdip_DeletePath(PPathCurrent)


			SplashBrush := Gdip_BrushCreateHatch("0xFFFFFFFF", "0xFF000000", 10)
			,ImageWidth2 := round(IconW*0.125)
			,pBitmapTemp := Gdip_CreateBitmap(ImageWidth2, ImageWidth2)
			,GTemp := Gdip_GraphicsFromImage(pBitmapTemp), Gdip_SetSmoothingMode(GTemp, 4)
			,Gdip_FillRectangle(GTemp, SplashBrush, 0, 0, ImageWidth2, ImageWidth2)
			,Gdip_DeleteBrush(SplashBrush)

			,pBitmapTemp2 := Gdip_CreateBitmap(IconW, IconW)
			,GTemp2 := Gdip_GraphicsFromImage(pBitmapTemp2), Gdip_SetSmoothingMode(GTemp2, 4)

			,Gdip_DrawImage(GTemp2, pBitmapTemp, 0, 0, IconW, IconW, 0, 0, ImageWidth2, ImageWidth2)
			,Gdip_DisposeImage(pBitmapTemp)
			,Gdip_DeleteGraphics(GTemp)

			,pBitmapTempMask := Gdip_CreateBitmap(IconW, IconW)
			,GTempMask := Gdip_GraphicsFromImage(pBitmapTempMask), Gdip_SetSmoothingMode(GTempMask, 4)
			,SplashBrush := Gdip_BrushCreateSolid("0x0A00FF00")
			,Gdip_FillPolygon(GTempMask, SplashBrush, Poly4)
			,Gdip_DeleteBrush(SplashBrush)



			pBitmapNewTriangle := Gdip_AlphaMask(pBitmapTemp2, pBitmapTempMask, 0, 0, 0)			;Both need to be same dimensions - YES

			,Gdip_DisposeImage(pBitmapTemp2)
			,Gdip_DeleteGraphics(GTemp2)
			,Gdip_DisposeImage(pBitmapTempMask)
			,Gdip_DeleteGraphics(GTempMask)

			,Gdip_DrawImage(GTris, pBitmapNewTriangle)
			,Gdip_DisposeImage(pBitmapNewTriangle)

			,Gdip_TranslateWorldTransform(GTris, IconW*0.5, IconW*0.5)
			,Gdip_RotateWorldTransform(GTris, 120)
			,Gdip_TranslateWorldTransform(GTris, -IconW*0.5, -IconW*0.5)
		}

		;Gdip_SaveBitmapToFile(SplashBitmapTris, RegexReplace(SplashImagePath, "\.png", "-Tris.png"), 100) ;Save Tris for Test

		Gdip_DrawImage(SplashGBig, SplashBitmapTris, 0, 0, IconW, IconW, 0, 0, IconW, IconW)
		,Gdip_DeleteGraphics(GTris)
		,Gdip_DisposeImage(SplashBitmapTris)
	}




	;;;;;Apply Alpha Mask to ICON
	pBitmapMaskedIcon := Gdip_AlphaMask(SplashBitmapIcon, SplashBitmapMask, 0, 0, 0)
	,Gdip_DeleteGraphics(SplashGIcon)
	,Gdip_DisposeImage(SplashBitmapIcon)
	
	,Gdip_DeleteGraphics(SplashGMask)
	,Gdip_DisposeImage(SplashBitmapMask)


	Matrix = 
	(
	0|0|0|0|0|
	0|1|0|0|0|
	0|0|0|0|0|
	0|0|0|0.5|0|
	0|0|0|0|0
	)

	if (!ExtraFeatures){
		;IconSimpleW := round(IconW*0.3636)
		IconSimpleW := round(IconW*0.333)
		,IconSimpleX := round(IconW/2-IconSimpleW/2)
		,IconSimpleY := round(IconW/2-IconSimpleW/2)

		,IconSimpleW2 := round(IconW*0.6363)
		,IconSimpleX2 := round(IconW/2-IconSimpleW2/2)
		,IconSimpleY2 := round(IconW/2-IconSimpleW2/2)

		;This is for Simple mini Icon...Then add triangles and highlight after
		NewSize := 64
		SplashBitmapSimple := Gdip_CreateBitmap(NewSize, NewSize), GSimple := Gdip_GraphicsFromImage(SplashBitmapSimple), Gdip_SetSmoothingMode(GSimple, 4)
		;,Gdip_DrawImage(GSimple, SplashBitmapIconGlow, 0, 0, NewSize, NewSize, IconSimpleX2, IconSimpleY2, IconSimpleW2, IconSimpleW2, Matrix)
		,Gdip_DrawImage(GSimple, pBitmapMaskedIcon, 0, 0, NewSize, NewSize, IconSimpleX, IconSimpleY, IconSimpleW, IconSimpleW)
		;Gdip_SaveBitmapToFile(SplashBitmapIcon, RegexReplace(SplashImagePath, "\.png", "-MaskedIcon.png"), 100) ;Save Tris for Test

		if (OutputName="")
			IconB64 := RegexReplace(Vis2.stdlib.Gdip_EncodeBitmapTo64string(SplashBitmapSimple, "PNG", 50), "\r?\n")
		else{
			Gdip_SaveBitmapToFile(SplashBitmapSimple, ImagesTempDir "\" OutputName "-icon.png", 80)
			IconB64 := ImagesTempDir "\" OutputName "-icon.png"
		}
		

		Gdip_DeleteGraphics(GSimple)
		Gdip_DisposeImage(SplashBitmapSimple)
	}


	;;;Do Draws for Big Icon if needed, then clean up
	if (ExtraFeatures){
		Gdip_DrawImage(SplashGBig, SplashBitmapIconGlow)
		Gdip_DrawImage(SplashGBig, pBitmapMaskedIcon)
		Gdip_SaveBitmapToFile(SplashBitmapBig, SplashImagePath, 100)
	}
	Gdip_DeleteGraphics(SplashGIconGlow)
	,Gdip_DisposeImage(SplashBitmapIconGlow)
	,Gdip_DisposeImage(pBitmapMaskedIcon)
	,Gdip_DeleteGraphics(SplashGBig)
	,Gdip_DisposeImage(SplashBitmapBig)
	
	FinishTime := round((A_TickCount - StartTime))			;170ms
	;Tooltip, %FinishTime%ms

	return
}

ConvertICO(ImagePath) {
	FilePath := A_ScriptDir "\Ark-AIO.ico"

	ImageArray := []
	ImageArray[1] := [ImagePath, 32, 32]
	;ImageArray[1] := [ImagePath, 64, 64]
	;,ImageArray[2] := [ImagePath, 32, 32]
	;,ImageArray[3] := [ImagePath, 16, 16]
	,ICO_ContainerSize := 16
	, O := 0
	, Total_PotentialSize := 6
	;, pToken := Gdip_Startup()
	;,OutFileName := ImageArray[1][1]
	;,OutFileName := RegExReplace(OutFileName, ".*\\")
	;,OutFileName := RegexReplace(OutFileName,"(png|jpeg|jpg|gif)$","ico")	
	;Tooltip, Test`n%OutFileName%

	; Convert Images
	for i, img in ImageArray {
		pBitmapFile := Gdip_CreateBitmapFromFile(img[1])							; Get a bitmap of the file to convert
		, pBitmap := Gdip_CreateBitmap(img[2], img[3])								; Create a new bitmap of the desired width/heigh
		, G := Gdip_GraphicsFromImage(pBitmap)                                  	; Get a pointer to the graphics of the bitmap
		, Gdip_SetSmoothingMode(G, 4)												; Set image quality modes
		, Gdip_SetInterpolationMode(G, 7)
		, Gdip_DrawImage(G, pBitmapFile, 0, 0, img[2], img[3])            		 	; Draw the original image onto the new bitmap
		, Gdip_DisposeImage(pBitmapFile)                                        	; Delete the bitmap of the original image
		, Gdip_SaveBitmapToFile(pBitmap, A_ScriptDir "\TempResized" i ".png")       ; Save the new bitmap to file
		, Gdip_DisposeImage(pBitmap)                                            	; Delete the new bitmap
		, Gdip_DeleteGraphics(G)                                               		; The graphics may now be deleted
		, img[1] := A_ScriptDir "\TempResized" i ".png"
		FileGetSize, ImgSize, % img[1]
		if (ImgSize)
			Total_PotentialSize += ICO_ContainerSize + ImgSize
	}

	VarSetCapacity(ICO_Data, Total_PotentialSize, 0)
	, NumPut(0, ICO_Data, O, "UShort"), O += 2 ;reserved - always 0
	, NumPut(1, ICO_Data, O, "UShort"), O += 2 ;ico = 1, cur = 2
	, NumPut(0, ICO_Data, O, "UShort"), O += 2 ;number of images in file
	
	for i, img in ImageArray {
		if (img[2] < 257 && img[3] < 257 && File := FileOpen(img[1], "r")) {
			NumPut(img[2], ICO_Data, O, "UChar"), O += 1 ;image width: 256 = 0
			, NumPut(img[3], ICO_Data, O, "UChar"), O += 1 ;image height: 256 = 0
			, NumPut(0, ICO_Data, O, "UChar"), O += 1 ;color palatte: 0 if not used
			, NumPut(0, ICO_Data, O, "UChar"), O += 1 ;reserved - always 0
			, NumPut(0, ICO_Data, O, "UShort"), O += 2 ;ico - color planes (0/1), cur - horizontal coordinates of the hotspot in pixels from left
			, NumPut(32, ICO_Data, O, "UShort"), O += 2 ;ico - bits per pixel, cur - vertical coordinates of hotspot in pixels from top
			, NumPut(File.Length, ICO_Data, O, "UInt"), O += 4 ;Size of image data in bytes
			, NumPut(O + 4, ICO_Data, O, "UInt"), O += 4 ;Offset of image data from begining of ico/cur file
			, File.RawRead(&ICO_Data + O, File.Length)
			, O += File.Length
			, NumPut(NumGet(ICO_Data, 4, "UShort") + 1, ICO_Data, 4, "UShort") ;Adds one to the total number of images
			, File.Close()
		}
		FileDelete, % img[1]
	}

	

	If (O > 6){
		File := FileOpen(FilePath, "w")
		, File.RawWrite(&ICO_Data, O)
		, File.Close()
		, VarSetCapacity(ICO_Data, O, 0)
		, VarSetCapacity(ICO_Data, 0)
	}

	ImageArray := ""
	;Gdip_Shutdown(pToken)
	return
}


GdipCreateFromBase64(B64) {
	VarSetCapacity(B64Len, 0)
	DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", StrLen(B64), "UInt", 0x01, "Ptr", 0, "UIntP", B64Len, "Ptr", 0, "Ptr", 0)
	VarSetCapacity(B64Dec, B64Len, 0) ; pbBinary size
	DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", StrLen(B64), "UInt", 0x01, "Ptr", &B64Dec, "UIntP", B64Len, "Ptr", 0, "Ptr", 0)
	pStream := DllCall("Shlwapi.dll\SHCreateMemStream", "Ptr", &B64Dec, "UInt", B64Len, "UPtr")
	VarSetCapacity(pBitmap, 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStreamICM", "Ptr", pStream, "PtrP", pBitmap)

	ObjRelease(pStream)
	return pBitmap
}


SetClipboardData(nFormat, hBitmap){
	DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
	hDBI :=	DllCall("GlobalAlloc", "Uint", 2, "Uint", 40+NumGet(oi,44))
	pDBI :=	DllCall("GlobalLock", "Uint", hDBI)
	DllCall("RtlMoveMemory", "Uint", pDBI, "Uint", &oi+24, "Uint", 40)
	DllCall("RtlMoveMemory", "Uint", pDBI+40, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44))
	DllCall("GlobalUnlock", "Uint", hDBI)
	DllCall("OpenClipboard", "Uint", 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "Uint", nFormat, "Uint", hDBI)

	return
}




BloodPackHotkeyFunction:
	ToggleKey := BloodPackHotkey
	if (BloodPackCheck){
		if (BloodPackEnabled){
			BloodPackEnabled := 0
		}else{
			ReplenishReadyTime := A_Now
			BloodPackEnabled := 1
		}
	}else{
		BloodPackEnabled := 0
	}
return



FishingHotkeyFunction:
	ToggleKey := FishingHotkey
	if (FishingCheck)
		FishingEnabled := FishingEnabled ? 0 : 1
	else
		FishingEnabled := 0
return

FishingLoop:
	if (FishingEnabled){
		if (WinsActive() && !CheckInv()){
			;;Auto Recast Rod
			PixelSearch, RecastPx, RecastPy, 0, 0, A_ScreenWidth/4, A_ScreenHeight/4, 0x7FFD03, 3, Fast ;
	       	if (( RecastPx && RecastPy ) && FishingEnabled && WinsActive()){
	    		FishingDispStr := "Waiting to Cast"
	        	Sleep, 2100
	        	MouseClick, left
	    	}
		    
			;;A
			PixelSearch Px, Py, 1162, 970, 1162, 970, FishingColor, 3, Fast
			if (( Px && Py ) && FishingEnabled && WinsActive()){	
				FishingDispStr := "Press A"
				Send, a
				Sleep, FishingSpeed
			}

			;;z
			PixelSearch Px, Py, 1158, 973, 1158, 973, FishingColor, 3, Fast
			if (( Px && Py ) && FishingEnabled && WinsActive()){	
				FishingDispStr := "Press Z"
				Send, z
				Sleep, FishingSpeed
			}

			;;q
			PixelSearch Px, Py, 1181, 1016, 1181, 1016, FishingColor, 3, Fast
			if (( Px && Py ) && FishingEnabled && WinsActive()){	
				FishingDispStr := "Press Q"
				Send, q
				Sleep, FishingSpeed
			}

			;;w
			PixelSearch Px, Py, 1113, 868, 1113, 868, FishingColor, 3, Fast
			if (( Px && Py ) && FishingEnabled && WinsActive()){	
				FishingDispStr := "Press W"
				Send, w
				Sleep, FishingSpeed
			}
				
			;;x
			PixelSearch Px, Py, 1167, 972, 1167, 972, FishingColor, 3, Fast
			if (( Px && Py ) && FishingEnabled && WinsActive()){	
				FishingDispStr := "Press X"
				Send, x
				Sleep, FishingSpeed
			}

			;;d
			PixelSearch Px, Py, 1192, 906, 1192, 906, FishingColor, 3, Fast
			if (( Px && Py ) && FishingEnabled && WinsActive()){	
				FishingDispStr := "Press D"
				Send, d
				Sleep, FishingSpeed
			}


			;;BEGIN PROCESS OF ELIMINATION TO FIND E, S, C
				
			;;E
			PixelSearch Px, Py, 1186, 998, 1186, 998, FishingColor, 3, Fast 
			PixelSearch PxA, PyA, 1162, 970, 1162, 970, FishingColor, 3, Fast	;;a
			PixelSearch PxZ, PyZ, 1158, 973, 1158, 973, FishingColor, 3, Fast	;;z
			PixelSearch PxW, PyW, 1113, 868, 1113, 868, FishingColor, 3, Fast	;;w
			PixelSearch PxX, PyX, 1167, 972, 1167, 972, FishingColor, 3, Fast	;;x
			PixelSearch PxD, PyD, 1192, 906, 1192, 906, FishingColor, 3, Fast	;;d

			if (( Px && Py ) && (!PxA && !PyA) && (!PxZ && !PyZ) && (!PxW && !PyW) && (!PxX && !PyX) && (!PxD && !PyD) && FishingEnabled && WinsActive()) {
				FishingDispStr := "Press E"
				Send, e
				Sleep, FishingSpeed
			}

			;;S
			PixelSearch Px, Py, 1161, 917, 1161, 917, FishingColor, 3, Fast 
			PixelSearch PxZ, PyZ, 1158, 973, 1158, 973, FishingColor, 3, Fast	;;z
			PixelSearch PxW, PyW, 1113, 868, 1113, 868, FishingColor, 3, Fast	;;w
			PixelSearch PxX, PyX, 1167, 972, 1167, 972, FishingColor, 3, Fast	;;x


			if (( Px && Py ) && (!PxZ && !PyZ) && (!PxW && !PyW) && (!PxX && !PyX) && FishingEnabled && WinsActive()) {
				FishingDispStr := "Press S"
				Send, s
				Sleep, FishingSpeed
			}

			;;C
			PixelSearch Px, Py, 1135, 918, 1135, 918, FishingColor, 3, Fast
			PixelSearch PxQ, PyQ, 1181, 1016, 1181, 1016, FishingColor, 3, Fast ;;q
			PixelSearch PxD, PyD, 1192, 906, 1192, 906, FishingColor, 3, Fast	;;d

			if (( Px && Py )  && (!PxQ && !PyQ) && (!PxD && !PyD) && FishingEnabled && WinsActive()) {
				FishingDispStr := "Press C"
				Send, c
				Sleep, FishingSpeed
			}
			FishingDispStr := "Waiting to Catch a Fish"
		}
	}
return

CheckForUpdate:
	;reqUpdate := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	;reqUpdate.Option(4) := 0x0100  + 0x0200 + 0x1000 + 0x2000
	
/*

Microsoft.XMLHTTP
Msxml2.ServerXMLHTTP
Msxml2.ServerXMLHTTP.3.0
Msxml2.ServerXMLHTTP.6.0
MSXML2.XMLHTTP.3.0
MSXML2.XMLHTTP.6.0

*/
	;reqUpdate := ComObjCreate("Msxml2.XMLHTTP.6.0")
	reqUpdate := ComObjCreate("Msxml2.ServerXMLHTTP.6.0")
	reqUpdate.Open("GET", "https://raw.githubusercontent.com/arodbusiness/Ark-AIO-V2/master/version.txt?abc=" A_Now, 0)

	reqUpdate.SetRequestHeader("Pragma", "no-cache")
	reqUpdate.SetRequestHeader("Cache-Control", "no-cache, no-store")
	reqUpdate.SetRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT")

	reqUpdate.onreadystatechange := Func("CheckForUpdateWait").bind(reqUpdate)
	reqUpdate.Send()
return


CheckForUpdateWait(reqUpdate) {
    if (reqUpdate.readyState != 4){
    	  ; Not done yet.
        return
    }else if (reqUpdate.status == 200){ ; OK.
    	GoSub, CheckForUpdateReady
    }
}
return

CheckForUpdateReady:
	if (RegexMatch(reqUpdate.responseText, "i)error_500|500 Error")){
		MsgBox2("Error aquiring latest version.`n500 Internal Server Error.`nPlease try again later.", "0 r3")
		Clipboard := reqUpdate.responseText
	}else{
		if (RegExMatch(reqUpdate.responseText, "([0-9.]{1,})", MatchVer)){
			LatestVer := round(MatchVer1,2)
			if (LatestVer>CurrentVer){
				RetVal := MsgBox2("There is an Update Available`nCurrent Version: " CurrentVer "`nLatest Version: " LatestVer "`nWould you like to Update Now?", "2 r3")
				;IfMsgBox Yes{
				if (RetVal){
					Run, %A_ScriptDir%\Ark-AIO-Updater.exe
					ExitApp
				}else{
				    ;;Just Continue...
				}
			}else if(!InitialUpdateCheck){
				MsgBox2("Ark AIO is up to date.`nCurrent Version: " CurrentVer "/" LatestVer, "0 r2")
			}
		}else{
			MsgBox2("Error aquiring latest version.`nPlease try again later.", "0 r2")
			Clipboard := reqUpdate.responseText
		}
	}
return


MsgBox2(Message, Options := 0){
	if (!ShowingMsgBox){
		global ShowingMsgBox := 1
		global SplashImageSimpleB64
		static MsgIcon, MsgCloseButton, MsgOKButton, MsgCancelButton

		MsgBoxW := 400
		;MsgBoxH := 200
		,ButtonW := 28
		,ButtonW2 := 100
		,FontSize := 11
		


		Gui, 3: +hwndMsgBoxhwnd +ToolWindow +AlwaysOnTop
		Gui, 3:Font, s14 bold cFFFFFF, %FontFace% 	;Font Color asdf
		Gui, 3:Color, 000000 			;Background Color


		Margin := 4
		MsgBoxX := MsgBoxY2 := Margin
		Gui, 3:Add, Picture, x%MsgBoxX% y%MsgBoxY2% w%ButtonW% h%ButtonW% vMsgIcon 0xE, 
		GuiControlGet, Pos, 3:Pos, MsgIcon
		GuiControlGet, hwnd, 3:hwnd, MsgIcon
		MsgIconBitmap := GdipCreateFromBase64(SplashImageSimpleB64)
		pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_SetSmoothingMode(G,4), Gdip_SetInterpolationMode(G, 7)
		Gdip_DrawImage(G, MsgIconBitmap, -3, -3, PosW, PosH)
		hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
		DeleteObject(hBitmap)
		Gdip_DisposeImage(MsgIconBitmap)
		Gdip_DeleteGraphics(G)
		DeleteObject(hBitmap)
		Gdip_DisposeImage(pBitmap)


		MsgBoxX := MsgBoxX + ButtonW + Margin*2
		Gui, 3:Add, Text, x%MsgBoxX% y%MsgBoxY2%, Ark AIO

		MsgBoxX := MsgBoxW - ButtonW + Margin
		Gui, 3:Add, Picture, x%MsgBoxX% y%MsgBoxY2% w%ButtonW% h%ButtonW% vMsgCloseButton gMsgBoxClose BackgroundTrans 0xE,
		GuiControlGet, Pos, 3:Pos, MsgCloseButton
		GuiControlGet, hwnd, 3:hwnd, MsgCloseButton 
		pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_SetSmoothingMode(G,4), Gdip_SetInterpolationMode(G, 7)
		pPenMsgBox:=Gdip_CreatePen("0xFFFFFFFF", 3)
		;pPenMsgBox2:=Gdip_CreatePen("0xFFFFFFFF", 2)
		;Gdip_DrawRectangle(G, pPenMsgBox2, 0, 0, PosW, PosH)
		Gdip_DrawLines(G, pPenMsgBox, 0.2*PosW "," 0.2*PosH "|" 0.8*PosW "," 0.8*PosH)
		Gdip_DrawLines(G, pPenMsgBox, 0.2*PosW "," 0.8*PosH "|" 0.8*PosW "," 0.2*PosH)
		hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap) ; this stays fine when windows messes up??

		;Gdip_DeletePen(pPenMsgBox2)
		Gdip_DeleteGraphics(G)
		DeleteObject(hBitmap)
		Gdip_DisposeImage(pBitmap)

		center := RegexMatch(Options, "center") ? "center" : ""
		MsgBoxY2 := MsgBoxY2 + ButtonW
		MsgBoxW2 := MsgBoxW-Margin*2

		rows := RegexMatch(Options, "r([0-9]{1,})", Match) ? Match1 : 1
		MsgBoxH2 := rows*(FontSize+5)
		Gui, 3:Font, s%FontSize% cFFFFFF, %FontFace% 	;Font Color
		Gui, 3:Add, Text, x4 y%MsgBoxY2% w%MsgBoxW2% h%MsgBoxH2% %center%, %Message%


		MsgBoxY2 := MsgBoxY2 + MsgBoxH2 + Margin*2

		if (RegexMatch(Options, "0")){				;OK
			MsgBoxX := MsgBoxW - ButtonW2
			Gui, 3:Add, Picture, x%MsgBoxX% y%MsgBoxY2% w%ButtonW2% h%ButtonW% vMsgOKButton gMsgBoxOK BackgroundTrans 0xE,
			GuiControlGet, Pos, 3:Pos, MsgOKButton
			GuiControlGet, hwnd, 3:hwnd, MsgOKButton 
			pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
			Gdip_SetSmoothingMode(G,4), Gdip_SetInterpolationMode(G, 7)
			pPenMsgBox:=Gdip_CreatePen("0xFFFFFFFF", 3)
			Gdip_DrawRectangle(G, pPenMsgBox, 0, 0, PosW, PosH)
			Gdip_TextToGraphics(G, "OK", "x" 0 " y" 0 " w" ButtonW2 " h" ButtonW " Center vCenter Bold cFFFFFFFF s" 14, FontFace)
			hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
			Gdip_DeleteGraphics(G)
			Gdip_DisposeImage(pBitmap)
			DeleteObject(hBitmap)
			
		}else{
			MsgBoxX := MsgBoxW/2 - ButtonW2 - Margin 
			Gui, 3:Add, Picture, x%MsgBoxX% y%MsgBoxY2% w%ButtonW2% h%ButtonW% vMsgOKButton gMsgBoxOK BackgroundTrans 0xE,
			GuiControlGet, Pos, 3:Pos, MsgOKButton
			GuiControlGet, hwnd, 3:hwnd, MsgOKButton 
			pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
			Gdip_SetSmoothingMode(G,4), Gdip_SetInterpolationMode(G, 7)
			Gdip_DrawRectangle(G, pPenMsgBox, 0, 0, PosW-1, PosH-1)
			Gdip_TextToGraphics(G, RegexMatch(Options, "1") ? "Ok" : "Yes", "x" 0 " y" 0 " w" ButtonW2 " h" ButtonW " Center vCenter Bold cFFFFFFFF s" 14, FontFace)
			hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
			
			Gdip_DeleteGraphics(G)
			Gdip_DisposeImage(pBitmap)
			DeleteObject(hBitmap)
			

			MsgBoxX := MsgBoxW/2 + Margin
			Gui, 3:Add, Picture, x%MsgBoxX% y%MsgBoxY2% w%ButtonW2% h%ButtonW% vMsgCancelButton gMsgBoxClose BackgroundTrans 0xE,
			GuiControlGet, Pos, 3:Pos, MsgCancelButton
			GuiControlGet, hwnd, 3:hwnd, MsgCancelButton 
			pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
			Gdip_SetSmoothingMode(G,4), Gdip_SetInterpolationMode(G, 7)
			Gdip_DrawRectangle(G, pPenMsgBox, 0, 0, PosW-1, PosH-1)
			Gdip_TextToGraphics(G, RegexMatch(Options, "1") ? "Cancel" : "No", "x" 0 " y" 0 " w" ButtonW2 " h" ButtonW " Center vCenter Bold cFFFFFFFF s" 14, FontFace)
			hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
			
			Gdip_DeleteGraphics(G)
			Gdip_DisposeImage(pBitmap)
			DeleteObject(hBitmap)
			
		}
		Gdip_DeletePen(pPenMsgBox)
		MsgBoxH := MsgBoxY2 + Margin
		;Gui, 3:Show, X%WindowX% Y%WindowY% W%WindowW% H%WindowH2%, Ark AIO  
		Gui, 3:Show, w%MsgBoxW% h%MsgBoxH%, Ark AIO  
	}Else{
		WinActive("ahk_id " MsgBoxhwnd)
		return
	}

	While (WinExist("ahk_id " MsgBoxhwnd))
	{
		;Tooltip, Waiting to return?
		Sleep, 50								;CPU usage...
	}
	return MsgBoxRetVal


}

MsgBoxClose:
	Gui, 3:Destroy
	global MsgBoxRetVal := 0
	global ShowingMsgBox := 0
return

MsgBoxOK:
	Gui, 3:Destroy
	global MsgBoxRetVal := 1
	global ShowingMsgBox := 0
return





ECHotkeyFunction:
	if (!ECcheck && WinsActive() && CheckInv()){
		ECcheck :=  1
		Goto, ECfunction
	}else{
		ECcheck :=  0
		Gui, 2:Destroy
		DisplayingMessage := 0

		TSTText := ""
		TSTEnabled := 0

		GoSub, TST_Off
	}
return



ECfunction:
	SoundBeep
	;Arkhwnd := WinsActive()
	if (WinsActive() && CheckInv() && ECcheck){

		ECLocW := 42
		ECLocH := 30
		UpdatePixelLoc("ECLoc", "Click near the top left corner of the desired stat number.", ECLocX, ECLocY,,,, 1, ECLocW, ECLocH)


		MouseClick, Left, TheirTransferSlotX, TheirTransferSlotY, 2, 3
		Sleep 250

		While (WinsActive() && CheckInv() && ECcheck){
			TSTText := ECHotkey " Egger: Next Egg..."
			GoSub, TST_Update


			MouseClick, Left, YourTransferSlotX, YourTransferSlotY, 2, 3
			Sleep 600

			CapturedIncbitmap := Gdip_BitmapFromHWND(WinsActive())
			CapturedIncbitmap2 := Gdip_CloneBitmapArea(CapturedIncbitmap, ECLocX, ECLocY, ECLocW, ECLocH)
			;Gdip_SaveBitmapToFile(CapturedIncbitmap2, "test.jpg", 100)
			Gdip_DisposeImage(CapturedIncbitmap)

			;Vis2.Tesseract.setVariable("tessedit_char_whitelist","ABCDEFGHIJKLMNOPQRSTUVWXYZ")


			StatValue := OCR(CapturedIncbitmap2)
			StatValue := StatValue="" ? 0 : StatValue
			StatValue := RegexReplace(StatValue, "'|_|\/| |\||\]|\.|\,")
			StatValue := RegexReplace(StatValue, "i)o", "0")


			;Gdip_DeleteGraphics(GInc)
			Gdip_DisposeImage(CapturedIncbitmap2)

			if (WinsActive() && CheckInv() && ECcheck)
				MouseClick, Left, TheirTransferSlotX, TheirTransferSlotY, 1, 3


			if (StatValue>ECCurrentVal && StatValue!="" && RegexMatch(StatValue, "^[0-9]{1,3}$")){
				TSTText := ECHotkey " Egger: Mutation?! " StatValue ">" ECCurrentVal
				GoSub, TST_Update


				ECcheck := 0
				;;DO SOMETHING TO SAVE EGG
			}else if (StatValue<=ECCurrentVal && StatValue!="" && RegexMatch(StatValue, "^[0-9]{1,3}$")){
				TSTText := ECHotkey " Egger: " StatValue "<=" ECCurrentVal
				GoSub, TST_Update

				;;Crack Egg
				Sleep 50
				if (WinsActive() && CheckInv() && ECcheck){
					MouseMove, 0.5*A_ScreenWidth, 660, 3
					Sleep 100
					Send {Lbutton 2}
				}
				;MouseMove, 0.5*A_ScreenWidth, 660, 3
			}else{
				TSTText := ECHotkey " Egger: """ StatValue """ Error getting stat, trying again."
				GoSub, TST_Update
				Sleep 500
			}

			if (ECcheck){
				Sleep 200
				TSTText := ECHotkey " Egger: Refreshing Slot."
				GoSub, TST_Update
			
			
				;Refresh Slot incase crack fails
				if (WinsActive() && CheckInv() && ECcheck)
					MouseClick, Left, TheirTransferSlotX, TheirTransferSlotY, 2, 3

			}	
			Sleep 250
		}
	}
return


KillTooltip:
	ToolTip
return

HasVal(haystack, needle) {
	foundIndicies := " "
    for index, value in haystack
        if (value = needle)
            foundIndicies := foundIndicies index " " 
    if !(IsObject(haystack)){
        throw Exception("Bad haystack!", -1, haystack)
	    return 0
	}else{
		return foundIndicies
	}
}

/*
F1::
	SoundBeep
	Send {i}
	Sleep 300
	MouseClick, Left, YourSearchX, YourSearchY, 1, 3
	Sleep 300
	Send emp
	Sleep 300
	MouseClick, Left, YourTransferSlotX, YourTransferSlotY, 1, 3
	Sleep 200
	Send {e}
	Sleep 200
	Send {Esc}
	Sleep 2500
	Send {LButton 3}
	Sleep 400
	Send {e down}
	Sleep 500
	MouseMove, 0.5*A_ScreenWidth-200, 0.5*A_ScreenHeight-200, 6
	Sleep 200
	Send {LButton}
	Sleep 200
	MouseMove, 0.5*A_ScreenWidth+200, 0.5*A_ScreenHeight+200, 6
	Sleep 200
	Send {LButton}
	Sleep 200
	Send {e up}
	Sleep 200
	MouseClick, Left, .5*A_ScreenWidth, 0.4*A_ScreenHeight, 1, 3
	Sleep 300
	Send ..
	Sleep 300
	MouseClick, Left, .5*A_ScreenWidth, 0.62*A_ScreenHeight, 1, 3
	SoundBeep
return
*/