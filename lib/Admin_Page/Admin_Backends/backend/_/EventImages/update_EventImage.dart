import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_EventImage.dart';

class UpdateImagePage extends StatefulWidget {
  @override
  _UpdateImagePageState createState() => _UpdateImagePageState();
}

class _UpdateImagePageState extends State<UpdateImagePage> {
  late Future<List<Map<String, String>>> _imageDataList;

  Future<List<Map<String, String>>> fetchImageData() async {
    try {
      final response = await http.get(Uri.parse('PLACE YOUR URL'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, String>> imageDataList = data.map<Map<String, String>>((imageJson) {
          return {
            'id': imageJson['id'] ?? 'No ID',
            'data': imageJson['data'] ?? '',
            'imageName': imageJson['imageName'] ?? 'No Name',
            'description': imageJson['description'] ?? 'No description',
            'locationUrl': imageJson['locationUrl'] ?? 'No URL available',
            'location': imageJson['location'] ?? 'No place available',
            'rating': (imageJson['rating'] ?? 0).toString(),
            'phoneNo1': imageJson['phoneNo1'] ?? 'No Phone 1',
            'phoneNo2': imageJson['phoneNo2'] ?? 'No Phone 2',
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
    _imageDataList = fetchImageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Images'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
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
                String base64Data = imageData['data'] ?? '';
                String imageName = imageData['imageName'] ?? 'No Name';
                String imageDescription = imageData['description'] ?? 'No description';
                String imageLocationUrl = imageData['locationUrl'] ?? 'No URL available';
                String imageLocation = imageData['location'] ?? 'No place available';
                String imageId = imageData['id'] ?? 'No ID';
                double rating = double.tryParse(imageData['rating'] ?? '0.0') ?? 0.0;
                String phoneNo1 = imageData['phoneNo1'] ?? 'No Phone 1';
                String phoneNo2 = imageData['phoneNo2'] ?? 'No Phone 2';

                return GestureDetector(
                  onTap: () {},
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          base64Data.isNotEmpty
                              ? Image.memory(
                            base64Decode(base64Data),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : Container(width: 100, height: 100, color: Colors.grey),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  imageName,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Description: $imageDescription',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Location URL: $imageLocationUrl',
                                  style: TextStyle(fontSize: 14, color: Colors.blue),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Location: $imageLocation',
                                  style: TextStyle(fontSize: 14, color: Colors.green),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < rating ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Rating: ${rating.toStringAsFixed(1)} / 5',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
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
                                    currentRating: rating,
                                    currentPhoneNo1: phoneNo1,
                                    currentPhoneNo2: phoneNo2,
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
