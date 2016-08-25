ECHO off

::Halts and Destroys ALL machines
cd "C:\Users\%USERNAME%\ole--vagrant-community\windows"
cd /d %~dp0
for /f "skip=2 tokens=1 delims= " %%F IN ('vagrant global-status') DO (
vagrant halt "%%F"
vagrant destroy -f "%%F" )


::Get Admin For Batch File
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

::Uninstalls Vagrant
wmic product where name="Vagrant" call uninstall

::Uninstalls VirtualBox
wmic product where name="Oracle VM VirtualBox 5.0.20" call uninstall