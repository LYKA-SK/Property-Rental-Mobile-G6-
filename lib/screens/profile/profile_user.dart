import 'package:flutter/material.dart';
import '../activity/booking_screen.dart';   // Ensure this file exists
import '../activity/favorite_screen.dart';  // Ensure this file exists
import '../activity/review_screen.dart';        // Match the class name ReviewScreen

class ProfileUserView extends StatelessWidget {
  const ProfileUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Fixed the 'crossAxisAlignment' error
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
                // Fixed: Added BuildContext to the method calls
                _buildMenuTile(context, Icons.calendar_today_outlined, "My Bookings", const BookingScreen()),
                const Divider(height: 1, indent: 60),
                _buildMenuTile(context, Icons.favorite_outline, "Saved Properties", const MyFavoritesScreen()),
                const Divider(height: 1, indent: 60),
                _buildMenuTile(context, Icons.chat_bubble_outline, "My Reviews", const ReviewScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FIXED: Parameter list and Navigator logic
  Widget _buildMenuTile(BuildContext context, IconData icon, String title, Widget destination) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F8EF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF07B741), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}