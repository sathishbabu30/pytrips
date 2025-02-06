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
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _phoneNo1Controller = TextEditingController(); // Added phoneNo1 controller
  final TextEditingController _phoneNo2Controller = TextEditingController(); // Added phoneNo2 controller
  final TextEditingController _websiteController = TextEditingController(); // Added website controller
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
    if (_descriptionController.text.isEmpty ||
        _locationUrlController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _ratingController.text.isEmpty ||
        _phoneNo1Controller.text.isEmpty || // Check phoneNo1
        _phoneNo2Controller.text.isEmpty || // Check phoneNo2
        _websiteController.text.isEmpty) { // Check website
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
      request.fields['location'] = _locationController.text;
      request.fields['rating'] = _ratingController.text;
      request.fields['phoneNo1'] = _phoneNo1Controller.text; // Add phoneNo1
      request.fields['phoneNo2'] = _phoneNo2Controller.text; // Add phoneNo2
      request.fields['website'] = _websiteController.text; // Add website

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
          _locationController.clear();
          _ratingController.clear();
          _phoneNo1Controller.clear(); // Clear phoneNo1
          _phoneNo2Controller.clear(); // Clear phoneNo2
          _websiteController.clear(); // Clear website
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _imageNameController,
                decoration: InputDecoration(
                  labelText: 'Image Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Image Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _locationUrlController,
                decoration: InputDecoration(
                  labelText: 'Location URL',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _ratingController,
                decoration: InputDecoration(
                  labelText: 'Rating (0 to 5)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _phoneNo1Controller,
                decoration: InputDecoration(
                  labelText: 'Phone Number 1',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _phoneNo2Controller,
                decoration: InputDecoration(
                  labelText: 'Phone Number 2',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _websiteController, // Input for website
                decoration: InputDecoration(
                  labelText: 'Website',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              if (_image != null)
                Image.file(_image!)
              else
                Text('No image selected'),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
