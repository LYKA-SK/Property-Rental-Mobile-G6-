import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/activity/favorite_screen.dart';
import '../screens/activity/review_screen.dart';
import '../screens/activity/booking_screen.dart';
import 'package:property_app/screens/profile/profile_screen.dart' as profile_page;
class MainNavigation extends StatefulWidget {
  final int userRole;
  final String userName;

  const MainNavigation({
    super.key,
    this.userRole = 0,
    this.userName = "Guest"
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (widget.userName == "Guest" && index != 0) {
      Navigator.pushNamed(context, '/login');
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),                          // Index 0
      const ReviewScreen(),                        // Index 1: Swapped Search for Reviews
      const MyFavoritesScreen(),                   // Index 2
      const BookingScreen(),                       // Index 3: Connected to BookingScreen

      profile_page.ProfileScreen( // Use the nickname here
        userRole: widget.userRole,
        userName: widget.userName,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      // FIXED: Removed duplicate floatingActionButton code
      floatingActionButton: widget.userRole == 1
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF07B741),
        onPressed: () { /* Agent Post Logic */ },
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF07B741),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'REVIEWS'), // Updated Icon/Label
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'SAVED'),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: 'BOOKINGS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      ),
    );
  }
}