import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../category_pages/Pub_page.dart';
import '../category_pages/beach_page.dart';
import '../category_pages/hotel_page.dart';
import '../category_pages/restaurants_page.dart';
import '../category_pages/shopping_page.dart';
import '../category_pages/temple_page.dart';
import '../category_pages/theater_page.dart';
import '../login & sign page/login_page.dart';
import '../weather/weather-home.dart';
import 'Event_images.dart';
import 'Navigation_pages/Entertainment_page.dart';
import 'Navigation_pages/Schedule_page.dart';
import 'Navigation_pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Successfully signed out!'),
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => login_page()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // EventImages

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 1),
                          child: Row(
                            children: [
                              Text(
                                'Hi Makkale',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(left: screenWidth * 0.378),
                              child: SizedBox(
                                height: screenHeight*0.065,
                                width: screenWidth*0.1560,
                                child: Image.asset(
                                    'assets/homepage_imgaes/path-removebg-preview.png'),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.14),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WeatherHome()));
                              },
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: Image.asset(
                                    'assets/weatherpage_images/cloudy.png'),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.025),
                            IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>login_page()));
                              },
                              icon: const Icon(Icons.notifications_none),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text(
                                'Explore ',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'PUDUCHERRY',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.040,
                  ),
                  //Image Carousel
                  Center(child: EventImageCarousel()),

                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'Category',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 220),
                        child: Icon(
                          Icons.keyboard_double_arrow_right_rounded,
                          color: Colors.black12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.030,
                  ),
                  //category
                  Category(),
                  SizedBox(height: screenHeight * 0.025),
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Recommended',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  // Recommended Items
                  Padding(
                    padding: const EdgeInsets.only(left: 9),
                    child: Column(
                      children: [
                        buildLocationCard(
                          'assets/recommended/arovile.webp',
                          'Auroville',
                          4.5,
                          () {
                            print('Auroville tapped');
                          },
                        ),
                        buildLocationCard(
                          'assets/recommended/beach1.jpg',
                          'Marina Beach',
                          4.3,
                          () {
                            print('Marina Beach tapped');
                          },
                        ),
                        buildLocationCard(
                          'assets/recommended/Providence-Mall-1.webp',
                          'Providence mall',
                          4.3,
                          () {
                            print('Providence mall tapped');
                          },
                        ),
                        buildLocationCard(
                          'assets/recommended/Sri manakula vinayagar Temple.jpg',
                          'Manakula Vinayagar ',
                          4.3,
                          () {
                            print('Manakula Vinayagar tapped');
                          },
                        ),
                        buildLocationCard(
                          'assets/entertainment_page/zoo.jpg',
                          'Zoo',
                          4.3,
                          () {
                            print('Marina Beach tapped');
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Schedule_page(),
            const EntertainmentPage(),
            const Profile_page()
          ],
        ),

        //circumnavigational
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black38,
          selectedItemColor: Colors.orangeAccent,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            _pageController.animateToPage(
              _currentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 26),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month, size: 25),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.border_all_rounded, size: 26),
              label: 'Entertainment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 26),
              label: 'Profile',
            ),
          ],
        ),
        //floating action button
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                mouseCursor: MouseCursor.defer,
                backgroundColor: Colors.orange.shade50,
                onPressed: () {
                /*  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  ChatBot(),
                    ),
                  );*/
                },
                child: ClipOval(
                  child: Image.asset(
                    'assets/chatbotpage_images/chatbot_logo.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Category() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CategoryItem(
              imageUrl: 'assets/category_images/temple.jpg',
              label: 'Temple',
              navigateTo: Temple_page(),
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            const SizedBox(width: 20),
            CategoryItem(
              imageUrl: 'assets/category_images/beach.jpg',
              label: 'Beach',
              navigateTo: Beach_page(),
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            const SizedBox(width: 20),
            CategoryItem(
              imageUrl: 'assets/category_images/shoppping.jpg',
              label: 'Shopping',
              navigateTo: Shopping_page(),
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            const SizedBox(width: 20),
            CategoryItem(
              imageUrl: 'assets/category_images/hotel.jpg',
              label: 'Hotel',
              navigateTo: Hotel_page(),
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            const SizedBox(width: 20),
            CategoryItem(
              imageUrl: 'assets/category_images/restaurant.jpg',
              label: 'Restaurant',
              navigateTo: Restaurants_page(),
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            const SizedBox(width: 20),
            CategoryItem(
              imageUrl: 'assets/category_images/theater.jpg',
              label: 'Theater',
              navigateTo: Theater_page(),
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            const SizedBox(width: 20),
            CategoryItem(
              imageUrl: 'assets/category_images/pub1.jpg',
              label: 'Pub',
              navigateTo: Pub_page(),
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget CategoryItem({
    required String imageUrl,
    required String label,
    required Widget navigateTo,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigateTo),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: screenWidth * 0.15,
              height: screenHeight * 0.070,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(2, 1),
                      blurRadius: 10,
                      color: Colors.black38)
                ],
              ),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.fill,

              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(label),
      ],
    );
  }
  // recommended containers

  Widget buildLocationCard(
      String imageUrl, String title, double rating, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            // Image Container
            Container(
              height: 200,
              width: screenWidth*.88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: screenWidth*.88,
                  width: 350,
                ),
              ),
            ),
            // Info Container
            Positioned(
              bottom: 0,
              child: Container(
                height: 55,
                width: screenWidth*.88,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                /*  border: Border(
                    bottom: BorderSide(width: 2),
                    right: BorderSide(width: .15),
                    left: BorderSide(width: .15),
                  ),*/
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 18,
                        ),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


