:: delete IIS files older than 180 days
:: -s or /S : recurse into all subfolders
:: -p or /P : path
:: -m or /M : file mask
:: -d or /D : number of days (-30 = older than 30 days)
:: -c or /C : command to execute
forfiles /P C:\inetpub\logs\LogFiles\ /S /M *.log /D -180 /C "cmd /C DEL @File"
