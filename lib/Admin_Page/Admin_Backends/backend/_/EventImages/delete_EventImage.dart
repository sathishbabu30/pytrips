import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeletePage extends StatefulWidget {
  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  late Future<List<Map<String, String>>> _imageDataList;

  // Fetch image data from the backend
  Future<List<Map<String, String>>> fetchImageData() async {
    // Replace with your actual server URL
    final response = await http.get(Uri.parse('PLACE YOUR URL'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map<Map<String, String>>((imageJson) {
        return {
          'id': imageJson['id'] ?? '',
          'data': imageJson['data'] ?? '',
          'imageName': imageJson['imageName'] ?? 'Unknown Name',  // Default value if null
          'description': imageJson['description'] ?? 'No description available',
          'locationUrl': imageJson['locationUrl'] ?? 'No location URL available',
          'location': imageJson['location'] ?? 'No location available',
          'rating': imageJson['rating']?.toString() ?? '0.0',
          'phoneNo1': imageJson['phoneNo1'] ?? 'No Phone 1',
          'phoneNo2': imageJson['phoneNo2'] ?? 'No Phone 2',
        };
      }).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }

  // Delete image by ID
  Future<void> _deleteImage(String id) async {
    final response = await http.delete(
      Uri.parse('https://eventimage.onrender.com/delete/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _imageDataList = fetchImageData();  // Refresh the list of images
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _imageDataList = fetchImageData();  // Fetch images when page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Images'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(  // Display the images
        future: _imageDataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images found'));
          } else {
            final imageDataList = snapshot.data!;
            return ListView.builder(
              itemCount: imageDataList.length,
              itemBuilder: (context, index) {
                final imageData = imageDataList[index];
                final base64Data = imageData['data'] ?? '';  // Ensure data is not null
                final imageName = imageData['imageName'] ?? 'Unknown Name';
                final imageDescription = imageData['description'] ?? 'No description available';
                final imageLocation = imageData['location'] ?? 'No location available';
                final imageLocationUrl = imageData['locationUrl'] ?? 'No location URL available';
                final imageId = imageData['id'] ?? '';
                final imageRating = imageData['rating'] ?? '0.0';
                final phoneNo1 = imageData['phoneNo1'] ?? 'No Phone 1';
                final phoneNo2 = imageData['phoneNo2'] ?? 'No Phone 2';

                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: base64Data.isNotEmpty
                        ? Image.memory(
                      base64Decode(base64Data),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image),
                    )
                        : Icon(Icons.broken_image),
                    title: Text(imageName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(imageDescription),
                        SizedBox(height: 4),
                        Text('Location: $imageLocation', style: TextStyle(color: Colors.green)),
                        SizedBox(height: 4),
                        Text('Location URL: $imageLocationUrl', style: TextStyle(color: Colors.blue)),
                        SizedBox(height: 4),
                        Text('Rating: $imageRating', style: TextStyle(color: Colors.orange)),
                        SizedBox(height: 4),
                        Text('Phone No 1: $phoneNo1', style: TextStyle(color: Colors.red)),
                        SizedBox(height: 4),
                        Text('Phone No 2: $phoneNo2', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteImage(imageId),  // Delete image when clicked
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
