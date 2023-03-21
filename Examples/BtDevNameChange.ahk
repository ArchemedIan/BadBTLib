#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
SetBatchLines -1
SplitPath, A_ScriptFullPath, , ScriptFolder, , ScriptNameNoExt
Global BadBTLib_Req_Major := 2
Global BadBTLib_Req_Minor := 0
#include ..\BadBTLib.ahk

if (A_IsCompiled) and (A_Args[1] = "applyonboot")
	goto applyonboot


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
if (A_IsCompiled)
	MsgBox, 36, apply on boot?, apply on boot?

Ifmsgbox, Yes
{
	IniWrite, % NewName, %A_ScriptDir%\%ScriptNameNoExt%.ini, Names2Change, % BtDevices[DevIndex].Addr
	if (!FileExist(A_Startup "\" ScriptNameNoExt ".lnk"))
		FileCreateShortcut, %A_ScriptDir%\%ScriptNameNoExt%.exe, %A_Startup%\%ScriptNameNoExt%.lnk, %A_ScriptDir%, applyonboot, Starts %ScriptNameNoExt%, , , ,
}

ExitApp
return



applyonboot:
IniRead, OutputVarSection, %A_ScriptDir%\%ScriptNameNoExt%.ini, Names2Change

names2cObj := StrSplit(OutputVarSection , "`n")

loop % names2cObj.Length()
{
	N2CObj := StrSplit(names2cObj[A_Index] , "=")
	BTUpdateDevName(N2CObj[2], N2CObj[1])
}

ExitApp
return
