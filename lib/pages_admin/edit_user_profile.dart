import 'package:flutter/material.dart';
import 'employee_list_page.dart';

void main() {
  runApp(
    const MaterialApp(
      home: EmployeeListPage(
        role: 'admin', // Replace 'admin' with the appropriate role
        employeeId:
            '123', // Replace '123' with the appropriate employee ID as a String
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
