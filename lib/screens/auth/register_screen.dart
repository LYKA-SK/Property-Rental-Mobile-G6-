import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Make sure to import your MainNavigation file
// Adjust the path according to your project structure
import 'package:property_app/widgets/navbar.dart'; // ← if MainNavigation is here
// OR: import 'package:property_app/screens/main_navigation.dart';  // example

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedRole;
  String _countryCode = '+855';

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;
  bool _isLoading = false;

  final List<String> _roles = ['User', 'Agent'];
  final List<String> _countryCodes = ['+855', '+60', '+66', '+84', '+1'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('dd MMM yyyy').format(date);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null || !_termsAccepted || _selectedDate == null) return;

    setState(() => _isLoading = true);

    // Simulate registration delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() => _isLoading = false);

    if (!mounted) return;

    final name = _fullNameController.text.trim();
    final roleValue = (_selectedRole == 'Agent') ? 1 : 0;

    // If you later want to pass more fields, collect them here:
    // final username = _usernameController.text.trim();
    // final email = _emailController.text.trim();
    // final phone = '$_countryCode ${_phoneController.text.trim()}';
    // final dob = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigation(
          userName: name,
          userRole: roleValue,
          // username: username,   // uncomment when MainNavigation accepts it
          // email: email,
          // phone: phone,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF07B741),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                Text(
                  'Join the student community in Phnom Penh',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Rith Sophea',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Required';
                    if (value.trim().length < 3) return 'Too short';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'rith_sophea99',
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Required';
                    if (value.trim().length < 4) return 'Min 4 characters';
                    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                      return 'Letters, numbers, underscore only';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Date of Birth (fixed version)
                TextFormField(
                  readOnly: true,
                  initialValue: _formatDate(_selectedDate),
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'Select your birth date',
                    prefixIcon: const Icon(Icons.calendar_today_rounded),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onTap: () => _selectDate(context),
                  validator: (_) => _selectedDate == null ? 'Required' : null,
                ),

                const SizedBox(height: 20),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@gmail.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Phone Number
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: DropdownButtonFormField<String>(
                        value: _countryCode,
                        decoration: InputDecoration(
                          labelText: 'Code',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _countryCodes.map((code) {
                          return DropdownMenuItem(value: code, child: Text(code));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _countryCode = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '12 345 678',
                          prefixIcon: const Icon(Icons.phone_android_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return 'Required';
                          final clean = value.trim().replaceAll(RegExp(r'[^0-9]'), '');
                          if (clean.length < 8 || clean.length > 10) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 6) return 'Min 6 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Role Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  hint: const Text('Select your role'),
                  decoration: InputDecoration(
                    labelText: 'Role',
                    prefixIcon: const Icon(Icons.group_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: _roles.map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedRole = value),
                  validator: (value) => value == null ? 'Required' : null,
                ),

                const SizedBox(height: 32),

                // Terms & Conditions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      activeColor: const Color(0xFF07B741),
                      onChanged: (value) => setState(() => _termsAccepted = value ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Wrap(
                          children: [
                            Text('I agree to the ', style: TextStyle(color: Colors.grey[700])),
                            GestureDetector(
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Terms of Service')),
                              ),
                              child: const Text(
                                'Terms of Service',
                                style: TextStyle(color: Color(0xFF07B741), fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(' and ', style: TextStyle(color: Colors.grey[700])),
                            GestureDetector(
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Privacy Policy')),
                              ),
                              child: const Text(
                                'Privacy Policy',
                                style: TextStyle(color: Color(0xFF07B741), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Register Button
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading || !_termsAccepted ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07B741),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                        : const Text(
                      'Register',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Already have account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: TextStyle(color: Colors.grey[700])),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Color(0xFF07B741), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}