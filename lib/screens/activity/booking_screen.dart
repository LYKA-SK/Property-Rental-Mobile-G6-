import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Bookings",
          style: TextStyle(color: Color(0xFF07B741), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 2,
        itemBuilder: (context, index) {
          return _buildBookingCard(
            context,
            title: index == 0 ? "Skyline Student Loft" : "Cozy Studio near ITC",
            date: "Feb 28, 2026",
            price: index == 0 ? "\$250/mo" : "\$180/mo", // Shortened to fit better
            status: "Confirmed",
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(
      BuildContext context, {
        required String title,
        required String date,
        required String price,
        required String status,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // Updated to latest syntax
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wrap title in Expanded so long names don't push the status off screen
              Expanded(
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8EF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Color(0xFF07B741), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text("Move-in: $date", style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const Divider(height: 24),

          // BOTTOM ROW: FIXED OVERFLOW
          Row(
            children: [
              Text(price, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF07B741))),
              const Spacer(), // Pushes buttons to the right

              // Use Row with MainAxisSize.min to avoid taking up all space
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text("Cancel", style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07B741),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Contact Agent", style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}