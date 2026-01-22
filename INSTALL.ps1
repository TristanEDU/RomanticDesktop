# Romantic Windows Customization Installer
# Portable version - works from any location (USB drive, desktop, etc.)
# Compatible with Windows 10 and Windows 11

Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "  Romantic Windows Customization Installer" -ForegroundColor Magenta
Write-Host "================================================" -ForegroundColor Magenta
Write-Host ""

# Get the directory where this script is located (works from USB or any location)
$packageDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script needs Administrator privileges!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please close this window and:" -ForegroundColor Yellow
    Write-Host "  1. Right-click on INSTALL.ps1" -ForegroundColor White
    Write-Host "  2. Select 'Run with PowerShell'" -ForegroundColor White
    Write-Host "  3. Click 'Yes' when asked for administrator permission" -ForegroundColor White
    Write-Host ""
    pause
    exit
}

# Detect Windows version
$osVersion = [System.Environment]::OSVersion.Version
$isWindows11 = $osVersion.Build -ge 22000
$windowsVersion = if ($isWindows11) { "Windows 11" } else { "Windows 10" }

Write-Host "Detected: $windowsVersion (Build $($osVersion.Build))" -ForegroundColor Cyan
Write-Host "Running from: $packageDir" -ForegroundColor Cyan
Write-Host ""

# Verify required files exist
Write-Host "Checking package contents..." -ForegroundColor Yellow
$missingFiles = @()

if (-not (Test-Path "$packageDir\WelcomeMessage.ps1")) {
    $missingFiles += "WelcomeMessage.ps1"
}

if (-not (Test-Path "$packageDir\config.txt")) {
    $missingFiles += "config.txt"
}

if ($missingFiles.Count -gt 0) {
    Write-Host "ERROR: Missing required files:" -ForegroundColor Red
    $missingFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    Write-Host ""
    Write-Host "Please ensure all files are in the same folder as INSTALL.ps1" -ForegroundColor Yellow
    pause
    exit
}

Write-Host "  ✓ All required files found!" -ForegroundColor Green
Write-Host ""

# Optional files check
$hasSound = Test-Path "$packageDir\romantic.wav"
$hasCursors = (Get-ChildItem "$packageDir" -Filter "*.cur" -ErrorAction SilentlyContinue).Count -gt 0 -or 
              (Get-ChildItem "$packageDir" -Filter "*.ani" -ErrorAction SilentlyContinue).Count -gt 0

if ($hasSound) {
    Write-Host "  ✓ Sound file found" -ForegroundColor Green
} else {
    Write-Host "  ℹ No sound file (romantic.wav) - sound will be skipped" -ForegroundColor Gray
}

if ($hasCursors) {
    Write-Host "  ✓ Cursor files found" -ForegroundColor Green
} else {
    Write-Host "  ℹ No cursor files (.cur/.ani) - cursors will be skipped" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Press any key to begin installation..." -ForegroundColor Yellow
pause

Write-Host ""
Write-Host "[1/8] Setting up directories..." -ForegroundColor Cyan

# Create installation directory
$installPath = "C:\RomanticCustomization"
if (-not (Test-Path $installPath)) {
    New-Item -Path $installPath -ItemType Directory -Force | Out-Null
}

$soundsPath = "$installPath\Sounds"
if (-not (Test-Path $soundsPath)) {
    New-Item -Path $soundsPath -ItemType Directory -Force | Out-Null
}

$cursorsPath = "$installPath\Cursors"
if (-not (Test-Path $cursorsPath)) {
    New-Item -Path $cursorsPath -ItemType Directory -Force | Out-Null
}

Write-Host "      ✓ Directories created" -ForegroundColor Green

# Copy files
Write-Host "[2/8] Installing files..." -ForegroundColor Cyan

# Copy welcome script
Copy-Item "$packageDir\WelcomeMessage.ps1" -Destination "$installPath\WelcomeMessage.ps1" -Force
Write-Host "      ✓ Welcome script installed" -ForegroundColor Green

# Copy config file
Copy-Item "$packageDir\config.txt" -Destination "$installPath\config.txt" -Force
Write-Host "      ✓ Configuration file installed" -ForegroundColor Green

# Validate configuration file
Write-Host "[3/8] Validating configuration..." -ForegroundColor Cyan
try {
    $configValidator = "$packageDir\CONFIG_VALIDATOR.ps1"
    if (Test-Path $configValidator) {
        $validationOutput = & $configValidator "$installPath\config.txt" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "      ✓ Configuration is valid" -ForegroundColor Green
        } else {
            Write-Host "      ⚠ Configuration validation warnings:" -ForegroundColor Yellow
            $validationOutput | ForEach-Object { Write-Host "        $_" -ForegroundColor Yellow }
        }
    } else {
        Write-Host "      ℹ Validator not found (skipping validation)" -ForegroundColor Gray
    }
} catch {
    Write-Host "      ⚠ Could not validate config: $_" -ForegroundColor Yellow
}

# Copy sound file if exists
if ($hasSound) {
    Copy-Item "$packageDir\romantic.wav" -Destination "$soundsPath\romantic.wav" -Force
    Write-Host "      ✓ Sound file installed" -ForegroundColor Green
}

# Copy cursor files if exist
if ($hasCursors) {
    Copy-Item "$packageDir\*.cur" -Destination "$cursorsPath\" -Force -ErrorAction SilentlyContinue
    Copy-Item "$packageDir\*.ani" -Destination "$cursorsPath\" -Force -ErrorAction SilentlyContinue
    Write-Host "      ✓ Cursor files installed" -ForegroundColor Green
}

# Set execution policy for current user
Write-Host "[4/8] Configuring PowerShell..." -ForegroundColor Cyan
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
    Write-Host "      ✓ PowerShell configured" -ForegroundColor Green
} catch {
    Write-Host "      ⚠ Warning: Could not set execution policy" -ForegroundColor Yellow
    Write-Host "        Welcome message may not work until policy is set manually" -ForegroundColor Gray
}

# Store installation path in registry (v1.1 - for portability)
Write-Host "[5/8] Storing installation path in registry..." -ForegroundColor Cyan
try {
    $regPath = "HKCU:\Software\RomanticCustomization"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name "InstallPath" -Value $installPath -Type String -Force
    Set-ItemProperty -Path $regPath -Name "InstallDate" -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss") -Type String -Force
    
    # Verify registry was actually written
    $verifyPath = Get-ItemProperty -Path $regPath -Name "InstallPath" -ErrorAction SilentlyContinue
    if ($verifyPath -and $verifyPath.InstallPath -eq $installPath) {
        Write-Host "      ✓ Registry path stored for portability (verified)" -ForegroundColor Green
    } else {
        Write-Host "      ⚠ Registry stored but verification failed (may still work)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "      ✗ Error: Could not store registry path: $_" -ForegroundColor Red
    Write-Host "      ℹ WelcomeMessage will default to C:\RomanticCustomization" -ForegroundColor Gray
}

# Enable startup sound
Write-Host "[6/8] Enabling startup sound..." -ForegroundColor Cyan
try {
    # Different registry paths for different Windows versions
    $regPath = "HKCU:\AppEvents\Schemes"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    
    # Disable the "disable startup sound" setting (double negative = enabled)
    Set-ItemProperty -Path $regPath -Name "DisableStartupSound" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    Write-Host "      ✓ Startup sound enabled" -ForegroundColor Green
} catch {
    Write-Host "      ⚠ Warning: Could not enable startup sound" -ForegroundColor Yellow
}

# Create scheduled task for welcome message
Write-Host "[7/8] Setting up welcome message..." -ForegroundColor Cyan

$taskName = "RomanticWelcome"

# Remove existing task if it exists
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false | Out-Null
    Write-Host "      ℹ Removed existing welcome task" -ForegroundColor Gray
}

# Get current user name
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Create new scheduled task
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$installPath\WelcomeMessage.ps1`""

$trigger = New-ScheduledTaskTrigger -AtLogOn -User $currentUser

$principal = New-ScheduledTaskPrincipal -UserId $currentUser -LogonType Interactive -RunLevel Highest

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 5)

try {
    Register-ScheduledTask -TaskName $taskName `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings `
        -Description "Displays romantic welcome message at login" `
        -Force | Out-Null
    
    # Verify task was created successfully with detailed checks
    Start-Sleep -Milliseconds 500
    $verifyTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    
    if ($verifyTask) {
        # Check task state and properties
        $isEnabled = $verifyTask.State -eq 'Ready'
        $hasTrigger = $verifyTask.Triggers -ne $null -and @($verifyTask.Triggers | Where-Object { $_.CimClass.CimClassName -like '*LogOnTrigger*' }).Count -gt 0
        $hasAction = $verifyTask.Actions -ne $null -and $verifyTask.Actions.Count -gt 0
        
        if ($isEnabled -and $hasTrigger -and $hasAction) {
            Write-Host "      ✓ Welcome message task created, verified, and ready" -ForegroundColor Green
        } else {
            Write-Host "      ⚠ Task created but has issues:" -ForegroundColor Yellow
            if (-not $isEnabled) { Write-Host "        - Task is not enabled (State: $($verifyTask.State))" -ForegroundColor Yellow }
            if (-not $hasTrigger) { Write-Host "        - LogOn trigger not found" -ForegroundColor Yellow }
            if (-not $hasAction) { Write-Host "        - No action configured" -ForegroundColor Yellow }
        }
    } else {
        Write-Host "      ⚠ Task created but verification failed (may work on next login)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "      ✗ Error creating welcome task: $($_.Exception.Message)" -ForegroundColor Red
}

# Apply romantic theme colors
Write-Host "[8/8] Applying romantic theme..." -ForegroundColor Cyan

try {
    # Set accent color (works on both Win10 and Win11)
    $accentPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"
    if (-not (Test-Path $accentPath)) {
        New-Item -Path $accentPath -Force | Out-Null
    }
    
    # Rose gold/romantic pink color (RGB: 183, 110, 121 = 0xB76E79)
    $colorValue = 0xFFB76E79
    Set-ItemProperty -Path $accentPath -Name "AccentColorMenu" -Value $colorValue -Type DWord -Force
    Set-ItemProperty -Path $accentPath -Name "StartColorMenu" -Value $colorValue -Type DWord -Force
    
    # Enable accent color on taskbar and Start
    $dwmPath = "HKCU:\Software\Microsoft\Windows\DWM"
    Set-ItemProperty -Path $dwmPath -Name "ColorPrevalence" -Value 1 -Type DWord -Force
    
    # For Windows 10 - show accent color on taskbar
    $themesPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    Set-ItemProperty -Path $themesPath -Name "ColorPrevalence" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    
    Write-Host "      ✓ Romantic theme colors applied" -ForegroundColor Green
} catch {
    Write-Host "      ⚠ Warning: Could not apply all theme settings" -ForegroundColor Yellow
}

if ($hasCursors) {
    # Get list of cursor files
    $cursorFiles = @{
        "Arrow" = Get-ChildItem "$cursorsPath" -Filter "*normal*.cur" | Select-Object -First 1
        "Help" = Get-ChildItem "$cursorsPath" -Filter "*help*.cur" | Select-Object -First 1
        "AppStarting" = Get-ChildItem "$cursorsPath" -Filter "*work*.ani" | Select-Object -First 1
        "Wait" = Get-ChildItem "$cursorsPath" -Filter "*busy*.ani" | Select-Object -First 1
        "Hand" = Get-ChildItem "$cursorsPath" -Filter "*link*.cur" | Select-Object -First 1
    }
    
    # If we found cursor files with standard naming, try to apply them
    $appliedCursors = 0
    $cursorsRegPath = "HKCU:\Control Panel\Cursors"
    
    foreach ($cursorType in $cursorFiles.Keys) {
        if ($cursorFiles[$cursorType]) {
            try {
                Set-ItemProperty -Path $cursorsRegPath -Name $cursorType -Value $cursorFiles[$cursorType].FullName -Force
                $appliedCursors++
            } catch {
                # Silently continue if one fails
            }
        }
    }
    
    if ($appliedCursors -gt 0) {
        # Refresh cursors
        [System.Windows.Forms.SendKeys]::SendWait("{F5}")
        Write-Host "      ✓ Applied $appliedCursors cursor(s) automatically" -ForegroundColor Green
        Write-Host "      ℹ Install remaining cursors manually via Mouse Settings" -ForegroundColor Gray
    } else {
        Write-Host "      ℹ Install cursors manually via Mouse Settings" -ForegroundColor Gray
        Write-Host "        (Cursors saved in C:\RomanticCustomization\Cursors)" -ForegroundColor Gray
    }
} else {
    Write-Host "      ℹ No cursor files to install" -ForegroundColor Gray
}

# Final summary
Write-Host ""
Write-Host "================================================" -ForegroundColor Magenta
Write-Host "        Installation Complete! ✓" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Magenta
Write-Host ""

Write-Host "What was installed:" -ForegroundColor White
Write-Host "  ✓ Welcome message popup at login" -ForegroundColor Green
if ($hasSound) {
    Write-Host "  ✓ Romantic sound effect" -ForegroundColor Green
}
Write-Host "  ✓ Rose gold/pink accent colors" -ForegroundColor Green
Write-Host "  ✓ Startup sound enabled" -ForegroundColor Green
if ($hasCursors) {
    Write-Host "  ✓ Custom cursors (may need manual setup)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation location: $installPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT - Next steps:" -ForegroundColor Yellow
Write-Host "  1. LOG OUT and LOG BACK IN to see the welcome message" -ForegroundColor White
Write-Host "  2. Set a romantic wallpaper (Settings > Personalization)" -ForegroundColor White
if ($hasCursors -and $appliedCursors -eq 0) {
    Write-Host "  3. Install cursors (Settings > Mouse > Additional mouse options)" -ForegroundColor White
}
Write-Host ""
Write-Host "To uninstall:" -ForegroundColor Gray
Write-Host "  - Delete task 'RomanticWelcome' from Task Scheduler" -ForegroundColor Gray
Write-Host "  - Delete folder: C:\RomanticCustomization" -ForegroundColor Gray
Write-Host ""

# Ask if they want to test the welcome message now
Write-Host "Would you like to test the welcome message now? (Y/N): " -ForegroundColor Yellow -NoNewline
$response = Read-Host

if ($response -eq 'Y' -or $response -eq 'y') {
    Write-Host ""
    Write-Host "Launching welcome message..." -ForegroundColor Cyan
    Start-Sleep -Seconds 1
    & powershell.exe -ExecutionPolicy Bypass -File "$installPath\WelcomeMessage.ps1"
}

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
pause