# Helper functions to be used across resources

Function New-DellEventLog{
[CmdletBinding()]
    param( 
            [Parameter (Mandatory=$false)][System.string] $LogName="DellClientBIOS PowerShell",
            [Parameter (Mandatory=$false)][System.string] $SourceName="DellBIOSProvider DSC"
         )

         $CustomLog = Get-EventLog -list | Where-object { $_.logdisplayname -eq $LogName}
         if (! $CustomLog) {
             $ErrorActionPreference = "Continue"
             try{
                 New-EventLog -LogName $LogName -Source $SourceName
                 Write-EventLog -LogName $LogName -Source $SourceName -EntryType Information -EventID 0 -Message "DellBIOSProvider DSC started."
             }
         
             catch [System.Security.SecurityException] {
              Write-Error "Error:  Run as elevated user.  Unable to write or read to event logs."
            }
         }
         

}

Function Write-DellEventLog{

[CmdletBinding()]
  [OutputType([int])]
    param(
       [Parameter (Mandatory=$false)] [System.string]$LogName="DellClientBIOS PowerShell",
       [Parameter (Mandatory=$false)] [System.string] $SourceName = "DellBIOSProvider DSC",
       [Parameter (Mandatory=$false)] [System.Int16] $EventID=0,
       [Parameter (Mandatory=$false)] [System.String] $EntryType='Information',
       [Parameter(Mandatory=$true)]   [string]$Message
    )

     $CustomLog = Get-EventLog -list | Where-object { $_.logdisplayname -eq $LogName}
         if (! $CustomLog) {
            New-DellEventLog
         }
    Write-EventLog -LogName $LogName -Source $SourceName -EntryType $EntryType -EventID $EventID -Message $Message


}

function Confirm-DellPSDrive{
 [CmdletBinding()]

    # Check if DellBIOSProvider module has already been loaded into the PS session

    $DellPSProvider = Get-Module -name DellBIOSProvider

    if ( !$DellPSProvider)
    {
        Write-Verbose "Drive DellSmbios is not found. Importing DellBiosProvider."
        import-module -name DellBiosProvider -verbose -force -ErrorVariable errorInModule
        If ($errorInModule)
        {
             $Message = �Module DellBiosProvider failed to import. Errors returned: $($errorInModule.exception.message)�
             Throw $Message
        }
        else {
            return $false #  Module was not already loaded
        }
    }
    else
    {
        return $true}
}


function CheckModuleLoaded{
 [CmdletBinding()]

    # Check if DellBIOSProvider module has already been loaded into the PS session

    $DellPSProvider = Get-Module -name DellBIOSProvider

    if ( !$DellPSProvider)
    {
            return $false #  Module was not already loaded
    }
    else
    {
        return $true
    }
}
# SIG # Begin signature block
# MIIVSQYJKoZIhvcNAQcCoIIVOjCCFTYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC6x9zLFGpcQgL3
# nD3MHa+Ep3xyKa03AHXTmy14xLaVWKCCCiMwggTCMIIDqqADAgECAhANhLMrA8kb
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
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgmLbhyoYw
# ooy+l7LjpeWgbyEHa1X1rujcrgeDkc+9u9wwQAYKKwYBBAGCNwIBDDEyMDCgFoAU
# AEQAZQBsAGwALAAgAEkAbgBjAC6hFoAUaHR0cDovL3d3dy5kZWxsLmNvbSAwDQYJ
# KoZIhvcNAQEBBQAEggEAY8r/AjxyQAMzNo6IpTabJClsDG0yvGrcu2Uo19oupdAn
# OW9NqcARJ5+tba2udvsC4KAYym/23KLVlgHmuzMlmq0bKAQyAv4vgK6ziPishe92
# BiPwQqXTSrhuJwYnQUkpmN64hnNaudKbg/LS66XgpE6W8saq/oDU2KebWnp9tiA7
# gpiG/vDurajjOh10h0frWbtqs1AJE28J794Z/wXQSlsoYxH9pbR7W6DfsHweqDDw
# aeFG6th8FIdCJCZW58w5O0ERptGzetjhCizCEVKCtwpyHaIwPAA08g69Y9FwURmv
# R6TCVdCuTtW3YNr40RdaAiOC45G0IIAhYp37q6+EN6GCCAowgggGBgorBgEEAYI3
# AwMBMYIH9jCCB/IGCSqGSIb3DQEHAqCCB+MwggffAgEDMQ8wDQYJYIZIAWUDBAIB
# BQAwbQYLKoZIhvcNAQkQAQSgXgRcMFoCAQEGCmCGSAGG/W4BBxgwMTANBglghkgB
# ZQMEAgEFAAQgG+xOfFpXVPKUgejehLDCht7i6dvl7wYR3+uDJpfZ9fcCBQUDsN0w
# GA8yMDE3MDEzMTA2NDYwNlqgggTxMIIE7TCCA9WgAwIBAgIIPG49fSM2JU0wDQYJ
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
# DQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTE3MDEzMTA2NDYwN1owKwYL
# KoZIhvcNAQkQAgwxHDAaMBgwFgQUcUS1PxpdOR3drHG2ByGQjJsb8/YwLwYJKoZI
# hvcNAQkEMSIEIIra3zgw0vA/r03wZsXJHtuDcc8l9/RRzZ+eyPXGe6k1MA0GCSqG
# SIb3DQEBAQUABIIBAHx/pml16hiJ/tF3Nqd2kIqJV3zjeMl/Dgj+wYAKRe2R7lcd
# IX5RCnpy4NEzQXZJ/3J6Idk041G81mD2blqL+w1gtvz57wVxmiYoy+u7xFHN70Tx
# D3xxP8U9R/kRuTPPuyLjJKQdSXVmhhgtREh/QsYlnhVEULrghgjWL41Jf7tMFxpJ
# Irfn3YBFVyIypypU1UIdTbSf0D6anf73GQIxFH89vCEMOIjuI2iWPhMbS6kL3LCW
# xiEwKVkFJ7kX8R6IJvosy791xZ+z01jeRC/+RKc6Va2bBard1BE7DdPnJ4vf7gVn
# wHw3s3tWwuuPexprlrk2NKkZHqA7cJb02otDOOI=
# SIG # End signature block
