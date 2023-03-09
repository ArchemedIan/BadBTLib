#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent ;Keeps script open
#SingleInstance Force

Global BadBTLib_Req_Major := 0
Global BadBTLib_Req_Minor := 1
#include ..\BadBTLib.ahk
FileDelete, BTDevInfo.txt



NameOrAddr := "Joy-Con (L)"   ;search for a left joycon
BtDevice := BTDevInfo(NameOrAddr, 25) ; for 32 seconds (25 x 1.28)


;store infos
Name 	:= BtDevice.Name
Addr 	:= BtDevice.Addr
CoD 	:= BtDevice.CoD
ConSts 	:= BtDevice.ConSts
RemSts 	:= BtDevice.RemSts
AuthSts := BtDevice.AuthSts
LSeen 	:= BtDevice.LSeen
LUsed 	:= BtDevice.LUsed

info :=	"Device #: " Devnum "`nName: " Name "`nAddr: " Addr "`nCoD: " CoD "`nConSts: " ConSts "`nRemSts: " RemSts "`nAuthSts: " AuthSts "`nLSeen: " LSeen "`nLUsed: " LUsed "`n`n"

FileAppend, % info, %A_ScriptDir%\BTDevInfo.txt

ExitApp