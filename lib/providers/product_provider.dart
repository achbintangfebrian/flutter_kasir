import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch all products
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _products = await ApiService.getProducts();
    } catch (error) {
      _errorMessage = 'Failed to load products: $error';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new product
  Future<bool> addProduct(Product product) async {
    try {
      final newProduct = await ApiService.createProduct(product);
      if (newProduct != null) {
        _products.add(newProduct);
        notifyListeners();
        return true;
      }
    } catch (error) {
      _errorMessage = 'Failed to add product: $error';
      print(_errorMessage);
    }
    return false;
  }

  // Update an existing product
  Future<bool> updateProduct(Product product) async {
    try {
      final updatedProduct = await ApiService.updateProduct(product);
      if (updatedProduct != null) {
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = updatedProduct;
          notifyListeners();
          return true;
        }
      }
    } catch (error) {
      _errorMessage = 'Failed to update product: $error';
      print(_errorMessage);
    }
    return false;
  }

  // Delete a product
  Future<bool> deleteProduct(int id) async {
    try {
      final success = await ApiService.deleteProduct(id);
      if (success) {
        _products.removeWhere((product) => product.id == id);
        notifyListeners();
        return true;
      }
    } catch (error) {
      _errorMessage = 'Failed to delete product: $error';
      print(_errorMessage);
    }
    return false;
  }
}