#requires -Version 5.0
using namespace Microsoft.Win32;

$ErrorActionPreference = "SilentlyContinue";

# These registry keys will only exist if the OS was deployed using MDT & CloneTools2
[string] $deploymentMetaDataLocation = "SOFTWARE\Microsoft\Deployment 4";
[string] $cloneToolsMetaDataLocation = "SOFTWARE\VC3\CloneTools";
[string] $agentConfigurationMetaDataLocation = "SOFTWARE\VC3\AgentConfiguration";
[string] $imageVersionMetaDataLocation = "SOFTWARE\VC3\VOA";

<#
.SYNOPSIS
Returns metadata tattoed onto the machines during image deployment by Microsoft Deployment Tools and CloneTools2

.DESCRIPTION
Pulls metadata information from 'HKLM:\SOFTWARE\Microsoft\Deployment 4', 'HKLM:\SOFTWARE\VC3\CloneTools', 'HKLM:\SOFTWARE\VC3\AgentConfiguration'

.PARAMETER RegistryKeys
A list of registry keys to pull values from

.EXAMPLE
Get-MetaData -RegistryKeys @('SOFTWARE\Microsoft\Deployment 4', 'SOFTWARE\VC3\CloneTools')

.NOTES
Ensure that the keys exist prior to running the command.
#>
function Get-MetaData {
    param(
        [Parameter(Mandatory=$true)]
        [string[]] $RegistryKeys
    )
    foreach ($RegistryKey in $RegistryKeys) {
        if (!(Test-Path -Path "HKLM:\$RegistryKey")) {
            Write-Warning -Message "The registry key $RegistryKey can not be found.";
        }
        [void] $RegistryKey.Replace('\', '\\');
        # Access HKEY_LOCAL_MACHINE with the default view.
        [RegistryKey] $localKey = [RegistryKey]::OpenBaseKey([RegistryHive]::LocalMachine, [RegistryView]::Default);
        # List the SubKeys values
        [string[]] $pathValue = $localKey.OpenSubKey($RegistryKey).GetValueNames();
        # Iterate through the registry values retriving the value
        foreach ($path in $pathValue) {
            # Use DSC's Registry resource as a template for property names.
            [pscustomobject] @{
                Key = $RegistryKey
                ValueName = $path
                ValueData = $localKey.OpenSubKey($RegistryKey).GetValue($path);
            }
        }
    }
}

Get-MetaData -RegistryKeys @($deploymentMetaDataLocation, $cloneToolsMetaDataLocation, $agentConfigurationMetaDataLocation);