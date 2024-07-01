import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/screens/home_screen.dart';
import 'package:flutter_blog_app/screens/options_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const HomeScreen())));
      });
    } else {
      Timer(const Duration(seconds: 4), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const OptionsScreen())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/blog_logo.png'),
            ),
          ],
        ),
      ),
    );
  }
}
