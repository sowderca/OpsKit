<#
.DESCRIPTION
	Returns information about printers and their drivers
.NOTES
	DriverVersion is in uint64 format by default, this script formats the version to match the Print Management MMC Conosle.
.LINK
	http://blog.powershell.no/2013/09/08/get-printerdriver-driver-version/
.LINK
	https://msdn.microsoft.com/en-us/library/windows/desktop/aa381058(v=vs.85).aspx
#>
$printers = Get-Printer

foreach ($printer in $printers) {
	$driver = Get-PrinterDriver -Name $printer.DriverName
	$ver = $driver.DriverVersion
	# Format the version to match what is seen in the Print Management MMC Console.
	$rev = $ver -band 0xffff
	$build = ($ver -shr 16) -band 0xffff
	$minor = ($ver -shr 32) -band 0xffff
	$major = ($ver -shr 48) -band 0xffff
	$printerData = New-Object -TypeName "PSObject" -Property @{
		PrinterName = $printer.Name
		DriverName = $printer.DriverName
		DriverVersion = "$major.$minor.$build.$rev"
	}
	$printerData
}