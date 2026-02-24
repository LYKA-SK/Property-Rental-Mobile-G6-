import 'package:flutter/material.dart';
import '../home/write_review_screen.dart'; // Import your new write review file

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Property Reviews",
          style: TextStyle(color: Color(0xFF07B741), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
              title: const Text("Student User", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < 4 ? Colors.amber : Colors.grey))),
                  const SizedBox(height: 5),
                  const Text("The room near RUPP is very clean and the owner is friendly!"),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF07B741),
        onPressed: () {
          // Link to your WriteReviewScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WriteReviewScreen()),
          );
        },
        label: const Text("Write Review", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}