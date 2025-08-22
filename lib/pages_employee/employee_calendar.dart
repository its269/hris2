import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EventType { holiday, leave, advisory, company, custom }

class CalendarEvent {
  final String title;
  final EventType type;
  final DateTime date;

  CalendarEvent({required this.title, required this.type, required this.date});

  Map<String, dynamic> toMap() => {
    'title': title,
    'type': type.toString(),
    'date': date.toIso8601String(),
  };

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      title: map['title'],
      type: EventType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => EventType.custom,
      ),
      date: DateTime.parse(map['date']),
    );
  }
}

class EmployeeCalendarPage extends StatefulWidget {
  const EmployeeCalendarPage({super.key, required bool showAppBar});

  @override
  State<EmployeeCalendarPage> createState() => _EmployeeCalendarPageState();
}

class _EmployeeCalendarPageState extends State<EmployeeCalendarPage> {
  late SharedPreferences _prefs;
  Map<DateTime, List<CalendarEvent>> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  EventType? _selectedFilter;
  final TextEditingController _titleController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadEvents();

    // Add sample events if none exist
    if (_events.isEmpty) {
      final now = DateTime.now();

      final sampleEvents = [
        CalendarEvent(
          title: 'Independence Day',
          type: EventType.holiday,
          date: now.subtract(const Duration(days: 2)),
        ),
        CalendarEvent(
          title: 'Annual Leave',
          type: EventType.leave,
          date: now.subtract(const Duration(days: 1)),
        ),
        CalendarEvent(
          title: 'Weather Advisory',
          type: EventType.advisory,
          date: now,
        ),
        CalendarEvent(
          title: 'Townhall Meeting',
          type: EventType.company,
          date: now.add(const Duration(days: 1)),
        ),
        CalendarEvent(
          title: 'Birthday Party',
          type: EventType.custom,
          date: now.add(const Duration(days: 2)),
        ),
      ];

      for (final event in sampleEvents) {
        final key = DateTime(event.date.year, event.date.month, event.date.day);
        _events.putIfAbsent(key, () => []).add(event);
      }

      await _saveEvents();
      setState(() {}); // Refresh UI
    }
  }

  void _loadEvents() {
    final jsonStr = _prefs.getString('calendar_events');
    if (jsonStr == null) return;

    final List decoded = jsonDecode(jsonStr);
    final List<CalendarEvent> loaded = decoded
        .map((e) => CalendarEvent.fromMap(e))
        .toList();

    final grouped = <DateTime, List<CalendarEvent>>{};
    for (var ev in loaded) {
      final key = DateTime(ev.date.year, ev.date.month, ev.date.day);
      grouped.putIfAbsent(key, () => []).add(ev);
    }

    _events = grouped;
  }

  Future<void> _saveEvents() async {
    final allEvents = _events.values.expand((e) => e).toList();
    final enc = jsonEncode(allEvents.map((e) => e.toMap()).toList());
    await _prefs.setString('calendar_events', enc);
  }

  Future<void> _addOrUpdateEvent(CalendarEvent? existing, DateTime date) async {
    final isEditing = existing != null;
    _titleController.text = existing?.title ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Edit Event' : 'Add Event',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      final text = _titleController.text.trim();
                      if (text.isEmpty) return;
                      final newEvent = CalendarEvent(
                        title: text,
                        type: EventType.custom,
                        date: date,
                      );
                      final dateKey = DateTime(date.year, date.month, date.day);
                      setState(() {
                        final list = _events.putIfAbsent(dateKey, () => []);
                        if (isEditing) list.remove(existing);
                        list.add(newEvent);
                      });
                      await _saveEvents();
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 12),
                  if (isEditing)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                      onPressed: () async {
                        final dateKey = DateTime(
                          date.year,
                          date.month,
                          date.day,
                        );
                        setState(() {
                          _events[dateKey]?.remove(existing);
                          if (_events[dateKey]?.isEmpty ?? false) {
                            _events.remove(dateKey);
                          }
                        });
                        await _saveEvents();
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final list = _events[DateTime(day.year, day.month, day.day)] ?? [];
    if (_selectedFilter == null) return list;
    return list.where((ev) => ev.type == _selectedFilter).toList();
  }

  Color _getColorForType(EventType type) {
    switch (type) {
      case EventType.holiday:
        return Colors.red;
      case EventType.leave:
        return Colors.orange;
      case EventType.advisory:
        return Colors.green;
      case EventType.company:
        return Colors.blue;
      case EventType.custom:
        return Colors.purple;
    }
  }

  String _getLabelForType(EventType type) {
    switch (type) {
      case EventType.holiday:
        return "Holiday";
      case EventType.leave:
        return "Leave";
      case EventType.advisory:
        return "Advisory";
      case EventType.company:
        return "Company Event";
      case EventType.custom:
        return "Custom Event";
    }
  }

  IconData _getIconForType(EventType type) {
    switch (type) {
      case EventType.holiday:
        return Icons.calendar_today;
      case EventType.leave:
        return Icons.beach_access;
      case EventType.advisory:
        return Icons.warning;
      case EventType.company:
        return Icons.business;
      case EventType.custom:
        return Icons.event;
    }
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Drawer _buildEndDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Filter',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildFilterTile(
            'HOLIDAY',
            Icons.calendar_today,
            EventType.holiday,
            Colors.red,
          ),
          _buildFilterTile(
            'LEAVES',
            Icons.beach_access,
            EventType.leave,
            Colors.orange,
          ),
          _buildFilterTile(
            'ATTENDANCE ADVISORY',
            Icons.warning,
            EventType.advisory,
            Colors.green,
          ),
          _buildFilterTile(
            'COMPANY EVENTS',
            Icons.business,
            EventType.company,
            Colors.blue,
          ),
          _buildFilterTile(
            'CUSTOM EVENTS',
            Icons.event,
            EventType.custom,
            Colors.purple,
          ),
          ListTile(
            leading: const Icon(Icons.clear),
            title: const Text('CLEAR FILTER'),
            onTap: () {
              setState(() {
                _selectedFilter = null;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildFilterTile(
    String title,
    IconData icon,
    EventType type,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: _colorDot(color),
      selected: _selectedFilter == type,
      onTap: () {
        setState(() {
          _selectedFilter = type;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventsForSelectedDay = _selectedDay == null
        ? []
        : _getEventsForDay(_selectedDay!);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildEndDrawer(),
      appBar: AppBar(
        title: const Text('Employee Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Text('View', style: TextStyle(fontSize: 14)),
                Switch(
                  value: _isEditMode,
                  onChanged: (val) {
                    setState(() {
                      _isEditMode = val;
                    });
                  },
                ),
                const Text('Edit', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedFilter != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Chip(
                label: Text(
                  'Filtered: ${_getLabelForType(_selectedFilter!)}',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: _getColorForType(_selectedFilter!),
                deleteIcon: const Icon(Icons.clear, color: Colors.white),
                onDeleted: () {
                  setState(() {
                    _selectedFilter = null;
                  });
                },
              ),
            ),
          Expanded(
            child: TableCalendar<CalendarEvent>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                if (_isEditMode) {
                  _addOrUpdateEvent(null, selectedDay);
                }
              },
              eventLoader: _getEventsForDay,
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                markerDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                markersMaxCount: 4,
                markerMargin: const EdgeInsets.symmetric(horizontal: 1.5),
                markerSizeScale: 1.2,
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return const SizedBox();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.take(3).map((event) {
                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getColorForType(event.type),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          if (_selectedDay != null)
            Container(
              color: const Color.fromARGB(255, 37, 38, 49),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Events on ${_selectedDay!.toLocal().toIso8601String().substring(0, 10)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (eventsForSelectedDay.isEmpty)
                    const Text(
                      'No events',
                      style: TextStyle(color: Colors.white),
                    ),
                  ...eventsForSelectedDay.map(
                    (ev) => ListTile(
                      leading: Icon(
                        _getIconForType(ev.type),
                        color: _getColorForType(ev.type),
                      ),
                      title: Text(
                        ev.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: ev.type == EventType.custom
                          ? IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                _addOrUpdateEvent(ev, ev.date);
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
