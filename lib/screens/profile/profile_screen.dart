import 'package:flutter/material.dart';
import 'profile_user.dart';
import 'profile_agent.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 0 = Student/User, 1 = Agent/Landlord
  int userRole = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildHeader(userRole == 1),

            // Logic: Show Agent view (Post/Update/Delete) or User view
            userRole == 1 ? const ProfileAgent() : const ProfileUser(),

            const SizedBox(height: 30),
            _buildLogoutButton(), // This is the method the error was asking for!
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isAgent) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
        ),
        const SizedBox(height: 10),
        const Text("Nea", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(isAgent ? "Agent Account" : "Student Account",
            style: const TextStyle(color: Color(0xFF2ECC71))),
      ],
    );
  }

  // DEFINING THE MISSING METHOD
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          // Add your logout logic here (e.g., clear API token)
        },
        icon: const Icon(Icons.logout, color: Colors.redAccent),
        label: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }
}