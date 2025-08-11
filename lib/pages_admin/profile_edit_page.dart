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

      final emp = Employee(
        employeeID: employeeId,
        firstName: controllers['firstName']!.text,
        middleName: controllers['middleName']!.text,
        lastName: controllers['lastName']!.text,
        suffix: controllers['suffix']!.text,
        nickname: controllers['nickname']!.text,
        birthday: controllers['birthday']!.text,
        age: controllers['age']!.text,
        birthPlace: controllers['birthPlace']!.text,
        civilStatus: controllers['civilStatus']!.text,
        companyEmail: controllers['companyEmail']!.text,
        personalEmail: controllers['personalEmail']!.text,
        mobileNumber: controllers['mobileNumber']!.text,
        permanentAddress: controllers['permanentAddress']!.text,
        temporaryAddress: controllers['temporaryAddress']!.text,
        college: controllers['college']!.text,
        shs: controllers['shs']!.text,
        highSchool: controllers['highSchool']!.text,
        bankName: controllers['bankName']!.text,
        bankNumber: controllers['bankNumber']!.text,
        position: controllers['position']!.text,
        branch: controllers['branch']!.text,
        department: controllers['department']!.text,
        dateHired: controllers['dateHired']!.text,
        dateRegular: controllers['dateRegular']!.text,
        employmentStatus: controllers['employmentStatus']!.text,
        supervisor: controllers['supervisor']!.text,
        familyMembers: familyMembers,
        role: controllers['role']!.text,
        password: controllers['password']!.text,
      );

      Navigator.pop(context, {
        'employee': emp,
        'isNew': widget.employee == null, // true if adding, false if updating
      });
    }
  }


  Widget buildField(String label, String key,
      {TextInputType inputType = TextInputType.text, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controllers[key],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: inputType,
        validator: isRequired
            ? (value) => value == null || value.isEmpty ? 'Required' : null
            : null,
      ),
    );
  }

  Widget buildDateField(String label, String key, {bool isRequired = false}) {
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
                .toSet()
                .map(
                  (relation) => DropdownMenuItem(
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
      // Get the current value from the controller
      String currentValue = controllers[key]!.text.trim();
      
      // Create a complete list of options including the current value if it's not already in the list
      List<String> allOptions = List.from(options);
      if (currentValue.isNotEmpty && !allOptions.contains(currentValue)) {
        allOptions.add(currentValue);
      }
      
      // Remove duplicates and ensure unique values
      allOptions = allOptions.toSet().toList();
      
      // Determine the value to use
      String? selectedValue;
      if (currentValue.isNotEmpty && allOptions.contains(currentValue)) {
        selectedValue = currentValue;
      } else if (allOptions.isNotEmpty) {
        selectedValue = allOptions.first;
        // Update the controller with the default value if current value is empty
        if (currentValue.isEmpty) {
          controllers[key]!.text = selectedValue;
        }
      }
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items: allOptions
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
                  buildField('First Name', 'firstName', isRequired: true),
                  buildField('Middle Name', 'middleName'),
                  buildField('Last Name', 'lastName', isRequired: true),
                  buildField('Suffix', 'suffix'),
                  buildField('Nickname', 'nickname'),
                  buildDateField('Birthday', 'birthday'),
                  buildField('Age', 'age', inputType: TextInputType.number),
                  buildField('Birth Place', 'birthPlace'),
                  buildDropdownField('Civil Status', 'civilStatus', [
                    'Single',
                    'Married',
                    'Divorced',
                    'Widowed',
                    'Separated',
                    'Annulled',
                    'Legally Separated',
                  ]),
                  buildField('Company Email', 'companyEmail',
                      inputType: TextInputType.emailAddress),
                  buildField('Personal Email', 'personalEmail',
                      inputType: TextInputType.emailAddress),
                  buildField('Mobile Number', 'mobileNumber',
                      inputType: TextInputType.phone),
                  buildField('Permanent Address', 'permanentAddress'),
                  buildField('Temporary Address', 'temporaryAddress'),
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
                  buildField('College', 'college'),
                  buildField('SHS', 'shs'),
                  buildField('High School', 'highSchool'),
                ],
              ),
              ExpansionTile(
                leading: const Icon(Icons.account_balance),
                title: const Text("Bank Information"),
                children: [
                  const SizedBox(height: 5),
                  buildField('Bank Name', 'bankName'),
                  buildField('Bank Number', 'bankNumber'),
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
                  buildField('Position', 'position', isRequired: true),
                  buildDropdownField('Department', 'department', [
                    'HR',
                    'Finance',
                    'MIS',
                    'Sales',
                    'Operations',
                    'Marketing',
                    'Accounting',
                    'Administration',
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
                  buildDateField('Date Regular', 'dateRegular'),
                  buildField('Immediate Supervisor', 'supervisor'),
                  buildDropdownField('Role', 'role', [
                    'Admin',
                    'Employee',
                  ]),
                  buildField('Password', 'password', isRequired: true),
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
