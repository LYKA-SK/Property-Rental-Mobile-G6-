import 'package:flutter/material.dart';
import '../home/write_review_screen.dart'; // Import your new write review file

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // Pre-loaded sample reviews
  final List<Map<String, dynamic>> _reviews = [
    {
      "name": "Sophea Meng",
      "avatar": "https://i.pravatar.cc/150?u=1",
      "rating": 5,
      "tags": ["Strong Wi-Fi", "Near RUPP"],
      "text": "Amazing studio! The Wi-Fi is super fast and the landlord replies quickly. Highly recommend for RUPP students.",
      "date": "Feb 20, 2025",
    },
    {
      "name": "Dara Chan",
      "avatar": "https://i.pravatar.cc/150?u=2",
      "rating": 4,
      "tags": ["Quiet Study Area", "Clean Room"],
      "text": "Very clean room and quiet environment. Perfect for studying. The only downside is the parking is a bit tight.",
      "date": "Jan 15, 2025",
    },
  ];

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1: return "Very Bad";
      case 2: return "Bad";
      case 3: return "Good";
      case 4: return "Very Good";
      case 5: return "Excellent";
      default: return "";
    }
  }

  void _openWriteReview() async {
    // Wait for result from WriteReviewScreen
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const WriteReviewScreen()),
    );

    // If a review was submitted, add it to the list
    if (result != null) {
      setState(() {
        _reviews.insert(0, {
          "name": "You",
          "avatar": "https://i.pravatar.cc/150?u=9",
          "rating": result["rating"],
          "tags": result["tags"],
          "text": result["text"],
          "date": _todayDate(),
        });
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Your review has been posted!"),
            backgroundColor: Color(0xFF1ADE7C),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String _todayDate() {
    final now = DateTime.now();
    const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Property Reviews",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _reviews.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reviews.length,
        itemBuilder: (context, index) {
          return _buildReviewCard(_reviews[index]);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1ADE7C),
        onPressed: _openWriteReview,
        label: const Text(
          "Write Review",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.edit, color: Colors.white),
        elevation: 4,
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final int rating = review["rating"] as int;
    final List<String> tags = List<String>.from(review["tags"] ?? []);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar + name + date
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(review["avatar"] as String),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review["name"] as String,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      review["date"] as String,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Rating badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1ADE7C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _ratingLabel(rating),
                  style: const TextStyle(
                    color: Color(0xFF1ADE7C),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Star row
          Row(
            children: List.generate(5, (i) => Icon(
              Icons.star_rounded,
              size: 18,
              color: i < rating
                  ? const Color(0xFF1ADE7C)
                  : const Color(0xFFE0E0E0),
            )),
          ),

          const SizedBox(height: 10),

          // Review text
          if ((review["text"] as String).isNotEmpty)
            Text(
              review["text"] as String,
              style: const TextStyle(
                fontSize: 13.5,
                color: Colors.black87,
                height: 1.55,
              ),
            ),

          // Tags
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1ADE7C).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF1ADE7C).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF1ADE7C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No reviews yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Be the first to review this property!",
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
        ],
      ),
    );
  }
}



