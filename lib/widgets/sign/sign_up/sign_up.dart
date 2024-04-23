// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:smart/common/button.dart';
// import 'package:smart/common/header.dart';
// import 'package:smart/common/no_account.dart';
// import 'package:smart/common/text_field.dart';
// import 'package:smart/models/m_sign_up.dart';
// import 'package:smart/services/user_services.dart';
// import 'package:smart/widgets/sign/log_in/log_in.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({super.key});

//   @override
//   State<SignUp> createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   final emailController = TextEditingController();
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final passwordController = TextEditingController();
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
//       try {
//         var userData = MSignUpUser(
//           email: emailController.text,
//           password: passwordController.text,
//           firstName: firstNameController.text,
//           lastName: lastNameController.text,
//         );
//         var response = await _userService.registerUser(userData);
//         // Check if sign-up was successful
//         if (response['message'] == 'User created successfully') {
//           // Show success message
//           _showSuccessDialog('Sign up successful!');
//           // Navigate to login screen
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => const LogIn(),
//             ),
//           );
//         } else {
//           // Show error message if sign-up fails
//           _showErrorDialog('Sign up failed: ${response['message']}');
//         }
//       } catch (e) {
//         _showErrorDialog(e.toString());
//       }
//     }
//   }

//   void _showSuccessDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Sign Up Successful"),
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
//     firstNameController.dispose();
//     lastNameController.dispose();
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
//                   TextFormField(
//                     controller: firstNameController,
//                     decoration: InputDecoration(
//                       labelText: 'First Name',
//                       border: const OutlineInputBorder(),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: const BorderSide(
//                           color: Color.fromARGB(255, 10, 73, 167),
//                           width: 2.0,
//                         ),
//                       ),
//                     ),
//                     keyboardType: TextInputType.text,
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your first name';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 10.0),

//                   TextFormField(
//                     controller: lastNameController,
//                     decoration: InputDecoration(
//                       labelText: 'Last Name',
//                       border: const OutlineInputBorder(),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: const BorderSide(
//                           color: Color.fromARGB(255, 10, 73, 167),
//                           width: 2.0,
//                         ),
//                       ),
//                     ),
//                     keyboardType: TextInputType.text,
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your last name';
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
