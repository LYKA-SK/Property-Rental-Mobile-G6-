import 'package:flutter/material.dart';

class ProfileAgentView extends StatelessWidget {
  const ProfileAgentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("My Activity", style: TextStyle(color: Colors.grey, fontSize: 14)),
              _agentBadge(),
            ],
          ),
          const SizedBox(height: 12),
          _buildMenuBox([
            _menuTile(Icons.calendar_today_outlined, "My Bookings"),
            _menuTile(Icons.favorite_outline, "Saved Properties"),
            _menuTile(Icons.chat_bubble_outline, "My Reviews"),
            const Divider(),
            _menuTile(Icons.add_box_outlined, "Post Property", isGreen: true),
          ]),
        ],
      ),
    );
  }

  Widget _agentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(10)),
      child: const Text("Agent", style: TextStyle(color: Colors.white, fontSize: 10)),
    );
  }

  Widget _buildMenuBox(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _menuTile(IconData icon, String title, {bool isGreen = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2ECC71)),
      title: Text(title, style: TextStyle(fontWeight: isGreen ? FontWeight.bold : FontWeight.normal)),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }
}