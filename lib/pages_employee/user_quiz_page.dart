import 'package:flutter/material.dart';

class UserQuizPage extends StatefulWidget {
  const UserQuizPage({super.key});

  @override
  State<UserQuizPage> createState() => _UserQuizPageState();
}

class _UserQuizPageState extends State<UserQuizPage> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the mission of Kelin Graphic System?',
      'options': [
        'To deliver exceptional value to clients.',
        'To be the most trusted partner worldwide.',
        'To prioritize customer satisfaction.',
        'To provide cutting-edge technology.',
      ],
      'answer': 'To deliver exceptional value to clients.',
    },
    {
      'question': 'Which of the following is a core value of the company?',
      'options': ['Integrity', 'Profitability', 'Competition', 'Individualism'],
      'answer': 'Integrity',
    },
    {
      'question': 'What does the company prioritize?',
      'options': [
        'Customer success',
        'Employee benefits',
        'Market dominance',
        'Cost reduction',
      ],
      'answer': 'Customer success',
    },
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizCompleted = false;

  void _submitAnswer(String selectedOption) {
    if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _isQuizCompleted = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isQuizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Quiz'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isQuizCompleted
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your Score: $_score / ${_questions.length}',
                      style: TextStyle(
                        fontSize: 20,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _restartQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: const Text('Restart Quiz'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _questions[_currentQuestionIndex]['question'],
                    style: TextStyle(
                      fontSize: 20,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ..._questions[_currentQuestionIndex]['options']
                      .map<Widget>(
                        (option) => Card(
                          color: colorScheme.surface,
                          child: ListTile(
                            title: Text(
                              option,
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                            onTap: () => _submitAnswer(option),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
      ),
    );
  }
}
