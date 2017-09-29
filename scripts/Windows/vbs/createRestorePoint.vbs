const DEVICE_DRIVER_INSTALL = 10
const BEGIN_SYSTEM_CHANGE = 100

strComputer = "."
set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\default")
set objItem = objWMIService.Get("SystemRestore")
errResults = objItem.CreateRestorePoint("Scripted restore", DEVICE_DRIVER_INSTALL, BEGIN_SYSTEM_CHANGE)
