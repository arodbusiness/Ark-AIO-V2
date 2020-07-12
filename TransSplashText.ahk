TransSplashText_On(Number=99,Text1="",Text2="",Text3="",ByRef hwndText3="",ByRef hwndText3S="",Font="",TC="",SC="",TS="",xPos="",yPos="",w="")
{
	If Text = 
		Text = TransSplashText
	If Font = 
		Font = Impact
	If TC = 
		TC = White
	If SC = 
		SC = 828284
	If TS = 
		TS = 16
	If xPos = 
		xPos = Center
	If yPos = 
		yPos = Center
	If w = 
		w = 500
		
	Q = 4

Text2X := StrLen(Text1) * 10 + 10
Text2X2 := Text2X + 2

Text3X := Text2X + 35
Text3X2 := Text3X + 2 



	If SC != 0
	{
		Gui, %Number%:Font, S%TS% C%SC% Q%Q%, %Font%
		Gui, %Number%:Add, Text, x12 y8 hwndhwndText1S, %Text1%


		Gui, %Number%:Font, S%TS% C%SC% Q%Q%, %Font%
		Gui, %Number%:Add, Text, x%Text2X2% y8 hwndhwndText2S, %Text2%


		Gui, %Number%:Font, S%TS% C%SC% Q%Q%, %Font%
		Gui, %Number%:Add, Text, x%Text3X2% y8 w%w% -wrap hwndhwndText3S, %Text3%
	
		
		
	}



	Gui, %Number%:Font, S%TS% C%TC% Q%Q%, %Font%
	Gui, %Number%:Add, Text, x10 y6 BackgroundTrans hwndhwndText1, %Text1%


	ToggleColor := Text2="ON" ? "Green" : "Red"
	Gui, %Number%:Font, S%TS% C%ToggleColor% Q%Q%, %Font%
	Gui, %Number%:Add, Text, x%Text2X% y6 BackgroundTrans hwndhwndText2, %Text2%


	Gui, %Number%:Font, S%TS% C%TC% Q%Q%, %Font%
	Gui, %Number%:Add, Text, x%Text3X% y6 w%w% -wrap BackgroundTrans hwndhwndText3, %Text3%

	
	
	
	Gui, %Number%:Color, EEAA99
	Gui, %Number%:+LastFound -Caption +AlwaysOnTop +ToolWindow +E0x20
	WinSet, TransColor, EEAA99
	Gui, %Number%:Show, x%xPos% y%yPos% AutoSize NA, TransSplashTextWindow
	
}

TransSplashText_Update(Text3="",hwnd3="",hwnd3S="")
{
	if (Text3!="")
	{
		GuiControl, Text, %hwnd3%, %Text3%
		GuiControl, Text, %hwnd3S%, %Text3%
	}

}






TST_On(Number=99,xPos="",yPos="",Text1="",Text2="",Text3="",ByRef hwnds="",Font="",TC="",SC="",TS="")
{
	If Text = 
		Text = TransSplashText
	If Font = 
		Font = Impact
	If TC = 
		TC = FFFFFF
	If SC = 
		SC = Black
	If TS = 
		TS = 16
	If xPos = 
		xPos = Center
	If yPos = 
		yPos = Center
	

	w1 = 150
	w2 = 100
	w3 := A_ScreenWidth-w2-w1


	Q = 4

	Text2X := StrLen(Text1) * 10 + 10
	Text2X2 := Text2X + 2

	Text3X := Text2X + 35
	Text3X2 := Text3X + 2 



	If SC != 0
	{
		Gui, %Number%:Font, S%TS% C%SC% Q%Q%, %Font%
		Gui, %Number%:Add, Text, x12 y8 w%w1% hwndhwndText1S, %Text1%


		Gui, %Number%:Font, S%TS% C%SC% Q%Q%, %Font%
		Gui, %Number%:Add, Text, x%Text2X2% y8 w%w2% hwndhwndText2S, %Text2%


		Gui, %Number%:Font, S%TS% C%SC% Q%Q%, %Font%
		Gui, %Number%:Add, Text, x%Text3X2% y8 w%w3% -wrap hwndhwndText3S, %Text3%

	}



	Gui, %Number%:Font, S%TS% C%TC% Q%Q%, %Font%
	Gui, %Number%:Add, Text, x10 y6 w%w1% BackgroundTrans hwndhwndText1, %Text1%


	ToggleColor := Text2="ON" ? "Green" : "Red"
	Gui, %Number%:Font, S%TS% C%ToggleColor% Q%Q%, %Font%
	Gui, %Number%:Add, Text, x%Text2X% y6 w%w2% BackgroundTrans hwndhwndText2, %Text2%


	Gui, %Number%:Font, S%TS% C%TC% Q%Q%, %Font%
	Gui, %Number%:Add, Text, x%Text3X% y6 w%w3% -wrap BackgroundTrans hwndhwndText3, %Text3%

	
	
	
	Gui, %Number%:Color, EEAA99
	Gui, %Number%:+LastFound -Caption +AlwaysOnTop +ToolWindow +E0x20
	WinSet, TransColor, EEAA99
	Gui, %Number%:Show, x%xPos% y%yPos% AutoSize NA, TransSplashTextWindow
	

	hwnds := hwndText1 "," hwndText1S "," hwndText2 "," hwndText2S "," hwndText3 "," hwndText3S 


}




TST_Update(Text1="",Text2="",Text3="",hwnds="")
{
	hwndArr := StrSplit(hwnds, ",")


	Text1W := StrLen(Text1) * 10


	Text2X := Text1W + 10
	Text2X2 := Text2X + 2

	Text3X := Text2X + 35
	Text3X2 := Text3X + 2 


	;;;;ADJUST WIDTH OF BOXES ON UPDATE!!!




	;if (Text1!="")
	;{
		Temp := hwndArr[1]
		GuiControl, Move, %Temp%, w%Text1W%
		GuiControl, Text, %Temp%, %Text1%
		
		Temp := hwndArr[2]
		GuiControl, Move, %Temp%, w%Text1W%
		GuiControl, Text, %Temp%, %Text1%
		
	;}


	;if (Text2!="")
	;{
		Temp := hwndArr[3]
		ToggleColor := Text2="ON" ? "Green" : "Red"
		GuiControl, +c%ToggleColor%, %Temp%
		GuiControl, Move, %Temp%, x%Text2X%
		GuiControl, Text, %Temp%, %Text2%
		Temp := hwndArr[4]
		GuiControl, Move, %Temp%, x%Text2X2%
		GuiControl, Text, %Temp%, %Text2%




	;}

	;if (Text3!="")
	;{
		Temp := hwndArr[5]
		GuiControl, Move, %Temp%, x%Text3X%
		GuiControl, Text, %Temp%, %Text3%
		Temp := hwndArr[6]
		GuiControl, Move, %Temp%, x%Text3X2%
		GuiControl, Text, %Temp%, %Text3%
	;}

}



TST_Test(program_id="")
{
	if (!FileExist("TransSplashText.ini")){
		file := FileOpen("TransSplashText.ini", "w")
		;file.Write("[Main]")
		file.Close()
	}
	IniWrite, %AutoClickCheck%, TransSplashText.ini, %program_id%, Slot
}