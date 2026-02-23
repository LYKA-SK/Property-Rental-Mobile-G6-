import 'package:flutter/material.dart';
import 'profile_user.dart';
import 'profile_agent.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // This is the switch: false = User View, true = Agent View
  bool isAgent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildHeader(), // Your profile pic and name

            // THE SWITCH LOGIC
            isAgent
                ? const AgentView()
                : UserView(onBecomeAgent: () {
              setState(() => isAgent = true); // Upgrade to agent
            }),

            const SizedBox(height: 30),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  // --- Common Header for both pages ---
  Widget _buildHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
        ),
        const SizedBox(height: 10),
        const Text("Nea", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const Text("nea@email.com", style: TextStyle(color: Colors.green)),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text("Logout", style: TextStyle(color: Colors.red)),
    );
  }
}