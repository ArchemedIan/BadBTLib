#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
SetBatchLines -1
Global BadBTLib_Req_Major := 2
Global BadBTLib_Req_Minor := 0
#include ..\BadBTLib.ahk


BtDevices := BTDevList(2) ; obtain known devices

NumOfDevices := BtDevices.Length() 
if (NumOfDevices = 0) 
{
	msgbox No paired devices or bluetooth off
	exitapp
}
loop %NumOfDevices%
{
	CoDObj := CoD2Obj(BtDevices[A_Index].CoD)		
	Gui, Add, Radio, vDev%A_Index% Checked%A_Index% , % BtDevices[A_Index].Name " (" CoDObj.Major.Class ") " ((CoDObj.Major.Class = "Phone") ? "(May not work)" : "" )
}
Gui, Add, Button, Default w80 gChangename, Change Name
Gui, Add, Button, x+m w80 gCancel, Cancel
Gui, Show, , Change BT device name
Return

Cancel:
ExitApp

Changename:
IfMsgBox, Cancel
	ExitApp
Gui, Submit
Gui, Destroy
loop %NumOfDevices%
	if (Dev%A_Index%)
		DevIndex := A_Index


InputBox, NewName, BtDevNameChange, % "Enter new name for " BtDevices[DevIndex].Name " (" BtDevices[DevIndex].Addr ")"
if ErrorLevel
	Goto Cancel
BTUpdateDevName(NewName, BtDevices[DevIndex].Addr)
msgbox Toggle bluetooth off and on for chamge to take effect.
ExitApp
return

