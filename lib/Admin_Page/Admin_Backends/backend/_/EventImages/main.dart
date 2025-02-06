import 'package:flutter/material.dart';
import 'add_EventImage.dart'; // Ensure this file exists
import 'delete_EventImage.dart'; // Ensure this file exists
import 'view_EventImage.dart'; // Ensure this file exists
import 'update_EventImage.dart'; // Ensure this file exists

class EventImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EventImage App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateImagePage()),
                );
              },
              child: Text('Add EventImage'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageCarousel()),
                );
              },
              child: Text('View EventImage'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateImagePage()),
                );
              },
              child: Text('Edit EventImage'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeletePage()),
                );
              },
              child: Text('Delete EventImage'),
            ),
          ],
        ),
      ),
    );
  }
}
