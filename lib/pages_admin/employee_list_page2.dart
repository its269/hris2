
import 'package:flutter/material.dart';
import 'employee_model.dart';
import 'profile_edit_page.dart';
import 'package:uuid/uuid.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final List<Employee> employees = [
    Employee(
      id: const Uuid().v4(),
      firstName: 'John Paul',
      middleName: 'Delos Reyes',
      lastName: 'Polendey',
      suffix: '',
      nickname: 'JP',
      birthday: 'Nov 26',
      age: 'Secret',
      birthPlace: 'Badoc, Ilocos Norte',
      civilStatus: 'Single',
      companyEmail: 'creatives03@kelinph.com',
      personalEmail: 'johnpaulpolendey22@gmail.com',
      mobileNumber: '',
      permanentAddress: 'Caloocan City',
      temporaryAddress: 'N/A',
      mother: 'Maribel Delos Reyes',
      father: 'Mark Zuckerberg',
      brother: 'Christian Polendey',
      college: 'UCC',
      shs: 'OLFU',
      highSchool: 'BHS',
      bankName: 'John Paul D. Polendey',
      bankNumber: '**** **** **** ****',
      eeId: 'KG-0751',
      position: 'Front-End Dev.',
      department: 'MIS',
      dateHired: '08 - 13 - 2024',
      dateRegular: '01 - 09 - 2025',
      employmentStatus: 'Regular',
      supervisor: 'Joyce S. Cambel',
      familyMembers: [
        {'relation': 'Mother', 'name': 'Maribel Delos Reyes'},
        {'relation': 'Father', 'name': 'Mark Zuckerberg'},
        {'relation': 'Brother', 'name': 'Christian Polendey'},
      ],
    ),
  ];

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
      appBar: AppBar(title: const Text('Employee Directory')),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          return ListTile(
            title: Text('${emp.firstName} ${emp.lastName}'),
            subtitle: Text(emp.position),
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
