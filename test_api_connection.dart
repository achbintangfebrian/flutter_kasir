import 'dart:convert';
import 'package:http/http.dart' as http;

/// Test script to verify API connection
/// Run this in DartPad or as a standalone Dart script

Future<void> testApiConnection() async {
  // TODO: Update this URL to match your actual backend URL
  final String baseUrl = 'http://localhost:8000/api/v1';
  
  print('Testing API connection to: $baseUrl');
  
  try {
    // Test if the base URL is accessible
    final response = await http.get(Uri.parse(baseUrl));
    print('Base URL response status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      print('Base URL is accessible');
      
      // Try to access the login endpoint
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': 'test@example.com',
          'password': 'password123',
        }),
      );
      
      print('Login endpoint response status: ${loginResponse.statusCode}');
      
      if (loginResponse.statusCode == 404) {
        print('ERROR: Login endpoint not found!');
        print('This means your API routes are not configured correctly.');
        print('Check your Laravel routes/api.php file.');
      } else if (loginResponse.body.contains('<html') || loginResponse.body.contains('<!DOCTYPE')) {
        print('ERROR: Received HTML instead of JSON!');
        print('This means the URL is incorrect or pointing to a web page instead of API.');
        print('Double-check your base URL configuration.');
      } else {
        print('Login endpoint responded with JSON (this is good!)');
        print('Response: ${loginResponse.body}');
      }
    } else if (response.body.contains('<html') || response.body.contains('<!DOCTYPE')) {
      print('ERROR: Base URL is returning HTML instead of API response!');
      print('This means your URL is incorrect.');
      print('For Laravel development server, it should be: http://localhost:8000/api/v1');
      print('For XAMPP/Laragon, it might be: http://localhost/your-project/public/api/v1');
    } else {
      print('Base URL returned status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Network error: $e');
    print('This could mean:');
    print('1. Your backend server is not running');
    print('2. The URL is incorrect');
    print('3. There\'s a network/firewall issue');
  }
}

void main() {
  testApiConnection();
}