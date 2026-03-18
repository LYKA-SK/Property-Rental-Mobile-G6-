import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_user.dart';
import 'profile_agent.dart';
import 'package:property_app/screens/auth/login_screen.dart';

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
  late TextEditingController _nameController;
  bool _isEditingName = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _loadLocalImage();
  }

  // Load image from SharedPreferences when the screen opens
  Future<void> _loadLocalImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('profile_image_path');
    if (path != null && File(path).existsSync()) {
      setState(() => _image = File(path));
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isUpdating = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // Ensure this is not null

      var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://propertyrentalapi-simple.onrender.com/api/users/profile')
      );

      // Add Authorization Header
      request.headers['Authorization'] = 'Bearer $token';

      // Use 'file' as the key from your API documentation
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Assume your API returns the URL in a 'url' field
        String serverImageUrl = data['url'];

        // Save the URL so it works after logout/login
        await prefs.setString('profile_image_url', serverImageUrl);

        _showSnackBar("Image uploaded successfully!", Colors.green);
      } else if (response.statusCode == 401) {
        _showSnackBar("Session expired. Please login again.", Colors.redAccent);
      } else {
        _showSnackBar("Upload failed: ${response.statusCode}", Colors.redAccent);
      }
    } catch (e) {
      _showSnackBar("Error: $e", Colors.redAccent);
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      setState(() => _image = file);
      await _uploadImage(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true, // BACK BUTTON ENABLED
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isUpdating) const LinearProgressIndicator(color: Color(0xFF07B741)),
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 10),
            widget.userRole == 1 ? const ProfileAgentView() : const ProfileUserView(),
            const SizedBox(height: 40),
            _buildLogoutButton(), // FIXED: Now called correctly
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
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
              ),
              const CircleAvatar(
                  radius: 15,
                  backgroundColor: Color(0xFF07B741),
                  child: Icon(Icons.camera_alt, size: 14, color: Colors.white)
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _isEditingName ? _buildNameEditor() : _buildNameDisplay(),
        Text(widget.userBio, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildNameDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 40),
        Text(_nameController.text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        IconButton(
            icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
            onPressed: () => setState(() => _isEditingName = true)
        ),
      ],
    );
  }

  Widget _buildNameEditor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: TextField(
        controller: _nameController,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: _updateName
          ),
        ),
      ),
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
        onPressed: _handleLogout,
        child: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- API / HELPER METHODS ---
  Future<void> _updateName() async {
    // Implement your name update logic here similarly to _uploadImage
    setState(() => _isEditingName = false);
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    // Only remove session data, keep settings like the image URL if desired
    await prefs.remove('token');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false
    );
  }
}