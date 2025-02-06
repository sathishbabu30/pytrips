import 'package:flutter/material.dart';
import 'login_page.dart';

class reset_pass extends StatelessWidget {
  const reset_pass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => login_page()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.black),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Password reset link sent!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please check your email and follow the link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
