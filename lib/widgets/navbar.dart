import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/activity/favorite_screen.dart';
import '../screens/profile/profile_screen.dart';

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

  // This function handles the "Only Home" logic
  void _onItemTapped(int index) {
    if (widget.userName == "Guest" && index != 0) {
      Navigator.pushNamed(context, '/login');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const HomeScreen(),
      const Center(child: Text('Search Page')),
      const MyFavoritesScreen(),
      const Center(child: Text('Bookings Page')),
      ProfileScreen(
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
        onTap: _onItemTapped, // Calls our custom logic
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