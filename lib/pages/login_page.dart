import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/my_button.dart';
import 'package:login/components/my_textfield.dart';
import 'package:login/components/square_tile.dart';
import 'package:login/pages/forget_password_page.dart';
import 'package:login/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.onTap});

  Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //create a function
  void signInUser() async {
    //loading
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // login user
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        errormsg('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errormsg('Wrong password provided for that user.');
      }
    }
  }

  void errormsg(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(error),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              const Icon(
                Icons.lock,
                size: 90,
              ),

              const SizedBox(
                height: 50,
              ),

              //Welcome text
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //username textfield
              MyTextfield(
                controller: emailController,
                hintText: 'Enter Email...',
                obscureText: false,
              ),

              const SizedBox(
                height: 20,
              ),

              //password textfield
              MyTextfield(
                controller: passwordController,
                hintText: 'Enter Password...',
                obscureText: true,
              ),

              const SizedBox(
                height: 10,
              ),

              //forget password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ForgetPasswordPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Forget Password?',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //sign in
              MyButton(
                text: 'Sign In',
                onTap: signInUser,
              ),

              const SizedBox(
                height: 50,
              ),

              //or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 3,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or Continue with',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 3,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //google and apple logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    imagePath: 'lib/images/google_logo.jpeg',
                    onTap: () => AuthServices().signInWithGoogle(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SquareTile(
                    imagePath: 'lib/images/apple_logo.jpeg',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(
                height: 40,
              ),

              //not a member register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a Member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Register Now',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
