import 'package:flutter/material.dart';

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

    if (!showAppBar) {
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
}
