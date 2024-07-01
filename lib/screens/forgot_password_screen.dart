import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_app/components/round_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool showSpinner = false;
  var emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: 'RECOVER PASSWORD',
                  onPress: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      setState(() {
                        showSpinner = false;
                      });
                      await auth
                          .sendPasswordResetEmail(
                              email: emailController.text.toString())
                          .then((value) {
                        toastMessages(
                            'Please check your Email, a reset link has been\nsent to you via this email');
                      }).onError((error, stackTrace) {
                        setState(() {
                          showSpinner = false;
                        });
                        toastMessages(error.toString());
                      });
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      toastMessages(e.toString());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void toastMessages(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16,
    );
  }
}
