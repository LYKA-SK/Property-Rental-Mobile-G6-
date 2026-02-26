import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  bool _isSearchFocused = false;
  double _filterScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _animateIn(child: _buildHeader(), delay: 0),
              const SizedBox(height: 25),
              _animateIn(child: _buildCategoryTabs(), delay: 100),
              const SizedBox(height: 20),
              _animateIn(child: _buildSearchBar(), delay: 200),
              const SizedBox(height: 25),
              _animateIn(child: _buildSectionHeader("Featured Rooms"), delay: 300),
              const SizedBox(height: 15),
              _animateIn(child: _buildFeaturedList(), delay: 400),
              const SizedBox(height: 25),
              _animateIn(child: _buildSectionHeader("Recent Listings"), delay: 500),
              const SizedBox(height: 15),
              _buildRecentListings(), // This section was causing the stripes
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animateIn({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Location", style: TextStyle(color: Colors.grey, fontSize: 13)),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF1ADE7C), size: 20),
                SizedBox(width: 4),
                Text("Phnom Penh, KH", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: ClipOval(child: Image.network('https://i.pravatar.cc/150?u=9')),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    List<String> categories = ["Location", "Room For Rent", "Others"];
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1ADE7C) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [BoxShadow(color: const Color(0xFF1ADE7C).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))]
                    : [],
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold
                  ),
                ),
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
          child: Focus(
            onFocusChange: (hasFocus) => setState(() => _isSearchFocused = hasFocus),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _isSearchFocused ? const Color(0xFF1ADE7C) : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isSearchFocused
                        ? const Color(0xFF1ADE7C).withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search near RUPP, ITC...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTapDown: (_) => setState(() => _filterScale = 0.9),
          onTapUp: (_) => setState(() => _filterScale = 1.0),
          onTapCancel: () => setState(() => _filterScale = 1.0),
          child: AnimatedTransform(
            transform: Matrix4.diagonal3Values(_filterScale, _filterScale, 1.0),
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.center,
            child: Container(
              height: 55, width: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF1ADE7C),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: const Color(0xFF1ADE7C).withValues(alpha: 0.3), blurRadius: 10)],
              ),
              child: const Icon(Icons.tune, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const Text("See All", style: TextStyle(color: Color(0xFF1ADE7C), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFeaturedList() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 240,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Stack(
                    children: [
                      Image.network('https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500', height: 140, width: 240, fit: BoxFit.cover),
                      Positioned(
                        top: 12, left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                          child: const Text("\$250/mo", style: TextStyle(color: Color(0xFF1ADE7C), fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Skyline Student Loft", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey),
                          Text(" Near RUPP, Toul Kork", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentListings() {
    final List<Map<String, String>> data = [
      {"title": "Cozy Studio near ITC", "price": "\$150", "img": "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=400"},
      {"title": "Student Shared Room", "price": "\$120", "img": "https://images.unsplash.com/photo-1554995207-c18c203602cb?w=400"},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(data[index]['img']!, width: 90, height: 90, fit: BoxFit.cover),
              ),
              const SizedBox(width: 15),
              // THE FIX: Expanded tells the Column to only take available width
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFF1ADE7C).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(5)),
                          child: const Text("VERIFIED", style: TextStyle(color: Color(0xFF1ADE7C), fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                        Text(data[index]['price']!, style: const TextStyle(color: Color(0xFF1ADE7C), fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data[index]['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      overflow: TextOverflow.ellipsis, // Prevents text from pushing past screen edge
                    ),
                    const Text("Tuek La'ak, Phnom Penh", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _infoIcon(Icons.bed, "1 Bed"),
                        const SizedBox(width: 12),
                        _infoIcon(Icons.wifi, "WiFi"),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}

class AnimatedTransform extends StatelessWidget {
  final Widget child;
  final Matrix4 transform;
  final Duration duration;
  final Alignment alignment;

  const AnimatedTransform({
    super.key,
    required this.child,
    required this.transform,
    this.duration = const Duration(milliseconds: 200),
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      transform: transform,
      transformAlignment: alignment,
      child: child,
    );
  }
}