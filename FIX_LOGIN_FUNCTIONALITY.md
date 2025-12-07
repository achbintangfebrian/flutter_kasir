# Fix Login Functionality Guide

## Problem Analysis
Your login functionality is not working because:
1. The API endpoint path was incorrect (`/login` instead of `/auth/login`)
2. The base URL might not be correctly configured for your environment

## Changes Made

### 1. Fixed API Endpoint Paths
Updated [api_service.dart](file:///c:/kasir_bintang/lib/services/api_service.dart) to use the correct endpoint paths:
- Login: `/auth/login` (was `/login`)
- Register: `/auth/register` (was `/register`)

### 2. Updated Base URL Configuration
Set a default base URL that works with Laravel development server:
- `http://10.0.2.2:8000/api` (for Android emulator with Laravel dev server)

## How to Test and Fix Login

### Step 1: Start Your Laravel Backend
Make sure your Laravel backend is running:
```bash
cd /path/to/your/laravel/project
php artisan serve
```

### Step 2: Test the Authentication Endpoint
Double-click on `test_auth_endpoint.bat` or run in terminal:
```bash
dart test_auth_endpoint.dart
```

### Step 3: Update Base URL for Your Environment
Depending on your setup, update the `baseUrl` in `lib/services/api_service.dart`:

```dart
// For Android Emulator with Laravel dev server:
static const String baseUrl = 'http://10.0.2.2:8000/api';

// For Android Emulator with XAMPP/Laragon:
static const String baseUrl = 'http://10.0.2.2/your_project_folder/api';

// For Physical Device:
static const String baseUrl = 'http://YOUR_LOCAL_IP:8000/api';

// For Browser/Web:
static const String baseUrl = 'http://localhost:8000/api';
```

### Step 4: Create a Test User (if needed)
If you don't have a test user, create one in your Laravel project:
```bash
php artisan tinker
User::create([
    'name' => 'Admin User',
    'email' => 'admin@example.com',
    'password' => Hash::make('your_password')
]);
exit
```

### Step 5: Test Login in Your App
Try logging in with:
- Email: admin@example.com
- Password: your_password

## Troubleshooting Common Issues

### Issue 1: "API endpoint not found" Error
**Cause**: Incorrect base URL or endpoint path
**Solution**:
1. Verify your Laravel backend is running
2. Check that your routes are defined in `routes/api.php`:
   ```php
   Route::post('/auth/login', [App\Http\Controllers\AuthController::class, 'login']);
   Route::post('/auth/register', [App\Http\Controllers\AuthController::class, 'register']);
   ```
3. Update the base URL to match your setup

### Issue 2: "Invalid email or password" Error
**Cause**: Wrong credentials or user doesn't exist
**Solution**:
1. Create a test user using the tinker command above
2. Use the correct credentials

### Issue 3: "Network error" Error
**Cause**: Backend not running or network issues
**Solution**:
1. Ensure `php artisan serve` is running
2. Check firewall settings
3. For physical devices, ensure both devices are on the same network

## Verification Steps

1. **Check Laravel Logs**: Look in `storage/logs/laravel.log` for any errors
2. **Test API with Postman/curl**:
   ```bash
   curl -X POST http://10.0.2.2:8000/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"admin@example.com","password":"your_password"}'
   ```
3. **Check Browser**: Visit `http://10.0.2.2:8000/api/auth/login` to see if the endpoint exists

## Expected Response Format
Your backend should return a JSON response in this format:
```json
{
  "data": {
    "id": 1,
    "name": "Admin User",
    "email": "admin@example.com",
    "token": "your_jwt_token_here"
  }
}
```

If your backend returns a different format, you may need to update the [User.fromJson](file:///c:/kasir_bintang/lib/models/user.dart#L14-L38) method in `lib/models/user.dart`.

## Need More Help?

1. Run the automated diagnostic: Double-click `run_diagnostics.bat`
2. Check console logs in your Flutter app for detailed error messages
3. Verify your Laravel backend logs for any errors
4. Make sure CORS is configured properly in your Laravel app