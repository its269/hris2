import 'package:flutter/material.dart';

class EmployeeHRFormsPage extends StatefulWidget {
  final bool showAppBar;
  
  const EmployeeHRFormsPage({super.key, this.showAppBar = true});

  @override
  State<EmployeeHRFormsPage> createState() => _EmployeeHRFormsPageState();
}

class _EmployeeHRFormsPageState extends State<EmployeeHRFormsPage> 
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // Sample data for pending/history forms
  final List<Map<String, dynamic>> _pendingForms = [
    {
      'id': 'HR001',
      'type': 'Certificate of Employment',
      'dateSubmitted': '2024-08-20',
      'status': 'Pending',
      'purpose': 'Bank loan application',
    },
    {
      'id': 'HR002',
      'type': 'Salary Certificate',
      'dateSubmitted': '2024-08-18',
      'status': 'Under Review',
      'purpose': 'Housing loan',
    },
    {
      'id': 'OT001',
      'type': 'Overtime Request',
      'dateSubmitted': '2024-08-22',
      'status': 'Pending',
      'purpose': '23/8/2024 - From 6:00 PM to 8:00 PM',
      'reason': 'Project deadline completion',
    },
  ];

  final List<Map<String, dynamic>> _historyForms = [
    {
      'id': 'HR003',
      'type': 'Certificate of Employment',
      'dateSubmitted': '2024-08-10',
      'dateProcessed': '2024-08-12',
      'status': 'Completed',
      'purpose': 'Visa application',
    },
    {
      'id': 'HR004',
      'type': 'Payslip Request',
      'dateSubmitted': '2024-08-05',
      'dateProcessed': '2024-08-06',
      'status': 'Completed',
      'purpose': 'Personal records',
    },
    {
      'id': 'UT001',
      'type': 'Undertime Request',
      'dateSubmitted': '2024-08-15',
      'dateProcessed': '2024-08-16',
      'status': 'Completed',
      'purpose': '16/8/2024 - Leave at 4:00 PM',
      'reason': 'Medical appointment',
    },
    {
      'id': 'HR005',
      'type': 'Tax Certificate',
      'dateSubmitted': '2024-07-28',
      'dateProcessed': '2024-07-30',
      'status': 'Completed',
      'purpose': 'Tax filing',
    },
  ];

  Widget _buildFormSubmissionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [
                        Color(0xFF2A2A3A),
                        Color(0xFF1E1E28),
                      ]
                    : [
                        Colors.blue.shade50,
                        Colors.indigo.shade50,
                      ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]!
                    : Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.description,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HR Request Forms',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Submit your document and time requests',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[300]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Form Categories
          Text(
            'Document Requests',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          
          // Document Forms Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.4,
            children: [
              _buildFormCard(
                'Certificate of Employment',
                'Employment verification',
                Icons.work,
                Colors.blue,
              ),
              _buildFormCard(
                'Salary Certificate',
                'Salary verification',
                Icons.attach_money,
                Colors.green,
              ),
              _buildFormCard(
                'Payslip Request',
                'Request payslip copies',
                Icons.receipt,
                Colors.orange,
              ),
              _buildFormCard(
                'Tax Certificate',
                'Tax withholding cert',
                Icons.account_balance,
                Colors.purple,
              ),
              _buildFormCard(
                'Leave Certificate',
                'Leave record cert',
                Icons.event_available,
                Colors.teal,
              ),
              _buildFormCard(
                'Other Documents',
                'Other HR documents',
                Icons.folder,
                Colors.grey,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Time Requests Section
          Text(
            'Time Requests',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          
          // Time Request Cards - Horizontal layout for better space usage
          Row(
            children: [
              Expanded(
                child: _buildFormCard(
                  'Overtime Request',
                  'Request overtime work',
                  Icons.access_time,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildFormCard(
                  'Undertime Request',
                  'Request early departure',
                  Icons.schedule,
                  Colors.indigo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(String title, String description, IconData icon, Color color) {
    // Calculate card width based on screen size - make it more responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 60) / 2; // Account for padding and spacing
    
    return SizedBox(
      width: cardWidth,
      height: 100, // Reduced height to prevent overflow
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showFormSubmissionDialog(title),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white
                            : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      description,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey[400]
                            : Colors.grey[600],
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingTab() {
    return _pendingForms.isEmpty
        ? _buildEmptyState('No pending requests', Icons.pending_actions)
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _pendingForms.length,
            itemBuilder: (context, index) {
              final form = _pendingForms[index];
              return _buildRequestCard(form, isPending: true);
            },
          );
  }

  Widget _buildHistoryTab() {
    return _historyForms.isEmpty
        ? _buildEmptyState('No request history', Icons.history)
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _historyForms.length,
            itemBuilder: (context, index) {
              final form = _historyForms[index];
              return _buildRequestCard(form, isPending: false);
            },
          );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> form, {required bool isPending}) {
    Color statusColor;
    IconData statusIcon;
    
    switch (form['status']) {
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'Under Review':
        statusColor = Colors.blue;
        statusIcon = Icons.rate_review;
        break;
      case 'Completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        form['type'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'ID: ${form['id']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    form['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Purpose: ${form['purpose']}',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Submitted: ${form['dateSubmitted']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (!isPending && form['dateProcessed'] != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.done, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Processed: ${form['dateProcessed']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFormSubmissionDialog(String formType) {
    if (formType == 'Overtime Request' || formType == 'Undertime Request') {
      _showTimeRequestDialog(formType);
      return;
    }
    
    final TextEditingController purposeController = TextEditingController();
    final TextEditingController remarksController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.description, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Request $formType',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please provide the following information:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose *',
                  hintText: 'e.g., Bank loan application, Visa processing',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: remarksController,
                decoration: const InputDecoration(
                  labelText: 'Additional Remarks (Optional)',
                  hintText: 'Any special instructions or requirements',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Processing time: 3-5 business days',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (purposeController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter the purpose of the request'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(context);
              
              // Add to pending forms (simulate API call)
              setState(() {
                _pendingForms.insert(0, {
                  'id': 'HR${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                  'type': formType,
                  'dateSubmitted': DateTime.now().toString().substring(0, 10),
                  'status': 'Pending',
                  'purpose': purposeController.text.trim(),
                });
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$formType request submitted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget bodyContent = Column(
      children: [
        // Tab Bar - More compact
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Submit Form', icon: Icon(Icons.add_circle_outline)),
              Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
              Tab(text: 'History', icon: Icon(Icons.history)),
            ],
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
            labelStyle: const TextStyle(fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
          ),
        ),
        
        // Tab Content
        Expanded(
          child: IndexedStack(
            index: _selectedTabIndex,
            children: [
              _buildFormSubmissionTab(),
              _buildPendingTab(),
              _buildHistoryTab(),
            ],
          ),
        ),
      ],
    );

    if (!widget.showAppBar) {
      return bodyContent;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.description, 
                 color: colorScheme.onPrimaryContainer, 
                 size: 24),
            const SizedBox(width: 8),
            const Text('HR Forms'),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: bodyContent,
    );
  }

  void _showTimeRequestDialog(String requestType) {
    final TextEditingController reasonController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                requestType == 'Overtime Request' ? Icons.access_time : Icons.schedule,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  requestType,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please fill in the details:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Date Selection
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 7)),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate != null 
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : 'Select Date *',
                          style: TextStyle(
                            color: selectedDate != null ? Colors.black87 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Time Range Selection
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              startTime = time;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                requestType == 'Overtime Request' ? 'Start Time *' : 'Leave Time *',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                startTime != null 
                                    ? startTime!.format(context)
                                    : '--:--',
                                style: TextStyle(
                                  color: startTime != null ? Colors.black87 : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              endTime = time;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                requestType == 'Overtime Request' ? 'End Time *' : 'Return Time',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                endTime != null 
                                    ? endTime!.format(context)
                                    : '--:--',
                                style: TextStyle(
                                  color: endTime != null ? Colors.black87 : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Reason Field
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason *',
                    hintText: 'Please explain the reason for this request',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                
                const SizedBox(height: 16),
                
                // Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          requestType == 'Overtime Request' 
                              ? 'Overtime requests require supervisor approval'
                              : 'Undertime requests must be filed in advance',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validation
                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a date'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (startTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(requestType == 'Overtime Request' 
                          ? 'Please select start time' 
                          : 'Please select leave time'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please provide a reason'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                Navigator.pop(context);
                
                // Create time details string
                String timeDetails = '';
                if (requestType == 'Overtime Request') {
                  timeDetails = 'From ${startTime!.format(context)}';
                  if (endTime != null) {
                    timeDetails += ' to ${endTime!.format(context)}';
                  }
                } else {
                  timeDetails = 'Leave at ${startTime!.format(context)}';
                  if (endTime != null) {
                    timeDetails += ', return at ${endTime!.format(context)}';
                  }
                }
                
                // Add to pending forms
                this.setState(() {
                  _pendingForms.insert(0, {
                    'id': 'HR${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    'type': requestType,
                    'dateSubmitted': DateTime.now().toString().substring(0, 10),
                    'status': 'Pending',
                    'purpose': '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} - $timeDetails',
                    'reason': reasonController.text.trim(),
                  });
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$requestType submitted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
