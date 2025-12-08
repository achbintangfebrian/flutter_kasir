import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/login_screen.dart';

void main() {
  print('Main: Starting application');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('MyApp: Building application');
    // Create a single instance of ApiService to be shared across the app
    final apiService = ApiService();
    
    return MultiProvider(
      providers: [
        // Provide the ApiService as a singleton
        Provider<ApiService>.value(value: apiService),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) {
            print('Main: Creating CategoryProvider');
            final provider = CategoryProvider();
            provider.setApiService(apiService);
            return provider;
          },
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) {
            print('Main: Creating ProductProvider');
            final provider = ProductProvider();
            provider.setApiService(apiService);
            return provider;
          },
        ),
        ChangeNotifierProvider<CustomerProvider>(
          create: (_) {
            print('Main: Creating CustomerProvider');
            final provider = CustomerProvider();
            provider.setApiService(apiService);
            return provider;
          },
        ),
        ChangeNotifierProvider<TransactionProvider>(
          create: (_) {
            print('Main: Creating TransactionProvider');
            final provider = TransactionProvider();
            provider.setApiService(apiService);
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Smart Cashier',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(), // Start with login screen
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}