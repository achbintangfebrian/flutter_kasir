import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../services/api_service.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Use the singleton instance of ApiService
  ApiService _apiService = ApiService();

  // Allow setting the API service instance (for dependency injection)
  void setApiService(ApiService apiService) {
    _apiService = apiService;
  }

  Future<void> fetchCustomers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _customers = await _apiService.getCustomers();
    } catch (error) {
      _errorMessage = error.toString();
      print('Error fetching customers: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Customer> createCustomer(Map<String, dynamic> customerData) async {
    try {
      final customer = await _apiService.createCustomer(customerData);
      _customers.add(customer);
      notifyListeners();
      return customer;
    } catch (error) {
      _errorMessage = error.toString();
      print('Error creating customer: $error');
      rethrow;
    }
  }

  Future<Customer> updateCustomer(int id, Map<String, dynamic> customerData) async {
    try {
      final customer = await _apiService.updateCustomer(id, customerData);
      final index = _customers.indexWhere((element) => element.id == id);
      if (index != -1) {
        _customers[index] = customer;
        notifyListeners();
      }
      return customer;
    } catch (error) {
      _errorMessage = error.toString();
      print('Error updating customer: $error');
      rethrow;
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await _apiService.deleteCustomer(id);
      _customers.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      print('Error deleting customer: $error');
      rethrow;
    }
  }
}