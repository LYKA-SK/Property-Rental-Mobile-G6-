// lib/screens/home/my_favorites_screen.dart

import 'package:flutter/material.dart';
import '../details/detail_screen.dart';

class MyFavoritesScreen extends StatefulWidget {
  const MyFavoritesScreen({super.key});

  @override
  State<MyFavoritesScreen> createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  final List<Map<String, dynamic>> _favorites = [
    // Original items
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

    // Additional realistic favorites (2025–2026 Cambodia rentals)
    {
      'image':
      'https://images.realestate.com.kh/listings/2026-02/img_2278-2.jpeg',
      'title': 'Modern 1-Bedroom Condo',
      'location': 'Toul Tom Poung, Phnom Penh',
      'price': '\$650/month',
      'beds': 1,
      'baths': 1,
      'isFavorite': true,
    },
    {
      'image':
      'https://camrealtyservice.com/wp-content/uploads/2026/02/modern-style-2-bedrooms-serviced-apartment-for-rent-near-vattanak-tower-3.jpg',
      'title': 'Serviced 2-Bedroom Apartment',
      'location': 'BKK1, Phnom Penh',
      'price': '\$1,200/month',
      'beds': 2,
      'baths': 2,
      'isFavorite': true,
    },
    {
      'image':
      'https://camrealtyservice.com/wp-content/uploads/2020/04/2-bedrooms-condo-for-rent-along-street-2004-N734168-Phnom-Penh-1.jpg',
      'title': 'Cozy 2-Bedroom near Airport',
      'location': 'Prampi Makara, Phnom Penh',
      'price': '\$900/month',
      'beds': 2,
      'baths': 2,
      'isFavorite': true,
    },
    {
      'image':
      'http://homeconnectcambodia.com/wp-content/uploads/2017/11/IMG_9036.jpg',
      'title': 'Spacious 4-Bedroom Villa + Garden',
      'location': 'Prek Eng, Phnom Penh',
      'price': '\$2,800/month',
      'beds': 4,
      'baths': 3,
      'isFavorite': true,
    },
    {
      'image':
      'https://photos.ips-cambodia.com/photos/property/18779/24062509088db160-18779-Studio-Apartment-For-Rent-Svay-Dangkum-Siem-Reap5-850x567.tab.jpg',
      'title': 'Studio Apartment near Pub Street',
      'location': 'Svay Dangkum, Siem Reap',
      'price': '\$450/month',
      'beds': 1,
      'baths': 1,
      'isFavorite': true,
    },
  ];

  final List<String> _filters = [
    'All',
    'Room',
    'Condo',
    'House / Villa',
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    // Simple keyword-based filtering
    final filteredFavorites = _selectedFilter == 'All'
        ? _favorites
        : _favorites.where((item) {
      final titleLower = item['title'].toString().toLowerCase();
      if (_selectedFilter == 'Condo') {
        return titleLower.contains('condo') || titleLower.contains('serviced');
      } else if (_selectedFilter == 'House / Villa') {
        return titleLower.contains('house') || titleLower.contains('villa');
      } else if (_selectedFilter == 'Room') {
        return titleLower.contains('room') ||
            titleLower.contains('studio') ||
            titleLower.contains('apartment') && !titleLower.contains('serviced');
      }
      return true;
    }).toList();

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
              // TODO: open advanced filter bottom sheet
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
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),

          // Favorites list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredFavorites.length,
              itemBuilder: (context, index) {
                final item = filteredFavorites[index];
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
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.grey.shade50,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFF07B741),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image_rounded,
                        size: 80,
                        color: Colors.grey,
                      ),
                    );
                  },
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
                        // Optional: if !isFavorite → remove from list or mark for later sync
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
                  height: 48,
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(item: item),
                          ),
                        );
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
          const SizedBox(width: 6),
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