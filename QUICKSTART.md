# Quick Start Guide - EEE4482 e-Library

**Student:** HE HUALIANG (230263367)

This guide will get you up and running in **5 minutes**!

## Prerequisites

- **Flutter SDK 3.24.0+** installed and in PATH
- **Git** installed
- **Chrome** browser (for web development)

## Quick Setup (All Platforms)

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/TerryNex/eee4482.git
cd eee4482

# Install dependencies
flutter pub get
```

### 2. Verify Installation

```bash
# Check Flutter setup
flutter doctor

# Check for issues
flutter analyze
```

### 3. Run the Application

```bash
# Run in Chrome (recommended for quick testing)
flutter run -d chrome

# Or run on your desktop platform
flutter run -d linux      # Linux
flutter run -d macos      # macOS
flutter run -d windows    # Windows
```

### 4. Development Tips

While the app is running:
- **Hot Reload**: Press `r` (apply code changes instantly)
- **Hot Restart**: Press `R` (full app restart)
- **Quit**: Press `q`

## Automated Setup Scripts

For a guided setup experience, use the provided scripts:

### Linux / macOS
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### Windows
```cmd
scripts\setup.bat
```

These scripts will:
- ✅ Verify Flutter and Git installation
- ✅ Install project dependencies
- ✅ Run Flutter doctor to check setup
- ✅ Enable desktop platform support
- ✅ Verify code with analyzer

## Building for Production

Choose your target platform:

```bash
# Web (recommended for deployment)
flutter build web --release

# Linux Desktop
flutter build linux --release

# macOS Desktop
flutter build macos --release

# Windows Desktop
flutter build windows --release
```

Build outputs:
- **Web**: `build/web/`
- **Linux**: `build/linux/x64/release/bundle/`
- **macOS**: `build/macos/Build/Products/Release/`
- **Windows**: `build/windows/x64/runner/Release/`

## Common Commands

```bash
# Install dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Check for issues
flutter analyze

# Format code
dart format .

# Clean build files
flutter clean

# Rebuild
flutter pub get
flutter run
```

## GitHub Actions (Automated Builds)

Don't have Flutter installed locally? Use GitHub Actions!

1. Go to: https://github.com/TerryNex/eee4482/actions
2. Click "Flutter Multi-Platform Build"
3. Click "Run workflow"
4. Select your platform (Web, Linux, macOS, Windows)
5. Click "Run workflow"
6. Wait for completion (~5-15 minutes)
7. Download the build artifact

## Troubleshooting Quick Fixes

### "flutter: command not found"
- **Fix**: Ensure Flutter bin directory is in your PATH
- **Windows**: Add `C:\Flutter SDK\flutter\bin` to system PATH
- **Linux/macOS**: Add to `.bashrc` or `.zshrc`

### "No devices found"
- **Fix**: For web development: Install Chrome
- **Fix**: For desktop: Enable platform support
  ```bash
  flutter config --enable-linux-desktop    # Linux
  flutter config --enable-macos-desktop    # macOS
  flutter config --enable-windows-desktop  # Windows
  ```

### Build fails with missing packages
- **Fix**: Run `flutter clean && flutter pub get`

### CORS errors in development
- **Solution**: Use a development proxy (see [Configuration Guide](docs/CONFIGURATION_GUIDE.md))
- **Alternative**: Deploy to server for production

## Configuration

For API and Proxy settings:
- **Quick Config**: Use Settings page (gear icon) in the app
- **Detailed Guide**: See [Configuration Guide](docs/CONFIGURATION_GUIDE.md)
- **Database Setup**: See [Database README](database/README.md)

## Need More Help?

📖 **Full Documentation**: See [README.md](README.md)

⚙️ **Configuration Guide**: See [Configuration Guide](docs/CONFIGURATION_GUIDE.md)

🗄️ **Database Setup**: See [Database README](database/README.md)

📚 **Project Requirements**: See `docs/Worksheet7g_v1.3.docx`

🤝 **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)

🐛 **Issues**: Report at https://github.com/TerryNex/eee4482/issues

## What's Next?

1. ✅ **Explore the Code**: Check out `lib/` directory
2. ✅ **Read the Docs**: Full README has detailed instructions
3. ✅ **Make Changes**: Use hot reload for fast development
4. ✅ **Deploy**: Build and deploy to your server

---

**Happy Coding! 🚀**

*Last Updated: 2025-11-01*  
*Maintained by: HE HUALIANG (230263367)*
