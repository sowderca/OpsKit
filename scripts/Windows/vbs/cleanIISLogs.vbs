dim sLogFolder
dim iMaxAge
set sLogFolder = "c:\inetpub\logs\LogFiles"
set iMaxAge = 30   'in days

set objFSO = CreateObject("Scripting.FileSystemObject")
set colFolder = objFSO.GetFolder(sLogFolder)

for each colSubfolder in colFolder.SubFolders
        set objFolder = objFSO.GetFolder(colSubfolder.Path)
        set colFiles = objFolder.Files
        for each objFile in colFiles
                iFileAge = now-objFile.DateCreated
                if iFileAge > (iMaxAge+1)  then
                        objFSO.deletefile objFile, true
                end if
        next
next
