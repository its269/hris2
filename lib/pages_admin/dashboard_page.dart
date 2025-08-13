import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'profile_edit_page.dart';
import 'account_settings_page.dart';
import 'employee_model.dart';
import '../theme_provider.dart';

class DashboardPage extends StatefulWidget {
  final String role;
  final String employeeId;

  const DashboardPage({
    super.key,
    required this.role,
    required this.employeeId,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('avatar_path');
    if (path != null && path.isNotEmpty) {
      setState(() {
        _avatarImage = File(path);
        _avatarPath = path;
      });
    }
  }

  // PLACEHOLDER DATA - Replace with actual API calls when available
  String get employeeName => widget.employeeId; // Using employeeId as name for now
  String get employeePosition => "Sample Position"; // Placeholder position
  String get employeeDepartment => "HR"; // Placeholder department

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 300,
            maxHeight: 300,
            imageQuality: 85,
          );
          if (image != null) {
            setState(() {
              _avatarImage = File(image.path);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Avatar updated (placeholder, not retained).'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error picking image: $e'),
              backgroundColor: Colors.red,
            ),
          );
    }
  }
  // String? _avatarPath; // Removed to avoid persistence
  void _navigateToEditProfile() {
    // TODO: PLACEHOLDER - Create a sample employee object for editing
    // In the future, this will fetch the actual employee data from API
    final sampleEmployee = Employee(
      employeeID: widget.employeeId,
      firstName: 'Sample',
      middleName: '',
      lastName: 'User',
      suffix: '',
      nickname: '',
      birthday: '',
      age: '',
      birthPlace: '',
      civilStatus: '',
      companyEmail: '',
      personalEmail: '',
      mobileNumber: '',
      permanentAddress: '',
      temporaryAddress: '',
      college: '',
      shs: '',
      highSchool: '',
      bankName: '',
      bankNumber: '',
      position: employeePosition,
      branch: '',
      department: employeeDepartment,
      dateHired: '',
      dateRegular: '',
      employmentStatus: '',
      supervisor: '',
      familyMembers: [],
      role: widget.role,
      password: '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditPage(employee: sampleEmployee),
      ),
    ).then((result) {
      if (result != null) {
        // Handle profile update result
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _navigateToAccountSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountSettingsPage(
          employeeId: widget.employeeId,
          role: widget.role,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Have a great day at work, ${employeeName}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            // Profile Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar Section
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: colorScheme.primary.withOpacity(0.1),
                            backgroundImage: _avatarImage != null 
                                ? FileImage(_avatarImage!) 
                                : null,
                            child: _avatarImage == null
                                ? Icon(Icons.person, size: 60, color: colorScheme.primary)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Employee Info
                    Text(
                      employeeName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employeePosition,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employeeDepartment,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text(
                        widget.role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: colorScheme.primary,
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _navigateToEditProfile,
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _navigateToAccountSettings,
                            icon: const Icon(Icons.settings),
                            label: const Text('Settings'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.dashboard, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Overview',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Today\'s Date',
                            DateTime.now().toString().split(' ')[0],
                            Icons.calendar_today,
                            colorScheme.primary,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Employee ID',
                            widget.employeeId,
                            Icons.badge,
                            colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context,
                            'Status',
                            'Active',
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                          Expanded(
                          child: _buildStatItem(
                            context,
                            'Department',
                            employeeDepartment,
                            Icons.business,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // TODO: PLACEHOLDER - Additional Dashboard Widgets
            // These can be implemented when more data becomes available
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Coming Soon',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Additional dashboard features will be available once the employee names table and other data sources are implemented:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Recent attendance summary'),
                        Text('• Leave balance overview'),
                        Text('• Upcoming events & deadlines'),
                        Text('• Performance metrics'),
                        Text('• Team announcements'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
