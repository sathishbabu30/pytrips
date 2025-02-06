import'package:flutter/material.dart';
import '../../Admin_Page/Admin_Backends/backend/_/Categories/Hotel/view_residential.dart';

void main(){
  runApp(Hotel_page());
}

class Hotel_page extends StatefulWidget {
  const Hotel_page({super.key});

  @override
  State<Hotel_page> createState() => _myappState();
}

class _myappState extends State<Hotel_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadHotelImage(),
    );
  }
}
