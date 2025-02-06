import'package:flutter/material.dart';
import '../../Admin_Page/Admin_Backends/backend/_/Categories/Pub/view_pub.dart';

void main(){
  runApp(Pub_page());
}

class Pub_page extends StatefulWidget {
  const Pub_page({super.key});

  @override
  State<Pub_page> createState() => _myappState();
}

class _myappState extends State<Pub_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadPubImage(),
    );
  }
}
