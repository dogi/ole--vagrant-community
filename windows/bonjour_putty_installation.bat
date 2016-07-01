:: preinstall.bat
:: install bonjour and putty
::
@ECHO OFF

:: create a temporarily folder 
if not exist "C:\tempfolder" mkdir C:\tempfolder

:: download bonjour to the temp folder and download putty to the user desktop
powershell -command "& { (New-Object Net.WebClient).DownloadFile('http://support.apple.com/downloads/DL999/en_US/BonjourPSSetup.exe', 'C:\tempfolder\BonjourPSSetup.exe') }"
powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://the.earth.li/~sgtatham/putty/latest/x86/putty.exe', '%USERPROFILE%\Desktop\putty.exe') }"

:: Switch to the temporarily folder
cd C:\tempfolder

:: Check whether bonjour is already installed
reg export HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall temp1.txt
find /i /n "Bonjour" temp1.txt
if %errorlevel% == 0 (
echo Bonjour is already installed!!!!
del temp1.txt BonjourPSSetup.exe
cd C:/
RMDIR tempfolder
exit /b
)

:: Start the installation
start /w C:\tempfolder\BonjourPSSetup.exe

:: Check whether bonjour is installed correctly
reg export HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall temp2.txt
find /i /n "Bonjour" temp2.txt
if %errorlevel% == 0 (
echo program is installed correctly
)

del temp1.txt temp2.txt BonjourPSSetup.exe
cd C:/
RMDIR tempfolder