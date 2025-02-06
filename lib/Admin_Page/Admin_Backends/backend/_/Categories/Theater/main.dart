import 'package:flutter/material.dart';
import 'add_Theater.dart';
import 'delete_Theater.dart';
import 'view_Theater.dart';
import 'update_Theater.dart';


class TheaterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/addTheater': (context) => CreateImagePage(),
        '/viewTheater': (context) => ReadTheaterImage(),
        '/updateTheater': (context) => UpdateImagePage(),
        '/deleteTheater': (context) => DeletePage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Theater App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addTheater'),
              child: Text('Add Theater'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/viewTheater'),
              child: Text('View Theater'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/updateTheater'),
              child: Text('Edit Theater'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/deleteTheater'),
              child: Text('Delete Theater'),
            ),
          ],
        ),
      ),
    );
  }
}
