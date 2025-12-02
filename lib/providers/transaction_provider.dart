import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ApiService _apiService = ApiService();

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _apiService.getTransactions();
    } catch (error) {
      _errorMessage = error.toString();
      print('Error fetching transactions: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Transaction> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      final transaction = await _apiService.createTransaction(transactionData);
      _transactions.add(transaction);
      notifyListeners();
      return transaction;
    } catch (error) {
      _errorMessage = error.toString();
      print('Error creating transaction: $error');
      rethrow;
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _apiService.deleteTransaction(id);
      _transactions.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      print('Error deleting transaction: $error');
      rethrow;
    }
  }
}