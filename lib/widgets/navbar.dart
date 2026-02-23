import 'package:flutter/material.dart';
import 'package:property_app/screens/home/home_screen.dart';
import 'package:property_app/screens/profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int userRole;
  final String userName; // New: receive the name

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
    final List<Widget> _pages = [
      const Center(child: Text('Home')),
      const MyFavoritesScreen(),
      const Center(child: Text('Bookings')),
      // Pass both name and role to the ProfileScreen
      ProfileScreen(userRole: widget.userRole, userName: widget.userName),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF07B741),
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