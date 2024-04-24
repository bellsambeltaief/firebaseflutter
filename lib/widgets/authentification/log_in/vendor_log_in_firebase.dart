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
import 'package:smart/widgets/authentification/sign_up/vendor_sign_up_firebase.dart';

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
  final _formKey = GlobalKey<FormState>();
  String? emailError;
  String? passwordError;

  /// Connection to firebase

  void _logIn() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      if ([
        email,
        password,
      ].any((element) => element.isEmpty)) {
        setState(() {
          if (email.isEmpty) {
            emailError = 'Please enter your Email';
          }

          if (password.isEmpty) {
            passwordError = 'Please enter your password';
          }
        });
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
        }
      } else {
        // Handle login error
        if (kDebugMode) {
          print("Some error happened");
        }
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
                  error: emailError,
                  controller: emailController,
                  label: "Vendor Email",
                  obscure: false,
                  input: TextInputType.emailAddress,
                  validate: (value) => _validateEmail(value),
                ),
                const SizedBox(height: 20.0),
                TextFileds(
                  error: passwordError,
                  controller: passwordController,
                  label: "Vendor Password",
                  obscure: true,
                  input: TextInputType.visiblePassword,
                  validate: (value) => _validatePassword(value),
                ),
                const SizedBox(height: 40.0),
                Button(
                  label: "Log In as a Vendor",
                  onTap: _logIn, 
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
