
import'package:flutter/material.dart';

import '../../Admin_Page/Admin_Backends/backend/_/Categories/Shopping/view_shop.dart';

void main(){
  runApp(Shopping_page());
}

class Shopping_page extends StatefulWidget {
  const Shopping_page({super.key});

  @override
  State<Shopping_page> createState() => _myappState();
}

class _myappState extends State<Shopping_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadShopImage(),
    );
  }
}
