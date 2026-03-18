import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../details/detail_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  String _userName = "User";
  int _userRole = 0;
  String? _remoteUrl;

  final List<String> _categories = ["Location", "Room For Rent", "Others"];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "User";
      _userRole = prefs.getInt('user_role') ?? 0;
      // Fetch the remote URL saved during profile upload
      _remoteUrl = prefs.getString('profile_image_url');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 25),
              _buildCategoryTabs(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildSectionHeader("Featured Rooms"),
              const SizedBox(height: 15),
              _buildFeaturedList(),
              const SizedBox(height: 25),
              _buildSectionHeader("Recent Listings"),
              const SizedBox(height: 15),
              _buildRecentListings(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Current Location", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 4),
            Row(
              children: const [
                Icon(Icons.location_on, color: Color(0xFF1ADE7C), size: 20),
                SizedBox(width: 4),
                Text("Phnom Penh, KH", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () async {
            // FIXED: Passing actual variables instead of null/empty strings
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userRole: _userRole,
                  userName: _userName,
                ),
              ),
            );
            _loadUserData(); // Refresh the image when returning from Profile
          },
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[200],
            // FIXED: Using NetworkImage for remote URLs
            backgroundImage: (_remoteUrl != null && _remoteUrl!.isNotEmpty)
                ? NetworkImage(_remoteUrl!)
                : null,
            child: (_remoteUrl == null || _remoteUrl!.isEmpty)
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
        ),
      ],
    );
  }

  // ... (Keep the rest of your UI building methods as they were)

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1ADE7C) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [if(!isSelected) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Center(
                child: Text(_categories[index],
                    style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.w600)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15)],
            ),
            child: const TextField(
              decoration: InputDecoration(
                  hintText: "Search property...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey)
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 55, width: 55,
          decoration: BoxDecoration(color: const Color(0xFF1ADE7C), borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.tune, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const Text("See All", style: TextStyle(color: Color(0xFF1ADE7C), fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildFeaturedList() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (context, index) {
          final item = {
            "title": index == 0 ? "Skyline Student Loft" : "Modern Apartment",
            "price": index == 0 ? "250" : "300",
            "location": "Toul Kork, Phnom Penh",
            "image": index == 0
                ? "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267"
                : "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688",
            "beds": "1 Bed", "baths": "1 Bath",
            "description": "A beautiful place located near the university campus."
          };
          return _buildPropertyCard(item);
        },
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(item: item))),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(item['image'] as String, height: 130, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 5),
                  Text("\$${item['price']}/mo", style: const TextStyle(color: Color(0xFF1ADE7C), fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecentListings() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        final item = {
          "title": "Cozy Studio near ITC",
          "price": "150",
          "location": "Tuek La'ak, Phnom Penh",
          "image": "https://images.unsplash.com/photo-1493809842364-78817add7ffb",
          "beds": "1 Bed", "baths": "Shared Bath",
          "description": "Perfect for students on a budget."
        };
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(item: item))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(item['image']!, width: 70, height: 70, fit: BoxFit.cover),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text("\$${item['price']}", style: const TextStyle(color: Color(0xFF1ADE7C), fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}