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
        final matchesSearch = ('${e.firstName} ${e.lastName}')
            .toLowerCase()
            .contains(searchQuery);
        final matchesBranch = selectedBranch == null ||
            e.branch == selectedBranch!.name;
        final matchesDepartment = selectedDepartment == null ||
            e.department == selectedDepartment!.name;
        return matchesSearch && matchesBranch && matchesDepartment;
      }).toList();
    });
  }

  void addOrUpdateEmployee(Employee emp) async {
    final api = ApiService();
    final index = employees.indexWhere((e) => e.employeeID == emp.employeeID);
    bool success;

    try {
      if (index >= 0) {
        // UPDATE
        success = await api.updateEmployee(emp);
        if (success) {
          setState(() {
            employees[index] = emp;
            search(searchQuery);
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Employee "${emp.firstName} ${emp.lastName}" updated successfully.',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else {
          _showSnackBar("Failed to update employee. Please try again.", isError: true);
        }
      } else {
        // CREATE
        success = await api.addEmployee(emp);
        if (success) {
          setState(() {
            employees.add(emp);
            search(searchQuery);
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Employee "${emp.firstName} ${emp.lastName}" added successfully.',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else {
          _showSnackBar("Failed to add employee. Please try again.", isError: true);
        }
      }
    } catch (e) {
      print('Error in addOrUpdateEmployee: $e');
      _showSnackBar("An error occurred. Please check your connection and try again.", isError: true);
    }
  }


  void deleteEmployee(String id) async {
    final api = ApiService();
    
    try {
      bool success = await api.deleteEmployee(id);

      if (success) {
        // find the employee (if present) so we can show their name in the snackbar
        final index = employees.indexWhere((e) => e.employeeID == id);
        final Employee? deletedEmp = index != -1 ? employees[index] : null;

        setState(() {
          employees.removeWhere((e) => e.employeeID == id);
          search(searchQuery);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                deletedEmp != null
                  ? 'Employee "${deletedEmp.firstName} ${deletedEmp.lastName}" deleted successfully.'
                  : 'Employee deleted successfully.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        _showSnackBar("Failed to delete employee. Please try again.", isError: true);
      }
    } catch (e) {
      print('Error in deleteEmployee: $e');
      _showSnackBar("An error occurred while deleting. Please check your connection and try again.", isError: true);
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

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
          duration: Duration(seconds: isError ? 4 : 2),
        ),
      );
    }
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
                                        final result =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ProfileEditPage(employee: emp),
                                          ),
                                        );
                                        if (result != null && result['employee'] != null) {
                                          addOrUpdateEmployee(result['employee']);
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
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProfileEditPage()),
                );
                if (result != null && result['employee'] != null) {
                  addOrUpdateEmployee(result['employee']);
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
