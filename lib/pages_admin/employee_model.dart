class Employee {
  final String id;
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
  final String mother;
  final String father;
  final String brother;
  final String college;
  final String shs;
  final String highSchool;
  final String bankName;
  final String bankNumber;
  final String eeId;
  final String position;
  final String department;
  final String dateHired;
  final String dateRegular;
  final String employmentStatus;
  final String supervisor;
  final List<Map<String, dynamic>> familyMembers;

  Employee({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.suffix,
    required this.nickname,
    required this.birthday,
    required this.age,
    required this.birthPlace,
    required this.civilStatus,
    required this.companyEmail,
    required this.personalEmail,
    required this.mobileNumber,
    required this.permanentAddress,
    required this.temporaryAddress,
    required this.mother,
    required this.father,
    required this.brother,
    required this.college,
    required this.shs,
    required this.highSchool,
    required this.bankName,
    required this.bankNumber,
    required this.eeId,
    required this.position,
    required this.department,
    required this.dateHired,
    required this.dateRegular,
    required this.employmentStatus,
    required this.supervisor,
    required this.familyMembers,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      suffix: json['suffix'],
      nickname: json['nickname'],
      birthday: json['birthday'],
      age: json['age'],
      birthPlace: json['birthPlace'],
      civilStatus: json['civilStatus'],
      companyEmail: json['companyEmail'],
      personalEmail: json['personalEmail'],
      mobileNumber: json['mobileNumber'],
      permanentAddress: json['permanentAddress'],
      temporaryAddress: json['temporaryAddress'],
      mother: json['mother'],
      father: json['father'],
      brother: json['brother'],
      college: json['college'],
      shs: json['shs'],
      highSchool: json['highSchool'],
      bankName: json['bankName'],
      bankNumber: json['bankNumber'],
      eeId: json['eeId'],
      position: json['position'],
      department: json['department'],
      dateHired: json['dateHired'],
      dateRegular: json['dateRegular'],
      employmentStatus: json['employmentStatus'],
      supervisor: json['supervisor'],
      familyMembers: List<Map<String, dynamic>>.from(
        json['familyMembers'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'mother': mother,
      'father': father,
      'brother': brother,
      'college': college,
      'shs': shs,
      'highSchool': highSchool,
      'bankName': bankName,
      'bankNumber': bankNumber,
      'eeId': eeId,
      'position': position,
      'department': department,
      'dateHired': dateHired,
      'dateRegular': dateRegular,
      'employmentStatus': employmentStatus,
      'supervisor': supervisor,
      'familyMembers': familyMembers,
    };
  }
}
