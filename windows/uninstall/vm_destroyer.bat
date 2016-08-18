@echo off

cd C:\
cd C:\Users\%USERNAME%\ole--vagrant-community\

:: check status of machine: running
vagrant status --machine-readable | grep state,running>nul

set ERRLVL1=%ERRORLEVEL%
IF %ERRLVL1% == 1 vagrant status --machine-readable | grep state,poweroff>nul
IF %ERRLVL1% == 0 goto statusRunning 

set ERRLVL4=%ERRORLEVEL%
IF %ERRLVL4% == 1 goto quit 
IF %ERRLVL4% == 0 echo Removing virtual machine: community ...  & echo. & goto statusPowerOff 

:statusRunning
echo Removing virtual machine: community ...
echo.

:: halt the machine
vagrant halt

set ERRLVL2=%ERRORLEVEL%
IF NOT %ERRLVL2% == 0 echo ERROR: Vagrant halt didn't execute properly. & goto quit

:statusPowerOff
:: destroy the machine (forcefully)
vagrant destroy community -f

set ERRLVL3=%ERRORLEVEL%
IF NOT %ERRLVL3% == 0 echo ERROR: Vagrant destroy didn't execute properly. & goto quit

echo.
echo Successfully removed virtual machine: community

:quit
cd C:\
cd %ORIGDIR%
