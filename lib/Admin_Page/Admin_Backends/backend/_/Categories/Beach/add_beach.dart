import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CreateImagePage extends StatefulWidget {
  @override
  _CreateImagePageState createState() => _CreateImagePageState();
}

class _CreateImagePageState extends State<CreateImagePage> {
  File? _image;
  final TextEditingController _imageNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationUrlController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();  // Renamed from _placeController
  final TextEditingController _ratingController = TextEditingController(); // Rating controller
  bool _isLoading = false;

  // Picking an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Show message in a Snackbar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Uploading image to server
  Future<void> _uploadImage() async {
    if (_image == null) {
      _showSnackBar('No image selected.');
      return;
    }

    if (_imageNameController.text.isEmpty) {
      _showSnackBar('Please provide a name for the image.');
      return;
    }

    // Ensure all fields are filled
    if (_descriptionController.text.isEmpty || _locationUrlController.text.isEmpty || _locationController.text.isEmpty || _ratingController.text.isEmpty) {  // Updated check for _locationController
      _showSnackBar('Please provide all required fields.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('PLACE YOUR URL'),
    );

    try {
      // Add all fields to the request
      request.fields['imageName'] = _imageNameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['locationUrl'] = _locationUrlController.text;
      request.fields['location'] = _locationController.text;  // Renamed from 'place' to 'location'
      request.fields['rating'] = _ratingController.text; // Add rating

      // Upload the image
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var response = await request.send();

      // Check the server response status
      if (response.statusCode == 200) {
        _showSnackBar('Image uploaded successfully!');
        setState(() {
          _image = null;
          _imageNameController.clear();
          _descriptionController.clear();
          _locationUrlController.clear();
          _locationController.clear();  // Clear the location controller
          _ratingController.clear(); // Clear the rating controller
        });
      } else {
        final responseBody = await response.stream.bytesToString();
        _showSnackBar('Error uploading image: ${response.statusCode}');
        print('Response body: $responseBody');
      }
    } catch (e) {
      _showSnackBar('An error occurred while uploading: $e');
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField for image name
            TextField(
              controller: _imageNameController,
              decoration: InputDecoration(
                labelText: 'Image Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // TextField for description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Image Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // TextField for location URL
            TextField(
              controller: _locationUrlController,
              decoration: InputDecoration(
                labelText: 'Location URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // TextField for location (renamed from place)
            TextField(
              controller: _locationController,  // Updated to use _locationController
              decoration: InputDecoration(
                labelText: 'Location',  // Updated label to 'Location'
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // TextField for rating
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(
                labelText: 'Rating (0 to 5)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            if (_image != null)
              Image.file(_image!)  // Display selected image
            else
              Text('No image selected'),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator() // Show loading indicator
                : ElevatedButton(
              onPressed: _uploadImage, // Call image upload
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
