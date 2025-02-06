import 'package:flutter/material.dart';
import 'add_pub.dart';
import 'delete_pub.dart';
import 'view_pub.dart';
import 'update_pub.dart';


class PubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pub App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/addPub': (context) => CreateImagePage(),
        '/viewPub': (context) => ReadPubImage(),
        '/updatePub': (context) => UpdateImagePage(),
        '/deletePub': (context) => DeletePage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pub App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addPub'),
              child: Text('Add Pub'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/viewPub'),
              child: Text('View Pub'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/updatePub'),
              child: Text('Edit Pub'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/deletePub'),
              child: Text('Delete Pub'),
            ),
          ],
        ),
      ),
    );
  }
}
