import 'package:flutter/material.dart';
import 'add_shop.dart';
import 'delete_shop.dart';
import 'view_shop.dart';
import 'update_shop.dart';


class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/addShop': (context) => CreateImagePage(),
        '/viewShop': (context) => ReadShopImage(),
        '/updateShop': (context) => UpdateImagePage(),
        '/deleteShop': (context) => DeletePage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addShop'),
              child: Text('Add Shop'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/viewShop'),
              child: Text('View Shop'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/updateShop'),
              child: Text('Edit Shop'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/deleteShop'),
              child: Text('Delete Shop'),
            ),
          ],
        ),
      ),
    );
  }
}
