@echo off

echo This script will install BeLL-Apps on your computer

REM Virtualization Check (Link with instructions on how to enable it, if disabled)
powershell -Command "& {$a = (Get-CimInstance -ClassName win32_processor -Property Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions); $a | Format-List Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions; $slat = $a.SecondLevelAddressTranslationExtensions; $virtual = $a.VirtualizationFirmwareEnabled; $vmextensions = $a.VMMonitorModeExtensions;If ($slat -eq $false){Write-Host 'BeLL-Apps is not compatible with your system. In order to install it, you need to upgrade your CPU first.';exit}Else{ If ($virtual -eq $false){'Virtualization is not enabled. In order to install BeLL-Apps, you must enable it. Helpful link: http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/'}If ($virtual -eq $false){"Virtualization is not enabled. In order to install BeLL-Apps, you must enable it. Helpful link: http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/";exit}}};

pause
