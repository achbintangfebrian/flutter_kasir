import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple test to verify the authentication endpoint
void main() async {
  print('=== Testing Authentication Endpoint ===\n');
  
  // Test URL - update this to match your actual backend URL
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final String loginEndpoint = '$baseUrl/auth/login';
  
  print('Testing endpoint: $loginEndpoint\n');
  
  try {
    // Test the login endpoint
    final response = await http.post(
      Uri.parse(loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': 'admin@example.com',
        'password': 'your_password',
      }),
    );
    
    print('Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}\n');
    
    if (response.statusCode == 200) {
      print('✅ SUCCESS: Login endpoint is working!');
      print('🎉 You should now be able to login through the app.');
    } else if (response.statusCode == 401) {
      print('⚠️  AUTH ERROR: Invalid credentials (this is expected if credentials are wrong)');
      print('✅ But the endpoint is working correctly!');
    } else if (response.statusCode == 404) {
      print('❌ ERROR: Endpoint not found');
      print('🔧 Possible solutions:');
      print('   1. Check if your Laravel backend is running');
      print('   2. Verify the endpoint path is correct (/auth/login)');
      print('   3. Check your baseUrl configuration');
    } else {
      print('❌ ERROR: Unexpected response status ${response.statusCode}');
    }
  } catch (e) {
    print('❌ NETWORK ERROR: $e');
    print('🔧 Troubleshooting steps:');
    print('   1. Make sure your Laravel backend is running (php artisan serve)');
    print('   2. Check your network connection');
    print('   3. Verify the IP address is correct for your setup');
    print('   4. Check if any firewall is blocking the connection');
  }
}