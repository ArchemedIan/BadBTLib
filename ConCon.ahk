#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#Persistent ;Keeps script open
#SingleInstance Force

Global BadBTLib_Req_Major := 0
Global BadBTLib_Req_Minor := 2
#include BadBTLib.ahk

LJoyconAddr := "EC:C4:0D:89:E9:95"
RJoyconAddr := "EC:C4:0D:8A:47:40"

;the second gamepad profile of the joycons is the one windows uses to connect, thats why they wont autoconnect, i think the first profile is used by the switch and expects a switch response to initiate connection 
Gamepad2CLSID := "{00001124-0000-1000-8000-00805F9B34FB}"

;mkBTDevInfoSTRUCT(LJoyConSTRUCT, "EC:C4:0D:89:E9:95", "Joy-Con (L)", "1288")
mkBTDevInfoSTRUCT(LJoyConSTRUCT, "EC:C4:0D:89:E9:95")

;mkBTDevInfoSTRUCT(RJoyConSTRUCT, "EC:C4:0D:8A:47:40", "Joy-Con (R)", "1288")
mkBTDevInfoSTRUCT(RJoyConSTRUCT, "EC:C4:0D:8A:47:40")

SetTimer, ConLCon, -1
sleep 5
GoSub, ConRCon

return

ConLCon:
left := BTSetServiceState(2, LJoyConSTRUCT, Gamepad2CLSID)
return

ConRCon:
right := BTSetServiceState(2, RJoyConSTRUCT, Gamepad2CLSID)
return
