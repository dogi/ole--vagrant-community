@echo off

echo This script will install BeLL-Apps on your computer

REM Get Admin For Batch File
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
  echo Requesting administrative privileges...
  echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
  set params = %*:"=""
  echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
  "%temp%\getadmin.vbs"
  del "%temp%\getadmin.vbs"
  exit /B
)
pushd "%CD%"
CD /D "%~dp0"

REM  Check for Virtualization and Install programs if enabled
powershell -ExecutionPolicy bypass -Command "& {$a = (Get-CimInstance -ClassName win32_processor -Property Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions); $a | Format-List Name, SecondLevelAddressTranslationExtensions, VirtualizationFirmwareEnabled, VMMonitorModeExtensions; $slat = $a.SecondLevelAddressTranslationExtensions; $virtual = $a.VirtualizationFirmwareEnabled; $vmextensions = $a.VMMonitorModeExtensions;If ($slat -eq $false){Write-Host 'BeLL-Apps is not compatible with your system. In order to install it, you need to upgrade your CPU first.';exit}Else{ If ($virtual -eq $false){'Virtualization is not enabled. In order to install BeLL-Apps, you must enable it. Helpful link: http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/'}If ($virtual -eq $false){"Virtualization is not enabled. In order to install BeLL-Apps, you must enable it. Helpful link: http://www.howtogeek.com/213795/how-to-enable-intel-vt-x-in-your-computers-bios-or-uefi-firmware/";exit}}(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1;RefreshEnv;choco install bonjour, git, virtualbox, vagrant -y -allowEmptyChecksums;RefreshEnv};

set git= dogi
set /p git= "Enter your git username: "
cd /D "C:\Users\%USERNAME%"
REM git clone https://github.com/%git%/ole--vagrant-community.git
cd ole--vagrant-community/windows
 
start start_vagrant_on_boot.bat 
start create_desktop_icon.bat

exit

