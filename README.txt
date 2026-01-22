💝 ROMANTIC WINDOWS CUSTOMIZATION PACKAGE 💝
VERSION 1.1 - Reliability Foundation Edition

═══════════════════════════════════════════════════════════════

QUICK START:

1. Edit config.txt - Change her name and your anniversary date
2. (Optional) Add romantic.wav sound file to this folder
3. (Optional) Add .cur or .ani cursor files to this folder
4. Double-click INSTALL.bat on her computer
5. Log out and log back in!

═══════════════════════════════════════════════════════════════

WHAT THIS DOES:

✨ Shows a romantic welcome message popup when she logs in
🎵 Plays a romantic sound at login (if you provide romantic.wav)
🎨 Applies beautiful rose gold/pink theme colors
🖱️ Installs custom cursors (if you provide cursor files)
💕 Shows an auto-updating "days together" counter

═══════════════════════════════════════════════════════════════

NEW IN V1.1 - RELIABILITY IMPROVEMENTS:

✅ Configurable welcome message timeout (5-300 seconds)
✅ Registry-based installation path (USB/portable support)
✅ Configuration validation before installation
✅ Scheduled task creation verification
✅ Installation logging for troubleshooting
✅ Clean uninstall script (UNINSTALL.ps1)
✅ Post-installation verification tool (VERIFY.ps1)
✅ Foundation for v2.0 voice messages and wallpaper features

═══════════════════════════════════════════════════════════════

REQUIRED FILES:
✅ INSTALL.bat
✅ INSTALL.ps1
✅ WelcomeMessage.ps1
✅ config.txt
✅ README.txt (this file)
✅ CONFIG_VALIDATOR.ps1 (validates configuration)
✅ VERIFY.ps1 (checks installation after setup)
✅ UNINSTALL.ps1 (clean removal tool)

OPTIONAL FILES:
🎵 romantic.wav - Your romantic sound (WAV format, under 10 seconds)
🖱️ *.cur or *.ani - Cursor files

═══════════════════════════════════════════════════════════════

BEFORE INSTALLING - CUSTOMIZE:

1. Edit config.txt:
   - Change HER_NAME to her actual name (max 100 characters)
   - Change ANNIVERSARY_DATE to your date (format: YYYY-MM-DD)
   - Customize WELCOME_TIMEOUT (5-300 seconds, default 20)
   - Add your own romantic messages (max 200 characters each)

2. Add romantic sound:
   - Get a romantic sound or song snippet
   - Convert to WAV format
   - Name it romantic.wav
   - Put it in this folder

3. (Optional) Add cursors:
   - Download romantic cursor packs (.cur or .ani files)
   - Put them in this folder

═══════════════════════════════════════════════════════════════

CONFIG.TXT V1.1 FORMAT:

The new config.txt has organized sections:
  [USER]     - Name and display timeout settings
  [DATES]    - Anniversary date and special dates
  [MESSAGES] - Romantic messages that appear at login
  [FUTURE]   - Reserved for v2.0 features (do not edit)

Example config entry:
  [USER]
  HER_NAME=Gillian
  WELCOME_TIMEOUT=20
  
  [DATES]
  ANNIVERSARY_DATE=2024-01-06
  
  [MESSAGES]
  MESSAGE=Good morning, beautiful! ❤️
  MESSAGE=Welcome back, love! ☀️

═══════════════════════════════════════════════════════════════

INSTALLATION HELPERS (v1.1):

After installation, use these tools to verify and manage:

VERIFY.ps1 - Post-installation verification
- Run: powershell .\VERIFY.ps1
- Checks all components are installed correctly
- Verifies scheduled task and configuration
- Reports any issues found

CONFIG_VALIDATOR.ps1 - Configuration validation
- Run: powershell .\CONFIG_VALIDATOR.ps1 c:\RomanticCustomization\config.txt
- Tests configuration file syntax and validity
- Reports any formatting errors
- Use this before reinstalling if config.txt has issues

UNINSTALL.ps1 - Clean removal tool
- Run as Administrator: powershell .\UNINSTALL.ps1
- Removes scheduled task, files, and registry entries
- Restores Windows theme to defaults
- Complete clean uninstall (no backup kept)

═══════════════════════════════════════════════════════════════

INSTALLATION STEPS:

On Her Computer:
1. Copy this entire folder to a USB drive
2. Plug USB into her computer
3. Open the folder
4. Double-click INSTALL.bat
5. Click "Yes" when asked for admin privileges
6. Wait for installation to complete
7. Run VERIFY.ps1 to confirm everything installed correctly
8. Log out and log back in to see it work!

That's it! Everything is automated!

═══════════════════════════════════════════════════════════════

MULTI-USER SYSTEMS - IMPORTANT NOTE:

⚠️ The scheduled task is created for the current user only.
   If multiple users share this computer, the welcome message
   will only appear for the user who ran INSTALL.ps1.
   
   To install for multiple users:
   - Have each user run INSTALL.ps1 separately
   - They'll each get their own welcome message at login

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
→ Open PowerShell as Admin
→ Run: Set-ExecutionPolicy RemoteSigned
→ Type Y and press Enter

"This app has been blocked"
→ Right-click INSTALL.bat → Properties
→ Check "Unblock" → OK
→ Try again

Welcome message doesn't appear
→ Make sure you LOGGED OUT and back in (not just locked)
→ Check Task Scheduler for "RomanticWelcome" task
→ Run VERIFY.ps1 to diagnose issues

Antivirus is blocking the installation
→ Some antivirus software blocks script execution
→ Temporarily disable your antivirus during installation
→ Then re-enable it (the package is safe)

Want to test welcome message before logging out?
→ During installation, say YES when asked to test
→ This shows you how it will look without logging out

Sound doesn't play
→ Verify romantic.wav is in WAV format (not renamed MP3)
→ Check volume is turned up
→ Try playing the file directly first

═══════════════════════════════════════════════════════════════

AFTER INSTALLATION:

Files are saved to: C:\RomanticCustomization\

Installation information stored in:
- Registry: HKCU:\Software\RomanticCustomization\InstallPath
- (Used for portable USB/multi-drive support)

Additional customization:
- Set romantic wallpaper: Right-click Desktop → Personalize
- Adjust colors: Settings → Personalization → Colors
- Install more cursors: Mouse Settings → Pointers
- Edit config.txt to change messages anytime

═══════════════════════════════════════════════════════════════

TO UNINSTALL:

EASY METHOD (Recommended):
1. Open PowerShell as Administrator
2. Navigate to the folder with UNINSTALL.ps1
3. Run: .\UNINSTALL.ps1
4. Confirm when prompted

MANUAL METHOD:
1. Open Task Scheduler
2. Find and delete "RomanticWelcome" task
3. Delete folder: C:\RomanticCustomization\
4. Delete registry key: HKCU:\Software\RomanticCustomization\
5. Reset cursors in Mouse Settings if needed

═══════════════════════════════════════════════════════════════

COMING SOON - v2.0 FEATURES:

The foundation for v2.0 is built into this package! Coming soon:
🎤 Voice message playback (record personal greetings)
🖼️ Dynamic wallpaper rotation (multiple romantic backgrounds)
📅 Smart messages (different messages for time of day/week)
💬 Enhanced message scheduling (anniversaries, special dates)
🎨 Theme customization (beyond just colors)

The [FUTURE] section in config.txt is reserved for v2.0 
compatibility, so your settings will upgrade seamlessly!

═══════════════════════════════════════════════════════════════

TIPS:

✨ Record a personal voice message for extra romance (v2.0)
✨ Add new messages weekly by editing config.txt
✨ Change WELCOME_TIMEOUT to customize how long message appears
✨ Time the installation for a special occasion
✨ Works on Windows 10 and Windows 11
✨ Use on multiple computers from the same USB drive
✨ Run VERIFY.ps1 to check system health anytime

═══════════════════════════════════════════════════════════════

VERSION HISTORY:

v1.1 - Reliability Foundation Edition (Current)
  • Registry-based installation paths (portable)
  • Configuration validation system
  • Installation logging and verification
  • Clean uninstall script
  • Configurable welcome timeout
  • v2.0 feature foundation

v1.0 - Portable USB Edition
  • Original release with core features

═══════════════════════════════════════════════════════════════

Version 1.1 - Reliability Foundation Edition
Compatible with Windows 10 & Windows 11
Built for USB portability and extensibility

Good luck! 💕
