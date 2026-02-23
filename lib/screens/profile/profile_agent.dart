import 'package:flutter/material.dart';

class ProfileAgent extends StatelessWidget {
  const ProfileAgent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Management Tools", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 15),

          _tile(Icons.add_circle_outline, "Post New Property", color: Colors.blue),
          const Divider(),
          _tile(Icons.edit_note, "Update My Listings", color: Colors.orange),
          const Divider(),
          _tile(Icons.delete_sweep_outlined, "Delete Properties", color: Colors.red),
          const Divider(),
          _tile(Icons.calendar_today, "View Bookings"),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, {Color color = Colors.black}) {
    Color iconColor = (color == Colors.black) ? const Color(0xFF2ECC71) : color;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {
        // Navigate to your specific API screens here
      },
    );
  }
}