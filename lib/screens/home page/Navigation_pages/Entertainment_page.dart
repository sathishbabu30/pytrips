import 'package:flutter/material.dart';

void main() {
  runApp(EntertainmentPage());
}

class EntertainmentPage extends StatefulWidget {
  const EntertainmentPage({super.key});

  @override
  State<EntertainmentPage> createState() => _MyAppState();
}

class _MyAppState extends State<EntertainmentPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Entertainment'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                buildLocationCard(
                  'assets/entertainment_page/turf.webp',
                  'Turf',
                      () {
                    print('Turf tapped');
                  },
                ),
                buildLocationCard(
                  'assets/entertainment_page/museum.jpg',
                  'Museum',
                      () {
                    print('Museum tapped');
                  },
                ),
                buildLocationCard(
                  'assets/entertainment_page/park.jpg',
                  'Park',
                      () {
                    print('Park tapped');
                  },
                ),
                buildLocationCard(
                  'assets/entertainment_page/zoo.jpg',
                  'Zoo',
                      () {
                    print('Zoo tapped');
                  },
                ),


              ],
            ),
          ),
        )
      ),
    );
  }
  Widget buildLocationCard(
      String imageUrl, String title, VoidCallback onTap) {
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
                height: 40,
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
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
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
