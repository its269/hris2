import 'package:flutter/material.dart';

class EmployeeLeaveRequestPage extends StatefulWidget {
  final bool showAppBar;
  
  const EmployeeLeaveRequestPage({super.key, this.showAppBar = true});

  @override
  State<EmployeeLeaveRequestPage> createState() => _EmployeeLeaveRequestPageState();
}

class _EmployeeLeaveRequestPageState extends State<EmployeeLeaveRequestPage> 
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
  
  // Sample data for pending/history leave requests
  final List<Map<String, dynamic>> _pendingLeaves = [
    {
      'id': 'LV001',
      'type': 'Paid Leave',
      'dateSubmitted': '2024-08-20',
      'status': 'Pending',
      'startDate': '2024-08-25',
      'endDate': '2024-08-27',
      'days': 3,
      'reason': 'Family vacation',
    },
    {
      'id': 'LV002',
      'type': 'Unpaid Leave',
      'dateSubmitted': '2024-08-22',
      'status': 'Under Review',
      'startDate': '2024-08-23',
      'endDate': '2024-08-23',
      'days': 1,
      'reason': 'Personal matters',
    },
  ];

  final List<Map<String, dynamic>> _historyLeaves = [
    {
      'id': 'LV003',
      'type': 'Paid Leave',
      'dateSubmitted': '2024-08-10',
      'dateProcessed': '2024-08-11',
      'status': 'Approved',
      'startDate': '2024-08-12',
      'endDate': '2024-08-14',
      'days': 3,
      'reason': 'Rest and recuperation',
    },
    {
      'id': 'LV004',
      'type': 'Paid Leave',
      'dateSubmitted': '2024-07-28',
      'dateProcessed': '2024-07-29',
      'status': 'Approved',
      'startDate': '2024-08-01',
      'endDate': '2024-08-05',
      'days': 5,
      'reason': 'Summer vacation',
    },
    {
      'id': 'LV005',
      'type': 'Unpaid Leave',
      'dateSubmitted': '2024-07-15',
      'dateProcessed': '2024-07-15',
      'status': 'Denied',
      'startDate': '2024-07-16',
      'endDate': '2024-07-16',
      'days': 1,
      'reason': 'Personal emergency',
      'denialReason': 'Insufficient justification provided',
    },
  ];

  Widget _buildLeaveRequestTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                        Colors.green.shade50,
                        Colors.teal.shade50,
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]!
                    : Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.event_available,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 12),
                Text(
                  'Leave Request',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Submit your leave applications',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[300]
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Leave Balance Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Your Leave Balance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBalanceItem('Paid Leave', '15', Colors.green),
                    _buildBalanceItem('Unpaid Leave', 'Available', Colors.orange),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Leave Types
          Text(
            'Request Leave',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Leave Type Cards
          Column(
            children: [
              _buildLeaveTypeCard(
                'Paid Leave',
                'Leave with salary compensation',
                Icons.payments,
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildLeaveTypeCard(
                'Unpaid Leave',
                'Leave without salary compensation',
                Icons.money_off,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String type, String days, Color color) {
    return Column(
      children: [
        Text(
          days,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          type,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveTypeCard(String title, String description, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showLeaveRequestDialog(title),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey[400]
                            : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingTab() {
    return _pendingLeaves.isEmpty
        ? _buildEmptyState('No pending leave requests', Icons.pending_actions)
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _pendingLeaves.length,
            itemBuilder: (context, index) {
              final leave = _pendingLeaves[index];
              return _buildLeaveCard(leave, isPending: true);
            },
          );
  }

  Widget _buildHistoryTab() {
    return _historyLeaves.isEmpty
        ? _buildEmptyState('No leave request history', Icons.history)
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _historyLeaves.length,
            itemBuilder: (context, index) {
              final leave = _historyLeaves[index];
              return _buildLeaveCard(leave, isPending: false);
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

  Widget _buildLeaveCard(Map<String, dynamic> leave, {required bool isPending}) {
    Color statusColor;
    IconData statusIcon;
    
    switch (leave['status']) {
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'Under Review':
        statusColor = Colors.blue;
        statusIcon = Icons.rate_review;
        break;
      case 'Approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Denied':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
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
                        leave['type'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'ID: ${leave['id']}',
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
                    leave['status'],
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
            
            // Leave Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        '${leave['startDate']} to ${leave['endDate']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${leave['days']} day${leave['days'] > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          leave['reason'],
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Submission and Processing Dates
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Submitted: ${leave['dateSubmitted']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (!isPending && leave['dateProcessed'] != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.done, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Processed: ${leave['dateProcessed']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            
            // Denial Reason (if applicable)
            if (leave['status'] == 'Denied' && leave['denialReason'] != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.red.shade700, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Reason: ${leave['denialReason']}',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLeaveRequestDialog(String leaveType) {
    final TextEditingController reasonController = TextEditingController();
    DateTime? startDate;
    DateTime? endDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.event_available, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Request $leaveType',
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
                  'Please fill in the leave details:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Date Selection
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              startDate = date;
                              if (endDate != null && endDate!.isBefore(date)) {
                                endDate = date;
                              }
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
                                'Start Date *',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                startDate != null 
                                    ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                                    : 'Select date',
                                style: TextStyle(
                                  color: startDate != null ? Colors.black87 : Colors.grey[600],
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
                          final date = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: startDate ?? DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              endDate = date;
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
                                'End Date *',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                endDate != null 
                                    ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                                    : 'Select date',
                                style: TextStyle(
                                  color: endDate != null ? Colors.black87 : Colors.grey[600],
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
                
                // Duration Display
                if (startDate != null && endDate != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.schedule, color: Colors.blue.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Duration: ${endDate!.difference(startDate!).inDays + 1} day(s)',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Reason Field
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason *',
                    hintText: 'Please explain the reason for this leave',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                
                const SizedBox(height: 16),
                
                // Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.green.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Leave requests require approval from your supervisor',
                          style: TextStyle(
                            color: Colors.green.shade700,
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
                if (startDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select start date'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (endDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select end date'),
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
                
                // Calculate days
                int days = endDate!.difference(startDate!).inDays + 1;
                
                // Add to pending leaves
                this.setState(() {
                  _pendingLeaves.insert(0, {
                    'id': 'LV${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    'type': leaveType,
                    'dateSubmitted': DateTime.now().toString().substring(0, 10),
                    'status': 'Pending',
                    'startDate': '${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}',
                    'endDate': '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}',
                    'days': days,
                    'reason': reasonController.text.trim(),
                  });
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$leaveType request submitted successfully'),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget bodyContent = Column(
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Request Leave', icon: Icon(Icons.add_circle_outline)),
              Tab(text: 'Pending', icon: Icon(Icons.pending_actions)),
              Tab(text: 'History', icon: Icon(Icons.history)),
            ],
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        
        // Tab Content
        Expanded(
          child: IndexedStack(
            index: _selectedTabIndex,
            children: [
              _buildLeaveRequestTab(),
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
            Icon(Icons.event_available, 
                 color: colorScheme.onPrimaryContainer, 
                 size: 24),
            const SizedBox(width: 8),
            const Text('Leave Requests'),
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
}
