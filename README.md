### ["Give me money. Money me! Money now! Me a money needing a lot now."](https://paypal.me/DvdIsDead)


# BadBTLib 

Badly made AHK Bluetooth library, Directly interacts with windows bluetooth apis

## What This Does

- Get first Radio (BT adapter) and their its info (need more adapters to test and implement full list) 
- List Bluetooth devices (by parameter) and their infos
- connect and disconnect BT devices (open and close services of a bluetooth device by CLSID)
- interact with windows bluetooth quicker than any other method ive found

### Pre-requisites

- Bluetooth adapter (obviously)
- Bluetooth On
- [*Current* AHK](https://www.autohotkey.com/download/ahk-install.exe) **Not version 2**

## Installation

~~- Download AutoHotKey from above and Install it.~~ 
TODO: CLI interface when compiled

# Usage

`#include BadBTLib.ahk` 
~~BadBTLib.exe --some-command~~

## Roadmap

- Possibly handle pairing (which is not necessary for most HID devices / controllers by the way)
- find way to enable/disable bluetooth (other than powershell)
- Add more windows functions that could be useful, if any
- CLI interface when compiled
