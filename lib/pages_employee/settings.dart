import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool showAppBar;

  const SettingsPage({Key? key, this.showAppBar = true}) : super(key: key);

  static const List<_SettingsItem> _settingsItems = [
    _SettingsItem(
      icon: Icons.person,
      title: 'Account',
      subtitle: 'Manage your account',
    ),
    _SettingsItem(
      icon: Icons.notifications,
      title: 'Notifications',
      subtitle: 'Notifications preference',
    ),
    _SettingsItem(
      icon: Icons.lock,
      title: 'Privacy',
      subtitle: 'Privacy and Security',
    ),
    _SettingsItem(
      icon: Icons.info,
      title: 'About',
      subtitle: 'App information',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: showAppBar
          ? AppBar(
              title: const Text('Settings'),
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              elevation: 0,
            )
          : null,
      body: Column(
        children: [
          const SettingsHeader(),
          Expanded(
            child: ListView.separated(
              itemCount: _settingsItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _settingsItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      tileColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      leading: Icon(
                        item.icon,
                        color: colorScheme.onPrimary,
                        size: 28,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: TextStyle(
                          color: colorScheme.onPrimary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                      onTap: () {
                        if (item.title == 'About') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutPage(),
                            ),
                          );
                        }
                        // You can add other onTap functionality for other items here
                      },
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
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/hris_settings_cover.png'),
            ),
          ),
          child: const Center(),
        ),
        const SizedBox(height: 16),
        Text(
          'HRIS',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'KELIN GRAPHIC SYSTEM CORP.',
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onBackground,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

/// NEW SCREEN FOR "ABOUT"
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HRIS App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16, color: colorScheme.onBackground),
            ),
            const SizedBox(height: 20),
            Text(
              'Developed by KELIN GRAPHIC SYSTEM CORP. (MIS DEPT.)',
              style: TextStyle(fontSize: 16, color: colorScheme.onBackground),
            ),
            const SizedBox(height: 20),
            Text(
              'This application is designed to manage human resource information efficiently and securely.',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onBackground.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
