import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'request_leave.dart';

class ProfileLeave extends StatefulWidget {
  const ProfileLeave({super.key});

  @override
  State<ProfileLeave> createState() => _ProfileLeaveState();
}

class _ProfileLeaveState extends State<ProfileLeave> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Leave Request'),
        // backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildButton(
                    label: 'Personal Information',
                    icon: Icons.person,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildButton(
                    label: 'Leave Request',
                    icon: Icons.calendar_today,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RequestLeavePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 181, 96),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16),
        ),
        icon: Icon(icon, size: 20),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
