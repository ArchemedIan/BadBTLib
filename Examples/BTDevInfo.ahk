#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ;Keeps script open
#SingleInstance Force

Global BadBTLib_Req_Major := 2
Global BadBTLib_Req_Minor := 0
#include ..\BadBTLib.ahk
FileDelete, BTDevInfo.txt



NameOrAddr := "Joy-Con (L)"   ;search for a left joycon
BtDevice := BTDevInfo(NameOrAddr, 25) ; for 32 seconds (25 x 1.28)


;store infos
Name 	:= BtDevice.Name
Addr 	:= BtDevice.Addr
CoD 	:= BtDevice.CoD
CoDObj	:= CoD2Obj(CoD)
ConSts 	:= BtDevice.ConSts
RemSts 	:= BtDevice.RemSts
AuthSts := BtDevice.AuthSts
LSeen 	:= BtDevice.LSeen
LUsed 	:= BtDevice.LUsed

info :=	"Device #: " Devnum "`nName: " Name "`nAddr: " Addr "`nCoD: " CoD "`nConSts: " ConSts "`nRemSts: " RemSts "`nAuthSts: " AuthSts "`nLSeen: " LSeen "`nLUsed: " LUsed "`n`n"

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
		CoDinfo := CoDinfo "`nLAN info:`nAvailable: " isAvail "`nUtilizationLevel: " CoDObj.Minor.UtilizationLevel
	}

	if (CoDObj.Major.Class = "Peripheral")
	{
		isM := CoDObj.Minor.Mouse ? "Yes" : "No"
		isK := CoDObj.Minor.Keyboard ? "Yes" : "No"
		CoDinfo := CoDinfo "`nPeripheral (" CoDObj.Minor.Class ") info:" "`nMouse: " isM "`nKeyboard: " isK
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
FileAppend , % info "`n" Servicesinfo "`n" CoDinfo, %A_ScriptDir%\BTDevInfo.txt

ExitApp