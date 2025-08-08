import 'dart:convert';
import 'package:http/http.dart' as http;

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
    List<Map<String, dynamic>> members = [];
    if (json['familyMembers'] != null && json['familyMembers'].isNotEmpty) {
      try {
        final List<dynamic> familyList = jsonDecode(json['familyMembers']);
        members = familyList.cast<Map<String, dynamic>>();
      } catch (e) {
        print('Failed to parse familyMembers: $e');
      }
    }

    return Employee(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String,
      lastName: json['lastName'] as String,
      suffix: json['suffix'] as String,
      nickname: json['nickname'] as String,
      birthday: json['birthday'] as String,
      age: json['age'] as String,
      birthPlace: json['birthPlace'] as String,
      civilStatus: json['civilStatus'] as String,
      companyEmail: json['companyEmail'] as String,
      personalEmail: json['personalEmail'] as String,
      mobileNumber: json['mobileNumber'] as String,
      permanentAddress: json['permanentAddress'] as String,
      temporaryAddress: json['temporaryAddress'] as String,
      mother: json['mother'] as String,
      father: json['father'] as String,
      brother: json['brother'] as String,
      college: json['college'] as String,
      shs: json['shs'] as String,
      highSchool: json['highSchool'] as String,
      bankName: json['bankName'] as String,
      bankNumber: json['bankNumber'] as String,
      eeId: json['eeId'] as String,
      position: json['position'] as String,
      department: json['department'] as String,
      dateHired: json['dateHired'] as String,
      dateRegular: json['dateRegular'] as String,
      employmentStatus: json['employmentStatus'] as String,
      supervisor: json['supervisor'] as String,
      familyMembers: members,
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
      'familyMembers': jsonEncode(familyMembers),
    };
  }
}
