import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminApprovalPage extends StatefulWidget {
  const AdminApprovalPage({Key? key}) : super(key: key);

  @override
  State<AdminApprovalPage> createState() => _AdminApprovalPageState();
}

class _AdminApprovalPageState extends State<AdminApprovalPage> {
  List requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final url = Uri.parse(
      "http://localhost/hris_api/get_leave_requests.php",
    ); // Change to your API URL
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        requests = jsonDecode(response.body);
        loading = false;
      });
    }
  }

  Future<void> updateStatus(int id, String status) async {
    final url = Uri.parse(
      "http://localhost/hris_api/update_leave_status.php",
    ); // Change to your API URL
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "status": status}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result["success"] == true) {
        fetchRequests(); // Refresh list
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Leave Approval")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(child: Text("No pending requests"))
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      "${req['employee_name']} - ${req['leave_type']}",
                    ),
                    subtitle: Text(
                      "From: ${req['start_date']} To: ${req['end_date']}\nReason: ${req['reason']}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () =>
                              updateStatus(int.parse(req['id']), "Approved"),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () =>
                              updateStatus(int.parse(req['id']), "Rejected"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}



// new