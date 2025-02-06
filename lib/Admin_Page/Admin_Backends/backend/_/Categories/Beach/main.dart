import 'package:flutter/material.dart';
import 'add_beach.dart';
import 'delete_page.dart';
import 'view_beaches.dart';
import 'update_beach.dart';

class BeachApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beach App')),
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
              child: Text('Add Beach'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReadBeachImage()),
                );
              },
              child: Text('View Beach'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateImagePage()),
                );
              },
              child: Text('Edit Beach'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeletePage()),
                );
              },
              child: Text('Delete Beach'),
            ),
          ],
        ),
      ),
    );
  }
}
