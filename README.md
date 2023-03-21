### ["Give me money. Money me! Money now! Me a money needing a lot now."](https://paypal.me/DvdIsDead)


# BadBTLib 

Badly made AHK Bluetooth library, Directly interacts with windows bluetooth apis

## What This Does

- Change name of (some) bluetooth devices (you'll have to toggle bluetooth off and on to see change)
- Get first Radio (BT adapter) and their its info (need more adapters to test and implement a full list) 
- List Bluetooth devices (by parameter) and their infos
- connect and disconnect BT devices (open and close services of a bluetooth device by CLSID)
- interact with windows bluetooth quicker than any other method ive found

### Pre-requisites

- Bluetooth adapter (obviously)
- Bluetooth On
- [*Current* AHK](https://www.autohotkey.com/download/ahk-install.exe) **Not version 2**

## Compilation

- ~~Download AutoHotKey from above and Install it.~~ 

TODO: CLI interface when compiled

# Usage

- `#include BadBTLib.ahk`
- ~~BadBTLib.exe --some-command~~

https://github.com/ArchemedIan/BadBTLib/tree/main/Examples

```#include BadBTLib.ahk
;;;;;;;;;;			Funtion List			;;;;;;;;;;

;; BTFirstRadioInfo()
;;;; Returns AHK Object of the First BT Radio AND its info, see example for usage


;; BTDevList(Search_Params, Timeout)
;;;; Returns AHK Object of BT devices AND their info, see example for usage, Search params, and what info is availible
;;;;
;;;; Default search parameters and timeout will instantly return all connected, authenticated and remembered devices, 
;;;; and any unknown device windows is currently tracking
;;;;
;;;; Timeout is in multiples of 1.28 seconds, so a value of 5 is 6.4 seconds, blame microsoft. 


;; BTDevInfo(NameOrAddr, Timeout)
;;;; Returns AHK object of a single bluetooth devices info, see example for usage and what info is availible
;;;;
;;;; Will return any device found within the timeout, default Timeout is 0, which will usually only return 
;;;; authenticated, remembered, and/or connected devices, but can also return unknown devices if the timing is right.
;;;;
;;;; Again, timeout is in multiples of 1.28 seconds, so a value of 5 is 6.4 seconds, blame microsoft.


;; mkBTDevInfoSTRUCT(Var, Addr, Name, CoD)
;;;; Creates a variable that refers to a (STRUCTured) space in memory that can be used by 
;;;; windows/C functions (i think thats what im doing??? lol)
;;;;
;;;; This is how youll adress a specific device when dis/connecting or otherwise manipulating 
;;;; the status or services of a bluetooth device.
;;;;
;;;; The variable name (Var, not Name) is the only required input, but may not work in all cases if theyre not 
;;;; all specified; and obviously wont work if none are, but it will still create an empty structure
;;;;
;;;; You should use BTDevInfo() to get the information required.


;; BTUpdateDevName(NewName, Addr)
;;;; Changes display name of a device by address


;; BTSetServiceState(OnOff, BTDevInfoSTRUCT, CLSID)   ( THIS IS HOW YOU CONNECT DEVICES )
;;;; Change the state of a service by CLSID (google is your friend)
;;;;
;;;; On (1) off (0) or Toggle off then on (2)

```

## Roadmap

- Possibly handle pairing (which is not necessary for most HID devices / controllers by the way)
- find way to enable/disable bluetooth (other than powershell)
- Add more windows functions that could be useful, if any
- CLI interface when compiled
