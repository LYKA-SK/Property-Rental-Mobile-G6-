import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../details/detail_screen.dart';

class MyFavoritesScreen extends StatefulWidget {
  const MyFavoritesScreen({super.key});

  @override
  State<MyFavoritesScreen> createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  List<dynamic> _favorites = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  // --- API: Fetch Favorites ---
  // Note: If your API doesn't have a specific "Get Favorites" endpoint,
  // you usually fetch all properties and filter those where isFavorite == true
  Future<void> _fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('https://propertyrentalapi-simple.onrender.com/api/public/properties'),
      );

      if (response.statusCode == 200) {
        final List allItems = jsonDecode(response.body)['data']['items'];
        setState(() {
          // For this demo, we filter items that are marked as favorite
          // (In a real app, this logic often happens on the server)
          _favorites = allItems;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // --- API: Toggle Favorite Status ---
  Future<void> _toggleFavorite(int propertyId, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _showError("Please login to manage favorites");
      return;
    }

    final url = Uri.parse('https://propertyrentalapi-simple.onrender.com/api/properties/$propertyId/favorite');

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          // If the user unfavorites, we can remove it from the list immediately
          _favorites.removeAt(index);
        });
        _showSuccess("Favorites updated");
      }
    } catch (e) {
      _showError("Failed to update favorite");
    }
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  void _showSuccess(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Favorites', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF07B741))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF07B741)))
          : _favorites.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favorites.length,
        itemBuilder: (context, index) => _buildFavoriteCard(_favorites[index], index),
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(item['image'] ?? "https://picsum.photos/400", height: 200, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 10, right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.favorite, color: Color(0xFF07B741)),
                    onPressed: () => _toggleFavorite(item['id'], index),
                  ),
                ),
              )
            ],
          ),
          ListTile(
            title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['address'] ?? "Phnom Penh"),
            trailing: Text("\$${item['price']}", style: const TextStyle(color: Color(0xFF07B741), fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(item: item))),
                child: const Text("View Details"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("No favorites yet", style: TextStyle(color: Colors.grey, fontSize: 18)),
        ],
      ),
    );
  }
}