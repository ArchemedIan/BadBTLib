start := A_TickCount
SetBatchLines -1
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include ..\BadBTLib.ahk

BTDevList := BTDevList(15, 0)
NumOfDevices := BTDevList.Length() ;Store infos 
loop %NumOfDevices%
	devs := devs BtDevList[A_Index].Name " Connected: " (BtDevList[A_Index].ConSts  ? "Yes`n" : "No`n")

msgbox % "ElapsedTime: " (A_TickCount - start) / 1000 " Seconds.`n" devs
 
return