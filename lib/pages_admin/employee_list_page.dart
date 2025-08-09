import 'package:flutter/material.dart';
import 'employee_model.dart';
import 'profile_edit_page.dart';
import 'api_service.dart';

class EmployeeListPage extends StatefulWidget {
  final String role;
  final String employeeId; // passed from login

  const EmployeeListPage({
    super.key,
    required this.role,
    required this.employeeId,
  });

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];
  bool isLoading = true;
  String? errorMessage;
  String searchQuery = "";

  Branch? selectedBranch;
  Department? selectedDepartment;

  final List<String> branches = [
    "KGS - Main",
    "KGS - Davao",
    "KGS - CDO",
  ];

  final List<String> departments = [
    "MIS",
    "HR",
    "Accounting",
    "Marketing",
    "Finance",
    "Sales",
    "Support",
    "E - Commerce"
  ];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final fetchedEmployees = await ApiService().fetchAllEmployees();

      List<Employee> finalList = fetchedEmployees;

      if (widget.role.toLowerCase() != 'admin') {
        finalList = fetchedEmployees
            .where((e) => e.employeeID == widget.employeeId) // changed here
            .toList();
      }

      setState(() {
        employees = finalList;
        filteredEmployees = finalList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Exception: $e";
        isLoading = false;
      });
    }
  }

  void search(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredEmployees = employees.where((e) {
        final fullName = '${e.firstName} ${e.lastName}'.toLowerCase();
        return fullName.contains(searchQuery);
      }).toList();
    });
  }

  void addOrUpdateEmployee(Employee emp) async {
    final api = ApiService();
    final index = employees.indexWhere((e) => e.employeeID == emp.employeeID);
    bool success;

    if (index >= 0) {
      success = await api.updateEmployee(emp);
      if (success) {
        setState(() {
          employees[index] = emp;
          search(searchQuery);
        });
      } else {
        _showSnackBar("Failed to update employee");
      }
    } else {
      success = await api.addEmployee(emp);
      if (success) {
        setState(() {
          employees.add(emp);
          search(searchQuery);
        });
      } else {
        _showSnackBar("Failed to add employee");
      }
    }
  }

  void deleteEmployee(String id) async {
    final api = ApiService();
    bool success = await api.deleteEmployee(id);

    if (success) {
      setState(() {
        employees.removeWhere((e) => e.employeeID == id);
        search(searchQuery);
      });
    } else {
      _showSnackBar("Failed to delete employee");
    }
  }

  Future<void> confirmDelete(BuildContext context, Employee emp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          'Are you sure you want to delete ${emp.firstName} ${emp.lastName}?',
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
      deleteEmployee(emp.employeeID);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // UI Starts
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(errorMessage!)),
      );
    }

    if (selectedBranch == null) return _buildBranchSelection();
    if (selectedDepartment == null) return _buildDepartmentSelection();
    return _buildEmployeeList();
  }

  Widget _buildBranchSelection() {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Branch")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: branches.map((branch) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.account_tree),
              title: Text(branch),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => setState(() {
                selectedBranch = Branch(branch);
              }),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDepartmentSelection() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Departments - ${selectedBranch!.name}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => selectedBranch = null),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: departments.map((dept) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.business_center),
              title: Text(dept),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => setState(() {
                selectedDepartment = Department(dept);
              }),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmployeeList() {
    final deptEmployees = filteredEmployees.where((e) =>
        e.branch == selectedBranch!.name &&
        e.department == selectedDepartment!.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("${selectedDepartment!.name} - ${selectedBranch!.name}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => selectedDepartment = null),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search employee...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: search,
            ),
          ),
          Expanded(
            child: deptEmployees.isEmpty
                ? const Center(child: Text("No employees found."))
                : ListView.builder(
                    itemCount: deptEmployees.length,
                    itemBuilder: (context, index) {
                      final emp = deptEmployees[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text("${emp.firstName} ${emp.lastName}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Position: ${emp.position}"),
                              Text("Email: ${emp.companyEmail}"),
                              Text("Mobile: ${emp.mobileNumber}"),
                            ],
                          ),
                          trailing: widget.role.toLowerCase() == 'admin'
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () async {
                                        final updatedEmp =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ProfileEditPage(employee: emp),
                                          ),
                                        );
                                        if (updatedEmp != null) {
                                          addOrUpdateEmployee(updatedEmp);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          confirmDelete(context, emp),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.role.toLowerCase() == 'admin'
          ? FloatingActionButton(
              onPressed: () async {
                final newEmp = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProfileEditPage()),
                );
                if (newEmp != null) {
                  addOrUpdateEmployee(newEmp);
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// Simple wrapper classes
class Branch {
  final String name;
  Branch(this.name);
}

class Department {
  final String name;
  Department(this.name);
}
