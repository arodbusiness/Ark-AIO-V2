whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://ark.gamepedia.com/Color_IDs", true)
whr.Send()
; Using 'true' above and the call below allows the script to remain responsive.
whr.WaitForResponse()
version := whr.ResponseText

FoundPos1 := InStr(whr.ResponseText, "<table class=""wikitable sortable"">")
FoundPos2 := InStr(whr.ResponseText, "</table", 0,  FoundPos1)

HTML := substr(whr.ResponseText, FoundPos1, FoundPos2-FoundPos1+8)

HTML := RegExReplace(HTML, "<tr>`n<td>", "<tr><td>")
HTML := RegExReplace(HTML, ">`n<td", "><td")
HTML := RegExReplace(HTML, "`n</td", "</td")
HTML := RegExReplace(HTML, "`n<th", "<th")
HTML := RegExReplace(HTML, "`n</th", "</th")
HTML := RegExReplace(HTML, "/tr></tbody", "/tr>`n</tbody")
HTML := RegExReplace(HTML, "`n`n")



file := FileOpen("ColorIDs.html", "w")
file.Write(HTML)
file.close


;;;Clipboard := HTML

HTMLlines := StrSplit(HTML,"`n")
;;HTMLlines.Delete(1)
;;Tooltip % HTMLlines.MaxIndex()

Colors := ""
Content := ""
ColorsFunctions := ""
ColorsHovers := ""


i := 0
Loop % HTMLlines.MaxIndex()
{

	;Tooltip % HTMLlines[A_Index]
	;Sleep 100
	FoundPos := RegexMatch(HTMLlines[A_Index], "<td>([0-9]{1,4})<\/td><td>(.+?)<\/td>.+?<tt>#([A-z0-9]{6})<\/tt>", Match)
	if (FoundPos)
	{
		i++
		if(InStr(Match2, "Dye"))
			Match2 := substr(Match2, 1, StrLen(Match2)-1)
		Content := Content Match1 "`t`t`t`t`t" Match2 "`t`t`t`t`t" Match3 "`n"
		Colors := Colors Match3 ","
		ColorsFunctions := ColorsFunctions "PickColor" i ":`n`tCurrentColor := """ Match3 """`n`tGoSub, ApplyColor`nReturn`n"
		ColorsHovers := ColorsHovers "`n`telse if (ctrl==""Button" i+16 """)`n`t`tTooltip, " Match2


		;;Tooltip, %Match1%`t`t`t`t`t%Match2%`t`t`t`t`t%Match3%
		;;Sleep 100
	}

}

ColorsHovers := "`n`tMouseGetPos,,,,ctrl`n`t" substr(ColorsHovers, 8) "`n`telse `n`t`tTooltip`n`t" 



Colors := substr(Colors, 1, StrLen(Colors)-1)
file := FileOpen("ColorIDs.txt", "w")
file.Write(substr(Content, 1, StrLen(Content)-1))
file.close

FilePath := "Advanced-Dino-Colorer.ahk"
if (FileExist(FilePath))
{
	SoundBeep
	FileRead, FileContents, %FilePath%
	

	FileContents := RegExReplace(FileContents, "Colors := strsplit\("".+?""", "Colors := strsplit(""" Colors """")
	
	FileContents := RegExReplace(FileContents, "(WM_MOUSEMOVE\(wParam,lParam\)\{)(.+?)(Return\n\})", "$1" ColorsHovers "$3")




	FoundPos := InStr(FileContents, "PICK COLORS FUNCTIONS")
	if (FoundPos)
	{
		FileContents := substr(FileContents, 1, FoundPos+21) "`n`n`n" ColorsFunctions


	}




	file := FileOpen(FilePath, "w")
	file.Write(FileContents)
	file.close

}







SoundBeep