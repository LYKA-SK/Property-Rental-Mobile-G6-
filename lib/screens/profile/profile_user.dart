import 'package:flutter/material.dart';

class ProfileUser extends StatelessWidget {
  const ProfileUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Activity", style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 10),
          _buildActivityCard([
            _tile(Icons.calendar_today, "My Bookings"),
            const Divider(height: 1),
            _tile(Icons.favorite_border, "Saved Properties"),
            const Divider(height: 1),
            _tile(Icons.chat_bubble_outline, "My Reviews"),
          ]),
        ],
      ),
    );
  }

  Widget _buildActivityCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _tile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2ECC71)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
    );
  }
}