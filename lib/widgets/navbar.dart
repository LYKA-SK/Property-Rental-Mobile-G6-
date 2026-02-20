import 'package:flutter/material.dart';
import 'package:property_app/screens/home/search_screen.dart';
// 1. Import your new profile screen here
import 'package:property_app/screens/home/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // 2. Update the list to include the actual ProfileScreen widget
  final List<Widget> _pages = [
    const Center(child: Text('Home Page')),      // Tab 0
    const SearchScreen(),                         // Tab 1
    const Center(child: Text('Saved Page')),     // Tab 2
    const Center(child: Text('Bookings Page')),  // Tab 3
    const ProfileScreen(),                        // Tab 4 (Connected!)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // Using IndexedStack preserves the state of your pages
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2ECC71),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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