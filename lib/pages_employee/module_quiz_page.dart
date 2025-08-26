import 'package:flutter/material.dart';

class ModuleQuizPage extends StatefulWidget {
  final Map<String, dynamic> module;

  const ModuleQuizPage({super.key, required this.module});

  @override
  State<ModuleQuizPage> createState() => _ModuleQuizPageState();
}

class _ModuleQuizPageState extends State<ModuleQuizPage> {
  int _currentQuestionIndex = 0;
  List<String> _selectedAnswers = [];
  bool _isQuizCompleted = false;
  int _score = 0;
  int _timeRemaining = 1800; // 30 minutes in seconds
  bool _isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(_getQuestions().length, '');
    _startTimer();
  }

  void _startTimer() {
    if (_isTimerRunning) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isTimerRunning && _timeRemaining > 0) {
          setState(() {
            _timeRemaining--;
          });
          _startTimer();
        } else if (_timeRemaining <= 0) {
          _submitQuiz();
        }
      });
    }
  }

  String get _formattedTime {
    int minutes = _timeRemaining ~/ 60;
    int seconds = _timeRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  List<Map<String, dynamic>> _getQuestions() {
    // Generate questions based on module type
    switch (widget.module['id']) {
      case 1: // Company Policies
        return [
          {
            'question': 'What is the primary mission of our company?',
            'options': [
              'To maximize profits at all costs',
              'To deliver exceptional value to clients through innovative solutions',
              'To compete with other companies',
              'To expand globally without restrictions'
            ],
            'correctAnswer': 'To deliver exceptional value to clients through innovative solutions',
            'explanation': 'Our company mission focuses on client value and innovation as core principles.',
          },
          {
            'question': 'Which of the following is a core company value?',
            'options': ['Integrity', 'Profitability', 'Competition', 'Individualism'],
            'correctAnswer': 'Integrity',
            'explanation': 'Integrity is one of our fundamental core values that guides all business decisions.',
          },
          {
            'question': 'What is the company dress code policy?',
            'options': [
              'Casual attire is always acceptable',
              'Business professional for client meetings, business casual otherwise',
              'Formal wear required at all times',
              'No specific dress code exists'
            ],
            'correctAnswer': 'Business professional for client meetings, business casual otherwise',
            'explanation': 'Our dress code balances professionalism with comfort based on the work context.',
          },
          {
            'question': 'How should confidential information be handled?',
            'options': [
              'Can be shared with anyone in the company',
              'Only shared on a need-to-know basis with authorized personnel',
              'Can be discussed freely in public areas',
              'Should be posted on company bulletin boards'
            ],
            'correctAnswer': 'Only shared on a need-to-know basis with authorized personnel',
            'explanation': 'Confidentiality is critical and information should only be shared with those who need it for their work.',
          },
          {
            'question': 'What is the policy on workplace harassment?',
            'options': [
              'Minor incidents should be ignored',
              'Zero tolerance - all incidents must be reported immediately',
              'Only physical harassment is considered serious',
              'Verbal harassment is acceptable if not frequent'
            ],
            'correctAnswer': 'Zero tolerance - all incidents must be reported immediately',
            'explanation': 'We maintain a zero-tolerance policy on all forms of workplace harassment.',
          },
        ];
      case 2: // Workplace Safety
        return [
          {
            'question': 'In case of fire, what should be your first action?',
            'options': [
              'Try to fight the fire yourself',
              'Alert others and evacuate immediately',
              'Save important documents first',
              'Wait for instructions from management'
            ],
            'correctAnswer': 'Alert others and evacuate immediately',
            'explanation': 'Personal safety is the top priority. Alert others and evacuate first, then call for help.',
          },
          {
            'question': 'Where are the fire extinguishers located?',
            'options': [
              'Only in the kitchen area',
              'Near all exits and high-risk areas',
              'In the manager\'s office only',
              'Fire extinguishers are not provided'
            ],
            'correctAnswer': 'Near all exits and high-risk areas',
            'explanation': 'Fire extinguishers are strategically placed near exits and areas with higher fire risk.',
          },
          {
            'question': 'What does the PASS technique refer to?',
            'options': [
              'A method for lifting heavy objects',
              'Fire extinguisher operation: Pull, Aim, Squeeze, Sweep',
              'Emergency evacuation procedure',
              'First aid response protocol'
            ],
            'correctAnswer': 'Fire extinguisher operation: Pull, Aim, Squeeze, Sweep',
            'explanation': 'PASS is the standard technique for operating fire extinguishers effectively.',
          },
          {
            'question': 'Who should you report workplace injuries to?',
            'options': [
              'No one, handle it yourself',
              'Your immediate supervisor and HR immediately',
              'Only if the injury is severe',
              'Wait until the end of the workday'
            ],
            'correctAnswer': 'Your immediate supervisor and HR immediately',
            'explanation': 'All workplace injuries must be reported immediately for proper documentation and care.',
          },
          {
            'question': 'What should you do if you see a safety hazard?',
            'options': [
              'Ignore it if it doesn\'t affect you',
              'Report it immediately to your supervisor',
              'Fix it yourself regardless of training',
              'Mention it casually during the next meeting'
            ],
            'correctAnswer': 'Report it immediately to your supervisor',
            'explanation': 'Safety hazards should be reported immediately to prevent accidents and injuries.',
          },
        ];
      case 3: // Diversity and Inclusion
        return [
          {
            'question': 'What is unconscious bias?',
            'options': [
              'Deliberately discriminating against others',
              'Automatic preferences or prejudices we\'re not aware of',
              'Being conscious of our biases',
              'A training program requirement'
            ],
            'correctAnswer': 'Automatic preferences or prejudices we\'re not aware of',
            'explanation': 'Unconscious bias refers to implicit attitudes that influence our decisions without our awareness.',
          },
          {
            'question': 'How should you respond to inappropriate comments about someone\'s background?',
            'options': [
              'Laugh along to avoid conflict',
              'Address it directly or report to HR',
              'Ignore it completely',
              'Make similar comments back'
            ],
            'correctAnswer': 'Address it directly or report to HR',
            'explanation': 'Inappropriate comments should be addressed to maintain an inclusive workplace environment.',
          },
          {
            'question': 'What makes a workplace truly inclusive?',
            'options': [
              'Having diverse employees only',
              'When all employees feel valued, respected, and able to contribute fully',
              'Meeting legal diversity requirements',
              'Having diversity training once a year'
            ],
            'correctAnswer': 'When all employees feel valued, respected, and able to contribute fully',
            'explanation': 'True inclusion means creating an environment where everyone can thrive and contribute their best.',
          },
        ];
      case 4: // Cybersecurity
        return [
          {
            'question': 'What makes a strong password?',
            'options': [
              'Your name and birthday',
              'At least 12 characters with mixed case, numbers, and symbols',
              'A simple word you can remember',
              'The same password for all accounts'
            ],
            'correctAnswer': 'At least 12 characters with mixed case, numbers, and symbols',
            'explanation': 'Strong passwords are long and complex, making them harder to crack.',
          },
          {
            'question': 'How can you identify a phishing email?',
            'options': [
              'It comes from a known contact',
              'Urgent language, suspicious links, and requests for sensitive information',
              'It has the company logo',
              'It\'s sent during business hours'
            ],
            'correctAnswer': 'Urgent language, suspicious links, and requests for sensitive information',
            'explanation': 'Phishing emails often use urgency and deception to trick users into revealing information.',
          },
          {
            'question': 'What should you do with suspicious emails?',
            'options': [
              'Click links to investigate',
              'Delete immediately and report to IT',
              'Forward to colleagues for verification',
              'Reply asking if it\'s legitimate'
            ],
            'correctAnswer': 'Delete immediately and report to IT',
            'explanation': 'Suspicious emails should be reported to IT without interacting with their content.',
          },
        ];
      case 5: // Customer Service
        return [
          {
            'question': 'What is the key to excellent customer service?',
            'options': [
              'Always saying yes to customer requests',
              'Active listening and understanding customer needs',
              'Processing requests as quickly as possible',
              'Following scripts exactly'
            ],
            'correctAnswer': 'Active listening and understanding customer needs',
            'explanation': 'Understanding customer needs through active listening is fundamental to excellent service.',
          },
          {
            'question': 'How should you handle an angry customer?',
            'options': [
              'Match their energy level',
              'Remain calm, listen actively, and show empathy',
              'Transfer them to someone else immediately',
              'End the conversation quickly'
            ],
            'correctAnswer': 'Remain calm, listen actively, and show empathy',
            'explanation': 'Staying calm and showing empathy helps de-escalate situations and find solutions.',
          },
          {
            'question': 'What is the best way to follow up with customers?',
            'options': [
              'Only when they contact you first',
              'Proactively check if their needs were met and if they need additional help',
              'Wait at least a month before following up',
              'Send automated messages only'
            ],
            'correctAnswer': 'Proactively check if their needs were met and if they need additional help',
            'explanation': 'Proactive follow-up shows commitment to customer satisfaction and builds loyalty.',
          },
        ];
      default:
        return [
          {
            'question': 'Sample question for this module',
            'options': ['Option A', 'Option B', 'Option C', 'Option D'],
            'correctAnswer': 'Option A',
            'explanation': 'This is a sample explanation.',
          },
        ];
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _getQuestions().length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _submitQuiz() {
    _isTimerRunning = false;
    final questions = _getQuestions();
    int correctAnswers = 0;
    
    for (int i = 0; i < questions.length; i++) {
      if (_selectedAnswers[i] == questions[i]['correctAnswer']) {
        correctAnswers++;
      }
    }
    
    setState(() {
      _score = (correctAnswers / questions.length * 100).round();
      _isQuizCompleted = true;
    });
  }

  void _showQuestionNavigation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Question Navigation'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _getQuestions().length,
            itemBuilder: (context, index) {
              final isAnswered = _selectedAnswers[index].isNotEmpty;
              final isCurrent = index == _currentQuestionIndex;
              
              return InkWell(
                onTap: () {
                  setState(() {
                    _currentQuestionIndex = index;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.blue
                        : isAnswered
                            ? Colors.green
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrent || isAnswered ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
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

  @override
  Widget build(BuildContext context) {
    if (_isQuizCompleted) {
      return _buildResultsPage();
    }

    final questions = _getQuestions();
    final currentQuestion = questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / questions.length;
    final moduleColor = widget.module['color'] ?? Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.module['title']} - Quiz'),
        backgroundColor: moduleColor.withOpacity(0.1),
        foregroundColor: moduleColor,
        actions: [
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _timeRemaining < 300 ? Colors.red : moduleColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  _formattedTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: moduleColor,
                      ),
                    ),
                    TextButton(
                      onPressed: _showQuestionNavigation,
                      child: const Text('Question Map'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(moduleColor),
                  minHeight: 6,
                ),
              ],
            ),
          ),
          
          // Question Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: moduleColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: moduleColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      currentQuestion['question'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Options
                  ...currentQuestion['options'].map<Widget>((option) {
                    final isSelected = _selectedAnswers[_currentQuestionIndex] == option;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(option),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? moduleColor.withOpacity(0.1)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected 
                                  ? moduleColor
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected 
                                      ? moduleColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected 
                                        ? moduleColor
                                        : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected 
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected 
                                        ? moduleColor
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousQuestion,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                
                if (_currentQuestionIndex > 0) const SizedBox(width: 16),
                
                Expanded(
                  flex: _currentQuestionIndex == 0 ? 1 : 1,
                  child: ElevatedButton.icon(
                    onPressed: _selectedAnswers[_currentQuestionIndex].isEmpty 
                        ? null
                        : (_currentQuestionIndex == questions.length - 1
                            ? _submitQuiz
                            : _nextQuestion),
                    icon: Icon(_currentQuestionIndex == questions.length - 1
                        ? Icons.check_circle
                        : Icons.arrow_forward),
                    label: Text(_currentQuestionIndex == questions.length - 1
                        ? 'Submit Quiz'
                        : 'Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: moduleColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsPage() {
    final questions = _getQuestions();
    final passingScore = widget.module['passingScore'] ?? 80;
    final passed = _score >= passingScore;
    final moduleColor = widget.module['color'] ?? Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: passed ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        foregroundColor: passed ? Colors.green : Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Results Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: passed
                      ? [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)]
                      : [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: passed ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    passed ? Icons.check_circle : Icons.cancel,
                    size: 64,
                    color: passed ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    passed ? 'Congratulations!' : 'Quiz Failed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: passed ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    passed 
                        ? 'You have successfully passed the quiz!'
                        : 'You need to retake the quiz to pass.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Score Details
            Row(
              children: [
                Expanded(
                  child: _buildResultCard(
                    'Your Score',
                    '$_score%',
                    Icons.grade,
                    passed ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildResultCard(
                    'Passing Score',
                    '$passingScore%',
                    Icons.flag,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildResultCard(
                    'Correct',
                    '${(_score * questions.length / 100).round()}/${questions.length}',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildResultCard(
                    'Time Used',
                    '${((1800 - _timeRemaining) / 60).floor()}min',
                    Icons.timer,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Question Review
            Text(
              'Question Review',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              final userAnswer = _selectedAnswers[index];
              final correctAnswer = question['correctAnswer'];
              final isCorrect = userAnswer == correctAnswer;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
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
                              color: isCorrect 
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isCorrect ? Icons.check : Icons.close,
                              color: isCorrect ? Colors.green : Colors.red,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Question ${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question['question'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      
                      if (userAnswer.isNotEmpty) ...[
                        Text(
                          'Your Answer:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userAnswer,
                          style: TextStyle(
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      
                      if (!isCorrect) ...[
                        Text(
                          'Correct Answer:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          correctAnswer,
                          style: const TextStyle(color: Colors.green),
                        ),
                        const SizedBox(height: 8),
                      ],
                      
                      if (question['explanation'] != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.withOpacity(0.2)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info, 
                                   color: Colors.blue, 
                                   size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  question['explanation'],
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 14,
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
            }).toList(),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                if (!passed) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ModuleQuizPage(module: widget.module),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retake Quiz'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Return results to training page
                      Navigator.pop(context, {
                        'score': _score,
                        'passed': passed,
                        'timeUsed': 1800 - _timeRemaining,
                      });
                    },
                    icon: Icon(passed ? Icons.file_download : Icons.home),
                    label: Text(passed ? 'Get Certificate' : 'Back to Training'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: passed ? Colors.green : Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
