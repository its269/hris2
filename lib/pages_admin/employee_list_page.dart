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
  final TextEditingController _searchController = TextEditingController();

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchEmployees() async {
    try {
      final fetchedEmployees = await ApiService().fetchAllEmployees();

      List<Employee> finalList = fetchedEmployees;

      if (widget.role.toLowerCase() != 'admin') {
        // Non-admin users only see their own profile
        finalList = fetchedEmployees
            .where((e) => e.employeeID == widget.employeeId)
            .toList();
      } else {
        // Admin users see all employees including themselves
        // Ensure admin's own profile is included
        final adminProfile = fetchedEmployees.firstWhere(
          (e) => e.employeeID == widget.employeeId,
          orElse: () => throw Exception('Admin profile not found'),
        );
        print('Admin profile found: ${adminProfile.firstName} ${adminProfile.lastName}');
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
      
      if (selectedBranch == null && selectedDepartment == null) {
        // Global search - no branch/department filtering
        filteredEmployees = employees.where((e) {
          final matchesName = ('${e.firstName} ${e.lastName}').toLowerCase().contains(searchQuery);
          final matchesId = e.employeeID.toLowerCase().contains(searchQuery);
          return searchQuery.isEmpty || matchesName || matchesId;
        }).toList();
      } else {
        // Branch/Department specific search - apply search only, let UI handle branch/dept filtering
        filteredEmployees = employees.where((e) {
          final matchesName = ('${e.firstName} ${e.lastName}').toLowerCase().contains(searchQuery);
          final matchesId = e.employeeID.toLowerCase().contains(searchQuery);
          return searchQuery.isEmpty || matchesName || matchesId;
        }).toList();
      }
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
          // Refresh the employees list from the database to ensure we have the latest data
          await fetchEmployees();

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
          // Refresh the employees list from the database to ensure we have the latest data
          await fetchEmployees();

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

  // Method to find and edit admin's own profile
  void _editMyProfile() async {
    try {
      final myProfile = employees.firstWhere(
        (e) => e.employeeID == widget.employeeId,
      );

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileEditPage(employee: myProfile),
        ),
      );
      
      if (result != null && result['employee'] != null) {
        addOrUpdateEmployee(result['employee']);
      }
    } catch (e) {
      print('Error finding admin profile: $e');
      _showSnackBar('Could not find your profile. Please ensure you are in the employee database.', isError: true);
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
      appBar: AppBar(
        title: const Text("Select Branch"),
        actions: widget.role.toLowerCase() == 'admin' ? [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'My Profile',
            onPressed: _editMyProfile,
          ),
        ] : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Global Search Section
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     Icon(Icons.search, color: Colors.blue.shade700, size: 28),
                  //     const SizedBox(width: 12),
                  //     Text(
                  //       'Employee Search',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.blue.shade700,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by employee name or ID...",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                search('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: search,
                  ),
                  if (searchQuery.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      "Found ${filteredEmployees.length} employee${filteredEmployees.length != 1 ? 's' : ''} matching '$searchQuery'",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: filteredEmployees.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                                  const SizedBox(height: 8),
                                  Text(
                                    "No employees found matching '$searchQuery'",
                                    style: TextStyle(color: Colors.grey[600]),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredEmployees.length,
                              itemBuilder: (context, index) {
                                final emp = filteredEmployees[index];
                                final isCurrentUser = emp.employeeID == widget.employeeId;
                                
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  color: isCurrentUser ? Colors.blue.shade50 : null,
                                  child: ListTile(
                                    leading: isCurrentUser 
                                        ? const Icon(Icons.account_circle, color: Colors.blue)
                                        : const Icon(Icons.person, color: Colors.grey),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${emp.firstName} ${emp.lastName}",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isCurrentUser) ...[
                                          const SizedBox(width: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              'You',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("ID: ${emp.employeeID}"),
                                        Text("${emp.position} - ${emp.department}"),
                                        Text("${emp.branch}"),
                                      ],
                                    ),
                                    trailing: widget.role.toLowerCase() == 'admin'
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Colors.blue),
                                                onPressed: () async {
                                                  final result = await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => ProfileEditPage(employee: emp),
                                                    ),
                                                  );
                                                  if (result != null && result['employee'] != null) {
                                                    addOrUpdateEmployee(result['employee']);
                                                  }
                                                },
                                              ),
                                              if (!isCurrentUser)
                                                IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () => confirmDelete(context, emp),
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            'Or browse by branch:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          ...branches.map((branch) {
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
        ],
      ),
      floatingActionButton: widget.role.toLowerCase() == 'admin'
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileEditPage(),
                  ),
                );
                if (result != null && result['employee'] != null) {
                  addOrUpdateEmployee(result['employee']);
                }
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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
        actions: widget.role.toLowerCase() == 'admin' ? [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'My Profile',
            onPressed: _editMyProfile,
          ),
        ] : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Global Search Option
          Card(
            color: Colors.blue.shade50,
            child: ListTile(
              leading: const Icon(Icons.search, color: Colors.blue, size: 28),
              title: const Text(
                'Search All Employees',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle: const Text('Search across all departments and branches'),
              trailing: const Icon(Icons.arrow_forward, color: Colors.blue),
              onTap: () => setState(() {
                selectedDepartment = Department('All');
              }),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          ...departments.map((dept) {
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
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    // Handle "Search All" case
    final deptEmployees = selectedDepartment!.name == 'All' 
        ? filteredEmployees // Show all filtered employees across all departments/branches
        : filteredEmployees.where((e) =>
            e.branch == selectedBranch!.name &&
            e.department == selectedDepartment!.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedDepartment!.name == 'All' 
            ? "All Employees" 
            : "${selectedDepartment!.name} - ${selectedBranch!.name}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => selectedDepartment = null),
        ),
        actions: widget.role.toLowerCase() == 'admin' ? [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'My Profile',
            onPressed: _editMyProfile,
          ),
        ] : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: selectedDepartment!.name == 'All' 
                    ? "Search by employee name or ID..."
                    : "Search employees in ${selectedDepartment!.name} by name or ID...",
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onChanged: search,
            ),
          ),
          // Search results counter
          if (searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Found ${deptEmployees.length} employee${deptEmployees.length != 1 ? 's' : ''} matching '$searchQuery'",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          Expanded(
            child: deptEmployees.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          searchQuery.isNotEmpty ? Icons.search_off : Icons.people_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isNotEmpty 
                              ? "No employees found matching '$searchQuery'"
                              : "No employees found in this department.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            "Try searching with different keywords",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: deptEmployees.length,
                    itemBuilder: (context, index) {
                      final emp = deptEmployees[index];
                      final isCurrentUser = emp.employeeID == widget.employeeId;
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        color: isCurrentUser ? Colors.blue.shade50 : null,
                        child: ListTile(
                          leading: isCurrentUser 
                              ? const Icon(Icons.account_circle, color: Colors.blue, size: 32)
                              : const Icon(Icons.person, color: Colors.grey),
                          title: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${emp.firstName} ${emp.lastName}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isCurrentUser) ...[
                                const SizedBox(width: 4),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'You',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Position: ${emp.position}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Email: ${emp.companyEmail}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Mobile: ${emp.mobileNumber}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (isCurrentUser)
                                const Text(
                                  "This is your profile",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
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
