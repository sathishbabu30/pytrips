import 'package:flutter/material.dart';
import 'add_temple.dart';
import 'delete_page.dart';
import 'view_temples.dart';
import 'update_temple.dart';

class TempleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temple App',
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/addTemple': (context) => CreateImagePage(),
        '/viewTemples': (context) => ReadTempleImage(),
        '/updateTemple': (context) => UpdateImagePage(),
        '/deleteTemple': (context) => DeletePage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Temple App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addTemple'),
              child: Text('Add Temple'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/viewTemples'),
              child: Text('View Temples'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/updateTemple'),
              child: Text('Edit Temples'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/deleteTemple'),
              child: Text('Delete Temples'),
            ),
          ],
        ),
      ),
    );
  }
}
