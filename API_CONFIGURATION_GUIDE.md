# API Configuration Guide

This guide will help you configure the API connection for the Smart Cashier application.

## Current Configuration

The application is currently configured to connect to:
- **Base URL**: `http://localhost:8000/api`
- **Login Endpoint**: `POST /login`
- **Register Endpoint**: `POST /register`

## Common Backend Setup Scenarios

### 1. Laravel Development Server
If you're using Laravel's built-in development server (`php artisan serve`):
- Base URL: `http://localhost:8000/api`

### 2. XAMPP/Laragon/WAMP
If you're using a local web server with your Laravel project in the web root:
- Base URL: `http://localhost/your-project-folder/public/api`

### 3. Production Server
For a deployed Laravel application:
- Base URL: `https://yourdomain.com/api`

## Common Connection Issues and Solutions

### 1. Localhost Issue
If you're running the app on a mobile device or different machine than your backend:
1. Replace `localhost` with your machine's IP address
2. Ensure your backend server is accessible from the device

### 2. Network Permissions
Ensure your app has the necessary permissions to access the network:
- **Android**: Internet permission is already added to AndroidManifest.xml
- **iOS**: NSAppTransportSecurity is configured to allow HTTP connections

### 3. Backend Server Not Running
Make sure your Laravel backend is running on port 8000:
```bash
php artisan serve
```

### 4. Incorrect API Endpoint (404 Error)
If you're getting a 404 error or HTML response instead of JSON:
1. Verify your Laravel routes are correctly defined
2. Check that your API prefix is correct (usually `/api`)
3. Make sure you have the correct URL structure

### 5. API Route Not Found
If you're getting "Route not found" errors:
1. Check your `routes/api.php` file in your Laravel project
2. Ensure you have defined the login and register routes
3. Verify the route prefixes match your frontend configuration

## How to Update API Configuration

### Step 1: Find Your Machine's IP Address
- **Windows**: Open Command Prompt and run `ipconfig`
- **Mac/Linux**: Open Terminal and run `ifconfig` or `ip addr`

### Step 2: Update the Base URL
In `lib/services/api_service.dart`, update the baseUrl:

```dart
// For local development (same machine)
static const String baseUrl = 'http://localhost:8000/api/v1';

// For mobile development (different machine)
static const String baseUrl = 'http://YOUR_MACHINE_IP:8000/api/v1';

// For production
static const String baseUrl = 'https://yourdomain.com/api/v1';
```

### Step 3: Test the Connection
1. Make sure your backend is running
2. Update the URL in the code
3. Restart the Flutter app

## Expected API Response Format

### Login Endpoint
**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "user@example.com",
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9..."
  }
}
```

## Troubleshooting Tips

1. **Check Network Connectivity**: Ensure your device can reach the backend server
2. **Verify Endpoints**: Confirm the API endpoints match your backend routes
3. **Check CORS Settings**: Make sure your Laravel backend allows requests from your app
4. **Enable Debug Logging**: The app includes extensive logging to help diagnose issues

## Testing the API Manually

You can test your API endpoints using tools like Postman or curl:

```bash
# Test login endpoint
curl -X POST http://localhost:8000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

If you continue to experience issues, check the console logs for detailed error messages.