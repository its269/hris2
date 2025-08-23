import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hris/theme_provider.dart';
import 'package:provider/provider.dart';
import 'training_page.dart'; // Placeholder for future API data
import '../pages_admin/policy_page.dart'; // Placeholder for future API data
import 'hr_forms_page.dart'; // Employee-specific HR forms page
import '../pages_admin/notifications_page.dart';
import 'profile_page.dart'; // Direct profile page
import 'solo_attendance.dart'; // Direct attendance page
import 'employee_calendar.dart';
import 'leave_request_page.dart'; // New leave request page
import 'home_page.dart';
import '../main.dart'; // Assuming MyApp is here

class UserPage extends StatefulWidget {
  const UserPage({super.key, String? username});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _selectedPage = 'Profile';

  Widget _getPage(String name) {
    switch (name) {
      case 'Home':
        return const HomePage();
      case 'Profile':
        return const ProfilePage(); // Direct to profile page
      case 'Attendance Records':
        return const EmployeeAttendancePage(); // Direct to attendance page
      case 'Leave Requests':
        return const EmployeeLeaveRequestPage(showAppBar: false); // New leave request page
      case 'Training Portal':
        return const TrainingPage(showAppBar: false);
      case 'Corporate Policy':
        return const PolicyPage(showAppBar: false, userRole: 'employee');
      case 'HR Related Forms':
        return const EmployeeHRFormsPage(showAppBar: false);
      case 'Calendar':
        return const EmployeeCalendarPage(showAppBar: false);
      default:
        return const Center(child: Text('Page Not Found'));
    }
  }

  void _navigate(String page) {
    Navigator.pop(context);
    setState(() {
      _selectedPage = page;
    });
  }

  String _getPageTitle(String pageName) {
    switch (pageName) {
      case 'Home':
        return 'Home';
      case 'Profile':
        return 'Profile';
      case 'Attendance Records':
        return 'Attendance Records';
      case 'Leave Requests':
        return 'Leave Requests';
      case 'Training Portal':
        return 'Training Portal';
      case 'Corporate Policy':
        return 'Corporate Policy';
      case 'HR Related Forms':
        return 'HR Forms';
      case 'Calendar':
        return 'Calendar';
      default:
        return 'Kelin Graphic System';
    }
  }

  IconData _getPageIcon(String pageName) {
    switch (pageName) {
      case 'Home':
        return Icons.home;
      case 'Profile':
        return Icons.person;
      case 'Attendance Records':
        return Icons.calendar_today;
      case 'Leave Requests':
        return Icons.event_available;
      case 'Training Portal':
        return Icons.school;
      case 'Corporate Policy':
        return Icons.policy;
      case 'HR Related Forms':
        return Icons.people_alt;
      case 'Calendar':
        return Icons.people_alt;
      default:
        return Icons.business;
    }
  }

  ListTile _buildDrawerItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: _selectedPage == label,
      selectedTileColor: Theme.of(
        context,
      ).colorScheme.secondaryContainer.withOpacity(0.2),
      onTap: () => _navigate(label),
    );
  }

  void _signOut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MyApp()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              _getPageIcon(_selectedPage),
              color: colorScheme.onPrimaryContainer,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(_getPageTitle(_selectedPage))),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (_selectedPage != 'Profile') {
                  setState(() {
                    _selectedPage = 'Profile';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navigated to Profile'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  'assets/kelin.png',
                  height: 32,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primaryContainer),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_selectedPage != 'Dashboard') {
                            setState(() {
                              _selectedPage = 'Dashboard';
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/profile.jpg',
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return GestureDetector(
                            onTap: () {
                              themeProvider.toggleTheme();
                              HapticFeedback.lightImpact();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimaryContainer
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder:
                                    (
                                      Widget child,
                                      Animation<double> animation,
                                    ) {
                                      return RotationTransition(
                                        turns: animation,
                                        child: ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                child: Icon(
                                  themeProvider.isDarkMode
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                  key: ValueKey<bool>(themeProvider.isDarkMode),
                                  color: colorScheme.onPrimaryContainer,
                                  size: 24,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome, John Paul!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    'Role: Employee',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            _buildDrawerItem(Icons.home, 'Home'),
            _buildDrawerItem(Icons.person, 'Profile'),
            _buildDrawerItem(Icons.calendar_today, 'Attendance Records'),
            _buildDrawerItem(Icons.event_available, 'Leave Requests'),
            _buildDrawerItem(Icons.school, 'Training Portal'),
            _buildDrawerItem(Icons.policy, 'Corporate Policy'),
            _buildDrawerItem(Icons.people_alt, 'HR Related Forms'),
            _buildDrawerItem(Icons.calendar_today, 'Calendar'),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log out'),
              onTap: () {
                Navigator.pop(context);
                _signOut();
              },
            ),

            const SizedBox(height: 260),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Padding(
          key: ValueKey(_selectedPage),
          padding: const EdgeInsets.all(12.0),
          child: _getPage(_selectedPage),
        ),
      ),
    );
  }
}
