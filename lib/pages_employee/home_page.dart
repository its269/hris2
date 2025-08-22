import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final String userName = "John Paul";

  final List<String> imagePaths = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
  ];

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
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

                // HRIS Card
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
                        "The Human Resource Information System (HRIS) of Kelin Graphics System Corporation is designed to streamline employee management, attendance tracking, and organizational reporting. It ensures accurate, secure, and efficient handling of HR processes, supporting the company's mission to deliver excellence through innovation and integrity.",
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

                // Carousel
                CarouselSlider.builder(
                  itemCount: imagePaths.length,
                  itemBuilder: (context, index, realIndex) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        semanticLabel: 'Carousel image ${index + 1}',
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(child: Text("Image not found")),
                          );
                        },
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
