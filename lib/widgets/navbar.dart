import 'package:flutter/material.dart';
import 'package:property_app/screens/home/home_screen.dart';
import 'package:property_app/screens/profile/profile_screen.dart';
// import 'package:property_app/screens/home/my_favorites_screen.dart'; // Make sure this path is correct

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

  @override
  Widget build(BuildContext context) {
    // We create a list of 5 widgets to match the 5 icons below
    final List<Widget> _pages = [
      const Center(child: Text('Home Page')),      // Index 0: HOME
      const Center(child: Text('Search Page')),    // Index 1: SEARCH
      const MyFavoritesScreen(),                   // Index 2: SAVED (Your new code!)
      const Center(child: Text('Bookings Page')),  // Index 3: BOOKINGS
      ProfileScreen(                               // Index 4: PROFILE
          userRole: widget.userRole,
          userName: widget.userName
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF07B741),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'SEARCH'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'SAVED'),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: 'BOOKINGS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      ),
    );
  }
}