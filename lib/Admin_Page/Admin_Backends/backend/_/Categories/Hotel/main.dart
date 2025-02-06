import 'package:flutter/material.dart';
import 'add_residential.dart';
import 'delete_residential.dart';
import 'view_residential.dart';
import 'update_residential.dart';

class ResidentialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Residential App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/addResidential': (context) => CreateImagePage(),
        '/viewResidential': (context) => ReadHotelImage(),
        '/updateResidential': (context) => UpdateImagePage(),
        '/deleteResidential': (context) => DeletePage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Residential App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addResidential'),
              child: Text('Add Residential'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/viewResidential'),
              child: Text('View Residential'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/updateResidential'),
              child: Text('Edit Residential'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/deleteResidential'),
              child: Text('Delete Residential'),
            ),
          ],
        ),
      ),
    );
  }
}
