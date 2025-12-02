import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _recommendations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  List<Product> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ApiService _apiService = ApiService();

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
    } catch (error) {
      _errorMessage = error.toString();
      print('Error fetching products: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      final product = await _apiService.createProduct(productData);
      _products.add(product);
      notifyListeners();
      return product;
    } catch (error) {
      _errorMessage = error.toString();
      print('Error creating product: $error');
      rethrow;
    }
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      final product = await _apiService.updateProduct(id, productData);
      final index = _products.indexWhere((element) => element.id == id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
      return product;
    } catch (error) {
      _errorMessage = error.toString();
      print('Error updating product: $error');
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.deleteProduct(id);
      _products.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      print('Error deleting product: $error');
      rethrow;
    }
  }

  Future<void> fetchRecommendations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await _apiService.getRecommendations();
    } catch (error) {
      _errorMessage = error.toString();
      print('Error fetching recommendations: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}