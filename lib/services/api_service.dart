import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/product_category.dart';
import '../models/product.dart';
import '../models/customer.dart';
import '../models/transaction.dart';

class ApiService {
  // TODO: Update this URL to match your backend server address
  // For Laravel development server: 'http://localhost:8000/api/v1'
  // For XAMPP/Laragon: 'http://localhost/your-project-folder/public/api/v1'
  // For mobile development with external server: 'http://YOUR_MACHINE_IP:8000/api/v1'
  // For production: 'https://yourdomain.com/api/v1'
  
  // FOR ANDROID EMULATOR: Use http://10.0.2.2:8000/api/v1
  // FOR PHYSICAL ANDROID DEVICE: Use your PC's local IP (e.g., http://192.168.1.50:8000/api/v1)
  // FOR BROWSER/WEB: Use http://localhost:8000/api/v1 or http://127.0.0.1:8000/api/v1
  static const String baseUrl = 'http://localhost:8000/api/v1'; // Updated for Laravel development server with v1
  
  // Store the API token after login
  String? _apiToken;
  
  // Set the API token after login
  void setApiToken(String token) {
    _apiToken = token;
  }
  
  // Get headers with optional authentication
  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_apiToken != null) {
      headers['Authorization'] = _apiToken!;
    }
    return headers;
  }
  
  // Authentication methods
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    
    final responseBody = json.decode(response.body);
    
    if (response.statusCode == 200 && responseBody['success'] == true) {
      return responseBody['data'];
    } else {
      throw Exception(responseBody['message'] ?? 'Failed to register');
    }
  }
  
  Future<Map<String, dynamic>> login(Map<String, dynamic> credentials) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(credentials),
    );
    
    final responseBody = json.decode(response.body);
    
    if (response.statusCode == 200 && responseBody['success'] == true) {
      return responseBody['data'];
    } else {
      throw Exception(responseBody['message'] ?? 'Failed to login');
    }
  }
  
  Future<void> logout() async {
    if (_apiToken == null) {
      throw Exception('Not logged in');
    }
    
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: _headers,
    );
    
    final responseBody = json.decode(response.body);
    
    if (response.statusCode == 200 && responseBody['success'] == true) {
      _apiToken = null; // Clear the token on successful logout
      return;
    } else {
      throw Exception(responseBody['message'] ?? 'Failed to logout');
    }
  }
  
  // Helper method to handle API responses
  dynamic _handleResponse(http.Response response) {
    final responseBody = json.decode(response.body);
    
    if (response.statusCode == 200 && responseBody['success'] == true) {
      return responseBody['data'];
    } else {
      throw Exception(responseBody['message'] ?? 'API request failed');
    }
  }
  
  // Categories
  Future<List<ProductCategory>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'), headers: _headers);
    final data = _handleResponse(response) as List;
    return data.map((category) => ProductCategory.fromJson(category)).toList();
  }

  Future<ProductCategory> createCategory(Map<String, dynamic> categoryData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: _headers,
      body: json.encode(categoryData),
    );
    final data = _handleResponse(response);
    return ProductCategory.fromJson(data);
  }

  Future<ProductCategory> getCategory(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/categories/$id'), headers: _headers);
    final data = _handleResponse(response);
    return ProductCategory.fromJson(data);
  }

  Future<ProductCategory> updateCategory(int id, Map<String, dynamic> categoryData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: _headers,
      body: json.encode(categoryData),
    );
    final data = _handleResponse(response);
    return ProductCategory.fromJson(data);
  }

  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/categories/$id'), headers: _headers);
    _handleResponse(response); // We don't need the response data for delete operations
  }

  // Products
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'), headers: _headers);
    final data = _handleResponse(response) as List;
    return data.map((product) => Product.fromJson(product)).toList();
  }

  Future<Product> createProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: _headers,
      body: json.encode(productData),
    );
    final data = _handleResponse(response);
    return Product.fromJson(data);
  }

  Future<Product> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'), headers: _headers);
    final data = _handleResponse(response);
    return Product.fromJson(data);
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> productData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: _headers,
      body: json.encode(productData),
    );
    final data = _handleResponse(response);
    return Product.fromJson(data);
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'), headers: _headers);
    _handleResponse(response); // We don't need the response data for delete operations
  }

  // Customers
  Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'), headers: _headers);
    final data = _handleResponse(response) as List;
    return data.map((customer) => Customer.fromJson(customer)).toList();
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
    final data = _handleResponse(response);
    return Customer.fromJson(data);
  }

  Future<Customer> getCustomer(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/customers/$id'), headers: _headers);
    final data = _handleResponse(response);
    return Customer.fromJson(data);
  }

  Future<Customer> updateCustomer(int id, Map<String, dynamic> customerData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/customers/$id'),
      headers: _headers,
      body: json.encode(customerData),
    );
    final data = _handleResponse(response);
    return Customer.fromJson(data);
  }

  Future<void> deleteCustomer(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/customers/$id'), headers: _headers);
    _handleResponse(response); // We don't need the response data for delete operations
  }

  // Transactions
  Future<List<Transaction>> getTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'), headers: _headers);
    final data = _handleResponse(response) as List;
    return data.map((transaction) => Transaction.fromJson(transaction)).toList();
  }

  Future<Transaction> createTransaction(Map<String, dynamic> transactionData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: _headers,
      body: json.encode(transactionData),
    );
    final data = _handleResponse(response);
    return Transaction.fromJson(data);
  }

  Future<Transaction> getTransaction(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/transactions/$id'), headers: _headers);
    final data = _handleResponse(response);
    return Transaction.fromJson(data);
  }

  Future<void> deleteTransaction(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/transactions/$id'), headers: _headers);
    _handleResponse(response); // We don't need the response data for delete operations
  }

  // Recommendations
  Future<List<Product>> getRecommendations() async {
    final response = await http.get(Uri.parse('$baseUrl/recommendations'), headers: _headers);
    final data = _handleResponse(response) as List;
    return data.map((product) => Product.fromJson(product)).toList();
  }
}