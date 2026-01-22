# Version History - Romantic Windows Customization

**Complete Timeline:** v1.0 ? v1.2.1 | **As of:** January 22, 2026

---

## ?? Version Timeline

```
v1.0 (August 2024)
   ?
v1.1 (January 2026) - Reliability Foundation
   ?
v1.2 (January 22, 2026) - Bug Fixes & Validation
   ?
v1.2.1 (January 22, 2026) - Documentation Restructure
```

---

## v1.0 - Initial Release Edition

**Release Date:** August 2024  
**Status:** No longer supported | Recommend upgrading to v1.2.1

### Features

- ? Basic welcome message popup
- ? Scheduled task creation
- ? Welcome message customization
- ? Theme color application
- ? Optional sound support
- ? Optional cursor support

### Limitations

- ? Hard-coded C:\ drive path (not portable)
- ? Limited configuration validation
- ? No installation verification tools
- ? Basic error handling
- ? No built-in diagnostics
- ? No uninstall script

### Known Issues

- Emoji characters sometimes lost in config
- No way to verify installation success
- Difficult to troubleshoot problems
- Not suitable for USB/portable use

---

## v1.1 - Reliability Foundation Edition

**Release Date:** January 21, 2026  
**Status:** Stable | Upgrade to v1.2.1 recommended

### Major Improvements from v1.0

#### ?? Portability

- Registry-based installation paths
- Works from any location (USB, external drive, etc.)
- Fallback to C:\ if registry path missing

#### ? Validation & Diagnostics

- CONFIG_VALIDATOR.ps1 (new) - validates config.txt before install
- VERIFY.ps1 (new) - post-installation health check
- 3 validation rules added
- Detailed error messages

#### ??? Installation Improvements

- 7-step installation process (auto-numbered)
- Installation logging
- Scheduled task verification
- Configuration validation integration

#### ?? Documentation

- README.txt with comprehensive guide
- Installation instructions
- Troubleshooting section
- Feature explanations

#### ?? New Tools

- UNINSTALL.ps1 - clean removal script
- CONFIG_VALIDATOR.ps1 - pre-install verification
- VERIFY.ps1 - post-install diagnostics

### Features

- All v1.0 features plus:
- ? Portable installation (USB-ready)
- ? Configuration validation
- ? Post-installation verification
- ? Clean uninstall script
- ? Registry-based path storage
- ? Installation date tracking
- ? Better error handling

### Config Format Changes

- New section-based format: [USER], [DATES], [MESSAGES], [FUTURE]
- Backward compatible with v1.0 configs
- More organized and maintainable

### Upgrade Path

- v1.0 ? v1.1: Fully compatible
- Config files work without modification
- Installation replaces v1.0 files

---

## v1.2 - Bug Fixes & Validation Edition

**Release Date:** January 22, 2026  
**Status:** Current | Production ready

### Major Bug Fixes (19 Total)

#### Critical Bugs Fixed (5)

1. **Emoji characters missing** - Restored all 8 emoji endings (???????????)
2. **Broken regex in CONFIG_VALIDATOR** - Fixed `"\`r?\`n"`?`'[\r\n]+'`
3. **Broken regex in WelcomeMessage** - Same regex fix
4. **Confusing step numbering** - [1-8] instead of [1-2-2.5-3...]
5. **Missing section-aware parsing** - Added `$inMessagesSection` tracking

#### High-Priority Enhancements (5)

6. **Section validation** - Ensures [USER], [DATES], [MESSAGES] exist
7. **WELCOME_TIMEOUT validation** - Range check (5-300 seconds)
8. **MESSAGE length validation** - Max 200 characters per message
9. **Future-date validation** - ANNIVERSARY_DATE cannot be in future
10. **Error output visibility** - Removed piping to Out-Null

#### Medium-Priority Improvements (9)

11. **Registry path verification** - Read-back test after write
12. **Task verification enhancement** - Checks state, trigger, action
13. **UTF-8 BOM verification** - Validates file encoding
14. **Timer lifecycle fix** - FormClosing event handler
15. **Async sound playback** - PlayAsync instead of Play
16. **WhatIf uninstall mode** - Dry-run preview before deletion
17. **Theme color validation** - Verifies colors actually applied
18. **Installation timestamp** - Tracks when installed
19. **WAV format validation** - Checks RIFF/WAVE header

### Validation Improvements

- **Before v1.2:** 3 validation rules
- **After v1.2:** 11 validation rules (+267%)
- Comprehensive upfront checking
- User-friendly error messages

### Code Quality

- Better regex patterns (cross-platform compatible)
- Section-aware parsing prevents edge cases
- Async operations for responsive UI
- Proper resource cleanup
- Enhanced error handling

### Features Added/Enhanced

- ? Comprehensive config validation
- ? Registry verification
- ? Task scheduler verification
- ? Dry-run uninstall mode (-WhatIf)
- ? UTF-8 BOM checking
- ? WAV file format validation

### Breaking Changes

- ? None! Fully backward compatible with v1.0 and v1.1

### Upgrade Path

- v1.1 ? v1.2: In-place upgrade (2 minutes)
- v1.0 ? v1.2: Backup ? uninstall ? install (5 minutes)
- No data loss
- Config files work as-is

---

## v1.2.1 - Documentation Restructure Edition

**Release Date:** January 22, 2026  
**Status:** Current | No code changes

### Major Changes (Documentation Only)

#### ?? Documentation Reorganization

- **New folder structure:**
  - `NON_TECHNICAL_GUIDES/` - User-friendly guides (5 files)
  - `TECHNICAL_DOCS/` - Developer documentation (4 files)
  - `MIGRATION_AND_VERSIONS/` - Upgrade & version info (5 files)

#### ?? New Non-Technical User Guides

1. **QUICK_START.md** - 2-page 5-minute setup guide
2. **INSTALLATION_GUIDE.md** - Step-by-step [1/8] installation with Windows 10/11 callouts
3. **CONFIGURATION_GUIDE.md** - Edit config.txt with examples (Unicode, emoji, etc.)
4. **TROUBLESHOOTING.md** - Common issues & solutions
5. **UNINSTALL_GUIDE.md** - Safe removal with dry-run preview

#### ?? Master Documentation Index

- **DOCUMENTATION_INDEX.md** - Master routing guide by use case
- Quick navigation: "I want to install" ? specific guide
- Tech vs non-tech documentation separated
- Clear file structure overview

#### ? Improved README.md

- Updated for v1.2.1
- Points to new documentation structure
- Quick feature list
- Version info

#### ?? Version & Release Documentation

- **VERSION_HISTORY.md** - Complete timeline (this file)
- **v1.2.1_RELEASE_NOTES.md** - Maintenance release notes
- **WINDOWS_VERSIONS.md** - Windows 10 vs 11 compatibility guide

#### ?? Technical Documentation Created

- **TECHNICAL_REFERENCE.md** - Registry keys, specs, validation rules
- **ARCHITECTURE.md** - System design & code structure
- **v1.2_RELEASE_NOTES.md** - Official v1.2 technical release notes
- **BUG_FIXES_v1.2.md** - Moved to TECHNICAL_DOCS/

#### ?? Reorganized Files

- Moved `BUG_FIXES_v1.2.md` ? `TECHNICAL_DOCS/`
- Moved `v1.2_IMPLEMENTATION_STATUS.txt` ? `MIGRATION_AND_VERSIONS/`
- Removed `complete_package.md` (outdated v1.0 code samples)

### Code Changes

- ? **None!** Purely documentation restructure
- All v1.2 code/functionality unchanged
- No breaking changes
- 100% backward compatible

### Documentation Statistics

- **Total new/reorganized docs:** 12+ files
- **Total lines of documentation:** 2,000+ lines
- **Coverage areas:** Installation, configuration, troubleshooting, uninstall, tech reference, architecture

### Why v1.2.1?

- Significant documentation improvements warrant version bump
- Users benefit from better guides and clearer organization
- No code changes, so point-release (v1.2 ? v1.2.1)
- Future v1.3+ will include code enhancements

### Upgrade Path

- **v1.2 ? v1.2.1:** File-only update (copy new docs)
- **v1.1 ? v1.2.1:** Standard install (includes all docs)
- **v1.0 ? v1.2.1:** Backup ? uninstall ? install

---

## Feature Comparison Matrix

| Feature                   | v1.0 | v1.1         | v1.2          | v1.2.1           |
| ------------------------- | ---- | ------------ | ------------- | ---------------- |
| Welcome message           | ?   | ?           | ?            | ?               |
| Customizable messages     | ?   | ?           | ?            | ?               |
| Theme colors              | ?   | ?           | ?            | ?               |
| Optional sound            | ?   | ?           | ?            | ?               |
| Optional cursors          | ?   | ?           | ?            | ?               |
| Scheduled task            | ?   | ?           | ?            | ?               |
| Config validation         | ?   | ?           | ?            | ?               |
| Post-install verification | ?   | ?           | ?            | ?               |
| Uninstall script          | ?   | ?           | ?            | ?               |
| Portable (registry)       | ?   | ?           | ?            | ?               |
| Section-aware parsing     | ?   | ?           | ?            | ?               |
| Enhanced validation       | ?   | ? (3 rules) | ? (11 rules) | ? (11 rules)    |
| WhatIf dry-run            | ?   | ?           | ?            | ?               |
| Quick-start guide         | ?   | ?           | ?            | ?               |
| User-friendly docs        | ?   | Basic        | Basic         | ? Comprehensive |
| Technical docs            | ?   | ?           | ?            | ?               |

---

## Support Status

| Version    | Release      | Support | Status                           |
| ---------- | ------------ | ------- | -------------------------------- |
| **v1.0**   | Aug 2024     | Ended   | ? No longer supported           |
| **v1.1**   | Jan 21, 2026 | Limited | ?? Works but upgrade recommended |
| **v1.2**   | Jan 22, 2026 | Full    | ? Current stable                |
| **v1.2.1** | Jan 22, 2026 | Full    | ? **Recommended version**       |

---

## Upgrade Recommendations

### If You Have v1.0

?? **Upgrade to v1.2.1**

- Reason: Missing portability, validation, diagnostics
- Time: 5 minutes (backup ? uninstall ? install)
- Benefit: Better reliability, USB support, troubleshooting tools

### If You Have v1.1

?? **Upgrade to v1.2.1 (optional but recommended)**

- Reason: 19 bug fixes, better documentation
- Time: 2 minutes (in-place upgrade)
- Benefit: Bug fixes, better guides, easier troubleshooting

### If You Have v1.2

?? **Update to v1.2.1 (optional)**

- Reason: Documentation improvements only
- Time: 1 minute (copy new doc files)
- Benefit: Better guides, clearer organization
- Code: 100% identical to v1.2

---

## Future Plans (v1.3+)

### Planned Features (Post v1.2.1)

- Voice message playback with custom audio
- Dynamic wallpaper rotation
- Seasonal theme variations
- Scheduled message queue
- Calendar event integration
- Advanced sound customization
- Graphical configuration editor
- Multi-language support

### Not Planned (By Design)

- Cloud sync (intentionally local-only for privacy)
- Network features (local machines only)
- Admin dashboard (single-user app)

---

## Getting Help by Version

**v1.2.1 (Recommended):**

- [QUICK_START.md](../NON_TECHNICAL_GUIDES/QUICK_START.md) - 5-minute setup
- [INSTALLATION_GUIDE.md](../NON_TECHNICAL_GUIDES/INSTALLATION_GUIDE.md) - Detailed steps
- [DOCUMENTATION_INDEX.md](../DOCUMENTATION_INDEX.md) - Master guide

**v1.1 or earlier:**

- Upgrade to v1.2.1 for best documentation
- Or refer to README.txt for v1.1 info

---

## Summary

- **Best user experience:** v1.2.1 (current)
- **Most reliable:** v1.2 (all bugs fixed)
- **Most portable:** v1.1+ (USB-ready)
- **Legacy:** v1.0 (no longer recommended)

**Current recommendation: Use v1.2.1** ?

---

**Questions?** See [DOCUMENTATION_INDEX.md](../DOCUMENTATION_INDEX.md) or [FAQ.md](../FAQ.md)

