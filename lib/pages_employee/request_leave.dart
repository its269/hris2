import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'leave_status.dart';

class RequestLeavePage extends StatefulWidget {
  const RequestLeavePage({super.key});

  @override
  State<RequestLeavePage> createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  final _formKey = GlobalKey<FormState>();

  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _reason;
  String _status = "No Request";

  final List<String> _leaveTypes = [
    'Annual Leave',
    'Sick Leave',
    'Unpaid Leave',
    'Maternity Leave',
    'Paid Leave',
  ];

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = newDate;
        } else {
          _endDate = newDate;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse(
        'http://10.0.2.2/user_leave_requests/submit_leave.php',
      ); // Use '10.0.2.2' for Android emulator
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'leave_type': _leaveType,
          'start_date': _formatDate(_startDate),
          'end_date': _formatDate(_endDate),
          'reason': _reason,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          _status = "Pending Approval";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Leave Request Submitted')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${data['message']}')));
      }
    }
  }

  void _goToStatusPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeaveStatusPage(status: _status)),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leave Request Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Leave Type'),
                value: _leaveType,
                items: _leaveTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _leaveType = value),
                validator: (value) =>
                    value == null ? 'Please select a leave type' : null,
              ),
              const SizedBox(height: 16),

              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(
                  _startDate == null
                      ? 'No date selected'
                      : _formatDate(_startDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(context, true),
              ),
              const SizedBox(height: 8),

              ListTile(
                title: const Text('End Date'),
                subtitle: Text(
                  _endDate == null ? 'No date selected' : _formatDate(_endDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(context, false),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Reason'),
                maxLines: 3,
                onSaved: (value) => _reason = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a reason'
                    : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Leave Request'),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                icon: const Icon(Icons.info_outline),
                label: const Text('Status'),
                onPressed: _goToStatusPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
