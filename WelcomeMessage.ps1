# Romantic Welcome Script
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Load configuration from config file
# v1.1: Read installation path from registry for portability
$regPath = "HKCU:\Software\RomanticCustomization"
$scriptDir = $null

try {
    $regData = Get-ItemProperty -Path $regPath -Name "InstallPath" -ErrorAction SilentlyContinue
    if ($regData -and $regData.InstallPath) {
        $scriptDir = $regData.InstallPath
    }
} catch {
    # Registry key not found, fall back to default
}

# Fallback to default path if registry lookup failed
if ([string]::IsNullOrEmpty($scriptDir)) {
    $scriptDir = "C:\RomanticCustomization"
}

$configFile = "$scriptDir\config.txt"

# Default values (used if config file is missing)
$herName = "My Love"
$startDate = Get-Date "2020-01-01"
$welcomeTimeout = 20  # seconds
$messages = @(
    "Good morning, beautiful! Hope your day is as amazing as you are ❤️",
    "Welcome back! You make every day brighter ☀️",
    "Hey gorgeous! Ready to conquer the day together? 💕",
    "Missing you already! Have a wonderful day 🌹",
    "You're logged in to the best computer... but I'm logged in to the best heart 💖",
    "Remember: you're incredible! ✨"
)

# Read config file if it exists (v1.1 format with sections)
if (Test-Path $configFile) {
    $configContent = Get-Content $configFile -Raw
    $lines = $configContent -split '[\r\n]+'
    $customMessages = @()
    $inMessagesSection = $false
    
    foreach ($line in $lines) {
        $line = $line.Trim()
        
        # Track which section we're in
        if ($line -match '^\[MESSAGES\]') {
            $inMessagesSection = $true
            continue
        }
        if ($line -match '^\[' -and $line -ne '[MESSAGES]') {
            $inMessagesSection = $false
            continue
        }
        
        # Skip comments and empty lines
        if ($line -match '^\s*#' -or $line -match '^\s*$') {
            continue
        }
        
        # Parse HER_NAME
        if ($line -match '^HER_NAME=(.+)$') {
            $herName = $matches[1].Trim()
        }
        
        # Parse WELCOME_TIMEOUT
        if ($line -match '^WELCOME_TIMEOUT=(\d+)$') {
            $timeout = [int]$matches[1].Trim()
            if ($timeout -ge 5 -and $timeout -le 300) {
                $welcomeTimeout = $timeout
            }
        }
        
        # Parse ANNIVERSARY_DATE
        if ($line -match '^ANNIVERSARY_DATE=(.+)$') {
            try {
                $startDate = Get-Date $matches[1].Trim()
            } catch {
                # Keep default if date format is invalid
            }
        }
        
        # Parse MESSAGE lines (only when in [MESSAGES] section)
        if ($inMessagesSection -and $line -match '^MESSAGE=(.+)$') {
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

# Auto-close after configurable timeout (default 20 seconds)
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = $welcomeTimeout * 1000
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