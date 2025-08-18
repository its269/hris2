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
  final Function(String)? onNavigateToPage;

  const DashboardPage({
    super.key,
    required this.role,
    required this.employeeId,
    this.onNavigateToPage,
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
        padding: const EdgeInsets.all(12.0),
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
            const SizedBox(height: 6),
            Text(
              'Have a great day at work, ${employeeName}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Profile Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                        style: TextStyle(
                          color: colorScheme.onPrimary,
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
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 12),
                              ),
                              elevation: WidgetStateProperty.resolveWith<double>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return 6.0;
                                  }
                                  return 2.0;
                                },
                              ),
                              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                                  }
                                  return Theme.of(context).colorScheme.primary;
                                },
                              ),
                              foregroundColor: WidgetStateProperty.all<Color?>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                              shadowColor: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Theme.of(context).colorScheme.primary.withOpacity(0.4);
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _navigateToAccountSettings,
                            icon: const Icon(Icons.settings),
                            label: const Text('Settings'),
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 12),
                              ),
                              elevation: WidgetStateProperty.resolveWith<double>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return 6.0;
                                  }
                                  return 2.0;
                                },
                              ),
                              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                                  }
                                  return Theme.of(context).colorScheme.primary;
                                },
                              ),
                              foregroundColor: WidgetStateProperty.all<Color?>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                              shadowColor: WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.hovered)) {
                                    return Theme.of(context).colorScheme.primary.withOpacity(0.4);
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Stats Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),

            // Reports Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Reports & Analytics',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Reports Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.5,
                      children: [
                        _buildReportCard(
                          context,
                          'Attendance Report',
                          'View statistics',
                          Icons.schedule,
                          Colors.blue,
                          () => _showAttendanceReport(context),
                        ),
                        _buildReportCard(
                          context,
                          'Leave Report',
                          'Requests & balances',
                          Icons.beach_access,
                          Colors.orange,
                          () => _showLeaveReport(context),
                        ),
                        _buildReportCard(
                          context,
                          'Team Report',
                          'Department info',
                          Icons.group,
                          Colors.teal,
                          () => _showTeamReport(context),
                        ),
                        _buildReportCard(
                          context,
                          'Monthly Summary',
                          'Full overview',
                          Icons.summarize,
                          Colors.indigo,
                          () => _showMonthlySummary(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Insights Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.insights, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Insights',
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
                          child: _buildInsightItem(
                            context,
                            'This Month',
                            '22/24 Days',
                            'Attendance',
                            Icons.calendar_month,
                            Colors.green,
                          ),
                        ),
                        Expanded(
                          child: _buildInsightItem(
                            context,
                            'Pending',
                            '3 Requests',
                            'Leave Applications',
                            Icons.pending_actions,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInsightItem(
                            context,
                            'This Week',
                            '8.5 Hours',
                            'Overtime',
                            Icons.access_time,
                            Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _buildInsightItem(
                            context,
                            'Open',
                            '7 Positions',
                            'Currently Hiring',
                            Icons.work,
                            Colors.red,
                          ),
                        ),
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

  Widget _buildReportCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 2,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            hoverColor: color.withOpacity(0.1),
            splashColor: color.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            height: 1.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 9,
                            height: 1.1,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightItem(BuildContext context, String label, String value, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _showAttendanceReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.schedule, color: Colors.blue),
            SizedBox(width: 8),
            Text('Attendance Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportStatRow('This Month', '22/24 Days', '91.7%'),
            _buildReportStatRow('Last Month', '20/22 Days', '90.9%'),
            _buildReportStatRow('Average Hours', '8.2 hrs/day', 'Good'),
            _buildReportStatRow('Late Arrivals', '2 Days', 'Minimal'),
            const SizedBox(height: 16),
            const Text(
              'Recommendation: Maintain current attendance pattern. Consider arriving 10 minutes earlier to avoid late marks.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                  }
                  return null;
                },
              ),
            ),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to Attendance Records tab
              if (widget.onNavigateToPage != null) {
                widget.onNavigateToPage!('Attendance Records');
              }
            },
            style: ButtonStyle(
              elevation: WidgetStateProperty.resolveWith<double>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return 8.0;
                  }
                  return 2.0;
                },
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                  }
                  return Theme.of(context).colorScheme.primary;
                },
              ),
              foregroundColor: WidgetStateProperty.all<Color?>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shadowColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                  }
                  return null;
                },
              ),
            ),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  void _showLeaveReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.beach_access, color: Colors.orange),
            SizedBox(width: 8),
            Text('Leave Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportStatRow('Vacation Leave', '15 Days', 'Available'),
            _buildReportStatRow('Sick Leave', '5 Days', 'Available'),
            _buildReportStatRow('Used This Year', '7 Days', 'Vacation'),
            _buildReportStatRow('Pending Requests', '2', 'In Review'),
            const SizedBox(height: 16),
            const Text(
              'Next scheduled leave: Dec 25-31, 2024 (7 days)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                  }
                  return null;
                },
              ),
            ),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to Leave Management tab
              if (widget.onNavigateToPage != null) {
                widget.onNavigateToPage!('Leave Management');
              }
            },
            style: ButtonStyle(
              elevation: WidgetStateProperty.resolveWith<double>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return 8.0;
                  }
                  return 2.0;
                },
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                  }
                  return Theme.of(context).colorScheme.primary;
                },
              ),
              foregroundColor: WidgetStateProperty.all<Color?>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shadowColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                  }
                  return null;
                },
              ),
            ),
            child: const Text('Manage Leave'),
          ),
        ],
      ),
    );
  }

  void _showTeamReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.group, color: Colors.teal),
            SizedBox(width: 8),
            Text('Team Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportStatRow('Team Members', '12 People', 'HR Department'),
            _buildReportStatRow('Present Today', '11/12', '91.7%'),
            _buildReportStatRow('Team Projects', '3 Active', 'On Track'),
            _buildReportStatRow('Avg Performance', '4.6/5.0', 'High'),
            const SizedBox(height: 16),
            const Text(
              'Team is performing well. Consider team building activity for next quarter.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                  }
                  return null;
                },
              ),
            ),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to Employee Management tab
              if (widget.onNavigateToPage != null) {
                widget.onNavigateToPage!('Employee Management');
              }
            },
            style: ButtonStyle(
              elevation: WidgetStateProperty.resolveWith<double>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return 8.0;
                  }
                  return 2.0;
                },
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                  }
                  return Theme.of(context).colorScheme.primary;
                },
              ),
              foregroundColor: WidgetStateProperty.all<Color?>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shadowColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                  }
                  return null;
                },
              ),
            ),
            child: const Text('View Team'),
          ),
        ],
      ),
    );
  }

  void _showMonthlySummary(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.summarize, color: Colors.indigo),
            SizedBox(width: 8),
            Text('Monthly Summary'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportStatRow('Work Days', '22/24', 'Attendance'),
            _buildReportStatRow('Tasks Completed', '28/30', 'Productivity'),
            _buildReportStatRow('Overtime Hours', '8.5 hrs', 'Extra Work'),
            _buildReportStatRow('Performance', '4.8/5.0', 'Rating'),
            const SizedBox(height: 16),
            const Text(
              'Excellent month overall! You\'re exceeding expectations in most areas.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                  }
                  return null;
                },
              ),
            ),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Detailed summary export feature coming soon!')),
              );
            },
            style: ButtonStyle(
              elevation: WidgetStateProperty.resolveWith<double>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return 8.0;
                  }
                  return 2.0;
                },
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                  }
                  return Theme.of(context).colorScheme.primary;
                },
              ),
              foregroundColor: WidgetStateProperty.all<Color?>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shadowColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                  }
                  return null;
                },
              ),
            ),
            child: const Text('Export Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportStatRow(String label, String value, String status) {
    Color statusColor = Colors.blue;
    if (status.contains('Excellent') || status.contains('Outstanding') || status.contains('Good')) {
      statusColor = Colors.green;
    } else if (status.contains('Minimal') || status.contains('Available')) {
      statusColor = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
