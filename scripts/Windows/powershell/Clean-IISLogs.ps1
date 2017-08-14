try {
    Import-Module -Name "WebAdministration";
    [int] $keepNumberOfDays = 90;

    Get-ChildItem -Path "IIS:\Sites" |
        ForEach-Object {
            $logDir = [System.Environment]::ExpandEnvironmentVariables($_.LogFile.Directory);
            Get-ChildItem -Path $logDir -Recurse -Filter *.log |
                Where-Object {
                    $_.PSIsContainer -eq $false -and $_.LastWriteTime -le (Get-Date).AddDays(-$keepNumberOfDays)
                } |
                    ForEach-Object {
                        Remove-Item $_.FullName -Force
                    }
                }
    } catch {
        if (Test-Path -Path $env:windir\system32\forfiles.exe) {
            forfiles -p C:\inetpub\logs\LogFiles\ -s -m *.log -d -90 -c "cmd /C del @File"
        }
	}
