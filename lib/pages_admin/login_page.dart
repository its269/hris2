import 'package:flutter/material.dart';
import 'api_service.dart';
import 'admin_page.dart';
import '../pages_employee/user_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final api = ApiService();
    final result = await api.signIn(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      if (result['role'] == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else if (result['role'] == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserPage()),
        );
      }
    } else {
      setState(() {
        _errorMessage = "Invalid username or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text('Login')),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
