import 'package:flutter/material.dart';
import 'package:hris/pages_admin/attendance_page.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // for caching credentials, storing securely
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
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _errorMessage;
  
  // Create secure storage instance
  // FlutterSecureStorage provides encrypted storage for sensitive data like passwords
  // Data is stored in the device's keychain (iOS) or keystore (Android)
  // This ensures credentials are encrypted and secure even if device is compromised
  static const _secureStorage = FlutterSecureStorage();
  
  @override
  void initState() {
    super.initState();
    // Load any previously saved credentials when the login page opens
    _loadSavedCredentials();
  }
  
  // REMEMBER ME FUNCTIONALITY:
  // This method loads saved username and password from secure storage
  // when the app starts. If user previously checked "Remember Me" and 
  // successfully logged in, their credentials will be auto-filled
  Future<void> _loadSavedCredentials() async {
    try {
      // Read stored values from secure storage using unique keys
      final savedUsername = await _secureStorage.read(key: 'username');
      final savedPassword = await _secureStorage.read(key: 'password');
      final rememberMe = await _secureStorage.read(key: 'remember_me');
      
      // Only auto-fill if all required data exists and remember_me was true
      if (savedUsername != null && savedPassword != null && rememberMe == 'true') {
        setState(() {
          // Auto-fill the text fields with saved credentials
          _usernameController.text = savedUsername;
          _passwordController.text = savedPassword;
          // Keep the "Remember Me" checkbox checked
          _rememberMe = true;
        });
      }
    } catch (e) {
      // Handle any errors gracefully (e.g., storage permissions, corrupted data)
      print('Error loading saved credentials: $e');
    }
  }
  
  // CREDENTIAL SAVING LOGIC:
  // This method saves or clears credentials based on the "Remember Me" checkbox state
  // Called after successful login to either store or remove user credentials
  Future<void> _saveCredentials() async {
    try {
      if (_rememberMe) {
        // User wants to be remembered - save encrypted credentials
        await _secureStorage.write(key: 'username', value: _usernameController.text.trim());
        await _secureStorage.write(key: 'password', value: _passwordController.text);
        await _secureStorage.write(key: 'remember_me', value: 'true');
        print('Credentials saved securely for next login');
      } else {
        // User unchecked "Remember Me" - clear any stored credentials for security
        await _secureStorage.delete(key: 'username');
        await _secureStorage.delete(key: 'password');
        await _secureStorage.delete(key: 'remember_me');
        print('Stored credentials cleared for security');
      }
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  // SECURITY UTILITY METHOD:
  // This method completely clears all stored credentials from secure storage
  // Useful for logout functionality or when resetting app data
  // Currently not used but available for future security features
  Future<void> _clearCredentials() async {
    try {
      // Remove all stored data from secure storage
      await _secureStorage.deleteAll();
      print('All stored credentials have been cleared');
    } catch (e) {
      print('Error clearing credentials: $e');
    }
  }

  @override
  void dispose() {
    // Clean up text controllers to prevent memory leaks
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Please enter both username and password";
      });
      return;
    }

    final api = ApiService();
    final result = await api.signIn(username, password);

    setState(() {
      _isLoading = false;
    });

    if (result != null && result.isNotEmpty) {
      // Check if login was actually successful by verifying we have valid data
      final employeeId = result['username'] ?? result['EmployeeID'] ?? '';
      final success = result['success'] ?? true; // Some APIs return success flag
      final error = result['error'] ?? '';
      
      // If there's an error message or no valid employeeId, treat as failed login
      if (error.isNotEmpty || employeeId.isEmpty || success == false) {
        setState(() {
          _errorMessage = error.isNotEmpty ? error : "Invalid username or password";
        });
        return;
      }

      // REMEMBER ME INTEGRATION:
      // After successful login, save credentials if user opted to be remembered
      // This ensures their username/password will be auto-filled next time
      await _saveCredentials();

      // Navigate to home page on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyHomePage(
            role: 'Admin', // Default role or you can use result['role'] ?? 'Admin'
            employeeId: employeeId,
          ),
        ),
      );
    } else {
      setState(() {
        _errorMessage = "Invalid username or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = themeProvider.currentTheme;
        final colorScheme = theme.colorScheme;
        final isDark = themeProvider.isDarkMode;
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset('assets/kelin.png', height: 120),
                  const SizedBox(height: 16),

                  // Welcome Text
                  Text(
                    "Welcome to HRIS!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Sign in to continue",
                    style: TextStyle(fontSize: 16, color: colorScheme.onBackground.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 32),

                  // Username Field
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: colorScheme.onBackground),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: colorScheme.onBackground.withOpacity(0.8)),
                      prefixIcon: Icon(Icons.person, color: colorScheme.primary),
                      filled: true,
                      fillColor: isDark ? colorScheme.surface : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(color: colorScheme.onBackground),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: colorScheme.onBackground.withOpacity(0.8)),
                      prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: isDark ? colorScheme.surface : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // REMEMBER ME CHECKBOX:
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                            if (!_rememberMe) {
                              _clearCredentials();
                            }
                          });
                        },
                        activeColor: colorScheme.primary,
                        checkColor: colorScheme.onPrimary,
                      ),
                      Text(
                        'Remember Me',
                        style: TextStyle(fontSize: 16, color: colorScheme.onBackground),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: colorScheme.onBackground.withOpacity(0.6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Login Button or Loading
                  _isLoading
                      ? CircularProgressIndicator(color: colorScheme.primary)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _login,
                            icon: const Icon(Icons.login),
                            label: const Text('Login'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                            ),
                          ),
                        ),

                  // Error Message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
