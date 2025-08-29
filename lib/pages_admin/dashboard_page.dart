import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'profile_edit_page.dart';
import 'account_settings_page.dart';
import 'employee_model.dart';
import 'edit_employee_home.dart';
import '../theme_provider.dart';
import 'full_analytics_page.dart';

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
      });
    }
  }

  // PLACEHOLDER DATA - Replace with actual API calls when available
  String get employeeName =>
      widget.employeeId; // Using employeeId as name for now
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

  void _navigateToFullAnalytics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullAnalyticsPage(employeeId: widget.employeeId, role: widget.role),
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
              'Have a great day at work, $employeeName',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
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
                            backgroundColor: colorScheme.primary.withOpacity(
                              0.1,
                            ),
                            backgroundImage: _avatarImage != null
                                ? FileImage(_avatarImage!)
                                : null,
                            child: _avatarImage == null
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: colorScheme.primary,
                                  )
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
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Employee Info
                    Text(
                      employeeName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
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
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
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
                              elevation:
                                  WidgetStateProperty.resolveWith<double>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return 6.0;
                                    }
                                    return 2.0;
                                  }),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.9);
                                    }
                                    return Theme.of(
                                      context,
                                    ).colorScheme.primary;
                                  }),
                              foregroundColor: WidgetStateProperty.all<Color?>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                              shadowColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.4);
                                    }
                                    return null;
                                  }),
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
                              elevation:
                                  WidgetStateProperty.resolveWith<double>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return 6.0;
                                    }
                                    return 2.0;
                                  }),
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.9);
                                    }
                                    return Theme.of(
                                      context,
                                    ).colorScheme.primary;
                                  }),
                              foregroundColor: WidgetStateProperty.all<Color?>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                              shadowColor:
                                  WidgetStateProperty.resolveWith<Color?>((
                                    Set<WidgetState> states,
                                  ) {
                                    if (states.contains(WidgetState.hovered)) {
                                      return Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.4);
                                    }
                                    return null;
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Main Dashboard Section
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withOpacity(0.02),
                      colorScheme.primary.withOpacity(0.08),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Quick Stats
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.primary.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.dashboard,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dashboard Overview',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Active • ${widget.employeeId} • $employeeDepartment',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Quick Insights in a compact row
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildCompactStat(
                                'Attendance',
                                '22/24 Days',
                                Icons.calendar_today,
                                Colors.green,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: _buildCompactStat(
                                'Leave Requests',
                                '3 Pending',
                                Icons.pending_actions,
                                Colors.orange,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: _buildCompactStat(
                                'Overtime',
                                '8.5 Hours',
                                Icons.access_time,
                                Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Reports & Analytics Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary.withOpacity(0.08),
                              colorScheme.primary.withOpacity(0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.primary.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.analytics,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reports & Analytics',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                          fontSize: 18,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Comprehensive insights and performance metrics',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _navigateToFullAnalytics(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: colorScheme.primary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'View All',
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: colorScheme.primary,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Container(
                      //   // ignore: sort_child_properties_last
                      //   child: Center(
                      //     child: Text(
                      //       'Hello',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      //   height: 100,
                      //   decoration: BoxDecoration(
                      //     color: const Color.fromARGB(48, 0, 80, 145),
                      //     border: Border.all(
                      //       color: const Color.fromARGB(255, 0, 109, 211),
                      //       width: 1,
                      //     ),
                      //     borderRadius: BorderRadius.circular(15),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EditEmployeeHome(showAppBar: false),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.edit, color: Colors.blueAccent),
                              Text(
                                'Employee Home',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Reports Grid - More compact
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _buildReportCard(
                            context,
                            'Attendance Report',
                            'Daily & monthly trends',
                            Icons.access_time,
                            Colors.blue[600]!,
                            () => _showAttendanceReport(context),
                          ),
                          _buildReportCard(
                            context,
                            'Leave Management',
                            'Requests & approvals',
                            Icons.event_busy,
                            Colors.orange[600]!,
                            () => _showLeaveReport(context),
                          ),
                          _buildReportCard(
                            context,
                            'Team Performance',
                            'Productivity metrics',
                            Icons.people_alt,
                            Colors.teal[600]!,
                            () => _showTeamReport(context),
                          ),
                          _buildReportCard(
                            context,
                            'Monthly Summary',
                            'Comprehensive overview',
                            Icons.assessment,
                            Colors.indigo[600]!,
                            () => _showMonthlySummary(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          shadowColor: color.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.06), color.withOpacity(0.12)],
              ),
              border: Border.all(color: color.withOpacity(0.15), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    Icon(Icons.arrow_forward_ios, color: color, size: 14),
                  ],
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: color,
                          height: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                          height: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
              overlayColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                }
                return null;
              }),
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
              elevation: WidgetStateProperty.resolveWith<double>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return 8.0;
                }
                return 2.0;
              }),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                }
                return Theme.of(context).colorScheme.primary;
              }),
              foregroundColor: WidgetStateProperty.all<Color?>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shadowColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                }
                return null;
              }),
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
              overlayColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                }
                return null;
              }),
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
              elevation: WidgetStateProperty.resolveWith<double>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return 8.0;
                }
                return 2.0;
              }),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                }
                return Theme.of(context).colorScheme.primary;
              }),
              foregroundColor: WidgetStateProperty.all<Color?>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shadowColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                }
                return null;
              }),
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
              overlayColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                }
                return null;
              }),
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
              elevation: WidgetStateProperty.resolveWith<double>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return 8.0;
                }
                return 2.0;
              }),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                }
                return Theme.of(context).colorScheme.primary;
              }),
              foregroundColor: WidgetStateProperty.all<Color?>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shadowColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                }
                return null;
              }),
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
              overlayColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.1);
                }
                return null;
              }),
            ),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Detailed summary export feature coming soon!'),
                ),
              );
            },
            style: ButtonStyle(
              elevation: WidgetStateProperty.resolveWith<double>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return 8.0;
                }
                return 2.0;
              }),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.9);
                }
                return Theme.of(context).colorScheme.primary;
              }),
              foregroundColor: WidgetStateProperty.all<Color?>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              shadowColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.hovered)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                }
                return null;
              }),
            ),
            child: const Text('Export Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportStatRow(String label, String value, String status) {
    Color statusColor = Colors.blue;
    if (status.contains('Excellent') ||
        status.contains('Outstanding') ||
        status.contains('Good')) {
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
