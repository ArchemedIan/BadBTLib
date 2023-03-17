#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ;Keeps script open
#SingleInstance Force

Global BadBTLib_Req_Major := 0
Global BadBTLib_Req_Minor := 1
#include ..\BadBTLib.ahk
FileDelete, BTDevList.txt


;###### SEARCH PARAMS HOWTO #######

;the search params are implemented in the same way things lik msgbox's options. https://www.autohotkey.com/docs/v1/lib/MsgBox.htm#Group_1_Buttons

;if you want an option, you add the value of that option to the rest of the options you want.

;there are 4 options;  

;::::Option:::::::::::Value:::::::::Description
ReturnAuthenticated := 	1		;This option will return any paired device
ReturnRemembered 	:= 	2		;This option will return any remembered device (being paired is not a requirement, only a previous connection)
ReturnUnknown		:= 	4		;This option will return any device that has not been connected or paired, but is otherwise discoverable.
ReturnConnected		:= 	8		;This option will return any device currently connected.

;Params := ReturnAuthenticated + ReturnRemembered	; = 3 

;Params := ReturnRemembered + ReturnConnected		; = 10

Params	:= 15	;Return All


;###### Usage Example #######

BtDevices := BTDevList(Params, 2) ;return bt devices based on %params% found in 10.24 8 x 1.28) seconds (and their infos) 


NumOfDevices := BtDevices.Length() ;Store infos 
loop %NumOfDevices%
{
	Devnum	:= A_Index 
	
	IniWrite,% BtDevices[A_Index].Name, BTDevList.txt, Device%Devnum%, Name
	IniWrite,% BtDevices[A_Index].Addr, BTDevList.txt, Device%Devnum%, Addr
	IniWrite,% BtDevices[A_Index].CoD, BTDevList.txt, Device%Devnum%, CoD
	IniWrite,% BtDevices[A_Index].ConSts, BTDevList.txt, Device%Devnum%, ConSts
	IniWrite,% BtDevices[A_Index].RemSts, BTDevList.txt, Device%Devnum%, RemSts
	IniWrite,% BtDevices[A_Index].AuthSts, BTDevList.txt, Device%Devnum%, AuthSts
	IniWrite,% BtDevices[A_Index].LSeen, BTDevList.txt, Device%Devnum%, LSeen
	IniWrite,% BtDevices[A_Index].LUsed, BTDevList.txt, Device%Devnum%, LUsed
	
	CoDObj := CoD2Obj(Bin(BtDevices[A_Index].CoD))	
	
	IniWrite,% CoDObj.ServiceClasses.LimitedDiscoverableMode ? "On" : "Off", BTDevList.txt, Device%Devnum%, LimitedDiscoverableMode 
	IniWrite,% CoDObj.ServiceClasses.Positioning ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Positioning services
	IniWrite,% CoDObj.ServiceClasses.Networking ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Networking services
	IniWrite,% CoDObj.ServiceClasses.Rendering ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Rendering services
	IniWrite,% CoDObj.ServiceClasses.Capturing ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Capturing services
	IniWrite,% CoDObj.ServiceClasses.ObjectTransfer ? "Yes" : "No", BTDevList.txt, Device%Devnum%, ObjectTransfer services
	IniWrite,% CoDObj.ServiceClasses.Audio ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Audio services
	IniWrite,% CoDObj.ServiceClasses.Telephony ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Telephony services
	IniWrite,% CoDObj.ServiceClasses.Information ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Information services
	
	IniWrite,% CoDObj.Major.Class, BTDevList.txt, Device%Devnum%, Major CoD
	IniWrite,% CoDObj.Minor.Class, BTDevList.txt, Device%Devnum%, Minor CoD
	
	if (CoDObj.Major.Class = "LAN")
	{
		IniWrite,% CoDObj.Minor.Available ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Available
		IniWrite,% CoDObj.Minor.UtilizationLevel ? "Yes" : "No", BTDevList.txt, Device%Devnum%, UtilizationLevel
	}

	if (CoDObj.Major.Class = "Peripheral")
	{
		IniWrite,% CoDObj.Minor.Mouse ? "Yes" : "No" ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Mouse
		IniWrite,% CoDObj.Minor.Keyboard ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Keyboard
	}
	
	if (CoDObj.Major.Class = "Imaging")
	{
		IniWrite,% CoDObj.Minor.Display ? "Yes" : "No" ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Display
		IniWrite,% CoDObj.Minor.Camera ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Camera
		IniWrite,% CoDObj.Minor.Scanner ? "Yes" : "No" ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Scanner
		IniWrite,% CoDObj.Minor.Printer ? "Yes" : "No", BTDevList.txt, Device%Devnum%, Printer
	}
	
	FileAppend, `n, %A_ScriptDir%\BTDevList.txt
}
ExitApp