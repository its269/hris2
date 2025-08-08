import 'package:flutter/material.dart';
import 'employee_model.dart';
import 'profile_edit_page.dart';
import 'api_service.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final List<Employee> employees = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  // Fetch employees from API
  Future<void> fetchEmployees() async {
    try {
      final fetchedEmployees = await ApiService().fetchAllEmployees();
      setState(() {
        employees.clear();
        employees.addAll(fetchedEmployees);
        isLoading = false;
      });
    } catch (e, stack) {
      print("Fetch Error: $e");
      print("Stack Trace: $stack");

      setState(() {
        errorMessage = "Exception: $e";
        isLoading = false;
      });
    }
  }

  // Add or Update employee via API
  void addOrUpdateEmployee(Employee emp) async {
    final api = ApiService();
    final index = employees.indexWhere((e) => e.id == emp.id);
    bool success;

    if (index >= 0) {
      success = await api.updateEmployee(emp);
      if (success) {
        setState(() {
          employees[index] = emp;
        });
      } else {
        _showSnackBar("Failed to update employee");
      }
    } else {
      success = await api.addEmployee(emp);
      if (success) {
        setState(() {
          employees.add(emp);
        });
      } else {
        _showSnackBar("Failed to add employee");
      }
    }
  }

  // Delete employee
  void deleteEmployee(String id) async {
    final api = ApiService();
    bool success = await api.deleteEmployee(id);

    if (success) {
      setState(() {
        employees.removeWhere((e) => e.id == id);
      });
    } else {
      _showSnackBar("Failed to delete employee");
    }
  }

  // Show confirmation dialog before delete
  Future<void> confirmDelete(BuildContext context, Employee emp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Are you sure you want to delete ${emp.firstName} ${emp.lastName}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      deleteEmployee(emp.id);
    }
  }

  // Show snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employees")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text("Error: $errorMessage"))
              : employees.isEmpty
                  ? const Center(child: Text("No employees found."))
                  : ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final emp = employees[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text("${emp.firstName} ${emp.lastName}"),
                            subtitle: Text("${emp.position} - ${emp.department}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    final updatedEmp = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProfileEditPage(employee: emp),
                                      ),
                                    );
                                    if (updatedEmp != null) {
                                      addOrUpdateEmployee(updatedEmp);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => confirmDelete(context, emp),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newEmp = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileEditPage()),
          );
          if (newEmp != null) {
            addOrUpdateEmployee(newEmp);
          }
        },
      ),
    );
  }
}
