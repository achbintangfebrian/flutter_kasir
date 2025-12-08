import 'package:flutter/foundation.dart';
import '../models/product_category.dart';
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  List<ProductCategory> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Use the singleton instance of ApiService
  ApiService _apiService = ApiService();

  // Allow setting the API service instance (for dependency injection)
  void setApiService(ApiService apiService) {
    _apiService = apiService;
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (error) {
      _errorMessage = error.toString();
      print('Error fetching categories: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ProductCategory> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final category = await _apiService.createCategory(categoryData);
      _categories.add(category);
      notifyListeners();
      return category;
    } catch (error) {
      _errorMessage = error.toString();
      print('Error creating category: $error');
      rethrow;
    }
  }

  Future<ProductCategory> updateCategory(int id, Map<String, dynamic> categoryData) async {
    try {
      final category = await _apiService.updateCategory(id, categoryData);
      final index = _categories.indexWhere((element) => element.id == id);
      if (index != -1) {
        _categories[index] = category;
        notifyListeners();
      }
      return category;
    } catch (error) {
      _errorMessage = error.toString();
      print('Error updating category: $error');
      rethrow;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _apiService.deleteCategory(id);
      _categories.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      print('Error deleting category: $error');
      rethrow;
    }
  }
}