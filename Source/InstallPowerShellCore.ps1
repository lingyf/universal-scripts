<#PSScriptInfo

.VERSION 1.0

.GUID 375c681f-9a07-492c-ad38-ea9122dec131

.AUTHOR lingyf

.COMPANYNAME

.COPYRIGHT

.TAGS PowerShellCore

.LICENSEURI https://github.com/lingyf/universal-scripts/blob/main/LICENSE

.PROJECTURI https://github.com/lingyf/universal-scripts

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
VERSION 1.0: Initial release.

.PRIVATEDATA

#>

<#

.DESCRIPTION
 This script installs the latest stable version of PowerShell Core on Windows.

#>

#Requires -PSEdition Desktop -RunAsAdministrator

$latest = Invoke-RestMethod -Uri 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest'
$local = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | Where-Object {$_.DisplayName -match 'powershell' -and $_.DisplayName -notmatch 'preview'}

if (-not $local -or ($local -and [version]($local.DisplayVersion.Split('.')[0..2] -join '.') -lt [version]$latest.tag_name.Trim('v'))) {
    $installer = $latest.assets | Where-Object {$_.name -match 'win-x64.msi'}
    $installerPath = Join-Path -Path 'C:\Windows\Temp' -ChildPath $installer.name

    Invoke-RestMethod -Uri $installer.browser_download_url -OutFile $installerPath
    Start-Process -FilePath 'msiexec.exe' -ArgumentList "/i $installerPath /quiet" -Wait
    Remove-Item -Path $installerPath
}