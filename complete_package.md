# 💝 Romantic Windows Customization - Complete Package

## Instructions for Creating Your Package

Copy each file below into separate files in a folder called "RomanticCustomization"

---

## FILE 1: INSTALL.bat

**Save as:** `INSTALL.bat`

```batch
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
```

---

## FILE 2: INSTALL.ps1

**Save as:** `INSTALL.ps1`

```powershell
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
Write-Host "[1/7] Setting up directories..." -ForegroundColor Cyan

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
Write-Host "[2/7] Installing files..." -ForegroundColor Cyan

# Copy welcome script
Copy-Item "$packageDir\WelcomeMessage.ps1" -Destination "$installPath\WelcomeMessage.ps1" -Force
Write-Host "      ✓ Welcome script installed" -ForegroundColor Green

# Copy config file
Copy-Item "$packageDir\config.txt" -Destination "$installPath\config.txt" -Force
Write-Host "      ✓ Configuration file installed" -ForegroundColor Green

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
Write-Host "[3/7] Configuring PowerShell..." -ForegroundColor Cyan
try {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop
    Write-Host "      ✓ PowerShell configured" -ForegroundColor Green
} catch {
    Write-Host "      ⚠ Warning: Could not set execution policy" -ForegroundColor Yellow
    Write-Host "        Welcome message may not work until policy is set manually" -ForegroundColor Gray
}

# Enable startup sound
Write-Host "[4/7] Enabling startup sound..." -ForegroundColor Cyan
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
Write-Host "[5/7] Setting up welcome message..." -ForegroundColor Cyan

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

    Write-Host "      ✓ Welcome message task created" -ForegroundColor Green
} catch {
    Write-Host "      ✗ Error creating welcome task: $($_.Exception.Message)" -ForegroundColor Red
}

# Apply romantic theme colors
Write-Host "[6/7] Applying romantic theme..." -ForegroundColor Cyan

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

# Auto-install cursors if available
Write-Host "[7/7] Configuring cursors..." -ForegroundColor Cyan

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
```

---

## FILE 3: WelcomeMessage.ps1

**Save as:** `WelcomeMessage.ps1`

```powershell
# Romantic Welcome Script
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Load configuration from config file
$scriptDir = "C:\RomanticCustomization"
$configFile = "$scriptDir\config.txt"

# Default values (used if config file is missing)
$herName = "My Love"
$startDate = Get-Date "2020-01-01"
$messages = @(
    "Good morning, beautiful! Hope your day is as amazing as you are ❤️",
    "Welcome back! You make every day brighter ☀️",
    "Hey gorgeous! Ready to conquer the day together? 💕",
    "Missing you already! Have a wonderful day 🌹",
    "You're logged in to the best computer... but I'm logged in to the best heart 💖",
    "Remember: you're incredible! ✨"
)

# Read config file if it exists
if (Test-Path $configFile) {
    $configContent = Get-Content $configFile
    $customMessages = @()

    foreach ($line in $configContent) {
        # Skip comments and empty lines
        if ($line -match '^\s*#' -or $line -match '^\s*$') {
            continue
        }

        # Parse HER_NAME
        if ($line -match '^HER_NAME=(.+)$') {
            $herName = $matches[1].Trim()
        }

        # Parse ANNIVERSARY_DATE
        if ($line -match '^ANNIVERSARY_DATE=(.+)$') {
            try {
                $startDate = Get-Date $matches[1].Trim()
            } catch {
                # Keep default if date format is invalid
            }
        }

        # Parse MESSAGE lines
        if ($line -match '^MESSAGE=(.+)$') {
            $customMessages += $matches[1].Trim()
        }
    }

    # Use custom messages if any were found
    if ($customMessages.Count -gt 0) {
        $messages = $customMessages
    }
}

# Replace placeholder in messages
$messages = $messages | ForEach-Object { $_ -replace '\{NAME\}', $herName }

# Play romantic sound
$soundPath = "$scriptDir\Sounds\romantic.wav"
if (Test-Path $soundPath) {
    try {
        $player = New-Object System.Media.SoundPlayer
        $player.SoundLocation = $soundPath
        $player.Play()
    } catch {
        # Silently continue if sound fails
    }
}

# Pick a random message
$randomMessage = $messages | Get-Random

# Calculate days together
$daysTogether = (New-TimeSpan -Start $startDate -End (Get-Date)).Days

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Welcome Home! 💝"
$form.Size = New-Object System.Drawing.Size(520, 320)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(255, 250, 240, 245)
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.TopMost = $true
$form.Icon = [System.Drawing.SystemIcons]::Information

# Title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "💕 Welcome, $herName! 💕"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 139, 69, 84)
$titleLabel.Location = New-Object System.Drawing.Point(10, 20)
$titleLabel.Size = New-Object System.Drawing.Size(500, 40)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

# Message label
$messageLabel = New-Object System.Windows.Forms.Label
$messageLabel.Text = $randomMessage
$messageLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$messageLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 60, 60, 60)
$messageLabel.Location = New-Object System.Drawing.Point(20, 80)
$messageLabel.Size = New-Object System.Drawing.Size(480, 90)
$messageLabel.TextAlign = "MiddleCenter"
$messageLabel.AutoSize = $false
$form.Controls.Add($messageLabel)

# Days together label
$daysLabel = New-Object System.Windows.Forms.Label
$daysLabel.Text = "We've been together for $daysTogether amazing days! 🥰"
$daysLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Italic)
$daysLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 139, 69, 84)
$daysLabel.Location = New-Object System.Drawing.Point(20, 180)
$daysLabel.Size = New-Object System.Drawing.Size(480, 35)
$daysLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($daysLabel)

# Close button
$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "Thanks, sweetheart! ❤️"
$closeButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$closeButton.Location = New-Object System.Drawing.Point(160, 230)
$closeButton.Size = New-Object System.Drawing.Size(200, 40)
$closeButton.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 182, 193)
$closeButton.FlatStyle = 'Flat'
$closeButton.FlatAppearance.BorderSize = 0
$closeButton.Cursor = [System.Windows.Forms.Cursors]::Hand
$closeButton.Add_Click({ $form.Close() })
$form.Controls.Add($closeButton)

# Add hover effect to button
$closeButton.Add_MouseEnter({
    $this.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 160, 175)
})
$closeButton.Add_MouseLeave({
    $this.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 182, 193)
})

# Auto-close after 20 seconds
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 20000
$timer.Add_Tick({
    $form.Close()
    $timer.Stop()
    $timer.Dispose()
})
$timer.Start()

# Show the form
$form.Add_Shown({ $form.Activate() })
$form.ShowDialog() | Out-Null
$form.Dispose()
```

---

## FILE 4: config.txt

**Save as:** `config.txt`
**⚠️ EDIT THIS FILE BEFORE INSTALLING!**

```
# Romantic Customization Configuration
# Edit these settings before installing!
# Save this file after making changes

# Her name (this will appear in the welcome message)
HER_NAME=My Love

# Your anniversary or start date (format: YYYY-MM-DD)
# Example: 2020-01-15 for January 15, 2020
ANNIVERSARY_DATE=2020-01-01

# Additional romantic messages (optional - add your own!)
# The system will randomly pick one each time she logs in
# Keep each message on its own line starting with MESSAGE=
MESSAGE=Good morning, beautiful! Hope your day is as amazing as you are ❤️
MESSAGE=Welcome back! You make every day brighter ☀️
MESSAGE=Hey gorgeous! Ready to conquer the day together? 💕
MESSAGE=Missing you already! Have a wonderful day 🌹
MESSAGE=You're logged in to the best computer... but I'm logged in to the best heart 💖
MESSAGE=Remember: you're incredible! ✨
MESSAGE=Another day, another chance to be amazing! 💫
MESSAGE=The world is lucky to have you in it today! 🌸
```

---

## FILE 5: README.txt

**Save as:** `README.txt`

```
💝 ROMANTIC WINDOWS CUSTOMIZATION PACKAGE 💝

═══════════════════════════════════════════════════════════════

QUICK START:

1. Edit config.txt - Change her name and your anniversary date
2. (Optional) Add romantic.wav sound file to this folder
3. (Optional) Add .cur or .ani cursor files to this folder
4. Double-click INSTALL.bat on her computer
5. Log out and log back in!

═══════════════════════════════════════════════════════════════

WHAT THIS DOES:

✨ Shows a romantic welcome message popup when she logs in
🎵 Plays a romantic sound at login (if you provide romantic.wav)
🎨 Applies beautiful rose gold/pink theme colors
🖱️ Installs custom cursors (if you provide cursor files)
💕 Shows an auto-updating "days together" counter

═══════════════════════════════════════════════════════════════

REQUIRED FILES:
✅ INSTALL.bat
✅ INSTALL.ps1
✅ WelcomeMessage.ps1
✅ config.txt
✅ README.txt (this file)

OPTIONAL FILES:
🎵 romantic.wav - Your romantic sound (WAV format, under 10 seconds)
🖱️ *.cur or *.ani - Cursor files

═══════════════════════════════════════════════════════════════

BEFORE INSTALLING - CUSTOMIZE:

1. Edit config.txt:
   - Change HER_NAME to her actual name
   - Change ANNIVERSARY_DATE to your date (format: YYYY-MM-DD)
   - Add your own romantic messages if you want!

2. Add romantic sound:
   - Get a romantic sound or song snippet
   - Convert to WAV format
   - Name it romantic.wav
   - Put it in this folder

3. Add cursors (optional):
   - Download romantic cursor packs
   - Put .cur and .ani files in this folder

═══════════════════════════════════════════════════════════════

INSTALLATION:

On Her Computer:
1. Copy this entire folder to a USB drive
2. Plug USB into her computer
3. Open the folder
4. Double-click INSTALL.bat
5. Click "Yes" when asked for admin privileges
6. Wait for installation to complete
7. Log out and log back in to see it work!

That's it! Everything is automated!

═══════════════════════════════════════════════════════════════

WHERE TO GET EXTRAS:

Romantic Sounds:
- Convert a song snippet: https://convertio.co/mp3-wav/
- Record your own message with Windows Voice Recorder
- Search for free romantic sound effects

Romantic Cursors:
- RW-Designer: www.rw-designer.com/cursor-sets
- Cursors 4U: www.cursors-4u.com
- Search: "hearts cursors" or "romantic cursors"

═══════════════════════════════════════════════════════════════

TROUBLESHOOTING:

"Cannot be loaded because running scripts is disabled"
→ Open PowerShell as Admin
→ Run: Set-ExecutionPolicy RemoteSigned
→ Type Y and press Enter

"This app has been blocked"
→ Right-click INSTALL.bat → Properties
→ Check "Unblock" → OK
→ Try again

Welcome message doesn't appear
→ Make sure you LOGGED OUT and back in (not just locked)
→ Check Task Scheduler for "RomanticWelcome" task

Sound doesn't play
→ Verify romantic.wav is in WAV format (not renamed MP3)
→ Check volume is turned up
→ Try playing the file directly first

═══════════════════════════════════════════════════════════════

AFTER INSTALLATION:

Files are saved to: C:\RomanticCustomization\

Additional customization:
- Set romantic wallpaper: Right-click Desktop → Personalize
- Adjust colors: Settings → Personalization → Colors
- Install more cursors: Mouse Settings → Pointers

═══════════════════════════════════════════════════════════════

TO UNINSTALL:

1. Open Task Scheduler
2. Delete "RomanticWelcome" task
3. Delete folder: C:\RomanticCustomization\
4. Reset cursors in Mouse Settings if needed

═══════════════════════════════════════════════════════════════

TIPS:

✨ Record a personal voice message for extra romance
✨ Add new messages weekly by editing the config file
✨ Time the installation for a special occasion
✨ Works on Windows 10 and Windows 11
✨ Can be used on multiple computers from the same USB drive

═══════════════════════════════════════════════════════════════

Version 1.0 - Portable USB Edition
Compatible with Windows 10 & Windows 11

Good luck! 💕
```

═══════════════════════════════════════════════════════════════

## HOW TO CREATE THE PACKAGE:

1. Create a folder called "RomanticCustomization"
2. Copy each file above into separate files with the exact names shown
3. Edit config.txt with her name and your date
4. Add romantic.wav and cursor files if you have them
5. Put the folder on a USB drive
6. Done! Ready to use on any Windows 10/11 PC

═══════════════════════════════════════════════════════════════
