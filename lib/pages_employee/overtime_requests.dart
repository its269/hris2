import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OvertimeRequestForm extends StatefulWidget {
  const OvertimeRequestForm({super.key});

  @override
  _OvertimeRequestFormState createState() => _OvertimeRequestFormState();
}

class _OvertimeRequestFormState extends State<OvertimeRequestForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _reasonController = TextEditingController();

  final List<Map<String, dynamic>> _overtimeHistory = [];

  String _filterStatus = 'All';

  // <-- Add this flag to control user role -->
  bool isAdmin = false; // set true for admin, false for requester

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _startTime != null &&
        _endTime != null) {
      setState(() {
        _overtimeHistory.insert(0, {
          'date': _selectedDate!,
          'startTime': _startTime!,
          'endTime': _endTime!,
          'reason': _reasonController.text,
          'status': 'Pending',
        });

        _selectedDate = null;
        _startTime = null;
        _endTime = null;
        _reasonController.clear();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Overtime Request Submitted')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please complete all fields')));
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Approved':
        color = Colors.green;
        break;
      case 'Rejected':
        color = Colors.red;
        break;
      case 'Pending':
      default:
        color = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _updateRequestStatus(int index, String newStatus) {
    setState(() {
      _overtimeHistory[index]['status'] = newStatus;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Request marked as $newStatus')));
  }

  Widget _buildHistoryList() {
    final filteredList = _filterStatus == 'All'
        ? _overtimeHistory
        : _overtimeHistory
              .where((item) => item['status'] == _filterStatus)
              .toList();

    if (filteredList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text('No overtime requests for selected filter.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 40),
        Text(
          'Overtime Request History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final item = filteredList[index];
            final date = item['date'] as DateTime;
            final start = item['startTime'] as TimeOfDay;
            final end = item['endTime'] as TimeOfDay;
            final reason = item['reason'] as String;
            final status = item['status'] as String;

            final originalIndex = _overtimeHistory.indexOf(item);

            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(DateFormat('EEEE, MMMM d, y').format(date)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time: ${start.format(context)} - ${end.format(context)}',
                    ),
                    Text('Reason: $reason'),
                    SizedBox(height: 6),
                    _buildStatusBadge(status),
                    SizedBox(height: 8),
                    if (isAdmin && status == 'Pending')
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.check, size: 16),
                            label: Text('Approve'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size(100, 30),
                            ),
                            onPressed: () =>
                                _updateRequestStatus(originalIndex, 'Approved'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            icon: Icon(Icons.close, size: 16),
                            label: Text('Reject'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: Size(100, 30),
                            ),
                            onPressed: () =>
                                _updateRequestStatus(originalIndex, 'Rejected'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Overtime Request Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'Select Overtime Date'
                        : 'Change Overtime Date',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context),
                ),
                if (_selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.today, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Overtime Date: ${DateFormat('EEEE, MMMM d, y').format(_selectedDate!)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ListTile(
                  title: Text(
                    _startTime == null
                        ? 'Select Start Time'
                        : 'Start Time: ${_startTime!.format(context)}',
                  ),
                  trailing: Icon(Icons.access_time),
                  onTap: () => _pickTime(context, true),
                ),
                ListTile(
                  title: Text(
                    _endTime == null
                        ? 'Select End Time'
                        : 'End Time: ${_endTime!.format(context)}',
                  ),
                  trailing: Icon(Icons.access_time),
                  onTap: () => _pickTime(context, false),
                ),
                TextFormField(
                  controller: _reasonController,
                  decoration: InputDecoration(labelText: 'Reason for Overtime'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit Request'),
                ),
                SizedBox(height: 30),
                Text(
                  'Filter by Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _filterStatus,
                  items: ['All', 'Pending', 'Approved', 'Rejected']
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _filterStatus = value;
                      });
                    }
                  },
                ),
                _buildHistoryList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
