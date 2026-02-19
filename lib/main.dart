import 'package:flutter/material.dart';
import 'package:property_app/screens/auth/login_screen.dart';
import 'package:property_app/widgets/navbar.dart';

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
        primaryColor: const Color(0xFF2ECC71), // The green from your design
        useMaterial3: true,
      ),
      // Set the LoginScreen as the first thing people see
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}