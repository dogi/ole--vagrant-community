@echo off

IF NOT EXIST "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\start_vagrant_on_boot.bat" (
  
  start cmd /c copy "C:\Users\%USERNAME%\ole--vagrant-community\windows\start_vagrant_on_boot.bat" "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
)

cd "C:\Users\%USERNAME%\ole--vagrant-community"

for /f "tokens=2* delims= " %%F IN ('vagrant status ^| find /I "default"') DO (SET "STATE=%%F%%G")

IF "%STATE%" NEQ "saved" (
  ECHO Starting Vagrant VM from powered down state...
  \HashiCorp\Vagrant\bin\vagrant.exe up
) ELSE (
  ECHO Resuming Vagrant VM from saved state...
  \HashiCorp\Vagrant\bin\vagrant.exe resume
)

if errorlevel 1 (
  ECHO FAILURE! Vagrant VM unresponsive...
)

echo Installation Completed
pause 
exit