#Continue on error
$ErrorActionPreference= 'silentlycontinue'

#Require elivation for script run
Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

Write-Host "Copying Windows Defender Configuration Files..." -ForegroundColor White -BackgroundColor Black
mkdir "C:\temp\Windows Defender"; Copy-Item -Path .\Files\"Windows Defender Configuration Files"\* -Destination C:\temp\"Windows Defender"\ -Force -Recurse -ErrorAction SilentlyContinue

Write-Host "Enabling Windows Defender Exploit Protection..." -ForegroundColor Green -BackgroundColor Black
Set-ProcessMitigation -PolicyFilePath "C:\temp\Windows Defender\DOD_EP_V3.xml"

Write-Host "Importing Windows Defender GPOs..." -ForegroundColor Green -BackgroundColor Black
.\Files\LGPO\LGPO.exe /g .\Files\GPO\

Write-Host "Done..." -ForegroundColor Green -BackgroundColor Black
