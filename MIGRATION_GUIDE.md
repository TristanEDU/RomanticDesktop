# Migration Guide: Upgrading Romantic Windows Customization

**Current Version:** v1.2.0  
**Last Updated:** January 22, 2026

---

## Quick Upgrade Summary

| Scenario                 | Steps                               | Time  | Data Loss           |
| ------------------------ | ----------------------------------- | ----- | ------------------- |
| **v1.0 → v1.2**          | Backup config, uninstall, install   | 5 min | None\*              |
| **v1.1 → v1.2**          | Run INSTALL.ps1 (auto-upgrade)      | 2 min | None                |
| **Rollback v1.2 → v1.1** | Restore from backup, uninstall v1.2 | 3 min | None (if backed up) |

\*With recommended backup process

---

## Scenario 1: Upgrading from v1.0 to v1.2

### ✅ What You Should Know

- v1.1 and v1.2 introduced new features (registry-based paths)
- Your current config.txt is compatible
- Settings will be preserved

### Step-by-Step Upgrade

**Step 1: Back Up Your Configuration**

```powershell
# Create backup folder
New-Item -Path "C:\Backups" -ItemType Directory -Force | Out-Null

# Backup current installation
Copy-Item "C:\RomanticCustomization" "C:\Backups\RomanticCustomization_v1.0_$(Get-Date -Format 'yyyyMMdd_HHmmss')" -Recurse

# Backup config separately
Copy-Item "C:\RomanticCustomization\config.txt" "C:\Backups\config.txt.backup_v1.0" -Force
```

**Step 2: Run New INSTALL.ps1**

```powershell
# Navigate to v1.2 package folder
cd "C:\path\to\v1.2\package"

# Run installer (will update existing installation)
.\INSTALL.ps1
```

**What happens during upgrade:**

1. Existing scheduled task "RomanticWelcome" removed
2. Old files (WelcomeMessage.ps1, etc.) updated with v1.2 versions
3. config.txt updated with emoji fixes
4. New registry entries created for portability
5. New scheduled task created with v1.2 settings
6. New validation tools installed

**Step 3: Verify the Upgrade**

```powershell
# Run verification tool
C:\RomanticCustomization\VERIFY.ps1

# Should show all checks PASSED
```

**Step 4: Test the Welcome Message**

```powershell
# Log out and back in to test
# OR run manually:
C:\RomanticCustomization\WelcomeMessage.ps1
```

✅ **Upgrade complete!**

---

## Scenario 2: Upgrading from v1.1 to v1.2

### ✅ What You Should Know

- v1.2 is a minor update (bug fixes only, no breaking changes)
- All v1.1 features preserved
- Configuration remains unchanged

### Quick Upgrade (2 minutes)

**Option A: Automatic In-Place Upgrade**

```powershell
# Simply run the new INSTALL.ps1
# It will detect existing installation and upgrade it
.\INSTALL.ps1

# Confirm when prompted
```

**Option B: Controlled Upgrade with Backup**

```powershell
# Step 1: Backup config (as precaution)
Copy-Item "C:\RomanticCustomization\config.txt" "C:\RomanticCustomization\config.txt.backup_v1.1" -Force

# Step 2: Run installer
.\INSTALL.ps1

# Step 3: Verify
C:\RomanticCustomization\VERIFY.ps1
```

**What changes in v1.2:**

- ✅ Bug fixes to emoji handling
- ✅ Enhanced config validation
- ✅ Better error messages
- ✅ Improved reliability
- ✅ No configuration changes needed

**What stays the same:**

- ✅ Your personalized messages
- ✅ Anniversary date
- ✅ Her name
- ✅ Timeout settings
- ✅ Installation location
- ✅ Sound files (if custom)

✅ **Upgrade complete!**

---

## Scenario 3: Fresh Installation on New Computer

### Migration Path: Moving from Old to New Computer

**Step 1: Export Current Settings**

_On old computer:_

```powershell
# Copy the entire installation
Copy-Item "C:\RomanticCustomization" "E:\RomanticCustomization_Export" -Recurse

# Or just the config if sharing settings
Copy-Item "C:\RomanticCustomization\config.txt" "E:\config.txt.export" -Force

# If custom sound
Copy-Item "C:\RomanticCustomization\Sounds\romantic.wav" "E:\romantic.wav" -Force
```

**Step 2: Prepare New Computer**

_On new computer:_

```powershell
# Create folder for package
New-Item -Path "C:\Setup\RomanticDesktop" -ItemType Directory -Force

# Copy v1.2 package files to this folder
# Copy exported config.txt to package folder
Copy-Item "E:\config.txt.export" "C:\Setup\RomanticDesktop\config.txt" -Force

# If custom sound, copy it
Copy-Item "E:\romantic.wav" "C:\Setup\RomanticDesktop\romantic.wav" -Force
```

**Step 3: Install on New Computer**

```powershell
cd "C:\Setup\RomanticDesktop"
.\INSTALL.ps1
```

**Step 4: Verify**

```powershell
C:\RomanticCustomization\VERIFY.ps1
```

✅ **Migration complete!**

---

## Scenario 4: Rollback from v1.2 to v1.1 (If Needed)

### When You Might Need This

- Found issues with v1.2 (unlikely, but possible)
- Need to verify specific bug wasn't introduced by v1.2
- Want to revert to previous version

### Rollback Process

**Step 1: Uninstall v1.2**

```powershell
# First preview what will be deleted
C:\RomanticCustomization\UNINSTALL.ps1 -WhatIf

# Then uninstall
C:\RomanticCustomization\UNINSTALL.ps1
```

**Step 2: Restore from Backup**

```powershell
# If you have backed-up v1.1 installation
Copy-Item "C:\Backups\RomanticCustomization_v1.1_backup" "C:\RomanticCustomization" -Recurse -Force

# Or restore just config
Copy-Item "C:\Backups\config.txt.backup_v1.1" "C:\RomanticCustomization\config.txt" -Force

# Restore sound if you had custom one
Copy-Item "C:\Backups\romantic.wav" "C:\RomanticCustomization\Sounds\romantic.wav" -Force
```

**Step 3: Reinstall Scheduled Task**

```powershell
# If only config was restored, you need to recreate the task:
# Either run v1.1 INSTALL.ps1
# Or manually create the task in Task Scheduler
```

**Step 4: Verify**

```powershell
C:\RomanticCustomization\VERIFY.ps1
```

⚠️ **Rollback complete - Note:** You're now back on v1.1

---

## Scenario 5: Changing Installation Location

### Moving from C:\ to Different Drive

**Step 1: Prepare Target Location**

```powershell
# Example: Moving to E:\
New-Item -Path "E:\RomanticCustomization" -ItemType Directory -Force
```

**Step 2: Copy Current Installation**

```powershell
# Copy everything from C:\ to E:\
Copy-Item "C:\RomanticCustomization\*" "E:\RomanticCustomization\" -Recurse -Force
```

**Step 3: Update Registry**

```powershell
# Update the registry to point to new location
Set-ItemProperty -Path "HKCU:\Software\RomanticCustomization" -Name "InstallPath" -Value "E:\RomanticCustomization" -Type String -Force

# Verify
Get-ItemProperty "HKCU:\Software\RomanticCustomization"
```

**Step 4: Remove Old Location**

```powershell
# After confirming new location works
Remove-Item "C:\RomanticCustomization" -Recurse -Force
```

**Step 5: Test**

```powershell
# Run welcome message to verify it finds files
E:\RomanticCustomization\WelcomeMessage.ps1

# Should work without errors
```

✅ **Location migration complete!**

---

## Scenario 6: Updating Configuration (Name/Date/Messages)

### Keeping Installation, Changing Settings

**Step 1: Edit Configuration**

```powershell
# Open config file (UTF-8 capable editor)
notepad "C:\RomanticCustomization\config.txt"

# OR use PowerShell ISE (better UTF-8 support)
ise "C:\RomanticCustomization\config.txt"
```

**Step 2: Make Changes**

```ini
[USER]
HER_NAME=New Name Here
WELCOME_TIMEOUT=25

[DATES]
ANNIVERSARY_DATE=2024-06-15

[MESSAGES]
MESSAGE=Your new message with emoji ❤️
MESSAGE=Another new message ✨
```

**Step 3: Validate**

```powershell
# Validate new config
C:\RomanticCustomization\CONFIG_VALIDATOR.ps1

# Should show: Status: PASSED
```

**Step 4: Test**

```powershell
# Run welcome message to see changes
C:\RomanticCustomization\WelcomeMessage.ps1
```

✅ **Configuration update complete!**

---

## Scenario 7: Clean Install (Start Fresh)

### When You Want to Start Completely Over

**Step 1: Backup Current (Optional but Recommended)**

```powershell
# If you want to keep a copy for reference
Copy-Item "C:\RomanticCustomization\config.txt" "C:\Backups\config.txt.last_version" -Force
```

**Step 2: Complete Removal**

```powershell
# Preview what will be deleted
C:\RomanticCustomization\UNINSTALL.ps1 -WhatIf

# Actually uninstall
C:\RomanticCustomization\UNINSTALL.ps1

# Verify it's gone
Test-Path "C:\RomanticCustomization"  # Should return: False
```

**Step 3: Fresh Install**

```powershript
# Start with clean v1.2 package
cd "C:\path\to\v1.2\package"

# Edit config.txt with fresh settings
notepad "config.txt"

# Install
.\INSTALL.ps1
```

**Step 4: Verify**

```powershell
C:\RomanticCustomization\VERIFY.ps1
```

✅ **Fresh installation complete!**

---

## Troubleshooting Migration Issues

### Issue: "Installation folder not found"

**Solution:**

```powershell
# Create it manually
New-Item -Path "C:\RomanticCustomization" -ItemType Directory -Force
```

### Issue: "Registry entry not updated"

**Solution:**

```powershell
# Manually create/update registry
$regPath = "HKCU:\Software\RomanticCustomization"
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name "InstallPath" -Value "C:\RomanticCustomization" -Type String -Force
```

### Issue: "Scheduled task didn't migrate"

**Solution:**

```powershell
# Manually re-create by running INSTALL.ps1
# OR manually create in Task Scheduler:
# 1. Open Task Scheduler
# 2. Create new task with these settings:
#    - Name: RomanticWelcome
#    - Trigger: AtLogOn (user-specific)
#    - Action: powershell.exe -File "C:\RomanticCustomization\WelcomeMessage.ps1"
#    - Run with highest privileges
```

### Issue: "Config.txt encoding wrong"

**Solution:**

```powershell
# Re-save with proper UTF-8 BOM
$content = Get-Content "C:\RomanticCustomization\config.txt" -Raw
$encoding = [System.Text.UTF8Encoding]::new($true)  # $true = with BOM
[System.IO.File]::WriteAllText("C:\RomanticCustomization\config.txt", $content, $encoding)
```

---

## Before/After Checklist

### Before Starting Migration

- [ ] Back up current config.txt
- [ ] Note your personalized settings
- [ ] Have v1.2 package files ready
- [ ] Ensure administrator access
- [ ] Know your installation path

### After Completing Migration

- [ ] Run VERIFY.ps1 successfully
- [ ] Test welcome message manually
- [ ] Log out and back in to test auto-display
- [ ] Confirm all personalization preserved
- [ ] Check for any error messages

---

## Version Compatibility Matrix

| From → To   | Supported   | Method                     | Difficulty |
| ----------- | ----------- | -------------------------- | ---------- |
| v1.0 → v1.1 | ✅ Yes      | Uninstall + Install        | Easy       |
| v1.0 → v1.2 | ✅ Yes      | Uninstall + Install        | Easy       |
| v1.1 → v1.2 | ✅ Yes      | Run new INSTALL.ps1        | Very Easy  |
| v1.2 → v1.1 | ⚠️ Possible | Restore backup + Uninstall | Medium     |
| v1.2 → v1.0 | ⚠️ Possible | Restore backup + Uninstall | Medium     |

---

## Keeping Multiple Versions

### If You Want to Keep v1.1 and v1.2

**Do NOT do this** - can cause conflicts.

**Instead, use separate computers or VMs.**

OR

**Keep backups in safe locations:**

```powershell
# Create version archive
$versions = @{
    "v1.0" = "C:\Backups\Versions\RomanticCustomization_v1.0"
    "v1.1" = "C:\Backups\Versions\RomanticCustomization_v1.1"
    "v1.2" = "C:\Backups\Versions\RomanticCustomization_v1.2"
}

# When you need a specific version, restore from backup
```

---

## Support During Migration

**If something goes wrong:**

1. **Check error messages** - v1.2 has detailed diagnostics
2. **Run VERIFY.ps1** - provides comprehensive status
3. **Run CONFIG_VALIDATOR.ps1** - validates configuration
4. **Check Task Scheduler** - ensure task is configured correctly
5. **Review event logs** - Windows logs failed task executions

---

## FAQ About Migration

**Q: Will I lose my custom messages?**  
A: No - they're stored in config.txt, which is preserved during upgrade.

**Q: Do I need to edit anything?**  
A: No - configuration is backward compatible. You can edit if you want.

**Q: What if something breaks?**  
A: Rollback using your backup, or reinstall from scratch.

**Q: How long does upgrade take?**  
A: v1.1 → v1.2: ~2 minutes  
 v1.0 → v1.2: ~5 minutes (with backup/uninstall/install)

---

**Last Updated:** January 22, 2026  
**Version:** v1.2.0
