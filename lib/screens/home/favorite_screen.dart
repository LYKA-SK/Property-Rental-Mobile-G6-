// lib/screens/home/my_favorites_screen.dart

import 'package:flutter/material.dart';

class MyFavoritesScreen extends StatefulWidget {
  const MyFavoritesScreen({super.key});

  @override
  State<MyFavoritesScreen> createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  final List<Map<String, dynamic>> _favorites = [
    {
      'image':
      'https://a0.muscache.com/im/pictures/hosting/Hosting-1298149296746584747/original/0ba47f87-27ff-473e-bcc2-1942c525dc0e.jpeg',
      'title': 'Room For Rent Siem Reap',
      'location': 'Krong Siem Reap, Siem Reap',
      'price': '\$1,250/month',
      'beds': 2,
      'baths': 1,
      'isFavorite': true,
    },
    {
      'image':
      'https://a0.muscache.com/im/pictures/hosting/Hosting-1464549350294255150/original/a40f648b-a25b-4923-9761-7adbf5cd1e13.jpeg?im_w=720',
      'title': 'Apartment Available For Rent',
      'location': 'Boeng Keng Kang, Phnom Penh',
      'price': '\$1,600/month',
      'beds': 2,
      'baths': 2,
      'isFavorite': true,
    },
    {
      'image': 'https://luxrealty.asia/wp-content/uploads/2025/08/house-pu-sona-13.jpg',
      'title': 'Modern House With Garden',
      'location': 'Mean Chey, Phnom Penh',
      'price': '\$2,200/month',
      'beds': 3,
      'baths': 2,
      'isFavorite': true,
    },

  ];

  final List<String> _filters = [
    'All',
    'Room',
    'Condo',
    'House / Villa',
    'Near RUPP',
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
            color: Color(0xFF07B741),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Color(0xFF07B741)),
            onPressed: () {
              // TODO: advanced filter bottom sheet
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search near RUPP, ITC...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: _filters.map((filter) {
                final isSelected = filter == _selectedFilter;
                return ChoiceChip(
                  label: Text(
                    filter,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF333333),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF07B741),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : Colors.grey.shade300,
                      width: 1.2,
                    ),
                  ),
                  elevation: isSelected ? 3 : 1,
                  shadowColor: Colors.black.withOpacity(0.12),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedFilter = filter;
                        // Future: filter the list here
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),

          // List of saved items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final item = _favorites[index];
                return _buildFavoriteCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  item['image'],
                  height: 400,                    // ← changed to 200
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,                  // ← matched to 200
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.55),
                  radius: 20,
                  child: IconButton(
                    icon: Icon(
                      item['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                      color: item['isFavorite'] ? const Color(0xFF07B741) : Colors.white,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        item['isFavorite'] = !item['isFavorite'];
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'PlusJakartaSans',
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['location'],
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['price'],
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF07B741),
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip('${item['beds']} Bed', Icons.bed_outlined),
                    const SizedBox(width: 12),
                    _buildInfoChip('${item['baths']} Bath', Icons.bathtub_outlined),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: navigate to detail page
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF07B741), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: Color(0xFF07B741),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'PlusJakartaSans',
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}