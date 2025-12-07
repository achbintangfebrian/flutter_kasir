# Quick Fix for API Connection Error

## The Problem
You're getting a 404 error with HTML content when trying to log in, which means your Flutter app can't connect to your Laravel backend API.

## Quick Solutions

### Option 1: Run the Automated Diagnostic (Recommended)
Double-click on `run_diagnostics.bat` to automatically find the correct API URL.

### Option 2: Manual Fix

1. **Start your Laravel backend:**
   ```bash
   # Navigate to your Laravel project directory
   cd /path/to/your/laravel/project
   
   # Start the development server
   php artisan serve
   ```
   
   You should see output like: "Laravel development server started: http://127.0.0.1:8000"

2. **Update the API URL in your Flutter app:**
   Open `lib/services/api_service.dart` and update line 17:
   
   ```dart
   // Try one of these common URLs:
   static const String baseUrl = 'http://localhost:8000/api';     // Most common
   // static const String baseUrl = 'http://127.0.0.1:8000/api';   // Alternative
   // static const String baseUrl = 'http://localhost/api';        // Direct Apache
   ```

3. **Check your Laravel routes:**
   Make sure your `routes/api.php` file has these routes:
   ```php
   Route::post('/login', [App\Http\Controllers\AuthController::class, 'login']);
   Route::post('/register', [App\Http\Controllers\AuthController::class, 'register']);
   ```

## Test Credentials
Try logging in with these test credentials:
- Email: admin@gmail.com
- Password: password123

## Need More Help?
Run the diagnostic tool by double-clicking `run_diagnostics.bat` for automatic detection of the correct URL.