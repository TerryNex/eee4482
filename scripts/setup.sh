#!/bin/bash
# EEE4482 e-Library Setup Script for Linux/macOS
# Student: HE HUALIANG (230263367)
#
# This script helps with initial project setup and verification

set -e  # Exit on error

echo "=========================================="
echo "EEE4482 e-Library Setup Script"
echo "Student: HE HUALIANG (230263367)"
echo "=========================================="
echo ""

# Check if Flutter is installed
echo "🔍 Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo ""
    echo "Please install Flutter from: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Check if Git is installed
echo "🔍 Checking Git installation..."
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed or not in PATH"
    echo ""
    echo "Please install Git:"
    echo "  macOS: xcode-select --install"
    echo "  Linux: sudo apt-get install git"
    exit 1
fi

echo "✅ Git found: $(git --version)"
echo ""

# Run Flutter Doctor
echo "🏥 Running Flutter Doctor..."
flutter doctor -v
echo ""

# Install project dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get
echo ""

# Run analyzer
echo "🔍 Running Flutter analyzer..."
if flutter analyze; then
    echo "✅ No analysis issues found"
else
    echo "⚠️  Some analysis issues found (review above)"
fi
echo ""

# Check platform support
echo "📱 Checking platform support..."
flutter devices
echo ""

# Enable desktop support (if not already enabled)
echo "🖥️  Enabling desktop support..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    flutter config --enable-linux-desktop
    echo "✅ Linux desktop support enabled"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    flutter config --enable-macos-desktop
    echo "✅ macOS desktop support enabled"
fi
echo ""

echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Review README.md for detailed documentation"
echo "  2. Run the app: flutter run -d chrome"
echo "  3. For hot reload: press 'r' while app is running"
echo "  4. For hot restart: press 'R' while app is running"
echo ""
echo "Build for production:"
echo "  Web:    flutter build web --release"
echo "  Linux:  flutter build linux --release"
echo "  macOS:  flutter build macos --release"
echo ""
echo "Happy coding! 🚀"

