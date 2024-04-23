import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/header.dart';
import 'package:smart/common/no_account.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';
import 'package:smart/widgets/sign/log_in/user_log_in_firebase.dart';

class UserSignUpFirebase extends StatefulWidget {
  const UserSignUpFirebase({super.key});

  @override
  State<UserSignUpFirebase> createState() => _UserSignUpFirebaseState();
}

class _UserSignUpFirebaseState extends State<UserSignUpFirebase> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final userTypeController = TextEditingController();
  final ageController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final salaryController = TextEditingController();
  final employmentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final _formKey = GlobalKey<FormState>();

  /// Connection to firebase
  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String userType = userTypeController.text;
      int age = int.tryParse(ageController.text) ?? 0;
      String maritalStatus = maritalStatusController.text;
      double salary = double.tryParse(salaryController.text) ?? 0.0;
      String employment = employmentController.text;

      if (email.isEmpty ||
          firstName.isEmpty ||
          lastName.isEmpty ||
          password.isEmpty ||
          userType.isEmpty ||
          age.isOdd ||
          maritalStatus.isEmpty ||
          salary.isInfinite ||
          employment.isEmpty) {
        if (kDebugMode) {
          print("All fields must be filled.");
        }
        return;
      }

      try {
        User? user = await _auth.signUpWithEmailAndPassword(
          email,
          password,
          userType,
          firstName,
          lastName,
          age,
          maritalStatus,
          salary,
          employment,
        );

        if (user != null) {
          if (kDebugMode) {
            print("User is successfully created");
          }

          // Save user details to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'userId': user.uid,
            'email': email,
            'firstName': firstName,
            'lastName': lastName,
            'userType': userType,
            'age': age,
            'maritalStatus': maritalStatus,
            'salary': salary,
            'employment': employment,
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const UserLogFirebase(),
            ),
          );
        } else {
          if (kDebugMode) {
            print("Some error happened");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Sign up error: $e");
        }
        // Display an error message or perform some other action
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = pickedFile;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    userTypeController.dispose();
    ageController.dispose();
    maritalStatusController.dispose();
    salaryController.dispose();
    employmentController.dispose();
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
                    onPressed: _pickImage,
                    child: const Text('Upload Identity Card'),
                  ),
                  const SizedBox(height: 10.0),
                  _image != null ? Image.file(File(_image!.path)) : Container(),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: userTypeController,
                    decoration: InputDecoration(
                      labelText: 'User',
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
                        return 'Please enter your Type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),

                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
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
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),

                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
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
                        return 'Please enter your last name';
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
                    errorText: 'This field must be filled.',
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
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                      errorText: 'This field must be filled.',
                      labelText: 'Age',
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
                        return 'Please enter your age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: maritalStatusController,
                    decoration: InputDecoration(
                      labelText: 'Marital Status',
                      errorText: 'This field must be filled.',
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
                        return 'Please enter your Marital Status';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: salaryController,
                    decoration: InputDecoration(
                      labelText: 'Salary',
                      errorText: 'This field must be filled.',
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
                        return 'Please enter your Salary';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: employmentController,
                    decoration: InputDecoration(
                      labelText: 'Employment',
                      errorText: 'This field must be filled.',
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
                        return 'Please enter your Employment';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Button(
                    label: "Sign Up",
                    onTap: _signUp,
                  ),
                  const SizedBox(height: 10.0),
                  NoAccount(
                    text1: 'You  have an account ? ',
                    text2: "LogIn",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const UserLogFirebase(),
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
