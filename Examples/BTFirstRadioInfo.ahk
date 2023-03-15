#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#Persistent ;Keeps script open
#SingleInstance Force
#Warn All, Off



Global BadBTLib_Req_Major := 1
Global BadBTLib_Req_Minor := 3
#include ..\BadBTLib.ahk




FileDelete, BTFirstRadioInfo.txt
BtRadio := BTFirstRadioInfo()
 
Name 	:= BtRadio.Name
Addr 	:= BtRadio.Addr
CoD 	:= BtRadio.CoD

SubVer	:= BtRadio.SubVer
Manufacturer	:= BtRadio.Manufacturer

info :=	"Name: " Name "`nAddr: " Addr "`nSubVer: " SubVer "`nManufacturer: " Manufacturer

CoDObj := CoD2Obj(Bin(CoD))	
s1 := CoDObj.ServiceClasses.LimitedDiscoverableMode ? "Yes" : "No"
s2 := CoDObj.ServiceClasses.Positioning ? "Yes" : "No"
s3 := CoDObj.ServiceClasses.Networking ? "Yes" : "No"
s4 := CoDObj.ServiceClasses.Rendering ? "Yes" : "No"
s5 := CoDObj.ServiceClasses.Capturing ? "Yes" : "No"
s6 := CoDObj.ServiceClasses.ObjectTransfer ? "Yes" : "No"
s7 := CoDObj.ServiceClasses.Audio ? "Yes" : "No"
s8 := CoDObj.ServiceClasses.Telephony ? "Yes" : "No"
s9 := CoDObj.ServiceClasses.Information ? "Yes" : "No"

Servicesinfo :=	"LimitedDiscoverableMode: " s1 "`nPositioning: " s2 "`nNetworking: " s3 "`nRendering: " s4 "`nCapturing: " s5 "`nObjectTransfer: " s6 "`nAudio: " s7 "`nTelephony: " s8 "`nInformation: " s9


CoDinfo := "Major Class of Device: " CoDObj.Major.Class "`nMinor Class of Device: " CoDObj.Minor.Class
if (CoDObj.Major.Class = "LAN" or CoDObj.Major.Class = "Peripheral" or CoDObj.Major.Class = "Imaging")
{
	if (CoDObj.Major.Class = "LAN")
	{
		isAvail := CoDObj.Minor.Available ? "Yes" : "No"
		CoDinfo := CoDinfo "`nLAN info:`n`nAvailable: " isAvail "`nUtilizationLevel: " CoDObj.Minor.UtilizationLevel
	}

	if (CoDObj.Major.Class = "Peripheral")
	{
		isM := CoDObj.Minor.Mouse ? "Yes" : "No"
		isK := CoDObj.Minor.Keyboard ? "Yes" : "No"
		CoDinfo := CoDinfo "`nPeripheral (" CoDObj.Minor.Class ") info:`n" "`nMouse: " isM "`nKeyboard: " isK
	}
	
	if (CoDObj.Major.Class = "Imaging")
	{
		isDisplay := CoDObj.Minor.Display ? "Yes" : "No"
		isCamera := CoDObj.Minor.Camera ? "Yes" : "No"
		isScanner := CoDObj.Minor.Scanner ? "Yes" : "No"
		isPrinter := CoDObj.Minor.Printer ? "Yes" : "No"
		CoDinfo := CoDinfo "`nImaging info:`n" "`nDisplay: " isDisplay "`nCamera: " isCamera "`nScanner: " isScanner "`nPrinter: " isPrinter
	}
}


FileAppend , % "RadioDetails:`n" info "`n`nServices:`n" Servicesinfo "`n`nCoD:`n" CoDinfo, BTFirstRadioInfo.txt


return

