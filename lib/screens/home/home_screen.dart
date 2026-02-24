import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Location Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Location',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: Color(0xFF07B741), size: 18),
                          SizedBox(width: 4),
                          Text('Phnom Penh, KH',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundImage: NetworkImage('https://placeholder.com/user_image'),
                  )
                ],
              ),
              const SizedBox(height: 20),
              // Category Filters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryChip('Location', true),
                  _buildCategoryChip('Room for Rent', false),
                  _buildCategoryChip('Others', false),
                ],
              ),
              const SizedBox(height: 20),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search near RUPP, ITC...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF07B741),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 25),
              _buildSectionHeader('Featured Rooms'),
              const SizedBox(height: 15),
              // Add your Horizontal List for Featured Rooms here
              _buildSectionHeader('Recent Listings'),
              const SizedBox(height: 15),
              // Add your Vertical List for Recent Listings here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF07B741) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
      ),
      child: Text(label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('See All', style: TextStyle(color: Color(0xFF07B741), fontSize: 14)),
      ],
    );
  }
}