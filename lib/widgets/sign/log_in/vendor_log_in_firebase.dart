import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/header.dart';
import 'package:smart/common/no_account.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';
import 'package:smart/widgets/HomeForLogin/Home.dart';
import 'package:smart/widgets/sign/sign_up/vendor_sign_up_firebase.dart';

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

    User? user = await _auth.signInVendor(
      email,
      password,
    );

    if (user != null) {
      // Retrieve the vendor document from Firestore
      DocumentSnapshot vendorDocument =
          await FirebaseFirestore.instance.collection('vendors').doc(user.uid).get();

      if (vendorDocument.exists) {
        if (kDebugMode) {
          print("Vendor is successfully logged in");
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const Home(),
          ),
        );
      } else {
        // Show error dialog if vendor document does not exist
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('You have to be a vendor to sign in here.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        // Clear the email and password fields
        emailController.clear();
        passwordController.clear();
      }
    } else {
      // Handle login error
      if (kDebugMode) {
        print("Some error happened");
      }
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
              SizedBox(width: 70),
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
                  label: "Vendor Email",
                  obscure: false,
                  input: TextInputType.emailAddress,
                  validate: (value) => _validateEmail(value),
                ),
                const SizedBox(height: 20.0),
                TextFileds(
                  controller: passwordController,
                  label: "Vendor Password",
                  obscure: true,
                  input: TextInputType.visiblePassword,
                  validate: (value) => _validatePassword(value),
                ),
                const SizedBox(height: 40.0),
                Button(
                  label: "Log In as a Vendor",
                  onTap: _logIn, // Call login function here
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
