import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple script to test backend connectivity
void main() async {
  print('=== Testing Backend Connectivity ===\n');
  
  // Test different common Laravel API URLs
  final List<String> urlsToTest = [
    'http://localhost:8000/api',
    'http://127.0.0.1:8000/api',
    'http://localhost/api',
  ];
  
  for (final baseUrl in urlsToTest) {
    print('Testing: $baseUrl');
    
    try {
      // Test base URL
      final baseResponse = await http.get(Uri.parse(baseUrl));
      print('  Base URL Status: ${baseResponse.statusCode}');
      
      // Test login endpoint
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': 'admin@gmail.com',
          'password': 'password123',
        }),
      );
      
      print('  Login Endpoint Status: ${loginResponse.statusCode}');
      
      if (loginResponse.statusCode == 200) {
        print('  ✅ SUCCESS: Login endpoint working!');
        print('  🎯 Use this URL in your api_service.dart: $baseUrl');
        return;
      } else if (loginResponse.body.contains('<html') || 
                 loginResponse.body.contains('<!DOCTYPE') ||
                 loginResponse.body.contains('Not Found')) {
        print('  ❌ Login endpoint returns HTML (404 error)');
      } else {
        print('  ⚠️  Login endpoint returns: ${loginResponse.body}');
      }
    } catch (e) {
      print('  ❌ Network error: $e');
    }
    
    print('---');
  }
  
  print('\n🔧 Troubleshooting Tips:');
  print('1. Make sure your Laravel backend is running (php artisan serve)');
  print('2. Check that your routes/api.php has login/register routes');
  print('3. Try different base URLs listed above');
}