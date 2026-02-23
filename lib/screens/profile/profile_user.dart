import 'package:flutter/material.dart';

class ProfileUserView extends StatelessWidget {
  const ProfileUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Activity", style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              children: [
                _menuTile(Icons.calendar_today_outlined, "My Bookings", context, const Center(child: Text("Bookings Screen"))),
                const Divider(height: 1, indent: 60),
                _menuTile(Icons.favorite_outline, "Saved Properties", context, const Center(child: Text("Saved Screen"))),
                const Divider(height: 1, indent: 60),
                _menuTile(Icons.chat_bubble_outline, "My Reviews", context, const Center(child: Text("Reviews Screen"))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title, BuildContext context, Widget destination) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFE8F8EF), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFF07B741), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
    );
  }
}