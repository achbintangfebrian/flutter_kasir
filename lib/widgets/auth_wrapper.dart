import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    print('AuthWrapper: Building widget, always returning HomeScreen');
    return const HomeScreen();
  }
}