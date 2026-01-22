# 💝 Romantic Windows Customization v1.2

**Status:** ✅ Production Ready | **Release:** January 22, 2026

---

## What Is This?

A romantic Windows customization package that shows a personalized welcome message when she logs in. Includes optional sound playback, theme colors, and an auto-updating "days together" counter.

**Works on:** Windows 10 & Windows 11

---

## 🚀 Quick Start (5 Minutes)

1. Edit config.txt - Change her name and your anniversary date
2. (Optional) Add romantic.wav sound file to this folder
3. (Optional) Add .cur or .ani cursor files to this folder
4. Double-click INSTALL.bat on her computer
5. Log out and log back in!

═══════════════════════════════════════════════════════════════

WHAT THIS DOES:

- ✨ Shows a romantic welcome message popup when she logs in
- 🎵 Plays a romantic sound at login (if you provide romantic.wav)
- 🎨 Applies beautiful rose gold/pink theme colors
- 🖱️ Installs custom cursors (if you provide cursor files)
- 💕 Shows an auto-updating "days together" counter

═══════════════════════════════════════════════════════════════

REQUIRED FILES:

- ✅ INSTALL.bat
- ✅ INSTALL.ps1
- ✅ WelcomeMessage.ps1
- ✅ config.txt
- ✅ README.txt (this file)

OPTIONAL FILES:

- 🎵 romantic.wav - Your romantic sound (WAV format, under 10 seconds)
- 🖱️ _.cur or _.ani - Cursor files

═══════════════════════════════════════════════════════════════

BEFORE INSTALLING - CUSTOMIZE:

1. Edit config.txt:
   - Change HER_NAME to her actual name
   - Change ANNIVERSARY_DATE to your date (format: YYYY-MM-DD)
   - Add your own romantic messages if you want!

2. Add romantic sound:
   - Get a romantic sound or song snippet
   - Convert to WAV format
   - Name it romantic.wav
   - Put it in this folder

3. Add cursors (optional):
   - Download romantic cursor packs
   - Put .cur and .ani files in this folder

═══════════════════════════════════════════════════════════════

INSTALLATION:

On Her Computer:

1. Copy this entire folder to a USB drive
2. Plug USB into her computer
3. Open the folder
4. Double-click INSTALL.bat
5. Click "Yes" when asked for admin privileges
6. Wait for installation to complete
7. Log out and log back in to see it work!

That's it! Everything is automated!

═══════════════════════════════════════════════════════════════

WHERE TO GET EXTRAS:

Romantic Sounds:

- Convert a song snippet: https://convertio.co/mp3-wav/
- Record your own message with Windows Voice Recorder
- Search for free romantic sound effects

Romantic Cursors:

- RW-Designer: www.rw-designer.com/cursor-sets
- Cursors 4U: www.cursors-4u.com
- Search: "hearts cursors" or "romantic cursors"

═══════════════════════════════════════════════════════════════

TROUBLESHOOTING:

"Cannot be loaded because running scripts is disabled"

- → Open PowerShell as Admin
- → Run: Set-ExecutionPolicy RemoteSigned
- → Type Y and press Enter

"This app has been blocked"

- → Right-click INSTALL.bat → Properties
- → Check "Unblock" → OK
- → Try again

Welcome message doesn't appear

- → Make sure you LOGGED OUT and back in (not just locked)
- → Check Task Scheduler for "RomanticWelcome" task

Sound doesn't play

- → Verify romantic.wav is in WAV format (not renamed MP3)
- → Check volume is turned up
- → Try playing the file directly first

═══════════════════════════════════════════════════════════════

AFTER INSTALLATION:

Files are saved to: C:\RomanticCustomization\

Additional customization:

- Set romantic wallpaper: Right-click Desktop → Personalize
- Adjust colors: Settings → Personalization → Colors
- Install more cursors: Mouse Settings → Pointers

═══════════════════════════════════════════════════════════════

TO UNINSTALL:

1. Open Task Scheduler
2. Delete "RomanticWelcome" task
3. Delete folder: C:\RomanticCustomization\
4. Reset cursors in Mouse Settings if needed

═══════════════════════════════════════════════════════════════

TIPS:

- ✨ Record a personal voice message for extra romance
- ✨ Add new messages weekly by editing the config file
- ✨ Time the installation for a special occasion
- ✨ Works on Windows 10 and Windows 11
- ✨ Can be used on multiple computers from the same USB drive

---

## 🎉 Getting Started

**Right now, your best bet:**

1. Open [QUICK_START.md](NON_TECHNICAL_GUIDES/QUICK_START.md) for a 5-minute setup
2. Or read [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) to find what you need
3. Or jump to [INSTALLATION_GUIDE.md](NON_TECHNICAL_GUIDES/INSTALLATION_GUIDE.md) for step-by-step help

**It takes about 5 minutes from start to finish.** 💕

---

## Version Info

**Current Version:** v1.2.1 (Maintenance Release)

- Documentation restructuring and organization
- All v1.2 bug fixes included
- No code changes from v1.2
- See [VERSION_HISTORY.md](MIGRATION_AND_VERSIONS/VERSION_HISTORY.md) for complete history

---

**Happy romantic computing! 💝✨**

For questions, check [FAQ.md](FAQ.md) or [TROUBLESHOOTING.md](NON_TECHNICAL_GUIDES/TROUBLESHOOTING.md).

═══════════════════════════════════════════════════════════════

Version 1.2.1 - Enhanced Documentation Edition
Compatible with Windows 10 & Windows 11

Good luck! 💕
