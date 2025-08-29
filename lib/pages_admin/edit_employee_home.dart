import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditEmployeeHome extends StatefulWidget {
  const EditEmployeeHome({super.key, required bool showAppBar});

  @override
  State<EditEmployeeHome> createState() => _EditEmployeeHomeState();
}

class _EditEmployeeHomeState extends State<EditEmployeeHome> {
  // State variables for the UI and data
  int _currentIndex = 0;
  List<dynamic> _images = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = true;

  // Lifecycle method to fetch data when the widget initializes
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Dispose controller to prevent memory leaks
  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // C R U D OPERATION 1: READ
  // Fetches data from the employee_home.php API to read the latest information.
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/employee_home/employee_home.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == null) {
          setState(() {
            _descriptionController.text = data['description'] ?? '';
            // Update the images list with data from the API
            _images = data['images'] ?? [];
          });
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // C R U D OPERATION 2 & 3: UPDATE and CREATE
  // Sends updated data to the update_employee_home.php API.
  // This handles both updating existing data and creating new image entries.
  Future<void> _saveChanges() async {
    // Show a loading indicator
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saving changes...')));

    try {
      final uri = Uri.parse(
        'http://10.0.2.2/employee_home/update_employee_home.php',
      );
      var request = http.MultipartRequest('POST', uri);

      request.fields['description'] = _descriptionController.text;

      // Add existing images (URLs) to the request
      for (int i = 0; i < _images.length; i++) {
        if (_images[i] is String) {
          request.fields['existing_images[$i]'] = _images[i];
        }
      }

      // Add new, uploaded images (local files) to the request
      for (var image in _images) {
        if (image is File) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', image.path),
          );
        }
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = json.decode(respStr);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Changes Saved Successfully!')),
          );
          _fetchData(); // Reload data after successful save to get the new URLs
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save changes.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // C R U D OPERATION 2: CREATE (front-end)
  // Pick a new image from the gallery and add it to the local list.
  Future<void> _addImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  // C R U D OPERATION 3: UPDATE (front-end)
  // Replace an existing image at a given index with a new one.
  Future<void> _updateImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images[index] = File(pickedFile.path);
      });
    }
  }

  // C R U D OPERATION 4: DELETE (front-end)
  // Remove an image from the local list. The change is saved on the next _saveChanges() call.
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  // Determine if the image is a URL or a local file and build the appropriate widget
  Widget _buildImage(dynamic image) {
    if (image is String) {
      // It's a URL from the API
      return Image.network(
        'http://10.0.2.2/uploads/$image',
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text('Image not found', style: TextStyle(color: Colors.red)),
          );
        },
      );
    } else if (image is File) {
      // It's a local file picked from the gallery
      return Image.file(image, fit: BoxFit.cover, width: double.infinity);
    }
    return const SizedBox.shrink();
  }

  // Confirmation dialog for deletion
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Image'),
        content: const Text('Are you sure you want to remove this image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _removeImage(index);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit HRIS Section"),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveChanges),
        ],
      ),
      backgroundColor: colorScheme.surface,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HRIS Description Card
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
                            controller: _descriptionController,
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

                    // Carousel Slider with Add Option
                    CarouselSlider.builder(
                      itemCount: _images.length + 1,
                      itemBuilder: (context, index, realIndex) {
                        if (index == _images.length) {
                          // Add Image Button
                          return GestureDetector(
                            onTap: _addImage,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 48,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          );
                        }

                        // Regular image
                        return GestureDetector(
                          onTap: () => _updateImage(index),
                          onLongPress: () => _showDeleteDialog(index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _buildImage(_images[index]),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 220,
                        autoPlay: false,
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
                        _images.length + 1,
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
    );
  }
}
