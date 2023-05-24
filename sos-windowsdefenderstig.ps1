# Set error action preference to continue
$ErrorActionPreference = 'Continue'

# Elevate privileges for this process
Write-Output "Elevating privileges for this process"
Start-Process -FilePath "$PSHOME\powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$PSScriptRoot'; & '$PSCommandPath'`"" -Verb RunAs

# Set directory to script root
Set-Location -Path $PSScriptRoot

# Copy Windows Defender configuration files
$defenderConfigSource = Join-Path $PSScriptRoot 'Files\Windows Defender Configuration Files'
$defenderConfigDestination = 'C:\temp\Windows Defender'
Write-Host "Copying Windows Defender Configuration Files..." -ForegroundColor White -BackgroundColor Black
mkdir $defenderConfigDestination -ErrorAction SilentlyContinue | Out-Null
Copy-Item -Path $defenderConfigSource\* -Destination $defenderConfigDestination -Force -Recurse -ErrorAction SilentlyContinue

# Enable Windows Defender Exploit Protection
$exploitProtectionConfig = Join-Path $defenderConfigDestination 'DOD_EP_V3.xml'
Write-Host "Enabling Windows Defender Exploit Protection..." -ForegroundColor Green -BackgroundColor Black
Set-ProcessMitigation -PolicyFilePath $exploitProtectionConfig

# Import Windows Defender GPOs
$gpoPath = Join-Path $PSScriptRoot 'Files\GPO'
Write-Host "Importing Windows Defender GPOs..." -ForegroundColor Green -BackgroundColor Black
& "$PSScriptRoot\Files\LGPO\LGPO.exe" /g $gpoPath

Write-Host "Done..." -ForegroundColor Green -BackgroundColor Black
