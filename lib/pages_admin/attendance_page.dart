// Admin > Attendance Per Branch
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const AttendancePage(),
    ),
  );
}

class AttendancePage extends StatefulWidget {
  final bool showAppBar;
  final String? initialBranch;

  const AttendancePage({super.key, this.showAppBar = true, this.initialBranch});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<Branch> branches = [
    Branch(
      name: "KGS - Main",
      departments: [
        Department(
          name: "MIS",
          Employees: generateEmployeesForDepartment("KGS - Main", "MIS"),
        ),
        Department(
          name: "HR",
          Employees: generateEmployeesForDepartment("KGS - Main", "HR"),
        ),
        Department(
          name: "Marketing",
          Employees: generateEmployeesForDepartment("KGS - Main", "Marketing"),
        ),
        Department(
          name: "Accounting",
          Employees: generateEmployeesForDepartment("KGS - Main", "Accounting"),
        ),
        Department(
          name: "Finance",
          Employees: generateEmployeesForDepartment("KGS - Main", "Finance"),
        ),
        Department(
          name: "Sales",
          Employees: generateEmployeesForDepartment("KGS - Main", "Sales"),
        ),
        Department(
          name: "Support",
          Employees: generateEmployeesForDepartment("KGS - Main", "Support"),
        ),
        Department(
          name: "E - Commerce",
          Employees: generateEmployeesForDepartment(
            "KGS - Main",
            "E - Commerce",
          ),
        ),
      ],
    ),
    Branch(
      name: "KGS - CDO",
      departments: [
        Department(
          name: "MIS",
          Employees: generateEmployeesForDepartment("KGS - CDO", "MIS"),
        ),
        Department(
          name: "HR",
          Employees: generateEmployeesForDepartment("KGS - CDO", "HR"),
        ),
        Department(
          name: "Marketing",
          Employees: generateEmployeesForDepartment("KGS - CDO", "Marketing"),
        ),
        Department(
          name: "Accounting",
          Employees: generateEmployeesForDepartment("KGS - CDO", "Accounting"),
        ),
        Department(
          name: "Finance",
          Employees: generateEmployeesForDepartment("KGS - CDO", "Finance"),
        ),
        Department(
          name: "Sales",
          Employees: generateEmployeesForDepartment("KGS - CDO", "Sales"),
        ),
        Department(
          name: "Support",
          Employees: generateEmployeesForDepartment("KGS - CDO", "Support"),
        ),
        Department(
          name: "E - Commerce",
          Employees: generateEmployeesForDepartment(
            "KGS - CDO",
            "E - Commerce",
          ),
        ),
      ],
    ),
    Branch(
      name: "KGS - Davao",
      departments: [
        Department(
          name: "MIS",
          Employees: generateEmployeesForDepartment("KGS - Davao", "MIS"),
        ),
        Department(
          name: "HR",
          Employees: generateEmployeesForDepartment("KGS - Davao", "HR"),
        ),
        Department(
          name: "Marketing",
          Employees: generateEmployeesForDepartment("KGS - Davao", "Marketing"),
        ),
        Department(
          name: "Accounting",
          Employees: generateEmployeesForDepartment(
            "KGS - Davao",
            "Accounting",
          ),
        ),
        Department(
          name: "Finance",
          Employees: generateEmployeesForDepartment("KGS - Davao", "Finance"),
        ),
        Department(
          name: "Sales",
          Employees: generateEmployeesForDepartment("KGS - Davao", "Sales"),
        ),
        Department(
          name: "Support",
          Employees: generateEmployeesForDepartment("KGS - Davao", "Support"),
        ),
        Department(
          name: "E - Commerce",
          Employees: generateEmployeesForDepartment(
            "KGS - Davao",
            "E - Commerce",
          ),
        ),
      ],
    ),
  ];

  Branch? selectedBranch;
  Department? selectedDepartment;
  String _searchQuery = '';
  final List<Employee> _searchResults = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If initialBranch is provided, pre-select it
    if (widget.initialBranch != null) {
      selectedBranch = branches.firstWhere(
        (branch) => branch.name == widget.initialBranch,
        orElse: () => branches.first,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Sample employee data matching the employee_list_page.dart structure
  static final Map<String, Map<String, List<Map<String, String>>>>
  employeeData = {
    "KGS - Main": {
      "MIS": [
        {"id": "EMP001", "name": "John Doe", "position": "IT Specialist"},
        {
          "id": "EMP025",
          "name": "Admin User",
          "position": "System Administrator",
        },
      ],
      "HR": [
        {"id": "EMP002", "name": "Jane Smith", "position": "HR Manager"},
      ],
      "Marketing": [
        {
          "id": "EMP003",
          "name": "Sarah Williams",
          "position": "Marketing Coordinator",
        },
      ],
      "Sales": [
        {
          "id": "EMP004",
          "name": "Lisa Davis",
          "position": "Sales Representative",
        },
      ],
      "E - Commerce": [
        {
          "id": "EMP005",
          "name": "Emily Wilson",
          "position": "E-commerce Specialist",
        },
      ],
      "Accounting": [
        {
          "id": "EMP006",
          "name": "Maria Garcia",
          "position": "Senior Accountant",
        },
      ],
      "Finance": [
        {
          "id": "EMP007",
          "name": "James Rodriguez",
          "position": "Finance Manager",
        },
      ],
      "Support": [
        {
          "id": "EMP008",
          "name": "Anna Martinez",
          "position": "Customer Support Lead",
        },
      ],
    },
    "KGS - Davao": {
      "MIS": [
        {
          "id": "EMP009",
          "name": "Mike Johnson",
          "position": "Network Administrator",
        },
      ],
      "HR": [
        {"id": "EMP010", "name": "Robert Miller", "position": "HR Assistant"},
      ],
      "Accounting": [
        {"id": "EMP011", "name": "Carmen Santos", "position": "Accountant"},
      ],
      "Marketing": [
        {
          "id": "EMP012",
          "name": "Daniel Cruz",
          "position": "Marketing Specialist",
        },
      ],
      "Sales": [
        {
          "id": "EMP013",
          "name": "Patricia Reyes",
          "position": "Sales Executive",
        },
      ],
      "Finance": [
        {
          "id": "EMP014",
          "name": "Kevin Torres",
          "position": "Financial Analyst",
        },
      ],
      "E - Commerce": [
        {
          "id": "EMP015",
          "name": "Michelle Flores",
          "position": "E-commerce Assistant",
        },
      ],
      "Support": [
        {
          "id": "EMP016",
          "name": "Richard Hernandez",
          "position": "Technical Support",
        },
      ],
    },
    "KGS - CDO": {
      "MIS": [
        {"id": "EMP017", "name": "David Brown", "position": "Systems Analyst"},
      ],
      "HR": [
        {
          "id": "EMP018",
          "name": "Jennifer Lopez",
          "position": "Recruitment Specialist",
        },
      ],
      "Accounting": [
        {
          "id": "EMP019",
          "name": "Carlos Valdez",
          "position": "Accounting Clerk",
        },
      ],
      "Marketing": [
        {
          "id": "EMP020",
          "name": "Sofia Gonzalez",
          "position": "Digital Marketing Specialist",
        },
      ],
      "Sales": [
        {"id": "EMP021", "name": "Antonio Perez", "position": "Sales Manager"},
      ],
      "Finance": [
        {
          "id": "EMP022",
          "name": "Isabella Morales",
          "position": "Budget Analyst",
        },
      ],
      "E - Commerce": [
        {
          "id": "EMP023",
          "name": "Gabriel Rivera",
          "position": "Online Store Manager",
        },
      ],
      "Support": [
        {
          "id": "EMP024",
          "name": "Natalia Castro",
          "position": "Help Desk Specialist",
        },
      ],
    },
  };

  static List<Employee> generateEmployeesForDepartment(
    String branch,
    String department,
  ) {
    final Random random = Random();
    final List<String> statusList = ['Present', 'Absent', 'Leave', 'Late'];
    final List<Employee> employees = [];

    // Get employees for specific branch and department
    final branchData = employeeData[branch];
    if (branchData == null) return employees;

    final deptData = branchData[department];
    if (deptData == null) return employees;

    for (final empData in deptData) {
      final employeeName = empData['name']!;
      final employeeId = empData['id']!;
      final position = empData['position']!;
      final attendanceRecords = <AttendanceRecord>[];

      // Generate attendance for the last 30 days
      for (int j = 1; j <= 30; j++) {
        final status = statusList[random.nextInt(statusList.length)];
        String inTime = "-";
        String outTime = "-";

        switch (status) {
          case 'Present':
            // Regular work hours: 8:00 AM - 5:00 PM with some variation
            final inHour = 8 + random.nextInt(2); // 8-9 AM
            final inMinute = random.nextInt(60);
            final outHour = 17 + random.nextInt(2); // 5-6 PM
            final outMinute = random.nextInt(60);

            inTime =
                "${inHour.toString().padLeft(2, '0')}:${inMinute.toString().padLeft(2, '0')} ${inHour < 12 ? 'AM' : 'PM'}";
            outTime =
                "${outHour.toString().padLeft(2, '0')}:${outMinute.toString().padLeft(2, '0')} PM";
            break;
          case 'Late':
            // Late arrival: 9:30 AM - 11:00 AM
            final inHour = 9 + random.nextInt(2);
            final inMinute = 30 + random.nextInt(30);
            final outHour = 17 + random.nextInt(2);
            final outMinute = random.nextInt(60);

            inTime =
                "${inHour.toString().padLeft(2, '0')}:${inMinute.toString().padLeft(2, '0')} ${inHour < 12 ? 'AM' : 'PM'}";
            outTime =
                "${outHour.toString().padLeft(2, '0')}:${outMinute.toString().padLeft(2, '0')} PM";
            break;
          case 'Leave':
            inTime = "On Leave";
            outTime = "On Leave";
            break;
          case 'Absent':
            inTime = "Absent";
            outTime = "Absent";
            break;
        }

        attendanceRecords.add(
          AttendanceRecord(
            date: "2025-08-${j.toString().padLeft(2, '0')}",
            inTime: inTime,
            outTime: outTime,
            status: status,
          ),
        );
      }

      employees.add(
        Employee(
          name: employeeName,
          employeeId: employeeId,
          position: position,
          attendanceRecords: attendanceRecords,
        ),
      );
    }
    return employees;
  }

  // Search functionality methods
  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        _searchResults.clear();
        return;
      }

      // Search across all branches and departments
      _searchResults.clear();
      final lowercaseQuery = query.toLowerCase();

      for (final branch in branches) {
        for (final department in branch.departments) {
          for (final employee in department.Employees) {
            // Search by name, ID, position, or branch
            if (employee.name.toLowerCase().contains(lowercaseQuery) ||
                employee.employeeId.toLowerCase().contains(lowercaseQuery) ||
                employee.position.toLowerCase().contains(lowercaseQuery) ||
                department.name.toLowerCase().contains(lowercaseQuery) ||
                branch.name.toLowerCase().contains(lowercaseQuery)) {
              _searchResults.add(employee);
            }
          }
        }
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _isSearching = false;
      _searchResults.clear();
      _searchController.clear();
    });
  }

  Widget _buildSearchResultCard(Employee employee) {
    final colorScheme = Theme.of(context).colorScheme;

    // Find the branch and department for this employee
    String? employeeBranch;
    String? employeeDepartment;

    for (final branch in branches) {
      for (final department in branch.departments) {
        if (department.Employees.contains(employee)) {
          employeeBranch = branch.name;
          employeeDepartment = department.name;
          break;
        }
      }
      if (employeeBranch != null) break;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.person_rounded,
            color: colorScheme.tertiary,
            size: 24,
          ),
        ),
        title: Text(
          employee.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'ID: ${employee.employeeId} • ${employee.position}',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$employeeBranch • $employeeDepartment',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.schedule_rounded,
          color: colorScheme.tertiary,
          size: 20,
        ),
        onTap: () => _showEmployeeAttendanceDialog(employee),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Always show unified attendance view (both embedded and full screen modes)
    if (selectedBranch == null) return _buildBranchSelection();
    if (selectedDepartment == null) return _buildDepartmentSelection();
    return _buildAttendanceView();
  }

  Widget _buildBranchSelection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text("Attendance Records"),
                ],
              ),
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
            )
          : null,
      body: Column(
        children: [
          // STICKY Global Search Bar - This will always stay at the top
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 4,
              color: colorScheme.primaryContainer.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                        "Search employees by name, ID, position, or department...",
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            onPressed: _clearSearch,
                          )
                        : null,
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
                  onChanged: _performSearch,
                ),
              ),
            ),
          ),

          // Search results indicator if searching
          if (_isSearching)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: colorScheme.primaryContainer.withOpacity(0.1),
              child: Text(
                'Found ${_searchResults.length} employee${_searchResults.length != 1 ? 's' : ''} matching "$_searchQuery"',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Scrollable content below the fixed search bar
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // Show search results when searching, otherwise show branches
                if (_isSearching) ...[
                  // Search results
                  if (_searchResults.isEmpty)
                    Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: colorScheme.onSurfaceVariant.withOpacity(
                                0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No employees found for "$_searchQuery"',
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurfaceVariant,
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
                  else
                    ..._searchResults.map(
                      (employee) => _buildSearchResultCard(employee),
                    ),
                ] else ...[
                  // Section Header for Branch Selection
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
                    final branchEmployeeCount = branch.departments.fold(
                      0,
                      (sum, dept) => sum + dept.Employees.length,
                    );
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
                            color: colorScheme.primaryContainer.withOpacity(
                              0.3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.account_tree_rounded,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          branch.name,
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
                          selectedBranch = branch;
                        }),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
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
                  'Select department:',
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

          ...selectedBranch!.departments
              .where((dept) => dept.Employees.isNotEmpty)
              .map((dept) {
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
                        color: colorScheme.secondaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.business_center_rounded,
                        color: colorScheme.secondary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      dept.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      '${dept.Employees.length} employee${dept.Employees.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colorScheme.secondary,
                      size: 16,
                    ),
                    onTap: () => setState(() {
                      selectedDepartment = dept;
                    }),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _buildAttendanceView() {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.schedule,
              color: colorScheme.onPrimaryContainer,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text("${selectedDepartment!.name} Attendance")),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            selectedDepartment = null;
            _clearSearch(); // Clear search when going back
          }),
        ),
      ),
      body: Column(
        children: [
          // Department info card (scrolls away)
          Container(
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.people_rounded,
                          color: colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedDepartment!.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${selectedBranch!.name} • ${selectedDepartment!.Employees.length} employee${selectedDepartment!.Employees.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sticky search bar
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Card(
              elevation: 4,
              color: colorScheme.primaryContainer.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search employees by name, ID, or position...",
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            onPressed: _clearSearch,
                          )
                        : null,
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
                  onChanged: _performSearch,
                ),
              ),
            ),
          ),

          // Search results indicator if searching
          if (_isSearching)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: colorScheme.primaryContainer.withOpacity(0.1),
              child: Text(
                'Found ${_getFilteredEmployees().length} employee${_getFilteredEmployees().length != 1 ? 's' : ''} matching "$_searchQuery"',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Employee list - This will scroll under the fixed search bar
          Expanded(child: _buildEmployeeListView(selectedDepartment!)),
        ],
      ),
    );
  }

  Widget _buildEmployeeListView(Department department) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayEmployees = _getFilteredEmployees();

    if (displayEmployees.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isSearching ? Icons.search_off_rounded : Icons.people_outline,
                size: 64,
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                _isSearching
                    ? 'No employees found matching "$_searchQuery"'
                    : 'No employees in this department',
                style: TextStyle(
                  fontSize: 18,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              if (_isSearching) ...[
                const SizedBox(height: 8),
                Text(
                  'Try searching with different keywords like employee name, ID, or position.',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: displayEmployees.length,
      itemBuilder: (context, index) {
        final employee = displayEmployees[index];

        // Calculate attendance summary
        final presentDays = employee.attendanceRecords
            .where((r) => r.status == 'Present')
            .length;
        final lateDays = employee.attendanceRecords
            .where((r) => r.status == 'Late')
            .length;
        final leaveDays = employee.attendanceRecords
            .where((r) => r.status == 'Leave')
            .length;
        final absentDays = employee.attendanceRecords
            .where((r) => r.status == 'Absent')
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
            leading: CircleAvatar(
              backgroundColor: colorScheme.primaryContainer,
              radius: 20,
              child: Text(
                employee.employeeId.substring(employee.employeeId.length - 2),
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(
              employee.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${employee.employeeId} • ${employee.position}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildStatusChip('Present', presentDays, Colors.green),
                    _buildStatusChip('Late', lateDays, Colors.amber),
                    _buildStatusChip('Leave', leaveDays, Colors.orange),
                    _buildStatusChip('Absent', absentDays, Colors.red),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              Icons.schedule_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
            onTap: () => _showEmployeeAttendanceDialog(employee),
          ),
        );
      },
    );
  }

  List<Employee> _getFilteredEmployees() {
    if (!_isSearching) return selectedDepartment!.Employees;

    return selectedDepartment!.Employees
        .where(
          (emp) =>
              emp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              emp.employeeId.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              emp.position.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void _showEmployeeAttendanceDialog(Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                radius: 20,
                child: Text(
                  employee.employeeId.substring(employee.employeeId.length - 2),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${employee.employeeId} • ${employee.position}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                // Summary row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatusChip(
                      'P',
                      employee.attendanceRecords
                          .where((r) => r.status == 'Present')
                          .length,
                      Colors.green,
                    ),
                    _buildStatusChip(
                      'L',
                      employee.attendanceRecords
                          .where((r) => r.status == 'Late')
                          .length,
                      Colors.amber,
                    ),
                    _buildStatusChip(
                      'V',
                      employee.attendanceRecords
                          .where((r) => r.status == 'Leave')
                          .length,
                      Colors.orange,
                    ),
                    _buildStatusChip(
                      'A',
                      employee.attendanceRecords
                          .where((r) => r.status == 'Absent')
                          .length,
                      Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                // Attendance records list
                Expanded(
                  child: ListView.builder(
                    itemCount: employee.attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final record = employee.attendanceRecords[index];
                      return _buildAttendanceDetailTile(record);
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label:$count',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAttendanceDetailTile(AttendanceRecord record) {
    final Color statusColor = switch (record.status) {
      'Present' => Colors.green,
      'Late' => Colors.amber,
      'Leave' => Colors.orange,
      'Absent' => Colors.red,
      _ => Colors.grey,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(record.date, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: record.status == 'Present' || record.status == 'Late'
                ? Text(
                    '${record.inTime} - ${record.outTime}',
                    style: const TextStyle(fontSize: 11),
                  )
                : Text(
                    record.status,
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              record.status,
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Models
class Branch {
  final String name;
  final List<Department> departments;

  Branch({required this.name, required this.departments});
}

class Department {
  final String name;
  final List<Employee> Employees;

  Department({required this.name, required this.Employees});
}

class Employee {
  final String name;
  final String employeeId;
  final String position;
  final List<AttendanceRecord> attendanceRecords;

  Employee({
    required this.name,
    required this.employeeId,
    required this.position,
    required this.attendanceRecords,
  });
}

class AttendanceRecord {
  final String date;
  final String inTime;
  final String outTime;
  final String status;

  AttendanceRecord({
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.status,
  });
}
