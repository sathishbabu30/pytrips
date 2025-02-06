import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';  // Import for MediaType
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';  // Import image_picker

class EditImagePage extends StatefulWidget {
  final String imageId;
  final String currentName;
  final String currentDescription;
  final String currentLocationUrl; // Renamed to match field
  final String currentLocation;    // Renamed place to location
  final String currentImage;
  final double currentRating;      // Added for rating

  EditImagePage({
    required this.imageId,
    required this.currentName,
    required this.currentDescription,
    required this.currentLocationUrl, // Renamed to match field
    required this.currentLocation,    // Renamed to location
    required this.currentImage,
    required this.currentRating,      // Passed current rating
  });

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationUrlController = TextEditingController();  // Updated to locationUrl
  TextEditingController _locationController = TextEditingController();      // Updated to location
  TextEditingController _ratingController = TextEditingController();         // Controller for rating input
  late Uint8List _imageData;
  bool _imageSelected = false;
  bool _isLoading = false;  // Loading state
  double _rating = 0.0;      // Added rating field

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _descriptionController.text = widget.currentDescription;
    _locationUrlController.text = widget.currentLocationUrl;  // Initialize locationUrl
    _locationController.text = widget.currentLocation;        // Initialize location
    _imageData = base64Decode(widget.currentImage);
    _rating = widget.currentRating;  // Initialize rating from current data
    _ratingController.text = _rating.toString();  // Initialize rating text field
  }

  // Method to handle image update
  Future<void> _updateImage() async {
    setState(() {
      _isLoading = true;  // Set loading state to true
    });

    String name = _nameController.text;
    String description = _descriptionController.text;
    String locationUrl = _locationUrlController.text; // Get locationUrl value
    String location = _locationController.text;  // Get location value
    String rating = _ratingController.text;

    // Ensure the rating is a valid number
    if (rating.isEmpty || double.tryParse(rating) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid rating (between 1 and 5).')),
      );
      return;
    }

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('PLACE YOUR URL/${widget.imageId}'),
    );

    // Adding fields
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['locationUrl'] = locationUrl; // Add locationUrl to request
    request.fields['location'] = location;  // Add location to request
    request.fields['rating'] = rating;  // Add rating to request

    // Adding file (if image is selected)
    if (_imageSelected) {
      request.files.add(await http.MultipartFile.fromBytes(
        'image',
        _imageData,
        filename: 'updated_image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      final response = await request.send();
      final responseString = await response.stream.bytesToString();  // Capture the response content

      setState(() {
        _isLoading = false;  // Set loading state to false after request
      });

      if (response.statusCode == 200) {
        print('Image updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image updated successfully')),
        );
        // Return updated data back to the previous page
        Navigator.pop(context, {
          'name': name,
          'description': description,
          'locationUrl': locationUrl,  // Pass updated locationUrl
          'location': location,        // Pass updated location
          'image': base64Encode(_imageData),  // Pass updated image as base64
          'rating': double.parse(rating),    // Pass updated rating as double
        });
      } else {
        print('Error: ${response.statusCode}, Response: $responseString');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update image')),
        );
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;  // Set loading state to false in case of error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Method to select a new image using image_picker
  Future<void> _selectNewImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageData = imageBytes;
        _imageSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Image')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image preview with ability to select a new image
              GestureDetector(
                onTap: _selectNewImage,
                child: Image.memory(
                  _imageData,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              // Image name input field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Image Name'),
              ),
              SizedBox(height: 8),

              // Image description input field
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 8),

              // Location URL input field
              TextField(
                controller: _locationUrlController,  // Updated to locationUrl
                decoration: InputDecoration(labelText: 'Location URL'),
              ),
              SizedBox(height: 8),

              // Location input field
              TextField(
                controller: _locationController,  // Updated to location
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 16),

              // Rating input field (numeric)
              Text(
                'Rating (1-5):',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _ratingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter rating',
                  hintText: 'Enter a number between 1 and 5',
                ),
                onChanged: (value) {
                  setState(() {
                    // Update the rating value dynamically
                    _rating = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 16),

              // Update button to trigger image update
              _isLoading
                  ? Center(child: CircularProgressIndicator())  // Show loading indicator while updating
                  : ElevatedButton(
                onPressed: _updateImage,
                child: Text('Update Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
