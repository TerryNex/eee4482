# GitHub Actions Workflows Usage Guide

**Student:** HE HUALIANG (230263367)

This document explains how to use the GitHub Actions workflows in this repository.

## Available Workflows

### 1. Flutter Multi-Platform Build

**File:** `.github/workflows/flutter-build.yml`

**Purpose:** Build the Flutter application for any supported platform (Web, Linux, macOS, Windows) without requiring a local Flutter installation.

**Trigger:** Manual workflow dispatch

---

## How to Use the Flutter Multi-Platform Build Workflow

### Step-by-Step Instructions

1. **Navigate to GitHub Actions**
   - Go to: https://github.com/TerryNex/eee4482
   - Click on the "Actions" tab at the top

2. **Select the Workflow**
   - In the left sidebar, click on "Flutter Multi-Platform Build"

3. **Run the Workflow**
   - Click the "Run workflow" dropdown button (right side)
   - You'll see a form with options:

4. **Select Platform**
   Choose one of the following platforms:
   - **web** - For web deployment (builds to JavaScript)
   - **linux** - For Linux desktop application
   - **macos** - For macOS desktop application  
   - **windows** - For Windows desktop application

5. **Start the Build**
   - Click the green "Run workflow" button
   - The workflow will start immediately

6. **Monitor Progress**
   - The workflow run will appear in the list
   - Click on it to see detailed logs
   - Build typically takes 5-15 minutes depending on platform

7. **Download Build Artifacts**
   - Once complete (green checkmark), click on the workflow run
   - Scroll down to the "Artifacts" section
   - Click to download the build artifact for your platform
   - File will be downloaded as a ZIP

8. **Extract and Deploy**
   - Extract the ZIP file
   - Follow deployment instructions in DEPLOYMENT.md for your platform

---

## Platform-Specific Build Details

### Web Build
- **Runner:** Ubuntu Latest
- **Build Command:** `flutter build web --release`
- **Artifact Name:** `web-build-[commit-sha]`
- **Contents:** Complete web application ready for Apache/Nginx deployment
- **Size:** ~10-15 MB
- **Deployment:** Upload contents to web server (see DEPLOYMENT.md)

### Linux Build
- **Runner:** Ubuntu Latest
- **Build Command:** `flutter build linux --release`
- **Artifact Name:** `linux-build-[commit-sha]`
- **Contents:** Executable Linux application bundle
- **Size:** ~30-40 MB
- **Dependencies:** GTK3, additional system libraries
- **Distribution:** Share bundle folder or create .deb package

### macOS Build
- **Runner:** macOS Latest
- **Build Command:** `flutter build macos --release`
- **Artifact Name:** `macos-build-[commit-sha]`
- **Contents:** .app bundle for macOS
- **Size:** ~25-35 MB
- **Requirements:** macOS 10.14 or later
- **Distribution:** Share .app or create DMG installer

### Windows Build
- **Runner:** Windows Latest
- **Build Command:** `flutter build windows --release`
- **Artifact Name:** `windows-build-[commit-sha]`
- **Contents:** Executable Windows application
- **Size:** ~20-30 MB
- **Requirements:** Windows 10 or later
- **Distribution:** Share Release folder or create installer

---

## Workflow Features

### Automatic Steps Performed

1. ✅ **Checkout Code** - Fetches the latest code from repository
2. ✅ **Setup Flutter** - Installs Flutter SDK 3.24.0 stable
3. ✅ **Verify Installation** - Runs `flutter doctor` to check setup
4. ✅ **Install Dependencies** - Runs `flutter pub get`
5. ✅ **Code Analysis** - Runs `flutter analyze` (continues on warnings)
6. ✅ **Platform Build** - Builds for selected platform
7. ✅ **Upload Artifacts** - Uploads build output (30-day retention)
8. ✅ **Build Summary** - Displays success message

### Benefits

- **No Local Setup Required** - Build without installing Flutter locally
- **Consistent Environment** - Same build environment every time
- **Multiple Platforms** - Build for any platform from any device
- **Artifact Storage** - Builds saved for 30 days
- **Build History** - Track all builds and their status
- **Parallel Development** - Team members can trigger builds independently

---

## Workflow Configuration

### Modifying the Workflow

If you need to customize the workflow:

1. Edit `.github/workflows/flutter-build.yml`
2. Common changes:
   - **Flutter Version:** Update `flutter-version: '3.24.0'`
   - **Artifact Retention:** Change `retention-days: 30`
   - **Build Options:** Modify build command (e.g., add `--web-renderer html`)

### Example Customizations

**Change Flutter Version:**
```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.27.0'  # Update to newer version
    channel: 'stable'
```

**Add Web Renderer Option:**
```yaml
- name: Build for Web
  if: github.event.inputs.platform == 'web'
  run: flutter build web --release --web-renderer html
```

**Extend Artifact Retention:**
```yaml
- name: Upload Web artifacts
  uses: actions/upload-artifact@v4
  with:
    retention-days: 90  # Keep for 90 days instead of 30
```

---

## Troubleshooting Workflow Issues

### Workflow Fails with "No matching devices found"
**Solution:** This is expected - the workflow doesn't need physical devices. The error is cosmetic if the build still succeeds.

### Workflow Fails with Dart/Flutter Errors
**Solution:** 
1. Check the error message in workflow logs
2. Fix the code issue locally
3. Commit and push the fix
4. Re-run the workflow

### Cannot Find Workflow
**Solution:** 
1. Ensure `.github/workflows/flutter-build.yml` exists
2. Check YAML syntax is valid
3. Ensure you're on the correct branch

### Artifact Download Link Expired
**Solution:** Artifacts are kept for 30 days. Re-run the workflow to generate new artifacts.

### Build Takes Too Long
**Expected Times:**
- Web: 5-7 minutes
- Linux: 7-10 minutes
- macOS: 10-15 minutes
- Windows: 8-12 minutes

If significantly longer, check GitHub Actions status page.

---

## Best Practices

1. **Use Descriptive Names** - When running workflows, note the purpose
2. **Tag Releases** - Tag commits before building for deployment
3. **Test Locally First** - Verify code works before using CI/CD
4. **Monitor Costs** - GitHub Actions has usage limits on free tier
5. **Clean Old Artifacts** - Delete artifacts you no longer need
6. **Document Changes** - Update CHANGELOG.md when building new versions

---

## GitHub Actions Limits

### Free Tier Limits (Public Repository)
- ✅ Unlimited build minutes for public repositories
- ✅ Unlimited workflow runs
- ✅ Artifacts stored for 30 days (configurable)

### Storage Limits
- 500 MB per artifact (plenty for Flutter apps)
- Total artifact storage depends on GitHub plan

---

## Future Workflow Enhancements

Potential additions:

1. **Automatic Deployment** - Deploy to server automatically after build
2. **Testing** - Run unit and widget tests before building
3. **Code Coverage** - Generate coverage reports
4. **Release Creation** - Automatically create GitHub releases
5. **Multi-Platform Matrix** - Build all platforms in one run
6. **Notifications** - Send build status to email/Slack

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Guide](https://docs.flutter.dev/deployment/cd)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)

---

## Support

For issues with workflows:
1. Check workflow logs for detailed error messages
2. Verify YAML syntax using online validators
3. Consult GitHub Actions documentation
4. Ask in course forums or contact instructor

---

**Created by:** HE HUALIANG (230263367)  
**Last Updated:** 2025-11-01
