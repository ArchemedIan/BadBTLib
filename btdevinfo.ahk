#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ;Keeps script open
#SingleInstance Force

Global BadBTLib_Req_Major := 0
Global BadBTLib_Req_Minor := 1
#include BadBTLib.ahk


FileDelete, btdevinfo.txt
BtDevices := BTDevList(31, 8)
NumOfDevices := BtDevices.Length()
;msgbox % NumOfDevices
loop %NumOfDevices%
{
	Devnum	:= A_Index 
	Name 	:= BtDevices[A_Index].Name
	Addr 	:= BtDevices[A_Index].Addr
	CoD 	:= BtDevices[A_Index].CoD
	ConSts 	:= BtDevices[A_Index].ConSts
	RemSts 	:= BtDevices[A_Index].RemSts
	AuthSts := BtDevices[A_Index].AuthSts
	LSeen 	:= BtDevices[A_Index].LSeen
	LUsed 	:= BtDevices[A_Index].LUsed

	info :=	"Device #: " Devnum "`nName: " Name "`nAddr: " Addr "`nCoD: " CoD "`nConSts: " ConSts "`nRemSts: " RemSts "`nAuthSts: " AuthSts "`nLSeen: " LSeen "`nLUsed: " LUsed "`n`n"
	
	FileAppend, % info, %A_ScriptDir%\btdevinfo.txt
}
ExitApp