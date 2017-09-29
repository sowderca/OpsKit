strComputer = "."
set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\default")
set objItem = objWMIService.Get("SystemRestore")
errResults = objItem.Enable("")
