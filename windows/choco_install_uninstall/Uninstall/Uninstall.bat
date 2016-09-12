@echo off
@powershell -NoProfile -NoExit -Command "& {Start-Process PowerShell -ArgumentList '-NoExit -NoProfile -File %~dp0UninstallChoco.ps1' -Verb RunAs}"
pause
