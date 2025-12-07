import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple logger to avoid print statements in favor of proper logging
void _log(String message) {
  // In a real application, this would use a proper logging framework
  // For this diagnostic tool, we'll use print but encapsulate it
  print(message);
}

/// Simple script to test if your Laravel backend is running and accessible
void main() async {
  _log('=== Testing Laravel Backend Connection ===\n');
  
  // Test the most common Laravel development server URL
  final String baseUrl = 'http://localhost:8000/api';
  
  _log('Testing connection to: $baseUrl\n');
  
  try {
    // Test if the base API endpoint is accessible
    _log('1. Testing base API endpoint...');
    final baseResponse = await http.get(Uri.parse(baseUrl));
    _log('   Status: ${baseResponse.statusCode}');
    
    if (baseResponse.statusCode == 200) {
      _log('   ✅ Base API endpoint is accessible');
    } else if (baseResponse.body.contains('<html') || 
               baseResponse.body.contains('<!DOCTYPE') ||
               baseResponse.body.contains('Not Found')) {
      _log('   ❌ Base API endpoint returns HTML (not a valid API endpoint)');
    } else {
      _log('   ⚠️  Base API endpoint returns: ${baseResponse.body}');
    }
    
    // Test the login endpoint
    _log('\n2. Testing login endpoint...');
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': 'admin@gmail.com',
        'password': 'password123',
      }),
    );
    
    _log('   Status: ${loginResponse.statusCode}');
    
    if (loginResponse.statusCode == 404) {
      _log('   ❌ Login endpoint not found (404 error)');
      _log('   This means your Laravel routes are not configured correctly');
    } else if (loginResponse.body.contains('<html') || 
               loginResponse.body.contains('<!DOCTYPE') ||
               loginResponse.body.contains('Not Found')) {
      _log('   ❌ Login endpoint returns HTML instead of JSON');
      _log('   This indicates the URL is incorrect or the endpoint doesn\'t exist');
    } else {
      // Try to parse as JSON
      try {
        final jsonResult = json.decode(loginResponse.body);
        _log('   ✅ Login endpoint returns valid JSON:');
        _log('   Response: $jsonResult');
      } catch (e) {
        _log('   ⚠️  Login endpoint returns non-JSON data:');
        _log('   Response: ${loginResponse.body}');
      }
    }
    
    _log('\n=== Test Complete ===');
    
    // Provide recommendations based on results
    if (loginResponse.statusCode == 404 || 
        loginResponse.body.contains('<html') ||
        loginResponse.body.contains('<!DOCTYPE')) {
      _log('\n🔧 Recommendations:');
      _log('1. Make sure your Laravel backend is running (php artisan serve)');
      _log('2. Check that your routes/api.php file contains login/register routes');
      _log('3. Try different base URLs:');
      _log('   - http://127.0.0.1:8000/api');
      _log('   - http://localhost/api');
      _log('   - http://localhost/your-project/public/api');
    } else {
      _log('\n🎉 Your backend connection appears to be working!');
    }
    
  } catch (e) {
    _log('   ❌ Network error: $e');
    _log('\n🔧 Recommendations:');
    _log('1. Make sure your Laravel backend is running');
    _log('2. Check your network connection');
    _log('3. Verify the URL is correct');
  }
}