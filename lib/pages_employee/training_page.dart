import 'package:flutter/material.dart';
import 'user_quiz_page.dart';
import 'user_learning_page.dart';

class TrainingPage extends StatelessWidget {
  final bool showAppBar;

  const TrainingPage({super.key, this.showAppBar = true});

  // Temporary static data; in the future, replace this with a network call
  Future<List<String>> fetchTrainingModules() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate loading
    return [
      'Introduction to Company Policies',
      'Workplace Safety',
      'Diversity and Inclusion',
      'Cybersecurity Basics',
      'Project Management 101',
    ];
  }

  // Navigate to UserQuizPage
  void navigateToQuiz(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserQuizPage()), // Fixed navigation
    );
  }

  // Navigate to UserLearningPage
  void navigateToLearning(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserLearningPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget bodyContent = FutureBuilder<List<String>>(
      future: fetchTrainingModules(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No training modules found.'));
        }

        final trainingModules = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: trainingModules.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.school),
                title: Text(trainingModules[index]),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped on ${trainingModules[index]}'),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('Training Portal'),
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Learning Section
            Card(
              color: colorScheme.surface,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learn About the Company',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore the history, mission, vision, and values of our company. Understand how we operate and what makes us unique.',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => navigateToLearning(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: const Text('Start Learning'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quiz Section
            Card(
              color: colorScheme.surface,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Take a Quiz',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Test your knowledge about the company and its policies. Complete the quiz to earn points and recognition.',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => navigateToQuiz(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: const Text('Start Quiz'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Training Modules Section
            bodyContent,
          ],
        ),
      ),
    );
  }
}
