import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminApprovalPage extends StatefulWidget {
  const AdminApprovalPage({super.key});

  @override
  State<AdminApprovalPage> createState() => _AdminApprovalPageState();
}

class _AdminApprovalPageState extends State<AdminApprovalPage> {
  List<dynamic> _leaveRequests = [];

  Future<void> _fetchRequests() async {
    final url = Uri.parse('http://10.0.2.2/get_leave_requests.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _leaveRequests = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load leave requests')),
      );
    }
  }

  Future<void> _approveRequest(int id) async {
    final url = Uri.parse('http://10.0.2.2/approve_leave.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    final data = jsonDecode(response.body);
    if (data['success']) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));
      _fetchRequests(); // refresh the list
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${data['message']}')));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Approval (Admin)')),
      body: _leaveRequests.isEmpty
          ? const Center(child: Text('No pending leave requests.'))
          : ListView.builder(
              itemCount: _leaveRequests.length,
              itemBuilder: (context, index) {
                final req = _leaveRequests[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(req['leave_type']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From: ${req['start_date']}"),
                        Text("To: ${req['end_date']}"),
                        Text("Reason: ${req['reason']}"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _approveRequest(req['id']),
                      child: const Text('Approve'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
