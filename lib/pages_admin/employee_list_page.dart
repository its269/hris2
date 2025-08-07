// Functionality: Employee Model (structure for Employee Data)
import 'package:flutter/material.dart';
import 'employee_model.dart';
import 'profile_edit_page.dart';
import 'package:uuid/uuid.dart';
import 'api_service.dart'; // Adjust the path as needed

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

  void addOrUpdateEmployee(Employee emp) {
    setState(() {
      final index = employees.indexWhere((e) => e.id == emp.id);
      if (index >= 0) {
        employees[index] = emp;
      } else {
        employees.add(emp);
      }
    });
  }

  void deleteEmployee(String id) {
    setState(() {
      employees.removeWhere((e) => e.id == id);
    });
  }

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

                        return ListTile(
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
                                  if (updatedEmp != null) addOrUpdateEmployee(updatedEmp);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => confirmDelete(context, emp),
                              ),
                            ],
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
          if (newEmp != null) addOrUpdateEmployee(newEmp);
        },
      ),
    );
  }
}
