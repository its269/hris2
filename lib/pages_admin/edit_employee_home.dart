import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;

  // Admin editable variables
  String userName = "John Paul";
  List<String> imagePaths = ['assets/1.png', 'assets/2.png', 'assets/3.png'];

  DateTime timeIn = DateTime.now();

  final TextEditingController _userNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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

  // Function to pick images
  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePaths[index] = pickedFile.path;
      });
    }
  }

  // Function to update the greeting
  void _updateGreeting() {
    setState(() {
      userName = _userNameController.text.isEmpty
          ? "John Paul"
          : _userNameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Here you can add your save functionality (e.g., save to a database or local storage).
              // For now, it just shows a confirmation
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Changes Saved')));
            },
          ),
        ],
      ),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting + Date + Time-in (Editable for Admin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Editable Greeting
                          TextField(
                            controller: _userNameController..text = userName,
                            onChanged: (newName) => _updateGreeting(),
                            decoration: InputDecoration(
                              labelText: 'Greeting',
                              hintText: 'Enter name',
                              labelStyle: textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onBackground,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: colorScheme.onBackground.withOpacity(
                                  0.7,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  formattedDate,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onBackground.withOpacity(
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
                                color: colorScheme.onBackground,
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

                // HRIS Card (Editable)
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
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "HRIS Description",
                          hintText: "Enter description...",
                          labelStyle: textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Carousel (Editable)
                CarouselSlider.builder(
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index, realIndex) {
                    return GestureDetector(
                      onTap: () => _pickImage(index), // Pick image when clicked
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(imagePaths[index]),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          semanticLabel: 'Carousel image ${index + 1}',
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
                      margin: const EdgeInsets.symmetric(horizontal: 6),
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
            ),
          ),
        ),
      ),
    );
  }
}
