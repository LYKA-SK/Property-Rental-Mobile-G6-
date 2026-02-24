import 'dart:io';
import 'package:flutter/material.dart';
import 'package:property_app/widgets/navbar.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_user.dart';
import 'profile_agent.dart';

class ProfileScreen extends StatefulWidget {
  final int userRole;
  final String userName;
  final String userBio;

  const ProfileScreen({
    super.key,
    required this.userRole,
    required this.userName,
    this.userBio = "Student at RUPP",
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  late TextEditingController _bioController;
  bool _isEditingBio = false;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.userBio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildHeader(), // Now defined below

            // --- BIO SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: _isEditingBio
                  ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _bioController,
                      autofocus: true,
                      decoration: const InputDecoration(hintText: "Enter bio..."),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => setState(() => _isEditingBio = false),
                  ),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      _bioController.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 16, color: Colors.grey),
                    onPressed: () => setState(() => _isEditingBio = true),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            widget.userRole == 1 ? const ProfileAgentView() : const ProfileUserView(),
            const SizedBox(height: 40),
            _buildLogoutButton(), // Now defined below
          ],
        ),
      ),
    );
  }

  // FIXED: Moved inside the _ProfileScreenState class
  Widget _buildHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const NetworkImage('https://i.pravatar.cc/300') as ImageProvider,
              ),
              const CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xFF07B741),
                child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(widget.userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainNavigation(
                userName: "Guest",
                userRole: 0,
              ),
            ),
                (route) => false,
          );
        },
        child: const Text(
          "Logout",
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}