import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple logger to avoid print statements in favor of proper logging
void _log(String message) {
  // In a real application, this would use a proper logging framework
  // For this diagnostic tool, we'll use print but encapsulate it
  // This makes it easier to replace with a proper logger later
  print(message);
}

/// Comprehensive diagnostic tool to find the correct API URL for your Laravel backend
void main() async {
  _log('=== Smart Cashier API URL Finder ===\n');
  
  // Common Laravel API URL patterns to test
  final List<Map<String, dynamic>> urlsToTest = [
    {
      'url': 'http://localhost:8000/api',
      'description': 'Laravel development server (default)'
    },
    {
      'url': 'http://127.0.0.1:8000/api',
      'description': 'Laravel development server (alternative localhost)'
    },
    {
      'url': 'http://localhost:8000/api/v1',
      'description': 'Laravel development server with v1 prefix'
    },
    {
      'url': 'http://localhost/api',
      'description': 'Direct Apache/Nginx setup'
    },
    {
      'url': 'http://localhost/your-project/public/api',
      'description': 'XAMPP/Laragon default setup'
    },
  ];
  
  _log('Testing common Laravel API URL patterns...\n');
  
  String bestUrl = '';
  bool foundValidUrl = false;
  
  for (final urlInfo in urlsToTest) {
    final url = urlInfo['url'] as String;
    final description = urlInfo['description'] as String;
    
    _log('Testing: $url ($description)');
    final result = await testApiUrl(url);
    
    if (result['valid'] == true) {
      _log('  ✅ VALID API ENDPOINT FOUND!');
      _log('  🎯 Recommended URL: $url');
      bestUrl = url;
      foundValidUrl = true;
      break;
    } else {
      _log('  ${result['message']}');
    }
    _log('---');
  }
  
  if (!foundValidUrl) {
    _log('\n❌ NO VALID API ENDPOINT FOUND');
    _log('Possible solutions:');
    _log('1. Make sure your Laravel backend is running');
    _log('2. Check if you have the correct project path');
    _log('3. Verify your Laravel routes are configured');
    _log('4. Try running "php artisan serve" in your Laravel project directory');
  } else {
    _log('\n🎉 SUCCESS! Update your api_service.dart with this URL:');
    _log('static const String baseUrl = \'$bestUrl\';');
  }
  
  _log('\n=== Diagnostic Complete ===');
}

Future<Map<String, dynamic>> testApiUrl(String baseUrl) async {
  try {
    // Test if this is a valid API endpoint by checking if it returns JSON or HTML
    final response = await http.get(Uri.parse(baseUrl));
    
    // If it returns HTML, it's probably not an API endpoint
    if (response.body.contains('<html') || 
        response.body.contains('<!DOCTYPE') ||
        response.body.contains('Not Found') ||
        response.body.contains('The requested URL was not found')) {
      return {
        'valid': false,
        'message': '❌ Returns HTML (not an API endpoint)'
      };
    }
    
    // Try the login endpoint specifically
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
    );
    
    // If login endpoint returns HTML, it doesn't exist
    if (loginResponse.body.contains('<html') || 
        loginResponse.body.contains('<!DOCTYPE') ||
        loginResponse.body.contains('Not Found') ||
        loginResponse.body.contains('The requested URL was not found')) {
      return {
        'valid': false,
        'message': '❌ Login endpoint not found (404 error)'
      };
    }
    
    // If we get here, it might be a valid API endpoint
    // Even if it returns an error JSON, that's still better than HTML
    try {
      final jsonResult = json.decode(loginResponse.body);
      // If we can parse JSON, this is likely a valid API endpoint
      return {
        'valid': true,
        'message': '✅ Returns JSON (valid API endpoint)',
        'response': jsonResult
      };
    } catch (jsonError) {
      // If we can't parse JSON but also don't get HTML, 
      // it might still be an API endpoint with a text response
      if (loginResponse.statusCode >= 200 && loginResponse.statusCode < 500) {
        return {
          'valid': true,
          'message': '✅ Valid endpoint (returns non-HTML response)',
          'response': loginResponse.body
        };
      } else {
        return {
          'valid': false,
          'message': '❌ Server error (${loginResponse.statusCode})'
        };
      }
    }
  } catch (networkError) {
    return {
      'valid': false,
      'message': '❌ Network error (server not running or unreachable)'
    };
  }
}