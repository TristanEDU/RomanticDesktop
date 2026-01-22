# VERIFY.ps1
# Post-installation verification and diagnostics
# UTF-8 with BOM encoding

param([switch]$SaveReport = $true)

Write-Host "
" -ForegroundColor Cyan
Write-Host "  INSTALLATION VERIFICATION" -ForegroundColor Cyan
Write-Host "
" -ForegroundColor Cyan

$passed = 0
$failed = 0
$warnings = 0

# Check 1: Installation folder
Write-Host "[1/6] Checking installation folder..." -ForegroundColor Cyan
if (Test-Path "C:\RomanticCustomization" -PathType Container) {
    Write-Host "   Installation folder exists" -ForegroundColor Green
    $passed++
    
    $files = @("WelcomeMessage.ps1", "config.txt")
    foreach ($file in $files) {
        $filePath = "C:\RomanticCustomization\$file"
        if (Test-Path $filePath -PathType Leaf) {
            Write-Host "     $file found" -ForegroundColor Green
        }
        else {
            Write-Host "     $file missing" -ForegroundColor Red
            $failed++
        }
    }
}
else {
    Write-Host "   Installation folder not found" -ForegroundColor Red
    $failed++
}

# Check 2: Scheduled task
Write-Host "
[2/6] Checking scheduled task..." -ForegroundColor Cyan
try {
    $task = Get-ScheduledTask -TaskName "RomanticWelcome" -ErrorAction SilentlyContinue
    if ($task) {
        Write-Host "   Task exists - State: $($task.State)" -ForegroundColor Green
        $passed++
    }
    else {
        Write-Host "   Task not found" -ForegroundColor Red
        $failed++
    }
}
catch {
    Write-Host "   Error: $_" -ForegroundColor Red
    $failed++
}

# Check 3: Config file
Write-Host "
[3/6] Validating config.txt..." -ForegroundColor Cyan
$configPath = "C:\RomanticCustomization\config.txt"
if (Test-Path $configPath) {
    $config = Get-Content $configPath -Raw
    if ($config -match "HER_NAME=" -and $config -match "ANNIVERSARY_DATE=") {
        Write-Host "   Config is valid" -ForegroundColor Green
        $passed++
    }
    else {
        Write-Host "   Config is incomplete" -ForegroundColor Red
        $failed++
    }
}
else {
    Write-Host "   Config file not found" -ForegroundColor Red
    $failed++
}

# Check 4: Registry
Write-Host "
[4/6] Checking registry entries..." -ForegroundColor Cyan
$regPath = "HKCU:\Software\RomanticCustomization"
if (Test-Path $regPath) {
    Write-Host "   Registry key exists" -ForegroundColor Green
    $passed++
}
else {
    Write-Host "   Registry key not found (will be created on next install)" -ForegroundColor Yellow
    $warnings++
}

# Check 5: Theme settings
Write-Host "
[5/6] Checking theme colors..." -ForegroundColor Cyan
try {
    $dwmPath = "HKCU:\Software\Microsoft\Windows\DWM"
    $color = Get-ItemProperty -Path $dwmPath -Name "AccentColor" -ErrorAction SilentlyContinue
    if ($color) {
        Write-Host "   Custom theme applied" -ForegroundColor Green
        $passed++
    }
    else {
        Write-Host "   No custom theme detected" -ForegroundColor Yellow
        $warnings++
    }
}
catch {
    Write-Host "   Could not verify theme" -ForegroundColor Yellow
    $warnings++
}

# Check 6: Script integrity
Write-Host "
[6/6] Checking script integrity..." -ForegroundColor Cyan
$scriptPath = "C:\RomanticCustomization\WelcomeMessage.ps1"
if (Test-Path $scriptPath) {
    try {
        $script = Get-Content $scriptPath -Raw
        if ($script.Length -gt 100) {
            Write-Host "   Script is intact" -ForegroundColor Green
            $passed++
        }
    }
    catch {
        Write-Host "   Error reading script" -ForegroundColor Red
        $failed++
    }
}
else {
    Write-Host "   Script not found" -ForegroundColor Red
    $failed++
}

# Summary
Write-Host "
" -ForegroundColor Cyan
Write-Host "VERIFICATION SUMMARY" -ForegroundColor Cyan
Write-Host "" -ForegroundColor Cyan
Write-Host "
Results:"
Write-Host "  Passed:   $passed" -ForegroundColor Green
Write-Host "  Failed:   $failed" -ForegroundColor Red
Write-Host "  Warnings: $warnings" -ForegroundColor Yellow

if ($failed -eq 0) {
    Write-Host "
Overall:  VERIFIED" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "
Overall:  ISSUES FOUND" -ForegroundColor Red
    exit 1
}