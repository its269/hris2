import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ Use http://10.0.2.2 if testing on Android Emulator!
  final String apiUrl = "http://10.0.2.2/login.php";

  Future<Map<String, dynamic>?> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['username'] != null) {
          return {'username': data['username'], 'role': data['role']};
        }
      }
    } catch (e) {
      print("API Error: $e");
    }

    return null;
  }
}
