import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class EditImagePage extends StatefulWidget {
  final String imageId;
  final String currentName;
  final String currentDescription;
  final String currentLocationUrl;
  final String currentLocation;
  final String currentImage;
  final double currentRating;
  final String currentPhoneNo1;
  final String currentPhoneNo2;

  EditImagePage({
    required this.imageId,
    required this.currentName,
    required this.currentDescription,
    required this.currentLocationUrl,
    required this.currentLocation,
    required this.currentImage,
    required this.currentRating,
    required this.currentPhoneNo1,
    required this.currentPhoneNo2,
  });

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationUrlController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _ratingController = TextEditingController();
  TextEditingController _phoneNo1Controller = TextEditingController();
  TextEditingController _phoneNo2Controller = TextEditingController();
  late Uint8List _imageData;
  bool _imageSelected = false;
  bool _isLoading = false;
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _descriptionController.text = widget.currentDescription;
    _locationUrlController.text = widget.currentLocationUrl;
    _locationController.text = widget.currentLocation;
    _phoneNo1Controller.text = widget.currentPhoneNo1;
    _phoneNo2Controller.text = widget.currentPhoneNo2;
    _imageData = base64Decode(widget.currentImage);
    _rating = widget.currentRating;
    _ratingController.text = _rating.toString();
  }

  Future<void> _updateImage() async {
    setState(() {
      _isLoading = true;
    });

    String name = _nameController.text;
    String description = _descriptionController.text;
    String locationUrl = _locationUrlController.text;
    String location = _locationController.text;
    String rating = _ratingController.text;
    String phoneNo1 = _phoneNo1Controller.text;
    String phoneNo2 = _phoneNo2Controller.text;

    if (rating.isEmpty || double.tryParse(rating) == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid rating (between 1 and 5).')));
      return;
    }

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('PLACE YOUR URL/${widget.imageId}'),
    );

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['locationUrl'] = locationUrl;
    request.fields['location'] = location;
    request.fields['rating'] = rating;
    request.fields['phoneNo1'] = phoneNo1;
    request.fields['phoneNo2'] = phoneNo2;

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


      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image updated successfully')));
        Navigator.pop(context, {
          'name': name,
          'description': description,
          'locationUrl': locationUrl,
          'location': location,
          'image': base64Encode(_imageData),
          'rating': double.parse(rating),
          'phoneNo1': phoneNo1,
          'phoneNo2': phoneNo2,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update image')));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

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
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Image Name'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _locationUrlController,
                decoration: InputDecoration(labelText: 'Location URL'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _phoneNo1Controller,
                decoration: InputDecoration(labelText: 'Phone Number 1'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _phoneNo2Controller,
                decoration: InputDecoration(labelText: 'Phone Number 2'),
              ),
              SizedBox(height: 16),
              Text('Rating (1-5):'),
              SizedBox(height: 8),
              TextField(
                controller: _ratingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter rating'),
              ),
              SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
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
