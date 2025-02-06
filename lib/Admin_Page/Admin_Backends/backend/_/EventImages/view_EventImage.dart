import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'image_detail_page.dart';


class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  List<Map<String, dynamic>> _images = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchImages();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _fetchImages() async {
    const String url = 'PLACE YOUR URL'; // Backend URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _images = List<Map<String, dynamic>>.from(json.decode(response.body));
          });
        }
      } else {
        print('Failed to load images: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching images: $error');
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_images.isNotEmpty) {
        if (mounted) {
          setState(() {
            _currentPage = (_currentPage + 1) % _images.length; // Loop to the first page
          });
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Widget _buildImageContainer(Map<String, dynamic> image) {
    final Uint8List imageData = base64Decode(image['data']);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageDetailsPage(image: image),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Image.memory(
            imageData,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/dummy-post-horisontal.jpg',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Carousel')),
      body: Center(
        child: SizedBox(
          height: 200,
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: _images.isEmpty
                    ? [Center(child: CircularProgressIndicator())]
                    : _images.map((image) => _buildImageContainer(image)).toList(),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_images.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.orange.shade200
                            : Colors.orange.shade50,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


