import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'request_leave.dart';
import 'solo_attendance.dart';
import 'home_page.dart';
import 'overtime_requests.dart';

class AttendanceOvertime extends StatefulWidget {
  const AttendanceOvertime({super.key});

  @override
  State<AttendanceOvertime> createState() => _AttendanceOvertimeState();
}

class _AttendanceOvertimeState extends State<AttendanceOvertime> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
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
                // Add a header since we removed the AppBar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Attendance & Overtime',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'View records and submit requests',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildButton(
                  context,
                  label: 'Attendance Records',
                  icon: Icons.person,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmployeeAttendancePage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildButton(
                  context,
                  label: 'View Only (Overtime moved to HR Forms)',
                  icon: Icons.info_outline,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Overtime and Undertime requests are now in HR Forms tab'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                ),
              ],
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
