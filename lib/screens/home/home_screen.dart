import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../details/detail_screen.dart';
import '../profile/profile_screen.dart';

// ================= PROPERTY MODEL =================
class Property {
  final int id;
  final String title;
  final String description;
  final String address;
  final double price;
  final String? image;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.price,
    this.image,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      address: json['address'] ?? 'No Address',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = "User";
  int _userRole = 0;
  String? _remoteUrl;
  List<Property> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchProperties();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "User";
      _userRole = prefs.getInt('user_role') ?? 0;
      _remoteUrl = prefs.getString('profile_image_url');
    });
  }

  Future<void> fetchProperties() async {
    try {
      final response = await http.get(
        Uri.parse('https://propertyrentalapi-simple.onrender.com/api/public/properties'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List items = jsonData['data']['items'] ?? [];
        setState(() {
          properties = items.map((item) => Property.fromJson(item)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF1ADE7C)))
            : RefreshIndicator(
          onRefresh: fetchProperties,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 25),
                _buildSectionHeader("Featured Rooms"),
                const SizedBox(height: 15),
                _buildFeaturedList(),
                const SizedBox(height: 25),
                _buildSectionHeader("Recent Listings"),
                const SizedBox(height: 15),
                _buildRecentListings(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Location", style: TextStyle(color: Colors.grey, fontSize: 12)),
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF1ADE7C), size: 18),
                Text("Phnom Penh, KH", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userRole: _userRole, userName: _userName)));
            _loadUserData();
          },
          child: CircleAvatar(
            radius: 22,
            backgroundImage: (_remoteUrl != null && _remoteUrl!.isNotEmpty) ? NetworkImage(_remoteUrl!) : null,
            child: (_remoteUrl == null) ? const Icon(Icons.person) : null,
          ),
        )
      ],
    );
  }

  Widget _buildFeaturedList() {
    return SizedBox(
      height: 250, // FIXED: Increased height to stop the 17px overflow
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: properties.length,
        itemBuilder: (context, index) => _buildPropertyCard(properties[index]),
      ),
    );
  }

  Widget _buildPropertyCard(Property item) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(item: {'id': item.id}))),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(item.image ?? "https://picsum.photos/300", height: 130, width: 220, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text("\$${item.price}/mo", style: const TextStyle(color: Color(0xFF1ADE7C), fontWeight: FontWeight.bold)),
                  Text(item.address, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildRecentListings() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final item = properties[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(item.image ?? "https://picsum.photos/100", width: 50, height: 50, fit: BoxFit.cover)),
          title: Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          trailing: Text("\$${item.price}", style: const TextStyle(color: Color(0xFF1ADE7C), fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}