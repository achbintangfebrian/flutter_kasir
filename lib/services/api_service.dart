import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/admin.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  // Headers for API requests
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Authentication methods
  static Future<Admin?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Admin.fromJson(data);
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  static Future<Admin?> register(int role, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: getHeaders(),
        body: jsonEncode({
          'role': role,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Admin.fromJson(data);
      }
    } catch (e) {
      print('Register error: $e');
    }
    return null;
  }

  // Product methods
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle case where API returns an object instead of array
        if (data is Map<String, dynamic>) {
          // Check if it has a data field or similar
          if (data.containsKey('data') && data['data'] is List) {
            return (data['data'] as List).map((json) => Product.fromJson(json)).toList();
          } else {
            // If it's just a single object, return empty list
            print('Unexpected data format for products: $data');
            return [];
          }
        } else if (data is List) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else {
          print('Unexpected data type for products: ${data.runtimeType}');
          return [];
        }
      }
    } catch (e) {
      print('Get products error: $e');
    }
    return [];
  }

  static Future<Product?> getProductById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle case where API returns an object with data field
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return Product.fromJson(data['data']);
        }
        return Product.fromJson(data);
      }
    } catch (e) {
      print('Get product by ID error: $e');
    }
    return null;
  }

  static Future<Product?> createProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: getHeaders(),
        body: jsonEncode(product.toJson()),
      );

      print('Create product response status: ${response.statusCode}');
      print('Create product response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Handle case where API returns an object with data field
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return Product.fromJson(data['data']);
        }
        return Product.fromJson(data);
      } else {
        print('Failed to create product: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Create product error: $e');
    }
    return null;
  }

  static Future<Product?> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.id}'),
        headers: getHeaders(),
        body: jsonEncode(product.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle case where API returns an object with data field
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return Product.fromJson(data['data']);
        }
        return Product.fromJson(data);
      }
    } catch (e) {
      print('Update product error: $e');
    }
    return null;
  }

  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Delete product error: $e');
      return false;
    }
  }

  // Category methods
  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle case where API returns an object instead of array
        if (data is Map<String, dynamic>) {
          // Check if it has a data field or similar
          if (data.containsKey('data') && data['data'] is List) {
            return (data['data'] as List).map((json) => Category.fromJson(json)).toList();
          } else {
            // If it's just a single object, return empty list
            print('Unexpected data format for categories: $data');
            return [];
          }
        } else if (data is List) {
          return data.map((json) => Category.fromJson(json)).toList();
        } else {
          print('Unexpected data type for categories: ${data.runtimeType}');
          return [];
        }
      }
    } catch (e) {
      print('Get categories error: $e');
    }
    return [];
  }

  static Future<Category?> getCategoryById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories/$id'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle case where API returns an object with data field
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return Category.fromJson(data['data']);
        }
        return Category.fromJson(data);
      }
    } catch (e) {
      print('Get category by ID error: $e');
    }
    return null;
  }

  static Future<Category?> createCategory(Category category) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: getHeaders(),
        body: jsonEncode(category.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Handle case where API returns an object with data field
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return Category.fromJson(data['data']);
        }
        return Category.fromJson(data);
      }
    } catch (e) {
      print('Create category error: $e');
    }
    return null;
  }

  static Future<Category?> updateCategory(Category category) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/categories/${category.id}'),
        headers: getHeaders(),
        body: jsonEncode(category.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle case where API returns an object with data field
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return Category.fromJson(data['data']);
        }
        return Category.fromJson(data);
      }
    } catch (e) {
      print('Update category error: $e');
    }
    return null;
  }

  static Future<bool> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$id'),
        headers: getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Delete category error: $e');
      return false;
    }
  }

  // Transaction methods
  static Future<List<Transaction>> getTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle case where API returns an object instead of array
        if (data is Map<String, dynamic>) {
          // Check if it has a data field or similar
          if (data.containsKey('data') && data['data'] is List) {
            return (data['data'] as List).map((json) => Transaction.fromJson(json)).toList();
          } else {
            // If it's just a single object, return empty list
            print('Unexpected data format for transactions: $data');
            return [];
          }
        } else if (data is List) {
          return data.map((json) => Transaction.fromJson(json)).toList();
        } else {
          print('Unexpected data type for transactions: ${data.runtimeType}');
          return [];
        }
      }
    } catch (e) {
      print('Get transactions error: $e');
    }
    return [];
  }

  static Future<Transaction?> getTransactionById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions/$id'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle case where API returns an object with data field
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return Transaction.fromJson(data['data']);
        }
        return Transaction.fromJson(data);
      }
    } catch (e) {
      print('Get transaction by ID error: $e');
    }
    return null;
  }

  static Future<Transaction?> createTransaction(Transaction transaction) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: getHeaders(),
        body: jsonEncode(transaction.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Handle case where API returns an object with data field
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return Transaction.fromJson(data['data']);
        }
        return Transaction.fromJson(data);
      }
    } catch (e) {
      print('Create transaction error: $e');
    }
    return null;
  }

  static Future<bool> deleteTransaction(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/transactions/$id'),
        headers: getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Delete transaction error: $e');
      return false;
    }
  }
}