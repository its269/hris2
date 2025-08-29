import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages_admin/login_page.dart';
import 'theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'HRIS - Kelin Graphic System',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../theme_provider.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset('../assets/1.png', fit: BoxFit.cover),
//           ),

//           // Optional overlay for readability
//           Positioned.fill(
//             child: Container(
//               color: isDarkMode
//                   ? Colors.black.withOpacity(0.5)
//                   : Colors.white.withOpacity(0.3),
//             ),
//           ),

//           // Login form content
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Welcome Back',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   TextField(
//                     style: TextStyle(
//                       color: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : Colors.black.withOpacity(0.05),
//                       hintText: 'Username',
//                       hintStyle: TextStyle(
//                         color: isDarkMode ? Colors.white70 : Colors.black87,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     obscureText: true,
//                     style: TextStyle(
//                       color: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: isDarkMode
//                           ? Colors.white.withOpacity(0.1)
//                           : Colors.black.withOpacity(0.05),
//                       hintText: 'Password',
//                       hintStyle: TextStyle(
//                         color: isDarkMode ? Colors.white70 : Colors.black87,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle login logic
//                     },
//                     child: const Text('Login'),
//                   ),

//                   const SizedBox(height: 16),
//                   // Theme toggle for testing
//                   IconButton(
//                     icon: Icon(
//                       isDarkMode ? Icons.dark_mode : Icons.light_mode,
//                       color: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                     onPressed: () {
//                       themeProvider.toggleTheme();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
