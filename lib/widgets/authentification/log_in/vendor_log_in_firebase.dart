import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/header.dart';
import 'package:smart/common/no_account.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/widgets/vendor_home/vendor_home.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';
import 'package:smart/widgets/authentification/sign_up/vendor_sign_up_firebase.dart';
import 'package:smart/widgets/sign_choices/sign_choices.dart';

class VendorLogFirebase extends StatefulWidget {
  const VendorLogFirebase({
    super.key,
  });

  @override
  State<VendorLogFirebase> createState() => _VendorLogFirebaseState();
}

class _VendorLogFirebaseState extends State<VendorLogFirebase> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logIn(context);
  }

  /// Connection to firebase

  void _logIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      // Check if all the fields aren't empty
      if (email.isEmpty || password.isEmpty) {
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
              await FirebaseFirestore.instance.collection('vendors').doc(user.uid).get();
          // Retrieve the userType field from the document
          Map<String, dynamic>? userData = userDocument.data() as Map<String, dynamic>?;

          if (userData != null) {
            String? userType = userData['userType'];

            if (userType == 'user') {
              if (kDebugMode) {
                print("You are not a user");
              }
            } else if (userType == 'vendor') {
              if (kDebugMode) {
                print("Connection successfully");
              }
              // Navigate to the user-specific screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VendorHome(
                    vendorEmail: email,
                  ),
                ),
              );
            } else {
              // Handle unsupported user type
              if (kDebugMode) {
                print("Unsupported user type: $userType");
              }
              _updateErrorMessage('Unsupported user type: $userType');
            }
          } else {
            // Handle missing user data
            if (kDebugMode) {
              print("User data not found");
            }
            _updateErrorMessage('User data not found');
          }
        } else {
          // Handle null user
          if (kDebugMode) {
            print("User isn't found");
          }
          _updateErrorMessage("User isn't found");
        }
      } catch (e) {
        // Handle login error
        if (kDebugMode) {
          print("Login error: $e");
        }
        _updateErrorMessage('Login error: $e');
      }
    }
  }

  void _updateErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SignChoices(),
                ),
              );
            },
          ),
          title: const Row(
            children: [
              SizedBox(width: 70),
              Text('LOG IN'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Header(text: 'Please login in order to proceed'),
                  const SizedBox(height: 50.0),
                  TextFileds(
                    error: errorMessage,
                    controller: emailController,
                    label: "Vendor Email",
                    obscure: false,
                    input: TextInputType.emailAddress,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an Email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFileds(
                    error: errorMessage,
                    controller: passwordController,
                    label: "Vendor Password",
                    obscure: true,
                    input: TextInputType.visiblePassword,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Button(
                    label: "Log In as a Vendor",
                    onTap: () => _logIn(context),
                  ),
                  NoAccount(
                    text1: 'You don\'t have an account ? ',
                    text2: "SignUp as a Vendor",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VendorSignUpFirebase(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
