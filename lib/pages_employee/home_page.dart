import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Import the http package

// This class represents the data we will fetch from the database.
// The 'images' field is a list of strings parsed from the JSON array
// stored in the MySQL database.
class EmployeeHomeData {
  final String description;
  final List<String> images;

  EmployeeHomeData({required this.description, required this.images});

  // A factory constructor to create an instance from a JSON map,
  // which would be the format received from a backend API.
  factory EmployeeHomeData.fromJson(Map<String, dynamic> json) {
    // Decode the JSON string from the 'images' field into a List<dynamic>.
    // The images field from your database is already a JSON string.
    final List<dynamic> imagesJson = jsonDecode(json['images']);
    // Map the dynamic list to a List<String>.
    final List<String> imageList = imagesJson.cast<String>();

    return EmployeeHomeData(
      description: json['description'],
      images: imageList,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // This is a placeholder for the user name.
  final String userName = "John Paul";

  // Use a Future to hold the result of the asynchronous data fetch.
  late Future<EmployeeHomeData> _employeeDataFuture;

  @override
  void initState() {
    super.initState();
    _employeeDataFuture = _fetchDataFromDatabase();
  }

  // --- UPDATED FUNCTION TO FETCH DATA FROM PHP API ---
  Future<EmployeeHomeData> _fetchDataFromDatabase() async {
    // Replace with the URL of your PHP API endpoint.
    // Use your computer's IP address or "10.0.2.2" for Android emulator.
    const String apiUrl =
        "http://10.0.2.2/employee_home/employee_user_home.php";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return EmployeeHomeData.fromJson(jsonResponse);
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception(
          'Failed to load data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Catch any errors during the HTTP request.
      throw Exception('Failed to connect to the server: $e');
    }
  }

  final DateTime timeIn = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    8,
    15,
  );

  String get formattedDate {
    return DateFormat('EEEE, MMMM d, yyyy').format(timeIn);
  }

  String get formattedTimeIn {
    return DateFormat('hh:mm a').format(timeIn);
  }

  bool get isDayTime {
    final hour = timeIn.hour;
    return hour >= 6 && hour < 18;
  }

  void _showImageLightbox(String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1,
          maxScale: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  height: 300,
                  child: const Center(child: Text("Image not found")),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting + Date + Time-in
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side (Greeting + Date)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, $userName",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  formattedDate,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Right side (TIME-IN label + time + icon)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "TIME-IN",
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formattedTimeIn,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              isDayTime
                                  ? Icons.wb_sunny_outlined
                                  : Icons.nights_stay_outlined,
                              color: isDayTime
                                  ? Colors.orangeAccent
                                  : Colors.indigoAccent,
                              size: 26,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Use FutureBuilder to handle the asynchronous data
                FutureBuilder<EmployeeHomeData>(
                  future: _employeeDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading indicator while fetching data
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Show an error message if something went wrong
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      // Data has been successfully fetched, build the UI
                      final employeeData = snapshot.data!;
                      final imagePaths = employeeData.images;

                      return Column(
                        children: [
                          // HRIS Card updated with fetched description
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.blue[800],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade900.withOpacity(0.6),
                                  blurRadius: 12,
                                  offset: const Offset(3, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "HRIS KELIN",
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.white70,
                                  thickness: 1.2,
                                  height: 32,
                                ),
                                Text(
                                  employeeData.description,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Carousel with fetched images
                          CarouselSlider.builder(
                            itemCount: imagePaths.length,
                            itemBuilder: (context, index, realIndex) {
                              return GestureDetector(
                                onTap: () =>
                                    _showImageLightbox(imagePaths[index]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    imagePaths[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    semanticLabel:
                                        'Carousel image ${index + 1}',
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Text("Image not found"),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 220,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.85,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Dots Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              imagePaths.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                height: 12,
                                width: _currentIndex == index ? 24 : 12,
                                decoration: BoxDecoration(
                                  color: _currentIndex == index
                                      ? colorScheme.primary
                                      : colorScheme.primary.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      );
                    } else {
                      // This case is unlikely, but good practice to handle.
                      return const Center(child: Text('No data found.'));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
