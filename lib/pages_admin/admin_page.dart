import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'attendance_page.dart';
import '../pages_employee/training_page.dart';
import 'policy_page.dart';
import 'hr_page.dart';
import 'employee_list_page.dart';
import 'admin_approval_page.dart';
import 'dashboard_page.dart';
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

    const MyHomePage({
    super.key,
    required this.role,
    required this.employeeId,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedPage = 'Dashboard';
  int _selectedTabIndex = 0; // 0 = Home, 1 = Notifications
  
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
        );
      case 'Leave Management':
        return const AdminApprovalPage();
      case 'Employee Profile':
      return EmployeeListPage(
        role: widget.role,
        employeeId: widget.employeeId,
      );
      case 'Attendance Records':
        return const AttendancePage();
      case 'Training Portal':
        return const TrainingPage();
      case 'Corporate Policy':
        return const PolicyPage();
      case 'HR Related Forms':
        return const HRPage();
      case 'Request':
        return const AdminApprovalPage();
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelin Graphic System'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          // Theme toggle button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                tooltip: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          // Logo
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              'assets/kelin.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
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
                  ClipRRect(
                    child: Image.asset(
                      'assets/human-resources_hris.png',
                      width: 60,
                      fit: BoxFit.cover,
                    ),
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
            _buildDrawerItem(Icons.person, 'Employee Profile'),
            _buildDrawerItem(Icons.calendar_today, 'Attendance Records'),
            _buildDrawerItem(Icons.school, 'Training Portal'),
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
          key: ValueKey(_selectedTabIndex),
          padding: const EdgeInsets.all(24.0),
          child: _selectedTabIndex == 0
              ? _getPage(_selectedPage)
              : const AdminApprovalPage(), // Show Notifications page
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.arrow_back), label: 'Prev'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
