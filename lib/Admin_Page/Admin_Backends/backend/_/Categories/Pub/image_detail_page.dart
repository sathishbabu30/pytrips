import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Make sure you have url_launcher in your pubspec.yaml
import 'dart:convert';

class ImageDetailPage extends StatelessWidget {
  final Map<String, String> imageData;

  // Constructor to receive the image data
  ImageDetailPage({required this.imageData});

  @override
  Widget build(BuildContext context) {
    // Get data with null checks to avoid null pointer exceptions
    String? base64Data = imageData['data'];
    String description = imageData['description'] ?? 'No Description available';
    String imageName = imageData['imageName'] ?? 'No Name';
    String locationUrl = imageData['locationUrl'] ?? 'No URL available';
    String location = imageData['location'] ?? 'No Location available';
    double rating = double.tryParse(imageData['rating'] ?? '0') ?? 0.0;

    // Check if base64 data is valid, if not show a fallback widget
    Widget imageWidget = base64Data != null && base64Data.isNotEmpty
        ? Image.memory(
      base64Decode(base64Data),
      width: double.infinity,
      height: 300,
      fit: BoxFit.cover,
    )
        : Icon(Icons.broken_image, size: 100); // Fallback icon

    return Scaffold(
      appBar: AppBar(
        title: Text('$imageName'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the image or a fallback if base64Data is invalid
            imageWidget,
            SizedBox(height: 16),
            // Display the image name
            Text(
              ' $imageName',textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),

            // Display the description
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$description',textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                Text(
                  ' $location',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: 300,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(width: 2,color: Colors.black26)
                //clipBehavior: Clip.hardEdge,
              ),
              child: ClipRRect(
                child: GestureDetector(
                  onTap: () async {
                    // Debugging to check if URL is valid
                    if (locationUrl.isNotEmpty) {
                      bool canOpen = await canLaunch(locationUrl);
                      print("Can open URL: $canOpen"); // Debugging print
                      if (canOpen) {
                        await launch(locationUrl); // Launch the URL
                      } else {
                        print('Could not launch URL: $locationUrl');
                      }
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Opacity(
                          opacity: 0.35,
                          child: Image.asset(
                            'assets/google map 1.webp',
                            fit: BoxFit.cover,
                            width: 320,
                            height: 130,
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                width: .5,
                              ),
                              right: BorderSide(width: .5),
                              top: BorderSide(width: .5),
                              bottom: BorderSide(width: .5)),
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Image.asset('assets/final_logo1.png')),
                      ),
                    ],
                  ),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            SizedBox(height: 16),
            // Display the numeric rating (removed star icons)

          ],
        ),
      ),
    );
  }
}
