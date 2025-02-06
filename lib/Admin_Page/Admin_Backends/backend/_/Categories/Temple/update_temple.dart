import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'EditImagePage.dart';

class UpdateImagePage extends StatefulWidget {
  @override
  _UpdateImagePageState createState() => _UpdateImagePageState();
}

class _UpdateImagePageState extends State<UpdateImagePage> {
  late Future<List<Map<String, String>>> _imageDataList;

  // Fetch image data from the backend
  Future<List<Map<String, String>>> fetchImageData() async {
    try {
      final response = await http.get(Uri.parse('PLACE YOUR URL'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, String>> imageDataList = data.map<Map<String, String>>((imageJson) {
          return {
            'id': imageJson['id'] ?? 'No ID', // Default to 'No ID' if null
            'data': imageJson['data'] ?? '', // Default to empty string if 'data' is null
            'imageName': imageJson['imageName'] ?? 'No Name', // Default to 'No Name' if null
            'description': imageJson['description'] ?? 'No description', // Default to 'No description' if null
            'locationUrl': imageJson['locationUrl'] ?? 'No URL available', // Default to 'No URL available' if null
            'location': imageJson['location'] ?? 'No place available', // Default to 'No place available' if null
            'rating': (imageJson['rating'] ?? 0).toString(), // Default to '0' if null, safely convert to string
          };
        }).toList();
        return imageDataList;
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _imageDataList = fetchImageData(); // Fetch the images when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Images'),
      ),
      body: FutureBuilder<List<Map<String, String>>>( // Load image data
        future: _imageDataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images found'));
          } else {
            List<Map<String, String>> imageDataList = snapshot.data!;
            return ListView.builder(
              itemCount: imageDataList.length,
              itemBuilder: (context, index) {
                Map<String, String> imageData = imageDataList[index];
                String base64Data = imageData['data'] ?? ''; // Provide empty string if null
                String imageName = imageData['imageName'] ?? 'No Name';
                String imageDescription = imageData['description'] ?? 'No description';
                String imageLocationUrl = imageData['locationUrl'] ?? 'No URL available';
                String imageLocation = imageData['location'] ?? 'No place available';
                String imageId = imageData['id'] ?? 'No ID';
                double rating = double.tryParse(imageData['rating'] ?? '0.0') ?? 0.0;

                return GestureDetector(
                  onTap: () {
                    // You can add more actions if needed
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Image
                          base64Data.isNotEmpty
                              ? Image.memory(
                            base64Decode(base64Data),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : Container(width: 100, height: 100, color: Colors.grey), // Show a grey box if no image data
                          SizedBox(width: 16),
                          // Image details (name, description, location URL)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image Name
                                Text(
                                  imageName,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                // Image Description
                                Text(
                                  'Description: $imageDescription',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                // Location URL
                                Text(
                                  'Location URL: $imageLocationUrl',
                                  style: TextStyle(fontSize: 14, color: Colors.blue),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                // Location
                                Text(
                                  'Location: $imageLocation',
                                  style: TextStyle(fontSize: 14, color: Colors.green),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                // Rating
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < rating ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                                SizedBox(height: 4),
                                // Display the numeric rating
                                Text(
                                  'Rating: ${rating.toStringAsFixed(1)} / 5',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          // Edit button
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Navigate to the Edit Page and pass rating as double
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditImagePage(
                                    imageId: imageId,
                                    currentName: imageName,
                                    currentDescription: imageDescription,
                                    currentLocationUrl: imageLocationUrl,
                                    currentLocation: imageLocation,
                                    currentImage: base64Data,
                                    currentRating: rating, // Pass rating as a double
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
