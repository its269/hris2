import 'package:flutter/material.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

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
    return Scaffold(
      appBar: AppBar(title: const Text('Training Portal')),
      body: FutureBuilder<List<String>>(
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
            itemCount: trainingModules.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.school),
                title: Text(trainingModules[index]),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped on ${trainingModules[index]}'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
