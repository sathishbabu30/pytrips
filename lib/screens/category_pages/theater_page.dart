import'package:flutter/material.dart';
import '../../Admin_Page/Admin_Backends/backend/_/Categories/Theater/view_Theater.dart';

void main(){
  runApp(Theater_page());
}

class Theater_page extends StatefulWidget {
  const Theater_page({super.key});

  @override
  State<Theater_page> createState() => _myappState();
}

class _myappState extends State<Theater_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadTheaterImage(),
    );
  }
}
