
import'package:flutter/material.dart';

import '../../Admin_Page/Admin_Backends/backend/_/Categories/Restaurant/view_Restaurant.dart';

void main(){
  runApp(Restaurants_page());
}

class Restaurants_page extends StatefulWidget {
  const Restaurants_page({super.key});

  @override
  State<Restaurants_page> createState() => _myappState();
}

class _myappState extends State<Restaurants_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadRestaurantImage(),
    );
  }
}
