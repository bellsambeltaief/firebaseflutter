import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/header.dart';
import 'package:smart/common/no_account.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';
import 'package:smart/widgets/sign/log_in/vendor_log_in_firebase.dart';

class VendorSignUpFirebase extends StatefulWidget {
  const VendorSignUpFirebase({super.key});

  @override
  State<VendorSignUpFirebase> createState() => _VendorSignUpFirebaseState();
}

class _VendorSignUpFirebaseState extends State<VendorSignUpFirebase> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final emailController = TextEditingController();
  final patentImageController = TextEditingController();
  final patentNumberController = TextEditingController();
  final companyNameController = TextEditingController();
  final userNameController = TextEditingController();
  final numeroCinController = TextEditingController();
  final passwordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _patentImage;
  final _formKey = GlobalKey<FormState>();

  /// Connection to firebase
  void _signUp() async {
    String email = emailController.text;
    String patentNumber = patentNumberController.text;
    String companyName = companyNameController.text;
    String userName = userNameController.text;
    String numeroCin = numeroCinController.text;
    String password = passwordController.text;

    /// Check if all the fields aren't empty
    if (email.isEmpty ||
        patentNumber.isEmpty ||
        companyName.isEmpty ||
        userName.isEmpty ||
        numeroCin.isEmpty ||
        password.isEmpty) {
      // Display an error message or perform some other action
      if (kDebugMode) {
        print("All fields must be filled.");
      }
      return;
    }

    User? user = await _auth.signUpVendor(
      userName,
      email,
      password,
      numeroCin,
      companyName,
      patentNumber,
    );

    if (user != null) {
      if (kDebugMode) {
        print("Vendor is successfully created");
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const VendorLogFirebase(),
        ),
      );
    } else {
      if (kDebugMode) {
        print("Some error happened");
      }
    }
  }

  Future<void> _pickPatentImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _patentImage = pickedFile;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error picking patent image: $e");
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    patentImageController.dispose();
    patentNumberController.dispose();
    companyNameController.dispose();
    numeroCinController.dispose();
    passwordController.dispose();
    super.dispose();
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
              Text('SIGN UP'),
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
                  const Header(
                    text: 'Please create your account in order to be able to benefit from our service!',
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _pickPatentImage,
                    child: const Text('Upload Patent Image'),
                  ),
                  const SizedBox(height: 10.0),
                  _patentImage != null ? Image.file(File(_patentImage!.path)) : Container(),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: patentNumberController,
                    decoration: InputDecoration(
                      labelText: 'Patent Number',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 10, 73, 167),
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your patent number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: companyNameController,
                    decoration: InputDecoration(
                      labelText: 'Company Name',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 10, 73, 167),
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your company name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 10, 73, 167),
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your manager name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: numeroCinController,
                    decoration: InputDecoration(
                      labelText: 'CIN Number',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 10, 73, 167),
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your CIN';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 10, 73, 167),
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),

                  /// TextField pour le mot de passe
                  TextFileds(
                    controller: passwordController,
                    label: 'Password',
                    obscure: true,
                    input: TextInputType.visiblePassword,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20.0),
                  Button(
                    label: "Sign Up as a Vendor",
                    onTap: _signUp,
                  ),
                  const SizedBox(height: 10.0),
                  NoAccount(
                    text1: 'You  have an account ? ',
                    text2: "LogIn as a Vendor",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const VendorLogFirebase(),
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
