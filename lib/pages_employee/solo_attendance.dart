import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const EmployeeAttendancePage(),
    ),
  );
}

class EmployeeAttendancePage extends StatefulWidget {
  const EmployeeAttendancePage({super.key});

  @override
  State<EmployeeAttendancePage> createState() => _EmployeeAttendancePageState();
}

class _EmployeeAttendancePageState extends State<EmployeeAttendancePage> {
  late final List<EmployeeMonth> employeeAttendance;
  late List<String> monthNames;
  String selectedMonth = '';
  String selectedStatus = 'All';

  final List<String> statusOptions = [
    'All',
    'Present',
    'Absent',
    'Leave',
    'Late',
    'Undertime',
  ];

  @override
  void initState() {
    super.initState();
    employeeAttendance = generateEmployeeAttendance();
    monthNames = employeeAttendance.map((e) => e.monthName).toList();
    selectedMonth = monthNames.isNotEmpty ? monthNames.last : '';
  }

  static List<EmployeeMonth> generateEmployeeAttendance() {
    final Random random = Random();
    final List<String> statusList = ['Present', 'Absent', 'Leave'];
    final DateTime now = DateTime.now();
    final int currentYear = now.year;
    final int currentMonth = now.month;

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

    final List<EmployeeMonth> data = [];

    for (int month = 1; month <= 12; month++) {
      if (month > currentMonth) break;

      final int daysInMonth = DateTime(currentYear, month + 1, 0).day;
      final List<AttendanceRecord> records = [];

      for (int day = 1; day <= daysInMonth; day++) {
        final DateTime date = DateTime(currentYear, month, day);
        if (date.isAfter(now)) continue;

        final String status = statusList[random.nextInt(statusList.length)];

        String inTime = "-", outTime = "-";
        int late = 0, undertime = 0;

        if (status == 'Present') {
          late = random.nextInt(16); // Up to 15 mins late
          undertime = random.nextInt(16); // Up to 15 mins undertime

          final int inMinute = 9 * 60 + late;
          final int outMinute = 17 * 60 - undertime;

          inTime =
              "${(inMinute ~/ 60).toString().padLeft(2, '0')}:${(inMinute % 60).toString().padLeft(2, '0')} AM";
          outTime =
              "${(outMinute ~/ 60).toString().padLeft(2, '0')}:${(outMinute % 60).toString().padLeft(2, '0')} PM";
        }

        records.add(
          AttendanceRecord(
            date: date,
            inTime: inTime,
            outTime: outTime,
            status: status,
            lateMinutes: late,
            undertimeMinutes: undertime,
          ),
        );
      }

      if (records.isNotEmpty) {
        data.add(
          EmployeeMonth(
            monthName: monthNames[month - 1],
            attendanceRecords: records,
          ),
        );
      }
    }

    return data;
  }

  List<AttendanceRecord> _getFilteredRecords() {
    final EmployeeMonth selected = employeeAttendance.firstWhere(
      (element) => element.monthName == selectedMonth,
      orElse: () => EmployeeMonth(monthName: '', attendanceRecords: []),
    );

    switch (selectedStatus) {
      case 'All':
        return selected.attendanceRecords;
      case 'Late':
        return selected.attendanceRecords
            .where((r) => r.status == 'Present' && r.lateMinutes > 0)
            .toList();
      case 'Undertime':
        return selected.attendanceRecords
            .where((r) => r.status == 'Present' && r.undertimeMinutes > 0)
            .toList();
      default:
        return selected.attendanceRecords
            .where((r) => r.status == selectedStatus)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = _getFilteredRecords();

    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Icon(Icons.calendar_today, color: colorScheme.onPrimaryContainer),
      //       const SizedBox(width: 8),
      //       const Expanded(child: Text("Employee Attendance")),
      //     ],
      //   ),
      //   backgroundColor: colorScheme.primaryContainer,
      //   foregroundColor: colorScheme.onPrimaryContainer,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildFilterControls(),
            const SizedBox(height: 12),
            Expanded(
              child: records.isEmpty
                  ? const Center(child: Text("No attendance records found."))
                  : ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) =>
                          _buildAttendanceTile(records[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterControls() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedMonth,
            items: monthNames
                .map(
                  (month) => DropdownMenuItem(value: month, child: Text(month)),
                )
                .toList(),
            onChanged: (value) => setState(() => selectedMonth = value!),
            decoration: const InputDecoration(
              labelText: "Select Month",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedStatus,
            items: statusOptions
                .map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                )
                .toList(),
            onChanged: (value) => setState(() => selectedStatus = value!),
            decoration: const InputDecoration(
              labelText: "Status Filter",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTile(AttendanceRecord record) {
    final Color statusColor = switch (record.status) {
      'Present' => Colors.green,
      'Leave' => Colors.orange,
      'Absent' => Colors.red,
      _ => Colors.grey,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        title: Text(
          "${record.date.day.toString().padLeft(2, '0')} "
          "${_monthName(record.date.month)} ${record.date.year}",
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("In: ${record.inTime}"),
                Text("Out: ${record.outTime}"),
              ],
            ),
            if (record.status == 'Present') ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Late: ${record.lateMinutes} mins"),
                  Text("Undertime: ${record.undertimeMinutes} mins"),
                ],
              ),
            ],
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
      ),
    );
  }

  String _monthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month - 1];
  }
}

class EmployeeMonth {
  final String monthName;
  final List<AttendanceRecord> attendanceRecords;

  EmployeeMonth({required this.monthName, required this.attendanceRecords});
}

class AttendanceRecord {
  final DateTime date;
  final String inTime;
  final String outTime;
  final String status;
  final int lateMinutes;
  final int undertimeMinutes;

  AttendanceRecord({
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.status,
    required this.lateMinutes,
    required this.undertimeMinutes,
  });
}
