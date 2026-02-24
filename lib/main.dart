import 'package:flutter/material.dart';

// Import your screens
import 'package:property_app/screens/auth/login_screen.dart';
import 'package:property_app/screens/auth/register_screen.dart';
import 'package:property_app/screens/home/home_screen.dart';
import 'package:property_app/widgets/navbar.dart'; // ← this should contain MainNavigation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Property App',
      theme: ThemeData(
        primaryColor: const Color(0xFF2ECC71),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71),
          primary: const Color(0xFF2ECC71),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade50,
      ),
      // Start with login screen
      // main.dart
      initialRoute: '/home', // Change this to show Home first
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}