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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.assignment,
              color: colorScheme.onPrimaryContainer,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Profile & Leave Request',
                style: TextStyle(color: colorScheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildButton(
                    context,
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
                  const SizedBox(height: 16),
                  _buildButton(
                    context,
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

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: const TextStyle(fontSize: 16),
        ),
        icon: Icon(icon, size: 20),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
