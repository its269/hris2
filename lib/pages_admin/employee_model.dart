class Employee {
  final String employeeID;
  final String firstName;
  final String middleName;
  final String lastName;
  final String suffix;
  final String nickname;
  final String birthday;
  final String age;
  final String birthPlace;
  final String civilStatus;
  final String companyEmail;
  final String personalEmail;
  final String mobileNumber;
  final String permanentAddress;
  final String temporaryAddress;
  final String college;
  final String shs;
  final String highSchool;
  final String bankName;
  final String bankNumber;
  final String position;
  final String branch;
  final String department;
  final String dateHired;
  final String dateRegular;
  final String employmentStatus;
  final String supervisor;
  final List<Map<String, dynamic>> familyMembers;
  final String role;
  final String password;

  Employee({
    required this.employeeID,
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.suffix = '',
    this.nickname = '',
    this.birthday = '',
    this.age = '',
    this.birthPlace = '',
    this.civilStatus = '',
    this.companyEmail = '',
    this.personalEmail = '',
    this.mobileNumber = '',
    this.permanentAddress = '',
    this.temporaryAddress = '',
    this.college = '',
    this.shs = '',
    this.highSchool = '',
    this.bankName = '',
    this.bankNumber = '',
    this.position = '',
    this.branch = '',
    this.department = '',
    this.dateHired = '',
    this.dateRegular = '',
    this.employmentStatus = '',
    this.supervisor = '',
    this.familyMembers = const [],
    this.role = '',
    this.password = '',
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeID: json['EmployeeID']?.toString() ?? '',
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      suffix: json['suffix'] ?? '',
      nickname: json['nickname'] ?? '',
      birthday: json['birthday'] ?? '',
      age: json['age'] ?? '',
      birthPlace: json['birthPlace'] ?? '',
      civilStatus: json['civilStatus'] ?? '',
      companyEmail: json['companyEmail'] ?? '',
      personalEmail: json['personalEmail'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      permanentAddress: json['permanentAddress'] ?? '',
      temporaryAddress: json['temporaryAddress'] ?? '',
      college: json['college'] ?? '',
      shs: json['shs'] ?? '',
      highSchool: json['highSchool'] ?? '',
      bankName: json['bankName'] ?? '',
      bankNumber: json['bankNumber'] ?? '',
      position: json['position'] ?? '',
      branch: json['branch'] ?? '',
      department: json['department'] ?? '',
      dateHired: json['dateHired'] ?? '',
      dateRegular: json['dateRegular'] ?? '',
      employmentStatus: json['employmentStatus'] ?? '',
      supervisor: json['supervisor'] ?? '',
      familyMembers: List<Map<String, dynamic>>.from(json['familyMembers'] ?? []),
      role: (json['loginRole'] ?? json['role']) ?? '',
      password: (json['loginPassword'] ?? json['password']) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'suffix': suffix,
      'nickname': nickname,
      'birthday': birthday,
      'age': age,
      'birthPlace': birthPlace,
      'civilStatus': civilStatus,
      'companyEmail': companyEmail,
      'personalEmail': personalEmail,
      'mobileNumber': mobileNumber,
      'permanentAddress': permanentAddress,
      'temporaryAddress': temporaryAddress,
      'college': college,
      'shs': shs,
      'highSchool': highSchool,
      'bankName': bankName,
      'bankNumber': bankNumber,
      'position': position,
      'branch': branch,
      'department': department,
      'dateHired': dateHired,
      'dateRegular': dateRegular,
      'employmentStatus': employmentStatus,
      'supervisor': supervisor,
      'familyMembers': familyMembers,
      'role': role,
      'password': password,
    };
  }
}
