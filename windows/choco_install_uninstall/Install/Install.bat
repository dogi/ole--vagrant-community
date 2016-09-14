@echo off
@powershell -NoProfile -NoExit -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoExit -NoProfile -ExecutionPolicy Bypass -File %~dp0InstChoco.ps1' -Verb RunAs}"
pause
