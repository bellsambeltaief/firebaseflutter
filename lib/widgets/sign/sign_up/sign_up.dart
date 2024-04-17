// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:smart/common/button.dart';
// import 'package:smart/common/header.dart';
// import 'package:smart/common/no_account.dart';
// import 'package:smart/common/text_field.dart';
// import 'package:smart/services/user_services.dart';
// import 'package:smart/widgets/sign/log_in/log_in.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final cinController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   XFile? _image;
//   final _formKey = GlobalKey<FormState>();
//   final _userService = UserService(); //

//   Future<void> _pickImage() async {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       setState(() {
//         _image = pickedFile;
//       });
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   void _signUp() async {
//     if (_formKey.currentState!.validate()) {

//       Map<String, dynamic> userData = {
//         'email': emailController.text,
//         'password': passwordController.text,
//         'cin': cinController.text,
//       };

//       try {
//         await _userService.createUser(userData);
//         // Navigate to login on successful sign up
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => const LogIn(),
//           ),
//         );
//       } catch (e) {
//         _showErrorDialog(e.toString());
//       }
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Sign Up Error"),
//         content: Text(message),
//         actions: <Widget>[
//           TextButton(
//             child: const Text("Okay"),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     cinController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: <Widget>[
//                   const Header(
//                     text: 'Please create your account in order to be able to benefit from our service!',
//                   ),

//                   const SizedBox(height: 20.0),
//                   ElevatedButton(
//                     onPressed: _pickImage,
//                     child: const Text('Upload Identity Card'),
//                   ),
//                   const SizedBox(height: 10.0),
//                   _image != null ? Image.file(File(_image!.path)) : Container(),
//                   const SizedBox(height: 20.0),
//                   TextFormField(
//                     controller: emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: const OutlineInputBorder(),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: const BorderSide(
//                           color: Color.fromARGB(255, 10, 73, 167),
//                           width: 2.0,
//                         ),
//                       ),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter an email';
//                       } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                         return 'Enter a valid email address';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10.0),
//                   TextFileds(
//                     controller: cinController,
//                     label: 'CIN',
//                     obscure: false,
//                     input: TextInputType.number,
//                     validate: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your CIN';
//                       } else if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
//                         return 'CIN must be 8 digits long';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 10.0),

//                   /// TextField pour le mot de passe
//                   TextFileds(
//                     controller: passwordController,
//                     label: 'Password',
//                     obscure: true,
//                     input: TextInputType.visiblePassword,
//                     validate: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter your password';
//                       } else if (value.length < 8) {
//                         return 'Password must be at least 8 characters long';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 10.0),

//                   /// TextField pour confirmer le mot de passe
//                   TextFileds(
//                     controller: confirmPasswordController,
//                     label: 'Confirm Password',
//                     obscure: true,
//                     input: TextInputType.visiblePassword,
//                     validate: (value) {
//                       if (value != passwordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 20.0),
//                   Button(
//                     label: "Sign Up",
//                     onTap: _signUp,
//                   ),
//                   NoAccount(
//                     text1: 'You  have an account ? ',
//                     text2: "LogIn",
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => const LogIn(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
