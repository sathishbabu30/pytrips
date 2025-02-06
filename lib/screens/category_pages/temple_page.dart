import 'package:flutter/material.dart';
import '../../Admin_Page/Admin_Backends/backend/_/Categories/Temple/view_temples.dart';

class Temple_page extends StatefulWidget {
  const Temple_page({super.key});

  @override
  State<Temple_page> createState() => _TemplePageState();
}

class _TemplePageState extends State<Temple_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ReadTempleImage(),
    );
  }
}
