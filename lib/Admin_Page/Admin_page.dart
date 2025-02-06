import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/login & sign page/login_page.dart';
import 'Admin_Backends/backend/_/Categories/Beach/main.dart';
import 'Admin_Backends/backend/_/Categories/Hotel/main.dart';
import 'Admin_Backends/backend/_/Categories/Pub/main.dart';
import 'Admin_Backends/backend/_/Categories/Restaurant/main.dart';
import 'Admin_Backends/backend/_/Categories/Shopping/main.dart';
import 'Admin_Backends/backend/_/Categories/Temple/main.dart';
import 'Admin_Backends/backend/_/Categories/Theater/main.dart';
import 'Admin_Backends/backend/_/EventImages/main.dart';

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
      home: AdminPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final ImagePicker picker = ImagePicker();
  List<File> _images = [];
  final int _currentPage = 0;
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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

  Widget _buildImageContainerFromFile(File file) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: FileImage(file),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text(
                            'Hi Admin',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.admin_panel_settings,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 145),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset(
                                'assets/homepage_imgaes/path-removebg-preview.png'),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.2),
                        IconButton(
                          onPressed: () {
                            _signOut();
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
                            'Manage ',
                            style: TextStyle(
                              fontSize: 18,
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
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventImagePage(),
                          ));
                    },
                    child: Container(
                      height: 200,
                      width: 400,
                      color: Colors.black45,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TempleApp()));
                          },
                          child: Text('Temple')),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BeachApp()));
                          },
                          child: Text('Beach')),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShoppingApp()));
                      }, child: Text('Shopping')),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResidentialApp()));
                      }, child: Text('Hotel')),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestaurantApp()));
                          }, child: Text('Restaurant')),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PubApp()));
                      }, child: Text('Pub')),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TheaterApp()));
                      }, child: Text('Theater')),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
