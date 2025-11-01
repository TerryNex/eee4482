@echo off
REM EEE4482 e-Library Setup Script for Windows
REM Student: HE HUALIANG (230263367)
REM
REM This script helps with initial project setup and verification

echo ==========================================
echo EEE4482 e-Library Setup Script
echo Student: HE HUALIANG (230263367)
echo ==========================================
echo.

REM Check if Flutter is installed
echo Checking Flutter installation...
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo.
    echo Please install Flutter from: https://docs.flutter.dev/get-started/install/windows
    pause
    exit /b 1
)

echo Flutter found:
flutter --version | findstr /C:"Flutter"
echo.

REM Check if Git is installed
echo Checking Git installation...
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git is not installed or not in PATH
    echo.
    echo Please install Git from: https://git-scm.com/download/win
    pause
    exit /b 1
)

echo Git found:
git --version
echo.

REM Run Flutter Doctor
echo Running Flutter Doctor...
flutter doctor -v
echo.

REM Install project dependencies
echo Installing Flutter dependencies...
flutter pub get
echo.

REM Run analyzer
echo Running Flutter analyzer...
flutter analyze
if %ERRORLEVEL% EQU 0 (
    echo No analysis issues found
) else (
    echo Some analysis issues found (review above)
)
echo.

REM Check platform support
echo Checking platform support...
flutter devices
echo.

REM Enable Windows desktop support
echo Enabling Windows desktop support...
flutter config --enable-windows-desktop
echo Windows desktop support enabled
echo.

echo ==========================================
echo Setup Complete!
echo ==========================================
echo.
echo Next steps:
echo   1. Review README.md for detailed documentation
echo   2. Run the app: flutter run -d chrome
echo   3. For hot reload: press 'r' while app is running
echo   4. For hot restart: press 'R' while app is running
echo.
echo Build for production:
echo   Web:     flutter build web --release
echo   Windows: flutter build windows --release
echo.
echo Happy coding!
echo.
pause

