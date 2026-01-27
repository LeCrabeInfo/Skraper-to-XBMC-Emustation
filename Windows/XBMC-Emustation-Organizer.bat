@echo off

echo ================================
echo    XBMC-Emustation-Organizer
echo ================================
echo.
echo This script is designed to adapt your emustation folder for use with
echo XBMC-Emustation. It automates the process of organizing and renaming
echo files to ensure compatibility with XBMC-Emustation and OG Xbox.
echo.
echo ---
echo.
echo Press any key to start...
pause >nul
echo.

set "scriptPath=%~dp0XBMC-Emustation-Organizer.ps1"
powershell.exe -File "%scriptPath%" %*

echo.
echo Press any key to exit...
pause >nul
