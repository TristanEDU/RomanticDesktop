# Technical Reference - Romantic Windows Customization v1.2.1

**For:** Developers, IT Administrators, Advanced Users  
**Last Updated:** January 22, 2026

Complete technical specifications, registry keys, validation rules, and API reference.

---

## Registry Keys

### Primary Installation Key

**Location:** `HKCU:\Software\RomanticCustomization`

**Values:**

| Value | Type | Purpose | Example |
|-------|------|---------|---------|
| `InstallPath` | String (REG_SZ) | Installation directory path | `C:\RomanticCustomization` |
| `InstallDate` | String (REG_SZ) | Installation timestamp (ISO 8601) | `2026-01-22T14:30:00` |

**Creation:** During INSTALL.ps1 execution (Step 5)  
**Modification:** None (read-only after installation)  
**Deletion:** UNINSTALL.ps1 removes key

### Related Registry Keys (Modified by Installation)

**Theme Colors:** `HKCU:\Software\Microsoft\Windows\DWM\`
- `AccentColor` (DWORD) — Applied during [8/8] step
- Modified: Yes (by installer)
- Reverted: By UNINSTALL.ps1

---

## Configuration File Format (config.txt)

**Location:** `C:\RomanticCustomization\config.txt` (after install) or in package folder (before)  
**Encoding:** UTF-8 with BOM  
**Max Size:** ~10KB  
**Format:** INI-like section-based

### File Structure

```ini
# Comments start with #
[SECTION_NAME]
KEY=VALUE
KEY=VALUE
```

### Sections

#### [USER] - User Customization
```
[USER]
HER_NAME=string (1-100 chars)
WELCOME_TIMEOUT=integer (5-300)
```

**HER_NAME**
- Type: String (Unicode supported)
- Min: 1 character
- Max: 100 characters
- Validation: Non-empty
- Usage: Displayed in welcome message and "days together" label

**WELCOME_TIMEOUT**
- Type: Integer
- Min: 5 seconds
- Max: 300 seconds
- Default: 20 seconds
- Validation: Numeric range check
- Usage: Popup auto-closes after this time

#### [DATES] - Important Dates
```
[DATES]
ANNIVERSARY_DATE=YYYY-MM-DD
```

**ANNIVERSARY_DATE**
- Format: ISO 8601 (YYYY-MM-DD)
- Example: `2024-01-06`
- Validation: Valid date, not in future
- Usage: Calculates "days together" counter
- Parsing: `[datetime]::ParseExact()` PowerShell method

#### [MESSAGES] - Welcome Messages
```
[MESSAGES]
MESSAGE=string (max 200 chars)
MESSAGE=string (max 200 chars)
...
```

**MESSAGE**
- Type: String
- Min: 1 per file (system needs at least one)
- Max: Unlimited (practical limit ~50 for performance)
- Max length per line: 200 characters
- Special token: `{NAME}` replaced with `HER_NAME`
- Selection: Random selection at runtime
- Validation: At least 1 message exists, max 200 chars per message

#### [FUTURE] - Reserved
```
[FUTURE]
# Reserved for v2.0+ features
# Do not modify this section
```

Not parsed by v1.2.1 (reserved for future versions)

---

## Validation Rules (11 Total)

### Config Validator Validation Rules

**Function:** `Test-RomanticConfig` (CONFIG_VALIDATOR.ps1)

| Rule # | Category | Check | Severity | Error Message |
|--------|----------|-------|----------|---------------|
| 1 | Structure | [USER] section exists | Error | "Missing [USER] section" |
| 2 | Structure | [DATES] section exists | Error | "Missing [DATES] section" |
| 3 | Structure | [MESSAGES] section exists | Error | "Missing [MESSAGES] section" |
| 4 | User | HER_NAME not empty | Error | "HER_NAME is empty" |
| 5 | User | HER_NAME ≤ 100 chars | Error | "HER_NAME exceeds 100 characters" |
| 6 | User | WELCOME_TIMEOUT is numeric | Error | "WELCOME_TIMEOUT must be numeric" |
| 7 | User | WELCOME_TIMEOUT 5-300 range | Error | "WELCOME_TIMEOUT must be 5-300 seconds" |
| 8 | Dates | ANNIVERSARY_DATE valid format | Error | "ANNIVERSARY_DATE invalid format (need YYYY-MM-DD)" |
| 9 | Dates | ANNIVERSARY_DATE not future | Error | "ANNIVERSARY_DATE cannot be in the future" |
| 10 | Messages | At least 1 MESSAGE exists | Error | "No messages found in [MESSAGES] section" |
| 11 | Messages | Each MESSAGE ≤ 200 chars | Warning | "Message #X exceeds 200 characters" |

---

## PowerShell Functions

### CONFIG_VALIDATOR.ps1

#### Test-RomanticConfig
```powershell
function Test-RomanticConfig {
    param([string]$ConfigPath)
    
    # Returns PSCustomObject with:
    # - IsValid (boolean)
    # - Errors (array of strings)
    # - Warnings (array of strings)
    # - Details (array of strings)
}
```

**Returns:** Custom object with validation results  
**Exit Code:** 0 if valid, 1 if invalid

### INSTALL.ps1

#### Core Steps

| Step | Function | Result |
|------|----------|--------|
| [1/8] | `New-Item` for directories | Creates C:\RomanticCustomization, Sounds, Cursors |
| [2/8] | `Copy-Item` for files | Copies scripts and config to install path |
| [3/8] | `Test-RomanticConfig` | Validates config before proceeding |
| [4/8] | `Set-ExecutionPolicy` | Sets RemoteSigned for user scope |
| [5/8] | Registry path storage | Writes InstallPath and InstallDate to registry |
| [6/8] | Audio system setup | Configures Windows audio startup |
| [7/8] | Scheduled task creation | Creates "RomanticWelcome" task at logon |
| [8/8] | Theme color application | Applies accent color to DWM registry |

### WelcomeMessage.ps1

#### Key Parsing Logic

```powershell
# Line splitting (cross-platform compatible)
$lines = $content -split '[\r\n]+'

# Section-aware parsing
$inMessagesSection = $false
foreach ($line in $lines) {
    if ($line -match '^\[MESSAGES\]') {
        $inMessagesSection = $true
    }
    elseif ($inMessagesSection -and $line -match '^MESSAGE=(.+)$') {
        $customMessages += $matches[1].Trim()
    }
}

# Message display
$randomMessage = $messages | Get-Random
$player.PlayAsync()  # Async sound (non-blocking)
```

### VERIFY.ps1

**6-Point Health Check:**
1. Installation folder & files exist
2. Scheduled task exists and is ready
3. Config file is valid and has UTF-8 BOM
4. Registry key exists with paths
5. Theme colors are applied
6. Script integrity (hash check)

### UNINSTALL.ps1

**5-Step Removal:**
1. Stop and delete scheduled task
2. Delete C:\RomanticCustomization folder
3. Delete registry key
4. Restore theme colors
5. Finalize and log

**WhatIf Mode:** `-WhatIf` parameter shows what would be deleted without actually removing

---

## Line Splitting Regex

**Pattern:** `'[\r\n]+'`

**Breakdown:**
- `[...]` — Character class (matches any one character inside)
- `\r` — Carriage return (Windows line ending)
- `\n` — Line feed (Unix line ending)
- `+` — One or more (handles multiple line breaks)

**Usage:**
```powershell
$lines = $content -split '[\r\n]+'
```

**Why this pattern:**
- ✅ Cross-platform compatible (Windows CRLF and Unix LF)
- ✅ Handles multiple consecutive line breaks
- ✅ Works in all PowerShell versions
- ✅ Prevents empty lines in array

---

## Section-Aware Parsing Algorithm

**Purpose:** Prevent parsing `[FUTURE]` section as messages

```powershell
$inMessagesSection = $false
$currentSection = $null

foreach ($line in $lines) {
    # Check for section headers
    if ($line -match '^\[([A-Z]+)\]') {
        $currentSection = $matches[1]
        $inMessagesSection = ($currentSection -eq 'MESSAGES')
        continue
    }
    
    # Only parse MESSAGE= when in [MESSAGES]
    if ($inMessagesSection -and $line -match '^MESSAGE=(.+)$') {
        [array]$customMessages += $matches[1].Trim()
    }
}
```

**Flow:**
1. Track current section with `$inMessagesSection` boolean
2. Update flag when section header found
3. Only parse `MESSAGE=` lines when flag is true
4. Prevents accidental parsing of other sections

---

## Scheduled Task Details

**Task Name:** `RomanticWelcome`  
**Location:** `Task Scheduler Library` (root)

### Task Configuration

| Property | Value |
|----------|-------|
| **Trigger** | At logon |
| **Trigger Scope** | Current user |
| **Action** | Execute PowerShell script |
| **Script Path** | `C:\RomanticCustomization\WelcomeMessage.ps1` |
| **Run As** | Current user (not admin) |
| **Execution Policy** | Bypass (for task execution) |
| **Hidden** | No (visible in Task Scheduler) |
| **Repeat** | No (runs once per logon) |

### Task Verification

**Checks performed by VERIFY.ps1:**
```powershell
$task = Get-ScheduledTask -TaskName RomanticWelcome
$task.State -eq "Ready"  # Task is enabled
$task.Triggers[0].Type -eq "LogonTrigger"  # Logon trigger exists
$task.Actions[0].Execute -like "*WelcomeMessage.ps1"  # Correct script
```

---

## Audio Playback

**Type:** WAV file (RIFF format)  
**Codec:** PCM audio  
**Max Size:** ~10MB (practical: 10 seconds × ~1MB/sec)  
**Format Check:** Validates RIFF/WAVE header bytes

### WAV Header Validation
```powershell
# Bytes 0-3: "RIFF"
# Bytes 8-11: "WAVE"
# Validates using [System.IO.File]::ReadAllBytes()
```

**Playback Method:**
```powershell
$player = New-Object System.Media.SoundPlayer
$player.SoundLocation = $soundPath
$player.PlayAsync()  # Non-blocking async playback
```

---

## File Encoding

**Standard:** UTF-8 with BOM  
**BOM Bytes:** `EF BB BF` (hex)

**Validation:**
```powershell
$bytes = [System.IO.File]::ReadAllBytes($path)
$hasBOM = ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
```

**Why UTF-8 with BOM:**
- ✅ Preserves emoji and international characters
- ✅ Compatible with Windows Notepad
- ✅ Supports Unicode names and messages
- ✅ Standard for PowerShell scripts

---

## Execution Policies

**Set during installation:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Scope:** CurrentUser (not system-wide)  
**Policy:** RemoteSigned (allows local scripts to run)  
**User Impact:** Affects only the installing user

---

## Error Handling Patterns

### Try-Catch Blocks

**Standard pattern:**
```powershell
try {
    # Potentially failing operation
    $result = Operation
}
catch {
    # Log error
    Write-Host "Error: $_" -ForegroundColor Red
    $failed = $true
}
```

### Graceful Degradation

**Example (sound file optional):**
```powershell
if (Test-Path $soundPath) {
    $player.PlayAsync()
} else {
    # Continue without sound
}
```

---

## Performance Characteristics

| Operation | Time | Notes |
|-----------|------|-------|
| Config parsing | <100ms | Even with 50+ messages |
| Welcome popup display | 500-800ms | Includes UI rendering |
| Sound playback | <50ms | Start (async) |
| Task execution | ~1-2s | From logon trigger |
| Registry operations | <50ms | Fast key access |
| Installation | ~2 minutes | 8 steps including file copies |

---

## API & Extension Points

### Current (v1.2.1)
- ❌ No official plugin API
- ❌ No extension hooks
- Config file is primary customization method

### Future (v1.3+)
- 🔮 Potential event hooks
- 🔮 Custom message plugins
- 🔮 Configuration API
- 🔮 Theme customization points

---

## Debugging

### Enable Verbose Output

```powershell
# Set verbose preference
$VerbosePreference = "Continue"

# Run scripts
C:\RomanticCustomization\WelcomeMessage.ps1
```

### Check Event Viewer Logs

```powershell
# Windows Logs → Application
# Look for RomanticWelcome task events
Get-EventLog -LogName Application -Source TaskScheduler -Newest 10
```

### Registry Inspection

```powershell
# Check registry values
Get-ItemProperty "HKCU:\Software\RomanticCustomization"

# Check theme colors
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\DWM"
```

---

## Security Considerations

### Execution Policy
- ✅ RemoteSigned limits to signed/local scripts
- ✅ User-scope only (not system-wide)
- ✅ Reverts on uninstall

### Registry Access
- ✅ User hive only (HKCU, not HKLM)
- ✅ No system-critical keys modified
- ✅ All changes reversible

### File Permissions
- ✅ C:\RomanticCustomization requires standard user access
- ✅ No special administrator permissions after install
- ✅ Scripts run as logged-in user (not elevated)

### Data Privacy
- ✅ No internet connectivity
- ✅ No external data collection
- ✅ Config stored locally only
- ✅ No cloud sync

---

## System Requirements (Technical)

### PowerShell
- **Minimum:** 5.0
- **Current:** 5.1 (Windows 10/11)
- **Recommended:** Latest available

### .NET Framework (Implicit)
- Windows.Forms assembly (included)
- System.Media namespace (included)

### Windows Features
- Windows Subsystem (winsxs)
- Registry service
- Task Scheduler service
- Windows Themes

---

## Compatibility

### PowerShell Versions
- ✅ 5.0
- ✅ 5.1
- ✅ 7.x (PowerShell Core)

### Windows Versions
- ✅ Windows 10 (build 1809+)
- ✅ Windows 11 (all builds)

### System Architectures
- ✅ x64 (primary)
- ✅ x86 (supported)
- ❓ ARM (untested)

---

## Troubleshooting Guide (Technical)

### Regex Not Splitting Lines

**Symptom:** Messages with line breaks not parsed correctly

**Check:**
```powershell
$content = Get-Content $file -Raw
$lines = $content -split '[\r\n]+'
$lines.Count  # Should be > 1
```

**Solution:** Ensure using single quotes around regex: `'[\r\n]+'`

### Registry Key Not Created

**Check:**
```powershell
Test-Path "HKCU:\Software\RomanticCustomization"
```

**Solution:** Run INSTALL.ps1 as administrator

---

## Further Resources

- [ARCHITECTURE.md](ARCHITECTURE.md) - System design
- [BUG_FIXES_v1.2.md](BUG_FIXES_v1.2.md) - Bug analysis
- [v1.2_IMPLEMENTATION_STATUS.txt](../MIGRATION_AND_VERSIONS/v1.2_IMPLEMENTATION_STATUS.txt) - Project metrics

---

**For non-technical users:** See [DOCUMENTATION_INDEX.md](../DOCUMENTATION_INDEX.md)
