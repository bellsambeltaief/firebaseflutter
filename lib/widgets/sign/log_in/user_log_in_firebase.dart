import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/header.dart';
import 'package:smart/common/no_account.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';
import 'package:smart/widgets/sign/sign_up/user_sign_up_firebase.dart';
import 'package:smart/widgets/HomeForLogin/Home.dart';

class UserLogFirebase extends StatefulWidget {
  const UserLogFirebase({
    super.key,
  });

  @override
  State<UserLogFirebase> createState() => _UserLogFirebaseState();
}

class _UserLogFirebaseState extends State<UserLogFirebase> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Connection to firebase

  void _logIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Check if all the fields aren't empty
    if (email.isEmpty || password.isEmpty) {
      // Display an error message or perform some other action
      if (kDebugMode) {
        print("All fields must be filled.");
      }
      return;
    }

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        // Retrieve the user document from Firestore
        DocumentSnapshot userDocument =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        print("userrrrrrrrrrrrrrrrrrrr ${user.uid}");
        // Retrieve the userType field from the document
        Map<String, dynamic>? userData = userDocument.data() as Map<String, dynamic>?;

        if (userData != null) {
          String? userType = userData['userType'];

          if (userType == 'vendor') {
            if (kDebugMode) {
              print("You are not a user");
            }
          } else if (userType == 'user') {
            if (kDebugMode) {
              print("Connection successfully");
            }
            // Navigate to the user-specific screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const Home(),
              ),
            );
          } else {
            // Handle unsupported user type
            if (kDebugMode) {
              print("Unsupported user type: $userType");
            }
          }
        } else {
          // Handle missing user data
          if (kDebugMode) {
            print("User data not found");
          }
        }
      } else {
        // Handle null user
        if (kDebugMode) {
          print("User is null");
        }
      }
    } catch (e) {
      // Handle login error
      if (kDebugMode) {
        print("Login error: $e");
      }
      // Display an error message or perform some other action
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Row(
            children: [
              SizedBox(
                width: 70,
              ),
              Text('LOG IN'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Header(text: 'Please login in order to proceed'),
                const SizedBox(height: 50.0),
                TextFileds(
                  controller: emailController,
                  label: "Email",
                  obscure: false,
                  input: TextInputType.emailAddress,
                  validate: (value) => _validateEmail(value),
                ),
                const SizedBox(height: 20.0),
                TextFileds(
                  controller: passwordController,
                  label: "Password",
                  obscure: true,
                  input: TextInputType.visiblePassword,
                  validate: (value) => _validatePassword(value),
                ),
                const SizedBox(height: 40.0),
                Button(
                  label: "Log In",
                  onTap: _logIn, // Call login function here
                ),
                NoAccount(
                  text1: 'You don\'t have an account ? ',
                  text2: "SignUp",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const UserSignUpFirebase(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
}
