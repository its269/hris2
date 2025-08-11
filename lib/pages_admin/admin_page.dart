import 'package:flutter/material.dart';
import 'attendance_page.dart';
import '../pages_employee/training_page.dart';
import 'policy_page.dart';
import 'hr_page.dart';
import 'employee_list_page.dart';
import 'admin_approval_page.dart';
import '../main.dart'; // Assuming MyApp is here

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
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedPage = 'Request';
  int _selectedTabIndex = 0; // 0 = Home, 1 = Notifications

  Widget _getPage(String name) {
    switch (name) {
      case 'Employee Profile':
        return const EmployeeListPage();
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Kelin Graphic System'),
            Image.asset(
              'assets/kelin.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
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
                  ClipRRect(
                    child: Image.asset(
                      'assets/human-resources_hris.png',
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.person, 'Employee Profile'),
            _buildDrawerItem(Icons.calendar_today, 'Attendance Records'),
            _buildDrawerItem(Icons.school, 'Training Portal'),
            _buildDrawerItem(Icons.policy, 'Corporate Policy'),
            _buildDrawerItem(Icons.people_alt, 'HR Related Forms'),
            // _buildDrawerItem(Icons.people_alt, 'Request'),

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
