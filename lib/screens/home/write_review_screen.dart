import 'package:flutter/material.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 3;
  final Set<String> _selectedTags = {};
  final TextEditingController _reviewController = TextEditingController();

  final List<String> _availableTags = [
    "Quiet Study Area", "Strong Wi-Fi", "Safe Moto Parking",
    "Near RUPP", "Affordable", "Clean Room",
    "Friendly Landlord", "Good Ventilation", "Close to Market",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Write a Review", style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF07B741))),
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
            _buildPropertyInfo(),
            const SizedBox(height: 28),
            _buildStarRating(),
            const SizedBox(height: 32),
            _buildQuickTags(),
            const SizedBox(height: 32),
            _buildTextField(),
            const SizedBox(height: 32),
            _buildSubmitButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Modern Studio Near RUPP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("Room 302, Tuol Kork, Phnom Penh", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("OVERALL EXPERIENCE", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black54)),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(index < _rating ? Icons.star_rounded : Icons.star_border_rounded, color: const Color(0xFF07B741), size: 36),
              onPressed: () => setState(() => _rating = index + 1),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuickTags() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _availableTags.map((tag) {
        final isSelected = _selectedTags.contains(tag);
        return ChoiceChip(
          label: Text(tag, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
          selected: isSelected,
          selectedColor: const Color(0xFF07B741),
          onSelected: (selected) {
            setState(() => selected ? _selectedTags.add(tag) : _selectedTags.remove(tag));
          },
        );
      }).toList(),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _reviewController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Neighborhood vibe for other students...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF07B741), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Review submitted! Thank you!")));
          Navigator.pop(context); // Go back to ReviewScreen
        },
        child: const Text("Submit Review", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}