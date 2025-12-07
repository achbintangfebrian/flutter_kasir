import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    print('AuthProvider: Starting login process for email: $email');

    try {
      final user = await _apiService.login(email, password);
      if (user.token.isEmpty) {
        print('AuthProvider: Login failed - empty token');
        throw Exception('Login failed: Empty token');
      }
      _user = user;
      print('AuthProvider: Login successful for user: ${_user?.name}');
      // Set the auth token in the API service
      _apiService.setAuthToken(_user!.token);
      notifyListeners();
    } catch (e, stackTrace) {
      print('AuthProvider: Login failed with error: ${e.toString()}');
      print('AuthProvider: Stack trace: $stackTrace');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
    print('AuthProvider: Login process completed');
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    print('AuthProvider: Starting registration process for name: $name, email: $email');

    try {
      final user = await _apiService.register(name, email, password);
      if (user.token.isEmpty) {
        print('AuthProvider: Registration failed - empty token');
        throw Exception('Registration failed: Empty token');
      }
      _user = user;
      print('AuthProvider: Registration successful for user: ${_user?.name}');
      // Set the auth token in the API service
      _apiService.setAuthToken(_user!.token);
      notifyListeners();
    } catch (e) {
      print('AuthProvider: Registration failed with error: ${e.toString()}');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
    print('AuthProvider: Registration process completed');
  }

  void logout() {
    print('AuthProvider: Logging out user');
    _user = null;
    // Clear the auth token in the API service
    _apiService.setAuthToken(null);
    notifyListeners();
  }
}