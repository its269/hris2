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
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<Branch> branches = [
    Branch(
      name: "Kelin Graphics System - Main",
      departments: [
        Department(name: "IT", Employees: generateEmployees()),
        Department(name: "Marketing", Employees: generateEmployees()),
        Department(name: "Accounting", Employees: generateEmployees()),
        Department(name: "E - Commerce", Employees: generateEmployees()),
      ],
    ),
    Branch(
      name: "Kelin Graphics System - CDO",
      departments: [
        Department(name: "HR", Employees: generateEmployees()),
        Department(name: "Finance", Employees: generateEmployees()),
      ],
    ),
    Branch(
      name: "Kelin Graphics System - Davao",
      departments: [
        Department(name: "Sales", Employees: generateEmployees()),
        Department(name: "Support", Employees: generateEmployees()),
      ],
    ),
  ];

  Branch? selectedBranch;
  Department? selectedDepartment;

  static List<Employee> generateEmployees() {
    final Random random = Random();
    final List<String> statusList = ['Present', 'Absent', 'Leave'];
    final List<Employee> Employees = [];

    for (int i = 1; i <= 5; i++) {
      final employeeName = "Employee $i";
      final attendanceRecords = <AttendanceRecord>[];

      for (int j = 1; j <= 30; j++) {
        final status = statusList[random.nextInt(statusList.length)];
        final inTime = status == 'Present'
            ? "09:${random.nextInt(60).toString().padLeft(2, '0')} AM"
            : "-";
        final outTime = status == 'Present'
            ? "05:${random.nextInt(60).toString().padLeft(2, '0')} PM"
            : "-";

        attendanceRecords.add(
          AttendanceRecord(
            date: "2025-07-${j.toString().padLeft(2, '0')}",
            inTime: inTime,
            outTime: outTime,
            status: status,
          ),
        );
      }

      Employees.add(
        Employee(name: employeeName, attendanceRecords: attendanceRecords),
      );
    }
    return Employees;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedBranch == null) return _buildBranchSelection();
    if (selectedDepartment == null) return _buildDepartmentSelection();
    return _buildAttendanceRecords();
  }

  Widget _buildBranchSelection() {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose a Branch")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: branches.length,
        itemBuilder: (context, index) {
          final branch = branches[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: Text(branch.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => setState(() => selectedBranch = branch),
            ),
          );
        },
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
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: selectedBranch!.departments.length,
        itemBuilder: (context, index) {
          final department = selectedBranch!.departments[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.business_center_outlined),
              title: Text(department.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => setState(() => selectedDepartment = department),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttendanceRecords() {
    return Scaffold(
      appBar: AppBar(
        title: Text("${selectedDepartment!.name} Attendance"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => selectedDepartment = null),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: selectedDepartment!.Employees.length,
          itemBuilder: (context, index) {
            final Employee = selectedDepartment!.Employees[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(Employee.name),
                children: Employee.attendanceRecords
                    .map(_buildAttendanceTile)
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAttendanceTile(AttendanceRecord record) {
    final Color statusColor = switch (record.status) {
      'Present' => Colors.green,
      'Leave' => Colors.orange,
      'Absent' => Colors.red,
      _ => Colors.grey,
    };

    return ListTile(
      title: Text(record.date),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("In: ${record.inTime}"),
          Text("Out: ${record.outTime}"),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          border: Border.all(color: statusColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          record.status,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
        ),
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
  final List<AttendanceRecord> attendanceRecords;

  Employee({required this.name, required this.attendanceRecords});
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
