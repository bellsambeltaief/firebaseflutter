import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/header.dart';
import 'package:smart/common/no_account.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';
import 'package:smart/widgets/authentification/log_in/user_log_in_firebase.dart';

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
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? emailError;
  String? firstNameError;
  String? lastNameError;
  String? ageError;
  String? maritalStatusError;
  String? salaryError;
  String? employmentErorr;
  String? passwordError;
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = pickedFile;
      });
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String> uploadFile(XFile file) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('user_uploads/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(File(file.path));
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }

  /// Connection to firebase
  void _signUp() async {
    setState(() {
      emailError = null;
      firstNameError = null;
      lastNameError = null;
      ageError = null;
      employmentErorr = null;
      salaryError = null;
      maritalStatusError = null;
      passwordError = null;
    });

    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String age = ageController.text.trim();
      String employment = employmentController.text.trim();
      String password = passwordController.text;
      String maritalStatus = passwordController.text;
      String salary = passwordController.text;
      String userType = userTypeController.text.trim();

      if ([
        email,
        firstName,
        lastName,
        employment,
        age,
        maritalStatus,
        salary,
        password,
      ].any((element) => element.isEmpty)) {
        setState(() {
          if (email.isEmpty) {
            emailError = 'Please enter your Email';
          }
          if (firstName.isEmpty) {
            firstNameError = 'Please enter your First Name';
          }
          if (lastName.isEmpty) {
            lastNameError = 'Please enter your Last Name';
          }
          if (employment.isEmpty) {
            employmentErorr = 'Please enter your Employment';
          }
          if (age.isEmpty) {
            ageError = 'Please enter your Age Number';
          }
          if (maritalStatus.isEmpty) {
            maritalStatusError = 'Please enter your Marital Status';
          }
          if (salary.isEmpty) {
            salaryError = 'Please enter your Salary';
          }
          if (password.isEmpty) {
            passwordError = 'Please enter your password';
          }
        });
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

        /// Upload file if selected
        if (_image != null) {
          String imageUrl = await uploadFile(_image!);
          // Optionally save imageUrl to Firestore or use it as needed
          if (imageUrl.isNotEmpty) {
            // File uploaded successfully
            if (kDebugMode) {
              print("File uploaded. Image URL: $imageUrl");
            }
          } else {
            // Error uploading file
            if (kDebugMode) {
              print("Error uploading file");
            }
          }
        }
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
                  Center(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Add your CIN image'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _image != null ? Image.file(File(_image!.path)) : Container(),
                  const SizedBox(height: 20.0),

                  /// Text field pour le prénom
                  TextFileds(
                    error: firstNameError,
                    controller: firstNameController,
                    label: 'First Name',
                    obscure: false,
                    input: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),

                  /// Text field pour le nom
                  TextFileds(
                    error: lastNameError,
                    controller: lastNameController,
                    label: 'Last Name',
                    obscure: false,
                    input: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),

                  /// Text field pour l'adresse Email
                  TextFileds(
                    error: emailError,
                    controller: emailController,
                    label: 'Email',
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

                  /// TextField pour le mot de passe
                  TextFileds(
                    error: passwordError,
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
                  const SizedBox(height: 10.0),

                  /// TextField pour l'âge
                  TextFileds(
                    error: ageError,
                    controller: ageController,
                    label: 'Age',
                    obscure: false,
                    input: TextInputType.number,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Age';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),

                  /// TextField pour le status
                  TextFileds(
                    error: maritalStatusError,
                    controller: maritalStatusController,
                    label: 'Marital Status',
                    obscure: false,
                    input: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Marital Status';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),

                  /// TextField pour le Salaire
                  TextFileds(
                    error: salaryError,
                    controller: salaryController,
                    label: 'Salary',
                    obscure: false,
                    input: TextInputType.number,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Salary';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),

                  /// TextField pour l'emploi
                  TextFileds(
                    error: employmentErorr,
                    controller: employmentController,
                    label: 'Employment',
                    obscure: false,
                    input: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
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
