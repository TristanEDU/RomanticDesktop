# 💝 Quick Start Guide - 5 Minutes to Romance

**Version:** v1.2.1 | **Updated:** January 22, 2026

Fastest way to get up and running. Takes about 5 minutes.

---

## Step 1: Customize Your Config (2 minutes) 📝

Open the file `config.txt` in Notepad (right-click → Open with → Notepad).

### Change These Three Things:

**1. Her Name** (Find line with `HER_NAME=`)

```
Change this:
HER_NAME=Gillian

To her actual name:
HER_NAME=Sarah
```

✅ Keep it under 100 characters
✅ Unicode works! 💕 (Japanese: 田中 さくら, Arabic: الاسم, etc.)

**2. Your Anniversary Date** (Find line with `ANNIVERSARY_DATE=`)

```
Change this:
ANNIVERSARY_DATE=2024-01-06

To your special date:
ANNIVERSARY_DATE=2023-06-15
```

✅ Format: YYYY-MM-DD (ISO standard)
✅ Cannot be in the future

**3. Add Personal Messages** (Optional - Find [MESSAGES] section)

```
Current 8 messages are there. You can:
✅ Edit existing ones
✅ Add new messages (one per MESSAGE= line)
✅ Keep default ones

Each message can be up to 200 characters.
```

Then **save the file** (Ctrl+S).

---

## Step 2: Run the Installer (2 minutes) ⚙️

**On her computer:**

1. Copy this entire folder to a USB drive (or any location)
2. Plug USB into her computer
3. **Double-click `INSTALL.bat`** (the installer)
4. Click **"Yes"** when asked for admin privileges
5. Wait for installation to complete (you'll see progress [1/8] through [8/8])
6. Press any key to close when done

**That's it!** Files installed to `C:\RomanticCustomization`

---

## Step 3: Verify It Works (1 minute) ✅

**Immediately after install:**

1. Open PowerShell (search "PowerShell" in Start menu)
2. Run this command:
   ```powershell
   C:\RomanticCustomization\VERIFY.ps1
   ```
3. Should see green checkmarks ✓ next to everything

If anything shows red ✗, see [Troubleshooting](TROUBLESHOOTING.md).

---

## Step 4: Test the Welcome Message 🎉

**Log out and back in:**

1. Click Start menu → Sign out (or press `Windows Key + L` to lock)
2. Log back in as her
3. You should see the romantic welcome popup! 💕

✅ Message appears for 20 seconds (customizable)
✅ Random message each login
✅ Shows "days together" counter

---

## Optional: Add Custom Sound 🎵

If you want custom romantic music:

1. Get a WAV file (under 10 seconds)
   - Tip: Use [Convertio.co](https://convertio.co/mp3-wav/) to convert MP3 → WAV
   - Or record a personal message with Windows Voice Recorder
2. Copy the WAV file to `C:\RomanticCustomization\Sounds\romantic.wav`

3. Log out/in again

Sound plays automatically at login! 🎶

---

## Optional: Add Custom Cursors 🖱️

If you want romantic cursor themes:

1. Download `.cur` or `.ani` cursor files
2. Copy them to `C:\RomanticCustomization\Cursors\`
3. Go to Windows Settings → Mouse → Pointers
4. Select the custom cursor files

---

## Troubleshooting Quick Fixes ⚡

### "Welcome message doesn't appear"

- ✅ Make sure you **LOGGED OUT and back in** (not just locked)
- ✅ Check if VERIFY.ps1 shows all green checkmarks
- See [Troubleshooting.md](TROUBLESHOOTING.md) for more help

### "Sound doesn't play"

- ✅ Check the file is WAV format (not renamed MP3)
- ✅ Volume is turned up
- ✅ Try playing `romantic.wav` directly first

### "Got admin/permission error"

- ✅ Right-click `INSTALL.bat` → Properties → Check "Unblock" → OK
- ✅ Retry installation

### "Something else broke"

→ See [Troubleshooting.md](TROUBLESHOOTING.md) for detailed help

---

## Next Steps

- **Want detailed installation guide?** → [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)
- **Want to customize config more?** → [CONFIGURATION_GUIDE.md](CONFIGURATION_GUIDE.md)
- **Have questions?** → [FAQ.md](../FAQ.md)
- **Need to uninstall?** → [UNINSTALL_GUIDE.md](UNINSTALL_GUIDE.md)

---

## What You Just Installed 💾

The installation creates:

- ✅ Scheduled task to run at login
- ✅ Romantic Windows theme colors (rose gold/pink)
- ✅ Auto-updating "days together" counter
- ✅ Optional custom sound playback
- ✅ Optional custom cursors

**No personal data sent anywhere** — everything runs locally on her computer. 100% offline, 100% safe. 💕

---

**Enjoy! You've got this! 💝✨**

For more help, check [DOCUMENTATION_INDEX.md](../DOCUMENTATION_INDEX.md) or [FAQ.md](../FAQ.md).
