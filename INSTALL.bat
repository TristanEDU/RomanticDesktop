@echo off
:: Romantic Windows Customization - Easy Installer
:: Just double-click this file - it will auto-request admin privileges

:: Check for admin privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run_installer
) else (
    goto :request_admin
)

:request_admin
echo Requesting administrator privileges...
powershell -Command "Start-Process '%~f0' -Verb RunAs"
exit /b

:run_installer
:: Run the PowerShell installer script
powershell.exe -ExecutionPolicy Bypass -File "%~dp0INSTALL.ps1"
pause
exit