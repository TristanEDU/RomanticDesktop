# ?? Configuration Guide - Customize Your Setup

**Version:** v1.2.1 | **Difficulty:** Easy | **File:** config.txt

This guide explains how to customize everything in the `config.txt` file.

---

## Quick Overview

The `config.txt` file controls:

- ? Her name (displayed in welcome message)
- ? Your anniversary date (calculates "days together")
- ? Welcome message timeout (how long popup displays)
- ? Romantic messages (8 customizable messages)

**Location:** `C:\RomanticCustomization\config.txt` (after installation)
**Format:** Simple text file (edit with Notepad)
**Encoding:** UTF-8 with BOM (supports emoji and international characters)

---

## Before You Start

### Where to Find config.txt

**Before installation:**

- In the RomanticDesktop folder (where you downloaded it)

**After installation:**

- `C:\RomanticCustomization\config.txt`

### How to Edit

1. Right-click the file ? **Open with** ? **Notepad**
2. Make your changes
3. **Save** (Ctrl+S)
4. **Log out and back in** to see changes take effect

? **That's it!** Changes apply immediately after you log in next time.

---

## Configuration Sections Explained

### Section 1: [USER] - Basic Information

Controls how the welcome message appears and who it greets.

#### HER_NAME

**What it does:** Displays her name in the welcome message

**Example in popup:**

```
?? Welcome, Sarah! ??
Good morning, beautiful! Hope your day is as amazing as you are ??
```

**How to change:**

```
Old:
HER_NAME=Gillian

New:
HER_NAME=Sarah
```

**Rules:**

- ? Minimum: 1 character
- ? Maximum: 100 characters
- ? Supports Unicode! ??
  - Japanese: `HER_NAME=?? ???`
  - Arabic: `HER_NAME=?????`
  - Chinese: `HER_NAME=??`
  - Russian: `HER_NAME=???`
  - Emoji: `HER_NAME=Sarah ??`

**Unicode Tips:**

- Use Notepad to edit (built-in UTF-8 support)
- If characters appear garbled, file encoding is wrong (should be UTF-8 with BOM)

#### WELCOME_TIMEOUT

**What it does:** How many seconds the welcome popup stays on screen

**Example:**

```
WELCOME_TIMEOUT=20
```

= Popup displays for 20 seconds, then closes automatically

**How to change:**

```
Old:
WELCOME_TIMEOUT=20

New:
WELCOME_TIMEOUT=30
```

**Rules:**

- ? Minimum: 5 seconds
- ? Maximum: 300 seconds (5 minutes)
- ? Must be a number (no decimal points)
- ? Default: 20 seconds (recommended)

**Tips:**

- **Too short (5-10 sec):** Message disappears quickly
- **Just right (15-30 sec):** Time to read & appreciate
- **Long (60+ sec):** Extra time if custom sound is playing

---

### Section 2: [DATES] - Important Dates

Controls the anniversary date for the "days together" counter.

#### ANNIVERSARY_DATE

**What it does:** Your special date - calculates how many days you've been together

**Example in popup:**

```
We've been together for 847 amazing days! ??
```

**How to change:**

```
Old:
ANNIVERSARY_DATE=2024-01-06

New:
ANNIVERSARY_DATE=2023-06-15
```

**Format:**

- ? **YYYY-MM-DD** (ISO 8601 standard)
- ? Year (4 digits) - Month (2 digits) - Day (2 digits)
- ? NOT MM/DD/YYYY
- ? NOT 01/06/2024

**Examples:**

- ? January 6, 2024 = `2024-01-06`
- ? June 15, 2023 = `2023-06-15`
- ? December 25, 2022 = `2022-12-25`
- ? 2024/1/6 (missing leading zeros)
- ? 01-06-2024 (wrong format)

**Rules:**

- Cannot be in the future (system won't accept it)
- Should be the date you got together (anniversary, first date, etc.)
- Maximum age: any past date is fine

**What if you have multiple anniversaries?**

- The [DATES] section currently supports one date
- For future updates, you could add multiple dates (not yet supported in v1.2.1)

---

### Section 3: [MESSAGES] - Romantic Messages

8 romantic messages that display randomly when she logs in.

**What it does:** Shows one random message from this list each login

**Example:**

```
MESSAGE=Good morning, beautiful! Hope your day is as amazing as you are ??
MESSAGE=Welcome back! You make every day brighter ?
MESSAGE=Hey gorgeous! Ready to conquer the day together? ??
MESSAGE=Missing you already! Have a wonderful day ??
MESSAGE=You're logged in to the best computer... but I'm logged in to the best heart ??
MESSAGE=Remember: you're incredible! ??
MESSAGE=Another day, another chance to be amazing! ?
MESSAGE=The world is lucky to have you in it today! ??
```

#### How to Customize Messages

**Option A: Edit an existing message**

```
Old:
MESSAGE=Good morning, beautiful! Hope your day is as amazing as you are ??

New:
MESSAGE=Good morning, Sarah! You light up my world! ??
```

**Option B: Add new messages**

Just add more `MESSAGE=` lines in the [MESSAGES] section:

```
MESSAGE=Good morning, beautiful! Hope your day is as amazing as you are ??
MESSAGE=Welcome back! You make every day brighter ?
MESSAGE=Hey gorgeous! Ready to conquer the day together? ??
MESSAGE=I love you more each day! ??
MESSAGE=You're the best part of my day! ??
MESSAGE=Thinking of you always! ??
```

**Option C: Remove messages you don't like**

Just delete the line (the system needs at least 1 message, but more is better for variety).

#### Message Rules

- ? Each message on its own line starting with `MESSAGE=`
- ? Maximum 200 characters per message
- ? Supports emoji! ?????????
- ? Can use her name placeholder `{NAME}` (will be replaced with HER_NAME)
- ? No empty lines between messages
- ? Don't break a message across multiple lines

#### Message Examples

**Simple:**

```
MESSAGE=Good morning!
```

**With emoji:**

```
MESSAGE=Good morning, beautiful! Hope your day is as amazing as you are ??
```

**With her name:**

```
MESSAGE=Good morning, {NAME}! You're amazing! ??
```

(Displays as: "Good morning, Sarah! You're amazing! ??")

**Personal & romantic:**

```
MESSAGE=Every moment with you is a blessing. Have a wonderful day! ??
MESSAGE=You make my heart smile. Go show the world your brilliance! ?
MESSAGE=I'm grateful for you every single day! ??
MESSAGE=You're stronger than you think. I believe in you! ????
MESSAGE=Thank you for being you. I love you! ??
```

#### Adding Emoji to Messages

**Common romantic emoji:**

- ?? Heart
- ?? Two hearts
- ?? Sparkling heart
- ?? Heart with ribbon
- ?? Rose
- ? Sparkles
- ?? Heart eyes
- ?? Love eyes
- ?? Couple
- ?? Kiss
- ?? Crown
- ?? Bow
- ?? Gift
- ?? Star
- ?? Dizzy (sparkle)

**How to add emoji:**

- Copy-paste emoji directly into the message
- Or type: Hold Windows key + semicolon (;) to open emoji picker
- Or just use the emoji characters: ???????

---

### Section 4: [FUTURE] - Reserved for v2.0

**Don't edit this section!**

```
[FUTURE]
# v2.0 planned features:
# - Voice message playback
# - Dynamic wallpaper
# - Seasonal themes
# - Calendar integration
```

This section is reserved for future versions. Just leave it as-is.

---

## Complete Example Config

Here's a fully customized example:

```
# Romantic Customization Configuration v1.2
# UTF-8 with BOM encoding

[USER]
HER_NAME=Sarah Johnson
WELCOME_TIMEOUT=25

[DATES]
ANNIVERSARY_DATE=2023-06-15

[MESSAGES]
MESSAGE=Good morning, beautiful! Hope your day is as amazing as you are ??
MESSAGE=Welcome back, Sarah! You make every day brighter ?
MESSAGE=Hey gorgeous! Ready to conquer the day together? ??
MESSAGE=Missing you already! Have a wonderful day ??
MESSAGE=You're logged in to the best computer... but I'm logged in to the best heart ??
MESSAGE=Remember: you're incredible! ??
MESSAGE=Another day, another chance to be amazing! ?
MESSAGE=The world is lucky to have you in it today! ??

[FUTURE]
# Reserved for v2.0+ features
```

---

## Troubleshooting Configuration Issues

### "Config validation failed" error during install

1. Open config.txt in Notepad
2. Check:
   - ? `HER_NAME=` has a value (not blank)
   - ? `ANNIVERSARY_DATE=` is in YYYY-MM-DD format
   - ? `ANNIVERSARY_DATE=` is not in the future
   - ? `WELCOME_TIMEOUT=` is a number between 5-300
   - ? At least one `MESSAGE=` line exists in [MESSAGES] section
   - ? Each message is 200 characters or less
3. Save and try installing again

### Welcome message shows "My Love" instead of her name

- Config.txt is not being read correctly
- Check file encoding (should be UTF-8 with BOM)
- Re-create config.txt with proper encoding

### Changes don't take effect after logging in

1. Log out completely (not just lock screen)
2. Log back in
3. Check if welcome message appears with new content

### Emoji characters don't display in welcome message

- File encoding is probably wrong
- Should be UTF-8 with BOM (Notepad should handle this automatically)
- Try re-saving the file in Notepad

---

## Advanced Options

### Using Variable Substitution

**Available variables:**

- `{NAME}` — Replaced with HER_NAME value

**Example:**

```
MESSAGE=Good morning, {NAME}! I love you! ??
```

Displays as:

```
Good morning, Sarah! I love you! ??
```

### Character Limit Tips

**Each message can be 200 characters max.** Here's how to check:

```
MESSAGE=Good morning, beautiful! Hope your day is as amazing as you are ??
```

Count that = about 85 characters. Plenty of room!

Longer examples (still under 200):

```
MESSAGE=Every single day with you is a gift. You make me smile, you inspire me, and you make me want to be a better person. Have an amazing day, beautiful! ??
```

That's about 165 characters. Still good!

---

## After Editing config.txt

1. **Save the file** (Ctrl+S in Notepad)
2. **Close Notepad**
3. **Log out** from Windows
4. **Log back in**
5. **See your updated welcome message!** ??

That's it! No need to reinstall or restart anything.

---

## Need More Help?

- **Installation issues?** ? [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md)
- **Welcome message not showing?** ? [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **General questions?** ? [FAQ.md](../FAQ.md)

---

**Happy customizing! ???**

