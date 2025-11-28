import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Fetch all transactions
  Future<void> fetchTransactions() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _transactions = await ApiService.getTransactions();
    } catch (error) {
      _errorMessage = 'Failed to load transactions: $error';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new transaction
  Future<bool> addTransaction(Transaction transaction) async {
    try {
      final newTransaction = await ApiService.createTransaction(transaction);
      if (newTransaction != null) {
        _transactions.insert(0, newTransaction); // Add to the beginning of the list
        notifyListeners();
        return true;
      }
    } catch (error) {
      _errorMessage = 'Failed to add transaction: $error';
      print(_errorMessage);
    }
    return false;
  }

  // Delete a transaction
  Future<bool> deleteTransaction(int id) async {
    try {
      final success = await ApiService.deleteTransaction(id);
      if (success) {
        _transactions.removeWhere((transaction) => transaction.id == id);
        notifyListeners();
        return true;
      }
    } catch (error) {
      _errorMessage = 'Failed to delete transaction: $error';
      print(_errorMessage);
    }
    return false;
  }
}