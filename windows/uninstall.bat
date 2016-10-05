@echo off

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
  exit
)
pushd "%CD%"
CD /D "%~dp0"
powershell -ExecutionPolicy bypass -Command "& {choco uninstall bonjour -y; $vb = Read-Host 'Are you sure you want to remove Virtualbox? (Y)es, (N)o'; if ($vb.ToUpper() -eq 'Y') {choco uninstall virtualbox -y} $vm = Read-Host 'Do you want to remove the virtual machine? (Y)es, (N)o'; if ($vm.ToUpper() -eq 'Y') {C:\HashiCorp\Vagrant\bin\vagrant.exe destroy community -f}$box = Read-Host 'Do you want to remove also all the files? (Y)es, (N)o'; if ($box.ToUpper() -eq 'Y') {C:\HashiCorp\Vagrant\bin\vagrant.exe box remove ole/jessie64 -f} $git = Read-Host 'Are you sure you want to remove Git? (Y)es, (N)o'; if ($git.ToUpper() -eq 'Y') {choco uninstall git, git.install -y; choco uninstall vagrant -y; choco uninstall chocolatey -y} $ff = Read-Host 'Are you sure you want to remove Firefox? (Y)es, (N)o'; if ($ff.ToUpper() -eq 'Y') {choco uninstall firefox -y} Remove-Item C:\Users\*\Desktop\MyBeLL.lnk -Force }"


netsh advfirewall firewall show rule name="CouchDB/HTTP(BeLL)" >nul
if not ERRORLEVEL 1 (
	echo Blocking Port 5984...
	netsh advfirewall firewall delete rule name="CouchDB/HTTP(BeLL)" 
)

netsh advfirewall firewall show rule name="CouchDB/HTTPS(BeLL)" >nul
if not ERRORLEVEL 1 (
	echo Blocking Port 6984...
	netsh advfirewall firewall delete rule name="CouchDB/HTTPS(BeLL)"
) 

IF EXIST "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start_vagrant_on_boot.bat" (
	del "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start_vagrant_on_boot.bat"
)
echo Deleting ole--vagrant-community folder..
RD /S "C:\Users\%USERNAME%\ole--vagrant-community"
RD /S /Q "%ALLUSERSPROFILE%\chocolatey"
RD /S /Q "%ALLUSERSPROFILE%\Git"

pause


