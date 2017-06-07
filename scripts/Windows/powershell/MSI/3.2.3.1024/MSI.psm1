﻿#Requires -Version 2.0

# The MIT License (MIT)
#
# Copyright (c) Microsoft Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

$script:loc = data {
    convertfrom-stringdata @'
        AdvtCaption = Confirm install
        AdvtDescription = Installing advertised features for product, {0}.
        AdvtWarning = Are you sure you want to install advertised features for product, {0}?
'@
}
import-localizeddata -bind loc -filename Resources.psd1 -ea SilentlyContinue

function Get-MSIComponentState
{
# .ExternalHelp Microsoft.Tools.WindowsInstaller.PowerShell.dll-Help.xml

    [CmdletBinding(DefaultParameterSetName = "Product")]
    param
    (
        [Parameter(ParameterSetName = "Product", Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [Microsoft.Deployment.WindowsInstaller.ProductInstallation[]] $Product,

        [Parameter(ParameterSetName = "ProductCode", Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Microsoft.Tools.WindowsInstaller.PowerShell.ValidateGuid()]
        [string[]] $ProductCode,

        [Parameter(ParameterSetName = "ProductCode", ValueFromPipelineByPropertyName = $true)]
        [Alias("Context", "InstallContext")]
        [Microsoft.Deployment.WindowsInstaller.UserContexts] $UserContext = "All",

        [Parameter(ParameterSetName = "ProductCode", ValueFromPipelineByPropertyName = $true)]
        [Microsoft.Tools.WindowsInstaller.PowerShell.Sid()]
        [string] $UserSid
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq "ProductCode")
        {
            $Product = @(,(get-msiproductinfo @PSBoundParameters))
        }

        $Product | foreach-object {

            [string] $productCode = $_.ProductCode

            # Get the state of every authored component in the product and applied patches.
            $_ | get-msitable -table Component | foreach-object {

                # Attach authored information from the product package to the output object.
                $_ | get-msicomponentinfo -productcode $productCode `
                   | foreach-object { $_.PSTypeNames.Insert(0, $_.PSTypeNames[0] + "#State"); $_ } `
                   | add-member -type NoteProperty -name Component -value $_.Component -passthru
            }
        }
    }
}

function Get-MSISharedComponentInfo
{
# .ExternalHelp Microsoft.Tools.WindowsInstaller.PowerShell.dll-Help.xml

    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Tools.WindowsInstaller.PowerShell.ValidateGuid()]
        [string[]] $ComponentCode,

        [Parameter(Position = 1)]
        [ValidateRange(2, 2147483647)]
        [int] $Count = 2
    )

    end
    {
        $getcomponents = { get-msicomponentinfo }
        if ($ComponentCode)
        {
            $getcomponents = { get-msicomponentinfo -componentcode $ComponentCode }
        }
        & $getcomponents | group-object -property ComponentCode | where-object { $_.Count -ge $Count } `
            | select-object -expand Group
    }
}

function Install-MSIAdvertisedFeature
{
# .ExternalHelp Microsoft.Tools.WindowsInstaller.PowerShell.dll-Help.xml

    [CmdletBinding(DefaultParameterSetName = "ProductCode", ConfirmImpact = "Medium", SupportsShouldProcess = $true)]
    param
    (
        [Parameter(ParameterSetName = "ProductCode", ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Tools.WindowsInstaller.PowerShell.ValidateGuid()]
        [string[]] $ProductCode,

        [Parameter(ParameterSetName = "Product", Mandatory = $true, ValueFromPipeline = $true)]
        [Microsoft.Deployment.WindowsInstaller.ProductInstallation[]] $Product,

        [Parameter(Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]] $FeatureName,

        [Parameter()]
        [switch] $Force,

        [Parameter(ValueFromPipelineByPropertyName = $true, ValueFromRemainingArguments = $true)]
        [string[]] $Properties
    )

    begin
    {
        $YesToAll = $false
        $NoToAll = $false
    }

    process
    {
        # Get only specified or all products given a ProductCode.
        if ($PSBoundParameters.ContainsKey("ProductCode"))
        {
            $Product = get-msiproductinfo -productcode $ProductCode
        }
        elseif ($PSCmdlet.ParameterSetName -eq "ProductCode")
        {
            $Product = get-msiproductinfo
        }

        # Get only specified or all features for each selected product.
        if ($PSBoundParameters.ContainsKey("FeatureName"))
        {
            $features = $Product | foreach-object {
                get-msifeatureinfo -productcode $_.ProductCode -featurename $FeatureName
            }
        }
        else
        {
            $features = $Product | get-msifeatureinfo
        }

        # Construct and splat the necessary parameters to re-install each product.
        $features | where-object { $_.State -eq "Advertised" } | group-object ProductCode | foreach-object {
            $params = @{
                "ProductCode" = $_.Name;
                "Properties" = "$Properties ADDLOCAL=$(($_.Group | select-object -expand Name) -join ',')"
            }

            # Get the advertised product name from the existing collection so we don't cause a reentrance issue.
            $name = $_.Name
            $name = $Product | where-object { $_.ProductCode -eq $name } | select-object -expand AdvertisedProductName

            $description = $script:loc.AdvtDescription -f $name
            $warning = $script:loc.AdvtWarning -f $name

            if ($PSCmdlet.ShouldProcess($description, $warning, $script:loc.AdvtCaption))
            {
                if ($Force -or $PSCmdlet.ShouldContinue($null, $null, [ref] $YesToAll, [ref] $NoToAll))
                {
                    install-msiproduct @params
                }
            }
        }
    }
}

# Update the usage information for this module if installed.
[Microsoft.Tools.WindowsInstaller.PowerShell.Module]::Use()
