import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminLeaveManagementPage extends StatefulWidget {
  final String employeeId;
  final String role;

  const AdminLeaveManagementPage({
    super.key,
    required this.employeeId,
    required this.role,
  });

  @override
  State<AdminLeaveManagementPage> createState() =>
      _AdminLeaveManagementPageState();
}

class _AdminLeaveManagementPageState extends State<AdminLeaveManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List pendingRequests = [];
  List allRequests = [];
  List employees = [];
  bool isLoading = true;

  final String apiBase = "http://10.0.2.2/admin_leave_approve";

  // Leave form variables
  final _formKey = GlobalKey<FormState>();
  String? _selectedEmployee;
  String? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _reason;
  String? _adminNotes;

  final List<String> _leaveTypes = [
    'Annual Leave',
    'Sick Leave',
    'Emergency Leave',
    'Maternity Leave',
    'Paternity Leave',
    'Bereavement Leave',
    'Unpaid Leave',
    'Study Leave',
    'Medical Leave',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDummyData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDummyData() async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      // Sample employees
      employees = [
        {
          'id': 'EMP001',
          'name': 'John Doe',
          'department': 'Human Resources',
          'position': 'HR Manager',
        },
        {
          'id': 'EMP002',
          'name': 'Jane Smith',
          'department': 'Information Technology',
          'position': 'Software Developer',
        },
        {
          'id': 'EMP003',
          'name': 'Mike Johnson',
          'department': 'Finance',
          'position': 'Financial Analyst',
        },
        {
          'id': 'EMP004',
          'name': 'Sarah Wilson',
          'department': 'Marketing',
          'position': 'Marketing Specialist',
        },
        {
          'id': 'EMP005',
          'name': 'David Brown',
          'department': 'Operations',
          'position': 'Operations Manager',
        },
        {
          'id': 'EMP006',
          'name': 'Emily Davis',
          'department': 'Sales',
          'position': 'Sales Representative',
        },
        {
          'id': 'EMP007',
          'name': 'Robert Miller',
          'department': 'IT Support',
          'position': 'Technical Support',
        },
        {
          'id': 'EMP008',
          'name': 'Lisa Anderson',
          'department': 'Human Resources',
          'position': 'HR Assistant',
        },
      ];

      // Sample pending requests
      pendingRequests = [
        {
          'id': '1',
          'employee_id': 'EMP002',
          'employee_name': 'Jane Smith',
          'department': 'Information Technology',
          'leave_type': 'Annual Leave',
          'start_date': '2024-08-20',
          'end_date': '2024-08-22',
          'days': 3,
          'reason': 'Family vacation to visit relatives in another city',
          'status': 'Pending',
          'submitted_date': '2024-08-10',
          'admin_notes': '',
        },
        {
          'id': '2',
          'employee_id': 'EMP005',
          'employee_name': 'David Brown',
          'department': 'Operations',
          'leave_type': 'Sick Leave',
          'start_date': '2024-08-16',
          'end_date': '2024-08-17',
          'days': 2,
          'reason': 'Medical appointment and recovery time needed',
          'status': 'Pending',
          'submitted_date': '2024-08-12',
          'admin_notes': '',
        },
        {
          'id': '3',
          'employee_id': 'EMP007',
          'employee_name': 'Robert Miller',
          'department': 'IT Support',
          'leave_type': 'Emergency Leave',
          'start_date': '2024-08-19',
          'end_date': '2024-08-19',
          'days': 1,
          'reason': 'Family emergency - need to attend to urgent matter',
          'status': 'Pending',
          'submitted_date': '2024-08-14',
          'admin_notes': '',
        },
      ];

      // Sample all requests (including history)
      allRequests = [
        ...pendingRequests,
        {
          'id': '4',
          'employee_id': 'EMP001',
          'employee_name': 'John Doe',
          'department': 'Human Resources',
          'leave_type': 'Annual Leave',
          'start_date': '2024-07-15',
          'end_date': '2024-07-19',
          'days': 5,
          'reason': 'Summer vacation with family',
          'status': 'Approved',
          'submitted_date': '2024-06-20',
          'approved_date': '2024-06-22',
          'approved_by': 'Admin',
          'admin_notes': 'Approved - sufficient annual leave balance',
        },
        {
          'id': '5',
          'employee_id': 'EMP003',
          'employee_name': 'Mike Johnson',
          'department': 'Finance',
          'leave_type': 'Sick Leave',
          'start_date': '2024-07-08',
          'end_date': '2024-07-10',
          'days': 3,
          'reason': 'Flu symptoms and doctor recommendation for rest',
          'status': 'Approved',
          'submitted_date': '2024-07-07',
          'approved_date': '2024-07-07',
          'approved_by': 'Admin',
          'admin_notes': 'Medical certificate provided',
        },
        {
          'id': '6',
          'employee_id': 'EMP004',
          'employee_name': 'Sarah Wilson',
          'department': 'Marketing',
          'leave_type': 'Personal Leave',
          'start_date': '2024-06-25',
          'end_date': '2024-06-28',
          'days': 4,
          'reason': 'Personal matters to attend to',
          'status': 'Rejected',
          'submitted_date': '2024-06-20',
          'rejected_date': '2024-06-21',
          'rejected_by': 'Admin',
          'admin_notes': 'Insufficient leave balance for this period',
        },
        {
          'id': '7',
          'employee_id': 'EMP006',
          'employee_name': 'Emily Davis',
          'department': 'Sales',
          'leave_type': 'Maternity Leave',
          'start_date': '2024-05-01',
          'end_date': '2024-08-01',
          'days': 92,
          'reason': 'Maternity leave for newborn care',
          'status': 'Approved',
          'submitted_date': '2024-03-15',
          'approved_date': '2024-03-18',
          'approved_by': 'Admin',
          'admin_notes': 'Standard maternity leave period approved',
        },
        {
          'id': '8',
          'employee_id': 'EMP008',
          'employee_name': 'Lisa Anderson',
          'department': 'Human Resources',
          'leave_type': 'Study Leave',
          'start_date': '2024-08-05',
          'end_date': '2024-08-07',
          'days': 3,
          'reason': 'Professional development seminar attendance',
          'status': 'Approved',
          'submitted_date': '2024-07-25',
          'approved_date': '2024-07-26',
          'approved_by': 'Admin',
          'admin_notes': 'Training supports role development',
        },
      ];

      isLoading = false;
    });
  }

  Future<void> _updateStatus(String id, String status, {String? notes}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      // Update the status in dummy data
      for (int i = 0; i < pendingRequests.length; i++) {
        if (pendingRequests[i]['id'] == id) {
          setState(() {
            pendingRequests[i]['status'] = status;
            pendingRequests[i]['admin_notes'] = notes ?? '';
            pendingRequests[i]['${status.toLowerCase()}_date'] = _formatDate(
              DateTime.now(),
            );
            pendingRequests[i]['${status.toLowerCase()}_by'] =
                widget.employeeId;

            // Move to all requests and remove from pending
            allRequests.removeWhere((req) => req['id'] == id);
            allRequests.insert(0, pendingRequests[i]);
          });
          break;
        }
      }

      // Remove from pending requests
      setState(() {
        pendingRequests.removeWhere((req) => req['id'] == id);
      });

      _showSuccessMessage("Leave request $status successfully");
    } catch (e) {
      _showErrorMessage("Error updating request status");
    }
  }

  Future<void> _submitLeaveRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));

      try {
        // Create new request with dummy data
        final newRequest = {
          'id': (allRequests.length + 1).toString(),
          'employee_id': _selectedEmployee,
          'employee_name': employees.firstWhere(
            (emp) => emp['id'] == _selectedEmployee,
          )['name'],
          'department': employees.firstWhere(
            (emp) => emp['id'] == _selectedEmployee,
          )['department'],
          'leave_type': _leaveType,
          'start_date': _formatDate(_startDate),
          'end_date': _formatDate(_endDate),
          'days': _calculateLeaveDays(),
          'reason': _reason,
          'status': 'Approved', // Admin submissions are auto-approved
          'submitted_date': _formatDate(DateTime.now()),
          'approved_date': _formatDate(DateTime.now()),
          'approved_by': widget.employeeId,
          'admin_notes': _adminNotes ?? 'Admin submission - Auto approved',
        };

        setState(() {
          allRequests.insert(0, newRequest);
        });

        _resetForm();
        _showSuccessMessage("Leave request submitted successfully");
      } catch (e) {
        _showErrorMessage("Error submitting request");
      }
    }
  }

  void _resetForm() {
    setState(() {
      _selectedEmployee = null;
      _leaveType = null;
      _startDate = null;
      _endDate = null;
      _reason = null;
      _adminNotes = null;
    });
    _formKey.currentState?.reset();
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? _startDate ?? DateTime.now());

    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (newDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = newDate;
          // Reset end date if it's before start date
          if (_endDate != null && _endDate!.isBefore(newDate)) {
            _endDate = null;
          }
        } else {
          _endDate = newDate;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDisplayDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
  }

  int _calculateLeaveDays() {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  int _calculateRequestDays(Map req) {
    try {
      final startDate = DateTime.parse(req['start_date']);
      final endDate = DateTime.parse(req['end_date']);
      return endDate.difference(startDate).inDays + 1;
    } catch (e) {
      return 1;
    }
  }

  void _showRequestDetails(Map req) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${req['leave_type']} Request'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Employee', req['employee_name']),
              _buildDetailRow('Employee ID', req['employee_id']),
              _buildDetailRow('Department', req['department']),
              _buildDetailRow('Leave Type', req['leave_type']),
              _buildDetailRow('Start Date', req['start_date']),
              _buildDetailRow('End Date', req['end_date']),
              _buildDetailRow('Duration', '${_calculateRequestDays(req)} days'),
              _buildDetailRow('Status', req['status']),
              _buildDetailRow('Submitted', req['submitted_date']),
              if (req['admin_notes'] != null &&
                  req['admin_notes'].toString().isNotEmpty)
                _buildDetailRow('Admin Notes', req['admin_notes']),
              const SizedBox(height: 8),
              const Text(
                'Reason:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(req['reason'] ?? 'No reason provided'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.event_available, color: colorScheme.onPrimary, size: 24),
            const SizedBox(width: 12),
            const Text(
              "Leave Management",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.onPrimary,
          unselectedLabelColor: colorScheme.onPrimary.withOpacity(0.7),
          indicatorColor: colorScheme.onPrimary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.pending_actions, size: 22),
              ),
              text: "Pending",
            ),
            Tab(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.history, size: 22),
              ),
              text: "History",
            ),
            Tab(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.add_circle, size: 22),
              ),
              text: "Submit",
            ),
            Tab(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.analytics, size: 22),
              ),
              text: "Analytics",
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPendingTab(),
                _buildHistoryTab(),
                _buildSubmitTab(),
                _buildAnalyticsTab(),
              ],
            ),
    );
  }

  Widget _buildPendingTab() {
    return pendingRequests.isEmpty
        ? _buildEmptyState(
            icon: Icons.check_circle_outline,
            title: "No Pending Requests",
            subtitle: "All leave requests have been processed",
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              return _buildRequestCard(
                pendingRequests[index],
                showActions: true,
              );
            },
          );
  }

  Widget _buildHistoryTab() {
    return allRequests.isEmpty
        ? _buildEmptyState(
            icon: Icons.history,
            title: "No Request History",
            subtitle: "Leave request history will appear here",
          )
        : Column(
            children: [
              // Summary Stats
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[50],
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Total Requests",
                        allRequests.length.toString(),
                        Icons.description,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        "Approved",
                        allRequests
                            .where((req) => req['status'] == 'Approved')
                            .length
                            .toString(),
                        Icons.check_circle,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        "Rejected",
                        allRequests
                            .where((req) => req['status'] == 'Rejected')
                            .length
                            .toString(),
                        Icons.cancel,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              // Request List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allRequests.length,
                  itemBuilder: (context, index) {
                    return _buildRequestCard(allRequests[index]);
                  },
                ),
              ),
            ],
          );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Color(0xFF1E2029)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.arrow_right_alt, color: color, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Submit Leave Request",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Submit requests on behalf of employees",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Employee Selection
            Text(
              "Employee",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedEmployee,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Select Employee",
                prefixIcon: const Icon(Icons.person),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
              isExpanded: true,
              items: employees
                  .map(
                    (emp) => DropdownMenuItem<String>(
                      value: emp['id'],
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              emp['name'] ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: Text(
                              emp['department'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedEmployee = value),
              validator: (value) =>
                  value == null ? "Please select an employee" : null,
            ),
            const SizedBox(height: 16),

            // Leave Type
            Text(
              "Leave Type",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _leaveType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Select Leave Type",
                prefixIcon: const Icon(Icons.category),
              ),
              items: _leaveTypes
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _leaveType = value),
              validator: (value) =>
                  value == null ? "Please select leave type" : null,
            ),
            const SizedBox(height: 16),

            // Date Selection
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Date",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _pickDate(context, true),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 8),
                              Text(_formatDisplayDate(_startDate)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "End Date",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _pickDate(context, false),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 8),
                              Text(_formatDisplayDate(_endDate)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Leave Duration Display
            if (_startDate != null && _endDate != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      "Duration: ${_calculateLeaveDays()} day(s)",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Reason
            Text(
              "Reason",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Enter reason for leave",
                prefixIcon: const Icon(Icons.edit_note),
              ),
              onSaved: (value) => _reason = value,
              validator: (value) =>
                  value?.isEmpty ?? true ? "Please enter reason" : null,
            ),
            const SizedBox(height: 16),

            // Admin Notes
            Text(
              "Admin Notes (Optional)",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 2,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Additional notes for this leave request",
                prefixIcon: const Icon(Icons.note_add),
              ),
              onSaved: (value) => _adminNotes = value,
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitLeaveRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Submit Leave Request",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _resetForm,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Reset Form", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    // Calculate analytics from requests
    int totalRequests = allRequests.length;
    int approvedRequests = allRequests
        .where((req) => req['status'] == 'Approved')
        .length;
    int rejectedRequests = allRequests
        .where((req) => req['status'] == 'Rejected')
        .length;
    int pendingCount = pendingRequests.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Stats Row - These are the 4 cards from the screenshot
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Total Requests",
                      totalRequests.toString(),
                      Icons.description,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      "Pending",
                      pendingCount.toString(),
                      Icons.pending_actions,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Approved",
                      approvedRequests.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      "Rejected",
                      rejectedRequests.toString(),
                      Icons.cancel,
                      Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Leave Type Breakdown
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leave Type Breakdown",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._getLeaveTypeBreakdown().map(
                    (item) => _buildBreakdownItem(
                      item['type'],
                      item['count'],
                      item['color'],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Recent Activity
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Activity",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...allRequests.take(5).map((req) => _buildActivityItem(req)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map req, {bool showActions = false}) {
    final statusColor = _getStatusColor(req['status']);
    final days = req['days'] ?? _calculateRequestDays(req);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showRequestDetails(req),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(req['status']),
                          color: statusColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          req['status'] ?? 'Unknown',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      req['leave_type'] ?? 'Unknown',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Employee Information
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withOpacity(0.1),
                    child: Text(
                      (req['employee_name'] ?? 'U')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          req['employee_name'] ?? 'Unknown Employee',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.badge_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              req['employee_id'] ?? 'N/A',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.business,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                req['department'] ?? 'N/A',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Date and Duration Information
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Duration',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${req['start_date']} → ${req['end_date']}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$days day${days == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Reason
              Text(
                'Reason:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                req['reason'] ?? 'No reason provided',
                style: const TextStyle(fontSize: 14, height: 1.3),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Admin Notes (if any)
              if (req['admin_notes'] != null &&
                  req['admin_notes'].toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Admin Notes:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  req['admin_notes'],
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ],

              // Submission Date
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Submitted: ${req['submitted_date'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),

              // Action Buttons for Pending Requests
              if (showActions && req['status'] == 'Pending') ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showApprovalDialog(req, "Approve"),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text("Approve"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showApprovalDialog(req, "Reject"),
                        icon: const Icon(Icons.cancel, size: 18),
                        label: const Text("Reject"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String type, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 4, height: 20, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(type)),
          Text(
            count.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map req) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(req['status']),
            color: _getStatusColor(req['status']),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${req['leave_type']} - ${req['employee_name'] ?? req['employee_id']}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  req['status'] ?? 'Unknown',
                  style: TextStyle(
                    color: _getStatusColor(req['status']),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            req['start_date'] ?? '',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showApprovalDialog(Map req, String action) {
    final TextEditingController notesController = TextEditingController();
    final String actionStatus = action == "Approve" ? "Approved" : "Rejected";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              actionStatus == "Approved" ? Icons.check_circle : Icons.cancel,
              color: actionStatus == "Approved" ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text("$action Leave Request"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    req['employee_name'] ?? 'Unknown Employee',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${req['leave_type']} - ${req['start_date']} to ${req['end_date']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text("Are you sure you want to $action this leave request?"),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: "Admin Notes (Optional)",
                hintText: actionStatus == "Approved"
                    ? "e.g., Approved with sufficient leave balance"
                    : "e.g., Insufficient leave balance or scheduling conflict",
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(12),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(
                req['id'].toString(),
                actionStatus,
                notes: notesController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: actionStatus == "Approved"
                  ? Colors.green
                  : Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      case 'pending approval':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
      case 'pending approval':
        return Icons.pending;
      default:
        return Icons.help_outline;
    }
  }

  List<Map<String, dynamic>> _getLeaveTypeBreakdown() {
    Map<String, int> breakdown = {};
    for (var req in allRequests) {
      String type = req['leave_type'] ?? 'Unknown';
      breakdown[type] = (breakdown[type] ?? 0) + 1;
    }

    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.indigo,
      Colors.amber,
    ];

    return breakdown.entries.map((entry) {
      int index = breakdown.keys.toList().indexOf(entry.key);
      return {
        'type': entry.key,
        'count': entry.value,
        'color': colors[index % colors.length],
      };
    }).toList();
  }
}
