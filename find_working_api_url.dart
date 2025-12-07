import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple tool to find the correct API URL for your Laravel backend
void main() async {
  print('=== Finding Correct API URL ===\n');
  
  // Common Laravel API URL patterns to test
  final List<String> urlsToTest = [
    'http://localhost:8000/api',
    'http://127.0.0.1:8000/api',
    'http://localhost/api',
    'http://localhost/your-laravel-project/public/api',
  ];
  
  print('Testing common Laravel API URLs...\n');
  
  for (final baseUrl in urlsToTest) {
    print('Testing: $baseUrl');
    
    try {
      // Test if this URL can be reached
      final response = await http.get(Uri.parse(baseUrl));
      
      // Test login endpoint specifically
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': 'admin@example.com',
          'password': 'password123',
        }),
      );
      
      print('  Base URL status: ${response.statusCode}');
      print('  Login endpoint status: ${loginResponse.statusCode}');
      
      // If we get a JSON response (even an error), the endpoint exists
      if (!loginResponse.body.contains('<html') && 
          !loginResponse.body.contains('<!DOCTYPE') &&
          loginResponse.body.contains('{')) {
        print('  ✅ VALID API ENDPOINT FOUND!');
        print('  🎯 Use this URL in your api_service.dart: $baseUrl');
        print('  ---');
        return;
      } else if (loginResponse.statusCode == 404) {
        print('  ❌ Login endpoint not found (404 error)');
      } else {
        print('  ⚠️  Unexpected response: ${loginResponse.body}');
      }
    } catch (e) {
      print('  ❌ Network error: $e');
    }
    
    print('  ---');
  }
  
  print('\n🔧 Troubleshooting Tips:');
  print('1. Make sure your Laravel backend is running (php artisan serve)');
  print('2. Check your Laravel routes/api.php file');
  print('3. Try different base URLs from the list above');
  print('4. If using XAMPP/WAMP, place your Laravel project in the web root');
}