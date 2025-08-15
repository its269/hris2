import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  final bool showAppBar;
  
  const PolicyPage({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Widget bodyContent = SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Policy Categories Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
            children: [
              _buildPolicyCard(
                context,
                'HR Policies',
                'Employment rules',
                Icons.people_outline,
                Colors.blue,
              ),
              _buildPolicyCard(
                context,
                'Code of Conduct',
                'Behavioral guidelines',
                Icons.rule,
                Colors.green,
              ),
              _buildPolicyCard(
                context,
                'Safety & Security',
                'Workplace safety',
                Icons.security,
                Colors.red,
              ),
              _buildPolicyCard(
                context,
                'IT Policies',
                'Technology usage',
                Icons.computer,
                Colors.purple,
              ),
              _buildPolicyCard(
                context,
                'Leave Policy',
                'Time off rules',
                Icons.event_available,
                Colors.orange,
              ),
              _buildPolicyCard(
                context,
                'Benefits',
                'Employee benefits',
                Icons.card_giftcard,
                Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );

    if (!showAppBar) {
      return bodyContent;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.policy, 
                 color: colorScheme.onPrimaryContainer, 
                 size: 24),
            const SizedBox(width: 8),
            const Text('Corporate Policy'),
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

  Widget _buildPolicyCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Add navigation or functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title policy coming soon!')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
