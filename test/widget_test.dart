// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:kasir_bintang/main.dart';
import 'package:kasir_bintang/providers/product_provider.dart';
import 'package:kasir_bintang/providers/category_provider.dart';
import 'package:kasir_bintang/providers/transaction_provider.dart';

void main() {
  testWidgets('App launches and shows login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ],
        child: const SmartCashierApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('Smart Cashier'), findsOneWidget);
    
    // Verify that we're on the login screen (check for login-related widgets)
    expect(find.text('Login'), findsWidgets);
  });
}