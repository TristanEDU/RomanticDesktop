# Frequently Asked Questions (FAQ)

## Installation & Setup

### Q1: Can I install this on a USB drive or external location?

**A:** Yes! v1.1+ features **portable installation** via registry path storage.

**Default location:** `C:\RomanticCustomization`  
**To use different location:**

1. Edit `INSTALL.ps1` line ~94: `$installPath = "C:\RomanticCustomization"`
2. Change to your preferred path (e.g., `E:\RomanticCustomization` for USB)
3. Run INSTALL.ps1
4. The path is stored in registry for portability

**Registry key:** `HKCU:\Software\RomanticCustomization\InstallPath`

---

### Q2: Can I install on multiple computers?

**A:** Yes, but each computer needs individual installation.

**Process:**

1. Copy the entire package folder to each computer
2. Run `INSTALL.ps1` on each computer
3. Each installation maintains separate registry entries
4. Settings stored in `config.txt` can be customized per computer

**Note:** Multi-user on single computer is **not** supported (see Q12).

---

### Q3: What are the system requirements?

**A:** Minimum requirements:

| Requirement     | Version                                        |
| --------------- | ---------------------------------------------- |
| **OS**          | Windows 10 (build 1809+) or Windows 11         |
| **PowerShell**  | 5.0+ (included by default)                     |
| **Disk Space**  | ~50MB (mostly for optional sound/cursor files) |
| **RAM**         | 512MB minimum (3GB+ recommended)               |
| **Permissions** | Administrator required for installation        |

**Tested on:**

- Windows 10 (builds 1909-22H2)
- Windows 11 (all current builds)

---

### Q4: Do I need .NET Framework installed?

**A:** No. The installation uses PowerShell's built-in Windows.Forms (requires .NET, but Windows has this built-in).

---

## Configuration

### Q5: Can I use Unicode or non-English names?

**A:** Yes! v1.1 supports international characters.

**Support:**

- ? Japanese: ??? ????
- ? Arabic: ?????
- ? Chinese: ??
- ? Russian: ???
- ? Emoji: ??

**Requirements:**

- config.txt must use UTF-8 BOM encoding
- Maximum length: 100 characters

**How to create UTF-8 file in PowerShell:**

```powershell
$content = @"
[USER]
HER_NAME=?? ???
WELCOME_TIMEOUT=20

[DATES]
ANNIVERSARY_DATE=2024-01-06

[MESSAGES]
MESSAGE=?????????????!

[FUTURE]
"@

[System.IO.File]::WriteAllText("C:\path\to\config.txt", $content, [System.Text.Encoding]::UTF8)
```

---

### Q6: Can I have more than 8 messages?

**A:** Yes! Add as many as you want.

**How to add messages:**

1. Open `C:\RomanticCustomization\config.txt` in Notepad (or UTF-8 capable editor)
2. In the `[MESSAGES]` section, add lines:
   ```
   MESSAGE=Your first message with emoji ??
   MESSAGE=Second message ?
   MESSAGE=Third message ??
   ```
3. One message per line (no empty lines)
4. Max 200 characters per message

**System randomly selects one message each login.**

---

### Q7: What format should the anniversary date be in?

**A:** ISO 8601 format: **YYYY-MM-DD**

**Examples:**

- ? 2024-01-06 (January 6, 2024)
- ? 2023-12-25 (December 25, 2023)
- ? 01/06/2024 (wrong format)
- ? 2024-1-6 (missing leading zero)

**Validation:**

- Cannot be in the future (v1.2+)
- Cannot be too far in past (no validation, but "days together" would be huge)

---

### Q8: What if I lose the config.txt file?

**A:** The installation will fail. Here's how to recover:

**Option 1 - Restore from backup:**

```powershell
# If you kept a backup:
Copy-Item "C:\RomanticCustomization\config.txt.backup" "C:\RomanticCustomization\config.txt"
```

**Option 2 - Recreate config.txt:**

1. Use the template from the package: `config.txt` (v1.1 format)
2. Edit with your information
3. Save as UTF-8 BOM encoding

**Option 3 - Reinstall:**

```powershell
UNINSTALL.ps1  # Remove old installation
INSTALL.ps1    # Fresh install with new config
```

---

## Troubleshooting

### Q9: The welcome message doesn't appear at login

**A:** This is the most common issue. Troubleshooting steps:

**Step 1: Check if scheduled task exists**

```powershell
Get-ScheduledTask -TaskName "RomanticWelcome"
# Should show task details
```

**Step 2: Run VERIFY.ps1 for diagnostics**

```powershell
C:\RomanticCustomization\VERIFY.ps1
# Shows detailed status of all components
```

**Step 3: Try running the script manually**

```powershell
C:\RomanticCustomization\WelcomeMessage.ps1
# Should display the form immediately
```

**Step 4: Check execution policy**

```powershell
Get-ExecutionPolicy -Scope CurrentUser
# Should be "RemoteSigned" or higher
```

**Step 5: Check Task Scheduler configuration**

1. Open Task Scheduler (`tasksched.msc`)
2. Look for "RomanticWelcome" under Tasks
3. Check:
   - Status: Should be "Ready"
   - Trigger: Should be "AtLogOn"
   - Action: Should point to `C:\RomanticCustomization\WelcomeMessage.ps1`

---

### Q10: "Access Denied" or permission errors during installation

**A:** Installation requires Administrator privileges.

**Solution:**

1. Right-click `INSTALL.ps1`
2. Select "Run with PowerShell"
3. Click "Yes" when UAC prompt appears

**Alternative method:**

```powershell
# Open PowerShell as Administrator
# Then run:
C:\path\to\INSTALL.ps1
```

---

### Q11: Antivirus is blocking the installation

**A:** PowerShell scripts may be flagged as suspicious.

**Solutions:**

**Option 1: Add to exclusion list**

- Windows Defender: Settings ? Virus & threat protection ? Manage settings ? Add exclusions
- Add: `C:\RomanticCustomization`
- Add: The installation folder containing scripts

**Option 2: Install with different execution policy**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

**Option 3: Contact your antivirus vendor**

- Report false positive
- Provide: INSTALL.ps1, WelcomeMessage.ps1, CONFIG_VALIDATOR.ps1 hashes

---

## Multi-User Systems

### Q12: Can multiple users share one installation?

**A:** Partially. Here's the situation:

| Feature                  | Works?     | Notes                                                                     |
| ------------------------ | ---------- | ------------------------------------------------------------------------- |
| Share executable files   | ? Yes     | All users can use same scripts                                            |
| Share config.txt         | ?? Partial | Messages shared, but name customization per-user requires separate config |
| Per-user welcome message | ? No      | v2.0 feature                                                              |
| Per-user scheduled task  | ? Yes     | Each user must run INSTALL separately                                     |

**Recommended setup for multi-user:**

1. Install once per user (each user runs INSTALL.ps1)
2. Customize config.txt in each user's profile
3. Each user gets personalized welcome message

**Alternative (shared configuration):**

1. One user installs and customizes
2. Share `config.txt` to other users
3. Other users use shared configuration

---

### Q13: My partner wants their own welcome message

**A:** v1.1 doesn't support per-user messages (v2.0 feature).

**Workaround:**

1. Create two config files: `config_her.txt` and `config_his.txt`
2. Swap config.txt before each login
3. Or create separate installations on separate user accounts

**Better solution (coming in v2.0):**

- Automatic per-user message selection
- Stored securely in user registry hive
- No manual swapping needed

---

## Sounds & Customization

### Q14: How do I add a custom sound?

**A:** Install a valid WAV file.

**Process:**

1. Prepare a `.wav` file (v1.2+ validates WAV format)
2. Name it exactly: `romantic.wav`
3. Place in the same folder as INSTALL.ps1
4. Run INSTALL.ps1
5. Sound will be copied to `C:\RomanticCustomization\Sounds\`

**Sound specifications:**

- Format: WAV (Waveform Audio File)
- Sample rate: 44.1kHz or 48kHz recommended
- Duration: 5-30 seconds optimal
- Size: <5MB recommended

**Where to find sounds:**

- Freesound.org
- Zapsplat.com
- Pixabay Music (some)
- YouTube Audio Library

---

### Q15: Sound file is not playing

**A:** Check the following:

**Step 1: File exists**

```powershell
Test-Path "C:\RomanticCustomization\Sounds\romantic.wav"
# Should return: True
```

**Step 2: File is valid WAV**

```powershell
# Should start with "RIFF" signature
[System.Text.Encoding]::Default.GetString([System.IO.File]::ReadAllBytes("C:\RomanticCustomization\Sounds\romantic.wav")[0..3])
```

**Step 3: Windows sound is enabled**

- Settings ? System ? Sound ? Volume slider
- Should not be muted
- Volume should be >0%

**Step 4: Startup sound enabled**

```powershell
Get-ItemProperty "HKCU:\AppEvents\Schemes" | Select-Object -Property DisableStartupSound
# Should not be 1 (disabled)
```

---

## Removal & Uninstall

### Q16: How do I uninstall this?

**A:** Use the provided UNINSTALL.ps1 script.

**Safe method (preview first):**

```powershell
# Preview what will be deleted (v1.2+):
C:\RomanticCustomization\UNINSTALL.ps1 -WhatIf

# Actually uninstall:
C:\RomanticCustomization\UNINSTALL.ps1
```

**What gets removed:**

- Scheduled task "RomanticWelcome"
- Folder `C:\RomanticCustomization`
- Registry entries in `HKCU:\Software\RomanticCustomization`
- Theme color modifications (restored to default)

**Manual uninstall (if script fails):**

1. Open Task Scheduler
2. Delete task "RomanticWelcome"
3. Delete folder `C:\RomanticCustomization`
4. Delete registry key: `HKCU:\Software\RomanticCustomization`

---

### Q17: Will uninstalling remove personal files?

**A:** No, uninstall is clean.

**Preserved:**

- ? Windows system files (untouched)
- ? Documents and photos (untouched)
- ? Other applications (untouched)

**Removed only:**

- ? Scheduled task
- ? RomanticCustomization folder
- ? Registry entries we created

---

## Upgrading

### Q18: How do I upgrade from v1.0 to v1.2?

**A:** Safe upgrade process:

**Backup first:**

```powershell
# Keep a copy of your settings
Copy-Item "C:\RomanticCustomization\config.txt" "C:\RomanticCustomization\config.txt.backup_v1.0" -Force
```

**Then upgrade:**

```powershell
# Run new INSTALL.ps1
# It will update all files automatically
C:\path\to\v1.2\INSTALL.ps1

# Verify upgrade
C:\RomanticCustomization\VERIFY.ps1
```

**What happens:**

- Old WelcomeMessage.ps1 updated with bug fixes
- Old config.txt updated with emoji fixes
- New validation tools installed
- Enhanced Task Scheduler settings

**Your customizations:**

- ? Name preserved
- ? Anniversary date preserved
- ? Custom messages preserved
- ? Timeout settings preserved

---

### Q19: Should I uninstall v1.1 before installing v1.2?

**A:** No need! INSTALL.ps1 will:

- Automatically remove old scheduled task
- Overwrite old files with new versions
- Preserve your config.txt

**You can safely just run new INSTALL.ps1.**

---

## Technical Questions

### Q20: What registry keys are modified?

**A:** Installation creates/modifies:

| Key                                                               | Purpose                   | Removable            |
| ----------------------------------------------------------------- | ------------------------- | -------------------- |
| `HKCU:\Software\RomanticCustomization`                            | Installation path storage | Yes (UNINSTALL.ps1)  |
| `HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent` | Accent color (rose gold)  | Yes (UNINSTALL.ps1)  |
| `HKCU:\Software\Microsoft\Windows\DWM`                            | DWM color prevalence      | Yes (manual restore) |
| `HKCU:\AppEvents\Schemes`                                         | Startup sound settings    | Yes (manual restore) |

**Safety:** All keys are user-specific (HKCU), not system-wide (HKLM)

---

### Q21: Does this use external services or internet?

**A:** No. Installation is completely offline.

- ? No internet required
- ? No cloud services
- ? No telemetry
- ? No external dependencies
- ? Runs locally on your machine

---

### Q22: Can I run this on a network drive?

**A:** Not recommended, but possible.

**Issues:**

- Performance may suffer
- Network delays could affect welcome display
- File locking issues possible

**If you must:**

```powershell
# Map network drive first
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\server\share"

# Edit INSTALL.ps1:
$installPath = "Z:\RomanticCustomization"  # Network path

# Run INSTALL.ps1
```

---

## Version History & Updates

### Q23: What's new in v1.2?

**A:** See [BUG_FIXES_v1.2.md](BUG_FIXES_v1.2.md) for complete details.

**Quick summary:**

- ?? 13 critical/high-priority bug fixes
- ??? 11 new validation rules
- ?? Better error messages and diagnostics
- ?? Improved testing and verification
- ?? Enhanced reliability

---

### Q24: When is v2.0 coming?

**A:** No official release date yet.

**Planned features for v2.0:**

- Per-user welcome messages
- Voice message playback
- Dynamic wallpaper rotation
- Calendar event integration
- Advanced scheduling
- Multi-user profile support

---

## Still Have Questions?

**Before asking, try:**

1. Run `VERIFY.ps1` - provides detailed diagnostics
2. Run `CONFIG_VALIDATOR.ps1` - validates your configuration
3. Review error messages - v1.2+ provides detailed, actionable help

**If stuck:**

- Check the [BUG_FIXES_v1.2.md](BUG_FIXES_v1.2.md) for known issues
- Review [README.md](README.md) for feature overview
- Check Windows Event Viewer for scheduled task failures

---

**Last Updated:** January 22, 2026  
**Version:** v1.2.0

