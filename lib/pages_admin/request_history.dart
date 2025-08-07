import 'package:flutter/material.dart';

// A separate page for displaying and searching the Request History
class RequestHistoryPage extends StatefulWidget {
  const RequestHistoryPage({super.key});

  @override
  State<RequestHistoryPage> createState() => _RequestHistoryPageState();
}

class _RequestHistoryPageState extends State<RequestHistoryPage> {
  // Dummy data for the full request history
  final List<Map<String, String>> _allRequestHistory = [
    {'name': 'Senpai Kazu', 'date': '07.28.2025'},
    {'name': 'Pedro Joaquin', 'date': '07.28.2025'},
    {'name': 'Michael Myers', 'date': '07.28.2025'},
    {'name': 'Senpai Kazu', 'date': '07.28.2025'},
    {'name': 'Juan Delacruz', 'date': '07.28.2025'},
    {'name': 'Michael Myers', 'date': '07.28.2025'},
    {'name': 'Senpai Kazu', 'date': '07.28.2025'},
    {'name': 'Pedro Joaquin', 'date': '07.28.2025'},
    {'name': 'Michael Myers', 'date': '07.20.2025'},
    {'name': 'Senpai Kazu', 'date': '07.15.2025'},
  ];

  // List to hold the currently displayed (filtered) request history
  List<Map<String, String>> _filteredRequestHistory = [];

  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the filtered list with all history items
    _filteredRequestHistory = _allRequestHistory;
    // Add a listener to the search controller to filter the list as text changes
    _searchController.addListener(_filterRequests);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRequests);
    _searchController.dispose();
    super.dispose();
  }

  // Method to filter the request history based on search input
  void _filterRequests() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRequestHistory = _allRequestHistory.where((request) {
        // Check if name or date contains the query
        return request['name']!.toLowerCase().contains(query) ||
            request['date']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar for Request History
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search request history...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none, // No border line
            ),
            filled: true,
            fillColor: Colors.grey[200], // Light grey background for search bar
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
        ),
        const SizedBox(
          height: 20,
        ), // Space between search bar and history title
        // Request History Section Title
        const Text(
          'Request History',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          // Use Expanded to allow the ListView to take available space
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE4CC), // Light orange color from image
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: _filteredRequestHistory.isEmpty
                ? const Center(
                    child: Text(
                      'No matching requests found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredRequestHistory.length,
                    itemBuilder: (context, index) {
                      final item = _filteredRequestHistory[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['name']!,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              item['date']!,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
