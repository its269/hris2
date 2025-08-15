import 'package:flutter/material.dart';

class TrainingManagementPage extends StatefulWidget {
  final bool showAppBar;
  
  const TrainingManagementPage({super.key, this.showAppBar = true});

  @override
  State<TrainingManagementPage> createState() => _TrainingManagementPageState();
}

class _TrainingManagementPageState extends State<TrainingManagementPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Mock data - replace with actual API calls
  final List<Map<String, dynamic>> _trainingModules = [
    {
      'id': 1,
      'title': 'Introduction to Company Policies',
      'description': 'Essential company policies and procedures',
      'duration': '2 hours',
      'completionRate': 85,
      'totalEmployees': 120,
      'completedEmployees': 102,
      'status': 'Active',
      'createdDate': '2024-01-15',
    },
    {
      'id': 2,
      'title': 'Workplace Safety Training',
      'description': 'Safety protocols and emergency procedures',
      'duration': '3 hours',
      'completionRate': 92,
      'totalEmployees': 120,
      'completedEmployees': 110,
      'status': 'Active',
      'createdDate': '2024-02-01',
    },
    {
      'id': 3,
      'title': 'Diversity and Inclusion',
      'description': 'Building an inclusive workplace culture',
      'duration': '1.5 hours',
      'completionRate': 78,
      'totalEmployees': 120,
      'completedEmployees': 94,
      'status': 'Active',
      'createdDate': '2024-02-15',
    },
    {
      'id': 4,
      'title': 'Cybersecurity Basics',
      'description': 'Digital security best practices',
      'duration': '2.5 hours',
      'completionRate': 65,
      'totalEmployees': 120,
      'completedEmployees': 78,
      'status': 'Draft',
      'createdDate': '2024-03-01',
    },
  ];

  final List<Map<String, dynamic>> _employeeProgress = [
    {
      'employeeId': 'EMP001',
      'name': 'John Doe',
      'department': 'IT',
      'completedTrainings': 3,
      'totalTrainings': 4,
      'completionRate': 75,
      'lastActivity': '2024-03-15',
    },
    {
      'employeeId': 'EMP002',
      'name': 'Jane Smith',
      'department': 'HR',
      'completedTrainings': 4,
      'totalTrainings': 4,
      'completionRate': 100,
      'lastActivity': '2024-03-20',
    },
    {
      'employeeId': 'EMP003',
      'name': 'Mike Johnson',
      'department': 'Finance',
      'completedTrainings': 2,
      'totalTrainings': 4,
      'completionRate': 50,
      'lastActivity': '2024-03-10',
    },
  ];

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Modules',
                  '${_trainingModules.length}',
                  Icons.school,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Avg. Completion',
                  '${(_trainingModules.map((m) => m['completionRate'] as int).reduce((a, b) => a + b) / _trainingModules.length).round()}%',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Employees',
                  '120',
                  Icons.people,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Active Modules',
                  '${_trainingModules.where((m) => m['status'] == 'Active').length}',
                  Icons.play_circle,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Recent Activity
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Training Activity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final activities = [
                        'Jane Smith completed "Cybersecurity Basics"',
                        'Mike Johnson started "Workplace Safety Training"',
                        'Sarah Wilson completed "Diversity and Inclusion"',
                      ];
                      final times = ['2 hours ago', '5 hours ago', '1 day ago'];
                      
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(activities[index]),
                        subtitle: Text(times[index]),
                        dense: true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesTab() {
    return Column(
      children: [
        // Search and Add Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search training modules...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add new training module
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add new training module')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Module'),
              ),
            ],
          ),
        ),
        
        // Training Modules List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _trainingModules.length,
            itemBuilder: (context, index) {
              final module = _trainingModules[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  title: Text(module['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(module['description']),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(module['duration'], style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(width: 16),
                          Icon(Icons.people, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${module['completedEmployees']}/${module['totalEmployees']}', 
                               style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: module['status'] == 'Active' ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          module['status'],
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('${module['completionRate']}%', 
                           style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Progress Bar
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: module['completionRate'] / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    module['completionRate'] >= 80 ? Colors.green : 
                                    module['completionRate'] >= 60 ? Colors.orange : Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text('${module['completionRate']}%'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Action Buttons
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: View detailed analytics
                                },
                                icon: const Icon(Icons.analytics),
                                label: const Text('Analytics'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Edit module
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Send reminders
                                },
                                icon: const Icon(Icons.notifications),
                                label: const Text('Remind'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeProgressTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search employees...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        
        // Employee Progress List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _employeeProgress.length,
            itemBuilder: (context, index) {
              final employee = _employeeProgress[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: employee['completionRate'] == 100 ? Colors.green : 
                                   employee['completionRate'] >= 75 ? Colors.orange : Colors.red,
                    child: Text(
                      employee['name'].toString().split(' ').map((n) => n[0]).join(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(employee['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${employee['department']} • ID: ${employee['employeeId']}'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Progress: ${employee['completedTrainings']}/${employee['totalTrainings']}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Last: ${employee['lastActivity']}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${employee['completionRate']}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: employee['completionRate'] == 100 ? Colors.green : 
                                 employee['completionRate'] >= 75 ? Colors.orange : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 60,
                        child: LinearProgressIndicator(
                          value: employee['completionRate'] / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            employee['completionRate'] == 100 ? Colors.green : 
                            employee['completionRate'] >= 75 ? Colors.orange : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // TODO: Show detailed employee training history
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('View details for ${employee['name']}')),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Report Generation
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generate Reports',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Generating completion report...')),
                          );
                        },
                        icon: const Icon(Icons.assignment_turned_in),
                        label: const Text('Completion Report'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Generating department report...')),
                          );
                        },
                        icon: const Icon(Icons.business),
                        label: const Text('Department Analysis'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Generating overdue report...')),
                          );
                        },
                        icon: const Icon(Icons.warning),
                        label: const Text('Overdue Training'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Exporting to Excel...')),
                          );
                        },
                        icon: const Icon(Icons.file_download),
                        label: const Text('Export to Excel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Quick Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Department Completion Rates',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ...[
                    {'dept': 'IT', 'rate': 95},
                    {'dept': 'HR', 'rate': 88},
                    {'dept': 'Finance', 'rate': 72},
                    {'dept': 'Marketing', 'rate': 65},
                    {'dept': 'Operations', 'rate': 78},
                  ].map((dept) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(dept['dept'].toString()),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: (dept['rate'] as int) / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              (dept['rate'] as int) >= 80 ? Colors.green : 
                              (dept['rate'] as int) >= 60 ? Colors.orange : Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 40,
                          child: Text('${dept['rate']}%'),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
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
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.school), text: 'Modules'),
            Tab(icon: Icon(Icons.people), text: 'Employees'),
            Tab(icon: Icon(Icons.analytics), text: 'Reports'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildModulesTab(),
              _buildEmployeeProgressTab(),
              _buildReportsTab(),
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
            Icon(Icons.school, 
                 color: colorScheme.onPrimaryContainer, 
                 size: 24),
            const SizedBox(width: 8),
            const Text('Training Management'),
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
