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
  late TextEditingController _nameController;
  bool _isEditingBio = false;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.userBio);
    _nameController = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _bioController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // --- FIXED: Missing _pickImage method ---
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
            _buildHeader(),

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
            // Check role to show Agent or User view
            widget.userRole == 1 ? const ProfileAgentView() : const ProfileUserView(),
            const SizedBox(height: 40),
            _buildLogoutButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

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

        // --- NAME EDITING LOGIC ---
        _isEditingName
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: TextField(
            controller: _nameController,
            autofocus: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () => setState(() => _isEditingName = false),
              ),
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40),
            Text(
              _nameController.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
              onPressed: () => setState(() => _isEditingName = true),
            ),
          ],
        ),
      ],
    );
  }

  // --- FIXED: Moved inside the _ProfileScreenState class ---
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