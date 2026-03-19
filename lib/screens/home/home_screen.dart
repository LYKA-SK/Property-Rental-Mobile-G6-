import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../details/detail_screen.dart';
import '../profile/profile_screen.dart';

// ================= MODEL =================
class Property {
  final int id;
  final String title;
  final String description;
  final String address;
  final double price;
  final String category;
  final String owner;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.price,
    required this.category,
    required this.owner,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category']?['name'] ?? '',
      owner: json['createdBy']?['fullname'] ?? '',
    );
  }
}

// ================= SCREEN =================
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

  List<Property> properties = [];
  bool isLoading = true;

  final List<String> _categories = ["Location", "Room For Rent", "Others"];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchProperties();
  }

  // ================= USER =================
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "User";
      _userRole = prefs.getInt('user_role') ?? 0;
      _remoteUrl = prefs.getString('profile_image_url');
    });
  }

  // ================= API =================
  Future<void> fetchProperties() async {
    try {
      final response = await http.get(
        Uri.parse('https://propertyrentalapi-simple.onrender.com/api/public/properties'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final List items = jsonData['data']['items'];

        setState(() {
          properties =
              items.map((item) => Property.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load properties");
      }
    } catch (e) {
      print("ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchProperties,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Location", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF1ADE7C)),
                SizedBox(width: 4),
                Text("Phnom Penh, KH",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  userRole: _userRole,
                  userName: _userName,
                ),
              ),
            );
            _loadUserData();
          },
          child: CircleAvatar(
            radius: 24,
            backgroundImage: (_remoteUrl != null && _remoteUrl!.isNotEmpty)
                ? NetworkImage(_remoteUrl!)
                : null,
            child: (_remoteUrl == null || _remoteUrl!.isEmpty)
                ? const Icon(Icons.person)
                : null,
          ),
        )
      ],
    );
  }

  // ================= CATEGORY =================
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
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= SEARCH =================
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search property...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ================= SECTION =================
  Widget _buildSectionHeader(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  // ================= FEATURED =================
  Widget _buildFeaturedList() {
    if (properties.isEmpty) {
      return const Center(child: Text("No properties"));
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return _buildPropertyCard(properties[index]);
        },
      ),
    );
  }

  Widget _buildPropertyCard(Property item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(
            item: {
              "title": item.title,
              "price": item.price.toString(),
              "location": item.address,
              "image": "https://picsum.photos/300",
              "description": item.description,
            },
          ),
        ),
      ),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "https://picsum.photos/300",
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("\$${item.price}",
                      style: const TextStyle(color: Colors.green)),
                  const SizedBox(height: 5),
                  Text(item.address,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ================= RECENT =================
  Widget _buildRecentListings() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final item = properties[index];

        return ListTile(
          leading: Image.network(
            "https://picsum.photos/300",
            width: 60,
            fit: BoxFit.cover,
          ),
          title: Text(item.title),
          subtitle: Text(item.address),
          trailing: Text("\$${item.price}"),
        );
      },
    );
  }
}