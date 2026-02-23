import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  final VoidCallback onBecomeAgent; // This will trigger the upgrade

  const UserView({super.key, required this.onBecomeAgent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        // Activity List for User
        _buildMenuCard([
          _menuTile(Icons.calendar_today, "My Bookings"),
          _menuTile(Icons.favorite_border, "Saved Properties"),
          _menuTile(Icons.chat_bubble_outline, "My Reviews"),
        ]),
        const SizedBox(height: 40),
        // The Upgrade Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2ECC71),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onBecomeAgent,
            child: const Text("Become an Agent", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _menuTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2ECC71)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }
}