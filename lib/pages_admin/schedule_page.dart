import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  final String role;
  final String employeeId;

  const SchedulePage({
    super.key,
    required this.role,
    required this.employeeId,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  // Sample events data for the calendar
  final Map<DateTime, List<String>> _events = {
    DateTime.now(): ['Morning Shift', 'Team Meeting'],
    DateTime.now().add(const Duration(days: 1)): ['Afternoon Shift'],
    DateTime.now().add(const Duration(days: 3)): ['Training Session', 'Performance Review'],
    DateTime.now().add(const Duration(days: 7)): ['Company Meeting'],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.calendar_today, 
                 color: colorScheme.onPrimaryContainer, 
                 size: 24),
            const SizedBox(width: 8),
            const Text('Schedule & Calendar'),
          ],
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact Header
            // Row(
            //   children: [
            //     Icon(Icons.calendar_today, 
            //          color: colorScheme.primary, 
            //          size: 24),
            //     const SizedBox(width: 8),
            //     Text(
            //       'Schedule & Calendar',
            //       style: Theme.of(context).textTheme.titleLarge?.copyWith(
            //         fontWeight: FontWeight.bold,
            //         color: colorScheme.primary,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 16),
            
            // Compact Quick Actions Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
              children: [
                _buildScheduleCard(
                  'Today',
                  'Shift',
                  Icons.schedule,
                  Colors.blue,
                ),
                _buildScheduleCard(
                  'Time Off',
                  'Leave',
                  Icons.beach_access,
                  Colors.orange,
                ),
                _buildScheduleCard(
                  'Team',
                  'Calendar',
                  Icons.group,
                  Colors.green,
                ),
                _buildScheduleCard(
                  'Overtime',
                  'Hours',
                  Icons.access_time,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Compact Weekly Overview
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.view_week, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'This Week',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Fixed overflow by using Expanded widgets
                    Row(
                      children: [
                        Expanded(child: _buildWeekDay('MON', '14', true)),
                        Expanded(child: _buildWeekDay('TUE', '15', false)),
                        Expanded(child: _buildWeekDay('WED', '16', false)),
                        Expanded(child: _buildWeekDay('THU', '17', false)),
                        Expanded(child: _buildWeekDay('FRI', '18', false)),
                        Expanded(child: _buildWeekDay('SAT', '19', false)),
                        Expanded(child: _buildWeekDay('SUN', '20', false)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Maximized Calendar Integration
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          'Monthly Calendar',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Maximized calendar with optimized styling
                    TableCalendar<String>(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      calendarFormat: _calendarFormat,
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle: TextStyle(color: colorScheme.error),
                        holidayTextStyle: TextStyle(color: colorScheme.error),
                        selectedDecoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                        // Optimized spacing
                        cellMargin: const EdgeInsets.all(2),
                        cellPadding: const EdgeInsets.all(8),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        formatButtonTextStyle: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 12,
                        ),
                        titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ) ?? const TextStyle(fontWeight: FontWeight.bold),
                        headerPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        weekendStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Selected day events
                    if (_selectedDay != null) ...[
                      Text(
                        'Events for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._getEventsForDay(_selectedDay!).map(
                        (event) => Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 16,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                event,
                                style: TextStyle(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_getEventsForDay(_selectedDay!).isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'No events scheduled for this day',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEventDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Event'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildScheduleCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () => _handleCardTap(title),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 9,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCardTap(String title) {
    switch (title) {
      case 'Today\'s Schedule':
        _showTodayScheduleDialog();
        break;
      case 'Time Off':
        _showTimeOffDialog();
        break;
      case 'Team Schedule':
        _showTeamScheduleDialog();
        break;
      case 'Overtime':
        _showOvertimeDialog();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title feature coming soon!'),
          ),
        );
    }
  }

  void _showAddEventDialog() {
    final TextEditingController eventController = TextEditingController();
    DateTime selectedDate = _selectedDay ?? DateTime.now();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: eventController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'Enter event description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      selectedDate = picked;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Change Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (eventController.text.isNotEmpty) {
                  setState(() {
                    final eventDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                    if (_events[eventDate] != null) {
                      _events[eventDate]!.add(eventController.text);
                    } else {
                      _events[eventDate] = [eventController.text];
                    }
                    _selectedDay = eventDate;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Event added successfully!')),
                  );
                }
              },
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTodayScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Today\'s Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScheduleItem('Morning Shift', '08:00 - 12:00', Icons.wb_sunny, Colors.orange),
            const SizedBox(height: 8),
            _buildScheduleItem('Lunch Break', '12:00 - 13:00', Icons.restaurant, Colors.green),
            const SizedBox(height: 8),
            _buildScheduleItem('Afternoon Shift', '13:00 - 17:00', Icons.work, Colors.blue),
            const SizedBox(height: 16),
            Text(
              'Total Hours: 8 hours',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTimeOffDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Off Requests'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Time Off:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildTimeOffItem('Vacation', 'Dec 25-31, 2024', 'Approved', Colors.green),
            const SizedBox(height: 8),
            _buildTimeOffItem('Sick Leave', 'Jan 15, 2025', 'Pending', Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Remaining Days: 15 vacation, 5 sick',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New time off request feature coming soon!')),
              );
            },
            child: const Text('New Request'),
          ),
        ],
      ),
    );
  }

  void _showTeamScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Team Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Team:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildTeamMember('John Doe', 'Morning Shift', 'Available', Colors.green),
            const SizedBox(height: 8),
            _buildTeamMember('Jane Smith', 'Afternoon Shift', 'Available', Colors.green),
            const SizedBox(height: 8),
            _buildTeamMember('Mike Johnson', 'Off', 'Vacation', Colors.red),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showOvertimeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Overtime Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Month:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildOvertimeItem('Week 1', '5 hours', Colors.blue),
            const SizedBox(height: 8),
            _buildOvertimeItem('Week 2', '3 hours', Colors.blue),
            const SizedBox(height: 8),
            _buildOvertimeItem('Week 3', '7 hours', Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Total: 15 hours',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String title, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDay(String day, String date, bool isToday) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: isToday ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isToday ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isToday ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOffItem(String type, String dates, String status, Color statusColor) {
    return Row(
      children: [
        Icon(Icons.event_available, size: 16, color: statusColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(dates, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 10,
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamMember(String name, String shift, String status, Color statusColor) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: statusColor.withOpacity(0.2),
          child: Text(
            name.split(' ').map((n) => n[0]).join(),
            style: TextStyle(fontSize: 12, color: statusColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(shift, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 10,
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOvertimeItem(String period, String hours, Color color) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(period, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Text(
          hours,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
