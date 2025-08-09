import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminApprovalPage extends StatefulWidget {
  const AdminApprovalPage({super.key});

  @override
  State<AdminApprovalPage> createState() => _AdminApprovalPageState();
}

class _AdminApprovalPageState extends State<AdminApprovalPage>
    with SingleTickerProviderStateMixin {
  List pendingRequests = [];
  List allRequests = [];
  bool isLoading = true;

  final String apiBase =
      "http://10.0.2.2/admin_leave_approve"; // change if real device

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    fetchPendingRequests();
    fetchAllRequests();
  }

  Future<void> fetchPendingRequests() async {
    final response = await http.get(
      Uri.parse("$apiBase/get_pending_requests.php"),
    );
    if (response.statusCode == 200) {
      setState(() {
        pendingRequests = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  Future<void> fetchAllRequests() async {
    final response = await http.get(Uri.parse("$apiBase/get_all_requests.php"));
    if (response.statusCode == 200) {
      setState(() {
        allRequests = jsonDecode(response.body);
      });
    }
  }

  Future<void> updateStatus(int id, String status) async {
    final response = await http.post(
      Uri.parse("$apiBase/update_leave_status.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "status": status}),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result["success"]) {
        fetchPendingRequests();
        fetchAllRequests();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${result["message"]}")));
      }
    }
  }

  Widget buildRequestCard(Map req, {bool showActions = false}) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          "${req['leave_type']} (${req['start_date']} → ${req['end_date']})",
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(req['reason']),
            const SizedBox(height: 4),
            Text(
              "Status: ${req['status']}",
              style: TextStyle(
                color: req['status'] == "Approved"
                    ? Colors.green
                    : req['status'] == "Rejected"
                    ? Colors.red
                    : Colors.orange,
              ),
            ),
          ],
        ),
        trailing: showActions
            ? Row(
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
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Leave Management"),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "Pending Approvals"),
            Tab(text: "Request History"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Pending Requests
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : pendingRequests.isEmpty
              ? const Center(child: Text("No pending leave requests"))
              : ListView.builder(
                  itemCount: pendingRequests.length,
                  itemBuilder: (context, index) {
                    return buildRequestCard(
                      pendingRequests[index],
                      showActions: true,
                    );
                  },
                ),

          // All Requests
          allRequests.isEmpty
              ? const Center(child: Text("No leave requests yet"))
              : ListView.builder(
                  itemCount: allRequests.length,
                  itemBuilder: (context, index) {
                    return buildRequestCard(allRequests[index]);
                  },
                ),
        ],
      ),
    );
  }
}
