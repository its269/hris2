import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class AccountSettingsPage extends StatefulWidget {
  final String employeeId;
  final String role;

  const AccountSettingsPage({
    super.key,
    required this.employeeId,
    required this.role,
  });

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  String _selectedLanguage = 'English';
  
  final List<String> _languages = ['English', 'Filipino', 'Cebuano'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Information Section
            _buildSectionHeader(context, 'Account Information', Icons.person),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Employee ID', widget.employeeId, Icons.badge, valueColor: Colors.blueAccent),
                    const Divider(),
                    _buildInfoRow('Role', widget.role, Icons.admin_panel_settings, valueColor: Colors.blueAccent),
                    const Divider(),
                    _buildInfoRow('Status', 'Active', Icons.check_circle, 
                        valueColor: Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Notification Settings Section
            _buildSectionHeader(context, 'Notification Settings', Icons.notifications),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Email Notifications'),
                      subtitle: const Text('Receive notifications via email'),
                      value: _emailNotifications,
                      onChanged: (value) {
                        setState(() {
                          _emailNotifications = value;
                        });
                        _showSettingsSaved();
                      },
                      secondary: const Icon(Icons.email),
                    ),
                    SwitchListTile(
                      title: const Text('Push Notifications'),
                      subtitle: const Text('Receive app notifications'),
                      value: _pushNotifications,
                      onChanged: (value) {
                        setState(() {
                          _pushNotifications = value;
                        });
                        _showSettingsSaved();
                      },
                      secondary: const Icon(Icons.notifications_active),
                    ),
                    SwitchListTile(
                      title: const Text('SMS Notifications'),
                      subtitle: const Text('Receive notifications via SMS'),
                      value: _smsNotifications,
                      onChanged: (value) {
                        setState(() {
                          _smsNotifications = value;
                        });
                        _showSettingsSaved();
                      },
                      secondary: const Icon(Icons.sms),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App Preferences Section
            _buildSectionHeader(context, 'App Preferences', Icons.settings),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, child) {
                        return SwitchListTile(
                          title: const Text('Dark Mode'),
                          subtitle: const Text('Use dark theme'),
                          value: themeProvider.isDarkMode,
                          onChanged: (value) async {
                            await themeProvider.setThemeMode(value);
                            _showSettingsSaved();
                          },
                          secondary: Icon(
                            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Language'),
                      subtitle: Text(_selectedLanguage),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showLanguageSelector(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Security Section
            _buildSectionHeader(context, 'Security', Icons.security),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Change Password'),
                      subtitle: const Text('Update your account password'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showChangePasswordDialog(),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phonelink_lock),
                      title: const Text('Two-Factor Authentication'),
                      subtitle: const Text('Add extra security to your account'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showComingSoonDialog('Two-Factor Authentication'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Login History'),
                      subtitle: const Text('View recent login activity'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showComingSoonDialog('Login History'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Data & Privacy Section
            _buildSectionHeader(context, 'Data & Privacy', Icons.privacy_tip),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.download),
                      title: const Text('Download My Data'),
                      subtitle: const Text('Export your personal information'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showComingSoonDialog('Data Export'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                      subtitle: const Text('Permanently delete your account'),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red),
                      onTap: () => _showDeleteAccountDialog(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Help & Support Section
            _buildSectionHeader(context, 'Help & Support', Icons.help),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_center),
                      title: const Text('Help Center'),
                      subtitle: const Text('Get help with common issues'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showComingSoonDialog('Help Center'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.contact_support),
                      title: const Text('Contact Support'),
                      subtitle: const Text('Get in touch with our support team'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showContactSupport(),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('About'),
                      subtitle: const Text('App version and information'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showAboutDialog(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsSaved() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                _showSettingsSaved();
              },
            );
          }).toList(),
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

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
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
              // TODO: Implement password change functionality
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password change functionality will be implemented soon!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(feature),
        content: Text('$feature will be available in a future update!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
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
                const SnackBar(
                  content: Text('Account deletion requires admin approval. Contact your administrator.'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showContactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get in touch with our support team:'),
            SizedBox(height: 16),
            Text('📧 Email: support@kelinGraphic.com'),
            Text('📞 Phone: +63 123 456 7890'),
            Text('🕒 Hours: Monday - Friday, 8AM - 5PM'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About HRIS'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kelin Graphic System HRIS'),
            Text('Version: 1.0.0'),
            SizedBox(height: 16),
            Text('Human Resource Information System for managing employee data, attendance, and leave requests.'),
            SizedBox(height: 16),
            Text('© 2025 Kelin Graphic System'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
