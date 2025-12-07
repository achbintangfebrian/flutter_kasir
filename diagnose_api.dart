import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple logger to avoid print statements in favor of proper logging
void _log(String message) {
  // In a real application, this would use a proper logging framework
  // For this diagnostic tool, we'll use print but encapsulate it
  print(message);
}

/// Diagnostic tool to find the correct API URL for your Laravel backend
void main() async {
  _log('=== Smart Cashier API Diagnostic Tool ===\n');
  
  // Common Laravel API URL patterns to test
  final List<String> urlsToTest = [
    'http://localhost:8000/api',           // Laravel development server
    'http://localhost:8000/api/v1',       // Laravel development server with v1
    'http://127.0.0.1:8000/api',          // Alternative localhost
    'http://localhost/your-project/public/api', // XAMPP/Laragon default
  ];
  
  _log('Testing common Laravel API URL patterns...\n');
  
  for (final url in urlsToTest) {
    _log('Testing: $url');
    await testApiUrl(url);
    _log('---');
  }
  
  _log('\n=== Diagnostic Complete ===');
  _log('Look for a URL that returns JSON instead of HTML.');
  _log('Update lib/services/api_service.dart with the correct URL.');
}

Future<void> testApiUrl(String baseUrl) async {
  try {
    // Test the base URL first
    final baseResponse = await http.get(Uri.parse(baseUrl));
    
    if (baseResponse.body.contains('<html') || baseResponse.body.contains('<!DOCTYPE')) {
      _log('  ❌ Base URL returns HTML (not an API endpoint)');
      return;
    }
    
    _log('  ⚠️  Base URL returns data (might be correct)');
    
    // Try the login endpoint
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (loginResponse.body.contains('<html') || loginResponse.body.contains('<!DOCTYPE')) {
      _log('  ❌ Login endpoint returns HTML (404 error)');
      return;
    }
    
    // Check if we get JSON
    try {
      final jsonResult = json.decode(loginResponse.body);
      _log('  ✅ Login endpoint returns JSON: $jsonResult');
      _log('  🎯 This URL might be correct!');
    } catch (e) {
      _log('  ⚠️  Login endpoint returns non-JSON data: ${loginResponse.body}');
    }
  } catch (e) {
    _log('  ❌ Network error: $e');
  }
}