@echo off

call vm_destroyer.bat
echo.

:: grab working directory to retreat upon script completion 
set CURRDIR=%cd%
IF NOT EXIST "%CURRDIR%\tempfolder" mkdir %CURRDIR%\tempfolder
cd %CURRDIR%\tempfolder

:: the first program that will be uninstalled
set PROGNAME=virtualbox

:restart

set _a32="false"
set _a64="false"

:: first check what type of os the user has (i.e. 32 bit or 64 bit)

reg query "HKLM\Hardware\Description\System\CentralProcessor\0" | findstr /i "x86" > NUL && set OSFLAVOR=BIT32 || set OSFLAVOR=BIT64
IF %OSFLAVOR% == BIT32 goto 32BIT
IF %OSFLAVOR% == BIT64 goto 64BIT

:64BIT

reg query HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall /s /f "%PROGNAME%" > dumpfile.txt

::figure out if the query returned successfull match(es)
:: if query FAILS, query alternate directory
set errlvl1=%ERRORLEVEL%
IF %errlvl1% == 1 goto 32BIT
IF %errlvl1% == 0 set checked64=%_a64:false=true% && goto success64


:: skip here if machine is running a 32 bit OS
:32BIT

reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall /s /f "%PROGNAME%" > dumpfile.txt

:: if query fails again, then program is not installed
set errlvl2=%ERRORLEVEL%
IF %errlvl2% == 1 goto NOTinstalled 
IF %errlvl2% == 0 set checked32=%_a32:false=true% && goto success32


:success64
findstr "Uninstall" dumpfile.txt > temp.txt
set /p KEY=<temp.txt
:: echo Program is installed!(64 or 32)
IF %checked64% == "true" set _RESULT=%KEY:~83, 38%
goto uninstall


:success32
findstr "Uninstall" dumpfile.txt > temp.txt
set /p KEY=<temp.txt
:: echo Program is installed(32)
IF %checked32% == "true" set _RESULT=%KEY:~71, 38%
goto uninstall


:NOTinstalled
echo %PROGNAME% is not installed.
IF %PROGNAME% == vagrant goto cleanup 
set PROGNAME=%PROGNAME:virtualbox=vagrant%
goto restart

:: grab uninstall string and call msiexec to uninstall
:uninstall
echo UNINSTALLING %PROGNAME%...
msiexec /x%_RESULT% /quiet /promptrestart
set errlvl3=%ERRORLEVEL%
IF NOT %errlvl3% == 0 echo Something went wrong... && goto cleanup
IF %errlvl3% == 0 echo Successfully uninstalled %PROGNAME% 

IF %PROGNAME% == virtualbox (
	set PROGNAME=%PROGNAME:virtualbox=vagrant%
	echo.
	goto restart
)
goto cleanup

:cleanup
IF EXIST temp.txt del temp.txt
IF EXIST dumpfile.txt del dumpfile.txt
cd ..
RMDIR tempfolder

:: finally, uninstall git
git_uninstaller.bat
pause
