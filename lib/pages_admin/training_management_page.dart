import 'package:flutter/material.dart';

class TrainingManagementPage extends StatefulWidget {
  final bool showAppBar;
  
  const TrainingManagementPage({super.key, this.showAppBar = true});

  @override
  State<TrainingManagementPage> createState() => _TrainingManagementPageState();
}

class _TrainingManagementPageState extends State<TrainingManagementPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _employeeSearchQuery = '';
  String _assessmentSearchQuery = '';
  int _selectedTabIndex = 0; // Add this to track selected tab
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    // Add listener to keep tabs synchronized
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Enhanced training modules with assessment information
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
      'content': 'This comprehensive training covers all essential company policies including code of conduct, workplace ethics, communication guidelines, and compliance requirements.',
      'objectives': ['Understand company values', 'Learn code of conduct', 'Know compliance requirements'],
      'hasQuiz': true,
      'passingScore': 80,
      'averageScore': 87.5,
      'quizQuestions': 15,
      'assessmentType': 'Multiple Choice Quiz',
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
      'content': 'Comprehensive safety training covering fire safety, emergency evacuation procedures, first aid basics, and workplace hazard identification.',
      'objectives': ['Fire safety protocols', 'Emergency procedures', 'First aid basics'],
      'hasQuiz': true,
      'passingScore': 85,
      'averageScore': 91.2,
      'quizQuestions': 20,
      'assessmentType': 'Practical Assessment',
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
      'content': 'Learn about creating an inclusive workplace, understanding unconscious bias, and promoting diversity in all aspects of work.',
      'objectives': ['Understand unconscious bias', 'Promote inclusion', 'Respect diversity'],
      'hasQuiz': true,
      'passingScore': 75,
      'averageScore': 83.7,
      'quizQuestions': 12,
      'assessmentType': 'Scenario-Based Quiz',
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
      'content': 'Essential cybersecurity training covering password security, phishing awareness, data protection, and secure communication practices.',
      'objectives': ['Password security', 'Phishing awareness', 'Data protection'],
      'hasQuiz': true,
      'passingScore': 80,
      'averageScore': 79.3,
      'quizQuestions': 18,
      'assessmentType': 'Interactive Simulation',
    },
    {
      'id': 5,
      'title': 'Customer Service Excellence',
      'description': 'Delivering exceptional customer experiences',
      'duration': '2 hours',
      'completionRate': 88,
      'totalEmployees': 120,
      'completedEmployees': 106,
      'status': 'Active',
      'createdDate': '2024-03-10',
      'content': 'Learn advanced customer service techniques, conflict resolution, and building lasting customer relationships.',
      'objectives': ['Customer communication', 'Conflict resolution', 'Service excellence'],
      'hasQuiz': true,
      'passingScore': 80,
      'averageScore': 88.9,
      'quizQuestions': 16,
      'assessmentType': 'Role-Play Assessment',
    },
  ];

  // Enhanced employee progress with detailed quiz/assessment results
  final List<Map<String, dynamic>> _employeeProgress = [
    {
      'employeeId': 'EMP001',
      'name': 'John Doe',
      'department': 'IT',
      'completedTrainings': 3,
      'totalTrainings': 5,
      'completionRate': 60,
      'lastActivity': '2024-03-15',
      'profileImage': null,
      'averageScore': 91.7,
      'trainings': [
        {
          'name': 'Company Policies', 
          'status': 'Completed', 
          'score': 95,
          'attempts': 1,
          'timeSpent': '1.8 hours',
          'completedDate': '2024-02-10',
          'quizResults': [
            {'attempt': 1, 'score': 95, 'date': '2024-02-10', 'timeSpent': '25 min'}
          ]
        },
        {
          'name': 'Workplace Safety', 
          'status': 'Completed', 
          'score': 88,
          'attempts': 2,
          'timeSpent': '2.5 hours',
          'completedDate': '2024-02-20',
          'quizResults': [
            {'attempt': 1, 'score': 76, 'date': '2024-02-18', 'timeSpent': '32 min'},
            {'attempt': 2, 'score': 88, 'date': '2024-02-20', 'timeSpent': '28 min'}
          ]
        },
        {
          'name': 'Cybersecurity Basics', 
          'status': 'Completed', 
          'score': 92,
          'attempts': 1,
          'timeSpent': '2.2 hours',
          'completedDate': '2024-03-05',
          'quizResults': [
            {'attempt': 1, 'score': 92, 'date': '2024-03-05', 'timeSpent': '35 min'}
          ]
        },
        {
          'name': 'Diversity and Inclusion', 
          'status': 'In Progress', 
          'score': null,
          'attempts': 0,
          'timeSpent': '0.5 hours',
          'completedDate': null,
          'quizResults': []
        },
        {
          'name': 'Customer Service', 
          'status': 'Not Started', 
          'score': null,
          'attempts': 0,
          'timeSpent': '0 hours',
          'completedDate': null,
          'quizResults': []
        },
      ],
    },
    {
      'employeeId': 'EMP002',
      'name': 'Jane Smith',
      'department': 'HR',
      'completedTrainings': 5,
      'totalTrainings': 5,
      'completionRate': 100,
      'lastActivity': '2024-03-20',
      'profileImage': null,
      'averageScore': 93.6,
      'trainings': [
        {
          'name': 'Company Policies', 
          'status': 'Completed', 
          'score': 98,
          'attempts': 1,
          'timeSpent': '1.9 hours',
          'completedDate': '2024-01-20',
          'quizResults': [
            {'attempt': 1, 'score': 98, 'date': '2024-01-20', 'timeSpent': '22 min'}
          ]
        },
        {
          'name': 'Workplace Safety', 
          'status': 'Completed', 
          'score': 94,
          'attempts': 1,
          'timeSpent': '2.8 hours',
          'completedDate': '2024-02-05',
          'quizResults': [
            {'attempt': 1, 'score': 94, 'date': '2024-02-05', 'timeSpent': '30 min'}
          ]
        },
        {
          'name': 'Cybersecurity Basics', 
          'status': 'Completed', 
          'score': 89,
          'attempts': 1,
          'timeSpent': '2.3 hours',
          'completedDate': '2024-02-25',
          'quizResults': [
            {'attempt': 1, 'score': 89, 'date': '2024-02-25', 'timeSpent': '38 min'}
          ]
        },
        {
          'name': 'Diversity and Inclusion', 
          'status': 'Completed', 
          'score': 96,
          'attempts': 1,
          'timeSpent': '1.4 hours',
          'completedDate': '2024-03-10',
          'quizResults': [
            {'attempt': 1, 'score': 96, 'date': '2024-03-10', 'timeSpent': '18 min'}
          ]
        },
        {
          'name': 'Customer Service', 
          'status': 'Completed', 
          'score': 91,
          'attempts': 1,
          'timeSpent': '1.9 hours',
          'completedDate': '2024-03-20',
          'quizResults': [
            {'attempt': 1, 'score': 91, 'date': '2024-03-20', 'timeSpent': '26 min'}
          ]
        },
      ],
    },
    {
      'employeeId': 'EMP003',
      'name': 'Mike Johnson',
      'department': 'Finance',
      'completedTrainings': 2,
      'totalTrainings': 5,
      'completionRate': 40,
      'lastActivity': '2024-03-10',
      'profileImage': null,
      'averageScore': 84.5,
      'trainings': [
        {
          'name': 'Company Policies', 
          'status': 'Completed', 
          'score': 87,
          'attempts': 2,
          'timeSpent': '2.1 hours',
          'completedDate': '2024-02-15',
          'quizResults': [
            {'attempt': 1, 'score': 72, 'date': '2024-02-12', 'timeSpent': '28 min'},
            {'attempt': 2, 'score': 87, 'date': '2024-02-15', 'timeSpent': '24 min'}
          ]
        },
        {
          'name': 'Workplace Safety', 
          'status': 'Completed', 
          'score': 92,
          'attempts': 1,
          'timeSpent': '2.9 hours',
          'completedDate': '2024-03-01',
          'quizResults': [
            {'attempt': 1, 'score': 92, 'date': '2024-03-01', 'timeSpent': '31 min'}
          ]
        },
        {
          'name': 'Cybersecurity Basics', 
          'status': 'In Progress', 
          'score': null,
          'attempts': 1,
          'timeSpent': '1.2 hours',
          'completedDate': null,
          'quizResults': [
            {'attempt': 1, 'score': 65, 'date': '2024-03-08', 'timeSpent': '42 min', 'passed': false}
          ]
        },
        {
          'name': 'Diversity and Inclusion', 
          'status': 'Not Started', 
          'score': null,
          'attempts': 0,
          'timeSpent': '0 hours',
          'completedDate': null,
          'quizResults': []
        },
        {
          'name': 'Customer Service', 
          'status': 'Not Started', 
          'score': null,
          'attempts': 0,
          'timeSpent': '0 hours',
          'completedDate': null,
          'quizResults': []
        },
      ],
    },
    {
      'employeeId': 'EMP004',
      'name': 'Sarah Wilson',
      'department': 'Marketing',
      'completedTrainings': 4,
      'totalTrainings': 5,
      'completionRate': 80,
      'lastActivity': '2024-03-18',
      'profileImage': null,
      'averageScore': 89.0,
      'trainings': [
        {
          'name': 'Company Policies', 
          'status': 'Completed', 
          'score': 93,
          'attempts': 1,
          'timeSpent': '1.7 hours',
          'completedDate': '2024-01-28',
          'quizResults': [
            {'attempt': 1, 'score': 93, 'date': '2024-01-28', 'timeSpent': '21 min'}
          ]
        },
        {
          'name': 'Workplace Safety', 
          'status': 'Completed', 
          'score': 90,
          'attempts': 1,
          'timeSpent': '2.7 hours',
          'completedDate': '2024-02-12',
          'quizResults': [
            {'attempt': 1, 'score': 90, 'date': '2024-02-12', 'timeSpent': '29 min'}
          ]
        },
        {
          'name': 'Cybersecurity Basics', 
          'status': 'Completed', 
          'score': 85,
          'attempts': 2,
          'timeSpent': '2.4 hours',
          'completedDate': '2024-03-05',
          'quizResults': [
            {'attempt': 1, 'score': 78, 'date': '2024-03-02', 'timeSpent': '41 min'},
            {'attempt': 2, 'score': 85, 'date': '2024-03-05', 'timeSpent': '36 min'}
          ]
        },
        {
          'name': 'Diversity and Inclusion', 
          'status': 'Completed', 
          'score': 88,
          'attempts': 1,
          'timeSpent': '1.3 hours',
          'completedDate': '2024-03-15',
          'quizResults': [
            {'attempt': 1, 'score': 88, 'date': '2024-03-15', 'timeSpent': '16 min'}
          ]
        },
        {
          'name': 'Customer Service', 
          'status': 'In Progress', 
          'score': null,
          'attempts': 0,
          'timeSpent': '0.8 hours',
          'completedDate': null,
          'quizResults': []
        },
      ],
    },
    {
      'employeeId': 'EMP005',
      'name': 'David Brown',
      'department': 'Operations',
      'completedTrainings': 1,
      'totalTrainings': 5,
      'completionRate': 20,
      'lastActivity': '2024-03-05',
      'profileImage': null,
      'averageScore': 82.0,
      'trainings': [
        {
          'name': 'Company Policies', 
          'status': 'Completed', 
          'score': 82,
          'attempts': 3,
          'timeSpent': '2.5 hours',
          'completedDate': '2024-03-05',
          'quizResults': [
            {'attempt': 1, 'score': 68, 'date': '2024-02-28', 'timeSpent': '33 min'},
            {'attempt': 2, 'score': 74, 'date': '2024-03-02', 'timeSpent': '29 min'},
            {'attempt': 3, 'score': 82, 'date': '2024-03-05', 'timeSpent': '26 min'}
          ]
        },
        {
          'name': 'Workplace Safety', 
          'status': 'Not Started', 
          'score': null,
          'attempts': 0,
          'timeSpent': '0 hours',
          'completedDate': null,
          'quizResults': []
        },
        {
          'name': 'Cybersecurity Basics', 
          'status': 'Not Started', 
          'score': null,
          'attempts': 0,
          'timeSpent': '0 hours',
          'completedDate': null,
          'quizResults': []
        },
        {
          'name': 'Diversity and Inclusion', 
          'status': 'Not Started', 
          'score': null,
          'attempts': 0,
          'timeSpent': '0 hours',
          'completedDate': null,
          'quizResults': []
        },
        {
          'name': 'Customer Service', 
          'status': 'Not Started', 
          'score': null,
          'attempts': 0,
          'timeSpent': '0 hours',
          'completedDate': null,
          'quizResults': []
        },
      ],
    },
  ];

  // New data structure for detailed assessment tracking
  final List<Map<String, dynamic>> _assessmentResults = [
    {
      'id': 'ASSESS001',
      'employeeId': 'EMP001',
      'employeeName': 'John Doe',
      'trainingId': 1,
      'trainingTitle': 'Introduction to Company Policies',
      'assessmentType': 'Multiple Choice Quiz',
      'totalQuestions': 15,
      'correctAnswers': 14,
      'score': 95,
      'passed': true,
      'attempt': 1,
      'startTime': '2024-02-10 14:30:00',
      'endTime': '2024-02-10 14:55:00',
      'timeSpent': '25 minutes',
      'submittedDate': '2024-02-10',
      'questionResults': [
        {'questionId': 1, 'question': 'What is the company mission?', 'correct': true, 'userAnswer': 'A', 'correctAnswer': 'A'},
        {'questionId': 2, 'question': 'What is the dress code policy?', 'correct': true, 'userAnswer': 'B', 'correctAnswer': 'B'},
        {'questionId': 3, 'question': 'When was the company founded?', 'correct': false, 'userAnswer': 'C', 'correctAnswer': 'B'},
        // ... more questions
      ],
      'feedback': 'Excellent understanding of company policies. Strong performance across all areas.',
      'improvementAreas': ['Company history'],
      'certificate': 'CERT_POL_001_2024',
    },
    {
      'id': 'ASSESS002',
      'employeeId': 'EMP002',
      'employeeName': 'Jane Smith',
      'trainingId': 2,
      'trainingTitle': 'Workplace Safety Training',
      'assessmentType': 'Practical Assessment',
      'totalQuestions': 20,
      'correctAnswers': 19,
      'score': 94,
      'passed': true,
      'attempt': 1,
      'startTime': '2024-02-05 10:00:00',
      'endTime': '2024-02-05 10:30:00',
      'timeSpent': '30 minutes',
      'submittedDate': '2024-02-05',
      'questionResults': [
        {'questionId': 1, 'question': 'Identify fire exit routes', 'correct': true, 'userAnswer': 'Correctly identified all routes', 'correctAnswer': 'All routes identified'},
        {'questionId': 2, 'question': 'Use fire extinguisher properly', 'correct': true, 'userAnswer': 'PASS technique applied', 'correctAnswer': 'PASS technique'},
        // ... more practical tasks
      ],
      'feedback': 'Outstanding practical demonstration of safety procedures. Excellent attention to detail.',
      'improvementAreas': ['Emergency communication'],
      'certificate': 'CERT_SAF_002_2024',
    },
    {
      'id': 'ASSESS003',
      'employeeId': 'EMP003',
      'employeeName': 'Mike Johnson',
      'trainingId': 4,
      'trainingTitle': 'Cybersecurity Basics',
      'assessmentType': 'Interactive Simulation',
      'totalQuestions': 18,
      'correctAnswers': 12,
      'score': 65,
      'passed': false,
      'attempt': 1,
      'startTime': '2024-03-08 15:00:00',
      'endTime': '2024-03-08 15:42:00',
      'timeSpent': '42 minutes',
      'submittedDate': '2024-03-08',
      'questionResults': [
        {'questionId': 1, 'question': 'Identify phishing email', 'correct': false, 'userAnswer': 'Legitimate', 'correctAnswer': 'Phishing'},
        {'questionId': 2, 'question': 'Create strong password', 'correct': true, 'userAnswer': 'P@ssw0rd123!', 'correctAnswer': 'Strong password'},
        // ... more simulation tasks
      ],
      'feedback': 'Needs improvement in recognizing social engineering attacks. Good understanding of password security.',
      'improvementAreas': ['Phishing detection', 'Social engineering awareness', 'Email security'],
      'certificate': null,
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
                        onTap: () {
                          _showActivityDetails(activities[index]);
                        },
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
      child: InkWell(
        onTap: () {
          _showSummaryDetails(title, value);
        },
        borderRadius: BorderRadius.circular(12),
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
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
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
                  _showAddModuleDialog();
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
            itemCount: _getFilteredModules().length,
            itemBuilder: (context, index) {
              final module = _getFilteredModules()[index];
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
                          Flexible(
                            child: Text(module['duration'], style: TextStyle(color: Colors.grey[600])),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.people, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text('${module['completedEmployees']}/${module['totalEmployees']}', 
                                 style: TextStyle(color: Colors.grey[600])),
                          ),
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
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _showModuleAnalytics(module);
                                },
                                icon: const Icon(Icons.analytics, size: 16),
                                label: const Text('Analytics'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _showEditModuleDialog(module);
                                },
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('Edit'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _sendTrainingReminders(module);
                                },
                                icon: const Icon(Icons.notifications, size: 16),
                                label: const Text('Remind'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            onChanged: (value) {
              setState(() {
                _employeeSearchQuery = value;
              });
            },
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
            itemCount: _getFilteredEmployees().length,
            itemBuilder: (context, index) {
              final employee = _getFilteredEmployees()[index];
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
                    _showEmployeeDetails(employee);
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
          // Report Generation - Expanded Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics, size: 28, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Generate Comprehensive Reports',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Export detailed analytics and insights about your training programs',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Primary Reports Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildReportCard(
                          'Completion Report',
                          'Detailed completion statistics',
                          Icons.assignment_turned_in,
                          Colors.green,
                          () => _generateCompletionReport(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildReportCard(
                          'Department Analysis',
                          'Performance by department',
                          Icons.business,
                          Colors.blue,
                          () => _generateDepartmentReport(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Secondary Reports Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildReportCard(
                          'Overdue Training',
                          'Employees needing attention',
                          Icons.warning,
                          Colors.orange,
                          () => _generateOverdueReport(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildReportCard(
                          'Export to Excel',
                          'Complete data export',
                          Icons.file_download,
                          Colors.purple,
                          () => _exportToExcel(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Additional Reports Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildReportCard(
                          'Performance Metrics',
                          'Scores and completion times',
                          Icons.trending_up,
                          Colors.teal,
                          () => _generatePerformanceReport(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildReportCard(
                          'Monthly Summary',
                          'Training activity overview',
                          Icons.calendar_month,
                          Colors.indigo,
                          () => _generateMonthlySummary(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Real-time Analytics Dashboard
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dashboard, size: 28, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Real-time Analytics Dashboard',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Department Completion Rates with Enhanced UI
                  Text(
                    'Department Completion Rates',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ...[
                    {'dept': 'IT Department', 'rate': 95, 'employees': 25, 'trend': '+5%'},
                    {'dept': 'HR Department', 'rate': 88, 'employees': 12, 'trend': '+2%'},
                    {'dept': 'Finance Department', 'rate': 72, 'employees': 18, 'trend': '-3%'},
                    {'dept': 'Marketing Department', 'rate': 65, 'employees': 22, 'trend': '+8%'},
                    {'dept': 'Operations Department', 'rate': 78, 'employees': 30, 'trend': '+1%'},
                    {'dept': 'Sales Department', 'rate': 82, 'employees': 35, 'trend': '+4%'},
                  ].map((dept) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                dept['dept'].toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (dept['trend'].toString().startsWith('+') ? Colors.green : Colors.red).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                dept['trend'].toString(),
                                style: TextStyle(
                                  color: dept['trend'].toString().startsWith('+') ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value: (dept['rate'] as int) / 100,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      (dept['rate'] as int) >= 80 ? Colors.green : 
                                      (dept['rate'] as int) >= 60 ? Colors.orange : Colors.red,
                                    ),
                                    minHeight: 8,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${dept['employees']} employees',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${dept['rate']}%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: (dept['rate'] as int) >= 80 ? Colors.green : 
                                       (dept['rate'] as int) >= 60 ? Colors.orange : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Training Insights
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.insights, size: 28, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Training Insights & Recommendations',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Insight Cards
                  ...[
                    {
                      'title': 'Top Performing Module',
                      'content': 'Workplace Safety Training has 92% completion rate',
                      'icon': Icons.star,
                      'color': Colors.green,
                    },
                    {
                      'title': 'Needs Attention',
                      'content': 'Cybersecurity Basics requires improvement (65% completion)',
                      'icon': Icons.warning,
                      'color': Colors.orange,
                    },
                    {
                      'title': 'Recommendation',
                      'content': 'Consider shorter modules for better engagement',
                      'icon': Icons.lightbulb,
                      'color': Colors.blue,
                    },
                  ].map((insight) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (insight['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: (insight['color'] as Color).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          insight['icon'] as IconData,
                          color: insight['color'] as Color,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                insight['title'].toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                insight['content'].toString(),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
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
        // Custom Horizontal Tab Selection - Fixed
        Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              final tabData = [
                {'icon': Icons.dashboard, 'text': 'Overview'},
                {'icon': Icons.school, 'text': 'Modules'},
                {'icon': Icons.people, 'text': 'Employees'},
                {'icon': Icons.analytics, 'text': 'Reports'},
                {'icon': Icons.quiz, 'text': 'Assessments'},
              ];
              
              final bool isSelected = _selectedTabIndex == index;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = index;
                    _tabController.animateTo(index);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? colorScheme.primary 
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected 
                          ? colorScheme.primary 
                          : Colors.grey.shade300,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tabData[index]['icon'] as IconData,
                        size: 18,
                        color: isSelected 
                            ? Colors.white 
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tabData[index]['text'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? Colors.white 
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Tab Content - Synchronized with tab selection
        Expanded(
          child: IndexedStack(
            index: _selectedTabIndex,
            children: [
              _buildOverviewTab(),
              _buildModulesTab(),
              _buildEmployeeProgressTab(),
              _buildReportsTab(),
              _buildAssessmentTab(),
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

  // Helper methods for functionality
  List<Map<String, dynamic>> _getFilteredModules() {
    if (_searchQuery.isEmpty) {
      return _trainingModules;
    }
    return _trainingModules.where((module) {
      return module['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
             module['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildReportCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredEmployees() {
    if (_employeeSearchQuery.isEmpty) {
      return _employeeProgress;
    }
    return _employeeProgress.where((employee) {
      return employee['name'].toString().toLowerCase().contains(_employeeSearchQuery.toLowerCase()) ||
             employee['department'].toString().toLowerCase().contains(_employeeSearchQuery.toLowerCase()) ||
             employee['employeeId'].toString().toLowerCase().contains(_employeeSearchQuery.toLowerCase());
    }).toList();
  }

  void _showActivityDetails(String activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity),
            const SizedBox(height: 16),
            const Text('This activity shows recent training progress updates from employees.'),
          ],
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

  void _showSummaryDetails(String title, String value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Value: $value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (title == 'Total Modules')
              const Text('This shows the total number of training modules available in the system.')
            else if (title == 'Avg. Completion')
              const Text('This shows the average completion rate across all training modules.')
            else if (title == 'Total Employees')
              const Text('This shows the total number of employees in the training system.')
            else if (title == 'Active Modules')
              const Text('This shows the number of currently active training modules.'),
          ],
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

  void _showAddModuleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Training Module'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Module Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Duration (hours)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Training module created successfully!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showModuleAnalytics(Map<String, dynamic> module) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Analytics: ${module['title']}'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Completion Rate: ${module['completionRate']}%'),
              const SizedBox(height: 8),
              Text('Completed: ${module['completedEmployees']}/${module['totalEmployees']} employees'),
              const SizedBox(height: 8),
              Text('Duration: ${module['duration']}'),
              const SizedBox(height: 8),
              Text('Status: ${module['status']}'),
              const SizedBox(height: 16),
              const Text('Performance Metrics:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('• Average score: ${85 + (module['id'] * 2)}%'),
              Text('• Time to complete: ${module['duration']}'),
              Text('• Satisfaction rating: ${4.2 + (module['id'] * 0.1)}/5.0'),
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

  void _showEditModuleDialog(Map<String, dynamic> module) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Training Module'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Module Title',
                border: const OutlineInputBorder(),
                hintText: module['title'],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: const OutlineInputBorder(),
                hintText: module['description'],
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Duration',
                border: const OutlineInputBorder(),
                hintText: module['duration'],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${module['title']} updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _sendTrainingReminders(Map<String, dynamic> module) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Reminders'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send reminder for: ${module['title']}'),
            const SizedBox(height: 16),
            const Text('Who should receive reminders?'),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Employees who haven\'t started'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Employees in progress'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('All enrolled employees'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reminders sent for ${module['title']}!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showEmployeeDetails(Map<String, dynamic> employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${employee['name']} - Training Details'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Department: ${employee['department']}'),
              Text('Employee ID: ${employee['employeeId']}'),
              Text('Overall Progress: ${employee['completionRate']}%'),
              Text('Last Activity: ${employee['lastActivity']}'),
              const SizedBox(height: 16),
              const Text('Training Status:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: employee['trainings'].length,
                  itemBuilder: (context, index) {
                    final training = employee['trainings'][index];
                    return Card(
                      child: ListTile(
                        title: Text(training['name']),
                        subtitle: Text(training['status']),
                        trailing: training['score'] != null 
                          ? Text('${training['score']}%', style: const TextStyle(fontWeight: FontWeight.bold))
                          : null,
                        leading: Icon(
                          training['status'] == 'Completed' ? Icons.check_circle : 
                          training['status'] == 'In Progress' ? Icons.schedule : Icons.radio_button_unchecked,
                          color: training['status'] == 'Completed' ? Colors.green : 
                                 training['status'] == 'In Progress' ? Colors.orange : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reminder sent to ${employee['name']}')),
              );
            },
            child: const Text('Send Reminder'),
          ),
        ],
      ),
    );
  }

  void _generateCompletionReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Completion Report'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Training Completion Summary', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: _trainingModules.map((module) => ListTile(
                    title: Text(module['title']),
                    subtitle: Text('${module['completedEmployees']}/${module['totalEmployees']} completed'),
                    trailing: Text('${module['completionRate']}%'),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Completion report downloaded!')),
              );
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _generateDepartmentReport() {
    final departments = ['IT', 'HR', 'Finance', 'Marketing', 'Operations'];
    final rates = [95, 88, 72, 65, 78];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Department Analysis'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Department Performance', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: departments.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(departments[index]),
                    subtitle: LinearProgressIndicator(value: rates[index] / 100),
                    trailing: Text('${rates[index]}%'),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Department analysis downloaded!')),
              );
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _generateOverdueReport() {
    final overdueEmployees = _employeeProgress.where((emp) => emp['completionRate'] < 80).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Overdue Training Report'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${overdueEmployees.length} employees need attention', 
                   style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: overdueEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = overdueEmployees[index];
                    return ListTile(
                      title: Text(employee['name']),
                      subtitle: Text('${employee['department']} • ${employee['completionRate']}% complete'),
                      trailing: Icon(
                        Icons.warning,
                        color: employee['completionRate'] < 50 ? Colors.red : Colors.orange,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Overdue report downloaded!')),
              );
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _exportToExcel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export to Excel'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select data to export:'),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Training Modules'),
              value: true,
              onChanged: null,
            ),
            CheckboxListTile(
              title: Text('Employee Progress'),
              value: true,
              onChanged: null,
            ),
            CheckboxListTile(
              title: Text('Completion Statistics'),
              value: true,
              onChanged: null,
            ),
            CheckboxListTile(
              title: Text('Department Analysis'),
              value: false,
              onChanged: null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Excel file exported successfully!')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _generatePerformanceReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Performance Metrics Report'),
        content: SizedBox(
          width: double.maxFinite,
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Training Performance Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildMetricRow('Average Completion Time', '2.3 hours'),
                    _buildMetricRow('Average Score', '87.5%'),
                    _buildMetricRow('Success Rate', '94.2%'),
                    _buildMetricRow('Employee Satisfaction', '4.3/5.0'),
                    _buildMetricRow('Most Popular Module', 'Workplace Safety'),
                    _buildMetricRow('Fastest Completion', '1.2 hours'),
                    _buildMetricRow('Highest Scoring Module', 'Company Policies (91%)'),
                    const Divider(),
                    const Text('Trends:', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildMetricRow('Completion Rate Trend', '+12% this month'),
                    _buildMetricRow('Engagement Trend', '+8% this quarter'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Performance report downloaded!')),
              );
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _generateMonthlySummary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Monthly Training Summary'),
        content: SizedBox(
          width: double.maxFinite,
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('August 2025 Training Activity', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildMonthlySummaryCard('Total Completions', '47'),
                    _buildMonthlySummaryCard('New Enrollments', '23'),
                    _buildMonthlySummaryCard('Modules Launched', '2'),
                    _buildMonthlySummaryCard('Average Score', '89.2%'),
                    _buildMonthlySummaryCard('Training Hours', '156 hours'),
                    _buildMonthlySummaryCard('Certificates Issued', '41'),
                    const Divider(),
                    const Text('Department Highlights:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('• IT Department: 100% completion rate'),
                    const Text('• HR Department: Highest engagement'),
                    const Text('• Sales: Most improved department'),
                    const Text('• Marketing: Fastest average completion'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Monthly summary downloaded!')),
              );
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMonthlySummaryCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentTab() {
    List<Map<String, dynamic>> filteredResults = _assessmentResults
        .where((result) => 
            result['employeeName'].toString().toLowerCase().contains(_assessmentSearchQuery.toLowerCase()) ||
            result['trainingTitle'].toString().toLowerCase().contains(_assessmentSearchQuery.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar with Compact Download Button
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search assessments...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _assessmentSearchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _exportToExcel,
                    icon: const Icon(Icons.download, color: Colors.white, size: 20),
                    tooltip: 'Export Results',
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),

          // Assessment Results Header
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.assessment, color: Colors.blue.shade700, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Assessment Results (${filteredResults.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Assessment Results List - Expanded and Less Crowded
          Expanded(
            child: filteredResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            Icons.assessment_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No assessment results found',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search criteria',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final result = filteredResults[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => _showAssessmentDetails(result),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with Employee Info and Score
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.blue.shade100,
                                      child: Text(
                                        result['employeeName'].toString().split(' ').map((e) => e[0]).take(2).join(),
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            result['employeeName'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            result['trainingTitle'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: result['passed'] ? Colors.green.shade50 : Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: result['passed'] ? Colors.green.shade300 : Colors.red.shade300,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            result['passed'] ? Icons.check_circle : Icons.cancel,
                                            color: result['passed'] ? Colors.green.shade700 : Colors.red.shade700,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${result['score']}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: result['passed'] ? Colors.green.shade700 : Colors.red.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                
                                // Assessment Details Grid
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildMobileDetailItem(
                                        Icons.quiz,
                                        'Questions',
                                        '${result['correctAnswers']}/${result['totalQuestions']}',
                                        Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildMobileDetailItem(
                                        Icons.access_time,
                                        'Time Spent',
                                        result['timeSpent'],
                                        Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildMobileDetailItem(
                                        Icons.repeat,
                                        'Attempt',
                                        '#${result['attempt']}',
                                        Colors.purple,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildMobileDetailItem(
                                        Icons.calendar_today,
                                        'Date',
                                        result['submittedDate'],
                                        Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                
                                // Action Button - Full Width
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _showAssessmentDetails(result),
                                    icon: const Icon(Icons.visibility, size: 18),
                                    label: const Text(
                                      'View Details',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade600,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAssessmentDetails(Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 600,
            height: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.quiz, color: Colors.blue.shade700, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assessment Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          Text(
                            result['trainingTitle'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Assessment Summary
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailItem('Employee', result['employeeName']),
                                  ),
                                  Expanded(
                                    child: _buildDetailItem('Score', '${result['score']}%'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailItem('Result', result['passed'] ? 'PASSED' : 'FAILED'),
                                  ),
                                  Expanded(
                                    child: _buildDetailItem('Time Spent', result['timeSpent']),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDetailItem('Questions', '${result['correctAnswers']}/${result['totalQuestions']} correct'),
                                  ),
                                  Expanded(
                                    child: _buildDetailItem('Date', result['submittedDate']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Feedback Section
                        if (result['feedback'] != null) ...[
                          Text(
                            'Feedback',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Text(result['feedback']),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Improvement Areas
                        if (result['improvementAreas'] != null && result['improvementAreas'].isNotEmpty) ...[
                          Text(
                            'Areas for Improvement',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...result['improvementAreas'].map<Widget>((area) => 
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_right, color: Colors.orange.shade600, size: 16),
                                  const SizedBox(width: 8),
                                  Text(area),
                                ],
                              ),
                            ),
                          ).toList(),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (result['certificate'] != null)
                      ElevatedButton.icon(
                        onPressed: () {
                          // Download certificate
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download Certificate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileDetailItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
