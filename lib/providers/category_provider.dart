import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch all categories
  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _categories = await ApiService.getCategories();
    } catch (error) {
      _errorMessage = 'Failed to load categories: $error';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new category
  Future<bool> addCategory(Category category) async {
    try {
      final newCategory = await ApiService.createCategory(category);
      if (newCategory != null) {
        _categories.add(newCategory);
        notifyListeners();
        return true;
      }
    } catch (error) {
      _errorMessage = 'Failed to add category: $error';
      print(_errorMessage);
    }
    return false;
  }

  // Update an existing category
  Future<bool> updateCategory(Category category) async {
    try {
      final updatedCategory = await ApiService.updateCategory(category);
      if (updatedCategory != null) {
        final index = _categories.indexWhere((c) => c.id == category.id);
        if (index != -1) {
          _categories[index] = updatedCategory;
          notifyListeners();
          return true;
        }
      }
    } catch (error) {
      _errorMessage = 'Failed to update category: $error';
      print(_errorMessage);
    }
    return false;
  }

  // Delete a category
  Future<bool> deleteCategory(int id) async {
    try {
      final success = await ApiService.deleteCategory(id);
      if (success) {
        _categories.removeWhere((category) => category.id == id);
        notifyListeners();
        return true;
      }
    } catch (error) {
      _errorMessage = 'Failed to delete category: $error';
      print(_errorMessage);
    }
    return false;
  }
}