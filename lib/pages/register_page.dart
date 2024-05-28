import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/my_button.dart';
import 'package:login/components/my_textfield.dart';
import 'package:login/components/square_tile.dart';
import 'package:login/services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, required this.onTap});

  Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //create a function
  void signUpUser() async {
    try {
      if (confirmPasswordController.text.trim() ==
          passwordController.text.trim()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        errormsg("Password don't match!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errormsg('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errormsg('The account already exists for that email.');
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
    confirmPasswordController.dispose();
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
                "Let's Create an account for you...",
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
                height: 20,
              ),

              // confirm Password
              MyTextfield(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(
                height: 20,
              ),

              //sign in
              MyButton(
                text: 'Sign Up',
                onTap: signUpUser,
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
                    'Already have a account?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Login Here',
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
