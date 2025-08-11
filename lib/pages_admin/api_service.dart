import 'dart:convert';
import 'package:http/http.dart' as http;
import 'employee_model.dart';

class ApiService {
  // ⚠️ Use http://10.0.2.2 if testing on Android Emulator!
  final String apiUrl = "http://10.0.2.2";

  // For actual device or web, use your server's IP or domain
  // final String apiUrl = "http://your-server-ip-or-domain";

  // Sign in method
  Future<Map<String, dynamic>?> signIn(String employeeId, String password) async {
    final url = Uri.parse("$apiUrl/login.php");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"EmployeeID": employeeId, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Login failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error in signIn: $e");
      return null;
    }
  }


  // Fetch all employees
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

  // Add a new employee
  Future<bool> addEmployee(Employee emp) async {
    try {
      print("Adding employee: ${emp.toJson()}");
      final response = await http.post(
        Uri.parse('$apiUrl/employee.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(emp.toJson()),
      );

      print("Add employee response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return true;
        } else {
          print("Add employee failed: ${responseData}");
          return false;
        }
      } else {
        print("Add employee HTTP error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error in addEmployee: $e");
      return false;
    }
  }

  // Update an existing employee
  Future<bool> updateEmployee(Employee emp) async {
    try {
      print("Updating employee: ${emp.toJson()}");
      final response = await http.put(
        Uri.parse('$apiUrl/employee.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(emp.toJson()),
      );

      print("Update employee response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return true;
        } else {
          print("Update employee failed: ${responseData}");
          return false;
        }
      } else {
        print("Update employee HTTP error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error in updateEmployee: $e");
      return false;
    }
  }

  // Delete an employee by ID
  Future<bool> deleteEmployee(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/employee.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'EmployeeID': id}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Delete failed: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error in deleteEmployee: $e");
      return false;
    }
  }

  // Fetch attendance records with leave status
  Future<List<Map<String, dynamic>>> fetchAttendanceWithLeave() async {
    final url = Uri.parse("http://10.0.2.2/attendance.php"); 
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch attendance data');
    }
  }
}
