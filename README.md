# Smart Cashier (Kasir Bintang)

A Flutter-based Point of Sale application with AI-powered product recommendations.

## Features

- User authentication (Login/Register)
- Product management
- Customer management
- Transaction processing
- AI-powered product recommendations
- Dashboard with analytics

## Prerequisites

- Flutter SDK (3.10.1 or higher)
- Dart SDK
- Backend API (Laravel-based)

## Getting Started

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Ensure your Laravel backend is running (see Backend Setup below)
4. Configure your API endpoint in `lib/services/api_service.dart`
5. **NEW:** Run the automated diagnostic by double-clicking `run_diagnostics.bat`
6. Run `flutter run` to start the application

## Backend Setup

Before running the frontend, you need to set up the Laravel backend:

1. Make sure you have PHP and Composer installed
2. Navigate to your Laravel project directory
3. Run `composer install` to install dependencies
4. Run `php artisan serve` to start the development server
5. Note the URL shown (typically `http://localhost:8000`)

## API Configuration

Before running the application, make sure to configure the API endpoint:

1. Open `lib/services/api_service.dart`
2. Update the `baseUrl` variable to match your backend server address
3. Ensure your backend server is running

### Automated Configuration (Recommended)

Simply double-click on `run_diagnostics.bat` to automatically detect the correct API URL.

### Manual Configuration

Common configurations:
- Laravel development server: `http://localhost:8000/api`
- XAMPP/Laragon: `http://localhost/your-project-folder/public/api`

## Troubleshooting

### Login/Register Not Working

If your login and register functionality is not working:

1. **See the detailed guide**: Check `FIX_LOGIN_FUNCTIONALITY.md` for comprehensive instructions

2. **Use the Automated Diagnostic Tool (Recommended)**
   - Double-click on `run_diagnostics.bat` in your project folder
   - The tool will automatically find the correct API URL for you
   - See `HOW_TO_USE_DIAGNOSTICS.md` for detailed instructions

3. **Check if your backend is running**
   - Run `php artisan serve` in your Laravel project directory
   - You should see output like: "Laravel development server started: http://127.0.0.1:8000"

4. **Verify your API URL**
   - Open `lib/services/api_service.dart`
   - Check that the `baseUrl` matches your actual backend URL
   - Common URLs:
     - Laravel development server: `http://localhost:8000/api`
     - XAMPP/Laragon: `http://localhost/your-project/public/api`

5. **Check your Laravel routes**
   - Open `routes/api.php` in your Laravel project
   - Make sure you have defined routes for `/auth/login` and `/auth/register`

6. **Run the URL finder tool**
   - Execute: `dart find_working_api_url.dart`
   - This will test common URLs and tell you which one works

### API Connection Error (404 HTML Response)

If you see HTML content or "404 Not Found" in your error messages instead of JSON:

1. **Use the Automated Diagnostic Tool (Recommended)**
   - Double-click on `run_diagnostics.bat` in your project folder
   - The tool will automatically find the correct API URL for you
   - See `HOW_TO_USE_DIAGNOSTICS.md` for detailed instructions

2. **Check if your backend is running**
   - Run `php artisan serve` in your Laravel project directory
   - You should see output like: "Laravel development server started: http://127.0.0.1:8000"

3. **Verify your API URL**
   - Open `lib/services/api_service.dart`
   - Check that the `baseUrl` matches your actual backend URL
   - Common URLs:
     - Laravel development server: `http://localhost:8000/api`
     - XAMPP/Laragon: `http://localhost/your-project/public/api`

4. **Check your Laravel routes**
   - Open `routes/api.php` in your Laravel project
   - Make sure you have defined routes for `/login` and `/register`

### Other Common Issues

If you encounter the error "Starting application from main method in: org-dartlang-app:/web_entrypoint.dart", it's likely due to API connection issues:

1. Check your network connectivity
2. Verify the API endpoint configuration
3. Ensure your backend server is running and accessible
4. Check that the required permissions are granted

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
