import 'dart:convert';
import 'package:http/http.dart' as http;
import 'employee_model.dart';

class ApiService {
  // ⚠️ Use http://10.0.2.2 if testing on Android Emulator!
  final String apiUrl = "http://10.0.2.2";
  
  // For actual device or web, use your server's IP or domain
  // final String apiUrl = "http://your-server-ip-or-domain";

  Future<Map<String, dynamic>?> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login.php'),
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

  Future<List<Employee>> fetchAllEmployees() async {
    final url = Uri.parse('$apiUrl/employee.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch employees');
    }
  }

  Future<bool> addEmployee(Employee emp) async {
    final response = await http.post(
      Uri.parse('$apiUrl/employee.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(emp.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> updateEmployee(Employee emp) async {
    final response = await http.put(
      Uri.parse('$apiUrl/employee.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(emp.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteEmployee(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/employee.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    return response.statusCode == 200;
  }
}
