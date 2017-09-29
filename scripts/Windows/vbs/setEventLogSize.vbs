strComputer = "."

set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate,(Security)}!\\.\root\cimv2")
set colLogFiles = objWMIService.ExecQuery("select * from Win32_NTEventLogFile")
for each objLogFile in colLogFiles
	strLogFileName = objLogFile.Name
	set wmiSWbemObject = GetObject("winmgmts:{impersonationLevel=Impersonate}!\\.\root\cimv2:" & "Win32_NTEventlogFile.Name='" & strLogFileName & "'")
	wmiSWbemObject.MaxFileSize = 5000000 ' 5 megabytes
	wmiSWbemObject.OverwriteOutdated = 14 ' 14 days
	wmiSWbemObject.Put_
next
