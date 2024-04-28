import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/header.dart';
import 'package:smart/common/no_account.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/services/storage_service.dart';
import 'package:smart/widgets/authentification/log_in/user_log_in_firebase.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';

class UserSignUpFirebase extends StatefulWidget {
  const UserSignUpFirebase({super.key});

  @override
  State<UserSignUpFirebase> createState() => _UserSignUpFirebaseState();
}

class _UserSignUpFirebaseState extends State<UserSignUpFirebase> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final userTypeController = TextEditingController();
  final ageController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final salaryController = TextEditingController();
  final employmentController = TextEditingController();
  final imagePathController = TextEditingController();
  final Storage storage = Storage();
  final _formKey = GlobalKey<FormState>();
 File? _pickedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _signUp();
  }

  /// Pick an image
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpeg'],
    );
    if (result != null) {
      setState(() {
        _pickedImage = File(result.files.single.path!);
      });
    } else {
      if (kDebugMode) {
        print("No file selected");
      }
    }
  }

  /// Upload images to firebase
  Future<void> _uploadImage() async {
    if (_pickedImage != null) {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      final fileName = _pickedImage!.path.split('/').last;
      final storageRef = firebase_storage.FirebaseStorage.instance.ref('UsersImages/$userEmail/$fileName');

      try {
        await storageRef.putFile(_pickedImage!);
        final downloadURL = await storageRef.getDownloadURL();
        if (kDebugMode) {
          print("Download URL: $downloadURL");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Failed to upload image: $e");
        }
      }
    } else {
      if (kDebugMode) {
        print("No image picked");
      }
    }
  }

  /// Connection to firebase
  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String userName = userNameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String userType = userTypeController.text;
      int age = int.tryParse(ageController.text) ?? 0;
      String maritalStatus = maritalStatusController.text;
      String imagePath = imagePathController.text;
      double salary = double.tryParse(salaryController.text) ?? 0.0;
      String employment = employmentController.text;

      if (email.isEmpty ||
          userName.isEmpty ||
          password.isEmpty ||
          userType.isEmpty ||
          age <= 0 || // Adjusted validation condition for age
          maritalStatus.isEmpty ||
          salary <= 0.0 || // Adjusted validation condition for salary
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
          userName,
          age,
          maritalStatus,
          salary,
          employment,
          imagePath,
        );

        if (user != null) {
          if (kDebugMode) {
            print("User is successfully created");
          }
          if (_pickedImage == null) {
            if (kDebugMode) {
              print("Please pick an image");
            }
            return;
          }

          // Upload the image to storage
          final userEmail = FirebaseAuth.instance.currentUser?.email;
          final fileName = _pickedImage!.path.split('/').last;
          final firebase_storage.Reference storageRef =
              firebase_storage.FirebaseStorage.instance.ref('UsersImages/$userEmail/$fileName');
          await storageRef.putFile(_pickedImage!);

          // Get the download URL
          final downloadURL = await storageRef.getDownloadURL();

          // Now you can proceed with the sign-up process with the image downloadURL
          final email = emailController.text;
          final password = passwordController.text;

          // Perform your sign-up logic here, passing the downloadURL along with other user details
          if (kDebugMode) {
            print("Signing up with email: $email, password: $password, imagePath: $downloadURL");
          }
          if (_pickedImage != null) {
            await _uploadImage(); // Upload the picked image
          }
          // Save user details to Firestore
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'userId': user.uid,
            'email': email,
            'userName': userName,
            'userType': userType,
            'age': age,
            'maritalStatus': maritalStatus,
            'salary': salary,
            'employment': employment,
            'password': password,
            'imagePath': downloadURL,
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
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
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
                  Center(
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text("Upload your CIN picture"),
                    ),
                  ),
                  if (_pickedImage != null)
                    Image.file(
                      _pickedImage!,
                      width: 200,
                      height: 200,
                    )
                  else
                    Container(),
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
                        return 'Please enter your user name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10.0),

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
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
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
                    keyboardType: TextInputType.number,
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
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 10, 73, 167),
                          width: 2.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
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
