const GLOBAL_INTERVAL_IN_SECONDS = 100000
const LIFE_INTERVAL_IN_SECONDS = 8000000
const SESSION_INTERVAL_IN_SECONDS = 500000

strComputer = "."
set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\default")
set objItem = objWMIService.Get("SystemRestoreConfig='SR'")
objItem.DiskPercent = 10
objItem.RPGlobalInterval = GLOBAL_INTERVAL_IN_SECONDS
objItem.RPLifeInterval = LIFE_INTERVAL_IN_SECONDS
objItem.RPSessionInterval = SESSION_INTERVAL_IN_SECONDS
objItem.Put_
