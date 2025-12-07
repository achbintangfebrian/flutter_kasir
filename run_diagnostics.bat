@echo off
title Smart Cashier API Diagnostics

echo ========================================
echo Smart Cashier API Connection Diagnostics
echo ========================================
echo.

echo Checking if Flutter is installed...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    echo Please install Flutter and add it to your PATH
    echo.
    pause
    exit /b 1
)

echo ✅ Flutter is installed
echo.

echo Checking if Dart is available...
dart --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Dart is not available
    echo This is unusual since Flutter includes Dart
    echo.
    pause
    exit /b 1
)

echo ✅ Dart is available
echo.

echo Running API URL finder...
echo This will test common Laravel API URL patterns
echo.
dart find_correct_api_url.dart

echo.
echo ========================================
echo Next Steps:
echo 1. Look for a URL that shows "VALID API ENDPOINT FOUND"
echo 2. Update lib/services/api_service.dart with that URL
echo 3. Make sure your Laravel backend is running
echo ========================================
echo.

pause