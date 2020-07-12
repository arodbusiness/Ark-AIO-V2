#NoEnv
#SingleInstance Force
#Include TransSplashText.ahk
#Include Gdip_All.ahk

SetBatchLines -1
Process, Priority,, High
SetKeyDelay, -1
;SetTimer, BeepFunction, 600000

OnExit, ExitSub
DetectHiddenWindows, On


HookProcAdr := RegisterCallback("HookProc", "F" )
API_SetWinEventHook(4,5,0,HookProcAdr,0,0,0)
API_SetWinEventHook(0xA,0xB,0,HookProcAdr,0,0,0)

;OnMessage(0x200,"WM_MOUSEMOVE")
;OnMessage(0x202,"WM_LBUTTONUP")
;OnMessage(0x200,"WM_MOUSEOVER")
OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x84, "WM_NCHITTEST")
OnMessage(0x83, "WM_NCCALCSIZE")


FishingColor := "0xFFFFFF"
FishingSpeed := 150

global GuiN := 43
GuiX := 0
GuiY := 0

AlertSlots := 1
ActiveAlertSlots := "|"

SetTimer, UpdateAlertTimers, 30000

global NewURL

If !pToken := Gdip_Startup(){
	MsgBox, No Gdiplus 
	ExitApp
}


global SplashImagePath := A_ScriptDir "\icon.png"

ColorR := 0xFFFA4C1D
ColorG := 0xFFB4D71E
ColorB := 0xFF6AAEDA

ColorR := 0xFFFF6040
ColorG := 0xFF40FF60
ColorB := 0xFF60CCFF


Menu, Tray, Click, 1
Menu, Tray, NoStandard

Menu, TreeToggleFunctions, Add, Splash Image, ShowingSplashImageFunction
Menu, TreeToggleFunctions, Add
Menu, TreeToggleFunctions, Add, Alerts, ShowingAlertsFunction
Menu, TreeToggleFunctions, Add, Auto Click, ShowingAutoClickFunction
Menu, TreeToggleFunctions, Add, Auto Food Water, ShowingAutoFoodWaterFunction
Menu, TreeToggleFunctions, Add, Crosshair, ShowingCrosshairFunction
Menu, TreeToggleFunctions, Add, Dino Export, ShowingDinoExportFunction
Menu, TreeToggleFunctions, Add, Feed Babies, ShowingFeedBabiesFunction
Menu, TreeToggleFunctions, Add, Fishing, ShowingFishingFunction
Menu, TreeToggleFunctions, Add, Quick Transfer, ShowingQuickTransferFunction
Menu, TreeToggleFunctions, Add, Server Info, ShowingServerInfoFunction
Menu, TreeToggleFunctions, Add, Debug, ShowingDebugFunction
Menu, Tray, Add, Toggle Functions, :TreeToggleFunctions


Menu, TreeUpdatePixels, Add, Check Inventory, UpdatePixel1
Menu, TreeUpdatePixels, Add
Menu, TreeUpdatePixels, Add, Your Search Bar, UpdatePixel2
Menu, TreeUpdatePixels, Add, Your Transfer All, UpdatePixel3
Menu, TreeUpdatePixels, Add, Your Drop All, UpdatePixel4
Menu, TreeUpdatePixels, Add, Your Transfer Slot, UpdatePixel9
Menu, TreeUpdatePixels, Add
Menu, TreeUpdatePixels, Add, Their Search Bar, UpdatePixel5
Menu, TreeUpdatePixels, Add, Their Transfer All, UpdatePixel6
Menu, TreeUpdatePixels, Add, Their Drop All, UpdatePixel7
Menu, TreeUpdatePixels, Add, Their Transfer Slot, UpdatePixel10
Menu, TreeUpdatePixels, Add
Menu, TreeUpdatePixels, Add, Structure Health - Dino XP, UpdatePixel8
Menu, Tray, Add, Update Pixel Coords, :TreeUpdatePixels


Menu, Tray, Add

Menu, Tray, Add, Restore, ActivateMainWindow
Menu, Tray, Default, Restore
Menu, Tray, Add, List Vars, ListVarsFn
Menu, Tray, Add, Reload, ReloadSub
Menu, Tray, Add, Exit, ExitSub

Menu, Tray, Tip, Ark All-In-One



oVoice := ComObjCreate("SAPI.SpVoice")
oVoice.Voice := oVoice.GetVoices().Item(1)




;;Drives := StrSplit("CDEFGH")
Alphabet := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
CurrentDir := "C:\"
i=4
ActualDirs := ""
while (FileExist(CurrentDir)){
	ActualDirs := ActualDirs substr(CurrentDir,1,1)
	CurrentDir := substr(Alphabet,i,1) ":\"
	i++
}
Drives := StrSplit(ActualDirs)




ModTimeLatest := ModTimeLatest2 := 0
Loop % Drives.MaxIndex()
{
	;;FIND VALUES.JSON SMART BREEDER
	CurrentDir := Drives[A_Index] ":\Users"
	
	if (FileExist(CurrentDir))
	{
		;;Tooltip, %CurrentDir%
		Loop, Files, %CurrentDir%\*, D
		{
			CurrentFile := A_LoopFileFullPath "\AppData\Local\ARK Smart Breeding\json\values\values.json"
			if (FileExist(CurrentFile)){
				;FileGetTime, ModTimeCurrent, %CurrentFile%, M
				ModTimeCurrent := A_LoopFileTimeModified
				if (ModTimeCurrent>ModTimeLatest){
					ModTimeLatest := ModTimeCurrent
					ASBvaluesFile := CurrentFile
				}
			}
		}
	}




	;;;FIND EXPORT FOLDER
	CurrentDir := Drives[A_Index] ":\Program Files (x86)\Steam\steamapps\common\ARK\ShooterGame\Saved\DinoExports"
	CurrentDir := !FileExist(CurrentDir) ? Drives[A_Index] ":\SteamLibrary\steamapps\common\ARK\ShooterGame\Saved\DinoExports" : CurrentDir

	if (FileExist(CurrentDir))
	{
		Loop, Files, %CurrentDir%\*, D
		{
			if (FileExist(A_LoopFileFullPath))
			{
				ModTimeCurrent2 := A_LoopFileTimeModified
				if (ModTimeCurrent2>ModTimeLatest2){
					ModTimeLatest2 := ModTimeCurrent2
					ExportDir := A_LoopFileFullPath
				}
			}
		}
	}
}



;;Run, %ASBvaluesFile%
ASBvaluesJSON := ""
if (!FileExist(ASBvaluesFile))
	ASBvaluesFile := A_ScriptDir "\values.json"
if (FileExist(ASBvaluesFile))
	FileRead, ASBvaluesJSON, %ASBvaluesFile%


;;;;;;;;;;;;;;;;;;;;;;;;;Get Crumple Corn Page
CrumpleCornFilePath := A_ScriptDir "\crumplecorn.js"
if (!FileExist(CrumpleCornFilePath))
	UrlDownloadToFile, http://ark.crumplecorn.com/breeding/controller.js, %CrumpleCornFilePath%
if (FileExist(CrumpleCornFilePath))
	FileRead, CrumpleCornFile, %CrumpleCornFilePath%
;;;;;;;;;;;;;;;;;;;;;;;;;Update Crumple Corn for Genesis


if (!RegexMatch(CrumpleCornFile, "'Ambergris': \{")){
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.foods=\{", "$scope.foods={`r`n`r`n`t`t'Ambergris': {`r`n`t`t`tfood: 500,`r`n`t`t`tstack: 1,`r`n`t`t`tspoil: 20*60,`r`n`t`t`tweight: 5,`r`n`t`t`twaste: 0`r`n`t`t},")
}
if (!RegexMatch(CrumpleCornFile, "'Blood Pack': \{")){
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.foods=\{", "$scope.foods={`r`n`r`n`t`t'Blood Pack': {`r`n`t`t`tfood: 200,`r`n`t`t`tstack: 100,`r`n`t`t`tspoil: 30*60,`r`n`t`t`tweight: 0.05,`r`n`t`t`twaste: 0`r`n`t`t},")
}
if (!RegexMatch(CrumpleCornFile, "'Plant Y Seed': \{")){
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.foods=\{", "$scope.foods={`r`n`r`n`t`t'Plant Y Seed': {`r`n`t`t`tfood: 65,`r`n`t`t`tstack: 100,`r`n`t`t`tspoil: 0,`r`n`t`t`tweight: 0.01,`r`n`t`t`twaste: 0`r`n`t`t},")
}
if (!RegexMatch(CrumpleCornFile, "'Rare Mushroom': \{")){
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.foods=\{", "$scope.foods={`r`n`r`n`t`t'Rare Mushroom': {`r`n`t`t`tfood: 75,`r`n`t`t`tstack: 100,`r`n`t`t`tspoil: 0,`r`n`t`t`tweight: 0.02,`r`n`t`t`twaste: 0`r`n`t`t},")
}
;;;;;;;;;;;;;;;;;;;;;;;;;
if (!RegexMatch(CrumpleCornFile, "Deinonychus: \{")){
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tDeinonychus: {`r`n`t`t`tbirthtype: ""Incubation"",`r`n`t`t`ttype: ""Carnivore"",`r`n`t`t},")
}
if (!RegexMatch(CrumpleCornFile, "Magmasaur: \{")){
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tMagmasaur: {`r`n`t`t`tbirthtype: ""Incubation"",`r`n`t`t`ttype: ""Ambergris"",`r`n`t`t},")
}
if (!RegexMatch(CrumpleCornFile, "Ferox: \{")){
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tFerox: {`r`n`t`t`tbirthtype: ""Gestation"",`r`n`t`t`ttype: ""Seed"",`r`n`t`t},")
}
if (!RegexMatch(CrumpleCornFile, "BloodStalker: \{")){
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tBloodStalker: {`r`n`t`t`tbirthtype: ""Incubation"",`r`n`t`t`ttype: ""Blood"",`r`n`t`t},")
}
if (!RegexMatch(CrumpleCornFile, "Hyaenodon: \{")){
	CrumpleCornFile := RegexReplace(CrumpleCornFile, "\$scope\.creatures=\{", "$scope.creatures={`r`n`r`n`t`tHyaenodon: {`r`n`t`t`tbirthtype: ""Gestation"",`r`n`t`t`ttype: ""Carnivore"",`r`n`t`t},")
}

;;;;;;;;;;;;

file := FileOpen(CrumpleCornFilePath, "w")
file.Write(CrumpleCornFile)
file.Close()


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FilePath := "ColorIDs.txt"
if (!FileExist(FilePath))
{
	FilePath := "ColorIDs.ahk"
	if (FileExist(FilePath))
		RunWait, %FilePath%
}
FilePath := "ColorIDs.txt"
if (FileExist(FilePath))
{
	FileRead, FileContents, %FilePath%
	ColorIDs := StrSplit(FileContents, "`n")

}


TempStr := ""
Loop % ColorIDs.MaxIndex()
{
	RegexMatch(ColorIDs[A_Index], "([0-9]{1,})\t{1,10}(.+?)\t{1,10}([0-9a-f]{6})", Match)
	TempStr := TempStr "," Match3
}
;;Clipboard := substr(TempStr, 2)
;;SoundBeep




CapDir := A_ScriptDir "\Captures"
if (!FileExist(CapDir))
	FileCreateDir, %CapDir%
	

YellowBar := CapDir "\YellowBar.jpg"
OrangeBar := CapDir "\OrangeBar.jpg"
CyanBar := CapDir "\CyanBar.jpg"
LowerButton := CapDir "\LowerButton.jpg"
UpperButton := CapDir "\UpperButton.jpg"
global CyanX := CapDir "\CyanX.png"
BlackBox1 := CapDir "\BlackBox1.jpg"	;;Small
BlackBox2 := CapDir "\BlackBox2.jpg"	;;Big

Loop, 8 {
	if (A_Index=1){
		ImgFile := YellowBar
		X := 5, Y := 25, Color := "FFFF00"
	}else if (A_Index=2){
		ImgFile := OrangeBar
		X := 3, Y := 15, Color := "FD8306"
	}else if (A_Index=3){
		ImgFile := CyanBar
		X := 3, Y := 20, Color := "00FFE9"
	}else if (A_Index=4){
		ImgFile := LowerButton
		X := 60, Y := 1, Color := "175F78"
	}else if (A_Index=5){
		ImgFile := UpperButton
		X := 60, Y := 1, Color := "1D6F89"
	}else if (A_Index=6){
		ImgFile := CyanX
		X := 22, Y := 22, Color := "0089A8", W := 3
	}else if (A_Index=7){
		ImgFile := BlackBox1
		X := 22, Y := 22, Color := "000000"
	}else if (A_Index=8){
		ImgFile := BlackBox2
		X := 44, Y := 44, Color := "000000"
	}

	if (!FileExist(ImgFile)){
		pBitmap := Gdip_CreateBitmap(X, Y)
		G := Gdip_GraphicsFromImage(pBitmap)
		pBrush := Gdip_BrushCreateSolid("0xFF" Color)
		if (A_Index=6){
			pPen:=Gdip_CreatePenFromBrush(pBrush, W)
			Gdip_DrawLine(G, pPen, 2, 2, X-2, Y-2)
			Gdip_DrawLine(G, pPen, 2, Y-2, X-2, 2)
		}else{
			Gdip_FillRectangle(G, pBrush, 0, 0, X, Y)
		}
		Gdip_DeleteBrush(pBrush)
		Gdip_DeletePen(pPen)
		Gdip_SaveBitmapToFile(pBitmap, ImgFile)
		Gdip_DeleteGraphics(G)
		Gdip_DisposeImage(pBitmap)

	}
}




X := 15, Y := 15, w := 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ImgFile := CapDir "\Arrow0.png"
pBitmap := Gdip_CreateBitmap(X, Y)
G := Gdip_GraphicsFromImage(pBitmap)
pBrush := Gdip_BrushCreateSolid("0xFFFFFFFF")
Gdip_FillPolygon(G, pBrush, "0,0|" X "," Y/2 "|0," Y "|0,0", 1)
Gdip_SaveBitmapToFile(pBitmap, ImgFile)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ImgFile := CapDir "\Arrow1.png"
pBitmap := Gdip_CreateBitmap(X, Y)
G := Gdip_GraphicsFromImage(pBitmap)
pBrush := Gdip_BrushCreateSolid("0xFFFFFFFF")
Gdip_FillPolygon(G, pBrush, "0,0|" X/2 "," Y "|" X ",0|0,0", 1)
Gdip_SaveBitmapToFile(pBitmap, ImgFile)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gdip_DeleteBrush(pBrush)
Gdip_DeleteGraphics(G)
Gdip_DisposeImage(pBitmap)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



Gui, +Resize +HwndMainHwnd ;+LastFound
;global GuiHwnd
Gui, Font, s16
Gui, Color, 000000
;Gui, Color, 00FF00


ButtonW := 28, ButtonY := 2
HTMLY := ButtonW + ButtonY




Gui, Add, ActiveX, vHTMLDisplay Y%HTMLY%, Chrome.Browser ;Chrome.Browser Shell.Explorer
global HTMLDisplay
ComObjConnect(HTMLDisplay, WB_events)
HTMLDisplay.silent := 1

;+BackgroundTrans

Gui, Add, Text, cWhite  vMover BackgroundTrans, Ark AIO
;;Gui Color, %GUIBackColor%, %GUIBackColor%
;;Gui Font, s%FontSizeT%, %FontFace%
Gui, Add, Picture, y%ButtonY% w%ButtonW% h%ButtonW% vCloseButton gExitSub BackgroundTrans 0xE,
Gui, Add, Picture, y%ButtonY% w%ButtonW% h%ButtonW% vMinButton gActivateMainWindow BackgroundTrans 0xE,
Gui, Add, Picture, y%ButtonY% w%ButtonW% h%ButtonW% vRestartButton gReloadSub BackgroundTrans 0xE,
Gui, Add, Picture, x2 y%ButtonY% w%ButtonW% h%ButtonW% vIconButton 0xE,



Color := ColorR
GuiControlGet, Pos, Pos, CloseButton
GuiControlGet, hwnd, hwnd, CloseButton 
pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
pPen:=Gdip_CreatePen(Color, 3), pPen2:=Gdip_CreatePen(Color, 2)
Gdip_DrawRectangle(G, pPen2, 0, 0, PosW, PosH)
Gdip_DrawLines(G, pPen, 0.2*PosW "," 0.2*PosH "|" 0.8*PosW "," 0.8*PosH)
Gdip_DrawLines(G, pPen, 0.2*PosW "," 0.8*PosH "|" 0.8*PosW "," 0.2*PosH)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Color := ColorB
GuiControlGet, hwnd, hwnd, MinButton 
pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
pPen:=Gdip_CreatePen(Color, 3), pPen2:=Gdip_CreatePen(Color, 2)
Gdip_DrawRectangle(G, pPen2, 0, 0, PosW, PosH)
Gdip_DrawLines(G, pPen, 0.15*PosW "," 0.75*PosH "|" 0.85*PosW "," 0.75*PosH)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Color := ColorG
GuiControlGet, hwnd, hwnd, RestartButton 
pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
pPen:=Gdip_CreatePen(Color, 3), pPen2:=Gdip_CreatePen(Color, 2)
pBrush:=Gdip_BrushCreateSolid(Color)
Gdip_DrawRectangle(G, pPen2, 0, 0, PosW, PosH)
Gdip_SetSmoothingMode(G,2), Gdip_SetInterpolationMode(G, 2)
Gdip_DrawArc(G, pPen, 0.17*PosW, 0.175*PosH, 0.6*PosW, 0.6*PosH, 0, 290)
Gdip_FillPolygon(G, pBrush, 0.55*PosW "," 0.5*PosH "|" 0.75*PosW "," 0.3*PosH "|" 0.95*PosW "," 0.5*PosH "|" 0.55*PosW "," 0.5*PosH)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap), SetImage(hwnd, hBitmap)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gdip_DeletePen(pPen)
Gdip_DeletePen(pPen2)
DeleteObject(hBitmap)
Gdip_DeleteGraphics(G)
Gdip_DisposeImage(pBitmap)



FileName := A_ScriptDir "\Ark-AIO.html"
FileRead, HTML, %FileName%


global FileSettings := A_ScriptDir . "\Ark-AIO.ini"
if (!FileExist(FileSettings)){
	MsgBox, 0,, Failed to find "Ark-AIO.ini"
	IfMsgBox OK 
		ExitApp
}


		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;MAKE THIS HAPPEN AFTER DISPLAY HTMLDisplay
		;HTMLDisplay.document.getElementById("Blah").value := blah

/*
IniRead, IniContents, %FileSettings%, Main
IniLines := StrSplit(IniContents, "`n")
Loop % IniLines.MaxIndex(){
	FoundPos := RegexMatch(IniLines[A_Index], "^(.+?)=(.+?)$", Match)
	if (StrLen(Match1)>0 && StrLen(Match2)>0){
		;Tooltip, %Match1% = %Match2%
		%Match1% := Match2
		if (RegexMatch(Match1, "Showing(.+?)Button", Matcher)){
			if (!Match2){
				HTML := RegexReplace(HTML, """" Matcher1 "DropDown"".+?>", """" Matcher1 "DropDown"" style=""display:none"" >")
			}else{
				Matcher1 := RegexReplace(Matcher1, "([A-Z]{1})([a-z]{1,20})( )?([A-Z]{1})?([a-z]{1,20})?( )?([A-Z]{1})?([a-z]{1,20})?", "$1$2 $4$5 $7$8")
				Matcher1 := RegexReplace(Matcher1, "([ ]{1,10})$")
				Menu, TreeToggleFunctions, Check, %Matcher1%
			}
		}else if (!RegexMatch(Match1, "AutoClickToggle|SpinDir|SoundOutput|SoundDefault|FoodKey|WaterKey|QTDrop|QTFromYou|GachaDump|PresetNumber")){
			if (RegexMatch(Match1, "AlertAlt|AlertsInput|Check|GachaQT|AutoQTSlotCap")){
				Checked := Match2=="1" ? "checked" : ""
				HTML := RegexReplace(HTML, """" Match1 """.+?>", """" Match1 """ " Checked ">")
			}else{
				if(RegexMatch(Match1, "Hotkey"))
					Match2 := RegExReplace(Match2, "~")
				HTML := RegexReplace(HTML, """" Match1 """.+?>", """" Match1 """ value=""" Match2 """>")
			}
			
		}
	}
}

IniLines := IniContents := ""

*/

















DefaultWaterDelay := 10000
DefaultFoodDelay := DefaultWaterDelay*2










IniRead, WindowX, %FileSettings%, Main, WindowX
IniRead, WindowY, %FileSettings%, Main, WindowY
IniRead, WindowW, %FileSettings%, Main, WindowW
IniRead, WindowH, %FileSettings%, Main, WindowH
IniRead, WindowTrans, %FileSettings%, Main, WindowTrans

HTML := RegexReplace(HTML, "(icon.png)", A_ScriptDir "\$1")
HTML := RegexReplace(HTML, """Captures", """" CapDir)
HTML := RegexReplace(HTML, "'Captures", "'" RegexReplace(CapDir, "\\", "\\"))


Display(HTMLDisplay,HTML)

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
	HTMLSoundDevices := HTMLSoundDevices "`t<option value=""" EachSoundDevice[A_Index] """ >" EachSoundDevice[A_Index] "</option>`n"
}
HTMLSoundDevices := "<select>`n" HTMLSoundDevices "</select>"

HTMLSoundDevicesDefault := RegexReplace(HTMLSoundDevices, "<select>", "<select id=""SoundDefaultInput"" name=""SoundDefaultInput"">")
HTMLSoundDevicesOutput := RegexReplace(HTMLSoundDevices, "<select>", "<select id=""SoundOutputInput"" name=""SoundOutputInput"">")

HTMLSoundDevicesDefault := RegexReplace(HTMLSoundDevicesDefault, """" SoundDefault """ >", """" SoundDefault """ selected>")
HTMLSoundDevicesOutput := RegexReplace(HTMLSoundDevicesOutput, """" SoundOutput """ >", """" SoundOutput """ selected>")

SoundDevices := HTMLSoundDevices := EachSoundDevice := ""




;;;;;;LET PAGE LOAD
;Sleep 10000


HTMLDisplay.document.getElementById("DefaultSoundDevicesList").innerHTML := HTMLSoundDevicesDefault
HTMLDisplay.document.getElementById("OutputSoundDevicesList").innerHTML := HTMLSoundDevicesOutput

 

IniRead, IniContents, %FileSettings%, Main
IniLines := StrSplit(IniContents, "`n")
Loop % IniLines.MaxIndex(){
	FoundPos := RegexMatch(IniLines[A_Index], "^(.+?)=(.+?)$", Match)
	if (StrLen(Match1)>0 && StrLen(Match2)>0){
		;Tooltip, %Match1% = %Match2%
		%Match1% := Match2
		if (RegexMatch(Match1, "Showing(.+?)Button", Matcher)){
			if (!Match2){
				HTMLDisplay.document.getElementById(Matcher1 "DropDown").style.display := "none"
				;HTML := RegexReplace(HTML, """" Matcher1 "DropDown"".+?>", """" Matcher1 "DropDown"" style=""display:none"" >")
			}else{
				Matcher1 := RegexReplace(Matcher1, "([A-Z]{1})([a-z]{1,20})( )?([A-Z]{1})?([a-z]{1,20})?( )?([A-Z]{1})?([a-z]{1,20})?", "$1$2 $4$5 $7$8")
				Matcher1 := RegexReplace(Matcher1, "([ ]{1,10})$")
				Menu, TreeToggleFunctions, Check, %Matcher1%
			}

		}else if (!RegexMatch(Match1, "AutoClickToggle|SpinDir|QTDrop|QTFromYou|GachaDump")){
			if (RegexMatch(Match1, "AlertAlt|AlertsInput|Check|GachaQT|AutoQTSlotCap")){
				;Checked := Match2=="1" ? "checked" : ""
				;HTML := RegexReplace(HTML, """" Match1 """.+?>", """" Match1 """ " Checked ">")

				if (Match2)
					HTMLDisplay.document.getElementById(Match1).checked := Match2
			}else{
				if(RegexMatch(Match1, "Hotkey"))
					Match2 := RegExReplace(Match2, "~")
				HTMLDisplay.document.getElementById(Match1).value := Match2
				;HTML := RegexReplace(HTML, """" Match1 """.+?>", """" Match1 """ value=""" Match2 """>")
			}
			
		}else{
			if (Match2="1")
				HTMLDisplay.document.getElementById(Match1 "0").checked := 1
			else
				HTMLDisplay.document.getElementById(Match1 "1").checked := 1
		}
	}
}


IniLines := IniContents := HTMLSoundDevicesDefault := HTMLSoundDevicesOutput := ""



HTMLDisplay.document.getElementById("SoundDefaultInput").value := SoundDefault
HTMLDisplay.document.getElementById("SoundOutputInput").value := SoundOutput



global QTPresetsStr
global QTPresetsArr := {}
ShitArr := StrSplit(QTPresetsStr, "\/")
i=1
Loop % ShitArr.MaxIndex()
{
	if (StrLen(ShitArr[A_Index])>8){
		QTPresetsArr[i] := ShitArr[A_Index]
		i := i + 1
	}
}

global AutoClickPresetsStr
global AutoClickPresetsArr := {}
ShitArr := StrSplit(AutoClickPresetsStr, "\/")
i=1
Loop % ShitArr.MaxIndex()
{
	if (StrLen(ShitArr[A_Index])>8){
		AutoClickPresetsArr[i] := ShitArr[A_Index]
		i := i + 1
	}
}

ShitArr := ""





UpdatePresetSlots("AutoClick",,AutoClickPresetNumber)
UpdatePresetSlots("QT",,QTPresetNumber)






AlertsDelayMS := AlertsDelay*1000
if (AlertsCheck)
	SetTimer, AlertsFunction, %AlertsDelayMS%

if (AutoClickCheck && AutoClickToggle)
	Hotkey, ~%AutoClickHotkey%, AutoClickHotkeyFunction, on

LastDrink := DrinkTime := LastEat := EatTime := A_Now
if (AutoFoodWaterCheck)
	SetTimer, FoodWaterFunction, 1000

LastExportTime := ModTimeLatest := A_Now
Exporting := 0
if (DinoExportCheck)
	SetTimer, CheckDinoExport, 1000

if (FeedBabiesCheck)
	Hotkey, ~%FeedBabiesHotkey%, FeedBabiesHotkeyFunction, on

FishingEnabled := 0
if (FishingCheck)
	Hotkey, ~%FishingHotkey%, FishingHotkeyFunction, on

AutoQTCapDelayMS := AutoQTCapDelay*1000
if (QTCheck){
	Hotkey, ~%QTHotkey%, QTHotkeyFunction, on
	if (AutoQTSlotCap)
		SetTimer, WatchingForSlotCap, %AutoQTCapDelayMS%
}

if (ServerInfoCheck){
	GoSub, ChooseServer
}else
	GoSub, GetOfficialRates



if (WindowTrans<255 && WindowTrans!="ERROR")
	Winset, Transparent, %WindowTrans%, ahk_id %MainHwnd%



Gui, Show, X%WindowX% Y%WindowY% W%WindowW% H%WindowH%, Ark AIO
GoSub, SaveWindowPos


DrinkTimeDisp := SecondsToString(WaterDelay,0)
EatTimeDisp := SecondsToString(FoodDelay,0)

GoSub, UpdateFWdisp



ToggleKey := AutoClickCheck ? AutoClickHotkey : FeedBabiesHotkey
TST_On(GuiN,GuiX,GuiY,ToggleKey ":","OFF","Welcome!",TSThwnds)
global TSThwnds
OverlayShowing := 1
SetTimer, UpdateGUI, 250



;;SetTimer, CheckCryoBed, 500
;;SetTimer, MakeSplashImage, 5000



CurrentlySpamming := 0
QTinProgress := 0
EnabledText := "OFF"

Loop{

	if (!AutoClickToggle){
		if (GetKeyState(AutoClickHotkey, P) && AutoClickCheck){
			if (!CurrentlySpamming){
				CurrentlySpamming := True
				SetTimer, AutoClickFunction, %AutoClickSpamDelay%
				EnabledText := "ON"
				;GoSub, UpdateGUI
			}
		}else{
			if (CurrentlySpamming){
				CurrentlySpamming := False
				SetTimer, AutoClickFunction, off
				EnabledText := "OFF"
				;GoSub, UpdateGUI
			}
		}
	}
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;Handle duplicate hotkeys
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	AllHotkeysNames := ":AutoClickHotkey:FeedBabiesHotkey:FishingHotkey:QTHotkey:"
	AllHotkeys := ":" AutoClickHotkey ":" FeedBabiesHotkey ":" FishingHotkey ":" QTHotkey ":"



	DuplicateHotkeyNames := DuplicateHotkey := ""
	Loop, Parse, AllHotkeysNames, % ":"
	{
		if (StrLen(A_LoopField)>1 && %A_LoopField%!=""){
			if(RegexMatch(AllHotkeys, "i):(" %A_LoopField% ").+?(" %A_LoopField% "):", Match)){
				TempName := RegExReplace(A_LoopField, "Hotkey", "Check")

				if (%TempName%=1){
					%TempName% := 0
					HTMLDisplay.document.getElementById(TempName).checked := 0
					IniWrite, 0, %FileSettings%, Main, %TempName%
					SoundBeep
				}
			}
		}
	}




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




	if (FeedBabiesCheck){
		if (FeedBabiesEnabled && WinActive("ahk_class UnrealWindow")){
			FeedBabiesDispStr = Rotating
			;;GoSub, UpdateGUI
			;BlockInput, MouseMove
						
			ActualSpin := SpinDir ? SpinPixels : -SpinPixels
			
			DllCall("mouse_event", "UInt", 0x01, "UInt", ActualSpin, "UInt", 0)
			Sleep 250
			Send {f}
			FeedBabiesDispStr = Looking For Inventory
			;;GoSub, UpdateGUI
			Sleep 1000
		}
		if (FeedBabiesEnabled && CheckInv() && WinActive("ahk_class UnrealWindow")){
			FeedBabiesDispStr = Found Inventory
			
			PixelGetColor, Color, %StructureHPX%, %StructureHPY%
			B := Color >> 16 & 0xFF, G := Color >> 8 & 0xFF, R := Color & 0xFF
			if (FeedBabiesEnabled && WinActive("ahk_class UnrealWindow")){
				;BlockInput, MouseMove
				if (R<20 && G>65 && B>100){	;;;;;;IN Food Supply
					
					FeedBabiesDispStr = Food Supply
					;;GoSub, UpdateGUI
					Sleep 1000
					MouseClick, Left, YourTransferAllX, YourTransferAllY, 1
					Sleep 250
					MouseClick, Left, TheirTransferSlotX, TheirTransferSlotY, 1
					
					Sleep 500
					babiesX := TheirTransferSlotX
					babiesY := TheirTransferSlotY
				}
				else{												;;;;;;IN Baby
					
					FeedBabiesDispStr = Feed Baby
					;;GoSub, UpdateGUI
					Sleep 1500
					MouseClick, Left, YourTransferSlotX, YourTransferSlotY, 1
					
					Sleep 500
					babiesX := YourTransferSlotX
					babiesY := YourTransferSlotY
				}
			}
			if (FeedBabiesEnabled && CheckInv() && WinActive("ahk_class UnrealWindow")){
				FeedBabiesDispStr = Transfering Food
				;;GoSub, UpdateGUI
				MouseMove, babiesX, babiesY, 5
				Sleep 100
				Loop, 5{
					if (FeedBabiesEnabled && WinActive("ahk_class UnrealWindow"))
						Send {t}
					Else
						break
					Sleep 500
				}
			}
			if (FeedBabiesEnabled && WinActive("ahk_class UnrealWindow"))
				Send {f}
			FeedBabiesDispStr = Exit Inventory
			;;GoSub, UpdateGUI
			Sleep 1000
		}else{
			if (FeedBabiesEnabled && WinActive("ahk_class UnrealWindow"))
			{
				FeedBabiesDispStr = No Inventory Found
				;;GoSub, UpdateGUI
			}
		}
	}else{
		FeedBabiesDispStr := ""
	}




	if (AutoFoodWaterCheck){

	}else{
		FoodWaterDispStr := ""
	}






	;;GoSub, UpdateGUI

		
	Sleep 1   ;;;If no SLeep.... CPU Hog
}
Return



UpdateGUI:
	if (DisplayingMessage){
		if (!OverlayShowing){
			Gui, %GuiN%:Show, NA
			OverlayShowing := 1
		}
	}else if (WinActive("ahk_class UnrealWindow")){
		if (AutoClickCheck){
			AutoClickDispStr := "Spam Key: " AutoClickKey "  Spam Delay: " AutoClickSpamDelay " ms"
			AutoClickDispStr := AutoClickHoldDelay != 0 ? AutoClickDispStr "Hold Delay: " AutoClickHoldDelay " ms" : AutoClickDispStr

		}else{
			AutoClickDispStr := ""
		}

		if (AutoClickCheck && AutoClickEnabled)
			FeedBabiesDispStr := ""

		if (FeedBabiesCheck && FeedBabiesEnabled)
			AutoClickDispStr := ""



		
		ToggleKey := FeedBabiesDispStr ? FeedBabiesHotkey : AutoClickHotkey


		EnabledText := FeedBabiesEnabled || (AutoClickEnabled && AutoClickToggle) || CurrentlySpamming ? "ON" : "OFF" 

		
		if (LastEnabledText!=EnabledText || LastDisplayStr!=DisplayStr || AutoClickDispStr!=LastAutoClickDispStr || FeedBabiesDispStr!=LastFeedBabiesDispStr || FoodWaterDispStr!=LastFoodWaterDispStr || LastToggleKey!=ToggleKey || LastEnabledText!=EnabledText || LastAutoClickKey!=AutoClickKey){
			LastAutoClickDispStr := AutoClickDispStr
			LastFeedBabiesDispStr := FeedBabiesDispStr
			LastFoodWaterDispStr := FoodWaterDispStr
			LastToggleKey := ToggleKey
			LastAutoClickKey := AutoClickKey
			

			DisplayStr := "" 


			if (AutoClickDispStr)
				DisplayStr := DisplayStr ? DisplayStr "  ||  " AutoClickDispStr : AutoClickDispStr
			

			if (FoodWaterDispStr)
				DisplayStr := DisplayStr ? DisplayStr "  ||  " FoodWaterDispStr : FoodWaterDispStr
			


			if (FeedBabiesDispStr)
				DisplayStr := DisplayStr ? DisplayStr "  ||  " FeedBabiesDispStr : FeedBabiesDispStr
			


			TST_Update(ToggleKey ":", EnabledText, DisplayStr, TSThwnds)
			LastEnabledText := EnabledText
			LastDisplayStr := DisplayStr
		}

		if (CrosshairCheck && !ReticleDrawn){
			GoSub, drawReticle
			ReticleDrawn := 1
		}



		if (!OverlayShowing){
			Gui, %GuiN%:Show, NA
			OverlayShowing := 1
		}

	}else{
		if (OverlayShowing){
			Gui, %GuiN%:Hide
			OverlayShowing := 0
		}


		if (ReticleDrawn){
			Gui, 6:Destroy
			ReticleDrawn := 0
		}

	}
Return





AlertsFunction:
	if (AlertsInput1){
		ImageSearch, FoundCyanX, FoundCyanY, 0, 0, A_ScreenWidth, 0.3*A_ScreenHeight, *5 %CyanBar%
		if (FoundCyanX && FoundCyanY){
			SoundFile := "EnemySpotted"
			GoSub, MakeSound
			Alerted := 1
		}
	}
	if (CheckDC() && AlertsInput2){
		SoundFile := "Disconnected"
		GoSub, MakeSound
		Alerted := 1
	}
	if (AlertsInput3 && WinExist("The UE4-ShooterGame Game has crashed and will close")){
		SoundFile := "Game has Crashed!"
		GoSub, MakeSound
		Alerted := 1
	}
	if (ServerDownAlert && AlertsInput4){
		SoundFile := "Server is Down!"
		GoSub, MakeSound
		Alerted := 1
	}
	if (ServerUpAlert && AlertsInput5){
		SoundFile := "Server is Up!"
		GoSub, MakeSound
		Alerted := 1
	}
Return






FoodWaterFunction:
	if (DrinkTime<=0){	
		if (WinActive("ahk_class UnrealWindow")){
			DrinkTimeDisp := "GLUG GLUG GLUG"
			Send {%WaterKey%}
			LastDrink := A_Now
			DrinkTime := 1
		}else {
			DrinkTimeDisp := "Waiting to Drink"
		}
	}else{
		DrinkTime := LastDrink
		EnvSub, DrinkTime, %A_Now%, seconds 
		DrinkTime := WaterDelay + DrinkTime
		DrinkTimeDisp := SecondsToString(DrinkTime,0)
	}

	if (EatTime<=0){	
		if (WinActive("ahk_class UnrealWindow")){
			EatTimeDisp := "NOM NOM NOM"
			Send {%FoodKey%}
			LastEat := A_Now
			EatTime := 1
		}else{
			EatTimeDisp := "Waiting to Eat"
		}
	}else{
		EatTime := LastEat
		EnvSub, EatTime, %A_Now%, seconds
		EatTime := FoodDelay + EatTime
		EatTimeDisp := SecondsToString(EatTime,0)
	}

	GoSub, UpdateFWdisp
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





$Esc::
	if (!WinActive("ahk_id " MainHwnd))
		Send {Esc}
	
return




GuiClose:
GuiEscape:
{
	GoSub, ExitSub
    ExitApp
}

ListVarsFn:
	ListVars
return

CheckInv(){


	;;;;;;;;;;;;;;;;;;;USING X BUTTON AT TOP RIGHT CORNER

	
	PixelGetColor, Color, %CheckInvX%, %CheckInvY%
	B := Color >> 16 & 0xFF, G := Color >> 8 & 0xFF, R := Color & 0xFF



	;;DebugInfo := "R: " R " B: " B " G: " G
	;;GoSub, UpdateDebug


	if (R<5 && G>110 && G<190 && B>155 && B<210 && WinActive("ahk_class UnrealWindow"))
		RetVal := true
	else{
		RetVal := false

		ImageSearch, CyanXX, CyanXY, 0.90*A_ScreenWidth, 0, A_ScreenWidth, 0.15*A_ScreenHeight, *15 *TransBlack %CyanX%
		
		;;Tooltip, %CyanX%`n%ErrorLevel%`n%CyanXX%`n%CyanXY%


		RetVal := CyanXX && CyanXY ? true : false
	}
	return RetVal
}








drawReticle:
	IniWrite, %XhairD%, %FileSettings%, Main, XhairD
	IniWrite, %XhairR%, %FileSettings%, Main, XhairR
	IniWrite, %XhairG%, %FileSettings%, Main, XhairG
	IniWrite, %XhairB%, %FileSettings%, Main, XhairB


	HexR := substr(FHex(XhairR, 2),3)
	HexG:= substr(FHex(XhairG, 2),3)
	HexB := substr(FHex(XhairB, 2),3)
	
	Gui, 6:Destroy

	X := (0.5*A_ScreenWidth-XhairD/2)+XhairOffsetX
	Y := (0.5*A_ScreenHeight-XhairD/2)+XhairOffsetY
	ARGB := 0xFF HexR HexG HexB 

	Gui, 6:-Caption +E0x80000 +E0x20 +HwndCrosshairhwnd +AlwaysOnTop +ToolWindow +OwnDialogs ;+LastFound Create GUI
	Gui, 6:Show, NA ; Show GUI
	;;hwnd1 := WinExist() ; Get a handle to this window we have created in order to update it later
	hbm := CreateDIBSection(A_ScreenWidth, A_ScreenHeight) ; Create a gdi bitmap drawing area
	hdc := CreateCompatibleDC() ; Get a device context compatible with the screen
	obm := SelectObject(hdc, hbm) ; Select the bitmap into the device context
	pGraphics := Gdip_GraphicsFromHDC(hdc) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	Gdip_SetSmoothingMode(pGraphics, 4) ; Set the smoothing mode to antialias = 4 to make shapes appear smother
	 
	pBrush := Gdip_BrushCreateSolid(ARGB)
	Gdip_FillEllipse(pGraphics, pBrush, X, Y, XhairD, XhairD)

	UpdateLayeredWindow(Crosshairhwnd, hdc, 0, 0, A_ScreenWidth, A_ScreenHeight)
	SelectObject(hdc, obm) ; Select the object back into the hdc
	Gdip_DeletePath(Path)
	Gdip_DeleteBrush(pBrush)
	Gdip_DeletePen(pPen)
	DeleteObject(hbm) ; Now the bitmap may be deleted
	DeleteDC(hdc) ; Also the device context related to the bitmap may be deleted
	Gdip_DeleteGraphics(pGraphics) ; The graphics may now be deleted

return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





Display(WB,html_str) {
	Count:=0
	while % FileExist(f:=A_Temp "\" A_TickCount A_NowUTC "-tmp" Count ".DELETEME.html")
		Count+=1
	FileAppend,%html_str%,%f%
	WB.Navigate("file://" . f)
}

FHex( int, pad=0 ) { ; Function by [VxE]. Formats an integer (decimals are truncated) as hex.

; "Pad" may be the minimum number of digits that should appear on the right of the "0x".

	Static hx := "0123456789ABCDEF"

	If !( 0 <= int |= 0 )

		Return !int ? "0x0" : "-" FHex( -int, pad )

	s := 1 + Floor( Ln( int ) / Ln( 16 ) )

	h := SubStr( "0x0000000000000000", 1, pad := pad < s ? s + 2 : pad < 16 ? pad + 2 : 18 )

	u := A_IsUnicode = 1

	Loop % s

		NumPut( *( &hx + ( ( int & 15 ) << u ) ), h, pad - A_Index << u, "UChar" ), int >>= 4

	Return h

}



SetDefaultEndpoint(DeviceID)
{
    try IPolicyConfig := ComObjCreate("{870af99c-171d-4f9e-af0d-e63df40c2bc9}", "{F8679F50-850A-41CF-9C72-430F290290C8}")
    try DllCall(NumGet(NumGet(IPolicyConfig+0)+13*A_PtrSize), "UPtr", IPolicyConfig, "UPtr", &DeviceID, "UInt", 0, "UInt")
    try ObjRelease(IPolicyConfig)
}

GetDeviceID(Devices, Name)
{
    For DeviceName, DeviceID in Devices
        If (InStr(DeviceName, Name))
            Return DeviceID
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



CheckDC(){


	Y := 0.572*A_ScreenHeight ;;;;.551-.574
	X1 := 0.390*A_ScreenWidth ;;;;.368
	X2 := 0.450*A_ScreenWidth ;;;;;.470
	X3 := 0.550*A_ScreenWidth ;;;;;.528
	X4 := 0.600*A_ScreenWidth ;;;;;.629
	Test1 := Test2 := Test3 := Test4 := 0	
	Loop, 4
	{
		if (WinActive("ahk_class UnrealWindow")){
			X := X%A_Index%
			PixelGetColor, Color, %X%, %Y%
			B%A_Index% := Color >> 16 & 0xFF
			G%A_Index% := Color >> 8 & 0xFF
			R%A_Index% := Color & 0xFF
			if (R%A_Index%>0 && R%A_Index%<20 && G%A_Index%>20 && G%A_Index%<100 && B%A_Index%>40 && B%A_Index%<120)
				Test%A_Index% := 1
			else
				Test%A_Index% := 0
		}
	}
	
	;Tooltip, R1:%R1% G1:%G1% B1:%B1%`nR2:%R2% G2:%G2% B2:%B2%`nR3:%R3% G3:%G3% B3:%B3%`nR4:%R4% G4:%G4% B4:%B4% 
	
	
	

	if (Test1=1 && Test2=1 && Test3=1 && Test4=1)
		RetVal := true
	;else if (!WinExist("ahk_exe ShooterGame.exe"))
	;	RetVal := true
	else if (WinExist("Json Error")){
		RetVal := true
		;WinClose, Json Error
		WinActivate, ahk_exe ShooterGame.exe
	}
	else
		RetVal := false
			
	return RetVal
}


CheckCryoBed:
	Testccb1 := Testccb2 := 0
	
	Yccb := 0.952*A_ScreenHeight
	
	
	if (WinActive("ahk_class UnrealWindow")){
		Xccb := 0.885*A_ScreenWidth
		PixelGetColor, Colorccb, %Xccb%, %Yccb%
		Bccb1 := Colorccb >> 16 & 0xFF, Gccb1 := Colorccb >> 8 & 0xFF, Rccb1 := Colorccb & 0xFF
		if (Gccb1>105 && Bccb1>35)
			Testccb1 := 1
			
			
			
		Xccb := 0.893*A_ScreenWidth	
		PixelGetColor, Colorccb, %Xccb%, %Yccb%
		Bccb2 := Colorccb >> 16 & 0xFF, Gccb2 := Colorccb >> 8 & 0xFF, Rccb2 := Colorccb & 0xFF
		if (Rccb2>120 && Gccb2>110 && Bccb2<60)
			Testccb2 := 1

		
		
		if (Testccb1 && Testccb2 && !CheckInv()){
			;;Tooltip, IN SLEEPING POD
			
			if (!InTekPod)
				SetTimer, TekPodAction, 50
			
			InTekPod := 1
			
		}else{
			if (InTekPod)
				SetTimer, TekPodAction, Off
			InTekPod := 0
			;;Tooltip, %Testccb1% - R:%Rccb1% G:%Gccb1% B:%Bccb1%`n%Testccb2% - R:%Rccb2% G:%Gccb2% B:%Bccb2%
		}
		
		
		
	}
return

TekPodAction:
	if (WinActive("ahk_class UnrealWindow")){
		PodSpinAmount := 15
		PodSpin := RadioSpinInput ? -PodSpinAmount : PodSpinAmount
			
		;;DllCall("mouse_event", "UInt", 0x01, "UInt", PodSpin, "UInt", 0)
	}
return

CheckDinoExport:
	if (WinActive("ahk_class UnrealWindow")){
		;ImageSearch, FoundYellowX, FoundYellowY, 0, 0, A_ScreenWidth, 0.3*A_ScreenHeight, *5 %YellowBar%
		
		;if ((FoundYellowX || FoundYellowY)){
		if(1){
			if (!Exporting){
			
				if (FileExist(ExportDir))
				{
					Loop, Files, %ExportDir%\*, R
					{
						;FileGetTime, ModTimeCurrent, %A_LoopFileFullPath%, M
						
						ModTimeCurrent := A_LoopFileTimeModified

						;;ModTimeLatest := ModTimeCurrent>ModTimeLatest ? ModTimeCurrent : ModTimeLatest
						

						if(ModTimeCurrent>=A_Now-4)
						{
							ModTimeLatest := ModTimeCurrent
							LatestFile := A_LoopFileFullPath
							break
						}

						if (ModTimeCurrent>ModTimeLatest){
							ModTimeLatest := ModTimeCurrent
							LatestFile := A_LoopFileFullPath
						}
					}
				}
			

				if (LastExportTime != ModTimeLatest)
				{
					SoundBeep
					Exporting := 1
					LastExportTime := ModTimeLatest
					GoSub, ASBstats
					GoSub, DinoExportFunction 
				}
			}
		}else
			Exporting := 0
	}else
		Exporting := 0
return


CleanExportFolder:



return





ASBstats:
	ASBhwnd := WinExist("ARK Smart")
	if (ASBhwnd){
		;;WinActivate, ahk_id %ASBhwnd%
		
		WinSet, AlwaysOnTop , On, ahk_id %ASBhwnd%




		;;;;;DOES NOT WORK IF RAN AS ADMIN
		;;ControlClick, WindowsForms10.BUTTON.app.0.141b42a_r9_ad139, ahk_id %ASBhwnd%,,,2
		ControlClick, X415 Y105, ahk_id %ASBhwnd%

		;WinActivate, ahk_id %ASBhwnd%
		;Tooltip, HERE, 415, 105
		WinSet, AlwaysOnTop , Off, ahk_id %ASBhwnd%
/*
		w := 550
		h := 705
		
		pBitmap := Gdip_CreateBitmap(w, h)
		G := Gdip_GraphicsFromImage(pBitmap)
		Gdip_SetSmoothingMode(G, 2)
		Gdip_SetInterpolationMode(G, 7)
		
		CapturedBitmap := Gdip_BitmapFromHWND(ASBhwnd)
		Gdip_DrawImage(G, CapturedBitmap, 0, 0, w, h, 15, 80, w, h)
		


		pBrush := Gdip_BrushCreateSolid("0xFFFFFFFF")

		x := 370
		y := 307
		w2 := 166
		h2 := 15
		Loop, 6
		{
			if (A_Index=3)
				y := y + 1
			if (A_Index=5)
				y := y + 2

			Gdip_FillRectangle(G, pBrush, x, y, w2, h2)
			y := y + 26
		}

		Gdip_SaveBitmapToFile(pBitmap, "LastExport.jpg", 100)
		
		;;Run, "LastExport.jpg"

		Gdip_DeleteBrush(pBrush)
		Gdip_DeleteGraphics(G)
		Gdip_DisposeImage(pBitmap)
		Gdip_DisposeImage(CapturedBitmap)
*/	
	}

return



DinoExportFunction:	

	ExportHTML := ""
	IniWrite, %LatestFile%, %FileSettings%, Main, LatestFile
	;Run, %LatestFile%

	IniRead, DinoNameTag, %LatestFile%, Dino Data, DinoNameTag
	DinoNameTag := DinoNameTag == "Pug" ? "Bulbdog" : DinoNameTag
	DinoNameTag := DinoNameTag == "Lantern Bird" ? "Featherlight" : DinoNameTag
	DinoNameTag := DinoNameTag == "CaveWolf" ? "Ravager" : DinoNameTag
	DinoNameTag := DinoNameTag == "Gremlin" ? "Ferox" : DinoNameTag
	DinoNameTag := DinoNameTag == "LavaLizard" ? "Magmasaur" : DinoNameTag
	DinoNameTag := DinoNameTag == "Bigfoot" ? "Gigantopithecus" : DinoNameTag
	DinoNameTag := DinoNameTag == "Gigant" ? "Giganotosaurus" : DinoNameTag
	DinoNameTag := DinoNameTag == "Para" ? "Parasaur" : DinoNameTag




	IniRead, DinoClass, %LatestFile%, Dino Data, DinoClass
	DinoClass := substr(DinoClass,1, strLen(DinoClass)-2)

	FoundPos := RegexMatch(DinoClass, "s)\.([A-z]{1,50})_Char", Match)
	DinoNameTag2 := Match1


	IniRead, BabyAge, %LatestFile%, Dino Data, BabyAge
	IniRead, DinoLevel, %LatestFile%, Dino Data, CharacterLevel
	IniRead, DinoImprintingQuality, %LatestFile%, Dino Data, DinoImprintingQuality





	IniRead, Health, %LatestFile%, Max Character Status Values, Health
	IniRead, Stamina, %LatestFile%, Max Character Status Values, Stamina
	IniRead, ChargeCapacity, %LatestFile%, Max Character Status Values, Charge Capacity
	IniRead, Torpidity, %LatestFile%, Max Character Status Values, Torpidity
	IniRead, Oxygen, %LatestFile%, Max Character Status Values, Oxygen
	IniRead, ChargeRegen, %LatestFile%, Max Character Status Values, Charge Regen
	IniRead, Food, %LatestFile%, Max Character Status Values, food
	IniRead, Weight, %LatestFile%, Max Character Status Values, Weight
	IniRead, Melee, %LatestFile%, Max Character Status Values, Melee Damage
	IniRead, EmissionRange, %LatestFile%, Max Character Status Values, Charge Emission Range
	IniRead, Speed, %LatestFile%, Max Character Status Values, Movement Speed
	IniRead, Crafting, %LatestFile%, Max Character Status Values, Crafting Skill





	Health := round(Health)
	Stamina := round(Stamina)
	ChargeCapacity := round(ChargeCapacity,1)
	Torpidity := round(Torpidity,1)
	Oxygen := round(Oxygen)
	ChargeRegen := round(ChargeRegen,1)
	Food := round(Food)
	Weight := round(Weight,1)
	Melee := round((Melee+1)*100,1)
	EmissionRange := round((EmissionRange+1)*100,1)
	Speed := round((Speed+1)*100,1)
	Crafting := round(Crafting,2)

	if(DinoImprintingQuality){
		Health2 := "<td>" round(Health/((1+0.2)*DinoImprintingQuality)) ".1</td>"
		Stamina2 := "<td>" round(Stamina) "</td>"
		ChargeCapacity2 := "<td>" round(ChargeCapacity,1) "</td>"
		Oxygen2 := "<td>" round(Oxygen) "</td>"
		ChargeRegen2 := "<td>" round(ChargeRegen,1) "</td>"
		Food2 := "<td>" round(Food/((1+0.2)*DinoImprintingQuality)) "</td>"
		Weight2 := "<td>" round(Weight/((1+0.2)*DinoImprintingQuality),1) "</td>"
		Melee2 := "<td>" round((Melee+1)*100/((1.1965128205128205128205128205128)*DinoImprintingQuality),1) "</td>"
		EmissionRange2 := "<td>" round((EmissionRange+1)*100/((1.1965128205128205128205128205128)*DinoImprintingQuality),1) "</td>"
		Speed2 := "<td>" round((Speed)/((1.2)*DinoImprintingQuality),1) "</td>"
	}Else
		Health2 := Stamina2 := ChargeCapacity2 := Oxygen2 := ChargeRegen2 := Food2 := Weight2 := Melee2 := EmissionRange2 := Speed2 := ""

	;;Run, %LatestFile%
	




	
	FoundPosDino := RegExMatch(ASBvaluesJSON, DinoClass)
	FoundPosDino := !FoundPosDino ? RegExMatch(ASBvaluesJSON, DinoNameTag) : FoundPosDino

	;;FoundPosMain := RegExMatch(ASBvaluesJSON, "fullStatsRaw""(.+?)""", Match, FoundPos)
	


	;FoundPosMain := RegExMatch(ASBvaluesJSON, "s)fullStatsRaw"": ?\[\n(.+?)\n\t{3}],\n", Match, FoundPosDino)
	FoundPosMain := RegExMatch(ASBvaluesJSON, "s)fullStatsRaw"": ?\[\r?\n(.+?)\r?\n\t{3}],\r?\n", Match, FoundPosDino)
	
	RawStatsArr := StrSplit(RegExReplace(Match1, "\t"), "`n")


	Stats1A := Health
	Stats2A := Stamina = "ERROR" || Stamina <= 0 ? ChargeCapacity : Stamina
	Stats4A := Oxygen="ERROR" || Oxygen <= 0 ? ChargeRegen : Oxygen
	Stats5A := Food
	Stats8A := Weight
	Stats9A := Melee="ERROR" || Melee <= 0 ? EmissionRange : Melee
	Stats10A := Speed
	Stats12A := Crafting


	WildLevels := 1


	ExportHTML := ExportHTML "`r`n<tr>`r`n<td colspan=""20"" align=""center"">`r`n<table width=""100%"">`r`n"


	DinoNameTagDisp := InStr(DinoClass, "BiomeVariants") ? "X-" DinoNameTag : DinoNameTag

	ImprintedStr := DinoImprintingQuality ? "  -  " round(DinoImprintingQuality*100) "% Imprint" : ""

	ExportHTML := ExportHTML "`r`n`r`n<tr>`r`n`t<th colspan=""6"">" DinoNameTagDisp "  -  Lvl " DinoLevel ImprintedStr "</th>`r`n</tr>`r`n"

	if(DinoImprintingQuality)
		ExportHTML := ExportHTML "`r`n`r`n<tr>`r`n`t<td></td><td>Current</td><td>Breeding</td><td>Wild Lvl</td>`r`n</tr>`r`n"
	else
		ExportHTML := ExportHTML "`r`n`r`n<tr>`r`n`t<td></td><td>Current</td><td>Wild Lvl</td>`r`n</tr>`r`n"


	Loop % RawStatsArr.MaxIndex() {
		
		if(InStr(RawStatsArr[A_Index],"null")){
			RawStats%A_Index% := 0

		}else{
			FoundPos := RegExMatch(RawStatsArr[A_Index], "\[ (.+?)`, (.+?)`, (.+?)`, (.+?)`, (.+?) \]", Match)

			if (RegexMatch(DinoClass, "BiomeVariants|Abb?err?ant") && A_Index=1){
				Match1 := Match1 *.97
			}


			RawStats%A_Index%A := Match1   ;;BASE Value
	 		RawStats%A_Index%B := Match2   ;;Wild Lvls Percent
			RawStats%A_Index%C := Match3   ;;Dom Lvls Percent
			RawStats%A_Index%D := Match4
			RawStats%A_Index%E := Match5   ;;Dom Flat Boost


			if (RegexMatch(A_Index, "^1|5|8|9$")){
				Stats%A_Index%A := DinoImprintingQuality ? Stats%A_Index%A/((1+0.2)*DinoImprintingQuality) : Stats%A_Index%A
				
			}



			if (A_Index=9){	;;MELEE

				if (RegexMatch(DinoNameTag, "i)giganoto")){
					MeleeMatch1 := 20
					MeleeMatch2 := 5
				}else if (RegexMatch(DinoNameTag, "i)magma")){
					MeleeMatch1 := 88.2
					MeleeMatch2 := 3.528

				}else if (RegexMatch(DinoNameTag, "i)wyv")){
					MeleeMatch1 := 88.2
					MeleeMatch2 := 5.88

				}else if (RegexMatch(DinoNameTag, "i)kangaroo")){
					MeleeMatch1 := 114.1
					MeleeMatch2 := 5.55

				}else if (RegexMatch(DinoNameTag, "i)elemental")){
					MeleeMatch1 := 119.7
					MeleeMatch2 := 5.88

				}else if (RegexMatch(DinoNameTag, "i)thyla|hyae")){
					MeleeMatch1 := 121.9
					MeleeMatch2 := 5.77

				}else if (RegexMatch(DinoNameTag, "i)giganto")){
					MeleeMatch1 := 125.8
					MeleeMatch2 := 4.704

				}else if (RegexMatch(DinoNameTag, "i)mantis")){
					MeleeMatch1 := 125.8
					MeleeMatch2 := 2.94

				}else if (RegexMatch(DinoNameTag, "i)ferox|mesopith|anky|bulb|feather|")){
					MeleeMatch1 := 134.1
					MeleeMatch2 := 5.88
				}else{
					MeleeMatch1 := 125.8
					MeleeMatch2 := 5.88
				}
				Stats%A_Index%B := round((Stats%A_Index%A-MeleeMatch1)/(MeleeMatch2))

			}else{
				Temp := Match1 + Match1*Match5
				Stats%A_Index%B := round((Stats%A_Index%A-Temp)/(Temp * Match2))
			}
			

			WildLevels := WildLevels + Stats%A_Index%B

		}
	}
	
	RawStats10B := DinoLevel - WildLevels


	ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Health</td>`r`n`t<td>" Health ".1</td>" Health2 "<td>" Stats1B "</td>`r`n</tr>"


	if(Stamina = "ERROR" || Stamina <= 0)
		ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Charge Capacity</td>`r`n`t<td>" ChargeCapacity "</td>" ChargeCapacity2 "<td>" Stats2B "</td>`r`n</tr>"
	else
		ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Stamina</td>`r`n`t<td>" Stamina "</td>" Stamina2 "<td>" Stats2B "</td>`r`n</tr>"

	if(Oxygen="ERROR" || Oxygen <= 0)
		ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Charge Regen</td>`r`n`t<td>" ChargeRegen "</td>" ChargeRegen2 "<td>" Stats4B "</td>`r`n</tr>"
	else
		ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Oxygen</td>`r`n`t<td>" Oxygen "</td>" Oxygen2 "<td>" Stats4B "</td>`r`n</tr>"

	ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Food</td>`r`n`t<td>" Food "</td>" Food2 "<td>" Stats5B "</td>`r`n</tr>"
	ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Weight</td>`r`n`t<td>" Weight "</td>" Weight2 "<td>" Stats8B "</td>`r`n</tr>"


	if(Melee="ERROR" || Melee <= 0){
		EmissionRange2 := DinoImprintingQuality ? "<td>" round(MeleeMatch1+MeleeMatch2*Stats9B,1) "</td>" : ""
		ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Emission Range</td>`r`n`t<td>" EmissionRange "</td>" EmissionRange2 "<td>" Stats9B "</td>`r`n</tr>"
	}
	else{
		Melee2 := DinoImprintingQuality ? "<td>" round(MeleeMatch1+MeleeMatch2*Stats9B,1) "</td>" : ""
		ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Melee</td>`r`n`t<td>" Melee "</td>" Melee2 "<td>" Stats9B "</td>`r`n</tr>"
	}

	ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td>Speed</td>`r`n`t<td>" Speed "</td>" Speed2 "<td>" RawStats10B "</td>`r`n</tr>"


	ExportHTML := ExportHTML "`r`n</table>`r`n</td>`r`n</tr>"






	FoundPosExport := RegExMatch(ASBvaluesJSON, DinoClass)

	

	FoundPosC := RegExMatch(ASBvaluesJSON, "s)""colors"":(.+?)""taming""", Match, FoundPosExport)
	Colors := Match1

	FoundPosC := 1
	ExportColorHTML := ""
	Loop, 6 {
		i := A_Index-1

		FoundPosC := RegExMatch(Colors, "s)(name|null)", Match, FoundPosC+1)
		if (FoundPosC){
			Colors%A_Index%Bool := Match1 = "null" ? 0 : 1
		}



		if (Colors%A_Index%Bool || ASBvaluesJSON=""){
			IniRead, Color%i%, %LatestFile%, Colorization, ColorSet[%i%]
			FoundPos%A_Index% := RegExMatch(Color%i%, "\(R=(.+?),G=(.+?),B=(.+?),A=(.+?)\)" , ColorMatch%A_Index%)
			Alpha := ColorMatch%A_Index%4=0 || ColorMatch%A_Index%4=1 ? 1.0 : ColorMatch%A_Index%4

			Color%A_Index%Rd := round(255*ColorMatch%A_Index%1**0.456)
			Color%A_Index%Gd := round(255*ColorMatch%A_Index%2**0.456)
			Color%A_Index%Bd := round(255*ColorMatch%A_Index%3**0.456)
			

			Color%A_Index%R := FHex(Color%A_Index%Rd, 2)
			Color%A_Index%G := FHex(Color%A_Index%Gd, 2)
			Color%A_Index%B := FHex(Color%A_Index%Bd, 2)
			Color%A_Index%Hex := substr(Color%A_Index%R,3) substr(Color%A_Index%G,3) substr(Color%A_Index%B,3)
		
			;Color%A_Index%R2 := FHex(round(255-255*ColorMatch%A_Index%1**0.456), 2)
			;Color%A_Index%G2 := FHex(round(255-255*ColorMatch%A_Index%2**0.456), 2)
			;Color%A_Index%B2 := FHex(round(255-255*ColorMatch%A_Index%3**0.456), 2)
			;Color%A_Index%Hex2 := substr(Color%A_Index%R2,3) substr(Color%A_Index%G2,3) substr(Color%A_Index%B2,3)

			ColorSum := ColorMatch%A_Index%1 + ColorMatch%A_Index%2*1.15 + ColorMatch%A_Index%3
			ColorBool := ColorSum<1.05

			;Tooltip, %ColorSum%`n%ColorBool%
			;Sleep 1000

			Color%A_Index%R2 := ColorBool ? "FF" : "00"
			Color%A_Index%G2 := ColorBool ? "FF" : "00"
			Color%A_Index%B2 := ColorBool ? "FF" : "00"
			Color%A_Index%Hex2 := Color%A_Index%R2 Color%A_Index%G2 Color%A_Index%B2

			CurrentIndex := A_Index
			
			ColorName := Color%A_Index%Hex
			ColorNameR := "Null"
			ColorNameG := "Null"
			ColorNameB := "Null"

			ColorNameR0 := substr(Color%A_Index%R,3)
			ColorNameR1 := Color%A_Index%Rd=255 ? "255" : Color%A_Index%Rd+1
			ColorNameR1 := substr(FHex(ColorNameR1,2),3)
			ColorNameR2 := Color%A_Index%Rd=0 ? "00" : Color%A_Index%Rd-1
			ColorNameR2 := substr(FHex(ColorNameR2,2),3)


			ColorNameG0 := substr(Color%A_Index%G,3)
			ColorNameG1 := Color%A_Index%Gd=255 ? "255" : Color%A_Index%Gd+1
			ColorNameG1 := substr(FHex(ColorNameG1,2),3)
			ColorNameG2 := Color%A_Index%Gd=0 ? "00" : Color%A_Index%Gd-1
			ColorNameG2 := substr(FHex(ColorNameG2,2),3)

			ColorNameB0 := substr(Color%A_Index%B,3)
			ColorNameB1 := Color%A_Index%Bd=255 ? "255" : Color%A_Index%Bd+1
			ColorNameB1 := substr(FHex(ColorNameB1,2),3)
			ColorNameB2 := Color%A_Index%Bd=0 ? "00" : Color%A_Index%Bd-1
			ColorNameB2 := substr(FHex(ColorNameB2,2),3)

			ColorMatch := "(" ColorNameR0 "|" ColorNameR1 "|" ColorNameR2 ")(" ColorNameG0 "|" ColorNameG1 "|" ColorNameG2 ")(" ColorNameB0 "|" ColorNameB1 "|" ColorNameB2 ")" 

			;DebugInfo := ColorNameR0 "|" ColorNameG0 "|" ColorNameB0 "-" ColorNameR1 "|" ColorNameG1 "|" ColorNameB1 "-" ColorNameR2 "|" ColorNameG2 "|" ColorNameB2 
			;GoSub, UpdateDebug
			;Sleep 8000
			Loop % ColorIDs.MaxIndex()
			{
				FoundPos := RegexMatch(ColorIDs[A_Index], "i)(.+?)\t\t\t\t\t(.+?)\t\t\t\t\t" Color%CurrentIndex%Hex, Match)
				if (FoundPos)
				{
					ColorName := Match2
					break
				}else{
					FoundPos := RegexMatch(ColorIDs[A_Index], "i)(.+?)\t\t\t\t\t(.+?)\t\t\t\t\t" ColorMatch "$", Match)
					if (FoundPos){
						ColorName := Match2
						break
					}
				}
			}
			ExportColorHTML := ExportColorHTML "`r`n`t<td>`r`n`t`t<button style=""background-color:#" Color%A_Index%Hex ";color:#" Color%A_Index%Hex2 ";border:none"" title=""" ColorName """ disabled>" i "</button>`r`n`t</td>`r`n"
		}
	}
	ExportHTML := ExportHTML "`r`n`r`n<tr>`r`n<td colspan=""20"" align=""center"">`t`n<table>`r`n<tr>" ExportColorHTML "`r`n</tr>`r`n</table>`r`n</td>`r`n</tr>`r`n"





	FoundPos2 := RegExMatch(ASBvaluesJSON, "s)""gestationTime"": ([0-9.]{1,20}).+?""incubationTime"": ([0-9.]{1,20}).+?""maturationTime"": ([0-9.]{1,20})", Match, FoundPosExport)
	GestationTime := Match1
	IncubationTime := Match2
	MaturationTime := Match3
	

	ExportHTML := ExportHTML "`r`n<tr>`r`n<td>`r`n`r`n"

	if (GestationTime){
		if (EggHatchSpeed){
			GestationTime := GestationTime / EggHatchSpeed
		}
		GestationTime := SecondsToString(GestationTime,1)
		;ExportHTML := ExportHTML "<tr><td>`r`n`t`tGestation Time`r`n</td>`r`n<td align=""right"">`r`n`t<table>`r`n`t" GestationTime "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
		;ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`r`n</tr>`r`n`r`n"
	}

	if (IncubationTime){
		if (EggHatchSpeed){
			IncubationTime := IncubationTime / EggHatchSpeed
		}
		IncubationTime := SecondsToString(IncubationTime,1)
		;ExportHTML := ExportHTML "<tr><td>`r`n`t`tIncubation Time`r`n</td>`r`n<td align=""right"">`r`n`t<table>`r`n`t" IncubationTime "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
		;ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`r`n</tr>`r`n`r`n"
	}	


	if (MaturationTime){
		if (BabyMatureSpeed){
			MaturationTime := MaturationTime / BabyMatureSpeed
		}

		if (BabyAge<1.0){
			if (BabyAge<0.1){
				BabySpecialPercentage := 0.117 + 0.825*BabyAge + 0.0597*BabyAge*BabyAge


				CreatureBaseFoodRate := CreatureMultFoodRate := 0
				FoundPos2 := RegExMatch(ASBvaluesJSON, "s)""foodConsumptionBase"": ([0-9.]{1,20}).+?""foodConsumptionMult"": ([0-9.]{1,20})", Match, FoundPosExport)

				CreatureBaseFoodRate := Match1 ;;;;Same values ASB & Crumple
				CreatureMultFoodRate := Match2 ;;;;;not used???
				

				
				if (CrumpleCornFile){
					FoundPos := RegexMatch(CrumpleCornFile, "i)" DinoNameTag "|" DinoNameTag2)
					CreatureType := "Carnivore"
					FoodType := "Raw Meat"

					FoundPos2 := RegExMatch(CrumpleCornFile, "s)\ttype: ""([A-z]{1,20})""", Match, FoundPos)
					CreatureType := Match1
					CreatureBabyFoodRate := InStr(DinoNameTag, "Giganto") ? 45.0 : 25.5
					CreatureExtraBabyFoodRate := 20.0

					CreatureMaxFoodRate := CreatureBaseFoodRate*CreatureBabyFoodRate*CreatureExtraBabyFoodRate

					if (DinoNameTag="Daedon")
						FoodType := "Cooked Meat"
					else if (DinoNameTag="Kangaroo")
						FoodType := "Rare Mushroom"
					else if (CreatureType="Carnivore")
						FoodType := "Raw Meat"
					else if (CreatureType="Herbivore")
						FoodType := "Mejoberry"
					else if (CreatureType="Omnivore")
						FoodType := "Mejoberry"
					else if (CreatureType="Microraptor")
						FoodType := "Rare Flower"
					else if (CreatureType="Carrion")
						FoodType := "Spoiled Meat"
					else if (CreatureType="Piscivore")
						FoodType := "Raw Fish Meat"
					else if (CreatureType="Blood")
						FoodType := "Blood Pack"
					else if (CreatureType="Seed")
						FoodType := "Plant Y Seed"
					else if (CreatureType="Ambergris")
						FoodType := "Ambergris"
					else 
						FoodType := "Raw Meat"


					FoundPos3 := RegExMatch(CrumpleCornFile, "s)'" FoodType "'.+?food: ([0-9.*]{0,20}).+?stack: ([0-9.*]{0,20}).+?spoil: ([0-9.*]{0,20}).+?weight: ([0-9.*]{0,20}).+?waste: ([0-9.*]{0,20})", Match)
					if (FoundPos3){
						FoodTypeAmount := Match1
						FoodTypeStack := Match2
						FoodTypeSpoil := Match3
						FoodTypeWeight := Match4
						FoodTypeWaste := Match5

						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
						ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`r`n</tr>`r`n`r`n"
						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

						;HandFeedFood := round((FoodTypeWeight*MaturationTime)/(10*Weight*FoodTypeAmount+10*FoodTypeWeight*MaturationTime),1)
						;ExportHTML := ExportHTML "<tr><td>`r`n`t`tTotal Food to Juvi`r`n</td>`r`n<td colspan=""100"" align=""right"">`r`n`t`t" HandFeedFood " " FoodType "`r`n</td>`r`n</tr>`r`n"
						

						



						HandFeedMaturation := round(100*(FoodTypeWeight*CreatureMaxFoodRate*MaturationTime)/(10*Weight*FoodTypeAmount+10*FoodTypeWeight*CreatureMaxFoodRate*MaturationTime),2)
						ExportHTML := ExportHTML "<tr><td>`r`n`t`tHand Feed Until`r`n</td>`r`n<td colspan=""100"" align=""right"">`r`n`t`t" HandFeedMaturation " %`r`n</td>`r`n</tr>`r`n"


						HandFeedMaturation2 := round(HandFeedMaturation - (100*(Food*BabyAge)/CreatureMaxFoodRate/MaturationTime),2)
						ExportHTML := ExportHTML "<tr><td>`r`n`t`tHand Feed Until`r`n</td>`r`n<td colspan=""100"" align=""right"">`r`n`t`t" HandFeedMaturation2 " %`r`n</td>`r`n</tr>`r`n"

						Assumed := FoundPos ? "" : " (Assumed)"
						ExportHTML := ExportHTML "<tr><td>`r`n`t`tFood Type" Assumed "`r`n</td>`r`n<td colspan=""100"" align=""right"">`r`n`t`t" FoodType "`r`n</td>`r`n</tr>`r`n"

						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
						ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`r`n</tr>`r`n`r`n"
						;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


						ExportHTML := ExportHTML "<tr><td>`r`n`t`tFood Consumption Rate`r`n</td>`r`n<td align=""right"">`r`n`t`t" round(CreatureMaxFoodRate,2) " (f/s)`r`n</td>`r`n</tr>`r`n"

						if (BabyAge<HandFeedMaturation){
							;CurrentTimeMaxFood := (FoodTypeAmount*floor((Weight*BabyAge)/FoodTypeWeight))/CreatureMaxFoodRate + (food*BabySpecialPercentage)/CreatureMaxFoodRate
							CurrentTimeMaxFood := (FoodTypeAmount*floor((Weight*BabyAge)/FoodTypeWeight))/CreatureMaxFoodRate
							

							ExportHTML := ExportHTML "<tr><td>`r`n`t`tCurrent Weight Time`r`n</td>`r`n<td align=""right"">`r`n`t<table>`r`n`t`t" SecondsToString(CurrentTimeMaxFood,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
						}
					}
				}

				ExportHTML := ExportHTML "<tr><td>`r`n`t`tJuvenile Remaining`r`n</td>`r`n<td align=""right"">`r`n`t<table>`r`n`t`t" SecondsToString(MaturationTime*(0.1-BabyAge),1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
				
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`r`n</tr>`r`n`r`n"
				;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

				ExportHTML := ExportHTML "<tr><td>`r`n`t`tJuvenile Time`r`n</td>`r`n<td align=""right"">`r`n`t<table>`r`n`t`t" SecondsToString(MaturationTime*0.1,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
			}
			ExportHTML := ExportHTML "<tr><td>`r`n`t`tMaturation Remaining`r`n</td>`r`n<td align=""right"">`r`n`t<table>`r`n`t`t" SecondsToString((1.0-BabyAge)*MaturationTime,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"

		}
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ExportHTML := ExportHTML "`r`n<tr>`r`n`t<td colspan=""2"" style=""border-top:solid 2px""></td>`r`n</tr>`r`n`r`n"
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		if (BabyAge<1.0)
			ExportHTML := ExportHTML "<tr><td>`r`n`t`tCurrent Maturation`r`n</td>`r`n<td colspan=""100"" align=""right"">`r`n`t`t" round(BabyAge*100,2) " %`r`n</td>`r`n</tr>`r`n"


		ExportHTML := ExportHTML "<tr><td>`r`n`t`tMaturation Time`r`n</td>`r`n<td align=""right"">`r`n`t<table>`r`n`t`t" SecondsToString(MaturationTime,1) "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
	}
	

	if (GestationTime){
		ExportHTML := ExportHTML "<tr><td>`r`n`t`tGestation Time`r`n</td>`r`n<td align=""right"">`r`n`t<table>`r`n`t" GestationTime "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
	}

	if (IncubationTime){
		ExportHTML := ExportHTML "<tr><td>`r`n`t`tIncubation Time`r`n</td>`r`n<td align=""right"">`r`n`t<table>`r`n`t" IncubationTime "`r`n`t</table>`r`n</td>`r`n</tr>`r`n"
	}	



	ExportHTML := ExportHTML "`r`n</table>`r`n</td>`r`n</tr>`r`n`r`n`r`n"



	ExportHTML := ExportHTML "`r`n<tr>`r`n<td colspan=""20"" align=""right"">`r`n`t<input type=""submit"" value=""Last Export"">`r`n</td>`r`n</tr>`r`n"

	HTMLDisplay.document.getElementById("DinoExportTable").innerHTML := ExportHTML
	;Clipboard := HTMLDisplay.document.getElementById("DinoExportTable").innerHTML
	HTMLDisplay.document.getElementById("DinoExportContent").style.display := "block"
	HTMLDisplay.document.getElementById("DinoExportArrow").src := A_ScriptDir "\Captures\Arrow1.png"

	Exporting := 0
return




ResetFWCounters:
	LastEat := LastDrink := A_Now
	DrinkTime := EatTime := 1
	GoSub, UpdateFWdisp
return

SetDefaultCounters:
	IniWrite, %DefaultFoodDelay%, %FileSettings%, Main, FoodDelay
	IniWrite, %DefaultWaterDelay%, %FileSettings%, Main, WaterDelay

	WaterDelay := DefaultWaterDelay
	FoodDelay := DefaultFoodDelay

	HTMLDisplay.document.getElementById("WaterDelay").value := WaterDelay
	HTMLDisplay.document.getElementById("FoodDelay").value := FoodDelay

	DrinkTimeDisp := SecondsToString(WaterDelay,0)
	EatTimeDisp := SecondsToString(FoodDelay,0)

	GoSub, UpdateFWdisp
return

UpdateFWdisp:
	FoodWaterDispStr := "Food Time: " EatTimeDisp "  Drink Time: " DrinkTimeDisp
	HTMLDisplay.document.getElementById("WaterTimer").value := DrinkTimeDisp
	HTMLDisplay.document.getElementById("FoodTimer").value := EatTimeDisp
return

AutoClickHotkeyFunction:
	if (WinActive("ahk_class UnrealWindow")){
		
		HTMLDisplay.document.getElementById("AutoClickContent").style.display := "block"
		HTMLDisplay.document.getElementById("AutoClickArrow").src := A_ScriptDir "\Captures\Arrow1.png"
		AutoClickEnabled := AutoClickEnabled ? 0 : 1
		if (AutoClickEnabled && !QTinProgress){
			AutoClickTimer := AutoClickHoldDelay ? AutoClickSpamDelay + AutoClickHoldDelay : AutoClickSpamDelay
			if (AutoClickTimer!="0")
				SetTimer, AutoClickFunction, %AutoClickTimer%
			Else
				Send {%AutoClickKey% down}
			CurrentlySpamming := 1
		}else{
			SetTimer, AutoClickFunction, Off
			CurrentlySpamming := 0
			if (AutoClickHoldDelay!="0" || AutoClickTimer="0")
				Send {%AutoClickKey% up}
		}
	}
return

AutoClickFunction:
	if (WinActive("ahk_class UnrealWindow")){
		if ((AutoClickKey="t" && CheckInv()) || AutoClickKey!="t"){
			if (AutoClickHoldDelay="0")
				Send {%AutoClickKey%}
			else {
				Send {%AutoClickKey% down}
				Sleep AutoClickHoldDelay
				Send {%AutoClickKey% up}
			}
		}
	}
return


WatchingForSlotCap:
	if (WinActive("ahk_class UnrealWindow")){
		if (QTFromYou)
			ImageSearch, BlackBoxX, BlackBoxY, 0.75*A_ScreenWidth, 0.75*A_ScreenHeight, A_ScreenWidth, A_ScreenHeight, *1 %BlackBox2% 
		else
			ImageSearch, BlackBoxX, BlackBoxY, 0.75*A_ScreenWidth, 0, A_ScreenWidth, 0.25*A_ScreenHeight, *1 %BlackBox1% 


		if (BlackBoxX || BlackBoxY){
			if (!QTinProgress){
				QTinProgress := 1
				GoSub, QTHotkeyFunction
			}
		}
	}
return


QTHotkeyFunction:

	if (QTCheck && WinActive("ahk_class UnrealWindow"))
	{
		HTMLDisplay.document.getElementById("QTContent").style.display := "block"
		HTMLDisplay.document.getElementById("QTArrow").src := A_ScriptDir "\Captures\Arrow1.png"


		QTinProgress := 1
		SetTimer, WatchingForSlotCap, Off

		if (CurrentlySpamming)
			SetTimer, AutoClickFunction, Off
		

		if (GachaQT){

			if (!CheckInv()){
				if(GachaDump)
					Send {f}
				else
					Send {i}
			}
			CheckInvI=1
			While (!CheckInv() && CheckInvI<1000)
			{
				CheckInvI++
				Sleep 5
			}
			
			
			if (CheckInv()){

				QTX1 := YourSearchX
				QTY1 := YourSearchY

				QTX2 := YourDropAllX
				QTY2 := YourDropAllY

				QTSearch2 := "pr,ra"


				QTSearchArr := StrSplit(QTSearch2, ",")
				Loop %	QTSearchArr.MaxIndex(){
					QTSearchStr := QTSearchArr[A_Index]
					if (StrLen(QTSearchStr)>0){
						MouseClick, Left, QTX1, QTY1, 2, 3
						Sleep 30
						if (CheckInv())
							Send %QTSearchStr%
						Else
							break
						Sleep 30
						MouseClick, Left, QTX2, QTY2, 2, 3
					}
					Sleep %QTDelay%
				}
				Sleep 30


				QTSearchStr2 := "gacha"

				MouseClick, Left, QTX1, QTY1, 2, 3
				Sleep 30
				if (CheckInv())
					Send %QTSearchStr2%
				Else
					return


				SlotInc := A_ScreenWidth=1920 ? 93 : 82
				MouseClick, Left, A_ScreenWidth/2, A_ScreenHeight/2
				Sleep 10


				ImagePath := A_ScriptDir "\Captures\GachaCrystal.png"
				ImageSearch, GCX, GCY, 0, 0, 0.5*A_ScreenWidth, A_ScreenHeight, *2 %ImagePath% 
				
				While (ErrorLevel=0 && WinActive("ahk_class UnrealWindow"))
				{
					CurrentSlotX := YourTransferSlotX - 2*SlotInc
					CurrentSlotY := YourTransferSlotY

					Loop, 1 {	;;;N Rows
						CurrentSlotX := YourTransferSlotX - 2*SlotInc
						Loop, 6 {	;;;N Columns
							
							MouseMove, %CurrentSlotX%, %CurrentSlotY%, 1
							;Sleep 5
							Send {e 4}

							CurrentSlotX := CurrentSlotX+SlotInc
							;Sleep 15
						}



						CurrentSlotY := CurrentSlotY+SlotInc
					}
					ImageSearch, GCX, GCY, 0, 0, 0.5*A_ScreenWidth, A_ScreenHeight, *2 %ImagePath% 
				}
				
				Sleep 30

				if (WinActive("ahk_class UnrealWindow")){
					if (GachaDump){
						MouseClick, Left, YourTransferAllX, YourTransferAllY, 3, 5
					}else{

						CurrentSlotX :=	YourSearchX + 3*SlotInc
						CurrentSlotY :=	YourSearchY	- SlotInc/2
						MouseClick, Left, CurrentSlotX, CurrentSlotY, 2, 3
						Sleep 30

						MouseClick, Left, YourSearchX, YourSearchY, 2, 3
						Sleep 30

						QTSearchStr2 := "element"
						if (CheckInv())
							Send %QTSearchStr2%
						Else
							return
						Sleep 30

						CurrentSlotX := YourTransferSlotX - SlotInc
						MouseClick, Left, %CurrentSlotX%, %YourTransferSlotY%
						Sleep 30

						Send {a 5}
					}
				}

				if (CheckInv() && WinActive("ahk_class UnrealWindow")){
					Send {Esc}
				}
			}	
		}else{	

			if (!CheckInv()){
				if(QTFromYou && QTDrop)
					Send {i}
				else
					Send {f}
			}
			CheckInvI := 1
			While (!CheckInv() && CheckInvI<1000)
			{
				CheckInvI++
				Sleep 5
			}
			
			
			if (CheckInv() && WinActive("ahk_class UnrealWindow")){
				if (QTFromYou){
					QTX1 := YourSearchX
					QTY1 := YourSearchY
					QTX2 := QTDrop ? YourDropAllX : YourTransferAllX
					QTY2 := QTDrop ? YourDropAllY : YourTransferAllY
				}else{
					QTX1 := TheirSearchX
					QTY1 := TheirSearchY
					QTX2 := QTDrop ? TheirDropAllX : TheirTransferAllX
					QTY2 := QTDrop ? TheirDropAllY : TheirTransferAllY
				}			
				
				if (InStr(QTSearch,",")){
					QTSearchArr := StrSplit(QTSearch, ",")
					Loop %	QTSearchArr.MaxIndex(){
						QTSearchStr := QTSearchArr[A_Index]
						if (StrLen(QTSearchStr)>0){
							MouseMove, QTX1, QTY1, 3
							Sleep 100
							MouseClick, Left,,, 2
							Sleep 200
							if (CheckInv())
								Send %QTSearchStr%
							Else
								return
							Sleep 150
							MouseClick, Left, QTX2, QTY2, 1, 3
							Sleep 25
							MouseMove, QTX1, QTY1, 0
						}
						Sleep %QTDelay%
					}
				}else{
					MouseMove, QTX1, QTY1, 3
					Sleep 100
					MouseClick, Left,,, 2
					Sleep 200
					if (CheckInv())
						Send %QTSearch%
					Else
						return
					Sleep 150
					MouseClick, Left, QTX2, QTY2, 1, 3
					Sleep 25
					MouseMove, QTX1, QTY1, 0
				}
				Sleep 60
				if(QTFromYou && QTDrop)
					Send {i}
				else
					Send {f}
			}
		}

		if (CurrentlySpamming){
			SetTimer, AutoClickFunction, %AutoClickSpamDelay%
		}
	
		QTinProgress := 0
		if (AutoQTSlotCap){
			SetTimer, WatchingForSlotCap, %AutoQTCapDelayMS%
		}
	}
return

FeedBabiesHotkeyFunction:
	if (WinActive("ahk_class UnrealWindow")){
		FeedBabiesEnabled := FeedBabiesEnabled ? 0 : 1
		FeedBabiesDispStr := ""
	}
return



ChooseServer:
	URL := "https://www.battlemetrics.com/servers/search?q=" ServerString "&game=ark&sort=score&features%5B2e079b9a-d6f7-11e7-8461-83e84cedb373%5D=true"
	Loop{
		Process, Close, iexplore.exe
		Process, Exist, iexplore.exe
	}	Until	!ErrorLevel
	
	hObject := ComObjCreate("InternetExplorer.Application")
	hObject.Visible := 0
	hObject.Silent := 1
	hObject.Navigate(URL)

	while hObject.readyState!=4 || hObject.document.readyState != "complete" || hObject.busy
		sleep 10
	
	Links := hObject.Document.getElementsbyTagName("a")
	Loop % Links.Length
	{	
		FoundPos := RegexMatch(Links[A_Index-1].outerHTML, "href=""/servers/ark/([0-9]{1,8})""", Match)
		if (FoundPos>0){
			URL := "https://www.battlemetrics.com/servers/ark/" Match1
			break
		}
	}
	hObject.Navigate(URL)
	while hObject.readyState!=4 || hObject.document.readyState != "complete" || hObject.busy
		sleep 10
	GoSub, UpdateServerInfo
	ServerRefreshMS := ServerRefresh * 1000
	SetTimer, UpdateServerInfo, %ServerRefreshMS%

	HTMLDisplay.document.getElementById("ServerInfoContent").style.display := "block"
	HTMLDisplay.document.getElementById("ServerInfoArrow").src := A_ScriptDir "\Captures\Arrow1.png"
return

UpdateServerInfo:
	hObject.refresh()
	
	while hObject.readyState!=4 || hObject.document.readyState != "complete" || hObject.busy
		sleep 10
		
	global ServerHTML
	try ServerHTML := hObject.Document.All.Tags("body")[0].OuterHTML
	ServerHTML := RegexReplace(ServerHTML, "&lt;", "<")
	ServerHTML := RegexReplace(ServerHTML, "&gt;", ">")
	
	FoundPos := RegexMatch(ServerHTML, "href=""\/servers\/ark\/[0-9]{1,10}"".+?>(.+?)<", Match)
	if (FoundPos>0)
		ServerName := substr(Match1, 1, InStr(Match1, " - "))

	FoundPos := RegexMatch(ServerHTML, "<dt>Player count</dt><dd>([0-9/]{1,7})</dd>", Match)
	if (FoundPos>0)
		PlayerCount := Match1
	
	FoundPos := RegexMatch(ServerHTML, "<div class=""collapse"">(.+?)</div></div>", Match)
	if (FoundPos>0){
		ServerLog := Match1
		ServerLog := RegexReplace(ServerLog, "<div.+?>|</div>", "")
		ServerLog := RegexReplace(ServerLog, "<span.+?>", "`r`n`r`n<tr>`r`n<td>`r`n")
		ServerLog := RegexReplace(ServerLog, "</span>", "`r`n</td>")
		ServerLog := RegexReplace(ServerLog, "<time.+?>", "`r`n<td>`r`n")
		ServerLog := RegexReplace(ServerLog, "</time>", "`r`n</td>`r`n</tr>")
		ServerLog := RegexReplace(ServerLog, "minute?s", "min")
		ServerLog := RegexReplace(ServerLog, "second?s", "sec")
		ServerLog := RegexReplace(ServerLog, " the game")
	}
	ServerHTML := "<table><tr><th colspan=""2"">" ServerName "</th></tr><tr><th colspan=""2"">Players " PlayerCount "</th></tr>" ServerLog "`r`n`r`n</table>"

	FoundPos1 := inStr(ServerLog, "Server failed to respond to query", 0, 1)
	FoundPos2 := inStr(ServerLog, "Server responded to query", 0, 1)
	
	ServerDownAlert := (FoundPos1<FoundPos2 && FoundPos1>0) ? 1 : 0
	ServerUpAlert := (FoundPos2<FoundPos1 && FoundPos1>0 && FoundPos2>0) ? 1 : 0

	GoSub, GetOfficialRates

return


GetOfficialRates:

	global req := ComObjCreate("Msxml2.XMLHTTP")
	; Open a request with async enabled.
	req.open("GET", "http://arkdedicated.com/dynamicconfig.ini", true)
	; Set our callback function [requires v1.1.17+].
	req.onreadystatechange := Func("Ready")
	; Send the request.  Ready() will be called when it's complete.
	req.send()

return


Ready() {

    if (req.readyState != 4)  ; Not done yet.
        return
    if (req.status == 200){ ; OK.
        global OfficialRates := req.responseText

        OfficialRates := RegExReplace(OfficialRates, "[A-z:]{1,}=[A-z:]{1,}")

        OfficialRates := RegExReplace(OfficialRates, "`r`n", "</td></tr>`n<tr><td>")
        OfficialRates := RegExReplace(OfficialRates, "=", ":</td><td>")
        OfficialRates := RegExReplace(OfficialRates, "Multiplier")

        OfficialRates := "<table width=""100%"">`n<tr><th colspan=""2"">Current Official Rates</th></tr>`n<tr><td>" OfficialRates "</td></tr>`n</table>"

		FoundPos := RegexMatch(OfficialRates, "BabyMatureSpeed:</td><td>([0-9.]{1,10})</td>", Match)
		global BabyMatureSpeed := Match1

		FoundPos := RegexMatch(OfficialRates, "EggHatchSpeed:</td><td>([0-9.]{1,10})</td>", Match)
		global EggHatchSpeed := Match1

		

        HTMLDisplay.document.getElementById("serverhtml").innerHTML := "<table><tr><td colspan=""100"">" OfficialRates "</td></tr><tr><td colspan=""100"" style=""border-top:solid 2px""></td></tr><tr><td>" ServerHTML "</td></tr></table>"
	}

}

HookProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime ){
	if event = 4
		 s := "Menu start"
	else if event = 5 
		 s := "Menu close"
	else if event = 10
		 s := "Moving started"
	else {
		s := "Moving stoped"
		GoSub, SaveWindowPos
	}
	;tooltip, %event%
}

API_SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
	DllCall("CoInitialize", "uint", 0)
	return DllCall("SetWinEventHook", "uint", eventMin, "uint", eventMax, "uint", hmodWinEventProc, "uint", lpfnWinEventProc, "uint", idProcess, "uint", idThread, "uint", dwFlags)
}

SaveWindowPos:
	WinGetPos, GX, GY, GW, GH, ahk_id %MainHwnd%
	if(GX!=-32000 && GY!=-32000){

		GW2 := GW - 16
		GH2 := GH - 39

		IniWrite, %GX%, %FileSettings%, Main, WindowX
		IniWrite, %GY%, %FileSettings%, Main, WindowY
		IniWrite, %GW2%, %FileSettings%, Main, WindowW
		IniWrite, %GH2%, %FileSettings%, Main, WindowH

		TitleBarX := ButtonW+8
		TitleBarY := 2
		TitleBarW := GW-ButtonW*4-6
		TitleBarH := 30
		ButtonX1 := GW-ButtonW
		ButtonX2 := ButtonX1-ButtonW
		ButtonX3 := ButtonX2-ButtonW
		ButtonX4 := ButtonX3-ButtonW
		HTMLx := 4
		HTMLy := TitleBarH
		HTMLw := GW-HTMLx*2
		HTMLh := GH-HTMLy*1.25

		GuiControl, Move, Mover, X%TitleBarX% Y%TitleBarY% W%TitleBarW% H%TitleBarH%
	    GuiControl, Move, HTMLDisplay, X%HTMLx% Y%HTMLy% W%HTMLw% H%HTMLh%

	    GuiControl, +Redraw, CloseButton
	    GuiControl, Move, CloseButton, X%ButtonX1%

	    GuiControl, +Redraw, MinButton
	    GuiControl, Move, MinButton, X%ButtonX2%

	    GuiControl, +Redraw, RestartButton
	    GuiControl, Move, RestartButton, X%ButtonX3%

		
	    HTMLDisplay.document.getElementsByTagName("table")[0].style.width := GW - 25 "px"
		

		;AllTables := HTMLDisplay.document.getElementsByTagName("table")
		try AllTables := HTMLDisplay.document.getElementsByClassName("tablecontent")
		Loop % AllTables.Length
		{
			Index := A_Index-1
			AllTables[Index].style.width := GW - 50 "px"
		}
		AllTables := ""

		
		if (!ClosingApp){
			HTMLDisplay.document.getElementById("SplashImage").src := SplashImagePath "?" A_Now
			GoSub, MakeSplashImage
		}
		
		HTMLDisplay.document.getElementById("SplashImage").width := GW-65
		HTMLDisplay.document.getElementById("SplashImage").height := GW-65

		
	}
return

ActivateMainWindow:
	WinGetPos, GX, GY, GW, GH, ahk_id %MainHwnd%
	;Tooltip, %GX%`n%GY%`n%GW%`n%GH%
	if(GX=-32000 || GY=-32000 || GW=0 || GH=0){
		WinRestore, Ark AIO
		WinActivate, Ark AIO
	}else{
		WinMinimize, Ark AIO
	}
return

ExitSub:
	ClosingApp := 1
	if (FileExist(FileSettings))
		GoSub, SaveWindowPos
	ExitApp
return

ReloadSub:
	ClosingApp := 1
	if (FileExist(FileSettings))
		GoSub, SaveWindowPos
	Reload
return

MakeSound:
	if (AlertAltSound){
		SetDefaultEndpoint( GetDeviceID(Devices, SoundOutput) )
	}else{
		SetDefaultEndpoint( GetDeviceID(Devices, SoundDefault) )
	}
	
	if (FileExist(SoundFile ".mp3")){
		SoundPlay, %SoundFile%.mp3, 1
	}else{
		oVoice.Speak(SoundFile)
	}
	SetDefaultEndpoint( GetDeviceID(Devices, SoundDefault) )
return


SecondsToString(InputTime, HTMLbool){

	OutputTime := round(InputTime)

	OutputTimeD := OutputTime/60/60/24
	OutputTimeH := (OutputTimeD - floor(OutputTimeD))*24
	OutputTimeM := (OutputTimeH - floor(OutputTimeH))*60
	OutputTimeS := (OutputTimeM - floor(OutputTimeM))*60
	
	OutputTimeDDisp := floor(OutputTimeD)
	OutputTimeHDisp := floor(OutputTimeH)
	OutputTimeMDisp := floor(OutputTimeM)
	OutputTimeSDisp := floor(OutputTimeS)

	if (HTMLbool){
		OutputTimeDDisp := OutputTimeDDisp != "" && OutputTimeDDisp != 0 ? "<td align=""right"">" OutputTimeDDisp "d</td>" : "<td align=""right""></td>"
		OutputTimeHDisp := OutputTimeHDisp != "" && OutputTimeHDisp != 0 ? "<td align=""right"">" OutputTimeHDisp "h</td>" : "<td align=""right""></td>"
		OutputTimeMDisp := OutputTimeMDisp != "" && OutputTimeMDisp != 0 ? "<td align=""right"">" OutputTimeMDisp "m</td>" : "<td align=""right""></td>"
		OutputTimeSDisp := OutputTimeSDisp != "" && OutputTimeSDisp != 0 ? "<td align=""right"">" OutputTimeSDisp "s</td>" : "<td align=""right"">0s</td>"
	}else{
		OutputTimeDDisp := OutputTimeDDisp != "" && OutputTimeDDisp != 0 ? OutputTimeDDisp "d " : ""
		OutputTimeHDisp := OutputTimeHDisp != "" && OutputTimeHDisp != 0 ? OutputTimeHDisp "h " : ""
		OutputTimeMDisp := OutputTimeMDisp != "" && OutputTimeMDisp != 0 ? OutputTimeMDisp "m " : ""
		OutputTimeSDisp := OutputTimeSDisp != "" && OutputTimeSDisp != 0 ? OutputTimeSDisp "s" : "0s"
	}
	OutputTime := OutputTimeDDisp OutputTimeHDisp OutputTimeMDisp OutputTimeSDisp

	return OutputTime
}


ParseHotkey(HotkeyInput){
	;;SoundBeep


	HotkeyOutput := HotkeyInput


	;;HotkeyOutput := RegExReplace(HotkeyOutput, "2B", "+")
	HotkeyOutput := RegExReplace(HotkeyOutput, "%2B", "+")
	HotkeyOutput := RegExReplace(HotkeyOutput, "%21", "!")
	HotkeyOutput := RegExReplace(HotkeyOutput, "%5e", "^")
	HotkeyOutput := RegExReplace(HotkeyOutput, "%26", "&")
	;;HotkeyOutput := RegExReplace(HotkeyOutput, "%7E", "~")
	HotkeyOutput := RegExReplace(HotkeyOutput, "%7E")
	HotkeyOutput := RegExReplace(HotkeyOutput, "%24", "$")



	HotkeyOutput := RegExReplace(HotkeyOutput,"i)lmb|lbutton|mouse1", "LButton")

	HotkeyOutput := RegExReplace(HotkeyOutput,"i)rmb|rbutton|mouse2", "RButton")

	HotkeyOutput := RegExReplace(HotkeyOutput,"i)xbutton1|mouse3|thumbmousebutton1", "XButton1")
	HotkeyOutput := RegExReplace(HotkeyOutput,"i)xbutton2|mouse4|thumbmousebutton2", "XButton2")
	

	;;HotkeyOutput := "Test"
	;;Tooltip, %HotkeyInput%`n%HotkeyOutput%


	Return HotkeyOutput
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
	;Tooltip, %NewURL%
	;Sleep 1500
	if (RegexMatch(NewURL,"(QT|AutoClick)Preset/([0-9]{1,})$", Match)){
		SoundBeep
		if (Match2!="0"){
			SetPreset(Match1, Match2)
		}
	}
	else if (RegexMatch(NewURL,"(QT|AutoClick)RemovePreset", Match)){
		PresetNumber := HTMLDisplay.document.getElementById(Match1 "PresetNumber").value ? HTMLDisplay.document.getElementById(Match1 "PresetNumber").value : PresetNumber
		if (PresetNumber)
			UpdatePresetSlots(Match1,"-1",PresetNumber)
	}else if (InStr(NewURL,"TestSound")){
		SoundFile := "Testing 1 2 3"
		GoSub, MakeSound

	}else if (InStr(NewURL,"ResetTimersFW")){

		GoSub, ResetFWCounters

	}else if (InStr(NewURL,"DefaultTimersFW")){

		GoSub, SetDefaultCounters

	}else if (InStr(NewURL,"ExportNow")){

		GoSub, DinoExportFunction

	}else if (InStr(NewURL,"Check")){

		if (InStr(NewURL,"Alerts")){
			AlertsCheck := InStr(NewURL,"checked=true") ? 1 : 0
			if (AlertsCheck)
				SetTimer, AlertsFunction, %AlertsDelayMS%
			Else
				SetTimer, AlertsFunction, Off
			IniWrite, %AlertsCheck%, %FileSettings%, Main, AlertsCheck
		}
		else if (InStr(NewURL,"AutoClick")){
			if (InStr(NewURL,"checked=true")){
				AutoClickCheck := 1
				if (AutoClickToggle)
					Hotkey, ~%AutoClickHotkey%, AutoClickHotkeyFunction, on
			}else {
				AutoClickCheck := 0
				Hotkey, %AutoClickHotkey%, AutoClickHotkeyFunction, off
			}
			IniWrite, %AutoClickCheck%, %FileSettings%, Main, AutoClickCheck
		}
		else if (InStr(NewURL,"AutoFoodWater")){
			AutoFoodWaterCheck := InStr(NewURL,"checked=true") ? 1 : 0
			if (AutoFoodWaterCheck)
				SetTimer, FoodWaterFunction, 1000
			Else	
				SetTimer, FoodWaterFunction, Off
			IniWrite, %AutoFoodWaterCheck%, %FileSettings%, Main, AutoFoodWaterCheck
		}
		else if (InStr(NewURL,"Crosshair")){
			if(InStr(NewURL,"checked=true")){
				CrosshairCheck := 1
				GoSub, drawReticle
				ReticleDrawn := 1
			}else{
				CrosshairCheck := 0
				Gui, 6:Destroy
				ReticleDrawn := 0
			}
			IniWrite, %CrosshairCheck%, %FileSettings%, Main, CrosshairCheck
		}
		else if (InStr(NewURL,"DinoExport")){
			if(InStr(NewURL,"checked=true")){
				DinoExportCheck := 1
				SetTimer, CheckDinoExport, 1000
			}else{
				DinoExportCheck := 0
				SetTimer, CheckDinoExport, off
			}
			Exporting := 0
			IniWrite, %DinoExportCheck%, %FileSettings%, Main, DinoExportCheck
		}
		else if (InStr(NewURL,"FeedBabies")){
			if(InStr(NewURL,"checked=true")){
				FeedBabiesCheck := 1
			}else{
				FeedBabiesCheck := 0
			}
			Hotkey, ~%FeedBabiesHotkey%, FeedBabiesHotkeyFunction, %FeedBabiesCheck%
			IniWrite, %FeedBabiesCheck%, %FileSettings%, Main, FeedBabiesCheck
		}
		else if (InStr(NewURL,"Fishing")){
			if(InStr(NewURL,"checked=true")){
				FishingCheck := 1
			}else{
				FishingCheck := 0
			}
			Hotkey, ~%FishingHotkey%, FishingHotkeyFunction, %FishingCheck%
			IniWrite, %FishingCheck%, %FileSettings%, Main, FishingCheck
		}
		else if (InStr(NewURL,"QuickTransfer")){
			if(InStr(NewURL,"checked=true")){
				QTCheck := 1
				Hotkey, ~%QTHotkey%, QTHotkeyFunction, on
				if (AutoQTSlotCap){
					SetTimer, WatchingForSlotCap, %AutoQTCapDelayMS%
				}
			}else{
				QTCheck := 0
				Hotkey, %QTHotkey%, QTHotkeyFunction, off
				SetTimer, WatchingForSlotCap, off
			}
			IniWrite, %QTCheck%, %FileSettings%, Main, QTCheck
		}
		else if (InStr(NewURL,"ServerInfoCheck")){
			if(InStr(NewURL,"checked=true")){
				ServerInfoCheck := 1
				GoSub, ChooseServer
			}else{
				ServerInfoCheck := 0
				SetTimer, UpdateServerInfo, off
			}
			IniWrite, %ServerInfoCheck%, %FileSettings%, Main, ServerInfoCheck
		}
	}else{	
		if (InStr(NewURL,"UpdateSplashImage",1)){
			GoSub, MakeSplashImage
			;HTMLDisplay.document.getElementById("SplashImage").src := SplashImagePath "?" A_Now
		}else if (InStr(NewURL,"UpdateAlerts",1)){
			FoundPos := RegexMatch(NewURL, "AlertsDelay=([0-9]{1,10000})", Match)
			if(FoundPos>0){
				AlertsDelay := Match1
				AlertsDelayMS := AlertsDelay*1000
				SetTimer, AlertsFunction, %AlertsDelayMS%
				IniWrite, %AlertsDelay%, %FileSettings%, Main, AlertsDelay
			}
			if (InStr(NewURL, "AlertsInput1=on") || InStr(NewURL, "AlertsInput1=1")){
				AlertsInput1 := 1
			}else{
				AlertsInput1 := 0
			}
			IniWrite, %AlertsInput1%, %FileSettings%, Main, AlertsInput1

			if (InStr(NewURL, "AlertsInput2=on") || InStr(NewURL, "AlertsInput2=1")){
				AlertsInput2 := 1
			}else{
				AlertsInput2 := 0
			}
			IniWrite, %AlertsInput2%, %FileSettings%, Main, AlertsInput2


			if (InStr(NewURL, "AlertsInput3=on") || InStr(NewURL, "AlertsInput3=1")){
				AlertsInput3 := 1
			}else{
				AlertsInput3 := 0
			}
			IniWrite, %AlertsInput3%, %FileSettings%, Main, AlertsInput3


			if (InStr(NewURL, "AlertsInput4=on") || InStr(NewURL, "AlertsInput4=1")){
				AlertsInput4 := 1
			}else{
				AlertsInput4 := 0
			}
			IniWrite, %AlertsInput4%, %FileSettings%, Main, AlertsInput4


			if (InStr(NewURL, "AlertsInput5=on") || InStr(NewURL, "AlertsInput5=1")){
				AlertsInput5 := 1
			}else{
				AlertsInput5 := 0
			}
			IniWrite, %AlertsInput5%, %FileSettings%, Main, AlertsInput5
		
			if (InStr(NewURL, "AlertAltSound=on") || InStr(NewURL, "AlertAltSound=1")){
				AlertAltSound := 1
			}else{
				AlertAltSound := 0
			}
			IniWrite, %AlertAltSound%, %FileSettings%, Main, AlertAltSound
		

			FoundPos := RegexMatch(NewURL, "SoundOutputInput=([A-z0-9]{1,50})", Match)
			if (FoundPos){
				SoundOutput := Match1
				IniWrite, %SoundOutput%, %FileSettings%, Main, SoundOutput
			}
			FoundPos := RegexMatch(NewURL, "SoundDefaultInput=([A-z0-9]{1,50})", Match)
			if (FoundPos){
				SoundDefault := Match1
				IniWrite, %SoundDefault%, %FileSettings%, Main, SoundDefault
			}
		}
		else if (InStr(NewURL,"UpdateAutoClick",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("AutoClickHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("AutoClickHotkey").value) : AutoClickHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %AutoClickHotkey%, AutoClickHotkeyFunction, off
				AutoClickHotkey := HotkeyTemp
				HTMLDisplay.document.getElementById("AutoClickHotkey").value := AutoClickHotkey
				IniWrite, %AutoClickHotkey%, %FileSettings%, Main, AutoClickHotkey
			}
			AutoClickPresetNumber := HTMLDisplay.document.getElementById("AutoClickPresetNumber").value != "" ? HTMLDisplay.document.getElementById("AutoClickPresetNumber").value : AutoClickPresetNumber
			AutoClickPresetStr := HTMLDisplay.document.getElementById("AutoClickPresetStr").value

			AutoClickToggle := HTMLDisplay.document.getElementById("AutoClickToggle0").checked ? 1 : 0
			IniWrite, %AutoClickToggle%, %FileSettings%, Main, AutoClickToggle
			if (AutoClickToggle)
				Hotkey, ~%AutoClickHotkey%, AutoClickHotkeyFunction, on
			
			AutoClickKey := HTMLDisplay.document.getElementById("AutoClickKey").value
			IniWrite, %AutoClickKey%, %FileSettings%, Main, autoclickkey
			
			AutoClickSpamDelay := HTMLDisplay.document.getElementById("AutoClickSpamDelay").value
			IniWrite, %AutoClickSpamDelay%, %FileSettings%, Main, autoclickspamdelay
			
			AutoClickHoldDelay := HTMLDisplay.document.getElementById("AutoClickHoldDelay").value
			IniWrite, %AutoClickHoldDelay%, %FileSettings%, Main, autoclickholddelay

			UpdatePresetSlots("AutoClick",AutoClickPresetStr "||" AutoClickToggle "||" AutoClickKey "||" AutoClickSpamDelay "||" AutoClickHoldDelay,AutoClickPresetNumber)
		}
		else if (InStr(NewURL,"UpdateAutoFoodWater",1)){
			FoodKey := HTMLDisplay.document.getElementById("FoodKey").value
			IniWrite, %FoodKey%, %FileSettings%, Main, foodkey
			
			FoodDelay := HTMLDisplay.document.getElementById("FoodDelay").value
			IniWrite, %FoodDelay%, %FileSettings%, Main, fooddelay

			WaterKey := HTMLDisplay.document.getElementById("WaterKey").value
			IniWrite, %WaterKey%, %FileSettings%, Main, waterkey

			WaterDelay := HTMLDisplay.document.getElementById("WaterDelay").value
			IniWrite, %WaterDelay%, %FileSettings%, Main, WaterDelay

			if (AutoFoodWaterCheck)
				SetTimer, FoodWaterFunction, 1000
		}
		else if (InStr(NewURL,"UpdateCrosshair",1)){
			XhairD := HTMLDisplay.document.getElementById("XhairD").value!="" ? HTMLDisplay.document.getElementById("XhairD").value : XhairD
			IniWrite, %XhairD%, %FileSettings%, Main, XhairD

			XhairR := HTMLDisplay.document.getElementById("XhairR").value!="" ? HTMLDisplay.document.getElementById("XhairR").value : XhairR
			IniWrite, %XhairR%, %FileSettings%, Main, XhairR

			XhairG := HTMLDisplay.document.getElementById("XhairG").value!="" ? HTMLDisplay.document.getElementById("XhairG").value : XhairG
			IniWrite, %XhairG%, %FileSettings%, Main, XhairG

			XhairB := HTMLDisplay.document.getElementById("XhairB").value!="" ? HTMLDisplay.document.getElementById("XhairB").value : XhairB
			IniWrite, %XhairB%, %FileSettings%, Main, XhairB

			XhairOffsetX := HTMLDisplay.document.getElementById("XhairOffsetX").value!="" ? HTMLDisplay.document.getElementById("XhairOffsetX").value : XhairOffsetX
			IniWrite, %XhairOffsetX%, %FileSettings%, Main, XhairOffsetX

			XhairOffsetY := HTMLDisplay.document.getElementById("XhairOffsetY").value!="" ? HTMLDisplay.document.getElementById("XhairOffsetY").value : XhairOffsetY
			IniWrite, %XhairOffsetY%, %FileSettings%, Main, XhairOffsetY
			;Tooltip, TEST: %XhairD%`n%XhairR%`n%XhairG%`n%XhairB%`n%XhairOffsetX%`n%XhairOffsetY%`n

			GoSub, drawReticle
		}
		else if (InStr(NewURL,"UpdateFeedBabies",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("FeedBabiesHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("FeedBabiesHotkey").value) : FeedBabiesHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %FeedBabiesHotkey%, FeedBabiesHotkeyFunction, off 
				FeedBabiesHotkey := HotkeyTemp
				Hotkey, ~%FeedBabiesHotkey%, FeedBabiesHotkeyFunction, on
				IniWrite, %FeedBabiesHotkey%, %FileSettings%, Main, FeedBabiesHotkey
			}
			SpinPixels := HTMLDisplay.document.getElementById("SpinPixels").value!="" ? HTMLDisplay.document.getElementById("SpinPixels").value : SpinPixels
			IniWrite, %SpinPixels%, %FileSettings%, Main, SpinPixels
			
			SpinDir := HTMLDisplay.document.getElementById("SpinDir").value!="" ? HTMLDisplay.document.getElementById("SpinDir").value : SpinDir
			IniWrite, %SpinDir%, %FileSettings%, Main, SpinDir
		}
		else if (InStr(NewURL,"UpdateFishing",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("FishingHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("FishingHotkey").value) : FishingHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %FishingHotkey%, FishingHotkeyFunction, off 
				FishingHotkey := HotkeyTemp
				Hotkey, ~%FishingHotkey%, FishingHotkeyFunction, on
				IniWrite, %FishingHotkey%, %FileSettings%, Main, FishingHotkey
			}
		}
		else if (InStr(NewURL,"UpdateQT",1)){
			HotkeyTemp := HTMLDisplay.document.getElementById("QTHotkey").value!="" ? ParseHotkey(HTMLDisplay.document.getElementById("QTHotkey").value) : QTHotkey
			if(HotkeyTemp != "LButton" && HotkeyTemp != "RButton" && HotkeyTemp !=""){
				Hotkey, %QTHotkey%, QTHotkeyFunction, off 
				QTHotkey := HotkeyTemp
				Hotkey, ~%QTHotkey%, QTHotkeyFunction, on
				IniWrite, %QTHotkey%, %FileSettings%, Main, QTHotkey
			}

			QTPresetNumber := HTMLDisplay.document.getElementById("QTPresetNumber").value != "" ? HTMLDisplay.document.getElementById("QTPresetNumber").value : QTPresetNumber
			IniWrite, %QTPresetNumber%, %FileSettings%, Main, QTPresetNumber

			QTPresetStr := HTMLDisplay.document.getElementById("QTPresetStr").value
			IniWrite, %QTPresetStr%, %FileSettings%, Main, QTPresetStr

			QTDrop := HTMLDisplay.document.getElementById("QTDrop0").checked ? 1 : 0
			IniWrite, %QTDrop%, %FileSettings%, Main, QTDrop

			QTFromYou := HTMLDisplay.document.getElementById("QTFromYou0").checked ? 1 : 0
			IniWrite, %QTFromYou%, %FileSettings%, Main, QTFromYou

			QTDelay := HTMLDisplay.document.getElementById("QTDelay").value
			IniWrite, %QTDelay%, %FileSettings%, Main, QTDelay

			QTSearch := HTMLDisplay.document.getElementById("QTSearch").value
			QTSearch := RegexReplace(QTSearch, "%2C|%7C", ",")
			IniWrite, %QTSearch%, %FileSettings%, Main, QTSearch


			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


			GachaQT := HTMLDisplay.document.getElementById("GachaQT").checked ? 1 : 0
			IniWrite, %GachaQT%, %FileSettings%, Main, GachaQT

			GachaDump := HTMLDisplay.document.getElementById("GachaDump0").checked ? 0 : 1
			IniWrite, %GachaDump%, %FileSettings%, Main, GachaDump

			AutoQTCapDelay := HTMLDisplay.document.getElementById("AutoQTCapDelay").value
			IniWrite, %AutoQTCapDelay%, %FileSettings%, Main, AutoQTCapDelay

			AutoQTSlotCap := HTMLDisplay.document.getElementById("AutoQTSlotCap").checked ? 1 : 0
			if (AutoQTSlotCap){
				AutoQTCapDelayMS := AutoQTCapDelay*1000
				SetTimer, WatchingForSlotCap, %AutoQTCapDelayMS%
			}
			else
				SetTimer, WatchingForSlotCap, Off
			IniWrite, %AutoQTSlotCap%, %FileSettings%, Main, AutoQTSlotCap


			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


			if (!GachaQT)
				UpdatePresetSlots("QT",QTPresetStr "||" QTDrop "||" QTFromYou "||" QTDelay "||" QTSearch,QTPresetNumber)
		}
		else if (InStr(NewURL,"UpdateServer",1)){
			ServerString := HTMLDisplay.document.getElementById("ServerString").value
			IniWrite, %ServerString%, %FileSettings%, Main, ServerString
	
			ServerRefresh := HTMLDisplay.document.getElementById("ServerRefresh").value
			IniWrite, %ServerRefresh%, %FileSettings%, Main, ServerRefresh
			
			if (ServerInfoCheck)
				GoSub, ChooseServer
		}
		else if (InStr(NewURL,"UpdateTimer",1)){
			
			FoundPos := RegexMatch(NewURL,"UpdateTimer([0-9]{1,})/", Match)
			if (FoundPos){
				AlertSlot := Match1
				AlertTitle%AlertSlot% := HTMLDisplay.document.getElementById("AlertTitle" AlertSlot).value
				FinishTime%AlertSlot% := HTMLDisplay.document.getElementById("TimeRemaining" AlertSlot).value
				if (FinishTime%AlertSlot%!=""){
					HTMLDisplay.document.getElementById("TimeRemaining" AlertSlot).disabled := 1
					FoundPos := RegexMatch(FinishTime%AlertSlot%, "i)([0-9]{0,})?[ ]{0,}d", Match)
					if (FoundPos)
						EnvAdd, ActualFinishTime%AlertSlot%, Match1, Days
					FoundPos := RegexMatch(FinishTime%AlertSlot%, "i)([0-9]{0,})?[ ]{0,}h", Match)
					if (FoundPos)
						EnvAdd, ActualFinishTime%AlertSlot%, Match1, Hours
					FoundPos := RegexMatch(FinishTime%AlertSlot%, "i)([0-9]{0,})?[ ]{0,}m", Match)
					if (FoundPos)
						EnvAdd, ActualFinishTime%AlertSlot%, Match1, Minutes

					;Temp := "Test:" ActualFinishTime%AlertSlot%
					;Tooltip, %Temp%

					if (!RegexMatch(ActiveAlertSlots,"\|" AlertSlot "\|") && AlertTitle%AlertSlot%!=""){
						ActiveAlertSlots := ActiveAlertSlots AlertSlot "|"
					
					}
				}		
			}
		}
		else if (InStr(NewURL,"StopTimer",1)){
			FoundPos := RegexMatch(NewURL,"StopTimer([0-9]{1,})/", Match)
			if (FoundPos){
				AlertSlot := Match1
				ActiveAlertSlots := RegexReplace(ActiveAlertSlots, AlertSlot "\|")
				
				HTMLDisplay.document.getElementById("TimeRemaining" AlertSlot).disabled := 0


				if (HTMLDisplay.document.getElementById("TimeRemaining" AlertSlot).value="NOW")
					HTMLDisplay.document.getElementById("TimeRemaining" AlertSlot).value := "DONE"
			}
		}
		else if (InStr(NewURL,"AddAlert",1)){


			AlertSlots := AlertSlots + 1
			TempTitle := ""
			TempFinishTime := ""
			GoSub, AddAlertSlot

			
		}


	}

return

AddAlertSlot:
	if (TempFinishTime!=""){
		TempRemaining := ""
	}else
		TempRemaining := ""

	TempHTML := HTMLDisplay.document.getElementById("AlertsContent").innerHTML
	TempHTML := RegExReplace(TempHTML, "<!--LastAlert-->", "<!--StartAlert" AlertSlots "-->`n<tr>`n<td>Alert Title:</td>`n<td><input type=""text"" id=""AlertTitle" AlertSlots """ value=""" TempTitle """></td>`n</tr>`n<tr>`n<td>Time Remaining:</td>`n<td>`n<input type=""text"" value=""" TempRemaining """ id=""TimeRemaining" AlertSlots """ >`n</td>`n</tr>`n<tr>`n<td align=""center"" colspan=""2"">`n<input type=""button"" onclick=""buttonpress(this)"" name=""StopTimer" AlertSlots """ value=""Stop Timer"" >`n<input type=""button"" onclick=""buttonpress(this)"" name=""UpdateTimer" AlertSlots """ value=""Update Timer"" >`n</td>`n</tr>`n`n`n<tr>`n<td colspan=""2"" style=""border-top:solid 2px""></td>`n<!--EndAlert" AlertSlots "-->`n<!--LastAlert-->")
	HTMLDisplay.document.getElementById("AlertsContent").innerHTML := TempHTML

	TempHTML := ""
return

UpdateAlertTimers:

	Loop, parse, ActiveAlertSlots, % "\|"
	{

		if (A_LoopField!=""){
			AlertSlot := A_LoopField
			CurrentFinishTime%AlertSlot% := ActualFinishTime%AlertSlot%
			EnvSub, CurrentFinishTime%AlertSlot%, A_Now, Seconds

			;Temp := CurrentFinishTime%AlertSlot%
			;Tooltip, %Temp%

			Sleep 1000
			if (CurrentFinishTime%AlertSlot%<=30){
				CurrentFinishTime%AlertSlot% := "NOW"
				SoundFile := AlertTitle%AlertSlot%
				;SoundBeep
				;SoundBeep
				GoSub, MakeSound
				;GoSub, StopAlertTimers
			}else{
				CurrentFinishTime%AlertSlot% := SecondsToString(CurrentFinishTime%AlertSlot%,0)
				CurrentFinishTime%AlertSlot% := subStr(CurrentFinishTime%AlertSlot%, 1, StrLen(CurrentFinishTime%AlertSlot%)-3)
				HTMLDisplay.document.getElementById("TimeRemaining" AlertSlot).disabled := 1
			}
	
			HTMLDisplay.document.getElementById("TimeRemaining" AlertSlot).value := CurrentFinishTime%AlertSlot%
		}
	}

return

SetPreset(PresetName, PresetSlot){

	;Tooltip % QTPresetsArr[PresetSlot]
	
	if(PresetName="AutoClick"){
		PresetArr := StrSplit(AutoClickPresetsArr[PresetSlot], "||")
		HTMLDisplay.document.getElementById("AutoClickPresetStr").value := PresetArr[1]
		HTMLDisplay.document.getElementById("AutoClickToggle0").checked := PresetArr[2] ? 1 : 0 
		HTMLDisplay.document.getElementById("AutoClickToggle1").checked := PresetArr[2] ? 0 : 1 
		HTMLDisplay.document.getElementById("AutoClickKey").value := PresetArr[3]
		HTMLDisplay.document.getElementById("AutoClickSpamDelay").value := PresetArr[4]
		HTMLDisplay.document.getElementById("AutoClickHoldDelay").value := PresetArr[5]
	}else if(PresetName="QT"){
		PresetArr := StrSplit(QTPresetsArr[PresetSlot], "||")
		HTMLDisplay.document.getElementById("QTPresetStr").value := PresetArr[1]
		HTMLDisplay.document.getElementById("QTDrop0").checked := PresetArr[2] ? 1 : 0 
		HTMLDisplay.document.getElementById("QTDrop1").checked := PresetArr[2] ? 0 : 1 
		HTMLDisplay.document.getElementById("QTFromYou0").checked := PresetArr[3] ? 1 : 0
		HTMLDisplay.document.getElementById("QTFromYou1").checked := PresetArr[3] ? 0 : 1 
		HTMLDisplay.document.getElementById("QTDelay").value := PresetArr[4]
		HTMLDisplay.document.getElementById("QTSearch").value := PresetArr[5]
	}
}


UpdatePresetSlots(PresetName,UpdatedSlot="",SlotNumber=""){

	;Tooltip, %PresetName%`n%UpdatedSlot%`n%SlotNumber%
	if (UpdatedSlot="-1"){
		%PresetName%PresetsArr.RemoveAt(SlotNumber)
	}else if (UpdatedSlot!=""){
		if (SlotNumber=0){
			%PresetName%PresetsArr.push(UpdatedSlot)
		}else{
			%PresetName%PresetsArr[SlotNumber] := UpdatedSlot
		}
	}


	%PresetName%PresetsHTML := %PresetName%PresetsStr := ""
	Loop % %PresetName%PresetsArr.MaxIndex(){
		TempArr := StrSplit(%PresetName%PresetsArr[A_Index],"||")
		%PresetName%PresetsHTML := %PresetName%PresetsHTML  "<option value='" A_Index "'>" TempArr[1] "</option>`n"
		%PresetName%PresetsStr := %PresetName%PresetsStr "\/\/" %PresetName%PresetsArr[A_Index]
	}
	%PresetName%PresetsHTML := %PresetName%PresetsHTML  "<option value='0'>Add New</option>`n"
	HTMLDisplay.document.getElementById(PresetName "PresetNumber").innerHTML := %PresetName%PresetsHTML
	
	if (UpdatedSlot!=""){
		%PresetName%PresetsStr := %PresetName%PresetsStr "\/\/"
		Temp := %PresetName%PresetsStr
		IniWrite, %Temp%, %FileSettings%, Main, %PresetName%PresetsStr
	}

	HTMLDisplay.document.getElementById(PresetName "PresetNumber").value := UpdatedSlot="-1" ? %PresetName%PresetsArr.MaxIndex() : SlotNumber

	;Clipboard := %PresetName%PresetsArr.MaxIndex()
	;Clipboard := %PresetName%PresetsHTML
	;SoundBeep
	;Sleep 5000
}

/*
WM_MOUSEOVER(){

	MouseGetPos,,, Currenthwnd

	return
}
*/
WM_LBUTTONDOWN(){
	
	MouseGetPos,,,,ctrl
    if (WinActive(ahk_id %MainHwnd%) && ctrl="Static1"){ ;;;;Mover TitleBar
       PostMessage, 0xA1, 2,,, A ; WM_NCLBUTTONDOWN
		;PostMessage, 0xA1, 2
    }
}

WM_NCCALCSIZE(){
    if (A_Gui)
        return 0    ; Sizes the client area to fill the entire window.
}

WM_NCHITTEST(wParam, lParam){
    static border_size = 6
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


UpdateDebug:
	if (ShowingDebugButton){
		HTMLDisplay.document.getElementById("DebugContent").innerHTML := DebugInfo
		HTMLDisplay.document.getElementById("DebugContent").style.display := "block"
		HTMLDisplay.document.getElementById("DebugArrow").src := A_ScriptDir "\Captures\Arrow1.png"
	}
return

ShowingSplashImageFunction:
	if (ShowingSplashImageButton){
		Menu, TreeToggleFunctions, Uncheck, Splash Image
		ShowingSplashImageButton := 0
		SetTimer, MakeSplashImage, Off
		HTMLDisplay.document.getElementById("SplashImageButton").style.display := "none"
	} else {
		Menu, TreeToggleFunctions, Check, Splash Image
		ShowingSplashImageButton := 1
		SetTimer, MakeSplashImage, 10000
		HTMLDisplay.document.getElementById("SplashImageButton").style.display := ""
	}
	IniWrite, %ShowingSplashImageButton%, %FileSettings%, Main, ShowingSplashImageButton
return


ShowingAlertsFunction:
	if (ShowingAlertsButton){
		Menu, TreeToggleFunctions, Uncheck, Alerts
		ShowingAlertsButton := 0
		HTMLDisplay.document.getElementById("AlertsDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("AlertsContent").style.display := "none"

		AlertsCheck := 0
		SetTimer, AlertsFunction, off
		IniWrite, %AlertsCheck%, %FileSettings%, Main, AlertsCheck
		HTMLDisplay.document.getElementById("AlertsCheck").checked := 0

	} else {
		Menu, TreeToggleFunctions, Check, Alerts
		ShowingAlertsButton := 1
		HTMLDisplay.document.getElementById("AlertsDropDown").style.display := ""
	}
	IniWrite, %ShowingAlertsButton%, %FileSettings%, Main, ShowingAlertsButton
return



ShowingAutoClickFunction:
	if (ShowingAutoClickButton){
		Menu, TreeToggleFunctions, Uncheck, Auto Click
		ShowingAutoClickButton := 0
		HTMLDisplay.document.getElementById("AutoClickDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("AutoClickContent").style.display := "none"

		AutoClickCheck := 0
		SetTimer, AutoClickFunction, off
		IniWrite, %AutoClickCheck%, %FileSettings%, Main, AutoClickCheck
		HTMLDisplay.document.getElementById("AutoClickCheck").checked := 0

	} else {
		Menu, TreeToggleFunctions, Check, Auto Click
		ShowingAutoClickButton := 1
		HTMLDisplay.document.getElementById("AutoClickDropDown").style.display := ""
	}
	IniWrite, %ShowingAutoClickButton%, %FileSettings%, Main, ShowingAutoClickButton
return


ShowingAutoFoodWaterFunction:
	if (ShowingAutoFoodWaterButton){
		Menu, TreeToggleFunctions, Uncheck, Auto Food Water
		ShowingAutoFoodWaterButton := 0
		HTMLDisplay.document.getElementById("AutoFoodWaterDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("AutoFoodWaterContent").style.display := "none"

		AutoFoodWaterCheck := 0
		;SetTimer, AutoFoodWaterFunction, off
		IniWrite, %AutoFoodWaterCheck%, %FileSettings%, Main, AutoFoodWaterCheck
		HTMLDisplay.document.getElementById("AutoFoodWaterCheck").checked := 0

	} else {
		Menu, TreeToggleFunctions, Check, Auto Food Water
		ShowingAutoFoodWaterButton := 1
		HTMLDisplay.document.getElementById("AutoFoodWaterDropDown").style.display := ""
	}
	IniWrite, %ShowingAutoFoodWaterButton%, %FileSettings%, Main, ShowingAutoFoodWaterButton
return


ShowingCrosshairFunction:
	if (ShowingCrosshairButton){
		Menu, TreeToggleFunctions, Uncheck, Crosshair
		ShowingCrosshairButton := 0
		HTMLDisplay.document.getElementById("CrosshairDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("CrosshairContent").style.display := "none"

		CrosshairCheck := 0
		IniWrite, %CrosshairCheck%, %FileSettings%, Main, CrosshairCheck
		HTMLDisplay.document.getElementById("CrosshairCheck").checked := 0

	} else {
		Menu, TreeToggleFunctions, Check, Crosshair
		ShowingCrosshairButton := 1
		HTMLDisplay.document.getElementById("CrosshairDropDown").style.display := ""
	}
	IniWrite, %ShowingCrosshairButton%, %FileSettings%, Main, ShowingCrosshairButton
return


ShowingDinoExportFunction:
	if (ShowingDinoExportButton){
		Menu, TreeToggleFunctions, Uncheck, Dino Export
		ShowingDinoExportButton := 0
		HTMLDisplay.document.getElementById("DinoExportDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("DinoExportContent").style.display := "none"

		DinoExportCheck := 0
		SetTimer, DinoExportFunction, off
		IniWrite, %DinoExportCheck%, %FileSettings%, Main, DinoExportCheck
		HTMLDisplay.document.getElementById("AlertsCheck").checked := 0

	} else {
		Menu, TreeToggleFunctions, Check, Dino Export
		ShowingDinoExportButton := 1
		HTMLDisplay.document.getElementById("DinoExportDropDown").style.display := ""
	}
	IniWrite, %ShowingDinoExportButton%, %FileSettings%, Main, ShowingDinoExportButton
return


ShowingFeedBabiesFunction:
	if (ShowingFeedBabiesButton){
		Menu, TreeToggleFunctions, Uncheck, Feed Babies
		ShowingFeedBabiesButton := 0
		HTMLDisplay.document.getElementById("FeedBabiesDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("FeedBabiesContent").style.display := "none"

		FeedBabiesCheck := 0
		;SetTimer, FeedBabiesFunction, off
		IniWrite, %FeedBabiesCheck%, %FileSettings%, Main, FeedBabiesCheck
		HTMLDisplay.document.getElementById("FeedBabiesCheck").checked := 0

	} else {
		Menu, TreeToggleFunctions, Check, Feed Babies
		ShowingFeedBabiesButton := 1
		HTMLDisplay.document.getElementById("FeedBabiesDropDown").style.display := ""
	}
	IniWrite, %ShowingFeedBabiesButton%, %FileSettings%, Main, ShowingFeedBabiesButton
return

ShowingFishingFunction:
	if (ShowingFishingButton){
		Menu, TreeToggleFunctions, Uncheck, Fishing
		ShowingFishingButton := 0
		HTMLDisplay.document.getElementById("FishingDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("FishingContent").style.display := "none"

		FishingCheck := 0
		IniWrite, %FishingCheck%, %FileSettings%, Main, FishingCheck
		HTMLDisplay.document.getElementById("FishingCheck").checked := 0

	} else {
		Menu, TreeToggleFunctions, Check, Fishing
		ShowingFishingButton := 1
		HTMLDisplay.document.getElementById("FishingDropDown").style.display := ""
	}
	IniWrite, %ShowingFishingButton%, %FileSettings%, Main, ShowingFishingButton
return


ShowingQuickTransferFunction:
	if (ShowingQuickTransferButton){
		Menu, TreeToggleFunctions, Uncheck, Quick Transfer
		ShowingQuickTransferButton := 0
		HTMLDisplay.document.getElementById("QTDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("QTContent").style.display := "none"

		QTCheck := 0
		;SetTimer, QuickTransferFunction, off
		IniWrite, %QTCheck%, %FileSettings%, Main, QTCheck
		HTMLDisplay.document.getElementById("QTCheck").checked := 0

	} else {
		Menu, TreeToggleFunctions, Check, Quick Transfer
		ShowingQuickTransferButton := 1
		HTMLDisplay.document.getElementById("QTDropDown").style.display := ""
	}
	IniWrite, %ShowingQuickTransferButton%, %FileSettings%, Main, ShowingQuickTransferButton
return


ShowingServerInfoFunction:
	if (ShowingServerInfoButton){
		Menu, TreeToggleFunctions, Uncheck, Server Info
		ShowingServerInfoButton := 0
		HTMLDisplay.document.getElementById("ServerInfoDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("ServerInfoContent").style.display := "none"

		ServerInfoCheck := 0
		SetTimer, UpdateServerInfo, off
		IniWrite, %ServerInfoCheck%, %FileSettings%, Main, ServerInfoCheck
		HTMLDisplay.document.getElementById("ServerInfoCheck").checked := 0

	} else {
		Menu, TreeToggleFunctions, Check, Server Info
		ShowingServerInfoButton := 1
		HTMLDisplay.document.getElementById("ServerInfoDropDown").style.display := ""
	}
	IniWrite, %ShowingServerInfoButton%, %FileSettings%, Main, ShowingServerInfoButton
return


ShowingDebugFunction:
	if (ShowingDebugButton){
		Menu, TreeToggleFunctions, Uncheck, Debug
		ShowingDebugButton := 0
		HTMLDisplay.document.getElementById("DebugDropDown").style.display := "none"
		HTMLDisplay.document.getElementById("DebugContent").style.display := "none"
	} else {
		Menu, TreeToggleFunctions, Check, Debug
		ShowingDebugButton := 1
		HTMLDisplay.document.getElementById("DebugDropDown").style.display := ""
	}
	IniWrite, %ShowingDebugButton%, %FileSettings%, Main, ShowingDebugButton
return


UpdatePixelLoc(PixelName, ByRef PixelX, ByRef PixelY){

	Gui, 9:Destroy

	PixelX := PixelX="" || PixelX=0 ? A_ScreenWidth/2 : floor(PixelX)
	PixelY := PixelY="" || PixelY=0 ? A_ScreenHeight/2 : floor(PixelY)

	Gui, 9:New, -Caption +E0x80000 +E0x20 +AlwaysOnTop +ToolWindow +OwnDialogs +LastFound +HwndPixelhwnd ; Create GUI

	Gui, 9:Show, , ChoosePixel ; Show GUI

	PixelW := PixelH := 6
	hbm2 := CreateDIBSection(PixelW+2, PixelH+2) ; Create a gdi bitmap drawing area
	hdc2 := CreateCompatibleDC() ; Get a device context compatible with the screen
	obm2 := SelectObject(hdc2, hbm2) ; Select the bitmap into the device context
	pGraphics2 := Gdip_GraphicsFromHDC(hdc2) ; Get a pointer to the graphics of the bitmap, for use with drawing functions
	Gdip_SetSmoothingMode(pGraphics2, 4) ; Set the smoothing mode to antialias = 4 to make shapes appear smother
	
	
	pPen := Gdip_CreatePen(0xFFFF0000, 3)
	Gdip_DrawRectangle(pGraphics2, pPen, 0, 0, PixelW, PixelH)

	;pBrush := Gdip_BrushCreateSolid(0x01000000)
 	;Gdip_FillRectangle(pGraphics2, pBrush, 0, 0, PixelW, PixelH)
	 
	UpdateLayeredWindow(Pixelhwnd, hdc2, PixelX-PixelW/2, PixelY-PixelH/2, PixelW+1, PixelH+1)
	SelectObject(hdc2, obm2) ; Select the object back into the hdc
	Gdip_DeletePen(pPen)
	Gdip_DeleteBrush(pBrush)
	DeleteObject(hbm2) ; Now the bitmap may be deleted
	DeleteDC(hdc2) ; Also the device context related to the bitmap may be deleted
	Gdip_DeleteGraphics(pGraphics2) ;




	global DisplayingMessage := 1
	;Sleep 500
			

	if (WinExist("ahk_class UnrealWindow")){
		TST_Update("", "","Click where the pixel is.", TSThwnds)
		Sleep 1500
	}else{
		TST_Update("", "","Could not find ""ahk_class UnrealWindow""", TSThwnds)
		Sleep 2000
		DisplayingMessage := 0
		return
	}

	While (!WinActive("ahk_class UnrealWindow") && WinExist("ahk_class UnrealWindow"))
		Sleep 10

	LastKey := ""
	While (LastKey!="LButton"){
		LastKey := A_PriorKey
		;Tooltip, %LastKey%
	}

	MouseGetPos, PixelX, PixelY

	;WinGetPos, PixelX, PixelY, PixelW, PixelH, ChoosePixel
	;PixelX := floor(PixelX + PixelW/2)
	;PixelY := floor(PixelY + PixelH/2)


	if (PixelX!=0 && PixelY!=0 && PixelX>0 && PixelY>0){
		WinMove, ahk_id %Pixelhwnd%, , PixelX-PixelW/2, PixelY-PixelH/2 
		IniWrite, %PixelX%, %FileSettings%, Main, %PixelName%X
		IniWrite, %PixelY%, %FileSettings%, Main, %PixelName%Y
	}
	TST_Update("", "", PixelName " was updated to X:" PixelX " Y: " PixelY, TSThwnds)
	Sleep 1500
	TST_Update("", "", , TSThwnds)


	DisplayingMessage := 0
	Sleep 1000

	Gui, 9:Destroy
	return
}



UpdatePixel1:
	UpdatePixelLoc("CheckInv", CheckInvX, CheckInvY)
return
UpdatePixel2:
	UpdatePixelLoc("YourSearch", YourSearchX, YourSearchY)
return
UpdatePixel3:
	UpdatePixelLoc("YourTransferAll", YourTransferAllX, YourTransferAllY)
return
UpdatePixel4:
	UpdatePixelLoc("YourDropAll", YourDropAllX, YourDropAllY)
return
UpdatePixel5:
	UpdatePixelLoc("TheirSearch", TheirSearchX, TheirSearchY)
return
UpdatePixel6:
	UpdatePixelLoc("TheirTransferAll", TheirTransferAllX, TheirTransferAllY)
return
UpdatePixel7:
	UpdatePixelLoc("TheirDropAll", TheirDropAllX, TheirDropAllY)
return
UpdatePixel8:
	UpdatePixelLoc("StructureHP", StructureHPX, StructureHPY)
return
UpdatePixel9:
	UpdatePixelLoc("YourTransferSlot", YourTransferSlotX, YourTransferSlotY)
return
UpdatePixel10:
	UpdatePixelLoc("TheirTransferSlot", TheirTransferSlotX, TheirTransferSlotY)
return


MakeSplashImage:
	IconW := 256

	pBitmapBack := Gdip_CreateBitmap(IconW, IconW), GBack := Gdip_GraphicsFromImage(pBitmapBack), Gdip_SetSmoothingMode(GBack, 4)

	pBitmapIcon := Gdip_CreateBitmap(IconW, IconW), GIcon := Gdip_GraphicsFromImage(pBitmapIcon), Gdip_SetSmoothingMode(GIcon, 4)
	pBitmapMask := Gdip_CreateBitmap(IconW, IconW), GMask := Gdip_GraphicsFromImage(pBitmapMask), Gdip_SetSmoothingMode(GMask, 4)
	

	pi := 3.1415927
	LastPattern := LastPatterns := ""
	RandA1 := 15
	ImageScaleFactor := 4
	Loop
	{

		CurrentLayer := ""
		if (A_Index=1){			
			CurrentLayer := "Mask"		;MASK
			r := floor(IconW/6)
			RadialFadeScale := 0.5
			ColorBall1 := 0x0000FF00	;Outer Edge
			ColorBall2 := 0xFF00FF00 	;Inside
		}else if (A_Index=2){			;Glow Behind 1
			r := floor(IconW/2.25)
			RadialFadeScale := 0.0
			ColorBall1 := 0x00FF00FF	;Outer Edge
			ColorBall2 := 0x44FF00FF	;Inside
		}else if (A_Index=3){			;Glow Behind 2
			r := floor(IconW/2.25)
			RadialFadeScale := 0.0
			ColorBall1 := 0x0000FFFF	;Outer Edge
			ColorBall2 := 0x3300FFFF	;Inside
		}else if (A_Index=4){			;Ball Main
			r := round(IconW/3*ImageScaleFactor)
			;ColorBall1 := 0xCC334488
			;ColorBall2 := 0x88443388
		}else {							;Ball Inners
			
			if (mod(A_Index,2)){		;;;;Pinks Purples
				Random, RandR, 100, 255
				Random, RandG, 20, 120
				Random, RandB, 120, 255
			}
			Else{						;;;;;Cyans
				Random, RandR, 0, 20
				Random, RandG, 120, 255
				Random, RandB, 120, 255
			}

			RandB := RandG>RandB ? round(RandG*1.33) : RandB
			RandB := RandB>255 ? 255 : RandB

			RandR := RandR>=RandB ? round(RandB*1.33) : RandR
			RandR := RandR>255 ? 255 : RandR

			RandA1 := RandA1 + 15

			ColorBall1 := FHex(RandA1,2) substr(FHex(RandR,2),3) substr(FHex(RandG,2),3) substr(FHex(RandB,2),3)
			ColorBall2 := 0x00000000

			Random, RandVal, 0.66, 0.8
			r := floor(RandVal*r)
			if (r<=IconW/10 || A_Index>25){
				Break
			}
		}

		
			
		if (A_Index>3){

			While (Pattern=LastPattern || InStr(LastPatterns, Pattern) || RegexMatch(Pattern, "12|13|14|15|16|17|20|21|26|27|28|29|38|39|41|43|46|48|49|50|52"))
				Random, Pattern, 1, 52
			LastPattern := Pattern
			LastPatterns := LastPatterns "`n" Pattern
			PBrush := Gdip_BrushCreateHatch(ColorBall1, ColorBall2, Pattern)

			ImageWidth2 := round(r)
			pBitmapTemp := Gdip_CreateBitmap(ImageWidth2, ImageWidth2)
			GTemp := Gdip_GraphicsFromImage(pBitmapTemp), Gdip_SetSmoothingMode(GTemp, 4)
			Gdip_FillEllipse(GTemp, PBrush, 0, 0, ImageWidth2, ImageWidth2)
			Gdip_DeleteGraphics(GTemp)
			GTemp := ""
			Gdip_DrawImage(GIcon, pBitmapTemp, 0, 0, IconW, IconW, 0, 0, ImageWidth2, ImageWidth2)
			Gdip_DisposeImage(pBitmapTemp)
			pBitmapTemp := ""
		}else{

			PPathCurrent := CurrentLayer = "Mask" ? Gdip_CreatePath(GMask) : Gdip_CreatePath(GBack)
			PathPoints := ""
			CurrentAngle := 0
			Random, AngleInc, 6, 22
			While (CurrentAngle<360)
			{
				if (CurrentLayer = "Mask"){
					PathCurrentX := floor(IconW/2+r*sin(CurrentAngle*pi/180))
					PathCurrentY := floor(IconW/2+r*cos(CurrentAngle*pi/180))
				}else{
					Random, AngleRand1, 20, 359
					Random, AngleRand2, 20, 359
					PathCurrentX := floor(IconW/2+0.1*r*sin(AngleRand1*pi/180)+r*sin(CurrentAngle*pi/180))
					PathCurrentY := floor(IconW/2+0.1*r*sin(AngleRand2*pi/180)+r*cos(CurrentAngle*pi/180))
				}
				CurrentAngle := CurrentAngle + AngleInc
				PathPoints := PathPoints "|" PathCurrentX "," PathCurrentY
			}
			Gdip_AddPathPolygon(PPathCurrent, substr(PathPoints, 2)), PathPoints := ""
			;Gdip_AddPathEllipse(PPathCurrent, IconW/2-r, IconW/2-r, r*2, r*2)

			DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", "Ptr", PPathCurrent, "PtrP", PBrush)
			VarSetCapacity(POINT, 8)
			NumPut(IconW/2, POINT, 0, "Float")
			NumPut(IconW/2, POINT, 4, "Float")
			DllCall("Gdiplus.dll\GdipSetPathGradientCenterPoint", "Ptr", PBrush, "Ptr", &POINT)
			DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", "Ptr", PBrush, "UInt", ColorBall2)
			POINT := ""
			VarSetCapacity(COLOR, 4, 0)
			NumPut(ColorBall1, COLOR, 0, "UInt")
			COLORS := 1
			DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", "Ptr", PBrush, "Ptr", &Color, "IntP", COLORS)
			DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", PBrush, "Float", RadialFadeScale, "Float", RadialFadeScale)
		
			if (CurrentLayer = "Mask")
				Gdip_FillPath(GMask, PBrush, PPathCurrent)
			else
				Gdip_FillPath(GBack, PBrush, PPathCurrent)
			Gdip_DeletePath(PPathCurrent)
			PPathCurrent := ""

		}
		Gdip_DeleteBrush(PBrush)
		PBrush := ""
		LastIndex := A_Index
	}
	LastPattern := LastPatterns := ""

	Gdip_DeleteGraphics(GIcon)
	GIcon := ""
	Gdip_DeleteGraphics(GMask)
	GMask := ""


	pBitmapIcon := Gdip_AlphaMask(pBitmapIcon, pBitmapMask, 0, 0, 0)
	Gdip_DisposeImage(pBitmapMask)
	pBitmapMask := ""

	Gdip_DrawImage(GBack, pBitmapIcon)
	Gdip_DisposeImage(pBitmapIcon)
	pBitmapIcon := ""


    Color1 := 0x00000000
    r := IconW/2.5 ; radius of imaginary circle for center of triangles
	Angle := 120
    Loop, 3
    {
		if (A_Index=1){
			Color2 := ColorB
			Color3 := "0xFF66FFFF"
		}else if (A_Index=2){
			Color2 := ColorG
			Color3 := "0xFFCCFFCC"
		}else{
			Color2 := ColorR
			Color3 := "0xFFFFAAAA"
		}

		Loop, 2     ;1 - Outer			;2 - Inner
		{
			sizer := A_Index=1 ? IconW/6 : sizer*0.5
			PointsA%A_Index% := [IconW/2+sizer*cos(270*pi/180) , (IconW/2-r)-sizer*sin(270*pi/180) , IconW/2+sizer*cos(150*pi/180) , (IconW/2-r)-sizer*sin(150*pi/180) , IconW/2+sizer*cos(30*pi/180) , (IconW/2-r)-sizer*sin(30*pi/180) ]
			Points%A_Index% := PointsA%A_Index%[1] "," PointsA%A_Index%[2] "|" PointsA%A_Index%[3] "," PointsA%A_Index%[4] "|" PointsA%A_Index%[5] "," PointsA%A_Index%[6]
		}

		Poly1 := round(PointsA1[3]) "," round(PointsA1[4]) "|" round(PointsA2[3]) "," round(PointsA2[4]) "|" round(PointsA2[5]) "," round(PointsA2[6]) "|" round(PointsA1[5]) "," round(PointsA1[6]) "|" round(PointsA1[3]) "," round(PointsA1[4])
		Poly2 := round(PointsA1[3]) "," round(PointsA1[4]) "|" round(PointsA2[3]) "," round(PointsA2[4]) "|" round(PointsA2[1]) "," round(PointsA2[2]) "|" round(PointsA1[1]) "," round(PointsA1[2]) "|" round(PointsA1[3]) "," round(PointsA1[4])
		Poly3 := round(PointsA2[1]) "," round(PointsA2[2]) "|" round(PointsA1[1]) "," round(PointsA1[2]) "|" round(PointsA1[5]) "," round(PointsA1[6]) "|" round(PointsA2[5]) "," round(PointsA2[6]) "|" round(PointsA2[1]) "," round(PointsA2[2])
		Poly4 := round(PointsA2[1]) "," round(PointsA2[2]) "|" round(PointsA2[3]) "," round(PointsA2[4]) "|" round(PointsA2[5]) "," round(PointsA2[6])

		pBrush1 := Gdip_CreateLineBrush((PointsA1[3]+PointsA1[5])/2, (PointsA1[4]+PointsA1[6])/2, (PointsA2[3]+PointsA2[5])/2, (PointsA2[4]+PointsA2[6])/2, Color1, Color2, 1)
		Gdip_FillPolygon(GBack, pBrush1, Poly1)
		Gdip_DeleteBrush(pBrush1)
		pBrush1 := ""

		pBrush2 := Gdip_CreateLineBrush((PointsA1[3]+PointsA1[1])/2, (PointsA1[4]+PointsA1[2])/2, (PointsA2[3]+PointsA2[1])/2, (PointsA2[4]+PointsA2[2])/2, Color1, Color2, 1)
		Gdip_FillPolygon(GBack, pBrush2, Poly2)
		Gdip_DeleteBrush(pBrush2)
		pBrush2 := ""
		
		pBrush3 := Gdip_CreateLineBrush((PointsA1[5]+PointsA1[1])/2, (PointsA1[6]+PointsA1[2])/2, (PointsA2[5]+PointsA2[1])/2, (PointsA2[6]+PointsA2[2])/2, Color1, Color2, 1)
		Gdip_FillPolygon(GBack, pBrush3, Poly3)
		Gdip_DeleteBrush(pBrush3)
		pBrush3 := ""
		
		pBrush4 := Gdip_BrushCreateSolid(Color2)
		Gdip_FillPolygon(GBack, pBrush4, Poly4)
		Gdip_DeleteBrush(pBrush4)
		pBrush4 := ""
		
		pPen := Gdip_CreatePen(Color3, 1)
		Gdip_DrawLines(GBack, pPen, PointsA2[1] "," PointsA2[2] "|" PointsA2[3] "," PointsA2[4] "|" PointsA2[5] "," PointsA2[6] "|" PointsA2[1] "," PointsA2[2])
		Gdip_DeleteBrush(pPen)
		pPen := ""
		
		Gdip_TranslateWorldTransform(GBack, IconW/2, IconW/2)
		Gdip_RotateWorldTransform(GBack, Angle)
		Gdip_TranslateWorldTransform(GBack, -IconW/2, -IconW/2)
	}

	Points1 := Points2 := PointsA1 := PointsA2 := ""

	Gdip_DeleteGraphics(GBack)
	GBack := ""
		
	Gdip_SaveBitmapToFile(pBitmapBack, SplashImagePath)

	hIcon := Gdip_CreateHICONFromBitmap(pBitmapBack)

	try Menu, Tray, Icon, HICON:%hIcon%
	DeleteObject(hIcon)
	hIcon := ""

	GuiControlGet, hwnd, hwnd, IconButton 
	pBitmap := Gdip_CreateBitmap(PosW, PosH), G := Gdip_GraphicsFromImage(pBitmap)
	Gdip_DrawImage(G, pBitmapBack, 0, 0, PosW, PosH, 0, 0, IconW, IconW)
	
	Gdip_DisposeImage(pBitmapBack)
	pBitmapBack := ""
	Gdip_DeleteGraphics(G)
	G := ""

	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	Gdip_DisposeImage(pBitmap)
	pBitmap := ""

	try SetImage(hwnd, hBitmap)
	DeleteObject(hBitmap)
	hBitmap := ""

	;Gdip_Shutdown(pToken)
	;pToken := Gdip_Startup()



	HTMLDisplay.document.getElementById("SplashImage").src := SplashImagePath "?" A_Now

return

BeepFunction:
	SoundBeep
	SoundBeep
	SoundBeep
return


FishingHotkeyFunction:
	if (FishingEnabled){
		FishingEnabled := 0
		SetTimer, FishingLoop, off
	}else{
		if (FishingCheck){
			FishingEnabled := 1
			SetTimer, FishingLoop, %FishingSpeed%
		}
	}
return

FishingLoop:
	;;Auto Recast Rod
	PixelSearch, RecastPx, RecastPy, 0, 0, A_ScreenWidth/4, A_ScreenHeight/4, 0x7FFD03, 3, Fast ;
       	if (ErrorLevel = 0)
    	{
        	Sleep, 2100
        	MouseClick, left
    	}
    
	;;A
	PixelSearch Px, Py, 1162, 970, 1162, 970, FishingColor, 3, Fast
	if (ErrorLevel = 0)
	{	
		Send, a
		Sleep, FishingSpeed
	}

	;;z
	PixelSearch Px, Py, 1158, 973, 1158, 973, FishingColor, 3, Fast
	if (ErrorLevel = 0)
	{	
		Send, z
		Sleep, FishingSpeed
	}

	;;q
	PixelSearch Px, Py, 1181, 1016, 1181, 1016, FishingColor, 3, Fast
	if (ErrorLevel = 0)
	{	
		Send, q
		Sleep, FishingSpeed
	}

	;;w
	PixelSearch Px, Py, 1113, 868, 1113, 868, FishingColor, 3, Fast
	if (ErrorLevel = 0)
	{	
		Send, w
		Sleep, FishingSpeed
	}
		
	;;x
	PixelSearch Px, Py, 1167, 972, 1167, 972, FishingColor, 3, Fast
	if (ErrorLevel = 0)
	{	
		Send, x
		Sleep, FishingSpeed
	}

	;;d
	PixelSearch Px, Py, 1192, 906, 1192, 906, FishingColor, 3, Fast
	if (ErrorLevel = 0)
	{	
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

	if ( Px && Py ) && (!PxA && !PyA) && (!PxZ && !PyZ) && (!PxW && !PyW) && (!PxX && !PyX) && (!PxD && !PyD) {
		Send, e
		Sleep, FishingSpeed
	}

	;;S
	PixelSearch Px, Py, 1161, 917, 1161, 917, FishingColor, 3, Fast 

	PixelSearch PxZ, PyZ, 1158, 973, 1158, 973, FishingColor, 3, Fast	;;z
	PixelSearch PxW, PyW, 1113, 868, 1113, 868, FishingColor, 3, Fast	;;w
	PixelSearch PxX, PyX, 1167, 972, 1167, 972, FishingColor, 3, Fast	;;x


	if ( Px && Py ) && (!PxZ && !PyZ) && (!PxW && !PyW) && (!PxX && !PyX) {
		Send, s
		Sleep, FishingSpeed
	}

	;;C
	PixelSearch Px, Py, 1135, 918, 1135, 918, FishingColor, 3, Fast

	PixelSearch PxQ, PyQ, 1181, 1016, 1181, 1016, FishingColor, 3, Fast ;;q
	PixelSearch PxD, PyD, 1192, 906, 1192, 906, FishingColor, 3, Fast	;;d

	if ( Px && Py )  && (!PxQ && !PyQ) && (!PxD && !PyD) {

		Send, c
		Sleep, FishingSpeed
	}
return
