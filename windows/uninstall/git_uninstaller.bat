@echo off

:: grab current directory
set origDir=%cd%

:: check if a tempfolder already exists
IF NOT EXIST "%origDir%\tempfolder" mkdir %origDir%\tempfolder
cd %origDir%\tempfolder

reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall /f "Git">nul

set errlvl1=%ERRORLEVEL%
IF %errlvl1% == 1 goto NOTinstalled

:: query
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1 /f "uninstall" > temp.txt

set errlvl2=%ERRORLEVEL%
IF %errlvl2% == 1 goto NOTinstalled
IF %errlvl2% == 0 goto uninstall


:NOTinstalled
echo Git is not installed.
goto cleanup


:uninstall
findstr "QuietUninstallString" temp.txt > key.txt
set /p KEY=<key.txt
set UNFORMATTED=%KEY:~35%
set UNINSTALLSTRING=%UNFORMATTED:~3% 
cd C:\
echo.
echo UNINSTALLING git...
%UNINSTALLSTRING%
set errlvl3=%ERRORLEVEL%
IF %errlvl3% == 1 echo Something went wrong...
IF %errlvl3% == 0 echo Successfully uninstalled git 


:cleanup
cd %origDir%\tempfolder
IF EXIST temp.txt del temp.txt
IF EXIST key.txt del key.txt
cd ..
rmdir tempfolder
exit /b
