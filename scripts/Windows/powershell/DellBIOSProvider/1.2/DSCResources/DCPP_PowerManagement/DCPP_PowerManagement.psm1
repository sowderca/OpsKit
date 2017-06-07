# Import the helper functions

Import-Module $PSScriptRoot\..\..\Misc\helper.psm1 -Verbose:$false
function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$BlockDefinition
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	<#
	$returnValue = @{
		BlockDefinition = [System.String]
		Category = [System.String]
		AutoOn = [System.String]
		AutoOnHr = [System.UInt16]
		AutoOnMn = [System.UInt16]
		AutoOnSun = [System.String]
		AutoOnMon = [System.String]
		AutoOnTue = [System.String]
		AutoOnWed = [System.String]
		AutoOnThur = [System.String]
		AutoOnFri = [System.String]
		AutoOnSat = [System.String]
		DeepSleepCtrl = [System.String]
		FanSpeed = [System.String]
		FanSpeedLvl = [System.UInt16]
		UsbWake = [System.String]
		FanCtrlOvrd = [System.String]
		AcPwrRcvry = [System.String]
		WakeOnLan = [System.String]
		SfpwakeOnLan = [System.String]
		WakeOnAc = [System.String]
		WakeOnDock = [System.String]
		LidSwitch = [System.String]
		BlinkPowerSupply1LED = [System.String]
		BlinkPowerSupply2LED = [System.String]
		WlanAutoSense = [System.String]
		WwanAutoSense = [System.String]
		BlockSleep = [System.String]
		SleepMode = [System.String]
		PrimaryBattChargeCfg = [System.String]
		CustomChargeStart = [System.UInt16]
		CustomChargeStop = [System.UInt16]
		SliceBattChargeCfg = [System.String]
		ModBattChargeCfg = [System.String]
		DockBatteryChargeConfiguration = [System.String]
		IntlSmartConnect = [System.String]
		IntelReadyModeEn = [System.String]
		PeakShiftCfg = [System.String]
		PeakShiftBatteryThreshold = [System.UInt16]
		PeakShiftDayConfiguration = [System.String]
		StartTime = [System.String]
		EndTime = [System.String]
		ChargeStartTime = [System.String]
		AdvBatteryChargeCfg = [System.String]
		AdvancedBatteryChargeConfiguration = [System.String]
		Type_CBatteryOverloadProtection = [System.String]
		BeginningOfDay = [System.String]
		WorkPeriod = [System.String]		
		Password = [System.String]
		SecurePassword = [System.String]
		PathToKey = [System.String]
	}

	$returnValue
	#>

# Check if module DellBIOSprovider is already loaded. If not, load it.
    try{
        $bool = Confirm-DellPSDrive -verbose
    }
    catch 
    {
        write-Verbose $_
        $msg = "Get-TargetResource: $($_.Exception.Message)"
        Write-DellEventLog -Message $msg -EventID 1 -EntryType 'Error'
        write-Verbose "Exiting Get-TargetResource"
        return
    }
    if ($bool) {                      
        Write-Verbose "Dell PS-Drive DellSmbios is found."
    }
    else{
        $Message = “Get-TargetResource: Module DellBiosProvider was imported correctly."
        Write-DellEventLog -Message $Message -EventID 2 
    }
    
    
    $Get = get-childitem -path @("DellSmbios:\" + $Category)
    # Removing Verbose and Debug from output
    $PSBoundParameters.Remove("Verbose") | out-null
    $PSBoundParameters.Remove("Debug") | out-null

    $out = @{}  
    $Get | foreach-Object {$out.Add($_.Attribute, $_.CurrentValue)}
    
    $out.add('Category', $Category )
    $out
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$BlockDefinition,

		[System.String]
		$Category,

		[ValidateSet("EveryDay","Disabled","WeekDays","SelectDays")]
		[System.String]
		$AutoOn,

		[System.UInt16]
		$AutoOnHr,

		[System.UInt16]
		$AutoOnMn,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnSun,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnMon,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnTue,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnWed,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnThur,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnFri,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnSat,

		[ValidateSet("Disabled","S5Only","S4AndS5")]
		[System.String]
		$DeepSleepCtrl,

		[ValidateSet("Auto","High","Med","Low","MedHigh","MedLow")]
		[System.String]
		$FanSpeed,

		[System.UInt16]
		$FanSpeedLvl,

		[ValidateSet("Disabled","Enabled")]
		[System.String]
		$UsbWake,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$FanCtrlOvrd,

		[ValidateSet("Off","On","Last")]
		[System.String]
		$AcPwrRcvry,

		[ValidateSet("AddInCard","Onboard","Disabled","LanOnly","LanWithPxeBoot","WlanOnly","LanWlan")]
		[System.String]
		$WakeOnLan,

		[ValidateSet("SFP","LANSFP","SFPPXE")]
		[System.String]
		$SfpwakeOnLan,

		[ValidateSet("Disabled","Enabled")]
		[System.String]
		$WakeOnAc,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$WakeOnDock,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$LidSwitch,

		[ValidateSet("Enabled")]
		[System.String]
		$BlinkPowerSupply1LED,

		[ValidateSet("Enabled")]
		[System.String]
		$BlinkPowerSupply2LED,

		[ValidateSet("Disabled","Enabled")]
		[System.String]
		$WlanAutoSense,

		[ValidateSet("Disabled","Enabled")]
		[System.String]
		$WwanAutoSense,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$BlockSleep,

		[ValidateSet("OSAutomaticSelection","ForceS3")]
		[System.String]
		$SleepMode,

		[ValidateSet("Auto","Standard","Express","PrimAcUse","Custom")]
		[System.String]
		$PrimaryBattChargeCfg,

		[System.UInt16]
		$CustomChargeStart,

		[System.UInt16]
		$CustomChargeStop,

		[ValidateSet("Standard","Express")]
		[System.String]
		$SliceBattChargeCfg,

		[ValidateSet("Standard","Express")]
		[System.String]
		$ModBattChargeCfg,

		[ValidateSet("Standard","Express")]
		[System.String]
		$DockBatteryChargeConfiguration,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$IntlSmartConnect,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$IntelReadyModeEn,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PeakShiftCfg,

		[System.UInt16]
		$PeakShiftBatteryThreshold,

		[System.String]
		$PeakShiftDayConfiguration,

		[System.String]
		$StartTime,

		[System.String]
		$EndTime,

		[System.String]
		$ChargeStartTime,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AdvBatteryChargeCfg,

		[System.String]
		$AdvancedBatteryChargeConfiguration,

		[ValidateSet("7.5Watts","15Watts")]
		[System.String]
		$Type_CBatteryOverloadProtection,

		[System.String]
		$BeginningOfDay,

		[System.String]
		$WorkPeriod,

		[System.String]
		$Password,

		[System.String]
		$SecurePassword,

		[System.String]
		$PathToKey
	)

    if (-not(CheckModuleLoaded)) {
        Write-Verbose -Message 'Required module DellBiosProvider does not exist. Exiting.'
        return $true
    }

    $DellPSDrive = get-psdrive -name Dellsmbios
    if ( !$DellPSDrive) {
        $Message = "Drive DellSmbios is not found. Exiting."
        Write-Verbose $Message
        Write-DellEventLog -Message $Message -EventID 3 -EntryType "Error"
        return $true
    }

      
    $atts = $PSBoundParameters

    $pathToCategory = $DellPSDrive.Name + ':\' + $atts["Category"]
    
    Dir $pathToCategory -verbose

    $atts.Remove("Verbose") | out-null
    $atts.Remove("Category") | out-null
    $atts.Remove("Debug") | out-null
    $atts.Remove("BlockDefinition") | out-null
    $startTime=$atts['StartTime']
    $endTime=$atts['EndTime']
    $chargeStartTime=$atts['ChargeStartTime']
	$atts.Remove("StartTime") | out-null
	$atts.Remove("EndTime") | out-null
	$atts.Remove("ChargeStartTime") | out-null
    $beginningOfDay=$atts['BeginningOfDay']
    $workPeriod=$atts['WorkPeriod']
    $atts.Remove("BeginningOfDay") | out-null
	$atts.Remove("WorkPeriod") | out-null
	$securePwd=$atts["SecurePassword"]
    $passwordSet=$atts["Password"]
    $atts.Remove("Password") | Out-Null
    $atts.Remove("SecurePassword") | Out-Null
	$pathToKey=$atts["PathToKey"]
	if(-Not [string]::IsNullOrEmpty($pathToKey))
	{  
		if(Test-Path $pathToKey)
		{
		$key=Get-Content $pathToKey
		}
		else
		{
		$key=""
		}
	}
    $atts.Remove("PathToKey") | Out-Null

    $atts.Keys | foreach-object {
					
                    if($($_) -eq "PeakShiftDayConfiguration")
                    {
                     $path = $pathToCategory + '\' + $($_)
                    $value = $atts[$_]
					if(-Not [string]::IsNullOrEmpty($securePwd))
					{                
					$pasvar=ConvertTo-SecureString $securePwd.ToString() -Key $key
					Set-Item  -path $path -value $value -StartTime $startTime -EndTime $endTime -ChargeStartTime $chargeStartTime -verbose -ErrorVariable ev -ErrorAction SilentlyContinue -PasswordSecure $pasvar
					}

					elseif(-Not [string]::IsNullOrEmpty($passwordSet))
					{
					Set-Item  -path $path -value $value -StartTime $startTime -EndTime $endTime -ChargeStartTime $chargeStartTime -verbose -ErrorVariable ev -ErrorAction SilentlyContinue -Password $passwordSet
					}

					else
					{
					Set-Item  -path $path -value $value -StartTime $startTime -EndTime $endTime -ChargeStartTime $chargeStartTime -verbose -ErrorVariable ev -ErrorAction SilentlyContinue
					}
                    
                    if ( $ev) { 
                        $cmdline = $ExecutionContext.InvokeCommand.ExpandString($ev.InvocationInfo.Line)
                        $Message = "An error occured in executing " + $cmdline + "`nError message: $($ev.ErrorDetails)"
                        Write-Verbose $Message
                        Write-DellEventLog -Message $Message -EventID 5 -EntryType "Error"
                    }
                    }
					
					elseif($($_) -eq "AdvancedBatteryChargeConfiguration")
                    {
                     $path = $pathToCategory + '\' + $($_)
                    $value = $atts[$_]
					
					if(-Not [string]::IsNullOrEmpty($securePwd))
					{                
					$pasvar=ConvertTo-SecureString $securePwd.ToString() -Key $key
					Set-Item  -path $path -value $value -BeginningOfDay $beginningOfDay -WorkPeriod $workPeriod -verbose -ErrorVariable ev -ErrorAction SilentlyContinue -PasswordSecure $pasvar
					}

					elseif(-Not [string]::IsNullOrEmpty($passwordSet))
					{
					Set-Item  -path $path -value $value -BeginningOfDay $beginningOfDay -WorkPeriod $workPeriod -verbose -ErrorVariable ev -ErrorAction SilentlyContinue -Password $passwordSet
					}

					else
					{
					Set-Item  -path $path -value $value -BeginningOfDay $beginningOfDay -WorkPeriod $workPeriod -verbose -ErrorVariable ev -ErrorAction SilentlyContinue
					}
					
                    
                    if ( $ev) { 
                        $cmdline = $ExecutionContext.InvokeCommand.ExpandString($ev.InvocationInfo.Line)
                        $Message = "An error occured in executing " + $cmdline + "`nError message: $($ev.ErrorDetails)"
                        Write-Verbose $Message
                        Write-DellEventLog -Message $Message -EventID 5 -EntryType "Error"
                    }
                    }
					
                     else
                     {
                     $path=""
                        if($($_) -eq "Type_CBatteryOverloadProtection")
                    {
                    $path = $pathToCategory + '\' + "Type-CBatteryOverloadProtection"
                    }					 

                    else
                    {
                    $path = $pathToCategory + '\' + $($_)
                    }
                    $value = $atts[$_]

					if(-Not [string]::IsNullOrEmpty($securePwd))
					{                
					$pasvar=ConvertTo-SecureString $securePwd.ToString() -Key $key
					Set-Item  -path $path -value $value -verbose -ErrorVariable ev -ErrorAction SilentlyContinue -PasswordSecure $pasvar
					}

					elseif(-Not [string]::IsNullOrEmpty($passwordSet))
					{
					Set-Item  -path $path -value $value -verbose -ErrorVariable ev -ErrorAction SilentlyContinue -Password $passwordSet
					}

					else
					{
					Set-Item  -path $path -value $value -verbose -ErrorVariable ev -ErrorAction SilentlyContinue
					}

                    
                    if ( $ev) { 
                        $cmdline = $ExecutionContext.InvokeCommand.ExpandString($ev.InvocationInfo.Line)
                        $Message = "An error occured in executing " + $cmdline + "`nError message: $($ev.ErrorDetails)"
                        Write-Verbose $Message
                        Write-DellEventLog -Message $Message -EventID 5 -EntryType "Error"
                    }
                    }
                 
                 }


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$BlockDefinition,

		[System.String]
		$Category,

		[ValidateSet("EveryDay","Disabled","WeekDays","SelectDays")]
		[System.String]
		$AutoOn,

		[System.UInt16]
		$AutoOnHr,

		[System.UInt16]
		$AutoOnMn,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnSun,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnMon,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnTue,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnWed,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnThur,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnFri,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AutoOnSat,

		[ValidateSet("Disabled","S5Only","S4AndS5")]
		[System.String]
		$DeepSleepCtrl,

		[ValidateSet("Auto","High","Med","Low","MedHigh","MedLow")]
		[System.String]
		$FanSpeed,

		[System.UInt16]
		$FanSpeedLvl,

		[ValidateSet("Disabled","Enabled")]
		[System.String]
		$UsbWake,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$FanCtrlOvrd,

		[ValidateSet("Off","On","Last")]
		[System.String]
		$AcPwrRcvry,

		[ValidateSet("AddInCard","Onboard","Disabled","LanOnly","LanWithPxeBoot","WlanOnly","LanWlan")]
		[System.String]
		$WakeOnLan,

		[ValidateSet("SFP","LANSFP","SFPPXE")]
		[System.String]
		$SfpwakeOnLan,

		[ValidateSet("Disabled","Enabled")]
		[System.String]
		$WakeOnAc,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$WakeOnDock,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$LidSwitch,

		[ValidateSet("Enabled")]
		[System.String]
		$BlinkPowerSupply1LED,

		[ValidateSet("Enabled")]
		[System.String]
		$BlinkPowerSupply2LED,

		[ValidateSet("Disabled","Enabled")]
		[System.String]
		$WlanAutoSense,

		[ValidateSet("Disabled","Enabled")]
		[System.String]
		$WwanAutoSense,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$BlockSleep,

		[ValidateSet("OSAutomaticSelection","ForceS3")]
		[System.String]
		$SleepMode,

		[ValidateSet("Auto","Standard","Express","PrimAcUse","Custom")]
		[System.String]
		$PrimaryBattChargeCfg,

		[System.UInt16]
		$CustomChargeStart,

		[System.UInt16]
		$CustomChargeStop,

		[ValidateSet("Standard","Express")]
		[System.String]
		$SliceBattChargeCfg,

		[ValidateSet("Standard","Express")]
		[System.String]
		$ModBattChargeCfg,

		[ValidateSet("Standard","Express")]
		[System.String]
		$DockBatteryChargeConfiguration,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$IntlSmartConnect,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$IntelReadyModeEn,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PeakShiftCfg,

		[System.UInt16]
		$PeakShiftBatteryThreshold,

		[System.String]
		$PeakShiftDayConfiguration,

		[System.String]
		$StartTime,

		[System.String]
		$EndTime,

		[System.String]
		$ChargeStartTime,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AdvBatteryChargeCfg,

		[System.String]
		$AdvancedBatteryChargeConfiguration,

		[ValidateSet("7.5Watts","15Watts")]
		[System.String]
		$Type_CBatteryOverloadProtection,

		[System.String]
		$BeginningOfDay,

		[System.String]
		$WorkPeriod,

		[System.String]
		$Password,

		[System.String]
		$SecurePassword,

		[System.String]
		$PathToKey
	)

	$Get = Get-TargetResource $PSBoundParameters['Category'] -verbose

    New-DellEventLog
  
    $PSBoundParameters.Remove("Verbose") | out-null
    $PSBoundParameters.Remove("Debug") | out-null
    $PSBoundParameters.Remove("Category") | out-null

    $startTime=$PSBoundParameters['StartTime']
    $endTime=$PSBoundParameters['EndTime']
    $chargestartTime=$PSBoundParameters['ChargeStartTime']
	$beginningOfDay=$PSBoundParameters['BeginningOfDay']
	$workPeriod=$PSBoundParameters['WorkPeriod']

    $PSBoundParameters.Remove("StartTime") | out-null
    $PSBoundParameters.Remove("EndTime") | out-null
    $PSBoundParameters.Remove("ChargeStartTime") | out-null
	$PSBoundParameters.Remove("BeginningOfDay") | out-null
	$PSBoundParameters.Remove("WorkPeriod") | out-null
    $PSBoundParameters.Remove("BlockDefinition") | out-null

   $bool = $true

  
   foreach ($config_att in  $PSBoundParameters.GetEnumerator())
   {
    if ($Get.ContainsKey($config_att.Key)) {
    if($config_att.Key -match "PeakShiftDayConfiguration")
    {
    $currentvalue = $Get[$config_att.Key]
    $whichDay=$config_att.Value


    if($whichDay -eq "Monday")
    {
    $iIndex=0
    }

    elseif($whichDay -eq "Tuesday")
    {
    $iIndex=1
    }

    elseif($whichDay -eq "Wednesday")
    {
    $iIndex=2
    }

        elseif($whichDay -eq "Thursday")
    {
    $iIndex=3
    }

        elseif($whichDay -eq "Friday")
    {
    $iIndex=4
    }

        elseif($whichDay -eq "Saturday")
    {
    $iIndex=5
    }

        elseif($whichDay -eq "Sunday")
    {
    $iIndex=6
    }

            if (($currentvalue[$iIndex].StartTime -ne $startTime) -or ($currentvalue[$iIndex].EndTime -ne $endTime) -or ($currentvalue[$iIndex].ChargeStartTime -ne $chargestartTime)){
            $bool = $false
            #$drift  = "`nCurrentValue: $currentvalue_nospace`nDesiredValue: $($config_att.value)"
            $drift  = "`nCurrentValue: StartTime "+$currentvalue[$iIndex].StartTime+" EndTime "+$currentvalue[$iIndex].EndTime+" ChargeStartTime "+$currentvalue[$iIndex].ChargeStartTime+"`nDesiredValue: StartTime "+$startTime+" EndTime "+$endTime+" ChargeStartTime "+$chargestartTime
            $message = "Configuration is drifted in category $Category for $($config_att.Key). $drift"
           
            write-verbose $message
            Write-DellEventLog -Message $message -EventID 4 -EntryType Warning
            
        }
        else {
            write-Debug "Configuration is same for $config_att."
        
        }

    }

	elseif($config_att.Key -match "AdvancedBatteryChargeConfiguration")
    {
    $currentvalue = $Get[$config_att.Key]
    $whichDay=$config_att.Value


    if($whichDay -eq "Monday")
    {
    $iIndex=0
    }

    elseif($whichDay -eq "Tuesday")
    {
    $iIndex=1
    }

    elseif($whichDay -eq "Wednesday")
    {
    $iIndex=2
    }

        elseif($whichDay -eq "Thursday")
    {
    $iIndex=3
    }

        elseif($whichDay -eq "Friday")
    {
    $iIndex=4
    }

        elseif($whichDay -eq "Saturday")
    {
    $iIndex=5
    }

        elseif($whichDay -eq "Sunday")
    {
    $iIndex=6
    }

            if (($currentvalue[$iIndex].BeginningOfDay -ne $beginningOfDay) -or ($currentvalue[$iIndex].WorkPeriod -ne $workPeriod)){
            $bool = $false
            #$drift  = "`nCurrentValue: $currentvalue_nospace`nDesiredValue: $($config_att.value)"
            $drift  = "`nCurrentValue: BeginningOfDay "+$currentvalue[$iIndex].BeginningOfDay+" WorkPeriod "+$currentvalue[$iIndex].WorkPeriod+"`nDesiredValue: BeginningOfDay "+$beginningOfDay+" WorkPeriod "+$workPeriod
            $message = "Configuration is drifted in category $Category for $($config_att.Key). $drift"
           
            write-verbose $message
            Write-DellEventLog -Message $message -EventID 4 -EntryType Warning
            
        }
        else {
            write-Debug "Configuration is same for $config_att."
        
        }

    }

	
	
    else
    {
     $currentvalue=""
    if($config_att.Key -match "Type_CBatteryOverloadProtection")
    {
    $currentvalue = $Get["Type-CBatteryOverloadProtection"]
    }
    else
    {
        $currentvalue = $Get[$config_att.Key]
    }
        $currentvalue_nospace = $currentvalue -replace " ", ""
        if ($config_att.Value -ne $currentvalue_nospace){
            $bool = $false
            $drift  = "`nCurrentValue: $currentvalue_nospace`nDesiredValue: $($config_att.value)"
            $message = "Configuration is drifted in category $Category for $($config_att.Key). $drift"
           
            write-verbose $message
            Write-DellEventLog -Message $message -EventID 4 -EntryType Warning
            
        }
        else {
            write-Debug "Configuration is same for $config_att."
        
        }
    }

    }
    else {
        $message = "Unsupported attribute $($config_att)."
        Write-Verbose $message
    }
  }
  

   return $bool
}


Export-ModuleMember -Function *-TargetResource


# SIG # Begin signature block
# MIIVSQYJKoZIhvcNAQcCoIIVOjCCFTYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBzj/Mbey6Unvhu
# vupwyh0qcB+RrxreeBmc0E88WTwMjKCCCiMwggTCMIIDqqADAgECAhANhLMrA8kb
# dRADSKysMihfMA0GCSqGSIb3DQEBCwUAMH8xCzAJBgNVBAYTAlVTMR0wGwYDVQQK
# ExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEfMB0GA1UECxMWU3ltYW50ZWMgVHJ1c3Qg
# TmV0d29yazEwMC4GA1UEAxMnU3ltYW50ZWMgQ2xhc3MgMyBTSEEyNTYgQ29kZSBT
# aWduaW5nIENBMB4XDTE2MDEyMDAwMDAwMFoXDTE5MDIxODIzNTk1OVowWjELMAkG
# A1UEBhMCVVMxDjAMBgNVBAgTBVRleGFzMRMwEQYDVQQHEwpSb3VuZCBSb2NrMRIw
# EAYDVQQKFAlEZWxsIEluYy4xEjAQBgNVBAMUCURlbGwgSW5jLjCCASIwDQYJKoZI
# hvcNAQEBBQADggEPADCCAQoCggEBAIiB7p20xoJ8RMmDhIKNR/g0X6OhJWWiaLL6
# OY8sCfY9B8BhCOKzCgNQU+g5Jdu5GZ+J7G8S7evlJfhskLH4fhkGYjn4a1sPw/mD
# m/qMaE4n9WLaRourdOIIWgYftCGmjrlpTq7d4rYZ+Oo+iaQTR1OIrnJ7UbV6YYKp
# /buZ3pcrWAB7ox3UDeH/UigGP+QIix5mQrRmQLgZyJkg5V9EB/m2HYmQ+w13VNIf
# adxPklaF1sNMJTRwzKzqZru4N7goue63NAu8COhQ9+c8MIom+VjDVuDR01UY25vQ
# IVJ8Sbk3ORD20Eb6a7ZxVb29Lkn6/cOccCf6tuAe7sd9skZAbJsCAwEAAaOCAV0w
# ggFZMAkGA1UdEwQCMAAwDgYDVR0PAQH/BAQDAgeAMCsGA1UdHwQkMCIwIKAeoByG
# Gmh0dHA6Ly9zdi5zeW1jYi5jb20vc3YuY3JsMGEGA1UdIARaMFgwVgYGZ4EMAQQB
# MEwwIwYIKwYBBQUHAgEWF2h0dHBzOi8vZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUF
# BwICMBkMF2h0dHBzOi8vZC5zeW1jYi5jb20vcnBhMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMFcGCCsGAQUFBwEBBEswSTAfBggrBgEFBQcwAYYTaHR0cDovL3N2LnN5bWNk
# LmNvbTAmBggrBgEFBQcwAoYaaHR0cDovL3N2LnN5bWNiLmNvbS9zdi5jcnQwHwYD
# VR0jBBgwFoAUljtT8Hkzl699g+8uK8zKt4YecmYwHQYDVR0OBBYEFIb5/xrKh87H
# XzS6cRL1o7LqbfaDMA0GCSqGSIb3DQEBCwUAA4IBAQCFWAnqZghMKytZjfSKt94F
# eB/VfyFl+3tWhPN8SFkXUdIDljd3t5dggtIYAc7TPKfOr8JngIRQmM0lOyj/bzOM
# Chdb8nEbKV4R6krbF423gSVFcYoZsiCoqV2An5OrnnRDPPmgWs5wJvgwk/iGeEYE
# /DQE8J0hWVr4tTQVKRaCBM4DVfK4Z2Mp5BAewp9jxvDS/cuguTQdQP+mtYxmkkXU
# SyTq+olOm8YVPAw0tpRGbZjPdxK2++EIeVrTL7jscqhuMx8d985A4corhmQdZ7Un
# qTurFTSdgqxqZeJiYVFqhp1c9wbCwFuCSTyJiissW+BC4lt+N2oFOSieit7gnmP8
# MIIFWTCCBEGgAwIBAgIQPXjX+XZJYLJhffTwHsqGKjANBgkqhkiG9w0BAQsFADCB
# yjELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQL
# ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTowOAYDVQQLEzEoYykgMjAwNiBWZXJp
# U2lnbiwgSW5jLiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MUUwQwYDVQQDEzxW
# ZXJpU2lnbiBDbGFzcyAzIFB1YmxpYyBQcmltYXJ5IENlcnRpZmljYXRpb24gQXV0
# aG9yaXR5IC0gRzUwHhcNMTMxMjEwMDAwMDAwWhcNMjMxMjA5MjM1OTU5WjB/MQsw
# CQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNV
# BAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxMDAuBgNVBAMTJ1N5bWFudGVjIENs
# YXNzIDMgU0hBMjU2IENvZGUgU2lnbmluZyBDQTCCASIwDQYJKoZIhvcNAQEBBQAD
# ggEPADCCAQoCggEBAJeDHgAWryyx0gjE12iTUWAecfbiR7TbWE0jYmq0v1obUfej
# DRh3aLvYNqsvIVDanvPnXydOC8KXyAlwk6naXA1OpA2RoLTsFM6RclQuzqPbROlS
# Gz9BPMpK5KrA6DmrU8wh0MzPf5vmwsxYaoIV7j02zxzFlwckjvF7vjEtPW7ctZlC
# n0thlV8ccO4XfduL5WGJeMdoG68ReBqYrsRVR1PZszLWoQ5GQMWXkorRU6eZW4U1
# V9Pqk2JhIArHMHckEU1ig7a6e2iCMe5lyt/51Y2yNdyMK29qclxghJzyDJRewFZS
# AEjM0/ilfd4v1xPkOKiE1Ua4E4bCG53qWjjdm9sCAwEAAaOCAYMwggF/MC8GCCsG
# AQUFBwEBBCMwITAfBggrBgEFBQcwAYYTaHR0cDovL3MyLnN5bWNiLmNvbTASBgNV
# HRMBAf8ECDAGAQH/AgEAMGwGA1UdIARlMGMwYQYLYIZIAYb4RQEHFwMwUjAmBggr
# BgEFBQcCARYaaHR0cDovL3d3dy5zeW1hdXRoLmNvbS9jcHMwKAYIKwYBBQUHAgIw
# HBoaaHR0cDovL3d3dy5zeW1hdXRoLmNvbS9ycGEwMAYDVR0fBCkwJzAloCOgIYYf
# aHR0cDovL3MxLnN5bWNiLmNvbS9wY2EzLWc1LmNybDAdBgNVHSUEFjAUBggrBgEF
# BQcDAgYIKwYBBQUHAwMwDgYDVR0PAQH/BAQDAgEGMCkGA1UdEQQiMCCkHjAcMRow
# GAYDVQQDExFTeW1hbnRlY1BLSS0xLTU2NzAdBgNVHQ4EFgQUljtT8Hkzl699g+8u
# K8zKt4YecmYwHwYDVR0jBBgwFoAUf9Nlp8Ld7LvwMAnzQzn6Aq8zMTMwDQYJKoZI
# hvcNAQELBQADggEBABOFGh5pqTf3oL2kr34dYVP+nYxeDKZ1HngXI9397BoDVTn7
# cZXHZVqnjjDSRFph23Bv2iEFwi5zuknx0ZP+XcnNXgPgiZ4/dB7X9ziLqdbPuzUv
# M1ioklbRyE07guZ5hBb8KLCxR/Mdoj7uh9mmf6RWpT+thC4p3ny8qKqjPQQB6rqT
# og5QIikXTIfkOhFf1qQliZsFay+0yQFMJ3sLrBkFIqBgFT/ayftNTI/7cmd3/SeU
# x7o1DohJ/o39KK9KEr0Ns5cF3kQMFfo2KwPcwVAB8aERXRTl4r0nS1S+K4ReD6bD
# dAUK75fDiSKxH3fzvc1D1PFMqT+1i4SvZPLQFCExggp8MIIKeAIBATCBkzB/MQsw
# CQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNV
# BAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxMDAuBgNVBAMTJ1N5bWFudGVjIENs
# YXNzIDMgU0hBMjU2IENvZGUgU2lnbmluZyBDQQIQDYSzKwPJG3UQA0isrDIoXzAN
# BglghkgBZQMEAgEFAKCBrDAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgpeb9M96T
# F51qZBY2Md/ffpksv/Aaunhmslr77gsBRggwQAYKKwYBBAGCNwIBDDEyMDCgFoAU
# AEQAZQBsAGwALAAgAEkAbgBjAC6hFoAUaHR0cDovL3d3dy5kZWxsLmNvbSAwDQYJ
# KoZIhvcNAQEBBQAEggEAAyxU+fLbVf3gpUbHVyKVATQKgX+LNHl2VUqMPHlwRhVq
# yVvGMyEiMmx/edj/HTk6MOjXAK9TW4lcxy61I6hFtGYUB2cWm3WFSEtCjCj6h30f
# 2o3N46dS69zc4TFa8lilNrhDsncxj7vbjUR+bahlGgHx6k4260f0Qi+qNd1qhckJ
# DKNWZTqp63tfRAtFtsKwq60ava4K7+6o1ejYE/Ctjj/USpnKF0iOG2Mzmq9JUvOv
# 5Nw3bGrex6PtnPQak42DK0PHpuSp+iXgUQXWcM99YSFLfQJve4f58bsXfFXuNeai
# NMVFzdcbrQ7Tji5GTxpqEgvNP+2pwHVSjyh/5B4y0qGCCAowgggGBgorBgEEAYI3
# AwMBMYIH9jCCB/IGCSqGSIb3DQEHAqCCB+MwggffAgEDMQ8wDQYJYIZIAWUDBAIB
# BQAwbQYLKoZIhvcNAQkQAQSgXgRcMFoCAQEGCmCGSAGG/W4BBxgwMTANBglghkgB
# ZQMEAgEFAAQgB4052X0j7GrYEf40hTzh9ewnm2k13YkeDVHO+UBIZXoCBQU/S6VL
# GA8yMDE3MDEzMTA2NDU1NFqgggTxMIIE7TCCA9WgAwIBAgIIPG49fSM2JU0wDQYJ
# KoZIhvcNAQELBQAwgY8xCzAJBgNVBAYTAlVTMRAwDgYDVQQIEwdBcml6b25hMRMw
# EQYDVQQHEwpTY290dHNkYWxlMSUwIwYDVQQKExxTdGFyZmllbGQgVGVjaG5vbG9n
# aWVzLCBJbmMuMTIwMAYDVQQDEylTdGFyZmllbGQgUm9vdCBDZXJ0aWZpY2F0ZSBB
# dXRob3JpdHkgLSBHMjAeFw0xNjEyMTMwNzAwMDBaFw0yMTEyMTMwNzAwMDBaMIGI
# MQswCQYDVQQGEwJVUzEQMA4GA1UECBMHQXJpem9uYTETMBEGA1UEBxMKU2NvdHRz
# ZGFsZTElMCMGA1UEChMcU3RhcmZpZWxkIFRlY2hub2xvZ2llcywgSW5jLjErMCkG
# A1UEAxMiU3RhcmZpZWxkIFRpbWVzdGFtcCBBdXRob3JpdHkgLSBHMjCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBAMMSt+zDfQd/+EDESIH4xIOLzJkCgOFq
# yWKYMsVjvYH7vCdlU0EAGu2AlzYiIjKbaGYLbQFtOf+ohaiLl6ewX04FImdW6c97
# 5Uoie+XnMGYOVySnWHIXv/q6fFX7Rgwh50vOMCDuKHCCpx3MrYU5g0kP3J+Psv9j
# E2Nc0jkOeHQadrpVTo8HGCWoz7XCLFIfCdjjWkoDLu4B0/9yehNaC+ZwrOy9cnUE
# NhnE/+0WMIoUdOLkD/Eq24ATVBVXBe7Q3o4/7hzYWPoABigrHpB6q1u1ILpB+Ze2
# K3rdWz4t93k+yqCybnZVFKuJZy53VS4PDszfiRHfIEZo2TZGBgIVfX8CAwEAAaOC
# AVAwggFMMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgbAMBYGA1UdJQEB/wQM
# MAoGCCsGAQUFBwMIMB0GA1UdDgQWBBTFhkohftnytX2hAaysXl3+FYL3vzAfBgNV
# HSMEGDAWgBR8DDIfp9kwf8R9aKNiqKHOqwdbJzA6BggrBgEFBQcBAQQuMCwwKgYI
# KwYBBQUHMAGGHmh0dHA6Ly9vY3NwLnN0YXJmaWVsZHRlY2guY29tLzBGBgNVHR8E
# PzA9MDugOaA3hjVodHRwOi8vY3JsLnN0YXJmaWVsZHRlY2guY29tL3JlcG9zaXRv
# cnkvc2Zyb290LWcyLmNybDBQBgNVHSAESTBHMEUGC2CGSAGG/W4BBxcCMDYwNAYI
# KwYBBQUHAgEWKGh0dHA6Ly9jcmwuc3RhcmZpZWxkdGVjaC5jb20vcmVwb3NpdG9y
# eS8wDQYJKoZIhvcNAQELBQADggEBAC1Tnm2HG1bh1d39Qe2NWq9CxxtZRHG3BR0h
# jgVznfEgv9I7fSQrnKbuE1q03r7BkLyZ57qQPIHN7Sm/DtfRpQ/XzO3V/SKcXcHp
# LSZNjCX38cTr4Bpnk0TzQFtCYiFGjEY66pvDLKOLdkpXqfdZjxCyhpAArlcH9EhO
# HEMjXDgJnurEtSG4G5RpS1/hA6BDI6+v/rgTCEuKUVCVMwkUWF5+elrNt2UN2SJA
# uwRwoYddTw3w68FU6YlPydL9DGxdS8UzP4udpfkuZGekvHm2nikbD+4J7NDXm4k9
# c2NzMwbdVlg7LDCoqVntapOQqZS4XMqSD6/eo/X14FBwhx4tB60xggJjMIICXwIB
# ATCBnDCBjzELMAkGA1UEBhMCVVMxEDAOBgNVBAgTB0FyaXpvbmExEzARBgNVBAcT
# ClNjb3R0c2RhbGUxJTAjBgNVBAoTHFN0YXJmaWVsZCBUZWNobm9sb2dpZXMsIElu
# Yy4xMjAwBgNVBAMTKVN0YXJmaWVsZCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0
# eSAtIEcyAgg8bj19IzYlTTANBglghkgBZQMEAgEFAKCBmDAaBgkqhkiG9w0BCQMx
# DQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTE3MDEzMTA2NDU1NFowKwYL
# KoZIhvcNAQkQAgwxHDAaMBgwFgQUcUS1PxpdOR3drHG2ByGQjJsb8/YwLwYJKoZI
# hvcNAQkEMSIEIAKYc8TY8tqzls6XmGf7fTT+4mi5ddcBYH/ohVO7sUTUMA0GCSqG
# SIb3DQEBAQUABIIBACTyUsizbxkOBv2P+1oe2PbS/FrlSCNeawJDJ6pWQ5lDSovW
# sGHiAJ6D0rO3paI7Wi+ESFh9vqtYTj77c+GHFPoVcKcBAUVvsZZs+PHxsLgRDx0A
# bwfJJaC/AuHReIKGwxxKFd7xt6qWEVKHTYfGnT7oM5ryKbDbcWjIcPc/k/EqUItX
# KvR6xvrdK7mYrYBGhtXp1L7VgWf/nIb5SCfzfoYeMy62Y3oows8x9JeS2aFN6bYp
# pur3lYGD/mJ2pTj3coCpGEyOHk1gDYXTnf8mZEf/eNBD3CDiVhnFEFboQTBMy020
# dH4SDgm1Rvc3R9AULXneucY7nKG1y3BB7+L7SRA=
# SIG # End signature block
