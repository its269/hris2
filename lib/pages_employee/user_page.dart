import 'package:flutter/material.dart';
// import 'profile_page.dart';
// import '../pages_admin/attendance_page.dart';
import 'training_page.dart'; // Placeholder for future API data
import '../pages_admin/policy_page.dart'; // Placeholder for future API data
import '../pages_admin/hr_page.dart'; // Placeholder for future API data
import 'profile_leave.dart';
import 'solo_attendance.dart';
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
      case 'Profile':
        return const ProfileLeave();
      case 'Attendance Records':
        return const AttendancePageSolo();
      case 'Training Portal':
        return const TrainingPage(); // Empty for now
      case 'Corporate Policy':
        return const PolicyPage(); // Empty for now
      case 'HR Related Forms':
        return const HRPage(); // Empty for now
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

  // Log out and go back to main.dart
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
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/profile.jpg',
                      width: 60,
                      height: 60,
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
            _buildDrawerItem(Icons.person, 'Profile'),
            _buildDrawerItem(Icons.calendar_today, 'Attendance Records'),
            _buildDrawerItem(Icons.school, 'Training Portal'),
            _buildDrawerItem(Icons.policy, 'Corporate Policy'),
            _buildDrawerItem(Icons.people_alt, 'HR Related Forms'),

            // Log out option
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log out'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _signOut(); // Then log out
              },
            ),

            const SizedBox(height: 260), // Optional spacing
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Padding(
          key: ValueKey(_selectedPage),
          padding: const EdgeInsets.all(24.0),
          child: _getPage(_selectedPage),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //     ),
      //   ],
      // ),
    );
  }
}
