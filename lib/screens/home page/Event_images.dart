import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import '../../Admin_Page/Admin_Backends/backend/_/EventImages/image_detail_page.dart';

class EventImageHandler {
  static const String _url = 'https://eventimage.onrender.com/images'; // Backend URL

  // Fetch images from the backend
  static Future<List<Map<String, dynamic>>> fetchImages() async {
    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        debugPrint('Failed to load images: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error fetching images: $error');
    }
    return [];
  }
}

class EventImageCarousel extends StatefulWidget {
  const EventImageCarousel({super.key});

  @override
  _EventImageCarouselState createState() => _EventImageCarouselState();
}

class _EventImageCarouselState extends State<EventImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isLoading = true;
  List<Map<String, dynamic>> _images = [];
  List<Uint8List> _decodedImages = []; // Cached decoded images
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Timer for automatic page transitions
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_pageController.hasClients && _images.isNotEmpty) {
        setState(() {
          _currentPage = (_currentPage + 1) % _images.length;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Fetch images from the backend
  Future<void> _fetchImages() async {
    final images = await EventImageHandler.fetchImages();
    if (mounted) {
      setState(() {
        _images = images;
        _decodedImages = images.map((image) => base64Decode(image['data'])).toList(); // Cache the decoded images
        isLoading = false;
      });
    }
  }

  // Build an individual image container
  Widget _buildImageContainer(Map<String, dynamic> image, int index) {
    final Uint8List imageData = _decodedImages[index]; // Use cached image data
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

  // Shimmer loading effect
  Widget _buildShimmerLoading() {
    return SizedBox(
      height: 190,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 330,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 5),
              ),
            );
          },
        ),
      ),
    );
  }

  // Build the image carousel
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        children: [
          isLoading
              ? _buildShimmerLoading()
              : PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) => _buildImageContainer(_images[index], index),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          if (_images.isNotEmpty)
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_images.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
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
    );
  }
}
