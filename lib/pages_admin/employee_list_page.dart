import 'package:flutter/material.dart';
import 'employee_model.dart';
import 'profile_edit_page.dart';
import 'api_service.dart';

class EmployeeListPage extends StatefulWidget {
  final String role;
  final String employeeId; // passed from login
  final bool showAppBar;

  const EmployeeListPage({
    super.key,
    required this.role,
    required this.employeeId,
    this.showAppBar = true,
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

  final List<String> branches = ["KGS - Main", "KGS - Davao", "KGS - CDO"];

  final List<String> departments = [
    "MIS",
    "HR",
    "Accounting",
    "Marketing",
    "Finance",
    "Sales",
    "Support",
    "E - Commerce",
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
    // COMMENTED OUT: API call replaced with sample data
    /*
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
    */

    // SAMPLE DATA - Replace with actual API call later
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading

      final sampleEmployees = [
        // KGS - Main Branch Employees
        Employee(
          employeeID: 'EMP001',
          firstName: 'John',
          lastName: 'Doe',
          companyEmail: 'john.doe@kgs.com',
          mobileNumber: '+63 912 345 6789',
          branch: 'KGS - Main',
          department: 'MIS',
          position: 'IT Specialist',
          dateHired: '2023-01-15',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP002',
          firstName: 'Jane',
          lastName: 'Smith',
          companyEmail: 'jane.smith@kgs.com',
          mobileNumber: '+63 912 345 6790',
          branch: 'KGS - Main',
          department: 'HR',
          position: 'HR Manager',
          dateHired: '2022-03-20',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP003',
          firstName: 'Sarah',
          lastName: 'Williams',
          companyEmail: 'sarah.williams@kgs.com',
          mobileNumber: '+63 912 345 6792',
          branch: 'KGS - Main',
          department: 'Marketing',
          position: 'Marketing Coordinator',
          dateHired: '2023-09-05',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP004',
          firstName: 'Lisa',
          lastName: 'Davis',
          companyEmail: 'lisa.davis@kgs.com',
          mobileNumber: '+63 912 345 6794',
          branch: 'KGS - Main',
          department: 'Sales',
          position: 'Sales Representative',
          dateHired: '2023-04-18',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP005',
          firstName: 'Emily',
          lastName: 'Wilson',
          companyEmail: 'emily.wilson@kgs.com',
          mobileNumber: '+63 912 345 6796',
          branch: 'KGS - Main',
          department: 'E - Commerce',
          position: 'E-commerce Specialist',
          dateHired: '2023-02-14',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP006',
          firstName: 'Maria',
          lastName: 'Garcia',
          companyEmail: 'maria.garcia@kgs.com',
          mobileNumber: '+63 912 345 6798',
          branch: 'KGS - Main',
          department: 'Accounting',
          position: 'Senior Accountant',
          dateHired: '2022-05-10',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP007',
          firstName: 'James',
          lastName: 'Rodriguez',
          companyEmail: 'james.rodriguez@kgs.com',
          mobileNumber: '+63 912 345 6799',
          branch: 'KGS - Main',
          department: 'Finance',
          position: 'Finance Manager',
          dateHired: '2021-08-15',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP008',
          firstName: 'Anna',
          lastName: 'Martinez',
          companyEmail: 'anna.martinez@kgs.com',
          mobileNumber: '+63 912 345 6800',
          branch: 'KGS - Main',
          department: 'Support',
          position: 'Customer Support Lead',
          dateHired: '2023-03-12',
          employmentStatus: 'Active',
        ),

        // KGS - Davao Branch Employees
        Employee(
          employeeID: 'EMP009',
          firstName: 'Mike',
          lastName: 'Johnson',
          companyEmail: 'mike.johnson@kgs.com',
          mobileNumber: '+63 912 345 6791',
          branch: 'KGS - Davao',
          department: 'MIS',
          position: 'Network Administrator',
          dateHired: '2023-06-10',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP010',
          firstName: 'Robert',
          lastName: 'Miller',
          companyEmail: 'robert.miller@kgs.com',
          mobileNumber: '+63 912 345 6795',
          branch: 'KGS - Davao',
          department: 'HR',
          position: 'HR Assistant',
          dateHired: '2023-07-25',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP011',
          firstName: 'Carmen',
          lastName: 'Santos',
          companyEmail: 'carmen.santos@kgs.com',
          mobileNumber: '+63 912 345 6801',
          branch: 'KGS - Davao',
          department: 'Accounting',
          position: 'Accountant',
          dateHired: '2022-11-20',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP012',
          firstName: 'Daniel',
          lastName: 'Cruz',
          companyEmail: 'daniel.cruz@kgs.com',
          mobileNumber: '+63 912 345 6802',
          branch: 'KGS - Davao',
          department: 'Marketing',
          position: 'Marketing Specialist',
          dateHired: '2023-01-08',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP013',
          firstName: 'Patricia',
          lastName: 'Reyes',
          companyEmail: 'patricia.reyes@kgs.com',
          mobileNumber: '+63 912 345 6803',
          branch: 'KGS - Davao',
          department: 'Sales',
          position: 'Sales Executive',
          dateHired: '2023-05-15',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP014',
          firstName: 'Kevin',
          lastName: 'Torres',
          companyEmail: 'kevin.torres@kgs.com',
          mobileNumber: '+63 912 345 6804',
          branch: 'KGS - Davao',
          department: 'Finance',
          position: 'Financial Analyst',
          dateHired: '2022-12-03',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP015',
          firstName: 'Michelle',
          lastName: 'Flores',
          companyEmail: 'michelle.flores@kgs.com',
          mobileNumber: '+63 912 345 6805',
          branch: 'KGS - Davao',
          department: 'E - Commerce',
          position: 'E-commerce Assistant',
          dateHired: '2023-04-20',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP016',
          firstName: 'Richard',
          lastName: 'Hernandez',
          companyEmail: 'richard.hernandez@kgs.com',
          mobileNumber: '+63 912 345 6806',
          branch: 'KGS - Davao',
          department: 'Support',
          position: 'Technical Support',
          dateHired: '2023-02-28',
          employmentStatus: 'Active',
        ),

        // KGS - CDO Branch Employees
        Employee(
          employeeID: 'EMP017',
          firstName: 'David',
          lastName: 'Brown',
          companyEmail: 'david.brown@kgs.com',
          mobileNumber: '+63 912 345 6793',
          branch: 'KGS - CDO',
          department: 'MIS',
          position: 'Systems Analyst',
          dateHired: '2022-11-12',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP018',
          firstName: 'Jennifer',
          lastName: 'Lopez',
          companyEmail: 'jennifer.lopez@kgs.com',
          mobileNumber: '+63 912 345 6807',
          branch: 'KGS - CDO',
          department: 'HR',
          position: 'Recruitment Specialist',
          dateHired: '2023-01-30',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP019',
          firstName: 'Carlos',
          lastName: 'Valdez',
          companyEmail: 'carlos.valdez@kgs.com',
          mobileNumber: '+63 912 345 6808',
          branch: 'KGS - CDO',
          department: 'Accounting',
          position: 'Accounting Clerk',
          dateHired: '2023-06-05',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP020',
          firstName: 'Sofia',
          lastName: 'Gonzalez',
          companyEmail: 'sofia.gonzalez@kgs.com',
          mobileNumber: '+63 912 345 6809',
          branch: 'KGS - CDO',
          department: 'Marketing',
          position: 'Digital Marketing Specialist',
          dateHired: '2022-09-18',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP021',
          firstName: 'Antonio',
          lastName: 'Perez',
          companyEmail: 'antonio.perez@kgs.com',
          mobileNumber: '+63 912 345 6810',
          branch: 'KGS - CDO',
          department: 'Sales',
          position: 'Sales Manager',
          dateHired: '2021-12-10',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP022',
          firstName: 'Isabella',
          lastName: 'Morales',
          companyEmail: 'isabella.morales@kgs.com',
          mobileNumber: '+63 912 345 6811',
          branch: 'KGS - CDO',
          department: 'Finance',
          position: 'Budget Analyst',
          dateHired: '2023-03-25',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP023',
          firstName: 'Gabriel',
          lastName: 'Rivera',
          companyEmail: 'gabriel.rivera@kgs.com',
          mobileNumber: '+63 912 345 6812',
          branch: 'KGS - CDO',
          department: 'E - Commerce',
          position: 'Online Store Manager',
          dateHired: '2022-07-14',
          employmentStatus: 'Active',
        ),
        Employee(
          employeeID: 'EMP024',
          firstName: 'Natalia',
          lastName: 'Castro',
          companyEmail: 'natalia.castro@kgs.com',
          mobileNumber: '+63 912 345 6813',
          branch: 'KGS - CDO',
          department: 'Support',
          position: 'Help Desk Specialist',
          dateHired: '2023-05-02',
          employmentStatus: 'Active',
        ),

        // Admin User (Current user)
        Employee(
          employeeID: widget.employeeId, // Current user
          firstName: 'Admin',
          lastName: 'User',
          companyEmail: 'admin@kgs.com',
          mobileNumber: '+63 912 345 6797',
          branch: 'KGS - Main',
          department: 'MIS',
          position: 'System Administrator',
          dateHired: '2022-01-01',
          employmentStatus: 'Active',
        ),
      ];

      List<Employee> finalList = sampleEmployees;

      if (widget.role.toLowerCase() != 'admin') {
        // Non-admin users only see their own profile
        finalList = sampleEmployees
            .where((e) => e.employeeID == widget.employeeId)
            .toList();
      }

      setState(() {
        employees = finalList;
        filteredEmployees = finalList;
        isLoading = false;
      });

      // Initialize search to populate filteredEmployees properly
      search('');
    } catch (e) {
      setState(() {
        errorMessage = "Error loading sample data: $e";
        isLoading = false;
      });
    }
  }

  void search(String query) {
    setState(() {
      searchQuery = query.toLowerCase();

      if (selectedBranch == null && selectedDepartment == null) {
        // Global search - no branch/department filtering, search all employees
        filteredEmployees = employees.where((e) {
          final matchesName = ('${e.firstName} ${e.lastName}')
              .toLowerCase()
              .contains(searchQuery);
          final matchesId = e.employeeID.toLowerCase().contains(searchQuery);
          final matchesBranch = e.branch.toLowerCase().contains(searchQuery);
          final matchesDepartment = e.department.toLowerCase().contains(
            searchQuery,
          );
          final matchesPosition = e.position.toLowerCase().contains(
            searchQuery,
          );
          return searchQuery.isEmpty ||
              matchesName ||
              matchesId ||
              matchesBranch ||
              matchesDepartment ||
              matchesPosition;
        }).toList();
      } else if (selectedBranch != null && selectedDepartment == null) {
        // Branch selected but no department - search within branch only
        filteredEmployees = employees.where((e) {
          final matchesBranch = e.branch == selectedBranch!.name;
          final matchesName = ('${e.firstName} ${e.lastName}')
              .toLowerCase()
              .contains(searchQuery);
          final matchesId = e.employeeID.toLowerCase().contains(searchQuery);
          final matchesDepartment = e.department.toLowerCase().contains(
            searchQuery,
          );
          final matchesPosition = e.position.toLowerCase().contains(
            searchQuery,
          );
          return matchesBranch &&
              (searchQuery.isEmpty ||
                  matchesName ||
                  matchesId ||
                  matchesDepartment ||
                  matchesPosition);
        }).toList();
      } else {
        // Both branch and department selected - search within specific department
        if (selectedDepartment!.name == 'All') {
          // "Search All" from department selection - search all employees
          filteredEmployees = employees.where((e) {
            final matchesName = ('${e.firstName} ${e.lastName}')
                .toLowerCase()
                .contains(searchQuery);
            final matchesId = e.employeeID.toLowerCase().contains(searchQuery);
            final matchesBranch = e.branch.toLowerCase().contains(searchQuery);
            final matchesDepartment = e.department.toLowerCase().contains(
              searchQuery,
            );
            final matchesPosition = e.position.toLowerCase().contains(
              searchQuery,
            );
            return searchQuery.isEmpty ||
                matchesName ||
                matchesId ||
                matchesBranch ||
                matchesDepartment ||
                matchesPosition;
          }).toList();
        } else {
          // Specific department selected - search within that department and branch
          filteredEmployees = employees.where((e) {
            final matchesBranch = e.branch == selectedBranch!.name;
            final matchesDepartment = e.department == selectedDepartment!.name;
            final matchesName = ('${e.firstName} ${e.lastName}')
                .toLowerCase()
                .contains(searchQuery);
            final matchesId = e.employeeID.toLowerCase().contains(searchQuery);
            final matchesPosition = e.position.toLowerCase().contains(
              searchQuery,
            );
            return matchesBranch &&
                matchesDepartment &&
                (searchQuery.isEmpty ||
                    matchesName ||
                    matchesId ||
                    matchesPosition);
          }).toList();
        }
      }
    });
  }

  void addOrUpdateEmployee(Employee emp) async {
    // COMMENTED OUT: CRUD operations disabled for demo
    /*
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
    */

    // PLACEHOLDER: Show demo message
    _showSnackBar(
      "Demo Mode: Employee operations are currently disabled",
      isError: false,
    );
  }

  void deleteEmployee(String id) async {
    // COMMENTED OUT: Delete operations disabled for demo
    /*
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
    */

    // PLACEHOLDER: Show demo message
    _showSnackBar(
      "Demo Mode: Delete operations are currently disabled",
      isError: false,
    );
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text(errorMessage!)));
    }

    // For embedded mode (side navigation), show simplified view
    if (!widget.showAppBar) {
      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.3,
                children: [
                  _buildQuickEmployeeCard(
                    context,
                    'All Employees',
                    'View all profiles',
                    Icons.people,
                    Colors.blue,
                  ),
                  _buildQuickEmployeeCard(
                    context,
                    'Departments',
                    'Browse by dept',
                    Icons.apartment,
                    Colors.orange,
                  ),
                  _buildQuickEmployeeCard(
                    context,
                    'Reports',
                    'Employee stats',
                    Icons.analytics,
                    Colors.purple,
                  ),
                  _buildQuickEmployeeCard(
                    context,
                    'Search',
                    'Find employees',
                    Icons.search,
                    Colors.teal,
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: widget.role.toLowerCase() == 'admin'
            ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileEditPage()),
                  );
                  if (result != null && result['employee'] != null) {
                    addOrUpdateEmployee(result['employee']);
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                child: const Icon(Icons.add_rounded),
              )
            : null,
      );
    }

    if (selectedBranch == null) return _buildBranchSelection();
    if (selectedDepartment == null) return _buildDepartmentSelection();
    return _buildEmployeeList();
  }

  Widget _buildBranchSelection() {
    final colorScheme = Theme.of(context).colorScheme;

    // If searching, show full-page search results
    if (searchQuery.isNotEmpty) {
      return _buildSearchResultsPage();
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Icon(Icons.business,
      //            color: colorScheme.onPrimaryContainer,
      //            size: 24),
      //       const SizedBox(width: 8),
      //       const Text("Select Branch"),
      //     ],
      //   ),
      //   backgroundColor: colorScheme.primaryContainer,
      //   foregroundColor: colorScheme.onPrimaryContainer,
      // ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Global Search Section
          Card(
            elevation: 3,
            color: colorScheme.primaryContainer.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by name, ID, position, department...",
                      hintStyle: TextStyle(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                    onChanged: search,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Branch browsing section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Browse by branch:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...branches.map((branch) {
            final branchEmployeeCount = employees
                .where((e) => e.branch == branch)
                .length;
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_tree_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  branch,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  '$branchEmployeeCount employee${branchEmployeeCount != 1 ? 's' : ''}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.primary,
                  size: 16,
                ),
                onTap: () => setState(() {
                  selectedBranch = Branch(branch);
                  search(''); // Reset search when changing branch
                }),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: widget.role.toLowerCase() == 'admin'
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileEditPage()),
                );
                if (result != null && result['employee'] != null) {
                  addOrUpdateEmployee(result['employee']);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              child: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  Widget _buildSearchResultsPage() {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Icon(Icons.search_rounded,
      //            color: colorScheme.onPrimaryContainer,
      //            size: 24),
      //       const SizedBox(width: 8),
      //       const Text("Search Results"),
      //     ],
      //   ),
      //   backgroundColor: colorScheme.primaryContainer,
      //   foregroundColor: colorScheme.onPrimaryContainer,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       _searchController.clear();
      //       search('');
      //     },
      //   ),
      // ),
      body: Column(
        children: [
          // Sticky search bar
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 3,
              color: colorScheme.primaryContainer.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search by name, ID, position, department...",
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        search('');
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
                  onChanged: search,
                ),
              ),
            ),
          ),

          // Search results header
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Search results (${filteredEmployees.length} found):',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Search results list
          Expanded(
            child: filteredEmployees.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: colorScheme.onSurfaceVariant.withOpacity(
                              0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No employees found for "$searchQuery"',
                            style: TextStyle(
                              fontSize: 18,
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try searching with different keywords like employee name, ID, position, department, or branch.',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant.withOpacity(
                                0.7,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = filteredEmployees[index];
                      return _buildSearchResultCard(employee);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(Employee employee) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCurrentUser = employee.employeeID == widget.employeeId;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: isCurrentUser
              ? colorScheme.primary
              : colorScheme.primaryContainer,
          radius: 20,
          child: Icon(
            isCurrentUser ? Icons.account_circle_rounded : Icons.person_rounded,
            color: isCurrentUser
                ? colorScheme.onPrimary
                : colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "${employee.firstName} ${employee.lastName}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (isCurrentUser) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'You',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
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
            const SizedBox(height: 4),
            Text(
              'ID: ${employee.employeeID} • ${employee.position}',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${employee.branch} • ${employee.department}',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 13,
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
                    icon: Icon(Icons.edit_rounded, color: colorScheme.primary),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileEditPage(employee: employee),
                        ),
                      );
                      if (result != null && result['employee'] != null) {
                        addOrUpdateEmployee(result['employee']);
                      }
                    },
                  ),
                  if (!isCurrentUser)
                    IconButton(
                      icon: Icon(
                        Icons.delete_rounded,
                        color: colorScheme.error,
                      ),
                      onPressed: () => confirmDelete(context, employee),
                    ),
                ],
              )
            : Icon(
                Icons.arrow_forward_ios_rounded,
                color: colorScheme.primary,
                size: 16,
              ),
        onTap: () async {
          if (widget.role.toLowerCase() != 'admin') {
            // Non-admin users can only view their profile
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileEditPage(employee: employee),
              ),
            );
            if (result != null && result['employee'] != null) {
              addOrUpdateEmployee(result['employee']);
            }
          }
        },
      ),
    );
  }

  Widget _buildDepartmentSelection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.apartment,
              color: colorScheme.onPrimaryContainer,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(selectedBranch!.name)),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => selectedBranch = null),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Global Search Option
          Card(
            elevation: 3,
            color: colorScheme.primaryContainer.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              title: Text(
                'Search All Employees',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colorScheme.primary,
                ),
              ),
              subtitle: Text(
                'Search across all departments and branches',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
              onTap: () => setState(() {
                selectedDepartment = Department('All');
                search(''); // Reset search when selecting "Search All"
              }),
            ),
          ),

          const SizedBox(height: 16),

          // Section Header for Department Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Icon(
                  Icons.business_center_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Department:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ...departments.map((dept) {
            final deptEmployeeCount = employees
                .where(
                  (e) =>
                      e.branch == selectedBranch!.name && e.department == dept,
                )
                .length;
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.business_center_rounded,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  dept,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  '$deptEmployeeCount employee${deptEmployeeCount != 1 ? 's' : ''}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.primary,
                  size: 16,
                ),
                onTap: () => setState(() {
                  selectedDepartment = Department(dept);
                  search(''); // Reset search when changing department
                }),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: widget.role.toLowerCase() == 'admin'
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileEditPage()),
                );
                if (result != null && result['employee'] != null) {
                  addOrUpdateEmployee(result['employee']);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              child: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  Widget _buildEmployeeList() {
    // Handle "Search All" case
    final deptEmployees = selectedDepartment!.name == 'All'
        ? filteredEmployees // Show all filtered employees across all departments/branches
        : filteredEmployees
              .where(
                (e) =>
                    e.branch == selectedBranch!.name &&
                    e.department == selectedDepartment!.name,
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.people,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedDepartment!.name == 'All'
                    ? "All Employees"
                    : "${selectedDepartment!.name} - ${selectedBranch!.name}",
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => selectedDepartment = null),
        ),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: selectedDepartment!.name == 'All'
                    ? "Search by employee name or ID..."
                    : "Search employees in ${selectedDepartment!.name} by name or ID...",
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          search('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                          searchQuery.isNotEmpty
                              ? Icons.search_off
                              : Icons.people_outline,
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
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        color: isCurrentUser
                            ? Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withOpacity(0.3)
                            : Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isCurrentUser
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            child: Icon(
                              isCurrentUser
                                  ? Icons.account_circle
                                  : Icons.person,
                              color: isCurrentUser
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ),
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'You',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
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
                                Text(
                                  "This is your profile",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                                      icon: Icon(
                                        Icons.edit_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ProfileEditPage(employee: emp),
                                          ),
                                        );
                                        if (result != null &&
                                            result['employee'] != null) {
                                          addOrUpdateEmployee(
                                            result['employee'],
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
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
                  MaterialPageRoute(builder: (_) => const ProfileEditPage()),
                );
                if (result != null && result['employee'] != null) {
                  addOrUpdateEmployee(result['employee']);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              child: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  Widget _buildQuickEmployeeCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (title == 'All Employees') {
            // Navigate to employee list with full app bar
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EmployeeListPage(
                  role: widget.role,
                  employeeId: widget.employeeId,
                  showAppBar: true,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title feature coming soon!')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
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
