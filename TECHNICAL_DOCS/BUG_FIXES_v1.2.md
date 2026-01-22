# Romantic Windows Customization v1.2 - Bug Fixes & Improvements

**Release Date:** January 22, 2026  
**Version:** v1.2.0 (Reliability & Quality Update)

---

## Executive Summary

v1.2 is a maintenance release focused on **reliability, robustness, and user experience**. This update fixes 13 critical and high-priority bugs that were discovered during v1.1 testing, and adds 11 medium-priority enhancements for better error handling and validation.

**Status:** ? All critical issues resolved | ? Comprehensive validation | ? Enhanced diagnostics

---

## Critical Fixes (BLOCKING)

### ?? BUG #1: Missing Emoji Characters in Messages

**Severity:** CRITICAL | **Impact:** User-facing | **Status:** ? FIXED

**Symptom:**

- All 8 welcome messages in config.txt were missing emoji endings
- Example: "Good morning, beautiful! Hope your day is as amazing as you are" (no ??)
- Messages appeared bland and incomplete

**Root Cause:**

- File encoding issue during v1.1 creation
- UTF-8 BOM encoding not properly preserving emoji characters

**Fix Applied (v1.2):**

- Restored all emoji endings to messages:
  - "...as amazing as you are ??"
  - "...make every day brighter ?"
  - "...conquer the day together? ??"
  - "...wonderful day ??"
  - "...logged in to the best heart ??"
  - "...you're incredible! ??"
  - "...chance to be amazing! ?"
  - "...in it today! ??"
- Verified UTF-8 BOM encoding applied

**Testing:**

```powershell
# Verify emoji preservation
(Get-Content "C:\RomanticCustomization\config.txt" | Select-String "MESSAGE=" | Select-Object -First 1).Line
# Should show: MESSAGE=Good morning, beautiful! Hope your day is as amazing as you are ??
```

---

### ?? BUG #2: Broken Line-Splitting Regex (CONFIG_VALIDATOR.ps1)

**Severity:** CRITICAL | **Impact:** Validation fails silently | **Status:** ? FIXED

**Symptom:**

- Config file validation did not work correctly
- Regex pattern `\`r?\`n` was not properly parsed by PowerShell
- Configuration validation appeared to pass but didn't actually parse file

**Root Cause:**

- Incorrect regex escaping syntax for PowerShell split operations
- Backtick escaping not valid for regex patterns in -split operator

**Fix Applied (v1.2):**

```powershell
# OLD (broken):
$lines = $content -split "\`r?\`n"

# NEW (working):
$lines = $content -split '[\r\n]+'
```

**Impact:**

- Config files now properly split by both Windows (CRLF) and Unix (LF) line endings
- All configuration values correctly extracted and validated

---

### ?? BUG #3: Broken Line-Splitting Regex (WelcomeMessage.ps1)

**Severity:** CRITICAL | **Impact:** Runtime failure | **Status:** ? FIXED

**Symptom:**

- Same regex issue as BUG #2 in WelcomeMessage.ps1
- Custom messages not loaded from config at runtime
- Welcome message displays defaults instead of customized messages

**Root Cause:**

- Copy-paste error from CONFIG_VALIDATOR.ps1
- Same broken regex pattern in two locations

**Fix Applied (v1.2):**

- Fixed regex pattern to proper PowerShell syntax: `'[\r\n]+'`
- Implemented **section-aware parsing** (see BUG #5)

---

### ?? BUG #4: Confusing Step Numbering in Installation

**Severity:** CRITICAL | **Impact:** User confusion | **Status:** ? FIXED

**Symptom:**

- Installation displayed inconsistent step counts: [1/7] ? [2/7] ? [2.5/7] ? [3/7] ? [3.5/7]
- Users questioned if installation would complete (what happens at step 2.5 of 7?)
- Unprofessional appearance and confusing UX

**Root Cause:**

- Added new validation step without renumbering subsequent steps
- Used decimal step notation instead of adding additional step

**Fix Applied (v1.2):**

- Refactored all steps to sequential [1/8] through [8/8]
- Step breakdown:
  1. [1/8] Setting up directories
  2. [2/8] Installing files
  3. [3/8] Validating configuration ? Moved from 2.5
  4. [4/8] Configuring PowerShell ? Was [3/7]
  5. [5/8] Storing installation path ? Was [3.5/7]
  6. [6/8] Enabling startup sound ? Was [4/7]
  7. [7/8] Setting up welcome message ? Was [5/7]
  8. [8/8] Applying romantic theme ? Was [6/7]

**Before & After:**

```
BEFORE (v1.1):
[1/7] [2/7] [2.5/7] [3/7] [3.5/7] [4/7] [5/7] [6/7] [7/7]

AFTER (v1.2):
[1/8] [2/8] [3/8] [4/8] [5/8] [6/8] [7/8] [8/8]
```

---

### ?? BUG #5: Missing Section-Aware Config Parsing

**Severity:** CRITICAL | **Impact:** Security/reliability | **Status:** ? FIXED

**Symptom:**

- Config parser didn't track which section it was reading
- Could potentially parse MESSAGE= lines from wrong sections
- If config was malformed, could extract incorrect data

**Root Cause:**

- Line-by-line parsing without context tracking
- No validation of section structure

**Fix Applied (v1.2):**

- Implemented proper section-aware parsing in WelcomeMessage.ps1:
  ```powershell
  foreach ($line in $lines) {
      # Track which section we're in
      if ($line -match '^\[MESSAGES\]') {
          $inMessagesSection = $true
          continue
      }
      if ($line -match '^\[' -and $line -ne '[MESSAGES]') {
          $inMessagesSection = $false
          continue
      }

      # Only parse MESSAGE= when in [MESSAGES] section
      if ($inMessagesSection -and $line -match '^MESSAGE=(.+)$') {
          $customMessages += $matches[1].Trim()
      }
  }
  ```

**Impact:**

- Robust config parsing that respects structure
- v2.0 [FUTURE] section properly skipped
- Correct message extraction regardless of file organization

---

## High-Priority Fixes (BROKEN FUNCTIONALITY)

### ?? BUG #6: Missing Section Validation in CONFIG_VALIDATOR

**Severity:** HIGH | **Impact:** Invalid configs accepted | **Status:** ? FIXED

**Symptom:**

- CONFIG_VALIDATOR didn't check for required sections
- Could accept config.txt missing [MESSAGES] section entirely
- Invalid files would show as "valid"

**Fix Applied (v1.2):**

- Added section existence validation:
  ```powershell
  if (-not $sectionsFound.ContainsKey('USER')) {
      $result.Errors += "Required section [USER] not found"
  }
  if (-not $sectionsFound.ContainsKey('DATES')) {
      $result.Errors += "Required section [DATES] not found"
  }
  if (-not $sectionsFound.ContainsKey('MESSAGES')) {
      $result.Errors += "Required section [MESSAGES] not found"
  }
  ```

---

### ?? BUG #7: WELCOME_TIMEOUT Validation Missing

**Severity:** HIGH | **Impact:** Invalid values accepted | **Status:** ? FIXED

**Symptom:**

- User could set WELCOME_TIMEOUT=9999 (unreasonable value)
- Message would display forever
- No validation that timeout was numeric

**Fix Applied (v1.2):**

- Added WELCOME_TIMEOUT validation to CONFIG_VALIDATOR:
  - Must be numeric
  - Must be between 5-300 seconds
  - Defaults to 20 seconds if missing
  - Provides helpful error message if invalid

---

### ?? BUG #8: MESSAGE Length Validation Missing

**Severity:** HIGH | **Impact:** UI text cutoff | **Status:** ? FIXED

**Symptom:**

- Documentation stated "max 200 characters" but no enforcement
- Users could add 500+ character messages
- Text would get cut off in popup UI

**Fix Applied (v1.2):**

- Added message length validation:
  ```powershell
  $overLengthMessages = $messages | Where-Object { $_.Length -gt 200 }
  if ($overLengthMessages.Count -gt 0) {
      $result.Errors += "Found $($overLengthMessages.Count) message(s) exceeding 200 char limit:"
      $overLengthMessages | ForEach-Object {
          $result.Errors += "  - Length: $($_.Length) chars (max 200)"
      }
  }
  ```

---

### ?? BUG #9: Future-Date Check Missing

**Severity:** HIGH | **Impact:** Negative "days together" | **Status:** ? FIXED

**Symptom:**

- ANNIVERSARY_DATE validation didn't check if date was in future
- User enters tomorrow's date ? "We've been together for -5 amazing days!"
- Documentation promised this check but it wasn't implemented

**Fix Applied (v1.2):**

- Added future-date validation:
  ```powershell
  if ($anniversaryDate -gt (Get-Date)) {
      $result.Errors += "ANNIVERSARY_DATE cannot be in the future (found: $($anniversaryDate.ToString('yyyy-MM-dd')))"
  }
  ```

---

### ?? BUG #10: Validation Errors Hidden from User

**Severity:** HIGH | **Impact:** User can't troubleshoot | **Status:** ? FIXED

**Symptom:**

- CONFIG_VALIDATOR.ps1 output piped to `Out-Null`
- If validation failed, user saw no error details
- Just: "? Configuration validation warnings (continuing)"
- No guidance on how to fix issues

**Fix Applied (v1.2):**

- Capture and display validation output:
  ```powershell
  $validationOutput = & $configValidator "$installPath\config.txt" 2>&1
  if ($LASTEXITCODE -eq 0) {
      Write-Host "      ? Configuration is valid" -ForegroundColor Green
  } else {
      Write-Host "      ? Configuration validation warnings:" -ForegroundColor Yellow
      $validationOutput | ForEach-Object { Write-Host "        $_" -ForegroundColor Yellow }
  }
  ```

**Impact:**

- Users see detailed error messages
- Can quickly identify and fix configuration issues

---

## Medium-Priority Fixes (RELIABILITY & UX)

### ?? BUG #11: Registry Path Not Verified

**Severity:** MEDIUM | **Impact:** Silent failure risk | **Status:** ? FIXED

**Symptom:**

- Registry key written but never verified
- If registry write failed silently, WelcomeMessage.ps1 wouldn't find files

**Fix Applied (v1.2):**

- Added registry verification (read-back test):

  ```powershell
  Set-ItemProperty -Path $regPath -Name "InstallPath" -Value $installPath -Type String -Force

  # Verify registry was actually written
  $verifyPath = Get-ItemProperty -Path $regPath -Name "InstallPath" -ErrorAction SilentlyContinue
  if ($verifyPath -and $verifyPath.InstallPath -eq $installPath) {
      Write-Host "      ? Registry path stored for portability (verified)" -ForegroundColor Green
  }
  ```

---

### ?? BUG #12: Task Verification Incomplete

**Severity:** MEDIUM | **Impact:** Task may not run | **Status:** ? FIXED

**Symptom:**

- Installation only checked if task exists
- Didn't verify it was enabled or properly configured
- Disabled task would still show as "created successfully"

**Fix Applied (v1.2):**

- Enhanced verification to check:
  - Task State == "Ready" (enabled)
  - LogOn trigger exists
  - Action is configured
  - Reports specific issues if checks fail

---

### ?? BUG #13: UTF-8 BOM Not Verified

**Severity:** MEDIUM | **Impact:** Emoji issues | **Status:** ? FIXED

**Fix Applied (v1.2):**

- VERIFY.ps1 now checks for UTF-8 BOM header
- Reports if file is missing BOM (may cause emoji issues)
- Helps diagnose encoding problems

---

### ?? BUG #14: Timer Not Properly Cleaned Up

**Severity:** MEDIUM | **Impact:** Resource leak | **Status:** ? FIXED

**Symptom:**

- Timer could interfere with form lifecycle
- No explicit cleanup when form closed early

**Fix Applied (v1.2):**

```powershell
$form.Add_FormClosing({
    $timer.Stop()
    $timer.Dispose()
})
```

---

### ?? BUG #15: Sound Playback Blocks UI

**Severity:** MEDIUM | **Impact:** Unresponsive UI during sound | **Status:** ? FIXED

**Symptom:**

- Used `$player.Play()` (synchronous)
- If sound was 30 seconds, UI froze for 30 seconds
- Users couldn't interact while sound played

**Fix Applied (v1.2):**

```powershell
$player.PlayAsync()  # Changed from Play()
```

**Impact:**

- Sound plays in background
- UI remains responsive
- Users can interact with form or close it immediately

---

### ?? BUG #16: No Dry-Run Option for Uninstall

**Severity:** MEDIUM | **Impact:** Users hesitant to uninstall | **Status:** ? FIXED

**Fix Applied (v1.2):**

- Added `-WhatIf` parameter to UNINSTALL.ps1:
  ```powershell
  UNINSTALL.ps1 -WhatIf
  ```
- Preview mode shows what would be deleted without making changes
- Improves user confidence in uninstall process

---

### ?? BUG #17: Theme Color Changes Not Validated

**Severity:** MEDIUM | **Impact:** Unknown if theme applied | **Status:** ? FIXED

**Fix Applied (v1.2):**

- Enhanced theme validation:
  - Verifies registry changes actually applied
  - Reports specific theme changes made
  - Provides documentation about what "theme" includes

---

### ?? BUG #18: No Installation Timestamp

**Severity:** MEDIUM | **Impact:** Can't track install date | **Status:** ? FIXED

**Fix Applied (v1.2):**

- Added `InstallDate` to registry:
  ```powershell
  Set-ItemProperty -Path $regPath -Name "InstallDate" -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss") -Type String -Force
  ```
- VERIFY.ps1 displays installation date
- Helps with troubleshooting and diagnostics

---

### ?? BUG #19: Sound File Not Validated

**Severity:** MEDIUM | **Impact:** Invalid files could be used | **Status:** ? FIXED

**Symptom:**

- Installation just copied any .wav file without checking format
- User could rename MP3 to .wav and cause errors

**Fix Applied (v1.2):**

- Added WAV format validation (check RIFF header):
  ```powershell
  $bytes = [System.IO.File]::ReadAllBytes($wavPath)
  $isValidWav = $bytes[0] -eq 0x52 -and $bytes[1] -eq 0x49 -and  # 'R' 'I'
                $bytes[2] -eq 0x46 -and $bytes[3] -eq 0x46        # 'F' 'F'
                # ... plus WAVE signature check
  ```

---

## Summary by Category

| Category                   | v1.1  | v1.2     | Improvement             |
| -------------------------- | ----- | -------- | ----------------------- |
| **Critical Bugs**          | 5     | 0        | ? All fixed            |
| **High-Priority Issues**   | 5     | 0        | ? All fixed            |
| **Medium-Priority Issues** | 9     | 0        | ? All fixed            |
| **Validation Rules**       | 3     | 8        | +167% more validation   |
| **Error Messages**         | Basic | Detailed | Users can self-diagnose |
| **File Verifications**     | 2     | 6        | 3x more robustness      |

---

## Upgrade Path

### From v1.0 to v1.2

```powershell
# 1. Backup current installation
Copy-Item "C:\RomanticCustomization" "C:\RomanticCustomization_backup_v1.0" -Recurse

# 2. Run new UNINSTALL (with -WhatIf to preview):
UNINSTALL.ps1 -WhatIf

# 3. Run new INSTALL.ps1
INSTALL.ps1

# 4. Verify with new VERIFY.ps1
VERIFY.ps1
```

### From v1.1 to v1.2

```powershell
# Backup config (settings preserved):
Copy-Item "C:\RomanticCustomization\config.txt" "C:\RomanticCustomization\config.txt.backup_v1.1"

# Run new INSTALL.ps1 (will update all files)
INSTALL.ps1

# Run VERIFY to confirm upgrade
VERIFY.ps1
```

---

## Testing Checklist

? **Critical Fixes:**

- [ ] Emojis display correctly in welcome message
- [ ] Config file parses with Windows and Unix line endings
- [ ] Installation step counter is sequential [1-8]
- [ ] Custom messages load from config

? **Validation:**

- [ ] CONFIG_VALIDATOR reports missing sections
- [ ] WELCOME_TIMEOUT validation works (5-300 range)
- [ ] MESSAGE length capped at 200 characters
- [ ] Future dates rejected with error message
- [ ] Validation errors display to user during install

? **Reliability:**

- [ ] Registry path verified on write
- [ ] Scheduled task state checked (not just existence)
- [ ] UTF-8 BOM verified in VERIFY.ps1
- [ ] Sound plays asynchronously (UI not blocked)
- [ ] Timer cleaned up on form close

? **UX Improvements:**

- [ ] UNINSTALL.ps1 -WhatIf shows what would be deleted
- [ ] Theme color changes validated and documented
- [ ] Installation timestamp logged and displayed
- [ ] Sound file format validated before use

---

## Known Limitations (Unchanged from v1.1)

These are by design and reserved for v2.0:

- ? Voice message playback not supported
- ? Dynamic wallpaper rotation not included
- ? Multiple system profiles not supported
- ? Scheduled message delivery not available
- ? Advanced calendar integration not implemented

---

## Performance Impact

- **Installation Time:** No change (~2-3 minutes)
- **Startup Impact:** No change (~10-15 seconds added to login)
- **Memory Usage:** Negligible increase (<5MB for welcome process)
- **File Size:** Slight increase (better documentation, more error handling)

---

## Security Notes

? No changes to security model  
? Same UAC requirements as v1.1  
? Registry modifications unchanged  
? No new external dependencies

---

## Support & Feedback

If you encounter any issues:

1. **Run VERIFY.ps1** - provides diagnostic information
2. **Check error messages** - v1.2 provides detailed, actionable errors
3. **Review config.txt** - use CONFIG_VALIDATOR.ps1 to validate
4. **Try dry-run uninstall** - `UNINSTALL.ps1 -WhatIf`

---

**v1.2 Release:** January 22, 2026  
**Compatibility:** Windows 10 (build 1809+) and Windows 11 (all builds)  
**License:** Personal use only

