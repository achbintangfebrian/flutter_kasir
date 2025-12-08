# Quick Fix for API Connection Error

## The Problem
You're getting a 404 error with HTML content when trying to access API endpoints, which means your Flutter app can't connect to your Laravel backend API.

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
   Open `lib/services/api_service.dart` and update line 20:
   
   ```dart
   // Try one of these common URLs:
   static const String baseUrl = 'http://localhost:8000/api/v1';     // Most common
   // static const String baseUrl = 'http://127.0.0.1:8000/api/v1';   // Alternative
   // static const String baseUrl = 'http://localhost/api/v1';        // Direct Apache
   ```

3. **Check your Laravel routes:**
   Make sure your `routes/api.php` file has the required routes for the POS system (categories, products, customers, transactions).

## Authentication

The application now requires authentication. You need to:

1. Register an account (first time only) or use existing credentials
2. Login through the app to get an API token
3. The token is automatically used for all subsequent API requests

Default test credentials:
- Email: admin@example.com
- Password: pw12345

## Need More Help?
Run the diagnostic tool by double-clicking `run_diagnostics.bat` for automatic detection of the correct URL.