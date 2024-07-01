import 'package:flutter/material.dart';
import 'package:flutter_blog_app/components/round_button.dart';
import 'package:flutter_blog_app/screens/login_screen.dart';
import 'package:flutter_blog_app/screens/signup_screen.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Register'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  const Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 300,
                    height: 300,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  RoundButton(
                      title: 'Login',
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const LoginScreen())));
                      }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  const Text(
                    'or',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  RoundButton(
                      title: 'Register',
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const SignupScreen())));
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
