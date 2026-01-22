# 🆘 Troubleshooting Guide

**Version:** v1.2.1 | **Last Updated:** January 22, 2026

Quick solutions to common problems. Most issues are fixable in 5 minutes.

---

## 🔥 Top 5 Common Issues

### 1. Welcome Message Doesn't Appear

**Symptom:** Installed successfully, but no popup when logging in

**Quick Fixes (try in order):**

1. ✅ **Did you actually log out?**
   - Locking the screen (Windows+L) doesn't work
   - You must fully **sign out** and back in
   - **Sign out:** Start menu → Sign out → Log back in

2. ✅ **Check if scheduled task exists:**

   ```powershell
   Get-ScheduledTask -TaskName RomanticWelcome
   ```

   - If nothing displays, task wasn't created
   - Try reinstalling

3. ✅ **Run VERIFY.ps1 to check everything:**

   ```powershell
   C:\RomanticCustomization\VERIFY.ps1
   ```

   - Look for any red ✗ marks
   - See detailed troubleshooting below

4. ✅ **Check if config.txt exists:**
   - Open `C:\RomanticCustomization\config.txt`
   - Make sure it has content (not empty)

5. ✅ **Check Windows Task Scheduler:**
   - Press Windows+R, type `taskschd.msc`
   - Look for "RomanticWelcome" task in Library
   - Right-click → Run
   - Does the popup appear? If yes, it works!

**If still not working:**
→ See [VERIFY.ps1 Checks Not Passing](#verifyps1-checks-not-passing) below

---

### 2. Sound Doesn't Play

**Symptom:** Welcome appears but no sound, or sound plays intermittently

**Quick Fixes:**

1. ✅ **Check volume**
   - Volume slider is turned up (not muted)
   - Try playing a different sound to confirm system works

2. ✅ **Check WAV file exists**

   ```
   C:\RomanticCustomization\Sounds\romantic.wav
   ```

   - If missing, copy your WAV file there

3. ✅ **Verify it's actually a WAV file**
   - Don't just rename an MP3 to .wav (won't work)
   - Use Convertio.co or Windows Media Player to convert properly
   - Right-click file → Properties → should show "Wave Sound"

4. ✅ **Test the file directly**
   - Right-click romantic.wav → Open with → Windows Media Player
   - Does it play? If yes, file is good
   - If no, file is corrupted or wrong format

5. ✅ **Check speakers work**
   - Click volume icon → test a system sound
   - Click Settings → System → Sound → test sound plays

**Still not working?**

- Sound is optional - welcome message works without it
- Try uninstalling and reinstalling without custom sound
- Default system sounds might be disabled (check Sound Settings)

---

### 3. "Cannot be loaded because running scripts is disabled" Error

**Symptom:** PowerShell error during installation

**Fix (takes 30 seconds):**

1. Right-click `INSTALL.bat` → **Properties**
2. At the bottom, check the box: **☑️ Unblock**
3. Click **Apply** → **OK**
4. Double-click INSTALL.bat again

✅ Should work now!

**Why this happens:**

- Windows blocks downloaded scripts for security
- "Unblock" tells Windows you trust this file

---

### 4. Admin/Permission Errors

**Symptom:** "Access Denied" or "Need Administrator Privileges" error

**Fixes:**

**Option A: Run with Admin (Quick)**

1. Right-click `INSTALL.bat` → **Run as Administrator**
2. Click **Yes** when prompted
3. Should now work

**Option B: Check Your Account Type**

1. Settings → Accounts → Your Info
2. Look for "Administrator" next to your account
3. If it says "Local Account" (not admin):
   - You need to log in with an admin account to install
   - Ask the computer's admin to install it

**Why this happens:**

- Installation needs admin rights to:
  - Create folders in C:\
  - Create scheduled tasks
  - Modify registry

---

### 5. Installation Fails Partway Through

**Symptom:** Installer runs but stops with an error (steps [1/8] through [8/8])

**Fixes (try in order):**

1. ✅ **Check config.txt is valid**

   ```powershell
   C:\RomanticDesktop\CONFIG_VALIDATOR.ps1
   ```

   - Look for any red ✗ errors
   - Fix the config errors
   - Try installing again

2. ✅ **Close all explorer windows**
   - If Windows Explorer is open in C:\RomanticCustomization\
   - Installer can't modify locked files
   - Close Explorer, try again

3. ✅ **Disable antivirus temporarily**
   - Some antivirus blocks installation
   - Temporarily disable it (check antivirus software's menu)
   - Try installing
   - Re-enable antivirus when done

4. ✅ **Run Disk Check**
   - Open PowerShell as Admin
   - Run: `chkdsk c: /f`
   - Restart computer
   - Try installing again

5. ✅ **Reinstall from scratch**
   - Run: `C:\RomanticDesktop\UNINSTALL.ps1`
   - Choose Yes to fully remove
   - Delete the C:\RomanticCustomization folder manually
   - Run INSTALL.bat again

---

## 🔍 VERIFY.ps1 Checks Not Passing

Run this to diagnose any issues:

```powershell
C:\RomanticCustomization\VERIFY.ps1
```

**Interpreting Results:**

### ✓ Green Checkmarks = Good

Everything is working correctly.

### ✗ Red X Marks = Problem

See solutions below.

### ⚠ Yellow Warnings = Minor Issues

These might not block functionality but should be fixed.

---

## Detailed Problem Solutions

### Problem: Installation Folder Not Found

**Red X:** "Installation folder not found"

**Solution:**

1. The system can't find `C:\RomanticCustomization\`
2. This shouldn't happen if installation succeeded
3. Check:
   - Open File Explorer
   - Type `C:\RomanticCustomization\` in address bar
   - Does the folder exist?

**If folder doesn't exist:**

- Installation failed
- See [Installation Fails Partway Through](#5-installation-fails-partway-through)

**If folder exists:**

- Try running VERIFY.ps1 again
- If still shows error, reinstall

---

### Problem: Scheduled Task Not Found

**Red X:** "Task not found"

**Solution:**

1. Open Task Scheduler:
   - Windows+R → `taskschd.msc`
2. Look in: Task Scheduler Library → find "RomanticWelcome"

**If task exists but VERIFY says it doesn't:**

- Restart computer
- Run VERIFY.ps1 again

**If task doesn't exist:**

- Installation failed to create it
- Run INSTALL.ps1 again:
  ```powershell
  C:\RomanticDesktop\INSTALL.ps1
  ```

---

### Problem: Config File Invalid

**Red X:** "Config file validation failed"

**Solution:**

1. Open the file:

   ```
   C:\RomanticCustomization\config.txt
   ```

2. Check for these common errors:
   - `HER_NAME=` has a blank/empty value
   - `ANNIVERSARY_DATE=` is in wrong format (should be YYYY-MM-DD)
   - `ANNIVERSARY_DATE=` is in the future
   - `WELCOME_TIMEOUT=` is not a number
   - No `MESSAGE=` lines in [MESSAGES] section

3. For detailed config help:
   → [CONFIGURATION_GUIDE.md](CONFIGURATION_GUIDE.md)

4. After fixing, save and run:
   ```powershell
   C:\RomanticCustomization\CONFIG_VALIDATOR.ps1
   ```

---

### Problem: Registry Entries Not Found

**Red X:** "Registry key not found"

**Solution:**

1. This means `HKCU:\Software\RomanticCustomization\` doesn't exist

2. Registry is created during installation

3. If missing after installation:
   - Run INSTALL.ps1 again
   - Should recreate the registry key

4. To manually check registry:
   - Windows+R → `regedit`
   - Navigate to: `HKEY_CURRENT_USER\Software\RomanticCustomization`
   - Should see: InstallPath and InstallDate

---

### Problem: Script Integrity Check Failed

**Red X:** "Script integrity check failed"

**Solution:**

1. This means WelcomeMessage.ps1 is corrupted or missing

2. Copy the file from source:
   - Copy `WelcomeMessage.ps1` from RomanticDesktop folder
   - Paste to `C:\RomanticCustomization\`
   - Overwrite the existing file

3. Or reinstall:
   ```powershell
   C:\RomanticDesktop\INSTALL.ps1
   ```

---

## Antivirus & Security Software Issues

### Issue: "Blocked by Windows Defender"

**Solution:**

1. Windows Defender → Virus & Threat Protection
2. Manage settings → Add exclusions
3. Add exclusion for: `C:\RomanticCustomization\`
4. Try installing again

### Issue: "Blocked by Other Antivirus"

**Solution:**

1. Check your antivirus software (Norton, McAfee, Avast, etc.)
2. Find the exceptions/whitelist section
3. Add: `C:\RomanticCustomization\` to whitelist
4. Try installing again

**Why antivirus blocks it:**

- PowerShell scripts sometimes flagged as suspicious
- Windows scheduled tasks trigger security warnings
- Registry modifications can be flagged

**Is it safe?**

- Yes! This is legitimate code
- No malware, no data collection
- Open source approach - you can read every line

---

## Contact & Advanced Help

### If you've tried everything above:

1. **Run full diagnostics:**

   ```powershell
   C:\RomanticCustomization\VERIFY.ps1
   Get-ScheduledTask -TaskName RomanticWelcome | fl
   Get-ItemProperty "HKCU:\Software\RomanticCustomization" | fl
   ```

2. **Check Windows Event Viewer:**
   - Windows+R → `eventvwr`
   - Look in: Windows Logs → Application
   - Look for errors related to "RomanticWelcome"

3. **Uninstall and try fresh:**
   ```powershell
   C:\RomanticCustomization\UNINSTALL.ps1
   C:\RomanticDesktop\INSTALL.ps1
   ```

---

## Getting More Help

- **Questions about config?** → [CONFIGURATION_GUIDE.md](CONFIGURATION_GUIDE.md)
- **Installation issues?** → [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)
- **Need to remove it?** → [UNINSTALL_GUIDE.md](UNINSTALL_GUIDE.md)
- **General Q&A?** → [FAQ.md](../FAQ.md)

---

**Most issues are resolved by:**

1. Running VERIFY.ps1
2. Following the specific error solution
3. Restarting your computer
4. Trying again

**You've got this! 💕**
