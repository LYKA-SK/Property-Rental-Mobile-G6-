import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Header Placeholder
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFD5F5E3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(child: Icon(Icons.apartment, size: 80, color: Colors.green)),
            ),
            const SizedBox(height: 30),
            const Text('Login to Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71))),
            const SizedBox(height: 30),

            // TextFields (Email/Password)
            TextField(decoration: InputDecoration(hintText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 15),
            TextField(obscureText: true, decoration: InputDecoration(hintText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),

            const SizedBox(height: 30),

            // THE SIGN IN BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // This command moves the user to the Home/Navbar screen!
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}