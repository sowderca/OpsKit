dim fso
dim WshShell

set fso = WScript.CreateObject("Scripting.FileSystemObject")
set WshShell = WScript.CreateObject("WScript.Shell")
set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate, (Backup)}!\\.\root\cimv2")
set colLogFiles = objWMIService.ExecQuery("select * from Win32_NTEventLogFile")
for each objLogFile in colLogFiles
	if fso.FileExists(WshShell.ExpandEnvironmentStrings("%windir%\Temp\" & objLogFile.LogFileName & ".evt")) then
		fso.DeleteFile WshShell.ExpandEnvironmentStrings("%windir%\Temp" & objLogFile.LogFileName & ".evt")
		errBackupLog = objLogFile.BackupEventLog(WshShell.ExpandEnvironmentStrings("%windir%\Temp\" & objLogfile.LogFileName & ".evt"))
		if errBackupLog = 0 then
			objLogfile.ClearEventLog()
			WScript.Echo "The " & objLogfile.LogFileName & " event log cleared and backed up"
		end if
	end if
next
