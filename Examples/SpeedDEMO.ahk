SetBatchLines -1
#NoEnv 
#SingleInstance Force
QPC := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "kernel32", "Ptr"), "AStr", "QueryPerformanceCounter", "Ptr")
QPF := DllCall("GetProcAddress", "Ptr", DllCall("GetModuleHandle", "Str", "kernel32", "Ptr"), "AStr", "QueryPerformanceFrequency", "Ptr")
DllCall(QPF, "Int64*", freq)

;start := A_TickCount
DllCall(QPC, "Int64*", startLoadLib)
SetWorkingDir %A_ScriptDir%   
#include ..\BadBTLib.ahk
DllCall(QPC, "Int64*", endLoadLib)
DllCall(QPC, "Int64*", start)
BTDevList := BTDevList(15, 0)
NumOfDevices := BTDevList.Length()  
loop %NumOfDevices%
	devs := devs BtDevList[A_Index].Name " Connected: " (BtDevList[A_Index].ConSts  ? "Yes`n" : "No`n")
DllCall(QPC, "Int64*", end)
LoadLibtimer := ((endLoadLib - startLoadLib)* (1000/freq))/1000
infotimer := ((end - start)* (1000/freq))/1000
total := LoadLibtimer + infotimer
IniRead, Fastest, SpeedDEMORecord.txt, Record, Fastest, ERROR
IniRead, Slowest, SpeedDEMORecord.txt, Record, Slowest, ERROR
rec := "`n"
if (Fastest != "ERROR") 
{
	if (total < Fastest)
	{
		rec := " (Fastest recorded!)`n"
		Fastest := total
		IniWrite,% Fastest, SpeedDEMORecord.txt, Record, Fastest
	}
}
else
{
	Fastest := total
	IniWrite,% Fastest, SpeedDEMORecord.txt, Record, Fastest
}
if (Slowest != "ERROR") 
{
	if (total > Slowest)
	{
		rec := " (Slowest recorded!)`n"
		Slowest := total
		IniWrite,% Slowest, SpeedDEMORecord.txt, Record, Slowest
	}
}
else
{
	Slowest := total
	IniWrite,% Slowest, SpeedDEMORecord.txt, Record, Slowest
}

msgbox % "ElapsedTime: `nLibrary:" A_Tab LoadLibtimer " Seconds.`nDevs:" A_Tab infotimer " Seconds.`nTotal:" A_Tab total " Seconds." rec "`nFastest:" A_Tab Fastest " Seconds.`nSlowest:" A_Tab Slowest " Seconds.`n`nDevices:`n"  devs
 
return