#Requires -Version 3
#Requires -Module OperationValidation

Import-Module -Name "OperationValidation";

<#
.SYNOPSIS
Creates Chocolatey packages .nuspec files from Powershell module manfiests

.DESCRIPTION
Reads settings from .nuspec files and creates modoule manifests based on the settings.

.PARAMETER Path
Path to a directory containing Chocolatey packages

.EXAMPLE
Convert-PackageSpecToManifest -Path "$($env:ChocolateyInstall)\lib";

.NOTES
To be used with the Operation Validation Framework to provide a solid foundation for system integration testing.
#>
function Convert-PackageSpecToManifest {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false)]
		[string] $Path = "$($env:ChocolateyInstall)\lib"
	)
	[System.IO.FileInfo[]] $packages = Get-ChildItem -Path $Path -Recurse -Depth 1 | Where-Object { $_.Extension -eq '.nuspec' };
	[string[]] $options = ((Get-Help -Name "New-ModuleManifest").parameters.parameter | ForEach-Object { $_.name });
	foreach ($package in $packages) {
		[System.Xml.XmlElement] $packageSpec = (Select-Xml -Path $package.FullName -XPath '*').Node.metadata;
		$params = @{
			Path = $package.FullName.Replace('.nuspec', '.psd1')
		}
		[Microsoft.PowerShell.Commands.MemberDefinition[]] $properties = ($packageSpec | Get-Member -MemberType Property);
		foreach ($option in $options) {
			if ($properties | ForEach-Object { $_.Name -like "*$($option)*" }) {
				[Microsoft.PowerShell.Commands.MemberDefinition] $property = ($properties | Where-Object { $_.Name -like "*$($option)*" });
				if ($packageSpec.($property.Name)) {
					$params.Add($option, $packageSpec.($property.Name));
				}
			}
		}
		New-ModuleManifest @params;
	}
};

<#
.SYNOPSIS
Cleans up module manifests from a directory

.DESCRIPTION
Removes module manifests used by the Operation Validation Framework.

.PARAMETER Path
Path to a directory containing Powershell module manifests.

.EXAMPLE
Remove-PackageManifests -Path "$($env:ChocolateyInstall)\lib";

.NOTES
To be used with the Operation Validation Framework to avoid littering the system with unessecary files.
#>
function Remove-PackageManifests {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false)]
		[string] $Path = "$($env:ChocolateyInstall)\lib"
	)
	Get-ChildItem -Path $Path -Recurse -Depth 1 | Where-Object { $_.Extension -eq '.psd1' } | Remove-Item -Force;
};

<#
.SYNOPSIS
Tests the system using the Operation Validation Framework.

.DESCRIPTION
Runs tests using Pester via the Operation Validation Framework on Chocolatey Packages to determine the state of the machine.

.PARAMETER Path
Path to a directory to run the tests on.

.EXAMPLE
Test-SystemState -Path "$($env:ChocolateyInstall)\lib";

.NOTES
Pester / OVF can be run outside of the scope of this funciton for increased persicion / flexibility.
#>
function Test-SystemState {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false)]
		[string] $Path = "$($env:ChocolateyInstall)\lib"
	)
	Convert-PackageSpecToManifest -Path $Path;
	Invoke-OperationValidation -LiteralPath $Path;
	Remove-PackageManifests -Path $Path;
};

Export-ModuleMember -Function @('Test-SystemState', 'Convert-PackageSpecToManifest', 'Remove-PackageManifests');