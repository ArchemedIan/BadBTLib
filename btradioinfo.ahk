#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#Persistent ;Keeps script open
#SingleInstance Force

Global BadBTLib_Req_Major := 0
Global BadBTLib_Req_Minor := 2
#include BadBTLib.ahk




FileDelete, btradioinfo.txt
BtRadio := BTRadioList()
 
Name 	:= BtRadio.Name
Addr 	:= BtRadio.Addr
CoD 	:= BtRadio.CoD
SubVer	:= BtRadio.SubVer
Manufacturer	:= BtRadio.Manufacturer
	
info :=	"Name: " Name "`nAddr: " Addr "`nCoD: " CoD "`nSubVer: " SubVer "`nManufacturer: " Manufacturer
FileAppend , % info "`n", btradioinfo.txt



return



BTRadioList()
{
	ThisBtRadios := {}
	;init lib 
	DllCall("LoadLibrary", "str", "Bthprops.cpl", "ptr")
	
	;init params struct	https://learn.microsoft.com/en-us/windows/win32/api/bluetoothapis/ns-bluetoothapis-bluetooth_find_radio_params
	VarSetCapacity(BLUETOOTH_FIND_RADIO_PARAMS, 4, 0)
	NumPut(4, BLUETOOTH_FIND_RADIO_PARAMS, 0, "uInt")
	
	;init handle (?) ahk complains otherwise
	VarSetCapacity(BLUETOOTH_RADIO_HANDLE, 4) ;dont know what size to make handle, tride huge and 0

	;try (and fail?) to get handle	https://learn.microsoft.com/en-us/windows/win32/api/bluetoothapis/nf-bluetoothapis-bluetoothfindfirstradio
	hRadio := DllCall("Bthprops.cpl\BluetoothFindFirstRadio", "ptr", &BLUETOOTH_FIND_RADIO_PARAMS, "ptr", &BLUETOOTH_RADIO_HANDLE)
	msgbox % "Result: " hRadio " EL: " ErrorLevel 
	
	;init info struct	https://learn.microsoft.com/en-us/windows/win32/api/bluetoothapis/ns-bluetoothapis-bluetooth_radio_info
	VarSetCapacity(BLUETOOTH_RADIO_INFO, 520, 0)
	NumPut(520, BLUETOOTH_RADIO_INFO, 0, "uint")
	
	;try and fail to fill info struct from handle	https://learn.microsoft.com/en-us/windows/win32/api/bluetoothapis/nf-bluetoothapis-bluetoothgetradioinfo
	chk := DllCall("Bthprops.cpl\BluetoothGetRadioInfo", "ptr", &BLUETOOTH_RADIO_HANDLE, "ptr", &BLUETOOTH_RADIO_INFO)
	msgbox % "Result: " chk " EL: " ErrorLevel ;returns 6 which is "invalid handle" https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-






	;;;;;;;;;;cant fill struct, so unimportant;;;;;;;;;;;;;;;
	
	ThisAddr := NumGet(BLUETOOTH_RADIO_INFO, 8, "Ptr")
	ThisAddr :=	Dec2Mac(ThisAddr)
	msgbox % ThisAddr
	;VarSetCapacity(BLUETOOTH_ADDRESS_STRUCT, 8, 0)

	;ullLong := NumGet(BLUETOOTH_RADIO_INFO, 8, "Int64")
	;rgBytes := NumGet(BLUETOOTH_RADIO_INFO, 8, "char")
	;msgbox % ullLong
	;msgbox % rgBytes
	
	ThisName := StrGet(&BLUETOOTH_RADIO_INFO + 16, 248)
	
	ThisCoD := NumGet(BLUETOOTH_RADIO_INFO, 512, "UInt")
	ThisSubVer := NumGet(BLUETOOTH_RADIO_INFO, 516, "UShort")
	ThisManufacturer := NumGet(BLUETOOTH_RADIO_INFO, 518, "UShort")
	if ( ThisName = "")
		ThisName = (no Radio name)
	
	ThisBtRadio := object("Name",ThisName, "Addr",ThisAddr, "CoD",ThisCoD, "SubVer",ThisSubVer, "Manufacturer",ThisManufacturer)
	
	DllCall("Bthprops.cpl\BluetoothFindRadioClose", "ptr", foundedRadio)
	Return ThisBtRadio
	
}

;;;;;;;;;;cant fill struct, so unimportant;;;;;;;;;;;;;;;

mkBTRadioInfoSTRUCT(ByRef var, Addr, Name="", CoD="", Manufacturer="", SubVer="")
{
	dwSize := 520
	szName := Name
	Address := Mac2Dec(Addr)
	ulClassofDevice := CoD
	lmpSubversion := SubVer
	manufacturer := Manufacturer
	
	
	VarSetCapacity(var, dwSize, 0)
	NumPut(dwSize, var, 0, "UInt")
	NumPut(address, var, 8, "Ptr")
	StrPut(szName, &var + 16, 248)
	NumPut(ulClassofDevice, var, 512, "UInt")
	NumPut(lmpSubversion, var, 516, "UShort")
	NumPut(manufacturer, var, 518, "UShort")
	return 
}

BTRadioInfoSTRUCT2Obj(ByRef var)
{
ThisBtRadioObj := 
ThisAddr := NumGet(var, 8, "Ptr")
ThisAddr :=	Dec2Mac(ThisAddr)
ThisName := StrGet(&var + 16, 248)
ThisCoD := NumGet(var, 512, "UInt")
ThisSubVer := NumGet(var, 516, "UShort")
ThisManufacturer := NumGet(var, 518, "UShort")
if ( ThisName = "")
	ThisName = (no Radio name)
		
ThisBtRadioObj := object("Name",ThisName, "Addr",ThisAddr, "CoD",ThisCoD, "SubVer",ThisSubVer, "Manufacturer",ThisManufacturer)
Return ThisBtRadioObj
}