import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'user_quiz_page.dart';
import 'user_learning_page.dart';
import 'module_quiz_page.dart';
import 'module_learning_page.dart';

class TrainingPage extends StatefulWidget {
  final bool showAppBar;

  const TrainingPage({super.key, this.showAppBar = true});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

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

  // Training modules data from admin side (matching training_management_page.dart structure)
  final List<Map<String, dynamic>> _trainingModules = [
    {
      'id': 1,
      'title': 'Introduction to Company Policies',
      'description': 'Essential company policies and procedures',
      'duration': '2 hours',
      'status': 'Active',
      'content': 'This comprehensive training covers all essential company policies including code of conduct, workplace ethics, communication guidelines, and compliance requirements.',
      'objectives': ['Understand company values', 'Learn code of conduct', 'Know compliance requirements'],
      'hasQuiz': true,
      'passingScore': 80,
      'quizQuestions': 15,
      'assessmentType': 'Multiple Choice Quiz',
      'isCompleted': true,
      'userScore': 95,
      'completedDate': '2024-08-15',
      'progress': 100,
      'icon': Icons.policy,
      'color': Colors.blue,
    },
    {
      'id': 2,
      'title': 'Workplace Safety Training',
      'description': 'Safety protocols and emergency procedures',
      'duration': '3 hours',
      'status': 'Active',
      'content': 'Comprehensive safety training covering fire safety, emergency evacuation procedures, first aid basics, and workplace hazard identification.',
      'objectives': ['Fire safety protocols', 'Emergency procedures', 'First aid basics'],
      'hasQuiz': true,
      'passingScore': 85,
      'quizQuestions': 20,
      'assessmentType': 'Practical Assessment',
      'isCompleted': true,
      'userScore': 88,
      'completedDate': '2024-08-18',
      'progress': 100,
      'icon': Icons.security,
      'color': Colors.red,
    },
    {
      'id': 3,
      'title': 'Diversity and Inclusion',
      'description': 'Building an inclusive workplace culture',
      'duration': '1.5 hours',
      'status': 'Active',
      'content': 'Learn about creating an inclusive workplace, understanding unconscious bias, and promoting diversity in all aspects of work.',
      'objectives': ['Understand unconscious bias', 'Promote inclusion', 'Respect diversity'],
      'hasQuiz': true,
      'passingScore': 75,
      'quizQuestions': 12,
      'assessmentType': 'Scenario-Based Quiz',
      'isCompleted': false,
      'userScore': null,
      'completedDate': null,
      'progress': 60,
      'icon': Icons.diversity_3,
      'color': Colors.purple,
    },
    {
      'id': 4,
      'title': 'Cybersecurity Basics',
      'description': 'Digital security best practices',
      'duration': '2.5 hours',
      'status': 'Active',
      'content': 'Essential cybersecurity training covering password security, phishing awareness, data protection, and secure communication practices.',
      'objectives': ['Password security', 'Phishing awareness', 'Data protection'],
      'hasQuiz': true,
      'passingScore': 80,
      'quizQuestions': 18,
      'assessmentType': 'Interactive Simulation',
      'isCompleted': false,
      'userScore': null,
      'completedDate': null,
      'progress': 0,
      'icon': Icons.security,
      'color': Colors.orange,
    },
    {
      'id': 5,
      'title': 'Customer Service Excellence',
      'description': 'Delivering exceptional customer experiences',
      'duration': '2 hours',
      'status': 'Active',
      'content': 'Learn advanced customer service techniques, conflict resolution, and building lasting customer relationships.',
      'objectives': ['Customer communication', 'Conflict resolution', 'Service excellence'],
      'hasQuiz': true,
      'passingScore': 80,
      'quizQuestions': 16,
      'assessmentType': 'Role-Play Assessment',
      'isCompleted': false,
      'userScore': null,
      'completedDate': null,
      'progress': 0,
      'icon': Icons.support_agent,
      'color': Colors.green,
    },
  ];

  // User's training progress summary
  Map<String, dynamic> get _userProgress {
    int completedModules = _trainingModules.where((m) => m['isCompleted'] == true).length;
    int totalModules = _trainingModules.length;
    double averageScore = _trainingModules
        .where((m) => m['userScore'] != null)
        .map((m) => m['userScore'] as int)
        .fold(0, (a, b) => a + b) / 
        _trainingModules.where((m) => m['userScore'] != null).length;
    
    return {
      'completedModules': completedModules,
      'totalModules': totalModules,
      'completionRate': (completedModules / totalModules * 100).round(),
      'averageScore': averageScore.isNaN ? 0 : averageScore.round(),
      'certificatesEarned': completedModules,
    };
  }

  // Navigate to module-specific quiz
  void _navigateToModuleQuiz(BuildContext context, Map<String, dynamic> module) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModuleQuizPage(module: module),
      ),
    );
    
    // If quiz is completed successfully, update module status
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final moduleIndex = _trainingModules.indexWhere((m) => m['id'] == module['id']);
        if (moduleIndex != -1) {
          _trainingModules[moduleIndex]['isCompleted'] = true;
          _trainingModules[moduleIndex]['userScore'] = result['score'];
          _trainingModules[moduleIndex]['completedDate'] = DateTime.now().toString().substring(0, 10);
          _trainingModules[moduleIndex]['progress'] = 100;
        }
      });
      
      // Show completion notification
      if (result['passed'] == true) {
        _showCertificateEarnedDialog(module, result['score']);
      }
    }
  }

  void _showCertificateEarnedDialog(Map<String, dynamic> module, int score) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber),
            const SizedBox(width: 8),
            const Text('Certificate Earned!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration,
              size: 64,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have successfully completed ${module['title']} with a score of $score%!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.file_download, color: Colors.green),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Your certificate is now available for download in the Certificates tab.',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadCertificate(module);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Download Certificate'),
          ),
        ],
      ),
    );
  }

  // Navigate to module content/learning
  void _navigateToModuleLearning(BuildContext context, Map<String, dynamic> module) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModuleLearningPage(module: module),
      ),
    );
    
    // If learning is completed, update progress and potentially navigate to quiz
    if (result == true) {
      setState(() {
        // Update module progress to 100% when learning is completed
        final moduleIndex = _trainingModules.indexWhere((m) => m['id'] == module['id']);
        if (moduleIndex != -1) {
          _trainingModules[moduleIndex]['progress'] = 100;
        }
      });
      
      // If module has quiz, show option to take it
      if (module['hasQuiz'] == true) {
        _showQuizPrompt(module);
      }
    }
  }

  void _showQuizPrompt(Map<String, dynamic> module) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.quiz, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Ready for Quiz?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.school,
              size: 48,
              color: module['color'],
            ),
            const SizedBox(height: 16),
            Text(
              'You\'ve completed the ${module['title']} learning module!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Would you like to take the quiz now to test your knowledge and earn your certificate?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Quiz: ${module['quizQuestions']} questions\nPassing score: ${module['passingScore']}%',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToModuleQuiz(context, module);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Take Quiz'),
          ),
        ],
      ),
    );
  }

  // Navigate to general quiz (legacy)
  void navigateToQuiz(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserQuizPage()),
    );
  }

  // Navigate to general learning (legacy)
  void navigateToLearning(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserLearningPage()),
    );
  }

  Widget _buildOverviewTab() {
    final progress = _userProgress;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Completed',
                  '${progress['completedModules']}/${progress['totalModules']}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Progress',
                  '${progress['completionRate']}%',
                  Icons.trending_up,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Avg Score',
                  '${progress['averageScore']}%',
                  Icons.grade,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Certificates',
                  '${progress['certificatesEarned']}',
                  Icons.emoji_events,
                  Colors.purple,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  'Continue Learning',
                  'Resume your training',
                  Icons.play_circle_fill,
                  Colors.green,
                  () => _continueTraining(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'View Certificates',
                  'Download achievements',
                  Icons.file_download,
                  Colors.blue,
                  () => _viewCertificates(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
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
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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

  List<Widget> _buildRecentActivity() {
    final recentActivities = _trainingModules
        .where((m) => m['completedDate'] != null)
        .take(3)
        .map((module) => _buildActivityItem(
              '${module['title']} completed',
              'Score: ${module['userScore']}%',
              module['completedDate'],
              Icons.check_circle,
              Colors.green,
            ))
        .toList();

    if (recentActivities.isEmpty) {
      return [
        Center(
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'No recent activity',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ];
    }

    return recentActivities;
  }

  Widget _buildActivityItem(String title, String subtitle, String date, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('$subtitle • $date'),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildModulesTab() {
    final activeModules = _trainingModules.where((m) => m['status'] == 'Active').toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeModules.length,
      itemBuilder: (context, index) {
        final module = activeModules[index];
        return _buildModuleCard(module);
      },
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    final bool isCompleted = module['isCompleted'] ?? false;
    final int progress = module['progress'] ?? 0;
    final Color moduleColor = module['color'] ?? Colors.blue;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showModuleDetails(module),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: moduleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      module['icon'] ?? Icons.school,
                      color: moduleColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          module['description'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        '$progress%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: moduleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(moduleColor),
                    minHeight: 6,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Module Info
              Row(
                children: [
                  _buildInfoChip(Icons.access_time, module['duration'], Colors.blue),
                  const SizedBox(width: 12),
                  if (module['hasQuiz'] == true)
                    _buildInfoChip(Icons.quiz, '${module['quizQuestions']} Questions', Colors.orange),
                  const SizedBox(width: 12),
                  if (isCompleted && module['userScore'] != null)
                    _buildInfoChip(Icons.grade, '${module['userScore']}%', Colors.green),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToModuleLearning(context, module),
                      icon: Icon(
                        isCompleted ? Icons.replay : Icons.play_arrow,
                        size: 16,
                      ),
                      label: Text(
                        isCompleted ? 'Review' : 'Start Learning',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  if (module['hasQuiz'] == true) ...[
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToModuleQuiz(context, module),
                        icon: const Icon(Icons.quiz, size: 16),
                        label: const Text(
                          'Quiz',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (isCompleted && module['userScore'] != null && module['userScore'] >= (module['passingScore'] ?? 80)) ...[
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _downloadCertificate(module),
                        icon: const Icon(Icons.file_download, size: 16),
                        label: const Text(
                          'Download',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificatesTab() {
    final completedModules = _trainingModules.where((m) => m['isCompleted'] == true).toList();
    
    if (completedModules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Certificates Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete training modules to earn certificates',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedModules.length,
      itemBuilder: (context, index) {
        final module = completedModules[index];
        return _buildCertificateCard(module);
      },
    );
  }

  Widget _buildCertificateCard(Map<String, dynamic> module) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              module['color'].withOpacity(0.1),
              module['color'].withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Certificate of Completion',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                        Text(
                          module['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.grade, color: module['color'], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Score: ${module['userScore']}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: module['color'],
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Completed: ${module['completedDate']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadCertificate(module),
                      icon: const Icon(Icons.file_download, size: 16),
                      label: const Text(
                        'Download',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _shareCertificate(module),
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text(
                        'Share',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
              Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
              Tab(text: 'Modules', icon: Icon(Icons.school)),
              Tab(text: 'Certificates', icon: Icon(Icons.emoji_events)),
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
              _buildOverviewTab(),
              _buildModulesTab(),
              _buildCertificatesTab(),
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
            const Text('Training Portal'),
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

  // Helper methods
  void _continueTraining() {
    final nextModule = _trainingModules.firstWhere(
      (m) => m['isCompleted'] == false && m['status'] == 'Active',
      orElse: () => _trainingModules.first,
    );
    _navigateToModuleLearning(context, nextModule);
  }

  void _viewCertificates() {
    setState(() {
      _selectedTabIndex = 2;
      _tabController.animateTo(2);
    });
  }

  void _showModuleDetails(Map<String, dynamic> module) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(module['title']),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(module['description']),
              const SizedBox(height: 16),
              
              Text(
                'Content',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(module['content']),
              const SizedBox(height: 16),
              
              Text(
                'Learning Objectives',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              ...module['objectives'].map<Widget>(
                (objective) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, 
                           color: module['color'], 
                           size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(objective)),
                    ],
                  ),
                ),
              ).toList(),
              
              if (module['hasQuiz'] == true) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.quiz, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Includes ${module['quizQuestions']} question quiz\nPassing score: ${module['passingScore']}%',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              _navigateToModuleLearning(context, module);
            },
            child: const Text('Start Learning'),
          ),
        ],
      ),
    );
  }

  void _downloadCertificate(Map<String, dynamic> module) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.file_download, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Download Certificate'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.green.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.emoji_events, size: 48, color: Colors.amber),
                  const SizedBox(height: 12),
                  Text(
                    'Certificate of Completion',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    module['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Score: ${module['userScore']}%',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Completed: ${module['completedDate']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose download format:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _downloadPDF(module);
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    label: const Text('PDF'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _downloadImage(module);
                    },
                    icon: const Icon(Icons.image, color: Colors.blue),
                    label: const Text('Image'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _shareCertificate(module);
            },
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadPDF(Map<String, dynamic> module) async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Generating PDF certificate for ${module['title']}...'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );

      // Request storage permission
      await _requestStoragePermission();

      // Create PDF document
      final pdf = pw.Document();
      
      // ===== PDF CONTENT CUSTOMIZATION SECTION =====
      // You can modify the PDF certificate design and content below:
      // - Change colors, fonts, sizes, layout
      // - Add/remove sections, logos, images
      // - Modify text content and styling
      // - Adjust borders, spacing, and positioning
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blue, width: 3), // CUSTOMIZE: Border color and width
              ),
              padding: const pw.EdgeInsets.all(40), // CUSTOMIZE: Page margins
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  // CUSTOMIZE: Certificate trophy/logo section
                  pw.Container(
                    padding: const pw.EdgeInsets.all(20),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.amber50, // CUSTOMIZE: Background color
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Text(
                      '🏆', // CUSTOMIZE: Replace with company logo or different icon
                      style: pw.TextStyle(fontSize: 48),
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  // CUSTOMIZE: Main certificate title
                  pw.Text(
                    'CERTIFICATE OF COMPLETION', // CUSTOMIZE: Main title text
                    style: pw.TextStyle(
                      fontSize: 24, // CUSTOMIZE: Title font size
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900, // CUSTOMIZE: Title color
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  // CUSTOMIZE: Module/Course name section
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 20),
                    child: pw.Text(
                      module['title'], // CUSTOMIZE: Course/module title display
                      style: pw.TextStyle(
                        fontSize: 20, // CUSTOMIZE: Module title font size
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  // CUSTOMIZE: Certificate description text
                  pw.Text(
                    'This certifies that the recipient has successfully completed the training module', // CUSTOMIZE: Description text
                    style: pw.TextStyle(fontSize: 14), // CUSTOMIZE: Description font size
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 30),
                  // CUSTOMIZE: Score, Date, Duration section - you can add/remove fields here
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      // CUSTOMIZE: Score display section
                      pw.Column(
                        children: [
                          pw.Text(
                            'Score Achieved', // CUSTOMIZE: Score label text
                            style: pw.TextStyle(
                              fontSize: 12, // CUSTOMIZE: Label font size
                              color: PdfColors.grey700, // CUSTOMIZE: Label color
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            '${module['userScore']}%', // CUSTOMIZE: Score value display
                            style: pw.TextStyle(
                              fontSize: 18, // CUSTOMIZE: Score font size
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green, // CUSTOMIZE: Score color
                            ),
                          ),
                        ],
                      ),
                      // CUSTOMIZE: Date display section
                      pw.Column(
                        children: [
                          pw.Text(
                            'Date Completed', // CUSTOMIZE: Date label text
                            style: pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            module['completedDate'], // CUSTOMIZE: Date value display
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // CUSTOMIZE: Duration display section
                      pw.Column(
                        children: [
                          pw.Text(
                            'Duration', // CUSTOMIZE: Duration label text
                            style: pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            module['duration'], // CUSTOMIZE: Duration value display
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 40),
                  // CUSTOMIZE: Footer/Company section
                  pw.Text(
                    'Kelin HRIS Training Portal', // CUSTOMIZE: Company/footer text
                    style: pw.TextStyle(
                      fontSize: 14, // CUSTOMIZE: Footer font size
                      color: PdfColors.grey600, // CUSTOMIZE: Footer color
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  // CUSTOMIZE: Generated timestamp section
                  pw.Text(
                    'Generated on ${DateTime.now().toString().substring(0, 19)}', // CUSTOMIZE: Timestamp format and text
                    style: pw.TextStyle(
                      fontSize: 10, // CUSTOMIZE: Timestamp font size
                      color: PdfColors.grey500, // CUSTOMIZE: Timestamp color
                    ),
                  ),
                  // ===== END OF PDF CONTENT CUSTOMIZATION SECTION =====
                ],
              ),
            );
          },
        ),
      );

      // Get directory to save file
      final directory = await _getDownloadDirectory();
      final fileName = 'Certificate_${module['title'].replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory!.path}/$fileName');

      // Save PDF
      await file.writeAsBytes(await pdf.save());

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('PDF certificate saved to Downloads/$fileName'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                _showCertificatePreview(module, 'PDF');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Error creating PDF: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _downloadImage(Map<String, dynamic> module) async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Generating image certificate for ${module['title']}...'),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 5),
        ),
      );

      // Request storage permission
      await _requestStoragePermission();

      // Create a custom painter to draw the certificate
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = const Size(800, 600); // CUSTOMIZE: Image dimensions

      // ===== IMAGE CONTENT CUSTOMIZATION SECTION =====
      // You can modify the image certificate design and content below:
      // - Change colors, gradients, dimensions
      // - Modify text content, fonts, sizes, positions
      // - Add/remove visual elements, borders, shapes
      // - Adjust layout and spacing

      // CUSTOMIZE: Certificate background gradient
      final paint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE3F2FD), Color(0xFFE8F5E8)], // CUSTOMIZE: Background gradient colors
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

      // CUSTOMIZE: Outer border design
      final borderPaint = Paint()
        ..color = Colors.blue // CUSTOMIZE: Border color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8; // CUSTOMIZE: Border thickness
      canvas.drawRect(
        Rect.fromLTWH(20, 20, size.width - 40, size.height - 40), // CUSTOMIZE: Border position
        borderPaint,
      );

      // CUSTOMIZE: Inner border design
      final innerBorderPaint = Paint()
        ..color = Colors.blue.withOpacity(0.3) // CUSTOMIZE: Inner border color and opacity
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2; // CUSTOMIZE: Inner border thickness
      canvas.drawRect(
        Rect.fromLTWH(40, 40, size.width - 80, size.height - 80), // CUSTOMIZE: Inner border position
        innerBorderPaint,
      );

      // Draw text content
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
      );

      // CUSTOMIZE: Main certificate title
      textPainter.text = TextSpan(
        text: 'CERTIFICATE OF COMPLETION', // CUSTOMIZE: Main title text
        style: TextStyle(
          fontSize: 28, // CUSTOMIZE: Title font size
          fontWeight: FontWeight.bold,
          color: Colors.blue[900], // CUSTOMIZE: Title color
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, 100), // CUSTOMIZE: Title position (x, y)
      );

      // CUSTOMIZE: Module/Course title
      textPainter.text = TextSpan(
        text: module['title'], // CUSTOMIZE: Module title display
        style: const TextStyle(
          fontSize: 24, // CUSTOMIZE: Module title font size
          fontWeight: FontWeight.bold,
          color: Colors.black87, // CUSTOMIZE: Module title color
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, 180), // CUSTOMIZE: Module title position
      );

      // CUSTOMIZE: Certificate description
      textPainter.text = const TextSpan(
        text: 'This certifies that the recipient has successfully\ncompleted the training module', // CUSTOMIZE: Description text
        style: TextStyle(
          fontSize: 16, // CUSTOMIZE: Description font size
          color: Colors.black87, // CUSTOMIZE: Description color
          height: 1.5, // CUSTOMIZE: Line height
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, 250), // CUSTOMIZE: Description position
      );

      // CUSTOMIZE: Score display
      textPainter.text = TextSpan(
        text: 'Score: ${module['userScore']}%', // CUSTOMIZE: Score text and format
        style: const TextStyle(
          fontSize: 20, // CUSTOMIZE: Score font size
          fontWeight: FontWeight.bold,
          color: Colors.green, // CUSTOMIZE: Score color
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, 350), // CUSTOMIZE: Score position
      );

      // CUSTOMIZE: Completion date display
      textPainter.text = TextSpan(
        text: 'Completed: ${module['completedDate']}', // CUSTOMIZE: Date text and format
        style: const TextStyle(
          fontSize: 16, // CUSTOMIZE: Date font size
          color: Colors.black87, // CUSTOMIZE: Date color
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, 400), // CUSTOMIZE: Date position
      );

      // CUSTOMIZE: Duration display
      textPainter.text = TextSpan(
        text: 'Duration: ${module['duration']}', // CUSTOMIZE: Duration text and format
        style: const TextStyle(
          fontSize: 16, // CUSTOMIZE: Duration font size
          color: Colors.black87, // CUSTOMIZE: Duration color
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, 430), // CUSTOMIZE: Duration position
      );

      // CUSTOMIZE: Footer/Company name
      textPainter.text = const TextSpan(
        text: 'Kelin HRIS Training Portal', // CUSTOMIZE: Footer text
        style: TextStyle(
          fontSize: 14, // CUSTOMIZE: Footer font size
          fontStyle: FontStyle.italic,
          color: Colors.grey, // CUSTOMIZE: Footer color
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset((size.width - textPainter.width) / 2, 500), // CUSTOMIZE: Footer position
      );

      // ===== END OF IMAGE CONTENT CUSTOMIZATION SECTION =====

      // Convert to image
      final picture = recorder.endRecording();
      final image = await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      // Get directory to save file
      final directory = await _getDownloadDirectory();
      final fileName = 'Certificate_${module['title'].replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory!.path}/$fileName');

      // Save image
      await file.writeAsBytes(bytes);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Image certificate saved to Downloads/$fileName'),
                ),
              ],
            ),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                _showCertificatePreview(module, 'Image');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Error creating image: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidInfo();
      if (androidInfo.version.sdkInt >= 30) {
        // For Android 11+ (API 30+), we don't need WRITE_EXTERNAL_STORAGE
        // Files are saved to app-specific directory or Downloads folder
        return;
      } else {
        // For older Android versions, request storage permission
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }
      }
    }
  }

  Future<dynamic> _getAndroidInfo() async {
    // Simple mock for Android info - in a real app you'd use device_info_plus
    return MockAndroidInfo();
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // Try to get the Downloads directory
      try {
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          return directory;
        }
      } catch (e) {
        // Fall back to external storage directory
      }
      
      // Fall back to external storage
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final downloadDir = Directory('${directory.path}/Download');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        return downloadDir;
      }
    }
    
    // Fall back to documents directory
    return await getApplicationDocumentsDirectory();
  }

  void _showCertificatePreview(Map<String, dynamic> module, String format) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Certificate Preview ($format)'),
        content: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.green.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue, width: 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 32, color: Colors.amber),
                const SizedBox(height: 8),
                Text(
                  'Certificate of Completion',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  module['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Score: ${module['userScore']}%',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Date: ${module['completedDate']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
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

  void _shareCertificate(Map<String, dynamic> module) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.share, color: Colors.blue),
            const SizedBox(width: 8),
            const Text('Share Certificate'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Share your achievement with others!',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Share via:'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.email, 'Email', Colors.red, () {
                  Navigator.pop(context);
                  _shareViaEmail(module);
                }),
                _buildShareOption(Icons.link, 'Link', Colors.blue, () {
                  Navigator.pop(context);
                  _shareViaLink(module);
                }),
                _buildShareOption(Icons.download, 'Save', Colors.green, () {
                  Navigator.pop(context);
                  _downloadCertificate(module);
                }),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareViaEmail(Map<String, dynamic> module) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.email, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Opening email to share ${module['title']} certificate...'),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareViaLink(Map<String, dynamic> module) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.link, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Certificate link copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Share',
          textColor: Colors.white,
          onPressed: () {
            // Simulate sharing functionality
          },
        ),
      ),
    );
  }
}

// Mock class for Android info
class MockAndroidInfo {
  final MockAndroidVersion version = MockAndroidVersion();
}

class MockAndroidVersion {
  final int sdkInt = 31; // Mock SDK version
}
