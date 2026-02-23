import 'package:flutter/material.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 3; // default 3 stars
  final Set<String> _selectedTags = {};
  final TextEditingController _reviewController = TextEditingController();

  final List<String> _availableTags = [
    "Quiet Study Area",
    "Strong Wi-Fi",
    "Safe Moto Parking",
    "Near RUPP",
    "Affordable",
    "Clean Room",
    "Friendly Landlord",
    "Good Ventilation",
    "Close to Market",
  ];

  String get _ratingText {
    switch (_rating) {
      case 5:
        return "Excellent";
      case 4:
        return "Very Good";
      case 3:
        return "Good";
      case 2:
        return "Average";
      case 1:
        return "Poor";
      default:
        return "Select rating";
    }
  }

  Color get _ratingColor {
    if (_rating >= 4) return Colors.green.shade700;
    if (_rating == 3) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Write a Review",
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
            color: Color(0xFF07B741),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Modern Studio Near RUPP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Room 302, Tuol Kork, Phnom Penh",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // OVERALL EXPERIENCE
            const Text(
              "OVERALL EXPERIENCE",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: const Color(0xFF07B741),
                    size: 36,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    setState(() => _rating = index + 1);
                  },
                );
              }),
            ),

            const SizedBox(height: 8),

            Text(
              _ratingText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _ratingColor,
                fontFamily: 'PlusJakartaSans',
              ),
            ),

            const SizedBox(height: 32),

            // Quick Tags
            const Text(
              "Quick Tags",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(
                    tag,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: const Color(0xFF07B741),
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Detailed Review
            const Text(
              "Detailed Review",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _reviewController,
              maxLines: 6,
              minLines: 4,
              decoration: InputDecoration(
                hintText:
                "Mention the condition, landlord's response? Is it pictured? Neighborhood vibe for other students...",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontFamily: 'PlusJakartaSans',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(fontFamily: 'PlusJakartaSans'),
            ),

            const SizedBox(height: 16),

            // Small note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Your honest feedback helps fellow students in Phnom Penh find safe and stable housing. Thank you for contributing to our student community!",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Submit review to backend
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Review submitted! Thank you!")),
                  );
                  // Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF07B741),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Submit Review",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}