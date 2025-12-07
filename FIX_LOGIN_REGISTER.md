# How to Fix Login and Register Issues

## Problem
Your login and register functionality is not working because the Flutter app cannot connect to your Laravel backend API.

## Quick Fix Steps

### Step 1: Start Your Laravel Backend
Make sure your Laravel backend is running:

```bash
# Navigate to your Laravel project directory
cd /path/to/your/laravel/project

# Start the development server
php artisan serve
```

You should see output like:
```
Laravel development server started: http://127.0.0.1:8000
```

### Step 2: Verify Your Laravel Routes
Check that your `routes/api.php` file contains the required routes:

```php
<?php

use Illuminate\Support\Facades\Route;

// Authentication routes
Route::post('/login', [App\Http\Controllers\AuthController::class, 'login']);
Route::post('/register', [App\Http\Controllers\AuthController::class, 'register']);

// Protected routes (if needed)
Route::middleware('auth:sanctum')->group(function () {
    // Your protected API routes go here
});
```

### Step 3: Update Your Flutter API Configuration
Open `lib/services/api_service.dart` and update the `baseUrl`:

```dart
// Try one of these common URLs:
static const String baseUrl = 'http://localhost:8000/api';     // Most common
// static const String baseUrl = 'http://127.0.0.1:8000/api'; // Alternative
// static const String baseUrl = 'http://localhost/api';        // Direct Apache
```

### Step 4: Test the Connection
Run the test script to verify connectivity:

```bash
# From your Flutter project directory
dart test_backend_connectivity.dart
```

### Step 5: Create Test User (if needed)
If you don't have a test user, create one in your Laravel project:

```bash
# In your Laravel project directory
php artisan tinker

# In the tinker shell:
User::create([
    'name' => 'Admin User',
    'email' => 'admin@gmail.com',
    'password' => Hash::make('password123')
]);

# Exit tinker
exit
```

## Test Credentials
Try logging in with these credentials:
- Email: admin@gmail.com
- Password: password123

## Common Issues and Solutions

### Issue 1: "API endpoint not found" Error
**Solution**: Your `baseUrl` is incorrect. Try different URLs:
- `http://localhost:8000/api` (Laravel development server)
- `http://127.0.0.1:8000/api` (Alternative localhost)
- `http://localhost/api` (Direct Apache/Nginx)

### Issue 2: "Invalid email or password" Error
**Solution**: Make sure you have created a user with the correct credentials in your database.

### Issue 3: "Network error" Error
**Solution**: 
1. Make sure your Laravel backend is running
2. Check your firewall settings
3. If testing on a mobile device, use your computer's IP address instead of localhost

## Need More Help?
1. Run the automated diagnostic by double-clicking `run_diagnostics.bat`
2. Check the console logs in your Flutter app for detailed error messages
3. Verify your Laravel backend logs for any errors