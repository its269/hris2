// Admin > Profile Edit and Add Page (Employee Model and Employee List)
import 'package:flutter/material.dart';
import 'employee_model.dart';
import 'package:uuid/uuid.dart';

class ProfileEditPage extends StatefulWidget {
  final Employee? employee;

  const ProfileEditPage({super.key, this.employee});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late Map<String, TextEditingController> controllers;
  List<Map<String, dynamic>> familyMembers = [];

  @override
  void initState() {
    super.initState();
    final emp = widget.employee;

    controllers = {
      'firstName': TextEditingController(text: emp?.firstName ?? ''),
      'middleName': TextEditingController(text: emp?.middleName ?? ''),
      'lastName': TextEditingController(text: emp?.lastName ?? ''),
      'suffix': TextEditingController(text: emp?.suffix ?? ''),
      'nickname': TextEditingController(text: emp?.nickname ?? ''),
      'birthday': TextEditingController(text: emp?.birthday ?? ''),
      'age': TextEditingController(text: emp?.age ?? ''),
      'birthPlace': TextEditingController(text: emp?.birthPlace ?? ''),
      'civilStatus': TextEditingController(text: emp?.civilStatus ?? ''),
      'companyEmail': TextEditingController(text: emp?.companyEmail ?? ''),
      'personalEmail': TextEditingController(text: emp?.personalEmail ?? ''),
      'mobileNumber': TextEditingController(text: emp?.mobileNumber ?? ''),
      'permanentAddress':
          TextEditingController(text: emp?.permanentAddress ?? ''),
      'temporaryAddress':
          TextEditingController(text: emp?.temporaryAddress ?? ''),
      'college': TextEditingController(text: emp?.college ?? ''),
      'shs': TextEditingController(text: emp?.shs ?? ''),
      'highSchool': TextEditingController(text: emp?.highSchool ?? ''),
      'bankName': TextEditingController(text: emp?.bankName ?? ''),
      'bankNumber': TextEditingController(text: emp?.bankNumber ?? ''),
      'EmployeeID': TextEditingController(text: emp?.employeeID ?? ''),
      'position': TextEditingController(text: emp?.position ?? ''),
      'branch': TextEditingController(text: emp?.branch ?? ''),
      'department': TextEditingController(text: emp?.department ?? ''),
      'dateHired': TextEditingController(text: emp?.dateHired ?? ''),
      'dateRegular': TextEditingController(text: emp?.dateRegular ?? ''),
      'employmentStatus':
          TextEditingController(text: emp?.employmentStatus ?? ''),
      'supervisor': TextEditingController(text: emp?.supervisor ?? ''),
      'role': TextEditingController(text: emp?.role ?? ''),
      'password': TextEditingController(text: emp?.password ?? ''),
    };

    familyMembers = emp?.familyMembers ?? [];
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void save() {
    if (_formKey.currentState!.validate()) {
      final typedEmployeeId = controllers['EmployeeID']?.text.trim() ?? '';
      final employeeId = (widget.employee?.employeeID != null && widget.employee!.employeeID.isNotEmpty)
          ? widget.employee!.employeeID
          : (typedEmployeeId.isNotEmpty ? typedEmployeeId : _uuid.v4());

      // Validate family members (only if any were added)
      bool hasInvalidFamilyMembers = false;
      for (var member in familyMembers) {
        if ((member['relation'] != null && member['relation'].toString().isNotEmpty) ||
            (member['name'] != null && member['name'].toString().trim().isNotEmpty)) {
          // If either field has content, both should be filled
          if (member['relation'] == null || member['relation'].toString().isEmpty ||
              member['name'] == null || member['name'].toString().trim().isEmpty) {
            hasInvalidFamilyMembers = true;
            break;
          }
        }
      }

      if (hasInvalidFamilyMembers) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete all family member information or remove incomplete entries.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Remove empty family members
      final validFamilyMembers = familyMembers.where((member) => 
        member['relation'] != null && member['relation'].toString().isNotEmpty &&
        member['name'] != null && member['name'].toString().trim().isNotEmpty
      ).toList();

      final emp = Employee(
        employeeID: employeeId,
        firstName: controllers['firstName']!.text.trim(),
        middleName: controllers['middleName']!.text.trim(),
        lastName: controllers['lastName']!.text.trim(),
        suffix: controllers['suffix']!.text.trim(),
        nickname: controllers['nickname']!.text.trim(),
        birthday: controllers['birthday']!.text.trim(),
        age: controllers['age']!.text.trim(),
        birthPlace: controllers['birthPlace']!.text.trim(),
        civilStatus: controllers['civilStatus']!.text.trim(),
        companyEmail: controllers['companyEmail']!.text.trim(),
        personalEmail: controllers['personalEmail']!.text.trim(),
        mobileNumber: controllers['mobileNumber']!.text.trim(),
        permanentAddress: controllers['permanentAddress']!.text.trim(),
        temporaryAddress: controllers['temporaryAddress']!.text.trim(),
        college: controllers['college']!.text.trim(),
        shs: controllers['shs']!.text.trim(),
        highSchool: controllers['highSchool']!.text.trim(),
        bankName: controllers['bankName']!.text.trim(),
        bankNumber: controllers['bankNumber']!.text.trim(),
        position: controllers['position']!.text.trim(),
        branch: controllers['branch']!.text.trim(),
        department: controllers['department']!.text.trim(),
        dateHired: controllers['dateHired']!.text.trim(),
        dateRegular: controllers['dateRegular']!.text.trim(),
        employmentStatus: controllers['employmentStatus']!.text.trim(),
        supervisor: controllers['supervisor']!.text.trim(),
        familyMembers: validFamilyMembers,
        role: controllers['role']!.text.trim(),
        password: controllers['password']!.text.trim(),
      );

      Navigator.pop(context, {
        'employee': emp,
        'isNew': widget.employee == null, // true if adding, false if updating
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Widget buildField(String label, String key,
      {TextInputType inputType = TextInputType.text, bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controllers[key],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: inputType,
        validator: (value) =>
            isRequired && (value == null || value.isEmpty) ? 'Required' : null,
      ),
    );
  }

  Widget buildDateField(String label, String key, {bool isRequired = true}) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate:
              DateTime.tryParse(controllers[key]?.text ?? '') ??
                  DateTime(1990),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          controllers[key]?.text =
              pickedDate.toIso8601String().split('T').first;
        }
      },
      child: AbsorbPointer(
        child: buildField(label, key, inputType: TextInputType.datetime, isRequired: isRequired),
      ),
    );
  }

  Widget buildFamilyField(int index) {
    final relations = [
      'Mother',
      'Father',
      'Brother',
      'Sister',
      'Spouse',
      'Child'
    ];
    final selectedRelation =
        relations.contains(familyMembers[index]['relation'])
            ? familyMembers[index]['relation']
            : null;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: selectedRelation,
            decoration: const InputDecoration(
              labelText: 'Relation',
              border: OutlineInputBorder(),
            ),
            items: relations
                .map(
                  (relation) => DropdownMenuItem<String>(
                      value: relation, child: Text(relation)),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                familyMembers[index]['relation'] = value;
              });
            },
            validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: familyMembers[index]['name'],
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              familyMembers[index]['name'] = value;
            },
            validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              familyMembers.removeAt(index);
            });
          },
        ),
      ],
    );
  }

  Widget buildDropdownField(
    String label,
    String key,
    List<String> options, {
    bool isRequired = true,
    }) {
      final currentValue = controllers[key]!.text;
      final validValue = options.contains(currentValue) ? currentValue : null;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          value: validValue,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items: options
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: (value) {
            setState(() {
              controllers[key]!.text = value ?? '';
            });
          },
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'Required';
            }
            return null;
          },
        ),
      );
    }
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.employee != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Profile' : 'Add Employee')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ExpansionTile(
                initiallyExpanded: true,
                leading: const Icon(Icons.person),
                title: const Text("Personal Information"),
                children: [
                  const SizedBox(height: 5),
                  buildField('First Name', 'firstName'),
                  buildField('Middle Name', 'middleName', isRequired: false),
                  buildField('Last Name', 'lastName'),
                  buildField('Suffix', 'suffix', isRequired: false),
                  buildField('Nickname', 'nickname', isRequired: false),
                  buildDateField('Birthday', 'birthday', isRequired: false),
                  buildField('Age', 'age', inputType: TextInputType.number, isRequired: false),
                  buildField('Birth Place', 'birthPlace', isRequired: false),
                  buildField('Civil Status', 'civilStatus', isRequired: false),
                  buildField('Company Email', 'companyEmail',
                      inputType: TextInputType.emailAddress),
                  buildField('Personal Email', 'personalEmail',
                      inputType: TextInputType.emailAddress, isRequired: false),
                  buildField('Mobile Number', 'mobileNumber',
                      inputType: TextInputType.phone, isRequired: false),
                  buildField('Permanent Address', 'permanentAddress', isRequired: false),
                  buildField('Temporary Address', 'temporaryAddress', isRequired: false),
                ],
              ),
              ExpansionTile(
                leading: const Icon(Icons.family_restroom),
                title: const Text("Family"),
                children: [
                  const SizedBox(height: 5),
                  ...List.generate(
                    familyMembers.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: buildFamilyField(index),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Add Family Member"),
                      onPressed: () {
                        setState(() {
                          familyMembers
                              .add({'relation': null, 'name': ''});
                        });
                      },
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                leading: const Icon(Icons.school),
                title: const Text("Education"),
                children: [
                  const SizedBox(height: 5),
                  buildField('College', 'college', isRequired: false),
                  buildField('SHS', 'shs', isRequired: false),
                  buildField('High School', 'highSchool', isRequired: false),
                ],
              ),
              ExpansionTile(
                leading: const Icon(Icons.account_balance),
                title: const Text("Bank Information"),
                children: [
                  const SizedBox(height: 5),
                  buildField('Bank Name', 'bankName', isRequired: false),
                  buildField('Bank Number', 'bankNumber', isRequired: false),
                ],
              ),
              ExpansionTile(
                leading: const Icon(Icons.work),
                title: const Text("Employment Info"),
                children: [
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: controllers['EmployeeID'],
                      decoration: const InputDecoration(
                        labelText: 'Employee ID',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: isEdit,
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Required'
                              : null,
                    ),
                  ),
                  buildField('Position', 'position'),
                  buildDropdownField('Department', 'department', [
                    'MIS',
                    'HR',
                    'Accounting',
                    'Marketing',
                    'Finance',
                    'Sales',
                    'Support',
                    'E - Commerce'
                  ]),

                  buildDropdownField('Branch', 'branch', [
                    'KGS - Main',
                    'KGS - Davao',
                    'KGS - CDO',
                  ]),

                  buildDropdownField('Employment Status', 'employmentStatus', [
                    'Probationary',
                    'Regular',
                  ]),
                  buildDateField('Date Hired', 'dateHired'),
                  buildDateField('Date Regular', 'dateRegular', isRequired: false),
                  buildField('Immediate Supervisor', 'supervisor', isRequired: false),
                  buildDropdownField('Role', 'role', [
                    'Admin',
                    'Employee',
                  ]),
                  buildField('Password', 'password'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: save,
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? 'Update Profile' : 'Add Employee'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
