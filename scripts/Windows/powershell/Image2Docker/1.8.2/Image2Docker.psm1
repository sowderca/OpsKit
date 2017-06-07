#requires -runasadministrator

enum ImageType {
    Unknown
    VHDX
    WIM
}

enum SourceType {
    Image
    Local
    Remote
}

### Obtain the module path
$ModulePath = $ExecutionContext.SessionState.Module.ModuleBase

### Import private (internal) functions
$PrivateFunctionList = Get-ChildItem -Path $PSScriptRoot\Functions\Private -File -Filter *.ps1 -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"}
foreach ($File in $PrivateFunctionList) {
    . $File.FullName
}

Remove-Variable -Name File

### Import public-facing functions 
$PublicFunctionList = Get-ChildItem -Path $PSScriptRoot\Functions\Public -File -Filter *.ps1 -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"}
foreach ($File in $PublicFunctionList) {
    . $File.FullName
}

Remove-Variable -Name File

Get-ChildItem -Path $PSScriptRoot\completers\*.ps1 | foreach { . $_.FullName}