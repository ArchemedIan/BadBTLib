

Global BadBTLib_Ver_Major := 0
Global BadBTLib_Ver_Minor := 2
VerChk()

;;;;;;;;;;			Funtion List			;;;;;;;;;;
;; BTDevList(Search_Params, Timeout)
;;;; Returns AHK Object of BT devices AND their info, see example for usage, Search params, and what info is availible
;;;; Default search parameters and timeout will instantly return all connected, authenticated and remembered devices, and any unknown device windows is currently tracking
;;;; Timeout is in multiples of 1.28 seconds, so a value of 5 is 6.4 seconds, blame microsoft. 
;;
;; BTDevInfo(NameOrAddr, Timeout)
;;;; Returns AHK object of a single bluetooth devices info, see example for usage and what info is availible 
;;;; Will return any device found within the timeout, default Timeout is 0, which will usually only return authenticated, remembered, and/or connected devices, but can also return unknown devices if the timing is right.
;;;; Again, timeout is in multiples of 1.28 seconds, so a value of 5 is 6.4 seconds, blame microsoft. 
;;
;; mkBTDevInfoSTRUCT(Var, Addr, Name, CoD)
;;;; Creates a variable that refers to a (STRUCTured) space in memory that can be used by windows/C functions (i think thats what im doing??? lol)
;;;; This is how youll adress a specific device when dis/connecting or otherwise manipulating the status or services of a bluetooth device.
;;;; The variable name is the only required input, but may not work in all cases if theyre not all specified; and obviously wont work if none are, but it will still create an empty structure
;;;; You should use BTDevInfo() to get the information required.
;;
;; BTSetServiceState(OnOff, BTDevInfoSTRUCT, CLSID)
;;;; Change the state of a service by CLSID (google is your friend)
;;;; On (1) off (0) or Toggle off then on (2)



;;;;;;;;;;			Functions			;;;;;;;;;;

;;;;;;;; BTDev

BTDevList(Search_Params=31, Timeout=0)
{
	ThisBtDevices := {}
	;https://learn.microsoft.com/en-us/windows/win32/api/bluetoothapis/ns-bluetoothapis-bluetooth_device_search_params
	DllCall("LoadLibrary", "str", "Bthprops.cpl", "ptr")
	VarSetCapacity(BLUETOOTH_DEVICE_SEARCH_PARAMS, 24+A_PtrSize*2, 0)
	NumPut(24+A_PtrSize*2, BLUETOOTH_DEVICE_SEARCH_PARAMS, 0, "uint")
	
	if (Search_Params > 31)
		msgbox invalid BT search params, exiting...
	if (Search_Params > 31)
		ExitApp
	if (Search_Params = 0)
		Search_Params := 31
	
	Search_Params_dec := Search_Params
	
	Search_Params_bin := Bin(Search_Params_dec)

	Search_Params := ""
	Search_Params := {}
	
	
	loop % StrLen(Search_Params_bin)
	{
		Search_Params[A_Index] := SubStr(Search_Params_bin, A_Index * -1 , 1)
	}
	ReturnAuthenticated := Search_Params[1]
	ReturnRemembered := Search_Params[2]
	ReturnUnknown := Search_Params[3]
	ReturnConnected := Search_Params[4]
	IssueInquiry := Search_Params[5]
	
	NumPut(ReturnAuthenticated, BLUETOOTH_DEVICE_SEARCH_PARAMS, 4, "uint") ; fReturnAuthenticated
	NumPut(ReturnRemembered, BLUETOOTH_DEVICE_SEARCH_PARAMS, 8, "uint") ; fReturnRemembered
	NumPut(ReturnUnknown, BLUETOOTH_DEVICE_SEARCH_PARAMS, 12, "uint") ; fReturnUnknown
	NumPut(ReturnConnected, BLUETOOTH_DEVICE_SEARCH_PARAMS, 16, "uint") ; fReturnConnected
	NumPut(IssueInquiry, BLUETOOTH_DEVICE_SEARCH_PARAMS, 20, "uint") ; fIssueInquiry
	NumPut(Timeout, BLUETOOTH_DEVICE_SEARCH_PARAMS, 24, "uint") ; cTimeoutMultiplier
	
	;https://www.autohotkey.com/boards/viewtopic.php?f=76&t=83224&sid=e91fdb4bfefebefbb45b786e56eccdb7&start=20
	VarSetCapacity(BLUETOOTH_DEVICE_INFO, 560, 0)
	NumPut(560, BLUETOOTH_DEVICE_INFO, 0, "uint")
	loop
	{
		If (A_Index = 1)
		{
			foundedDevice := DllCall("Bthprops.cpl\BluetoothFindFirstDevice", "ptr", &BLUETOOTH_DEVICE_SEARCH_PARAMS, "ptr", &BLUETOOTH_DEVICE_INFO)
			if !foundedDevice
			{
				;msgbox "No bluetooth radios found, or off"
				break
			}
		}
		else
		{
			if !DllCall("Bthprops.cpl\BluetoothFindNextDevice", "ptr", foundedDevice, "ptr", &BLUETOOTH_DEVICE_INFO)
			{
				;msgbox "Device list end"
				break
			}
		}
		DevIndex += 1
		ThisName := StrGet(&BLUETOOTH_DEVICE_INFO+64)
		;msgbox % ThisName

		;https://learn.microsoft.com/en-us/windows/win32/api/bluetoothapis/ns-bluetoothapis-bluetooth_device_info_struct	
		ThisAddr :=	NumGet(BLUETOOTH_DEVICE_INFO, 8, "ptr")	;Address
		;msgbox % ThisAddr
		ThisAddr :=	Dec2Mac(ThisAddr)
		ThisCoD :=	NumGet(BLUETOOTH_DEVICE_INFO, 16, "UInt")	;ulClassofDevice
		ThisConSts := NumGet(BLUETOOTH_DEVICE_INFO, 20, "Int")	;fConnected
		ThisRemSts := NumGet(BLUETOOTH_DEVICE_INFO, 24, "Int")	;fRemembered
		ThisAuthSts := NumGet(BLUETOOTH_DEVICE_INFO, 28, "Int")	;fAuthenticated
		
			;stLastSeen ThisLSeen := NumGet(BLUETOOTH_DEVICE_INFO, 32, "Ptr")	
		ThisLSeenYear := NumGet(BLUETOOTH_DEVICE_INFO, 32, "UShort")
		ThisLSeenMonth := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 2, "UShort")
		ThisLSeenDayOfWeek := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 4, "UShort")
		ThisLSeenDay := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 6, "UShort")
		ThisLSeenHour := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 8, "UShort")
		ThisLSeenMinute := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 10, "UShort")
		ThisLSeenSecond := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 12, "UShort")
		ThisLSeenMilliseconds := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 14, "UShort")
		ThisLSeen := Timestamp(ThisLSeenYear, ThisLSeenMonth, ThisLSeenDay, ThisLSeenHour, ThisLSeenMinute,  ThisLSeenSecond, ThisLSeenMilliseconds, "-")

			;stLastUsed ThisLUsed := NumGet(BLUETOOTH_DEVICE_INFO, 48, "Ptr")
		ThisLUsedYear := NumGet(BLUETOOTH_DEVICE_INFO, 48, "UShort")
		ThisLUsedMonth := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 2, "UShort")
		ThisLUsedDayOfWeek := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 4, "UShort")
		ThisLUsedDay := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 6, "UShort")
		ThisLUsedHour := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 8, "UShort")
		ThisLUsedMinute := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 10, "UShort")
		ThisLUsedSecond := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 12, "UShort")
		ThisLUsedMilliseconds := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 14, "UShort")
		ThisLUsed := Timestamp(ThisLUsedYear, ThisLUsedMonth, ThisLUsedDay, ThisLUsedHour, ThisLUsedMinute,  ThisLUsedSecond, ThisLUsedMilliseconds, "-")

		
		if ( ThisName = "")
			ThisName = (no device name)
		
		ThisBtDevices[DevIndex] := object("Name",ThisName, "Addr",ThisAddr, "CoD",ThisCoD, "ConSts",ThisConSts, "RemSts",ThisRemSts, "AuthSts",ThisAuthSts, "LSeen",ThisLSeen, "LUsed",ThisLUsed)
	}
	DllCall("Bthprops.cpl\BluetoothFindDeviceClose", "ptr", foundedDevice)
	;msgbox % nameList
	Return ThisBtDevices
}

BTDevInfo(NameOrAddr,Timeout=0)
{
	ThisBtDevice := {}
	;https://learn.microsoft.com/en-us/windows/win32/api/bluetoothapis/ns-bluetoothapis-bluetooth_device_search_params
	DllCall("LoadLibrary", "str", "Bthprops.cpl", "ptr")
	VarSetCapacity(BLUETOOTH_DEVICE_SEARCH_PARAMS, 24+A_PtrSize*2, 0)
	NumPut(24+A_PtrSize*2, BLUETOOTH_DEVICE_SEARCH_PARAMS, 0, "uint")

	ReturnAuthenticated := 1
	ReturnRemembered := 1
	ReturnUnknown := 1
	ReturnConnected := 1
	if (Timeout > 0)
		IssueInquiry := 1
	else
		IssueInquiry := 0
	
	NumPut(ReturnAuthenticated, BLUETOOTH_DEVICE_SEARCH_PARAMS, 4, "uint") ; fReturnAuthenticated
	NumPut(ReturnRemembered, BLUETOOTH_DEVICE_SEARCH_PARAMS, 8, "uint") ; fReturnRemembered
	NumPut(ReturnUnknown, BLUETOOTH_DEVICE_SEARCH_PARAMS, 12, "uint") ; fReturnUnknown
	NumPut(ReturnConnected, BLUETOOTH_DEVICE_SEARCH_PARAMS, 16, "uint") ; fReturnConnected
	NumPut(IssueInquiry, BLUETOOTH_DEVICE_SEARCH_PARAMS, 20, "uint") ; fIssueInquiry
	NumPut(Timeout, BLUETOOTH_DEVICE_SEARCH_PARAMS, 24, "uint") ; cTimeoutMultiplier
	
	;https://www.autohotkey.com/boards/viewtopic.php?f=76&t=83224&sid=e91fdb4bfefebefbb45b786e56eccdb7&start=20
	VarSetCapacity(BLUETOOTH_DEVICE_INFO, 560, 0)
	NumPut(560, BLUETOOTH_DEVICE_INFO, 0, "uint")
	BtDevFound := 0
	loop
	{
		If (A_Index = 1)
		{
			foundedDevice := DllCall("Bthprops.cpl\BluetoothFindFirstDevice", "ptr", &BLUETOOTH_DEVICE_SEARCH_PARAMS, "ptr", &BLUETOOTH_DEVICE_INFO)
			if !foundedDevice
			{
				;msgbox "No bluetooth radios found, or off"
				break
			}
		}
		else
		{
			if !DllCall("Bthprops.cpl\BluetoothFindNextDevice", "ptr", foundedDevice, "ptr", &BLUETOOTH_DEVICE_INFO)
			{
				;msgbox "Device list end"
				break
			}
		}
		ThisName := StrGet(&BLUETOOTH_DEVICE_INFO+64)
		;msgbox % ThisName

		;https://learn.microsoft.com/en-us/windows/win32/api/bluetoothapis/ns-bluetoothapis-bluetooth_device_info_struct	
		ThisAddr :=	NumGet(BLUETOOTH_DEVICE_INFO, 8, "ptr")	;Address
		;msgbox % ThisAddr
		ThisAddr :=	Dec2Mac(ThisAddr)
		
		if (ThisName != NameOrAddr) and (ThisAddr != NameOrAddr)
			continue
		
		BtDevFound := 1
		
		ThisCoD :=	NumGet(BLUETOOTH_DEVICE_INFO, 16, "UInt")	;ulClassofDevice
		ThisConSts := NumGet(BLUETOOTH_DEVICE_INFO, 20, "Int")	;fConnected
		ThisRemSts := NumGet(BLUETOOTH_DEVICE_INFO, 24, "Int")	;fRemembered
		ThisAuthSts := NumGet(BLUETOOTH_DEVICE_INFO, 28, "Int")	;fAuthenticated
		
			;stLastSeen ThisLSeen := NumGet(BLUETOOTH_DEVICE_INFO, 32, "Ptr")	
		ThisLSeenYear := NumGet(BLUETOOTH_DEVICE_INFO, 32, "UShort")
		ThisLSeenMonth := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 2, "UShort")
		ThisLSeenDayOfWeek := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 4, "UShort")
		ThisLSeenDay := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 6, "UShort")
		ThisLSeenHour := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 8, "UShort")
		ThisLSeenMinute := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 10, "UShort")
		ThisLSeenSecond := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 12, "UShort")
		ThisLSeenMilliseconds := NumGet(BLUETOOTH_DEVICE_INFO, 32 + 14, "UShort")
		ThisLSeen := Timestamp(ThisLSeenYear, ThisLSeenMonth, ThisLSeenDay, ThisLSeenHour, ThisLSeenMinute,  ThisLSeenSecond, ThisLSeenMilliseconds, "-")

			;stLastUsed ThisLUsed := NumGet(BLUETOOTH_DEVICE_INFO, 48, "Ptr")
		ThisLUsedYear := NumGet(BLUETOOTH_DEVICE_INFO, 48, "UShort")
		ThisLUsedMonth := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 2, "UShort")
		ThisLUsedDayOfWeek := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 4, "UShort")
		ThisLUsedDay := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 6, "UShort")
		ThisLUsedHour := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 8, "UShort")
		ThisLUsedMinute := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 10, "UShort")
		ThisLUsedSecond := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 12, "UShort")
		ThisLUsedMilliseconds := NumGet(BLUETOOTH_DEVICE_INFO, 48 + 14, "UShort")
		ThisLUsed := Timestamp(ThisLUsedYear, ThisLUsedMonth, ThisLUsedDay, ThisLUsedHour, ThisLUsedMinute,  ThisLUsedSecond, ThisLUsedMilliseconds, "-")

		
		if ( ThisName = "")
			ThisName = (no device name)
		
		ThisBtDevice := object("Name",ThisName, "Addr",ThisAddr, "CoD",ThisCoD, "ConSts",ThisConSts, "RemSts",ThisRemSts, "AuthSts",ThisAuthSts, "LSeen",ThisLSeen, "LUsed",ThisLUsed)
		DllCall("Bthprops.cpl\BluetoothFindDeviceClose", "ptr", foundedDevice)
		;msgbox % nameList
		Return ThisBtDevice
	}
	return "DeviceNotFound"
}

mkBTDevInfoSTRUCT(ByRef var,Addr,Name="",CoD="")
{
	dwSize := 560
	szName := Name
	Address := Mac2Dec(Addr)
	ulClassofDevice := CoD
	;fConnected
	;fRemembered
	;fAuthenticated
	;stLastSeen
	;stLastUsed

	VarSetCapacity(var, dwSize, 0)
	NumPut(dwSize, var, 0, "UInt")
	

	NumPut(Address, var, 8, "Ptr")
	NumPut(ulClassofDevice, var, 16, "UInt")
	;NumPut(fConnected, BLUETOOTH_DEVICE_INFO_STRUCT, 20, "Int")
	;NumPut(fRemembered, BLUETOOTH_DEVICE_INFO_STRUCT, 24, "Int")
	;NumPut(fAuthenticated, BLUETOOTH_DEVICE_INFO_STRUCT, 28, "Int")
	;NumPut(stLastSeen, BLUETOOTH_DEVICE_INFO_STRUCT, 32, "Ptr")
	;NumPut(stLastUsed, BLUETOOTH_DEVICE_INFO_STRUCT, 48, "Ptr")

;Name
	;plan0
	StrPut(szName, &var + 64, 248)
	
	
	;Plan A.
	;StrPut(szName, &var + 64, 248, "UTF-16")
	
	
	; Plan B. Try this if Plan A fails.
	; szName := "Put your string here."
	; StrPutVar(szName, Pointer_szName, "UTF-16")
	; NumPut(&Pointer_szName, BLUETOOTH_DEVICE_INFO_STRUCT, 64, "Ptr")
	
	
	return 
}

BTSetServiceState(OnOff, ByRef BTDevInfoSTRUCT, CLSID="{00001124-0000-1000-8000-00805F9B34FB}")
{

			VarSetCapacity(ThisCLSID, 16)
			DllCall("ole32\CLSIDFromString", "wstr", CLSID, "ptr", &ThisCLSID)
			
			if (OnOff = 0)
				TogOff := 1
				
			if (OnOff = 1)
				TogOn := 1	
			
			if (OnOff = 2)
			{
				TogOff := 1
				TogOn := 1
			}	
			
			loop
			{
				tries += 1
				if (TogOff = 1) and (ToggedOff != 1)
					ServiceOff := DllCall("Bthprops.cpl\BluetoothSetServiceState", "ptr", 0, "ptr", &BTDevInfoSTRUCT, "ptr", &ThisCLSID, "int", 0) 
					
				if (ServiceOff = 0)
					ToggedOff := 1
					
				if (ToggedOff != 1) and (tries < 500)
					Continue
			
				if (TogOn = 1) (ToggedOn != 1)
					ServiceOn := DllCall("Bthprops.cpl\BluetoothSetServiceState", "ptr", 0, "ptr", &BTDevInfoSTRUCT, "ptr", &ThisCLSID, "int", 1)
					
				if (ServiceOn = 0)
					ToggedOn := 1
					
				if (ToggedOn = 1)
					break
				
				if (tries > 500)
					Return 500
			}
			Return 0
}







;;;;;;;; Misc


Timestamp(Year="", Month="", Day="", Hour="", Minute="", Second="", Milliseconds="", dashes="")
{
	if (StrLen(Month) < 2) and (Month != "")
		Month := "0" Month
				
	if (StrLen(Day) < 2) and (Day != "")
		Day := "0" Day
		
	if (StrLen(Hour) < 2) and (Hour != "")
		Hour := "0" Hour
		
	if (StrLen(Minute) < 2) and (Minute != "")
		Minute := "0" Minute
		
	if (StrLen(Second) < 2) and (Second != "")
		Second := "0" Second
		
	if (StrLen(Milliseconds) < 2) and (Milliseconds != "")
		Milliseconds := "0" Milliseconds

	if (Year != "") 
		TimeStamp := Year dashes
	
	if (Month != "")
		TimeStamp := TimeStamp Month dashes
	
	if (Day != "")
		TimeStamp := TimeStamp Day dashes
	
	if (Hour != "")
		TimeStamp := TimeStamp Hour dashes
	
	if (Minute != "") 
			TimeStamp := TimeStamp Minute dashes
	
	if (Second != "") 
		TimeStamp := TimeStamp Second dashes
	

	if (Milliseconds != "") 
		TimeStamp := TimeStamp Milliseconds

	return TimeStamp
}

Mac2Dec(Addr) 
{
    Addr := StrReplace(Addr, ":")
	
	SetFormat, integer, D
	Dec += "0x" Addr
	return Dec
}

Dec2Mac( int, pad=0 ) 
{ 
; "Pad" may be the minimum number of digits that should appear on the right of the "0x".

	Static hx := "0123456789ABCDEF"

	If !( 0 < int |= 0 )

		Return !int ? "0x0" : "-" Dec2Mac( -int, pad )

	s := 1 + Floor( Ln( int ) / Ln( 16 ) )

	h := SubStr( "0x0000000000000000", 1, pad := pad < s ? s + 2 : pad < 16 ? pad + 2 : 18 )

	u := A_IsUnicode = 1

	Loop % s

		NumPut( *( &hx + ( ( int & 15 ) << u ) ), h, pad - A_Index << u, "UChar" ), int >>= 4

	RawMac := SubStr(h, 3)
	;12
	loop 12
	{
		if (A_Index = 1)
			Mac := SubStr(RawMac, 1, 1)
		else 
			if (Mod(A_Index,2) = 1)
				Mac := Mac ":" SubStr(RawMac, A_Index, 1)
			else
				Mac := Mac SubStr(RawMac, A_Index, 1)
	}
	Return Mac

}

Bin(x){
	while x
		r:=1&x r,x>>=1
	return r
}

Dec(x){
	b:=StrLen(x),r:=0
	loop,parse,x
		r|=A_LoopField<<--b
	return r
}

StrPutVar(str, ByRef var, encoding)
	{
	  factor := (encoding="utf-16" or encoding="cp1200") ? 2 : 1
	  VarSetCapacity(var, StrPut(str, encoding) * factor)
	  return StrPut(str, &var, encoding)
	}

VerChk()
{
	if (BadBTLib_Req_Major > BadBTLib_Ver_Major)
		VerError := "expexted major ver`: " BadBTLib_Req_Major "`, got`: "BadBTLib_Ver_Major
		
	if (BadBTLib_Req_Minor > BadBTLib_Ver_Minor) and (BadBTLib_Req_Major > BadBTLib_Ver_Major)
		VerError := VerError "`nexpexted minor ver`: " BadBTLib_Req_Minor "`, got`: " BadBTLib_Ver_Minor
	else
		if (BadBTLib_Req_Minor > BadBTLib_Ver_Minor)
			VerError := "expexted minor ver`: " BadBTLib_Req_Minor "`, got`: " BadBTLib_Ver_Minor
			
	if (BadBTLib_Req_Minor > BadBTLib_Ver_Minor) or (BadBTLib_Req_Major > BadBTLib_Ver_Major)
	{
		VerError := VerError "`nErrors may occur"
		TrayTip , BadBTLib Version mismatch, % VerError, 8, 1
		return VerError
	}
	
	return 0
}

