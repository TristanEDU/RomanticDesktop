# ?? Installation Guide - Step-by-Step

**Version:** v1.2.1 | **Time Required:** ~5 minutes | **Difficulty:** Easy

Follow this guide to install Romantic Windows Customization on her computer.

---

## Before You Start

### ? What You Need

1. This entire "RomanticDesktop" folder (or a copy on USB)
2. Her computer with Windows 10 or Windows 11
3. Administrator access (you'll be asked to confirm when you run the installer)
4. About 5 minutes of time
5. Her `config.txt` file customized (see [QUICK_START.md](QUICK_START.md) if not done)

### ? Optional Files You Can Add

- `romantic.wav` — A romantic sound file (custom music or message)
- `*.cur` or `*.ani` — Custom cursor files (for custom mouse cursor theme)

---

## Installation Steps

### Step 1: Customize the Config File (if not done)

**If you already did this, skip to Step 2.**

Open `config.txt` in Notepad:

1. Right-click `config.txt` ? **Open with** ? **Notepad**
2. Change these three things:

**A) Her Name** (Find `HER_NAME=Gillian`)

```
Change to:
HER_NAME=Sarah
```

**B) Your Anniversary Date** (Find `ANNIVERSARY_DATE=2024-01-06`)

```
Change to (format YYYY-MM-DD):
ANNIVERSARY_DATE=2023-06-15
```

**C) Messages** (Optional - in the `[MESSAGES]` section)

```
Keep the 8 default messages, or:
- Edit any of them (up to 200 characters each)
- Add new messages with: MESSAGE=Your message here
- Delete ones you don't want
```

3. **Save** (Ctrl+S)

? Done with config!

---

### Step 2: Copy Files to Her Computer

**On her computer:**

1. **Copy this entire folder** to USB drive (or any location)
   - Right-click the RomanticDesktop folder ? Copy
   - Paste it on the USB drive

2. **Plug USB into her computer** (if using USB)

3. **Open the folder** (if not already open)

You should see these files:

- ? INSTALL.bat
- ? config.txt
- ? WelcomeMessage.ps1
- ? INSTALL.ps1
- And other files/folders

---

### Step 3: Run the Installer [1/8]

This is the easiest part!

1. **Double-click `INSTALL.bat`**
2. A **black PowerShell window** will open

3. You'll see a message asking: **"Continue with installation? (Y/N)"**
4. **Type `Y`** and press Enter

5. **Click "Yes"** when Windows asks for admin privileges (the "User Account Control" popup)

? Installation will now begin automatically!

---

### Step 4: Watch the Installation Progress

The installer runs 8 automated steps. You'll see:

```
[1/8] Setting up directories...
? Directories created

[2/8] Installing files...
? Files installed

[3/8] Validating configuration...
? Configuration valid

[4/8] Configuring PowerShell...
? PowerShell configured

[5/8] Storing installation path in registry...
? Registry updated

[6/8] Enabling startup sound...
? Sound configured

[7/8] Creating scheduled task...
? Scheduled task created

[8/8] Applying romantic theme...
? Theme applied
```

?? **This takes about 2 minutes.** Just watch it complete!

---

### Step 5: Verify Installation Succeeded

When the installer finishes:

1. You'll see: **"Press any key to close"**
2. Press any key to close the window

**Immediately after, verify everything worked:**

Open PowerShell (search "PowerShell" in Start menu) and run:

```powershell
C:\RomanticCustomization\VERIFY.ps1
```

You should see a report with **GREEN checkmarks (?)** for everything:

```
? Installation folder exists
? Scheduled task exists
? Config file valid
? Registry entries found
? Theme colors applied
? Script integrity verified
```

? **If you see all green checkmarks, you're done!**

? If you see any red X marks, see [Troubleshooting](TROUBLESHOOTING.md).

---

### Step 6: Test the Welcome Message

Now let's test it!

1. **Log her out:**
   - Start menu ? Sign out (or press Windows+L and select sign out)

2. **Log back in** as her

3. **You should see the romantic welcome popup!** ??
   - Shows personalized message
   - Shows "days together" counter
   - Disappears after 20 seconds
   - (Or click "Thanks, sweetheart!" button to close)

? **If you see the welcome message, installation succeeded!**

---

## What Gets Installed

**Installation Location:** `C:\RomanticCustomization\`

**Files installed:**

- `WelcomeMessage.ps1` — Welcome popup display script
- `config.txt` — Your customization file
- `Sounds/romantic.wav` — (if you provided it)
- `Cursors/` — (any custom cursors you provided)

**System changes:**

- ? Scheduled task created: "RomanticWelcome" (runs at login)
- ? Registry key created: `HKCU:\Software\RomanticCustomization`
- ? PowerShell execution policy set to RemoteSigned
- ? Windows theme colors changed to rose gold/pink

**Nothing system-critical changed** — All changes are user-specific and reversible.

---

## Windows 10 vs Windows 11 - Any Differences?

Both work exactly the same! Minor differences:

| Feature         | Windows 10 | Windows 11              |
| --------------- | ---------- | ----------------------- |
| Welcome message | ? Yes     | ? Yes                  |
| Sound playback  | ? Yes     | ? Yes                  |
| Scheduled task  | ? Yes     | ? Yes                  |
| Theme colors    | ? Yes     | ? Yes (Updated design) |
| Custom cursors  | ? Yes     | ? Yes                  |

**No special steps needed for either version.**

---

## Troubleshooting During Installation

### "User Account Control" popup didn't appear

- Make sure you're running as a user with admin rights
- If using a limited account, log in as an admin first

### "Cannot be loaded because running scripts is disabled"

- Right-click `INSTALL.bat` ? **Properties**
- Check **"Unblock"** at the bottom
- Click **OK**
- Try again

### Installation fails partway through

- Close the window and try again
- Make sure the config.txt file is valid (see [CONFIGURATION_GUIDE](CONFIGURATION_GUIDE.md))
- Run CONFIG_VALIDATOR.ps1 to check:
  ```powershell
  C:\RomanticDesktop\CONFIG_VALIDATOR.ps1
  ```

### "This app has been blocked"

- Your antivirus might be blocking the installer
- Temporarily disable antivirus while installing
- Or add the folder to antivirus whitelist

---

## After Installation

### Test Everything Works

1. ? Run VERIFY.ps1 (see Step 5 above)
2. ? Log out and back in to see welcome message
3. ? Check that sound plays (if provided)
4. ? Verify theme colors are applied (pink/rose gold)

### Customize Further

- **Change her name:** Edit `C:\RomanticCustomization\config.txt` (change HER_NAME)
- **Change anniversary date:** Edit config.txt (change ANNIVERSARY_DATE)
- **Add more messages:** Edit config.txt (add MESSAGE= lines in [MESSAGES] section)
- **Change welcome timeout:** Edit config.txt (change WELCOME_TIMEOUT in [USER] section, range 5-300)
- **Add custom sound:** Copy WAV file to `C:\RomanticCustomization\Sounds\romantic.wav`
- **Add custom cursors:** Copy .cur/.ani files to `C:\RomanticCustomization\Cursors\`

### Verify Installation Regularly

Run VERIFY.ps1 anytime to check that everything is still working:

```powershell
C:\RomanticCustomization\VERIFY.ps1
```

---

## Need Help?

- **Welcome message not appearing?** ? [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Questions about setup?** ? [FAQ.md](../FAQ.md)
- **Want to customize more?** ? [CONFIGURATION_GUIDE.md](CONFIGURATION_GUIDE.md)
- **Need to uninstall?** ? [UNINSTALL_GUIDE.md](UNINSTALL_GUIDE.md)

---

**Installation complete! Enjoy! ???**

