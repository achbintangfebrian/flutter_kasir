import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_category.dart';
import '../models/product.dart';
import '../models/customer.dart';
import '../models/transaction.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  // Categories
  Future<List<ProductCategory>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
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
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.get(Uri.parse('$baseUrl/categories/$id'));
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
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.delete(Uri.parse('$baseUrl/categories/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }

  // Products
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
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
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
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
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  // Customers
  Future<List<Customer>> getCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'));
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
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.get(Uri.parse('$baseUrl/customers/$id'));
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
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.delete(Uri.parse('$baseUrl/customers/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete customer');
    }
  }

  // Transactions
  Future<List<Transaction>> getTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'));
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
      headers: {'Content-Type': 'application/json'},
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
    final response = await http.get(Uri.parse('$baseUrl/transactions/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Transaction.fromJson(data);
    } else {
      throw Exception('Failed to load transaction');
    }
  }

  Future<void> deleteTransaction(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/transactions/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction');
    }
  }

  // Recommendations
  Future<List<Product>> getRecommendations() async {
    final response = await http.get(Uri.parse('$baseUrl/recommendations'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}