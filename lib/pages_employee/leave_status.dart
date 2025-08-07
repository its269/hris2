import 'package:flutter/material.dart';

class LeaveStatusPage extends StatelessWidget {
  final String status;
  const LeaveStatusPage({super.key, required this.status});

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending Approval":
        return Colors.orange;
      case "Approved":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Pending Approval":
        return Icons.pending;
      case "Approved":
        return Icons.check_circle;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave Status")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getStatusIcon(status),
              size: 64,
              color: _getStatusColor(status),
            ),
            const SizedBox(height: 16),
            const Text("Current Leave Status:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(status),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
