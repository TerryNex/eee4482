# EEE4482 e-Library Flutter Application

**Version:** V1.1  
**Student:** HE HUALIANG  
**Student ID:** 230263367  
**Course:** EEE 4482 - Server Installation and Programming

A multi-platform Flutter application for managing an e-library system with support for Web, Linux, macOS, and Windows platforms.

**✨ New in V1.1:**
- 🌐 Robust API calls with error handling and timeout settings
- 🔒 Authentication support with Bearer tokens
- 🔄 Dynamic proxy configuration for different network scenarios
- ✅ Comprehensive input validation (frontend + backend)
- 🎨 Multiple UI themes (GitHub High Contrast, JetBrains IDE, Xcode)
- ⚙️ Settings page for API, proxy, and theme configuration

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Requirements](#system-requirements)
- [Installation & Setup](#installation--setup)
- [Development Guide](#development-guide)
- [Building for Production](#building-for-production)
- [Deployment](#deployment)
- [GitHub Actions CI/CD](#github-actions-cicd)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)
- [Version History](#version-history)

---

## 🎯 Overview

This Flutter application is an e-library management system developed as part of the EEE4482 coursework (Worksheet 7g). It provides a user-friendly interface for browsing books, adding new books, and managing library resources. The application connects to a backend API (built in Worksheet 7b) for data persistence.

---

## ✨ Features

### Core Functionality
- **Book Management**: Browse, add, update, and delete books in the library
- **API Integration**: Full RESTful API integration with backend server
- **Student Information**: Displays borrower information (HE HUALIANG - 230263367)

### API & Network (NEW in V1.1)
- **Robust API Calls**: Comprehensive error handling with timeout settings
- **Authentication**: Bearer token authentication support
- **Proxy Support**: Configurable proxy for development and corporate networks
- **Error Recovery**: Graceful error handling with user-friendly messages

### Input Validation (NEW in V1.1)
- **Real-time Validation**: Immediate feedback on form inputs
- **Comprehensive Rules**: Email, ISBN, date, and custom format validation
- **Clear Error Messages**: Specific, actionable error descriptions
- **Frontend + Backend**: Validation at both application layers

### UI & Theming (NEW in V1.1)
- **Multiple Themes**: Choose from 4 professional themes:
  - Default (Material Design 3)
  - GitHub High Contrast (Dark, accessibility-focused)
  - JetBrains IDE (Darcula theme)
  - Xcode (macOS developer tools style)
- **Theme Persistence**: Your choice is saved across sessions
- **Instant Switching**: Change themes without restarting

### Platform Support
- **Multi-Platform**: Build for Web, Linux, macOS, or Windows
- **Responsive Design**: Adapts to different screen sizes
- **Cross-platform Consistency**: Same features on all platforms

---

## 💻 System Requirements

### For Development

#### Windows
- **OS**: Windows 10 or later (64-bit)
- **RAM**: Minimum 4GB (8GB+ recommended)
- **Disk Space**: 2.5GB for Flutter SDK + 1GB for IDE
- **Software**: 
  - Git for Windows
  - Visual Studio Code (recommended) or Android Studio
  - PowerShell 5.0 or later

#### macOS
- **OS**: macOS 10.14 (Mojave) or later
- **RAM**: Minimum 4GB (8GB+ recommended)
- **Disk Space**: 2.5GB for Flutter SDK + 1GB for IDE
- **Xcode**: Latest stable version (for macOS builds)

#### Linux
- **OS**: 64-bit Ubuntu 20.04 LTS or later (Debian-based)
- **RAM**: Minimum 4GB (8GB+ recommended)
- **Disk Space**: 2.5GB for Flutter SDK + 1GB for IDE
- **Dependencies**: 
  - bash, curl, git, unzip, which
  - libgtk-3-dev, clang, cmake, ninja-build, pkg-config

### For Production Deployment
- Web server (Apache, Nginx, etc.) for Web deployment
- Target platform OS for desktop deployments

---

## 🚀 Installation & Setup

### Step 1: Install Flutter SDK

#### Windows Installation

1. **Download Flutter SDK**
   - Visit: https://docs.flutter.dev/get-started/install/windows
   - Download Flutter SDK v3.24.0 or later
   - Recommended: Extract to `C:\Flutter SDK\flutter_windows_3.24.0-stable\flutter`

2. **Configure Environment Variables**
   ```
   a. Press Win + R, type 'sysdm.cpl', press Enter
   b. Go to "Advanced" tab → "Environment Variables"
   c. Under "User variables" or "System variables", select "Path" → "Edit"
   d. Click "New" and add: C:\Flutter SDK\flutter_windows_3.24.0-stable\flutter\bin
   e. Click "OK" to save
   ```

3. **Verify Installation**
   ```cmd
   flutter --version
   flutter doctor
   ```

#### macOS Installation

1. **Download Flutter SDK**
   ```bash
   cd ~/development
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.24.0-stable.zip
   unzip flutter_macos_3.24.0-stable.zip
   ```

2. **Add to PATH**
   ```bash
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Verify Installation**
   ```bash
   flutter --version
   flutter doctor
   ```

#### Linux Installation

1. **Download Flutter SDK**
   ```bash
   cd ~/development
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
   tar xf flutter_linux_3.24.0-stable.tar.xz
   ```

2. **Add to PATH**
   ```bash
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. **Install Dependencies**
   ```bash
   sudo apt-get update
   sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev
   ```

4. **Verify Installation**
   ```bash
   flutter --version
   flutter doctor
   ```

### Step 2: Install Git

#### Windows
- Download and install from: https://git-scm.com/download/win
- During installation, select "Git from the command line and also from 3rd-party software"
- Add Git to PATH if not automatically done

#### macOS
```bash
xcode-select --install
```

#### Linux
```bash
sudo apt-get install git
```

### Step 3: Clone the Repository

```bash
git clone https://github.com/TerryNex/eee4482.git
cd eee4482
```

### Step 4: Install Project Dependencies

```bash
flutter pub get
```

### Step 5: Verify Setup

```bash
flutter doctor -v
flutter analyze
```

---

## 🛠️ Development Guide

### Setting Up Visual Studio Code

1. **Install VS Code**
   - Download from: https://code.visualstudio.com/

2. **Install Flutter Extension**
   ```
   a. Open VS Code
   b. Press Ctrl+Shift+X (or Cmd+Shift+X on macOS)
   c. Search for "Flutter"
   d. Click "Install" on the Flutter extension (by Dart Code)
   ```

3. **Open Project**
   ```
   a. File → Open Folder
   b. Select the eee4482 directory
   ```

### Running the Application in Development Mode

#### Web Development (Recommended for Testing)

```bash
flutter run -d chrome
```

or in VS Code:
- Press F5
- Select "Chrome" as the device

#### Desktop Development

**Linux:**
```bash
flutter run -d linux
```

**macOS:**
```bash
flutter run -d macos
```

**Windows:**
```bash
flutter run -d windows
```

### Development Proxy for CORS Issues

When developing locally and connecting to a backend API, you may encounter CORS issues. Use the development proxy to bypass these:

1. **Configure the Proxy** (if proxy file exists in your project)
   - Update the proxy configuration with your server IP address
   - Example: Change `serverIp` to your backend server IP

2. **Run the Proxy**
   ```bash
   dart run tools/proxy.dart
   ```
   *(Note: Create a proxy.dart file as needed based on Worksheet 7g instructions)*

3. **Run Your Flutter App**
   ```bash
   flutter run -d chrome
   ```

### Hot Reload and Hot Restart

While the app is running:
- **Hot Reload**: Press `r` in terminal (or save file in VS Code)
- **Hot Restart**: Press `R` in terminal
- **Quit**: Press `q` in terminal

---

## 📦 Building for Production

### Web Build

```bash
flutter build web --release
```

Output directory: `build/web/`

### Linux Build

```bash
flutter build linux --release
```

Output directory: `build/linux/x64/release/bundle/`

### macOS Build

```bash
flutter build macos --release
```

Output directory: `build/macos/Build/Products/Release/`

### Windows Build

```bash
flutter build windows --release
```

Output directory: `build/windows/x64/runner/Release/`

---

## 🌐 Deployment

### Web Deployment to Apache Server

1. **Build the Application**
   ```bash
   flutter build web --release
   ```

2. **Locate Build Files**
   - All files are in: `build/web/`

3. **Deploy to Server**
   
   **Option A: Using FileZilla (GUI)**
   ```
   a. Install FileZilla Client
   b. Connect to your server via SFTP
      - Host: Your server IP (e.g., 192.168.1.100)
      - Username: Your server username
      - Password: Your server password
      - Port: 22 (for SFTP)
   c. Navigate to local: build/web/
   d. Navigate to remote: /var/www/html/
   e. Upload all files and folders from build/web/ to /var/www/html/
   ```

   **Option B: Using SCP (Command Line)**
   ```bash
   scp -r build/web/* username@server-ip:/var/www/html/
   ```

4. **Test Deployment**
   - Open browser
   - Navigate to: `http://your-server-ip/`
   - The e-library application should load

### Desktop Application Deployment

For desktop platforms, distribute the build output directory:
- **Linux**: Share the entire `build/linux/x64/release/bundle/` folder
- **macOS**: Share the `.app` file from `build/macos/Build/Products/Release/`
- **Windows**: Share the entire `build/windows/x64/runner/Release/` folder

---

## 🤖 GitHub Actions CI/CD

### Manual Build Workflow

This project includes a GitHub Actions workflow for building the Flutter application on any platform.

#### How to Use:

1. **Navigate to GitHub Actions**
   - Go to: https://github.com/TerryNex/eee4482/actions
   - Click on "Flutter Multi-Platform Build"

2. **Run Workflow**
   - Click "Run workflow" dropdown
   - Select your desired platform:
     - **Web**: For web deployment
     - **Linux**: For Linux desktop app
     - **macOS**: For macOS desktop app
     - **Windows**: For Windows desktop app
   - Click "Run workflow" button

3. **Download Build Artifacts**
   - Wait for the workflow to complete (5-15 minutes depending on platform)
   - Click on the completed workflow run
   - Scroll to "Artifacts" section
   - Download the build artifact for your platform
   - Extract and deploy as needed

### Workflow Features:
- ✅ Automatic Flutter installation and configuration
- ✅ Platform-specific build optimization
- ✅ Build artifact upload (30-day retention)
- ✅ Flutter analyzer checks
- ✅ Cross-platform support (Linux, macOS, Windows, Web)

---

## 🔧 Troubleshooting

### Common Issues

#### Issue: "flutter: command not found"
**Solution:**
- Verify Flutter is in your PATH
- Restart terminal/command prompt after adding to PATH
- Windows: Reboot may be required after PATH changes

#### Issue: "Flutter Doctor shows errors"
**Solution:**
- Run: `flutter doctor -v` to see detailed errors
- Install missing dependencies as indicated
- Android licenses (if needed): `flutter doctor --android-licenses`

#### Issue: CORS errors when connecting to backend API
**Solution:**
- Use the development proxy (see Development Guide)
- Configure backend server to allow CORS headers
- For production, deploy to same domain as backend

#### Issue: Build fails with "no connected devices"
**Solution:**
- For web: Install Chrome or use `flutter run -d web-server`
- For desktop: Enable desktop support:
  ```bash
  flutter config --enable-windows-desktop  # Windows
  flutter config --enable-macos-desktop    # macOS
  flutter config --enable-linux-desktop    # Linux
  ```

#### Issue: Linux build fails with missing libraries
**Solution:**
```bash
sudo apt-get update
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
```

#### Issue: macOS build fails with Xcode errors
**Solution:**
- Install latest Xcode from App Store
- Run: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
- Accept license: `sudo xcodebuild -license accept`

#### Issue: Windows build fails with Visual Studio errors
**Solution:**
- Install Visual Studio 2022 with "Desktop development with C++" workload
- Ensure Flutter can find Visual Studio:
  ```cmd
  flutter doctor -v
  ```

### Getting Help

- Flutter Documentation: https://docs.flutter.dev/
- Flutter Community: https://flutter.dev/community
- GitHub Issues: https://github.com/TerryNex/eee4482/issues

---

## ⚙️ Configuration (NEW in V1.1)

### API Configuration

Configure your backend API server in the Settings page or programmatically:

```dart
// In lib/config/api_config.dart
ApiConfig.baseUrl = 'http://your-server-ip/api/public';
```

**Default API Base URL**: `http://192.168.1.100/api/public`

### Proxy Configuration

For development or corporate networks requiring a proxy:

1. Navigate to Settings page (gear icon)
2. Enable "Use Proxy"
3. Enter proxy host and port
4. Click "Save Settings"

**Use Cases:**
- CORS bypass during development
- Corporate network proxy requirements
- Testing with different network configurations

### Theme Selection

Choose your preferred UI theme:

1. Go to Settings page
2. Select from available themes:
   - **Default**: Material Design 3 with warm colors
   - **GitHub High Contrast**: Dark theme, high accessibility
   - **JetBrains IDE**: Darcula theme for developers
   - **Xcode**: Light theme, macOS style
3. Theme applies immediately and persists across sessions

### API Endpoints

The application uses the following endpoints:

- `GET /books` - Fetch all books
- `POST /books/add` - Add a new book
- `PUT /books/update/:id` - Update a book
- `DELETE /books/delete/:id` - Delete a book

For detailed API documentation, see `docs/API_PROXY_VALIDATION_GUIDE.md`

---

## 📁 Project Structure

```
eee4482/
├── .github/
│   └── workflows/
│       └── flutter-build.yml          # CI/CD workflow for multi-platform builds
├── docs/                              # Project documentation and worksheets
│   ├── Worksheet7g_v1.3.docx         # Main project requirements
│   ├── API_PROXY_VALIDATION_GUIDE.md # NEW: API, proxy, validation guide
│   └── ...
├── lib/
│   ├── main.dart                      # Application entry point
│   ├── config/                        # NEW: Configuration
│   │   ├── api_config.dart           # API and proxy configuration
│   │   └── settings_provider.dart    # Settings state management
│   ├── pages/                         # Application pages/screens
│   │   ├── home_page.dart            # Home page (displays student info)
│   │   ├── add_book_page.dart        # Add new book page
│   │   ├── booklist_page.dart        # Book list page
│   │   └── settings_page.dart        # NEW: Settings page
│   ├── services/                      # NEW: API services
│   │   ├── api_service.dart          # HTTP client with error handling
│   │   └── book_service.dart         # Book-related API operations
│   ├── themes/                        # NEW: Theme management
│   │   ├── app_themes.dart           # Theme definitions
│   │   └── theme_provider.dart       # Theme state management
│   ├── utils/                         # NEW: Utilities
│   │   └── validators.dart           # Input validation functions
│   └── widgets/                       # Reusable UI components
│       ├── book_form.dart            # Book form widget (with validation)
│       ├── input_box.dart            # Input field widget (with validation)
│       └── navigation_frame.dart     # Navigation layout widget
├── web/                               # Web-specific files
├── linux/                             # Linux-specific files
├── macos/                             # macOS-specific files
├── windows/                           # Windows-specific files
├── test/                              # Unit and widget tests
├── pubspec.yaml                       # Project dependencies and metadata
├── analysis_options.yaml              # Dart analyzer configuration
├── .gitignore                         # Git ignore rules
└── README.md                          # This file
```

---

## 📚 Additional Resources

### Flutter Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design 3](https://m3.material.io/)

### Course Materials
- Refer to `docs/Worksheet7g_v1.3.docx` for detailed project requirements
- Additional worksheets in `docs/` folder for context and background

### NEW: API & Feature Documentation (V1.1)
- **[API, Proxy & Validation Guide](docs/API_PROXY_VALIDATION_GUIDE.md)** - Comprehensive guide for:
  - API calls with error handling
  - Proxy configuration
  - Input validation
  - UI themes
  - Code examples and best practices

### Development Tools
- [Visual Studio Code](https://code.visualstudio.com/)
- [Android Studio](https://developer.android.com/studio)
- [Flutter DevTools](https://docs.flutter.dev/tools/devtools)

---

## 📝 Version History

### V1.1 (Current Release - 2025-11-02)
- ✅ **API Calls**: Robust HTTP client with error handling, timeouts, and authentication
- ✅ **Proxy Support**: Configurable proxy for development and corporate networks
- ✅ **Input Validation**: Comprehensive validation with real-time feedback
- ✅ **Multiple Themes**: 4 professional themes (Default, GitHub, JetBrains, Xcode)
- ✅ **Settings Page**: Configure API, proxy, and theme preferences
- ✅ **Enhanced Book Form**: Full CRUD operations with validation
- ✅ **Documentation**: Comprehensive API and feature guide
- ✅ **State Management**: Provider-based architecture
- ✅ **Settings Persistence**: SharedPreferences for user preferences

### V1.0 (Initial Release - 2025-11-01)
- ✅ Basic e-library functionality (browse, add books)
- ✅ Student information integration (HE HUALIANG - 230263367)
- ✅ Multi-platform support (Web, Linux, macOS, Windows)
- ✅ GitHub Actions CI/CD workflow
- ✅ Comprehensive documentation and setup guide
- ✅ Material Design 3 UI

---

## 👨‍🎓 Student Information

**Name:** HE HUALIANG  
**Student ID:** 230263367  
**Course:** EEE 4482 - Server Installation and Programming  
**Institution:** [Your Institution Name]  
**Academic Year:** 2024/2025

---

## 📄 License

This project is developed for educational purposes as part of the EEE4482 course.

---

## 🙏 Acknowledgments

- Course instructors and teaching assistants
- Flutter team for the excellent framework
- Open source community for various packages and tools

---

**Last Updated:** 2025-11-01  
**Maintained by:** HE HUALIANG (230263367)
