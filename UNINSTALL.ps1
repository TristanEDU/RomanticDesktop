# UNINSTALL.ps1
# Removes Romantic Windows Customization completely
# UTF-8 with BOM encoding

#Requires -RunAsAdministrator

Write-Host "
" -ForegroundColor Magenta
Write-Host "  ROMANTIC CUSTOMIZATION - UNINSTALLER" -ForegroundColor Magenta
Write-Host "
" -ForegroundColor Magenta

$ErrorActionPreference = "Continue"
$uninstallLog = "$env:TEMP\romantic_uninstall_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$stepsPassed = 0
$stepsFailed = 0

# Confirmation
Write-Host "This will completely remove Romantic Windows Customization:" -ForegroundColor Yellow
Write-Host "   Scheduled task 'RomanticWelcome'" -ForegroundColor Yellow
Write-Host "   C:\RomanticCustomization folder" -ForegroundColor Yellow
Write-Host "   Registry entries" -ForegroundColor Yellow
Write-Host "   Theme color modifications" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Continue with uninstall? (Y/N)"
if ($confirm -ne "Y") {
    Write-Host "Uninstall cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""

# Step 1: Remove scheduled task
Write-Host "[1/5] Removing scheduled task..." -ForegroundColor Cyan
try {
    $task = Get-ScheduledTask -TaskName "RomanticWelcome" -ErrorAction SilentlyContinue
    if ($task) {
        Stop-ScheduledTask -TaskName "RomanticWelcome" -ErrorAction SilentlyContinue
        Unregister-ScheduledTask -TaskName "RomanticWelcome" -Confirm:$false
        Write-Host "   Task removed" -ForegroundColor Green
        $stepsPassed++
    }
    else {
        Write-Host "   Task not found" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "   Error: $_" -ForegroundColor Red
    $stepsFailed++
}

# Step 2: Delete folder
Write-Host "[2/5] Removing C:\RomanticCustomization..." -ForegroundColor Cyan
try {
    if (Test-Path "C:\RomanticCustomization") {
        Remove-Item -Path "C:\RomanticCustomization" -Recurse -Force
        Write-Host "   Folder deleted" -ForegroundColor Green
        $stepsPassed++
    }
    else {
        Write-Host "   Folder not found" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "   Error: $_" -ForegroundColor Red
    $stepsFailed++
}

# Step 3: Remove registry
Write-Host "[3/5] Removing registry entries..." -ForegroundColor Cyan
try {
    $regPath = "HKCU:\Software\RomanticCustomization"
    if (Test-Path $regPath) {
        Remove-Item -Path $regPath -Recurse -Force
        Write-Host "   Registry cleaned" -ForegroundColor Green
        $stepsPassed++
    }
    else {
        Write-Host "   Registry key not found" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "   Error: $_" -ForegroundColor Red
    $stepsFailed++
}

# Step 4: Restore theme
Write-Host "[4/5] Restoring Windows theme..." -ForegroundColor Cyan
try {
    $dwmPath = "HKCU:\Software\Microsoft\Windows\DWM"
    Remove-ItemProperty -Path $dwmPath -Name "AccentColor" -ErrorAction SilentlyContinue
    Write-Host "   Theme restored" -ForegroundColor Green
    $stepsPassed++
}
catch {
    Write-Host "   Could not restore theme" -ForegroundColor Yellow
}

# Step 5: Log completion
Write-Host "[5/5] Finalizing..." -ForegroundColor Cyan
Write-Host "   Done" -ForegroundColor Green

Write-Host "
" -ForegroundColor Magenta
Write-Host "  Uninstall Complete! " -ForegroundColor Green
Write-Host "
" -ForegroundColor Magenta

exit 0