// User > Attendance Page (Solo) 
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const AttendancePageSolo(),
    ),
  );
}

class AttendancePageSolo extends StatefulWidget {
  const AttendancePageSolo({super.key});

  @override
  State<AttendancePageSolo> createState() => _AttendancePageSoloState();
}

class _AttendancePageSoloState extends State<AttendancePageSolo> {
  final List<Student> months = generateMonths();

  static List<Student> generateMonths() {
    final Random random = Random();
    final List<String> statusList = ['Present', 'Absent', 'Leave'];
    final List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    final List<Student> students = [];

    for (var month in monthNames) {
      final attendanceRecords = <AttendanceRecord>[];

      for (int day = 1; day <= 30; day++) {
        final status = statusList[random.nextInt(statusList.length)];
        final inTime = status == 'Present'
            ? "09:${random.nextInt(60).toString().padLeft(2, '0')} AM"
            : "-";
        final outTime = status == 'Present'
            ? "05:${random.nextInt(60).toString().padLeft(2, '0')} PM"
            : "-";

        attendanceRecords.add(
          AttendanceRecord(
            date:
                "2025-${monthNames.indexOf(month) + 1}".padLeft(2, '0') +
                "-${day.toString().padLeft(2, '0')}",
            inTime: inTime,
            outTime: outTime,
            status: status,
          ),
        );
      }

      students.add(Student(name: month, attendanceRecords: attendanceRecords));
    }
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance: January to December")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: const CircleAvatar(child: Icon(Icons.calendar_month)),
              title: Text(month.name),
              children: month.attendanceRecords
                  .map(_buildAttendanceTile)
                  .toList(),
            ),
          );
        },
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

class Student {
  final String name;
  final List<AttendanceRecord> attendanceRecords;

  Student({required this.name, required this.attendanceRecords});
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
