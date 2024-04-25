import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/header.dart';
import 'package:smart/common/no_account.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/services/storage_service.dart';
import 'package:smart/widgets/firebase_auth_imp/firebase_auth_services.dart';
import 'package:smart/widgets/authentification/log_in/vendor_log_in_firebase.dart';

class VendorSignUpFirebase extends StatefulWidget {
  const VendorSignUpFirebase({super.key});

  @override
  State<VendorSignUpFirebase> createState() => _VendorSignUpFirebaseState();
}

class _VendorSignUpFirebaseState extends State<VendorSignUpFirebase> {
  final Storage storage = Storage();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final emailController = TextEditingController();
  final patentImageController = TextEditingController();
  final patentNumberController = TextEditingController();
  final companyNameController = TextEditingController();
  final userNameController = TextEditingController();
  final numeroCinController = TextEditingController();
  final passwordController = TextEditingController();
  final userTypeController = TextEditingController();
  final imagePathController = TextEditingController();
  File? _pickedImage;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _signUpVendor();
  }

  /// Pick an Image
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

  /// Upload it to firestore
  Future<void> _uploadImage() async {
    if (_pickedImage != null) {
      final fileName = _pickedImage!.path.split('/').last;

      // Uploading the file to your storage library
      final uploadTask = storage.UploadFile(_pickedImage!.path, fileName);

      // Getting download URL after upload
      uploadTask.then((value) {
        firebase_storage.FirebaseStorage.instance
            .ref('testing/$fileName')
            .getDownloadURL()
            .then((downloadURL) {
          if (kDebugMode) {
            print("Download URL: $downloadURL");
          }
        });
      });

      if (kDebugMode) {
        print("File Name: $fileName");
        print("Path: ${_pickedImage!.path}");
      }
    } else {
      if (kDebugMode) {
        print("No image picked");
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  String? emailError;
  String? patentNumberError;
  String? companyNameError;
  String? userNameError;
  String? numeroCinError;
  String? passwordError;

  /// Fonction signup du vendeur
  void _signUpVendor() async {
 

    setState(() {
      emailError = null;
      patentNumberError = null;
      companyNameError = null;
      userNameError = null;
      numeroCinError = null;
      passwordError = null;
    });

    if (_formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String patentNumber = patentNumberController.text.trim();
      String companyName = companyNameController.text.trim();
      String userName = userNameController.text.trim();
      String numeroCin = numeroCinController.text.trim();
      String password = passwordController.text;
      String userType = userTypeController.text.trim();
      String imagePath = imagePathController.text.trim();

      if ([
        email,
        patentNumber,
        companyName,
        userName,
        numeroCin,
        password,
      ].any((element) => element.isEmpty)) {
        setState(() {
          if (email.isEmpty) {
            emailError = 'Please enter your Email';
          }
          if (patentNumber.isEmpty) {
            patentNumberError = 'Please enter your Patent Number';
          }
          if (companyName.isEmpty) {
            companyNameError = 'Please enter your Company Name';
          }
          if (userName.isEmpty) {
            userNameError = 'Please enter your User Name';
          }
          if (numeroCin.isEmpty) {
            numeroCinError = 'Please enter your CIN Number';
          }
          if (password.isEmpty) {
            passwordError = 'Please enter your password';
          }
        });
        return;
      }
      try {
        User? user = await _auth.signUpVendor(
          userName,
          email,
          password,
          numeroCin,
          companyName,
          patentNumber,
          userType,
          imagePath,
        );

        if (user != null) {
          if (kDebugMode) {
            print("Vendor is successfully created ");
          }
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const VendorLogFirebase(),
            ),
          );
          if (_pickedImage == null) {
            if (kDebugMode) {
              print("Please pick an image");
            }
            return;
          }

          // Upload the image to storage
          final fileName = _pickedImage!.path.split('/').last;
          final firebase_storage.Reference storageRef =
              firebase_storage.FirebaseStorage.instance.ref('VendorsImages/$fileName');
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
          // Save vendor details to Firestore (excluding the password)
          await FirebaseFirestore.instance.collection('vendors').doc(user.uid).set({
            'email': email,
            'patentNumber': patentNumber,
            'companyName': companyName,
            'userName': userName,
            'numeroCin': numeroCin,
            'userType': userType,
            'password': password,
            'imagePath': downloadURL,
          });
        } else {
          if (kDebugMode) {
            print("Failed to create vendor account. Please check your input and try again.");
          }
        }
        setState(() {
          _isLoading = false; // Marquer la fin du chargement
        });
      } catch (e) {
        setState(() {
          _isLoading = false; // Marquer la fin du chargement en cas d'erreur
        });
        if (kDebugMode) {
          print("Sign up error: $e");
        }
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
    userTypeController.dispose();
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
        body: Stack(
          children: [
            SingleChildScrollView(
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
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text("Upload your Patent picture"),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      _pickedImage != null
                          ? Image.file(_pickedImage!) // Display the picked image if available
                          : Container(), // Empty container if no image is picked
                      const SizedBox(height: 20.0),
                      TextFileds(
                        controller: userTypeController,
                        label: 'Vendor',
                        obscure: false,
                        input: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your user type';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20.0),

                      /// TextField pour le numéro du patente
                      TextFileds(
                        error: patentNumberError,
                        controller: patentNumberController,
                        label: 'Patent Number',
                        obscure: false,
                        input: TextInputType.number,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Patent Number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10.0),

                      /// Text Field pour le nom du company
                      TextFileds(
                        error: companyNameError,
                        controller: companyNameController,
                        label: 'Company Name',
                        obscure: false,
                        input: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Company Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),

                      /// TextField pour le numéro du CIN
                      TextFileds(
                        error: numeroCinError,
                        controller: numeroCinController,
                        label: 'CIN Number',
                        obscure: false,
                        input: TextInputType.number,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your CIN Number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10.0),

                      /// Text field pour le nom d'utilisateur
                      TextFileds(
                        error: userNameError,
                        controller: userNameController,
                        label: 'User Name',
                        obscure: false,
                        input: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your User Name';
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

                      const SizedBox(height: 20.0),
                      Button(
                        label: "Sign Up as a Vendor",
                        onTap: _signUpVendor,
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
            Visibility(
              // Afficher le cercle de chargement seulement lorsque _isLoading est vrai
              visible: _isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.5), // Fond semi-transparent
                child: const Center(
                  // Centrer le cercle de chargement
                  child: CircularProgressIndicator(), // Cercle de chargement
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
