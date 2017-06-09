$computerName = [System.Environment]::MachineName;
$softwareService = Get-WMIObject -Query "select * from softwarelicensingservice" -ComputerName $computerName;
$OEMlicenseKey = $softwareService.OA3xOriginalProductKey;
$softwareService.InstallProductKey($OEMlicenseKey);
$softwareService.RefreshLicenseStatus();