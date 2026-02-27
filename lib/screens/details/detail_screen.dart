import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required Map<String, dynamic> item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentImageIndex = 0;

  // Placeholder images for the carousel
  final List<String> _images = [
    "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=2340&q=80",
    "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?ixlib=rb-4.0.3&auto=format&fit=crop&w=2340&q=80",
    "https://images.unsplash.com/photo-1493809842364-78817add7ffb?ixlib=rb-4.0.3&auto=format&fit=crop&w=2340&q=80",
  ];

  @override
  Widget build(BuildContext context) {
    // Define the primary green color from your design
    const Color primaryGreen = Color(0xFF10C66F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top Section: Image Carousel & Floating Buttons ---
            Stack(
              children: [
                // 1. Image Carousel
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    itemCount: _images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        _images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey))),
                      );
                    },
                  ),
                ),

                // 2. Top Floating Buttons (Back, Share, Fav)
                Positioned(
                  top: 50, // Adjust for status bar
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircleButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          _buildCircleButton(icon: Icons.share, onTap: () {}),
                          const SizedBox(width: 12),
                          _buildCircleButton(icon: Icons.favorite_border, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Pagination Dots
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _images.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(
                              _currentImageIndex == entry.key ? 0.9 : 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            // --- Content Section ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "\$150 ",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: "/ month",
                          style: TextStyle(fontSize: 16, color: primaryGreen, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  const Text(
                    "Modern Studio Near RUPP",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Location
                  const Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        "Tuol Kork, Phnom Penh",
                        style: TextStyle(color: primaryGreen, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Feature Chips (1 Bed, 1 Bath, Verified)
                  Row(
                    children: [
                      _buildFeatureChip(icon: Icons.bed, label: "1 Bed"),
                      const SizedBox(width: 12),
                      _buildFeatureChip(icon: Icons.bathtub_outlined, label: "1 Bath"),
                      const SizedBox(width: 12),
                      _buildFeatureChip(icon: Icons.verified, label: "Verified", isVerified: true),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Description
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    "Perfectly located just 5 minutes from the Royal University of Phnom Penh. This high-clarity studio offers a minimalist lifestyle with natural light, secure parking, and 24/7 security. Ideal for students seeking a quiet study environment.",
                    style: TextStyle(color: Colors.grey[600], height: 1.5),
                  ),
                  const SizedBox(height: 25),

                  // Amenities
                  const Text("Amenities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildAmenityItem(Icons.wifi, "Free WiFi"),
                      _buildAmenityItem(Icons.ac_unit, "Air Con"),
                      _buildAmenityItem(Icons.local_laundry_service, "Laundry"),
                      _buildAmenityItem(Icons.security, "Security"),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Location Map
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Open in Maps", style: TextStyle(color: primaryGreen)),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          // Generic map placeholder image
                          image: NetworkImage("https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg"),
                          fit: BoxFit.cover,
                        )
                    ),
                    child: Center(
                      child: Icon(Icons.location_on, size: 40, color: primaryGreen),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "St. 256, Tuol Kork, Phnom Penh, Cambodia",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ],
        ),
      ),

      // --- Bottom "Book a Visit" Button ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Book a visit",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }

  Widget _buildFeatureChip({required IconData icon, required String label, bool isVerified = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isVerified ? const Color(0xFFE8F5E9) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
              icon,
              size: 16,
              color: isVerified ? Colors.green : Colors.grey[600]
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isVerified ? Colors.green : Colors.grey[800],
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String label) {
    return SizedBox(
      width: 150, // Roughly half width minus padding
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.grey[800]),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

