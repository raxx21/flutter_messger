import 'package:flutter/material.dart';
import 'package:flutter_ui_msg/screens/login_screen.dart';
import 'package:flutter_ui_msg/screens/sign_screen.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showLogIn = true;
  void toggleView() {
    setState(() {});
    showLogIn = !showLogIn;
  }

  @override
  Widget build(BuildContext context) {
    if (showLogIn) {
      return Login(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
