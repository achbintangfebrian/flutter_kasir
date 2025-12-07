# How to Use the Diagnostic Tools

This project includes several diagnostic tools to help you fix API connection issues automatically.

## Method 1: Double-Click Batch File (Windows)

1. In your project folder, find `run_diagnostics.bat`
2. Double-click on it
3. The tool will automatically test different API URLs
4. It will show you the correct URL to use
5. Update `lib/services/api_service.dart` with the recommended URL

## Method 2: Run PowerShell Script (Windows)

1. In your project folder, find `run_diagnostics.ps1`
2. Right-click on it
3. Select "Run with PowerShell"
4. Follow the on-screen instructions

## Method 3: Run Dart Scripts Directly

If you prefer to run the scripts directly:

1. Open a terminal/command prompt
2. Navigate to your project directory
3. Run one of these commands:

```bash
# Run the URL finder
dart find_correct_api_url.dart

# Or run the connection test
dart test_backend_connection.dart
```

## What the Tools Do

- **find_correct_api_url.dart**: Tests common Laravel API URL patterns to find the correct one
- **test_backend_connection.dart**: Verifies if your backend is running and accessible
- **run_diagnostics.bat/.ps1**: Automated wrappers that run the Dart scripts for you

## Interpreting Results

When the diagnostic tools run, look for:
- ✅ VALID API ENDPOINT FOUND - This is the URL you should use
- ❌ Network error - Your backend isn't running
- ❌ Login endpoint not found - Your Laravel routes aren't configured correctly

## After Running Diagnostics

1. Take note of the recommended URL from the diagnostic tool
2. Open `lib/services/api_service.dart`
3. Update line 17 with the recommended URL:
   ```dart
   static const String baseUrl = 'THE_RECOMMENDED_URL_HERE';
   ```
4. Save the file
5. Restart your Flutter app