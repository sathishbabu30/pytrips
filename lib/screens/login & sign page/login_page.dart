import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_finalyearproject/screens/login%20&%20sign%20page/signup_page.dart';
import '../../Admin_Page/Admin_page.dart';
import '../Home page/Homepage.dart';
import 'forgot_pass.dart';

class login_page extends StatelessWidget {
  const login_page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool textVisible = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context) async {
    await _googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) {
      _showErrorMessage("Google Sign-In aborted");
      return;
    }

    try {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCredential.user!.displayName);
      print(userCredential.user!.email);
      print(userCredential.user!.metadata);

      _showSuccessMessage("Login successful!");

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showErrorMessage("Google Sign-In failed. Please try again.");
    }
  }

  void _showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      duration: const Duration(seconds: 2),
      elevation: 0,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      duration: const Duration(seconds: 2),
      elevation: 0,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _login() async {
    const String adminEmail = "pytripsa1@gmail.com";
    const String adminPassword = "rrrsa1mit";

    String loginId = _loginIdController.text.trim();
    String password = _passwordController.text.trim();

    if (loginId.isEmpty || password.isEmpty) {
      _showErrorMessage(loginId.isEmpty && password.isEmpty
          ? 'Login ID and Password are required.'
          : loginId.isEmpty
              ? 'Login ID is required.'
              : 'Password is required.');
    } else {
      try {
        if (loginId == adminEmail && password == adminPassword) {
          _showSuccessMessage("Welcome Admin!");
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          // Normal user login with Firebase
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: loginId, password: password);
          _showSuccessMessage("Login successful!");
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        _showErrorMessage("Incorrect login ID or Password.");
      }
    }
  }

  Future<void> _register() async {
    String loginId = _loginIdController.text.trim();
    String password = _passwordController.text.trim();

    if (loginId.isEmpty || password.isEmpty) {
      _showErrorMessage(loginId.isEmpty && password.isEmpty
          ? 'Login ID and Password are required.'
          : loginId.isEmpty
              ? 'Login ID is required.'
              : 'Password is required.');
    } else {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: loginId, password: password);

        _showSuccessMessage("Registration successful! Please log in.");
      } catch (e) {
        _showErrorMessage("Registration failed. Please try again.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.035),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  'assets/loginpage_images/image5.webp',
                  height: screenHeight * 0.45,
                  width: screenWidth * 1.9,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Column(
                children: [
                  TextField(
                    controller: _loginIdController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TextField(
                    controller: _passwordController,
                    obscureText: !textVisible,
                    cursorColor: Colors.black38,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            textVisible = !textVisible;
                          });
                        },
                        icon: Icon(
                          textVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.0005),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgottenPasswordActivity()),
                        );
                      },
                      child: const Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.black38),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(),));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.3,
                        vertical: screenHeight * 0.02,
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              (MaterialPageRoute(
                                  builder: (context) => signup_page())));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  const Text(
                    'or login with',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () => signInWithGoogle(context),
                    child: ClipRRect(
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Image.asset(
                            'assets/loginpage_images/google.png',
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey.shade300),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
