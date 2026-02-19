import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background like the design
      body: Column(
        children: [
          const SizedBox(height: 60),
          // Profile Header
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFF2ECC71), // Green border
                  child: CircleAvatar(
                    radius: 52,
                    backgroundImage: NetworkImage('https://placeholder.com/150'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Text("Nea", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("nea@email.com", style: TextStyle(color: Color(0xFF2ECC71))),

          const SizedBox(height: 30),

          // Activity Section Container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("My Activity", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                _activityItem(Icons.calendar_today, "My Bookings", Colors.green.shade100, Colors.green),
                _activityItem(Icons.favorite_border, "Saved Properties", Colors.green.shade100, Colors.green),
                _activityItem(Icons.chat_bubble_outline, "My Reviews", Colors.green.shade100, Colors.green),
              ],
            ),
          ),

          const Spacer(), // Pushes logout to bottom

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                // Return to Login screen
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.redAccent),
                  SizedBox(width: 10),
                  Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper widget for the list items
  Widget _activityItem(IconData icon, String title, Color bgColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}