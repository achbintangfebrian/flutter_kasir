import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/category_provider.dart';
import 'providers/product_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/auth_provider.dart';
import 'widgets/auth_wrapper.dart';

void main() {
  print('Main: Starting application');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          print('Main: Creating AuthProvider');
          return AuthProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          print('Main: Creating CategoryProvider');
          return CategoryProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          print('Main: Creating ProductProvider');
          return ProductProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          print('Main: Creating CustomerProvider');
          return CustomerProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          print('Main: Creating TransactionProvider');
          return TransactionProvider();
        }),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('MyApp: Building application');
    return MaterialApp(
      title: 'Smart Cashier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}