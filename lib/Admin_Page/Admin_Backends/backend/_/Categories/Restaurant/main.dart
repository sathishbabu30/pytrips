import 'package:flutter/material.dart';
import 'add_Restaurantp.dart';
import 'delete_Restaurant.dart';
import 'view_Restaurant.dart';
import 'update_Restaurant.dart';


class RestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/addRestaurant': (context) => CreateImagePage(),
        '/viewRestaurant': (context) => ReadRestaurantImage(),
        '/updateRestaurant': (context) => UpdateImagePage(),
        '/deleteRestaurant': (context) => DeletePage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restaurant App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addRestaurant'),
              child: Text('Add Restaurant'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/viewRestaurant'),
              child: Text('View Restaurant'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/updateRestaurant'),
              child: Text('Edit Restaurant'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/deleteRestaurant'),
              child: Text('Delete Restaurant'),
            ),
          ],
        ),
      ),
    );
  }
}
