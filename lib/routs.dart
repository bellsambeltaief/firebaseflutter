import 'package:flutter/material.dart';
import 'package:smart/widgets/sign/log_in/log_in.dart';
import 'package:smart/widgets/sign/sign_up/sign_up.dart';


class Routes {
  static const String login = '/login';
  static const String register = '/register';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LogIn());
      // case register:
      //   return MaterialPageRoute(builder: (_) => SignUp());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('Error: Invalid route')),
      );
    });
  }
}
