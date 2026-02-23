import 'package:flutter/material.dart';

class AgentView extends StatelessWidget {
  const AgentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        // Agent Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(20)),
          child: const Text("Agent", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
        // Activity List for Agent (Includes Post Property)
        _buildMenuCard([
          _menuTile(Icons.calendar_today, "My Bookings"),
          _menuTile(Icons.favorite_border, "Saved Properties"),
          _menuTile(Icons.chat_bubble_outline, "My Reviews"),
          const Divider(height: 1),
          _menuTile(Icons.add_box_outlined, "Post Property", isBlue: true),
        ]),
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

  Widget _menuTile(IconData icon, String title, {bool isBlue = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2ECC71)),
      title: Text(title, style: TextStyle(color: isBlue ? Colors.blue : Colors.black)),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }
}