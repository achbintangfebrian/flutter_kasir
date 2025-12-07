# API URL Configuration Guide

## Understanding the Problem

Your Flutter app is unable to connect to your Laravel backend because the API URL is incorrectly configured. The current URL `http://localhost:8000/api` will not work when running on Android emulators or physical devices.

## How to Configure Your API URL Correctly

### Step 1: Identify Your Development Setup

Determine which scenario applies to you:

| Scenario | Description | Correct URL Pattern |
|----------|-------------|-------------------|
| Android Emulator | Running app on Android emulator | `http://10.0.2.2/your_backend_folder/api` |
| Physical Android Device | Running app on actual Android phone | `http://YOUR_PC_LOCAL_IP/your_backend_folder/api` |
| Browser/Web | Running app in browser | `http://localhost/your_backend_folder/api` or `http://127.0.0.1/your_backend_folder/api` |

### Step 2: Locate Your Backend Folder Path

Identify where your Laravel backend is located:

1. **If using Laravel development server** (`php artisan serve`):
   - URL: `http://10.0.2.2:8000/api` (for emulator)

2. **If using XAMPP/Laragon**:
   - Place your Laravel project in the web root
   - Example: If your project folder is named `kasir_backend`, URL would be:
     - `http://10.0.2.2/kasir_backend/api` (for emulator)

3. **If using a custom setup**:
   - Determine the correct path to your API endpoints

### Step 3: Update the API Configuration

Open `lib/services/api_service.dart` and update the `baseUrl`:

```dart
class ApiService {
  // TODO: Update this URL to match your backend server address
  
  // FOR ANDROID EMULATOR: Use http://10.0.2.2/
  // FOR PHYSICAL ANDROID DEVICE: Use your PC's local IP (e.g., http://192.168.1.50/)
  // FOR BROWSER/WEB: Use http://localhost/ or http://127.0.0.1/
  
  // Examples:
  // static const String baseUrl = 'http://10.0.2.2:8000/api';           // Laravel dev server + emulator
  // static const String baseUrl = 'http://10.0.2.2/kasir_backend/api';  // XAMPP/Laragon + emulator
  // static const String baseUrl = 'http://192.168.1.50:8000/api';       // Laravel dev server + physical device
  // static const String baseUrl = 'http://localhost:8000/api';          // Browser/web development
  
  static const String baseUrl = 'http://10.0.2.2/your_backend_folder/api'; // CHANGE THIS TO MATCH YOUR SETUP
  // ... rest of the code
}
```

### Step 4: Find Your PC's Local IP Address (For Physical Devices)

If you're using a physical Android device:

**Windows:**
```cmd
ipconfig
```
Look for "IPv4 Address" under your active network connection.

**Mac/Linux:**
```bash
ifconfig
```
or
```bash
ip addr show
```

### Step 5: Ensure Both Devices Are on Same Network

For physical device testing:
1. Connect your PC and Android device to the same Wi-Fi network
2. Make sure your firewall allows connections on the port you're using (usually 80, 8000, etc.)

### Step 6: Test Your Configuration

1. **Start your Laravel backend**:
   ```bash
   cd /path/to/your/laravel/project
   php artisan serve
   # or if using XAMPP/Laragon, start the Apache server
   ```

2. **Verify the API endpoint**:
   Open your browser and visit:
   - `http://10.0.2.2:8000/api` (if using Laravel dev server)
   - You should see a JSON response or at least not get a 404 error

3. **Test in your Flutter app**:
   Try to login/register in your app

## Common Configuration Examples

### Example 1: Laravel Development Server + Android Emulator
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

### Example 2: XAMPP + Android Emulator
If your Laravel project is in `C:\xampp\htdocs\kasir_backend`:
```dart
static const String baseUrl = 'http://10.0.2.2/kasir_backend/api';
```

### Example 3: Laragon + Android Emulator
If your Laravel project is in `C:\laragon\www\kasir_backend`:
```dart
static const String baseUrl = 'http://10.0.2.2/kasir_backend/api';
```

### Example 4: Laravel Development Server + Physical Device
If your PC's IP is 192.168.1.50:
```dart
static const String baseUrl = 'http://192.168.1.50:8000/api';
```

### Example 5: Browser/Web Development
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

## Troubleshooting

### Issue 1: Still Getting 404 Errors
1. Double-check your URL path
2. Ensure your Laravel routes are correctly defined in `routes/api.php`
3. Make sure your backend server is running

### Issue 2: Network Connection Errors
1. Verify both devices are on the same network
2. Check firewall settings
3. Try turning off antivirus temporarily

### Issue 3: CORS Errors
Add CORS middleware to your Laravel app:
1. Install the CORS package:
   ```bash
   composer require fruitcake/laravel-cors
   ```
2. Add to `app/Http/Kernel.php`:
   ```php
   protected $middleware = [
       // ... other middleware
       \Fruitcake\Cors\HandleCors::class,
   ];
   ```
3. Publish and configure CORS:
   ```bash
   php artisan vendor:publish --tag=cors
   ```

## Verification Checklist

- [ ] Backend server is running
- [ ] Correct IP address used for your setup
- [ ] Proper folder path to your API endpoints
- [ ] Both devices on same network (for physical device testing)
- [ ] Firewall allows connections
- [ ] Laravel routes are properly defined
- [ ] CORS is configured (if needed)