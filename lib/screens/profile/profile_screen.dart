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
  late TextEditingController _bioController;
  late TextEditingController _nameController;
  bool _isEditingName = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.userBio);
    _nameController = TextEditingController(text: widget.userName);
  }

  // --- API: 2.1 Upload Profile Image (Multipart/form-data) ---
  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isUpdating = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://propertyrentalapi.onrender.com/api/users/profile')
      );

      request.headers['Authorization'] = 'Bearer $token';
      // Key must be 'file' as shown in your Postman screenshot
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        _showSnackBar("Image uploaded successfully!", Colors.green);
      } else {
        _showSnackBar("Image upload failed", Colors.redAccent);
      }
    } catch (e) {
      _showSnackBar("Error connecting to server", Colors.redAccent);
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  // --- API: 3.1 Update Fullname ---
  Future<void> _updateName() async {
    setState(() => _isUpdating = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('https://propertyrentalapi.onrender.com/api/me/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"fullname": _nameController.text.trim()}),
      );

      if (response.statusCode == 200) {
        await prefs.setString('user_name', _nameController.text.trim());
        setState(() => _isEditingName = false);
        _showSnackBar("Name updated!", Colors.green);
      }
    } catch (e) {
      _showSnackBar("Update failed", Colors.redAccent);
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
      _uploadImage(file); // Call the API immediately after picking
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false
    );
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            if (_isUpdating) const LinearProgressIndicator(color: Color(0xFF07B741)),
            _buildHeader(),
            const SizedBox(height: 10),
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
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
              ),
              const CircleAvatar(radius: 15, backgroundColor: Color(0xFF07B741), child: Icon(Icons.camera_alt, size: 14, color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _isEditingName
            ? _buildNameEditor()
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40),
            Text(_nameController.text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.edit, size: 18, color: Colors.grey), onPressed: () => setState(() => _isEditingName = true)),
          ],
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
          suffixIcon: IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: _updateName),
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
}