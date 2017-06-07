﻿function Generate_DNSServer {
<#
.SYNOPSIS
Generates Dockerfile contents for DNS Server component 

.PARAMETER ManifestPath
The filesystem path where the JSON manifests are stored.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $MountPath,
    
    [Parameter(Mandatory = $true)]
    [string] $ManifestPath
)

    $ArtifactName = Split-Path -Path $PSScriptRoot -Leaf

    Write-Verbose -Message ('Generating result for {0} component' -f $ArtifactName)
    $Manifest = '{0}\{1}.json' -f $ManifestPath, $ArtifactName

    $Artifact = Get-Content -Path $Manifest -Raw | ConvertFrom-Json

    $ResultBuilder = GetDockerfileBuilder
    if ($Artifact.Status -eq 'Enabled') {    
        $null = $ResultBuilder.AppendLine('RUN Enable-WindowsOptionalFeature -Online -FeatureName DNS-Server-Full-Role')
        $null = $ResultBuilder.AppendLine('EXPOSE 53')
        $null = $ResultBuilder.AppendLine('CMD /Wait-Service.ps1 -ServiceName DNS -AllowServiceRestart')
    }

    return $ResultBuilder.ToString()
}