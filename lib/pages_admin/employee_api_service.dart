import 'dart:convert';
import 'package:http/http.dart' as http;
import 'employee_model.dart';

// IMPORTANT: Replace this with the URL of your PHP server.
// For local development, you might use '[http://10.0.2.2/api](http://10.0.2.2/api)' for Android
// or 'http://localhost:80/api' for iOS/web.
const String _baseUrl = 'http://10.0.2.2/employee_api';

class ApiService {
  static Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse('$_baseUrl/read.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  static Future<void> addEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/create.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add employee');
    }
  }

  static Future<void> updateEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/update.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update employee');
    }
  }

  static Future<void> deleteEmployee(String id) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/delete.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete employee');
    }
  }
}
