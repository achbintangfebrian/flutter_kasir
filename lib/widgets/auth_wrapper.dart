import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    print('AuthWrapper: Building widget, isAuthenticated: ${authProvider.isAuthenticated}, isLoading: ${authProvider.isLoading}');
    
    // Show splash screen while checking auth state
    if (authProvider.isLoading) {
      print('AuthWrapper: Showing loading indicator');
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // Return HomeScreen if authenticated, otherwise LoginScreen
    final isAuthenticated = authProvider.isAuthenticated;
    print('AuthWrapper: isAuthenticated = $isAuthenticated');
    if (isAuthenticated) {
      print('AuthWrapper: Returning HomeScreen');
      return const HomeScreen();
    } else {
      print('AuthWrapper: Returning LoginScreen');
      return const LoginScreen();
    }
  }
}