import'package:flutter/material.dart';
import '../../Admin_Page/Admin_Backends/backend/_/Categories/Beach/view_beaches.dart';

void main(){
  runApp(Beach_page());
}

class Beach_page extends StatefulWidget {
  const Beach_page({super.key});

  @override
  State<Beach_page> createState() => _myappState();
}

class _myappState extends State<Beach_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadBeachImage(),
    );
  }
}
