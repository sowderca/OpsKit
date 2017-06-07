﻿




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

@{
GUID = '0D5A8A07-2E6E-432F-86E2-605D4EEAA9A8'
Author = 'Heath Stewart'
CompanyName = 'Microsoft Corporation'
Description = 'Exposes Windows Installer functionality to Windows PowerShell'
Copyright = 'Copyright Microsoft Corporation'
ModuleVersion = '3.2.3.1024'
PowerShellVersion = '2.0'
CLRVersion = '2.0'
ModuleToProcess = 'MSI.psm1'
NestedModules = 'Microsoft.Tools.WindowsInstaller.PowerShell.dll'
CmdletsToExport = '*'
FunctionsToExport = '*'
FormatsToProcess = 'MSI.formats.ps1xml'
TypesToProcess = 'MSI.types.ps1xml'
RequiredAssemblies = 'Microsoft.Tools.WindowsInstaller.PowerShell.dll', 'Microsoft.Deployment.WindowsInstaller.dll', 'Microsoft.Deployment.WindowsInstaller.Package.dll'
FileList = 'about_MSI.help.txt', 'Microsoft.Tools.WindowsInstaller.PowerShell.dll-Help.xml'
PrivateData = @{
  PSData = @{
    Tags = @('WindowsInstaller', 'MSI', 'MSP')
    ProjectUri = 'https://github.com/heaths/psmsi'
    LicenseUri = 'https://raw.githubusercontent.com/heaths/psmsi/master/LICENSE.txt'
    IconUri = 'https://raw.githubusercontent.com/heaths/psmsi/master/res/psmsi.png'
  }
}
}
