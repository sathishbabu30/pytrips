import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../../screens/Home page/Homepage.dart';
import 'image_detail_page.dart';
import 'package:shimmer/shimmer.dart';

class ReadRestaurantImage extends StatefulWidget {
  @override
  _ReadImageState createState() => _ReadImageState();
}

class _ReadImageState extends State<ReadRestaurantImage> {
  late Future<List<Map<String, String>>> _imageDataList;
  List<Map<String, String>> _allImageDataList = [];
  List<Map<String, String>> _filteredImageDataList = [];
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false; // Variable to control the search bar visibility

  // Function to fetch image data from the backend
  Future<List<Map<String, String>>> fetchImageData() async {
    final response = await http
        .get(Uri.parse('PLACE YOUR URLs'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, String>> imageDataList =
          data.map<Map<String, String>>((imageJson) {
        return {
          'data': imageJson['data'] ?? '',
          'imageName': imageJson['imageName'] ?? 'No Name',
          'rating': imageJson['rating']?.toString() ?? 'No Rating',
          'location': imageJson['location'] ?? 'No Location',
          'description': imageJson['description'] ?? 'No description available',
          'locationUrl': imageJson['locationUrl'] ?? 'No URL available',
        };
      }).toList();

      setState(() {
        _allImageDataList = imageDataList;
        _filteredImageDataList = imageDataList;
      });
      return imageDataList;
    } else {
      throw Exception('Failed to load images');
    }
  }

  // Function to filter images based on search query (imageName and location)
  void _filterImages(String query) {
    List<Map<String, String>> filteredList =
        _allImageDataList.where((imageData) {
      return imageData['imageName']!
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          imageData['location']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredImageDataList = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    _imageDataList = fetchImageData();
    _searchController.addListener(() {
      _filterImages(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? Container(
                width: 300,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by image name or location...',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  ),
                  onChanged: (query) {
                    _filterImages(query);
                  },
                ),
              )
            : Text('Restaurant'),
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  // Clear the search when turning off the search bar
                  _searchController.clear();
                  _filteredImageDataList = _allImageDataList;
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              // Image list
              FutureBuilder<List<Map<String, String>>>(
                future: _imageDataList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show shimmer effect while loading data
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5, // Show 5 shimmer items
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            height: 200,
                            color: Colors.white,
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (_filteredImageDataList.isEmpty) {
                    return Center(child: Text('No images found'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      itemCount: _filteredImageDataList.length,
                      itemBuilder: (context, index) {
                        Map<String, String> imageData =
                            _filteredImageDataList[index];
                        String base64Data = imageData['data']!;
                        String imageName = imageData['imageName']!;
                        double screenHeight =
                            MediaQuery.of(context).size.height;
                        double screenWidth = MediaQuery.of(context).size.width;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ImageDetailPage(imageData: imageData),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 1),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black38),
                              ],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35),
                                bottomLeft: Radius.circular(35),
                              ),
                            ),
                            margin: EdgeInsets.only(bottom: 35),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Image.memory(
                                    base64Decode(base64Data),
                                    fit: BoxFit.cover,
                                    height: screenHeight * 0.26,
                                    width: screenWidth * 0.9,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: screenHeight * 0.065,
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(35),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        imageName,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
