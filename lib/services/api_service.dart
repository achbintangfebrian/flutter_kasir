import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/product_category.dart';
import '../models/product.dart';
import '../models/customer.dart';
import '../models/transaction.dart';
import '../models/user.dart';

class ApiService {
  // TODO: Update this URL to match your backend server address
  // For Laravel development server: 'http://localhost:8000/api'
  // For XAMPP/Laragon: 'http://localhost/your-project-folder/public/api'
  // For mobile development with external server: 'http://YOUR_MACHINE_IP:8000/api'
  // For production: 'https://yourdomain.com/api'
  
  // FOR ANDROID EMULATOR: Use http://10.0.2.2/
  // FOR PHYSICAL ANDROID DEVICE: Use your PC's local IP (e.g., http://192.168.1.50/)
  // FOR BROWSER/WEB: Use http://localhost/ or http://127.0.0.1/
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Default for Laravel development server
  String? _authToken;
  
  void setAuthToken(String? token) {
    _authToken = token;
  }
  
  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }
  
  // Authentication
  // Endpoint: POST /auth/login
  // Expected payload: {"email": "string", "password": "string"}
  // Expected response: {"data": {"id": number, "name": "string", "email": "string", "token": "string"}}
  Future<User> login(String email, String password) async {
    print('ApiService: Attempting login with email: $email');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      print('ApiService: Login response status: ${response.statusCode}');
      print('ApiService: Login response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse is! Map<String, dynamic>) {
            print('ApiService: Login failed - invalid response format');
            throw Exception('Login failed: Invalid response format');
          }
          final data = jsonResponse['data'];
          if (data == null) {
            print('ApiService: Login failed - no data in response');
            throw Exception('Login failed: No data in response');
          }
          if (data is! Map<String, dynamic>) {
            print('ApiService: Login failed - invalid data format');
            throw Exception('Login failed: Invalid data format');
          }
          print('ApiService: Login successful, parsing user data');
          return User.fromJson(data);
        } catch (e) {
          print('ApiService: Login failed - error parsing response: ${e.toString()}');
          throw Exception('Login failed: Error parsing response');
        }
      } else {
        print('ApiService: Login failed with status ${response.statusCode}');
        // Handle specific error codes
        if (response.statusCode == 401) {
          throw Exception('Invalid email or password');
        } else if (response.statusCode == 404) {
          throw Exception('API endpoint not found. Please check your API URL configuration.');
        } else if (response.statusCode >= 500) {
          throw Exception('Server error. Please try again later.');
        } else {
          // Check if we received HTML instead of JSON (wrong URL)
          if (response.body.contains('<html') || response.body.contains('<!DOCTYPE')) {
            throw Exception('Invalid API endpoint. Received HTML instead of JSON. Please check your API URL configuration.');
          }
          throw Exception('Login failed: ${response.body}');
        }
      }
    } catch (e, stackTrace) {
      print('ApiService: Error during login: ${e.toString()}');
      print('ApiService: Stack trace: $stackTrace');
      // Check if it's a network error
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        throw Exception('Network error. Please check your connection.');
      }
      rethrow;
    }
  }
  
  Future<User> register(String name, String email, String password) async {
    print('ApiService: Attempting registration with name: $name, email: $email');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      print('ApiService: Registration response status: ${response.statusCode}');
      print('ApiService: Registration response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse is! Map<String, dynamic>) {
            print('ApiService: Registration failed - invalid response format');
            throw Exception('Registration failed: Invalid response format');
          }
          final data = jsonResponse['data'];
          if (data == null) {
            print('ApiService: Registration failed - no data in response');
            throw Exception('Registration failed: No data in response');
          }
          if (data is! Map<String, dynamic>) {
            print('ApiService: Registration failed - invalid data format');
            throw Exception('Registration failed: Invalid data format');
          }
          print('ApiService: Registration successful, parsing user data');
          return User.fromJson(data);
        } catch (e) {
          print('ApiService: Registration failed - error parsing response: ${e.toString()}');
          throw Exception('Registration failed: Error parsing response');
        }
      } else {
        print('ApiService: Registration failed with status ${response.statusCode}');
        // Handle specific error codes
        if (response.statusCode == 401) {
          throw Exception('Invalid registration data');
        } else if (response.statusCode == 404) {
          throw Exception('API endpoint not found. Please check your API URL configuration.');
        } else if (response.statusCode >= 500) {
          throw Exception('Server error. Please try again later.');
        } else {
          // Check if we received HTML instead of JSON (wrong URL)
          if (response.body.contains('<html') || response.body.contains('<!DOCTYPE')) {
            throw Exception('Invalid API endpoint. Received HTML instead of JSON. Please check your API URL configuration.');
          }
          throw Exception('Registration failed: ${response.body}');
        }
      }
    } catch (e, stackTrace) {
      print('ApiService: Error during registration: ${e.toString()}');
      print('ApiService: Stack trace: $stackTrace');
      // Check if it's a network error
      if (e.toString().contains('SocketException') || e.toString().contains('Connection')) {
        throw Exception('Network error. Please check your connection.');
      }
      rethrow;
    }
  }
  
  // Categories
  Future<List<ProductCategory>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'), headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((category) => ProductCategory.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<ProductCategory> createCategory(Map<String, dynamic> categoryData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: _headers,
      body: json.encode(categoryData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return ProductCategory.fromJson(data);
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<ProductCategory> getCategory(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/categories/$id'), headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return ProductCategory.fromJson(data);
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future<ProductCategory> updateCategory(int id, Map<String, dynamic> categoryData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: _headers,
      body: json.encode(categoryData),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return ProductCategory.fromJson(data);
    } else {
      throw Exception('Failed to update category');
    }
  }

  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/categories/$id'), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }

  // Products
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'), headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> createProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: _headers,
      body: json.encode(productData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<Product> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'), headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> productData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: _headers,
      body: json.encode(productData),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  // Customers
  Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'), headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((customer) => Customer.fromJson(customer)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<Customer> createCustomer(Map<String, dynamic> customerData) async {
    print('Sending customer data: $customerData');
    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: _headers,
      body: json.encode(customerData),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return Customer.fromJson(data);
    } else {
      throw Exception('Failed to create customer. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<Customer> getCustomer(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/customers/$id'), headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Customer.fromJson(data);
    } else {
      throw Exception('Failed to load customer');
    }
  }

  Future<Customer> updateCustomer(int id, Map<String, dynamic> customerData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/customers/$id'),
      headers: _headers,
      body: json.encode(customerData),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Customer.fromJson(data);
    } else {
      throw Exception('Failed to update customer');
    }
  }

  Future<void> deleteCustomer(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/customers/$id'), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete customer');
    }
  }

  // Transactions
  Future<List<Transaction>> getTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'), headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((transaction) => Transaction.fromJson(transaction)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<Transaction> createTransaction(Map<String, dynamic> transactionData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: _headers,
      body: json.encode(transactionData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return Transaction.fromJson(data);
    } else {
      throw Exception('Failed to create transaction');
    }
  }

  Future<Transaction> getTransaction(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/transactions/$id'), headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Transaction.fromJson(data);
    } else {
      throw Exception('Failed to load transaction');
    }
  }

  Future<void> deleteTransaction(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/transactions/$id'), headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction');
    }
  }

  // Recommendations
  Future<List<Product>> getRecommendations() async {
    final response = await http.get(Uri.parse('$baseUrl/recommendations'), headers: _headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}