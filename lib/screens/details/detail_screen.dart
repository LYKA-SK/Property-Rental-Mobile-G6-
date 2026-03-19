import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? _propertyDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPropertyDetails();
  }

  // --- API Fetch: 1.3 Get by id Property ---
  Future<void> _fetchPropertyDetails() async {
    final int id = widget.item['id']; // ID passed from HomeScreen
    final url = Uri.parse('https://propertyrentalapi-simple.onrender.com/api/public/properties/$id');

    try {
      // Documentation specifies POST for this endpoint
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        setState(() {
          // Store the nested 'data' object from API response
          _propertyDetail = decodedData['data'];
          _isLoading = false;
        });
      } else {
        _handleError("Failed to load details (${response.statusCode})");
      }
    } catch (e) {
      _handleError("Connection error: $e");
    }
  }

  void _handleError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF10C66F);

    // Use API data if available, otherwise fallback to the item from the list
    final displayData = _propertyDetail ?? widget.item;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading && _propertyDetail == null
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image Header ---
            Stack(
              children: [
                Image.network(
                  displayData['image'] ?? "https://picsum.photos/400/300",
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Price & Title ---
                  Text(
                    "\$${displayData['price']} / month",
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    displayData['title'] ?? "Property Details",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // --- Location Row ---
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          displayData['address'] ?? "Phnom Penh, KH",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // --- Feature Chips ---
                  Row(
                    children: [
                      _buildChip(Icons.bed, "${displayData['beds'] ?? '1'} Bed"),
                      const SizedBox(width: 12),
                      _buildChip(Icons.bathtub, "${displayData['baths'] ?? '1'} Bath"),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Text(
                      "Description",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 10),
                  Text(
                    displayData['description'] ?? "No description available.",
                    style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 15),
                  ),
                  const SizedBox(height: 100), // Padding for bottom button
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(primaryGreen),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBottomButton(Color color) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 58),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: () {
          // Future implementation: Booking API
        },
        child: const Text(
            "Book a visit",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
        ),
      ),
    );
  }
}