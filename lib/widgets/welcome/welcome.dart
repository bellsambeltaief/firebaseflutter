import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart/widgets/sign_choices/sign_choices.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 4),
      () => Navigator.of(context).pushReplacement(
        _createRoute(),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SignChoices(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 950),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        body: Center(
          child: Image.asset(
            'assets/a.png',
            width: 300,
            height: 120,
          ),
        ),
      ),
    );
  }
}
