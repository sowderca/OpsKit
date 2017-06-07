﻿function Clear-JunctionLink {

    <#
    .Synopsis
    Simple helper script that removes any discovered junction links from user's $env:TEMP directory.
    
    .EXAMPLE

    Clear-JunctionLink

    This will remove any mounted images in the $env:TEMP directory 
    #>
    [CmdletBinding()]
    param (
    )

    $ItemList = Get-ChildItem -Path $env:TEMP -Directory | Where-Object -FilterScript { $PSItem.LinkType -eq 'Junction' }

    foreach ($Item in $ItemList) {
        Dismount-WindowsImage -Path $Item.FullName -Discard
        Write-Verbose -Message ('Dismounted Windows image from directory: {0}' -f $Item.FullName)
    }

}

