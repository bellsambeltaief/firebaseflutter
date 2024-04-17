import 'package:flutter/material.dart';
import 'package:smart/common/button.dart';
import 'package:smart/common/header.dart';
import 'package:smart/common/no_account.dart';
import 'package:smart/common/text_field.dart';
import 'package:smart/models/m_login.dart';
import 'package:smart/services/user_services.dart';
import 'package:smart/widgets/sign/sign_up/sign_up.dart';
import 'package:smart/widgets/HomeForLogin/Home.dart';

class LogIn extends StatefulWidget {
  const LogIn({
    super.key,
  });

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _userService = UserService(); // Create an instance of UserService

  void _performLogin() async {
    try {
      var loginModel = MLogin(
        email: emailController.text,
        password: passwordController.text,
      );
      await _userService.loginUserWithModel(loginModel);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const Home(),
        ),
      );
    } catch (e) {
      _showErrorDialog(
        e.toString(),
      ); // Show error message if login fails
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Login Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("Okay"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  label: "Email",
                  obscure: false,
                  input: TextInputType.emailAddress,
                  validate: (value) => _validateEmail(value),
                ),
                const SizedBox(height: 20.0),
                TextFileds(
                  controller: passwordController,
                  label: "Password",
                  obscure: true,
                  input: TextInputType.visiblePassword,
                  validate: (value) => _validatePassword(value),
                ),
                const SizedBox(height: 40.0),
                Button(
                  label: "Log In",
                  onTap: _performLogin, // Call login function here
                ),
                NoAccount(
                  text1: 'You don\'t have an account ? ',
                  text2: "SignUp",
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => const SignUp(),
                    //   ),
                    // );
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
