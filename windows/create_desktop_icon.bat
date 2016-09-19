@echo off 

::Set the application-specific string vars 
SET AppDescription=Bell-App
SET IconName=Bell_logo.ico
SET Shortcut_Name=MyBell.url
SET URL_PATH=http://127.0.0.1:5984/apps/_design/bell/MyApp/index.html

::Set the common string vars 
SET WORKING_PATH=%~dp0
SET ICONDEST=c:\ProgramData\%AppDescription%
SET LinkPath=%userprofile%\Desktop\%Shortcut_Name%

IF EXIST "%ICONDEST%" (GOTO _CopyIcon) 
mkdir "%ICONDEST%"
:_CopyIcon 
copy "%WORKING_PATH%%IconName%" "%ICONDEST%"

echo. 
echo.
echo [InternetShortcut] > "%LinkPath%"
echo URL=%URL_PATH% >> "%LinkPath%"
echo IDList= >> "%LinkPath%"
echo IconFile=%ICONDEST%\%IconName% >> "%LinkPath%"
echo IconIndex=0 >> "%LinkPath%"
echo HotKey=0 >> "%LinkPath%"

exit