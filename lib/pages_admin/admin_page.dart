import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'attendance_page.dart';
import 'training_management_page.dart';
import 'policy_page.dart';
import 'hr_page.dart';
import 'employee_list_page.dart';
import 'admin_leave_management_page.dart';
import 'dashboard_page.dart';
import 'schedule_page.dart';
import 'notifications_page.dart';
import '../theme_provider.dart';
import '../main.dart'; // Assuming MyApp is here
// Uncomment when employee names API is implemented
// import 'api_service.dart';

// Placeholder notification page
// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Leave Request Notifications',
//         style: TextStyle(fontSize: 24),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  final String role;
  final String employeeId;

  const MyHomePage({super.key, required this.role, required this.employeeId});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedPage = 'Dashboard';
  int _selectedTabIndex = 0; // 0 = Home, 1 = Notifications
  int _unreadNotificationCount =
      5; // Example count - replace with actual API data

  // PLACEHOLDER - Employee name field
  // Uncomment this field when employee names table is ready:
  // String? _employeeName;

  @override
  void initState() {
    super.initState();
    // Uncomment this when employee names table is ready
    // _loadEmployeeName();
  }

  // PLACEHOLDER - Load employee name from API
  // This method will fetch the actual employee name from another table
  // using the employeeId. Currently commented out because the separate
  // employee names table is not yet available.
  //
  // Future<void> _loadEmployeeName() async {
  //   final apiService = ApiService();
  //   final name = await apiService.fetchEmployeeName(widget.employeeId);
  //   if (name != null && name.isNotEmpty) {
  //     setState(() {
  //       _employeeName = name;
  //     });
  //   }
  // }

  Widget _getPage(String name) {
    switch (name) {
      case 'Dashboard':
        return DashboardPage(
          role: widget.role,
          employeeId: widget.employeeId,
          onNavigateToPage: (pageName) {
            setState(() {
              _selectedPage = pageName;
            });
          },
        );
      case 'Leave Management':
        return AdminLeaveManagementPage(
          employeeId: widget.employeeId,
          role: widget.role,
        );
      case 'Employee Management':
        return EmployeeListPage(
          role: widget.role,
          employeeId: widget.employeeId,
          showAppBar: true,
        );
      case 'Attendance Records':
        return const AttendancePage(showAppBar: false);
      case 'Training Management':
        return const TrainingManagementPage(showAppBar: false);
      case 'Corporate Policy':
        return PolicyPage(showAppBar: false, userRole: widget.role);
      case 'HR Related Forms':
        return const HRPage(showAppBar: false);
      case 'Request':
        return AdminLeaveManagementPage(
          employeeId: widget.employeeId,
          role: widget.role,
        );
      default:
        return const Center(child: Text('Page Not Found'));
    }
  }

  void _navigate(String page) {
    Navigator.pop(context);
    setState(() {
      _selectedPage = page;
      _selectedTabIndex = 0; // Ensure Home tab is selected when using drawer
    });
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

  String _getPageTitle(String pageName) {
    switch (pageName) {
      case 'Dashboard':
        return 'Dashboard';
      case 'Leave Management':
        return 'Leave Management';
      case 'Employee Management':
        return 'Employee Management';
      case 'Attendance Records':
        return 'Attendance Records';
      case 'Training Management':
        return 'Training Management';
      case 'Corporate Policy':
        return 'Corporate Policy';
      case 'HR Related Forms':
        return 'HR Related Forms';
      case 'Request':
        return 'Leave Requests';
      case 'Schedule & Calendar':
        return 'Schedule & Calendar';
      default:
        return 'Kelin Graphic System';
    }
  }

  IconData _getPageIcon(String pageName) {
    switch (pageName) {
      case 'Dashboard':
        return Icons.dashboard;
      case 'Leave Management':
        return Icons.event_available;
      case 'Employee Management':
        return Icons.people;
      case 'Attendance Records':
        return Icons.schedule;
      case 'Training Management':
        return Icons.school;
      case 'Corporate Policy':
        return Icons.policy;
      case 'HR Related Forms':
        return Icons.people_alt;
      case 'Request':
        return Icons.request_page;
      case 'Schedule & Calendar':
        return Icons.calendar_today;
      default:
        return Icons.business;
    }
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
            Text(_getPageTitle(_selectedPage)),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          // Theme toggle moved to drawer
          // Clickable Logo - Navigate to Dashboard
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to dashboard if not already there
                if (_selectedPage != 'Dashboard') {
                  setState(() {
                    _selectedPage = 'Dashboard';
                  });
                  // Show feedback
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text('Navigated to Dashboard'),
                  //     duration: Duration(seconds: 1),
                  //   ),
                  // );
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
          ),
        ],
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
                          // Navigate to dashboard if not already there
                          if (_selectedPage != 'Dashboard') {
                            setState(() {
                              _selectedPage = 'Dashboard';
                            });
                          }
                          // Close drawer
                          Navigator.pop(context);
                          // Show feedback
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text('Navigated to Dashboard'),
                          //     duration: Duration(seconds: 1),
                          //   ),
                          // );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/human-resources_hris.png',
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Dark Mode Toggle in Header
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
                    // Use actual employee name when available
                    // When employee names table is ready, this will show:
                    // 'Welcome, ${_employeeName ?? widget.employeeId}!'
                    // For now, using employeeId as the display name
                    'Welcome, ${widget.employeeId}!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    'Role: ${widget.role}',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard'),
            _buildDrawerItem(Icons.approval, 'Leave Management'),
            _buildDrawerItem(Icons.person, 'Employee Management'),
            _buildDrawerItem(Icons.calendar_today, 'Attendance Records'),
            _buildDrawerItem(Icons.school, 'Training Management'),
            _buildDrawerItem(Icons.policy, 'Corporate Policy'),
            _buildDrawerItem(Icons.people_alt, 'HR Related Forms'),

            // Log out option
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
          padding: const EdgeInsets.all(24.0),
          child: _getPage(_selectedPage), // Show only regular pages
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            if (index == 0) {
              // Schedule tab tapped - Navigate to full page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SchedulePage(
                    role: widget.role,
                    employeeId: widget.employeeId,
                  ),
                ),
              );
            } else if (index == 1) {
              // Notifications tab tapped - Navigate to full page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            }
            // Reset to previous state (don't change _selectedTabIndex)
            _selectedTabIndex = 0;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (_unreadNotificationCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$_unreadNotificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
