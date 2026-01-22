# 🗑️ Uninstall Guide - Safe Removal

**Version:** v1.2.1 | **Time Required:** ~3 minutes | **Difficulty:** Easy

Complete guide to cleanly remove Romantic Windows Customization.

---

## Before You Uninstall

### ✅ What Gets Removed?

- ❌ `C:\RomanticCustomization\` folder (entire directory)
- ❌ Scheduled task: "RomanticWelcome"
- ❌ Registry key: `HKCU:\Software\RomanticCustomization`
- ❌ PowerShell execution policy changes (reverted)
- ❌ Windows theme colors (reset to defaults)

### ✅ What Gets Preserved?

- ✅ No system files damaged
- ✅ No permanent registry changes
- ✅ No boot sector modifications
- ✅ Can reinstall anytime with no issues
- ✅ No data loss

---

## Method 1: Safe Uninstall with Preview (Recommended)

This method shows you exactly what will be deleted **before** anything is removed.

### Step 1: Open PowerShell

1. Search "PowerShell" in Start menu
2. Right-click → **Run as Administrator**
3. Click **Yes** when prompted

### Step 2: Run Uninstaller with Preview

In PowerShell, run:

```powershell
C:\RomanticCustomization\UNINSTALL.ps1 -WhatIf
```

This shows **[DRY RUN MODE]** with:

- What would be deleted
- What would be removed from registry
- What would be reverted

**Review the output carefully.**

### Step 3: Run Actual Uninstall

If everything looks correct, run **without** the `-WhatIf`:

```powershell
C:\RomanticCustomization\UNINSTALL.ps1
```

You'll be asked: **"Continue with uninstall? (Y/N)"**

Type `Y` and press Enter.

### Step 4: Confirm Removal

You'll see:

```
[1/5] Removing scheduled task...
[2/5] Removing C:\RomanticCustomization...
[3/5] Removing registry entries...
[4/5] Restoring Windows theme...
[5/5] Finalizing...

Uninstall Complete!
```

✅ **Done!**

---

## Method 2: GUI Uninstall (Easier)

If you prefer not to use PowerShell:

### Step 1: Delete the Folder

1. Open File Explorer
2. Navigate to: `C:\RomanticCustomization\`
3. Delete the entire folder
   - Right-click → Delete (or press Delete key)

### Step 2: Remove Scheduled Task

1. Press Windows+R
2. Type: `taskschd.msc`
3. Press Enter (Task Scheduler opens)
4. Look in: Task Scheduler Library
5. Find: "RomanticWelcome"
6. Right-click → Delete
7. Click Yes to confirm

### Step 3: Remove Registry Key

1. Press Windows+R
2. Type: `regedit`
3. Press Enter (Registry Editor opens)
4. Navigate to: `HKEY_CURRENT_USER\Software\RomanticCustomization`
5. Right-click the "RomanticCustomization" folder → Delete
6. Click Yes to confirm

### Step 4: Restore Windows Theme

1. Right-click Desktop → Personalize
2. Colors → Choose default theme
3. Or manually set Accent color to your preferred color

✅ **All removed!**

---

## Method 3: Full Clean Uninstall (Nuclear Option)

Most thorough removal method.

```powershell
# Step 1: Uninstall via script
C:\RomanticCustomization\UNINSTALL.ps1

# Step 2: Manually delete any remaining files
Remove-Item "C:\RomanticCustomization" -Recurse -Force -ErrorAction SilentlyContinue

# Step 3: Verify it's gone
Test-Path "C:\RomanticCustomization"
# Should return: False
```

---

## After Uninstall

### ✅ Verify Everything Is Removed

1. Check folder is gone:
   - Open File Explorer
   - Type: `C:\RomanticCustomization`
   - Should say "Folder not found"

2. Check scheduled task is gone:
   - Press Windows+R → `taskschd.msc`
   - Search for "RomanticWelcome"
   - Should not find it

3. Log out and back in:
   - No welcome message should appear
   - No theme colors should apply

### ✅ Theme Colors Restored

- Windows theme reset to your default
- Accent color reset
- Cursors back to normal

---

## Reinstall Later

You can reinstall anytime with no issues:

```powershell
C:\RomanticDesktop\INSTALL.ps1
```

Or follow [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md).

---

## Backup Before Uninstalling

If you want to **keep your config for later**:

```powershell
# Backup the config file
Copy-Item "C:\RomanticCustomization\config.txt" "C:\Users\$env:USERNAME\Documents\config_backup.txt"

# Then uninstall normally
C:\RomanticCustomization\UNINSTALL.ps1

# When you reinstall, restore the config
Copy-Item "C:\Users\$env:USERNAME\Documents\config_backup.txt" "C:\RomanticCustomization\config.txt"
```

---

## Troubleshooting Uninstall Issues

### "Access Denied" Error

**Solution:**

1. Close all File Explorer windows
2. Close any PowerShell windows
3. Try uninstalling again
4. If still locked, restart computer and try again

### Scheduled Task Won't Delete

**Solution:**

1. Open Task Scheduler (`Windows+R` → `taskschd.msc`)
2. Right-click "RomanticWelcome" → Delete
3. Click Yes
4. If still won't delete, restart and try again

### Registry Key Won't Delete

**Solution:**

1. Close Registry Editor
2. Restart computer
3. Try again
4. If still locked, check no programs have the key open

### Folder Won't Delete

**Solution:**

```powershell
# Force delete the folder
Remove-Item "C:\RomanticCustomization" -Recurse -Force
```

---

## Still Having Issues?

### Check Event Viewer for Errors

1. Windows+R → `eventvwr`
2. Application → Look for errors related to RomanticWelcome
3. Note the error code

### Try Safe Mode

1. Restart computer
2. During startup, press F8 (or Shift+Restart for Windows 11)
3. Choose Safe Mode
4. Try uninstalling again

### Nuclear Option: Clean Files Manually

If automated uninstall fails:

```powershell
# Stop the scheduled task if running
Get-ScheduledTask -TaskName RomanticWelcome | Stop-ScheduledTask -ErrorAction SilentlyContinue

# Force-delete files
Remove-Item "C:\RomanticCustomization" -Recurse -Force -ErrorAction Continue

# Delete registry
Remove-Item "HKCU:\Software\RomanticCustomization" -Force -ErrorAction Continue

# Verify it's gone
Test-Path "C:\RomanticCustomization"  # Should be False
```

---

## Complete Removal Verification Checklist

✅ Run this PowerShell command to verify complete removal:

```powershell
$checks = @{
    "Folder exists" = (Test-Path "C:\RomanticCustomization")
    "Task exists" = (Get-ScheduledTask -TaskName RomanticWelcome -ErrorAction SilentlyContinue) -ne $null
    "Registry exists" = (Test-Path "HKCU:\Software\RomanticCustomization")
}

$checks | ForEach-Object {
    foreach ($check in $_.GetEnumerator()) {
        $status = if ($check.Value) { "FOUND (Not removed)" } else { "REMOVED (OK)" }
        Write-Host "$($check.Name): $status"
    }
}
```

**All should show "REMOVED (OK)"**

---

## Need Help?

- **Want to reinstall?** → [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)
- **Uninstall issues?** → [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Questions?** → [FAQ.md](../FAQ.md)

---

**Cleanly uninstalled! No traces left. 💕**
