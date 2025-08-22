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
                'Attendance & Overtime Request',
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
                    label: 'Overtime Request',
                    icon: Icons.calendar_today,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OvertimeRequestForm(),
                        ),
                      );
                    },
                  ),
                  // const SizedBox(height: 16),
                  // _buildButton(
                  //   context,
                  //   label: 'For UI Checking',
                  //   icon: Icons.calendar_today,
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => HomePage()),
                  //     );
                  //   },
                  // ),
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
