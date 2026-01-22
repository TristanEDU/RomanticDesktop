# System Architecture - Romantic Windows Customization v1.2.1

**For:** Developers, System Architects, Technical Reviewers  
**Last Updated:** January 22, 2026

Complete architectural overview of how Romantic Windows Customization works.

---

## System Overview

```
┌─────────────────────────────────────────────────────────┐
│         ROMANTIC WINDOWS CUSTOMIZATION SYSTEM           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  User Logon Event                                       │
│       ↓                                                 │
│  Windows Task Scheduler (RomanticWelcome)              │
│       ↓                                                 │
│  WelcomeMessage.ps1 Execution                          │
│       ├─ Read config.txt from registry path            │
│       ├─ Parse [MESSAGES] section                      │
│       ├─ Select random message                         │
│       ├─ Calculate days together                       │
│       ├─ Create UI form                                │
│       ├─ Play sound (async)                            │
│       └─ Display popup for N seconds                   │
│                                                         │
│  User dismisses popup or timeout expires               │
│       ↓                                                 │
│  Welcome message disappears                            │
│  User continues with their day 💕                      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Component Architecture

### 1. Installation Layer

**Components:**

- INSTALL.bat (batch entry point)
- INSTALL.ps1 (main installation script)
- CONFIG_VALIDATOR.ps1 (pre-install validation)

**Responsibilities:**

- ✅ Check admin privileges
- ✅ Validate configuration file
- ✅ Create installation directories
- ✅ Copy scripts and resources
- ✅ Configure PowerShell execution policy
- ✅ Store registry keys
- ✅ Create scheduled task
- ✅ Apply theme colors

**Data Flow:**

```
User runs INSTALL.bat
    ↓
Batch requests admin elevation
    ↓
PowerShell execution begins
    ↓
Validate installation prerequisites
    ↓
Run 8 sequential installation steps
    ↓
Create registry entries
    ↓
Create scheduled task
    ↓
Installation complete
```

### 2. Runtime Layer

**Components:**

- Windows Task Scheduler (orchestration)
- WelcomeMessage.ps1 (primary application)
- System.Windows.Forms (UI framework)
- System.Media.SoundPlayer (audio)

**Responsibilities:**

- ✅ Trigger at user logon
- ✅ Load configuration from registry/file
- ✅ Parse config.txt using section-aware logic
- ✅ Display popup UI
- ✅ Play optional sound asynchronously
- ✅ Handle user input
- ✅ Cleanup resources

**Execution Context:**

- Runs as: Current user (non-elevated)
- Trigger: User logon event
- Frequency: Once per logon
- Window: Hidden window execution

### 3. Storage Layer

**Registry Storage:**

```
HKCU:\Software\RomanticCustomization\
├─ InstallPath (string) → C:\RomanticCustomization
└─ InstallDate (string) → 2026-01-22T14:30:00
```

**File Storage:**

```
C:\RomanticCustomization\
├─ WelcomeMessage.ps1 (executable)
├─ config.txt (configuration)
├─ Sounds\
│  └─ romantic.wav (optional)
└─ Cursors\
   └─ *.cur/*.ani (optional)
```

**Config File Format:**

```
[USER]
HER_NAME=string
WELCOME_TIMEOUT=integer

[DATES]
ANNIVERSARY_DATE=YYYY-MM-DD

[MESSAGES]
MESSAGE=string
MESSAGE=string
...

[FUTURE]
# Reserved
```

### 4. Verification Layer

**Components:**

- VERIFY.ps1 (post-install diagnostics)
- CONFIG_VALIDATOR.ps1 (config validation)

**Responsibilities:**

- ✅ Check installation folder
- ✅ Verify scheduled task exists
- ✅ Validate config file
- ✅ Check registry entries
- ✅ Verify theme colors
- ✅ Check script integrity

**Output:** Color-coded report with ✓/✗/⚠ symbols

### 5. Cleanup Layer

**Components:**

- UNINSTALL.ps1 (removal script)

**Responsibilities:**

- ✅ Stop scheduled task
- ✅ Delete installation folder
- ✅ Remove registry keys
- ✅ Restore theme colors
- ✅ Provide -WhatIf preview mode

---

## Configuration Parsing Architecture

### Section-Aware Parser Design

**Problem:** Config file has multiple sections ([USER], [DATES], [MESSAGES], [FUTURE]). Can't blindly extract MESSAGE= lines - they might appear in [FUTURE] section.

**Solution:** State machine with section tracking

```powershell
$inMessagesSection = $false

foreach ($line in $lines) {
    # STATE TRANSITION: Check for section header
    if ($line -match '^\[([A-Z]+)\]') {
        $currentSection = $matches[1]
        $inMessagesSection = ($currentSection -eq 'MESSAGES')
        continue
    }

    # ACTION: Only parse MESSAGE= when in [MESSAGES] state
    if ($inMessagesSection -and $line -match '^MESSAGE=(.+)$') {
        $customMessages += $matches[1].Trim()
    }
}
```

**State Diagram:**

```
┌─────────────────────────────────┐
│  Start: inMessagesSection=false │
└────────────┬────────────────────┘
             │
      ┌──────┴──────┐
      │             │
  [OTHER]      [MESSAGES]
      │             │
      v             v
 inMessagesSection  inMessagesSection
    = false           = true
      │             │
      │  Parse MESSAGE= only here
      │             │
      ├─────────────┤
      │    [OTHER]  │
      v             v
Transition back if section changes
```

**Benefits:**

- ✅ Prevents parsing wrong sections
- ✅ Handles any section order
- ✅ Scalable for future sections
- ✅ Efficient (single pass through file)

---

## Scheduled Task Lifecycle

```
┌────────────────────────────────────────────────┐
│  1. CREATION (during INSTALL.ps1 [7/8])        │
├────────────────────────────────────────────────┤
│  - Register task with Task Scheduler           │
│  - Set trigger: At logon                       │
│  - Set action: Execute WelcomeMessage.ps1      │
│  - Set user: Current user                      │
│  - Verification: Read-back test                │
└─────────────────────┬──────────────────────────┘
                      │
                      ↓
┌────────────────────────────────────────────────┐
│  2. REGISTRATION (Task Scheduler)              │
├────────────────────────────────────────────────┤
│  - Task visible in Task Scheduler              │
│  - State: Ready                                │
│  - Can be manually triggered                   │
└─────────────────────┬──────────────────────────┘
                      │
                      ↓
┌────────────────────────────────────────────────┐
│  3. EXECUTION (at user logon)                  │
├────────────────────────────────────────────────┤
│  - Windows fires logon trigger                 │
│  - Task Scheduler launches WelcomeMessage.ps1  │
│  - Script runs in user context                 │
│  - Popup displays (20 seconds default)         │
└─────────────────────┬──────────────────────────┘
                      │
                      ↓
┌────────────────────────────────────────────────┐
│  4. CLEANUP (on popup close)                   │
├────────────────────────────────────────────────┤
│  - Timer stops                                 │
│  - Form disposed                               │
│  - Sound playback stops (if still playing)     │
│  - Resources freed                             │
└─────────────────────┬──────────────────────────┘
                      │
                      ↓
┌────────────────────────────────────────────────┐
│  5. DELETION (during UNINSTALL.ps1)            │
├────────────────────────────────────────────────┤
│  - Task removed from Task Scheduler            │
│  - No longer runs at logon                     │
└────────────────────────────────────────────────┘
```

---

## User Interface Architecture

### Welcome Message Form

**Window Properties:**

- Title: "Welcome Home! 💝"
- Size: 520×320 pixels
- Position: Centered screen
- TopMost: True (always on top)
- BorderStyle: FixedDialog (non-resizable)
- BackColor: Soft pink (#FFF0F5)

**Form Composition:**

```
┌─────────────────────────────────────────────┐
│  💕 Welcome, [NAME]! 💕                    │ ← Title Label
│                                             │
│  [Random personalized message]              │ ← Message Label
│  [Shows 1 of 8+ custom messages]            │
│                                             │
│  We've been together for [N] amazing days! 🥰 │ ← Days Label
│                                             │
│    [Thanks, sweetheart! ❤️]                 │ ← Close Button
│                                             │
└─────────────────────────────────────────────┘
```

**Colors:**

- Background: RGB(255, 240, 245) - Soft pink
- Title text: RGB(139, 69, 84) - Rose red
- Message text: RGB(60, 60, 60) - Dark gray
- Button: RGB(255, 182, 193) - Light pink
- Button hover: RGB(255, 105, 180) - Hot pink

**Font:**

- Title: Segoe UI, 16pt, Bold
- Message: Segoe UI, 11pt, Regular
- Button: Segoe UI, 10pt, Bold

### UI Lifecycle

```
1. CREATE FORM
   ↓ New-Object System.Windows.Forms.Form

2. CREATE CONTROLS
   ↓ Add labels and button

3. LOAD MESSAGE
   ↓ Select random from 8+ messages
   ↓ Replace {NAME} token

4. DISPLAY FORM
   ↓ $form.ShowDialog()

5. PLAY SOUND (ASYNC)
   ↓ $player.PlayAsync() - non-blocking

6. START TIMER
   ↓ Timer fires after WELCOME_TIMEOUT seconds

7. CLOSE FORM
   ↓ On timeout or user click

8. CLEANUP
   ↓ Timer.Stop()
   ↓ Timer.Dispose()
   ↓ Form.Dispose()
```

---

## Async Sound Playback Architecture

**Challenge:** If sound blocks UI, form freezes during playback.

**Solution:** Asynchronous playback using `PlayAsync()`

```powershell
# Create player
$player = New-Object System.Media.SoundPlayer
$player.SoundLocation = "C:\RomanticCustomization\Sounds\romantic.wav"

# Play asynchronously (non-blocking)
$player.PlayAsync()  # Returns immediately, sound plays in background

# Form continues to display unblocked
# User can close form while sound still playing
```

**Flow:**

```
WelcomeMessage.ps1 starts
    ↓
    ├─ Show form (UI thread)
    │
    └─ PlayAsync() starts sound (background thread)
            ↓
            └─ Returns immediately to UI thread
                ↓
                UI is responsive during sound playback
                ↓
    Sound continues in background
    Form stays responsive
    User can close anytime
```

**Comparison:**

- ❌ `Play()` - Blocks UI until sound finishes
- ✅ `PlayAsync()` - Returns immediately, sound in background

---

## Registry Interaction Architecture

### Write Operations

```powershell
# Step 1: Create registry path if not exists
$regPath = "HKCU:\Software\RomanticCustomization"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Step 2: Write InstallPath
Set-ItemProperty -Path $regPath -Name "InstallPath" -Value "C:\RomanticCustomization"

# Step 3: Write InstallDate
Set-ItemProperty -Path $regPath -Name "InstallDate" -Value (Get-Date -Format o)

# Step 4: VERIFY - Read back
$readBack = (Get-ItemProperty -Path $regPath -Name "InstallPath").InstallPath
if ($readBack -ne "C:\RomanticCustomization") {
    # Write failed!
    Write-Error "Registry write verification failed"
}
```

### Read Operations

```powershell
# WelcomeMessage.ps1 reads install path
$regPath = "HKCU:\Software\RomanticCustomization"
$scriptDir = (Get-ItemProperty -Path $regPath -Name "InstallPath").InstallPath

# Fallback if registry read fails
if ([string]::IsNullOrEmpty($scriptDir)) {
    $scriptDir = "C:\RomanticCustomization"
}

# Then use scriptDir for config file path
$configFile = "$scriptDir\config.txt"
```

**Advantages:**

- ✅ Portable (works from any drive)
- ✅ Multi-user support (each user has own HKCU key)
- ✅ No hardcoded paths
- ✅ Can upgrade installation location

---

## Error Handling Architecture

### Try-Catch Pattern

```powershell
try {
    # Risky operation
    $value = $risky_operation
} catch {
    # Log error
    Write-Host "Operation failed: $_" -ForegroundColor Red

    # Either retry, fallback, or exit
    if ($canRetry) {
        # Retry logic
    } elseif ($hasFallback) {
        # Use fallback
    } else {
        # Critical failure
        exit 1
    }
}
```

### Graceful Degradation

**Example: Optional sound file**

```powershell
$soundPath = "$scriptDir\Sounds\romantic.wav"

if (Test-Path $soundPath) {
    try {
        $player.PlayAsync()
    } catch {
        # Sound playback failed, but continue anyway
        Write-Warning "Sound playback failed"
    }
} else {
    # Sound file missing, continue without sound
    # This is not an error - sound is optional
}

# Form still displays regardless
$form.ShowDialog()
```

### Error Reporting

- **Installation errors:** Shown in console, exit code = 1
- **Runtime errors:** Silent (logged in Event Viewer)
- **Validation errors:** Detailed messages with fixes

---

## Resource Management

### Timer Lifecycle (Critical!)

**Problem:** Timer can leak memory if not properly disposed

**Solution:** Dispose timer in FormClosing event

```powershell
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = ($welcomeTimeout * 1000)

# Set up form closing event handler
$form.Add_FormClosing({
    $timer.Stop()
    $timer.Dispose()  # CRITICAL: Clean up timer
})

# Alternative: Explicit cleanup
$timer.Stop()
$timer.Dispose()
```

### Form Lifecycle

```powershell
# Create
$form = New-Object System.Windows.Forms.Form

# ... Add controls, set properties ...

# Display
$form.ShowDialog()

# Cleanup (automatic on form close)
$form.Dispose()
```

---

## File Encoding Architecture

### UTF-8 with BOM

**Purpose:** Preserve international characters and emoji

**BOM (Byte Order Mark):** `EF BB BF` (hex)

**Detection:**

```powershell
$bytes = [System.IO.File]::ReadAllBytes($path)
$hasUTF8BOM = ($bytes.Length -ge 3 -and
               $bytes[0] -eq 0xEF -and
               $bytes[1] -eq 0xBB -and
               $bytes[2] -eq 0xBF)
```

**Writing:**

```powershell
$content = "Your content here"
[System.IO.File]::WriteAllText($path, $content, [System.Text.Encoding]::UTF8)
```

**Why UTF-8 with BOM:**

- ✅ Windows Notepad auto-detects BOM
- ✅ PowerShell preserves BOM on read
- ✅ Supports full Unicode range
- ✅ Compatible with international characters: 日本語, العربية, 中文, Русский, 💕

---

## Security Architecture

### Execution Context

```
User Logon
    ↓
Task Scheduler fires trigger
    ↓
WelcomeMessage.ps1 executes AS CURRENT USER (not elevated)
    ↓
Accesses HKCU hive (user registry, not HKLM)
    ↓
Reads local config file
    ↓
Creates local UI window
    ↓
No internet, no external calls, no privilege escalation
```

### Privilege Model

- **Installation:** Requires admin (to create C:\ folder and task)
- **Runtime:** Runs as user (non-elevated)
- **Registry Access:** User hive only (HKCU, not HKLM)
- **File Access:** User-owned directory only

### Data Isolation

- **Per-user settings:** Each user has own config and registry
- **No cloud sync:** All data stays local
- **No external calls:** No internet connectivity
- **No data export:** Config stays in C:\RomanticCustomization\

---

## Scalability & Performance

### Configuration Size

| Metric           | Current     | Limit     | Headroom |
| ---------------- | ----------- | --------- | -------- |
| Messages         | 8           | ~50       | 6.25x    |
| Message length   | 200 chars   | 200 chars | At limit |
| HER_NAME length  | 100 chars   | 100 chars | At limit |
| Config file size | ~2KB        | ~100KB    | 50x      |
| Welcome popup    | 20s timeout | 300s max  | 15x      |

### Memory Usage

| Component            | Usage |
| -------------------- | ----- |
| WelcomeMessage.ps1   | ~30MB |
| Form + controls      | ~5MB  |
| Sound playback       | ~5MB  |
| Total per invocation | ~40MB |

**Note:** Memory freed after form closes (no memory leaks with proper timer cleanup)

---

## Future Extensibility

### Reserved Sections

**[FUTURE]** section reserved for v1.3+

Potential additions:

```ini
[VOICE]  # v2.0
MESSAGE_VOICE=voice_file.wav

[WALLPAPER]  # v2.0
WALLPAPER_ROTATE=true

[CALENDAR]  # v2.0+
INTEGRATE_CALENDAR=true

[THEMES]  # v2.0+
SEASON_THEME=spring
```

### Backward Compatibility

**Design principle:** v1.2.1 ignores unknown sections

```powershell
# If v2.0 adds [VOICE] section, v1.2.1 simply skips it
# No breaking changes
```

---

## Deployment Architecture

### Single-User Install

```
User runs INSTALL.ps1
    ↓
C:\RomanticCustomization\ created
    ↓
HKCU:\Software\RomanticCustomization\ created (CURRENT USER)
    ↓
Task created for current user
    ↓
Works only for that user
```

### Multi-User System

```
For each user needing installation:
    Admin runs: INSTALL.ps1 (or user runs with admin rights)
    ↓
    C:\RomanticCustomization\ created (shared)
    ↓
    HKCU:\...\RomanticCustomization\ created (PER USER)
    ↓
    Task created for that user
    ↓
    Each user sees welcome independently
```

---

## Summary: How It All Works Together

1. **User logs in** → Windows triggers logon event
2. **Task Scheduler** → RomanticWelcome task fires
3. **Execute Script** → WelcomeMessage.ps1 runs as user
4. **Read Config** → Loads from registry path, reads config.txt
5. **Parse Messages** → Section-aware parser selects random message
6. **Create UI** → Windows Forms displays popup
7. **Play Sound** → Async playback starts in background
8. **Wait/Close** → Popup shows for WELCOME_TIMEOUT seconds or user closes
9. **Cleanup** → Timer disposed, form closed, resources freed
10. **Back to Desktop** → User continues with their day 💕

---

**Questions?** See [TECHNICAL_REFERENCE.md](TECHNICAL_REFERENCE.md) or [DOCUMENTATION_INDEX.md](../DOCUMENTATION_INDEX.md)
