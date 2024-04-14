import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart/widgets/sign/log_in/log_in.dart';

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
      () => Navigator.of(context).pushReplacement(_createRoute()),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const LogIn(),
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
        backgroundColor:
            Colors.blue[900], // Adjust the color to match your branding
        body: Center(
          child: Image.asset(
            'assets/a.png', // Replace with the path to your logo file
            width: 300, // Set this to the appropriate width for your logo
            height: 120, // Set this to the appropriate height for your logo
          ),
        ),
      ),
    );
  }
}
