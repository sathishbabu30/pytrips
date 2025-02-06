import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageDetailsPage extends StatelessWidget {
  final Map<String, dynamic> image;

  ImageDetailsPage({required this.image});

  @override
  Widget build(BuildContext context) {
    final Uint8List imageData = base64Decode(image['data']);
    return Scaffold(
      appBar: AppBar(
        title: Text(image['imageName'] ?? 'Image Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                imageData,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/dummy-post-horisontal.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              textAlign: TextAlign.justify,
              ' ${image['description'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Icon(
                Icons.location_on,
                color: Colors.redAccent,
              ),
              Text(
                ' ${image['location'] ?? 'N/A'}',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              )
            ]),
            SizedBox(height: 16),
            Center(
              child: Container(
                width: 300,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(width: 2, color: Colors.black26),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GestureDetector(
                    onTap: () async {
                      final url = image[
                          'locationUrl']; // Retrieve the URL from the image
                      if (url != null &&
                          url.isNotEmpty &&
                          await canLaunch(url)) {
                        await launch(url); // Launch the URL
                      } else {
                        // If the URL can't be launched, show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Could not open location URL')),
                        );
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Blurred Background Image
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
                        // Circular Logo
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.black),
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset('assets/final_logo1.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
