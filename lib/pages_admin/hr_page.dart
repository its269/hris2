import 'package:flutter/material.dart';

class HRPage extends StatefulWidget {
  final bool showAppBar;

  const HRPage({super.key, this.showAppBar = true});

  @override
  State<HRPage> createState() => _HRPageState();
}

class _HRPageState extends State<HRPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;

  List employees = [];
  List overtimeRequests = [];
  List undertimeRequests = [];
  List adjustmentRequests = [];
  List certificateRequests = [];
  List allHRRequests = [];

  // Form variables
  final _formKey = GlobalKey<FormState>();
  String? _selectedEmployee;
  String? _formType;
  DateTime? _selectedDate;
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;
  String? _reason;
  String? _adminNotes;
  String? _certificateType;

  final List<String> _formTypes = [
    'Overtime Request',
    'Undertime Request',
    'Time Adjustment',
    'Certificate Request',
    'Salary Adjustment',
    'Schedule Change',
  ];

  final List<String> _certificateTypes = [
    'Certificate of Employment',
    'Certificate of Compensation',
    'Certificate of No Pending Case',
    'Service Record Certificate',
    'Tax Certificate (BIR 2316)',
    'SSS Certificate',
    'PhilHealth Certificate',
    'Pag-IBIG Certificate',
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
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      // Sample employees (unified with leave management)
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

      // Sample overtime requests
      overtimeRequests = [
        {
          'id': 'OT001',
          'employee_id': 'EMP002',
          'employee_name': 'Jane Smith',
          'department': 'Information Technology',
          'form_type': 'Overtime Request',
          'date': '2024-08-18',
          'time_from': '18:00',
          'time_to': '22:00',
          'hours': 4.0,
          'reason': 'Critical system deployment and testing',
          'status': 'Pending',
          'submitted_date': '2024-08-15',
          'admin_notes': '',
        },
        {
          'id': 'OT002',
          'employee_id': 'EMP003',
          'employee_name': 'Mike Johnson',
          'department': 'Finance',
          'form_type': 'Overtime Request',
          'date': '2024-08-19',
          'time_from': '17:30',
          'time_to': '20:30',
          'hours': 3.0,
          'reason': 'Month-end financial reporting and reconciliation',
          'status': 'Approved',
          'submitted_date': '2024-08-16',
          'approved_date': '2024-08-17',
          'admin_notes': 'Approved for month-end closure',
        },
      ];

      // Sample undertime requests
      undertimeRequests = [
        {
          'id': 'UT001',
          'employee_id': 'EMP005',
          'employee_name': 'David Brown',
          'department': 'Operations',
          'form_type': 'Undertime Request',
          'date': '2024-08-20',
          'time_from': '14:00',
          'time_to': '17:00',
          'hours': 3.0,
          'reason': 'Medical appointment that cannot be rescheduled',
          'status': 'Pending',
          'submitted_date': '2024-08-17',
          'admin_notes': '',
        },
      ];

      // Sample certificate requests
      certificateRequests = [
        {
          'id': 'CERT001',
          'employee_id': 'EMP006',
          'employee_name': 'Emily Davis',
          'department': 'Sales',
          'form_type': 'Certificate Request',
          'certificate_type': 'Certificate of Employment',
          'reason': 'Bank loan application requirement',
          'status': 'Approved',
          'submitted_date': '2024-08-14',
          'approved_date': '2024-08-15',
          'admin_notes': 'Certificate prepared and ready for pickup',
        },
        {
          'id': 'CERT002',
          'employee_id': 'EMP007',
          'employee_name': 'Robert Miller',
          'department': 'IT Support',
          'form_type': 'Certificate Request',
          'certificate_type': 'Certificate of Compensation',
          'reason': 'Visa application requirement',
          'status': 'Pending',
          'submitted_date': '2024-08-16',
          'admin_notes': '',
        },
      ];

      // Sample adjustment requests
      adjustmentRequests = [
        {
          'id': 'ADJ001',
          'employee_id': 'EMP004',
          'employee_name': 'Sarah Wilson',
          'department': 'Marketing',
          'form_type': 'Time Adjustment',
          'date': '2024-08-15',
          'reason': 'Incorrect time-in recorded due to system glitch',
          'status': 'Approved',
          'submitted_date': '2024-08-16',
          'approved_date': '2024-08-16',
          'admin_notes': 'System log verified, adjustment approved',
        },
      ];

      // Combine all requests
      allHRRequests = [
        ...overtimeRequests,
        ...undertimeRequests,
        ...certificateRequests,
        ...adjustmentRequests,
      ];

      isLoading = false;
    });
  }

  Widget bodyContent() {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0, // Remove the toolbar to maximize tab space
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'History'),
                Tab(text: 'Submit'),
                Tab(text: 'Analytics'),
              ],
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    if (!widget.showAppBar) {
      return bodyContent();
    }

    return bodyContent();
  }

  Widget _buildPendingTab() {
    final pendingRequests = allHRRequests
        .where((req) => req['status'] == 'Pending')
        .toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return pendingRequests.isEmpty
        ? _buildEmptyState(
            icon: Icons.assignment_outlined,
            title: "No Pending HR Forms",
            subtitle: "All HR form requests have been processed",
          )
        : Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey[50],
            ),
            child: Column(
              children: [
                // Header Section
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade600, Colors.orange.shade400],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.pending_actions,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pending HR Forms',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pendingRequests.length} forms awaiting approval',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Forms Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 2.5,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: pendingRequests.length,
                    itemBuilder: (context, index) {
                      return _buildModernHRCard(
                        pendingRequests[index],
                        showActions: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildHistoryTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return allHRRequests.isEmpty
        ? _buildEmptyState(
            icon: Icons.history_outlined,
            title: "No Form History",
            subtitle: "HR form request history will appear here",
          )
        : Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.grey[50],
            ),
            child: Column(
              children: [
                // Stats Dashboard
                // Container(
                //   margin: const EdgeInsets.all(16),
                //   child: Column(
                //     children: [
                //       // Header
                //       // Container(
                //       //   padding: const EdgeInsets.all(20),
                //       //   decoration: BoxDecoration(
                //       //     gradient: LinearGradient(
                //       //       colors: [Colors.green.shade400, Colors.green.shade600],
                //       //     ),
                //       //     borderRadius: const BorderRadius.only(
                //       //       topLeft: Radius.circular(16),
                //       //       topRight: Radius.circular(16),
                //       //     ),
                //       //   ),
                //       //   // child: Row(
                //       //   //   children: [
                //       //   //     const Icon(Icons.analytics, color: Colors.white, size: 28),
                //       //   //     const SizedBox(width: 12),
                //       //   //     const Text(
                //       //   //       'HR Forms Analytics',
                //       //   //       style: TextStyle(
                //       //   //         color: Colors.white,
                //       //   //         fontSize: 20,
                //       //   //         fontWeight: FontWeight.bold,
                //       //   //       ),
                //       //   //     ),
                //       //   //   ],
                //       //   // ),
                //       // ),

                //       // Stats Cards
                //       Container(
                //         padding: const EdgeInsets.all(16),
                //         // decoration: BoxDecoration(
                //         //   color: Colors.white,
                //         //   borderRadius: const BorderRadius.only(
                //         //     bottomLeft: Radius.circular(16),
                //         //     bottomRight: Radius.circular(16),
                //         //   ),
                //         //   boxShadow: [
                //         //     BoxShadow(
                //         //       color: Colors.green.withOpacity(0.1),
                //         //       blurRadius: 10,
                //         //       offset: const Offset(0, 4),
                //         //     ),
                //         //   ],
                //         // ),
                //         child: Column(
                //           children: [
                //             Row(
                //               children: [
                //                 // Expanded(
                //                 //   child: _buildCircularStatCard(
                //                 //     "Total",
                //                 //     allHRRequests.length.toString(),
                //                 //     Icons.description,
                //                 //     Colors.blue,
                //                 //     0.7,
                //                 //   ),
                //                 // ),
                //                 const SizedBox(width: 12),
                //                 // Expanded(
                //                 //   child: _buildCircularStatCard(
                //                 //     "Approved",
                //                 //     allHRRequests.where((req) => req['status'] == 'Approved').length.toString(),
                //                 //     Icons.check_circle,
                //                 //     Colors.green,
                //                 //     0.85,
                //                 //   ),
                //                 // ),
                //               ],
                //             ),
                //             const SizedBox(height: 12),
                //             Row(
                //               children: [
                //                 // Expanded(
                //                 //   child: _buildCircularStatCard(
                //                 //     "Pending",
                //                 //     allHRRequests.where((req) => req['status'] == 'Pending').length.toString(),
                //                 //     Icons.pending_actions,
                //                 //     Colors.orange,
                //                 //     0.3,
                //                 //   ),
                //                 // ),
                //                 const SizedBox(width: 12),
                //                 // Expanded(
                //                 //   child: _buildCircularStatCard(
                //                 //     "This Month",
                //                 //     "15",
                //                 //     Icons.calendar_month,
                //                 //     Colors.purple,
                //                 //     0.6,
                //                 //   ),
                //                 // ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // Timeline List
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: allHRRequests.length,
                      itemBuilder: (context, index) {
                        return _buildTimelineCard(allHRRequests[index], index);
                      },
                    ),
                  ),
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
                        Icons.assignment,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Submit HR Form Request",
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
                    "Submit various HR forms on behalf of employees",
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

            // Form Type
            Text(
              "Form Type",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _formType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Select Form Type",
                prefixIcon: const Icon(Icons.assignment),
              ),
              items: _formTypes
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _formType = value),
              validator: (value) =>
                  value == null ? "Please select form type" : null,
            ),
            const SizedBox(height: 16),

            // Conditional fields based on form type
            if (_formType == 'Overtime Request' ||
                _formType == 'Undertime Request' ||
                _formType == 'Time Adjustment') ...[
              // Date Selection
              Text(
                "Date",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _pickDate(context),
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
                      Text(_formatDisplayDate(_selectedDate)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_formType == 'Overtime Request' ||
                  _formType == 'Undertime Request') ...[
                // Time Selection
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time From",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _pickTime(context, true),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time),
                                  const SizedBox(width: 8),
                                  Text(_formatTime(_timeFrom)),
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
                            "Time To",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _pickTime(context, false),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time),
                                  const SizedBox(width: 8),
                                  Text(_formatTime(_timeTo)),
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

                // Hours calculation display
                if (_timeFrom != null && _timeTo != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          "Total Hours: ${_calculateHours().toStringAsFixed(1)}",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ],

            if (_formType == 'Certificate Request') ...[
              // Certificate Type
              Text(
                "Certificate Type",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _certificateType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Select Certificate Type",
                  prefixIcon: const Icon(Icons.description),
                ),
                items: _certificateTypes
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _certificateType = value),
                validator: (value) =>
                    _formType == 'Certificate Request' && value == null
                    ? "Please select certificate type"
                    : null,
              ),
              const SizedBox(height: 16),
            ],

            // Reason
            Text(
              "Reason/Purpose",
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
                hintText: "Enter reason or purpose",
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
                hintText: "Additional notes for this request",
                prefixIcon: const Icon(Icons.note_add),
              ),
              onSaved: (value) => _adminNotes = value,
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Submit Request",
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
    int totalRequests = allHRRequests.length;
    int approvedRequests = allHRRequests
        .where((req) => req['status'] == 'Approved')
        .length;
    int pendingRequests = allHRRequests
        .where((req) => req['status'] == 'Pending')
        .length;
    int overtimeCount = allHRRequests
        .where((req) => req['form_type'] == 'Overtime Request')
        .length;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[50],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              // decoration: BoxDecoration(
              //   color: isDark ? Colors.grey[850] : Colors.white,
              //   borderRadius: BorderRadius.circular(12),
              //   border: Border.all(
              //     color: isDark ? Colors.grey[700]! : Theme.of(context).primaryColor.withOpacity(0.2),
              //   ),
              // ),
              // child: Row(
              //   children: [
              //     Icon(
              //       Icons.insights,
              //       color: Theme.of(context).primaryColor,
              //       size: 24,
              //     ),
              //     const SizedBox(width: 12),
              //     // Expanded(
              //     //   child: Column(
              //     //     crossAxisAlignment: CrossAxisAlignment.start,
              //     //     children: [
              //     //       Text(
              //     //         'HR Forms Analytics',
              //     //         style: TextStyle(
              //     //           color: isDark ? Colors.white : Colors.black,
              //     //           fontSize: 18,
              //     //           fontWeight: FontWeight.bold,
              //     //         ),
              //     //       ),
              //     //       const SizedBox(height: 4),
              //     //       Text(
              //     //         'Detailed insights and trends',
              //     //         style: TextStyle(
              //     //           color: isDark ? Colors.grey[400] : Colors.grey[600],
              //     //           fontSize: 12,
              //     //         ),
              //     //       ),
              //     //     ],
              //     //   ),
              //     // ),
              //   ],
              // ),
            ),

            const SizedBox(height: 24),

            // Hexagonal Stats
            Row(
              children: [
                Expanded(
                  child: _buildHexagonalStat(
                    "Total Forms",
                    totalRequests.toString(),
                    Icons.description,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHexagonalStat(
                    "Pending",
                    pendingRequests.toString(),
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildHexagonalStat(
                    "Approved",
                    approvedRequests.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHexagonalStat(
                    "Overtime",
                    overtimeCount.toString(),
                    Icons.access_time,
                    Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Form Type Breakdown with Different Design
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.pie_chart,
                          color: Colors.purple.shade600,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Form Types Distribution",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ..._getFormTypeBreakdown().map(
                    (item) => _buildAdvancedBreakdownItem(
                      item['type'],
                      item['count'],
                      item['color'],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Activity Feed with Modern Design
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.timeline,
                          color: Colors.green.shade600,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Recent Activity Feed",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...allHRRequests
                      .take(4)
                      .map((req) => _buildActivityFeedItem(req)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // New Modern Widget Methods
  Widget _buildModernHRCard(Map req, {bool showActions = false}) {
    final statusColor = _getStatusColor(req['status']);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : statusColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: statusColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showRequestDetails(req),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Left Side - Employee Avatar & Status
              Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: statusColor.withOpacity(0.1),
                        child: Text(
                          (req['employee_name'] ?? 'U')
                              .substring(0, 1)
                              .toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getStatusIcon(req['status']),
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Center - Main Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Text(
                        req['form_type'] ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Employee Name
                    Text(
                      req['employee_name'] ?? 'Unknown Employee',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Details Row
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          req['date'] ?? req['submitted_date'] ?? 'No date',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        if (req['hours'] != null) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${req['hours'].toStringAsFixed(1)}h',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Right Side - Actions
              if (showActions && req['status'] == 'Pending')
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _showApprovalDialog(req, "Approve"),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.green, width: 1),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showApprovalDialog(req, "Reject"),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.red, width: 1),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineCard(Map req, int index) {
    final statusColor = _getStatusColor(req['status']);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.white,
                    width: 3,
                  ),
                ),
                child: Icon(
                  _getStatusIcon(req['status']),
                  color: Colors.white,
                  size: 10,
                ),
              ),
              if (index < allHRRequests.length - 1)
                Container(
                  width: 2,
                  height: 40,
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                ),
            ],
          ),

          const SizedBox(width: 16),

          // Card content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.grey[700]!
                      : statusColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          req['form_type'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        req['date'] ?? req['submitted_date'] ?? '',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    req['employee_name'] ?? 'Unknown Employee',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  if (req['reason'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      req['reason'],
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHexagonalStat(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.8), color],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedBreakdownItem(String type, int count, Color color) {
    final percentage = allHRRequests.isNotEmpty
        ? (count / allHRRequests.length)
        : 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.7), color],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  type,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count (${(percentage * 100).toStringAsFixed(0)}%)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeedItem(Map req) {
    final statusColor = _getStatusColor(req['status']);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[600]! : statusColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getStatusIcon(req['status']),
              color: statusColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${req['form_type']} - ${req['employee_name'] ?? req['employee_id']}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        req['status'] ?? 'Unknown',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      req['date'] ?? req['submitted_date'] ?? '',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: isDark ? Colors.grey[500] : Colors.grey[400],
            size: 14,
          ),
        ],
      ),
    );
  }

  // Helper methods
  Future<void> _pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isTimeFrom) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: isTimeFrom
          ? (_timeFrom ?? TimeOfDay.now())
          : (_timeTo ?? TimeOfDay.now()),
    );

    if (newTime != null) {
      setState(() {
        if (isTimeFrom) {
          _timeFrom = newTime;
        } else {
          _timeTo = newTime;
        }
      });
    }
  }

  String _formatDisplayDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    return time.format(context);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  double _calculateHours() {
    if (_timeFrom == null || _timeTo == null) return 0.0;

    final from = _timeFrom!.hour + _timeFrom!.minute / 60.0;
    final to = _timeTo!.hour + _timeTo!.minute / 60.0;

    return to > from ? to - from : (24 - from) + to;
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));

      try {
        // Create new request with dummy data
        final newRequest = {
          'id':
              '${_formType?.substring(0, 3).toUpperCase()}${(allHRRequests.length + 1).toString().padLeft(3, '0')}',
          'employee_id': _selectedEmployee,
          'employee_name': employees.firstWhere(
            (emp) => emp['id'] == _selectedEmployee,
          )['name'],
          'department': employees.firstWhere(
            (emp) => emp['id'] == _selectedEmployee,
          )['department'],
          'form_type': _formType,
          'date': _formatDate(_selectedDate),
          'time_from': _timeFrom != null
              ? '${_timeFrom!.hour.toString().padLeft(2, '0')}:${_timeFrom!.minute.toString().padLeft(2, '0')}'
              : null,
          'time_to': _timeTo != null
              ? '${_timeTo!.hour.toString().padLeft(2, '0')}:${_timeTo!.minute.toString().padLeft(2, '0')}'
              : null,
          'hours': _calculateHours(),
          'certificate_type': _certificateType,
          'reason': _reason,
          'status': 'Approved', // Admin submissions are auto-approved
          'submitted_date': _formatDate(DateTime.now()),
          'approved_date': _formatDate(DateTime.now()),
          'approved_by': 'Admin',
          'admin_notes': _adminNotes ?? 'Admin submission - Auto approved',
        };

        setState(() {
          allHRRequests.insert(0, newRequest);
        });

        _resetForm();
        _showSuccessMessage("HR form request submitted successfully");
      } catch (e) {
        _showErrorMessage("Error submitting request");
      }
    }
  }

  void _resetForm() {
    setState(() {
      _selectedEmployee = null;
      _formType = null;
      _selectedDate = null;
      _timeFrom = null;
      _timeTo = null;
      _reason = null;
      _adminNotes = null;
      _certificateType = null;
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

  Future<void> _updateStatus(String id, String status, {String? notes}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      // Update the status in dummy data
      for (int i = 0; i < allHRRequests.length; i++) {
        if (allHRRequests[i]['id'] == id) {
          setState(() {
            allHRRequests[i]['status'] = status;
            allHRRequests[i]['admin_notes'] = notes ?? '';
            allHRRequests[i]['${status.toLowerCase()}_date'] = _formatDate(
              DateTime.now(),
            );
            allHRRequests[i]['${status.toLowerCase()}_by'] = 'Admin';
          });
          break;
        }
      }

      _showSuccessMessage("Request $status successfully");
    } catch (e) {
      _showErrorMessage("Error updating request status");
    }
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

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'Approved':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      case 'Pending':
        return Icons.pending_actions;
      default:
        return Icons.help_outline;
    }
  }

  void _showRequestDetails(Map req) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${req['form_type']} Request'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Employee', req['employee_name']),
              _buildDetailRow('Employee ID', req['employee_id']),
              _buildDetailRow('Department', req['department']),
              _buildDetailRow('Form Type', req['form_type']),
              if (req['date'] != null) _buildDetailRow('Date', req['date']),
              if (req['time_from'] != null)
                _buildDetailRow('Time From', req['time_from']),
              if (req['time_to'] != null)
                _buildDetailRow('Time To', req['time_to']),
              if (req['hours'] != null)
                _buildDetailRow('Hours', req['hours'].toString()),
              if (req['certificate_type'] != null)
                _buildDetailRow('Certificate Type', req['certificate_type']),
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
            Text("$action Request"),
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
                    '${req['form_type']} - ${req['date'] ?? 'No date'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Admin Notes",
                hintText: "Add notes for this decision...",
                border: OutlineInputBorder(),
              ),
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
                req['id'],
                actionStatus,
                notes: notesController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: actionStatus == "Approved"
                  ? Colors.green
                  : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFormTypeBreakdown() {
    final formTypes = <String, int>{};
    for (final req in allHRRequests) {
      final type = req['form_type'] ?? 'Unknown';
      formTypes[type] = (formTypes[type] ?? 0) + 1;
    }

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    int colorIndex = 0;

    return formTypes.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return {'type': entry.key, 'count': entry.value, 'color': color};
    }).toList();
  }
}
