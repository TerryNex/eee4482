# Setup Verification Checklist

**Student:** HE HUALIANG (230263367)  
**Project:** EEE4482 e-Library Flutter Application

Use this checklist to verify your development environment is properly configured.

---

## Pre-Setup Requirements

### System Requirements
- [ ] Computer meets minimum RAM requirements (4GB+, 8GB recommended)
- [ ] Sufficient disk space available (5GB+ free space)
- [ ] Operating system is up to date
- [ ] Internet connection available for downloading dependencies

---

## Installation Verification

### Flutter SDK
- [ ] Flutter SDK downloaded and extracted
- [ ] Flutter bin directory added to PATH
- [ ] Terminal/Command Prompt restarted after PATH update
- [ ] `flutter --version` command works
- [ ] Flutter version is 3.24.0 or later

**Test Command:**
```bash
flutter --version
```

**Expected Output:** Should show Flutter version without errors

### Git
- [ ] Git installed
- [ ] `git --version` command works
- [ ] Git configured with username: `git config user.name`
- [ ] Git configured with email: `git config user.email`

**Test Command:**
```bash
git --version
```

**Expected Output:** Should show Git version

### Code Editor (VS Code)
- [ ] Visual Studio Code installed
- [ ] Flutter extension installed in VS Code
- [ ] Dart extension automatically installed with Flutter extension
- [ ] Extensions are enabled and active

**Verification:**
- Open VS Code
- Press Ctrl+Shift+X (Cmd+Shift+X on macOS)
- Search for "Flutter"
- Should show "Flutter" extension as installed

---

## Flutter Doctor Checks

Run `flutter doctor -v` and verify:

- [ ] Flutter version shows (should be green ✓)
- [ ] Dart version shows (should be green ✓)
- [ ] Chrome/Web browser detected (if developing for web)
- [ ] Visual Studio Code detected (if installed)

**Test Command:**
```bash
flutter doctor -v
```

**Expected Output Example:**
```
[✓] Flutter (Channel stable, 3.24.0, on ...)
[✓] Chrome - develop for the web
[✓] VS Code (version X.X.X)
```

**Note:** You may see warnings for Android Studio, Android SDK, or Xcode if not installed. These are optional unless building for mobile platforms.

---

## Project Setup Verification

### Repository Clone
- [ ] Repository cloned successfully
- [ ] Can navigate to project directory
- [ ] All files visible (lib, docs, .github, etc.)

**Test Commands:**
```bash
git clone https://github.com/TerryNex/eee4482.git
cd eee4482
ls -la  # Linux/macOS
dir     # Windows
```

### Dependencies Installation
- [ ] `flutter pub get` runs without errors
- [ ] All dependencies downloaded
- [ ] `pubspec.lock` file created/updated
- [ ] `.dart_tool` directory created

**Test Command:**
```bash
flutter pub get
```

**Expected Output:**
```
Running "flutter pub get" in eee4482...
Resolving dependencies...
Got dependencies!
```

### Code Analysis
- [ ] `flutter analyze` runs without critical errors
- [ ] No blocking issues reported
- [ ] Only info/warnings at most (some are okay)

**Test Command:**
```bash
flutter analyze
```

**Expected Output:**
```
Analyzing eee4482...
No issues found!
```

---

## Running the Application

### Web Platform (Recommended for Testing)
- [ ] Chrome browser installed
- [ ] `flutter devices` shows Chrome
- [ ] Can run app with `flutter run -d chrome`
- [ ] Application launches in browser
- [ ] No console errors in terminal
- [ ] Home page displays correctly
- [ ] Student information shows: "HE HUALIANG (230263367)"

**Test Commands:**
```bash
flutter devices
flutter run -d chrome
```

**Expected:** Application opens in Chrome browser

### Desktop Platform (If Applicable)

#### Linux
- [ ] Desktop support enabled: `flutter config --enable-linux-desktop`
- [ ] Required libraries installed (GTK3, etc.)
- [ ] `flutter devices` shows Linux desktop
- [ ] Can run app with `flutter run -d linux`

#### macOS
- [ ] Desktop support enabled: `flutter config --enable-macos-desktop`
- [ ] Xcode installed (if required)
- [ ] `flutter devices` shows macOS desktop
- [ ] Can run app with `flutter run -d macos`

#### Windows
- [ ] Desktop support enabled: `flutter config --enable-windows-desktop`
- [ ] Visual Studio 2022 with C++ tools installed (if required)
- [ ] `flutter devices` shows Windows desktop
- [ ] Can run app with `flutter run -d windows`

---

## Development Features

### Hot Reload
- [ ] Application running
- [ ] Make a small change to `lib/main.dart`
- [ ] Press `r` in terminal
- [ ] Change appears without full restart

**Test:**
1. Run `flutter run -d chrome`
2. Change text color in code
3. Press `r`
4. See update immediately

### Hot Restart
- [ ] Application running
- [ ] Press `R` in terminal
- [ ] Application restarts fully
- [ ] State resets to initial

**Test:**
1. Run application
2. Navigate to different page
3. Press `R`
4. App returns to home page

---

## Build Verification

### Web Build
- [ ] `flutter build web --release` completes successfully
- [ ] Build output in `build/web/` directory
- [ ] `index.html` file exists
- [ ] `main.dart.js` file exists
- [ ] Built app works when served locally

**Test Commands:**
```bash
flutter build web --release
cd build/web
python3 -m http.server 8000  # Linux/macOS
# or
python -m http.server 8000   # Windows
```

**Verification:** Visit http://localhost:8000 in browser

### Desktop Build (Optional)

#### Linux Build
- [ ] `flutter build linux --release` completes
- [ ] Output in `build/linux/x64/release/bundle/`
- [ ] Executable file present
- [ ] App runs: `./build/linux/x64/release/bundle/eee4482_flutter_app1`

#### macOS Build
- [ ] `flutter build macos --release` completes
- [ ] .app bundle created
- [ ] App opens when double-clicked

#### Windows Build
- [ ] `flutter build windows --release` completes
- [ ] Output in `build/windows/x64/runner/Release/`
- [ ] .exe file present
- [ ] App runs when double-clicked

---

## GitHub Actions Verification

### Workflow Accessibility
- [ ] Can access https://github.com/TerryNex/eee4482
- [ ] Can see "Actions" tab
- [ ] "Flutter Multi-Platform Build" workflow visible
- [ ] Can click "Run workflow"
- [ ] Platform options show: Web, Linux, macOS, Windows

### Test Build (Optional)
- [ ] Triggered a test build
- [ ] Build starts and shows progress
- [ ] Build completes successfully (green checkmark)
- [ ] Artifacts section shows build output
- [ ] Can download artifact
- [ ] Artifact contains expected files

---

## Documentation Verification

### Files Existence
- [ ] README.md exists and opens
- [ ] QUICKSTART.md exists
- [ ] DEPLOYMENT.md exists
- [ ] CONTRIBUTING.md exists
- [ ] CHANGELOG.md exists
- [ ] PROJECT_SUMMARY.md exists
- [ ] .github/workflows/flutter-build.yml exists

### Content Verification
- [ ] README.md displays correctly on GitHub
- [ ] Student information visible in documentation
- [ ] Version number shows as V1.0
- [ ] Links in documentation work
- [ ] Code examples have syntax highlighting

---

## Feature Verification

### Home Page
- [ ] Opens successfully
- [ ] Shows "EEE4482 e-Library" title
- [ ] Shows "Welcome, HE HUALIANG (230263367)"
- [ ] Navigation bar visible
- [ ] Can navigate to other pages

### Add Book Page
- [ ] Accessible from navigation
- [ ] Form displays correctly
- [ ] Input fields present
- [ ] Layout looks professional

### Book List Page
- [ ] Accessible from navigation
- [ ] Page loads without errors
- [ ] Shows borrower: "HE HUALIANG (230263367)"
- [ ] Layout looks correct

---

## Common Issues Check

### Issue: "flutter: command not found"
- [ ] Verified Flutter in PATH
- [ ] Restarted terminal
- [ ] Can run `echo $PATH` and see Flutter bin directory

### Issue: "No devices found"
- [ ] Chrome installed (for web)
- [ ] Desktop support enabled (for desktop)
- [ ] `flutter devices` shows at least one device

### Issue: "Pub get failed"
- [ ] Internet connection working
- [ ] No firewall blocking Flutter
- [ ] Tried `flutter clean` then `flutter pub get`

### Issue: Build failures
- [ ] Ran `flutter clean`
- [ ] Ran `flutter pub get`
- [ ] Checked `flutter doctor` for issues
- [ ] Reviewed error messages

---

## Final Verification

### Complete Setup
- [ ] All above sections checked and working
- [ ] Can develop and test changes
- [ ] Can build for at least one platform
- [ ] Documentation is readable and helpful
- [ ] Ready to start development work

### Optional Advanced Setup
- [ ] Setup scripts tested (`setup.sh` or `setup.bat`)
- [ ] GitHub Actions workflow tested
- [ ] Multiple platforms configured
- [ ] Version control configured (git user.name, user.email)

---

## Next Steps

After completing this checklist:

1. **If all checks pass:**
   - ✅ You're ready to develop!
   - Start with QUICKSTART.md for fast development
   - Or read README.md for comprehensive guide
   - Begin making changes and using hot reload

2. **If some checks fail:**
   - Review the specific failed section
   - Check troubleshooting section in README.md
   - Re-run setup steps for that component
   - Verify system requirements are met

3. **For deployment:**
   - Read DEPLOYMENT.md thoroughly
   - Complete build verification first
   - Follow platform-specific deployment steps
   - Verify deployment with provided checklists

---

## Quick Reference Commands

```bash
# Verify Flutter installation
flutter --version
flutter doctor -v

# Install dependencies
flutter pub get

# Check for code issues
flutter analyze

# Run application
flutter run -d chrome          # Web
flutter run -d linux           # Linux
flutter run -d macos           # macOS  
flutter run -d windows         # Windows

# Build for production
flutter build web --release    # Web
flutter build linux --release  # Linux
flutter build macos --release  # macOS
flutter build windows --release # Windows

# Clean build artifacts
flutter clean

# Update dependencies
flutter pub upgrade
```

---

## Support

If you encounter issues not covered in this checklist:

1. **Check Documentation:**
   - README.md troubleshooting section
   - DEPLOYMENT.md common issues
   - PROJECT_SUMMARY.md

2. **Run Diagnostics:**
   - `flutter doctor -v` for detailed status
   - `flutter analyze` for code issues
   - Check terminal error messages

3. **Get Help:**
   - Course instructor/TA
   - Flutter documentation: https://docs.flutter.dev/
   - GitHub Issues for project-specific problems

---

**Checklist Version:** V1.0  
**Last Updated:** 2025-11-01  
**Created by:** HE HUALIANG (230263367)

---

## Checklist Status

- [ ] Started setup process
- [ ] Completed pre-setup requirements
- [ ] Completed installation verification
- [ ] Completed Flutter doctor checks
- [ ] Completed project setup
- [ ] Completed running application
- [ ] Completed development features test
- [ ] Completed build verification
- [ ] **Ready for development! 🚀**
