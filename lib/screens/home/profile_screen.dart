import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isAgent = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // 1. IMAGE PICKING LOGIC
  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selected = await _picker.pickImage(source: source);
    if (selected != null) {
      setState(() => _image = File(selected.path));
    }
  }

  // 2. PHONE VERIFICATION LOGIC
  void _startPhoneVerification() {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // Allows UI updates inside dialog
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Agent Verification"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Enter your phone number to receive a verification code."),
                const SizedBox(height: 15),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: "+1 234 567 890",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)),
                onPressed: () {
                  // Simulate sending SMS, then show Code Field
                  Navigator.pop(context);
                  _showCodeDialog(codeController);
                },
                child: const Text("Send Code"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCodeDialog(TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Code"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(letterSpacing: 10, fontSize: 24),
          decoration: const InputDecoration(hintText: "0000"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (controller.text == "1234") { // Example verification code
                setState(() => isAgent = true);
                Navigator.pop(context);
              }
            },
            child: const Text("Verify"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Profile Picture with Camera Icon
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFF2ECC71),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: _image != null
                          ? FileImage(_image!) as ImageProvider
                          : const NetworkImage('https://i.pravatar.cc/300'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showImagePicker(context),
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.add_a_photo, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text("Nea", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("nea@email.com", style: TextStyle(color: Color(0xFF2ECC71))),

            const SizedBox(height: 30),

            // Agent Switch Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: isAgent
                  ? _buildAgentBadge()
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _startPhoneVerification,
                child: const Text("Become an Agent", style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified, color: Color(0xFF2ECC71)),
          SizedBox(width: 8),
          const Text("Verified Agent Account", style: TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            _tile(Icons.calendar_today, "My Bookings"),
            const Divider(height: 1),
            _tile(Icons.favorite_border, "Saved Properties"),
            if (isAgent) ...[
              const Divider(height: 1),
              _tile(Icons.add_circle_outline, "Post Property", isGreen: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title, {bool isGreen = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2ECC71)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: isGreen ? Colors.green : Colors.black)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}