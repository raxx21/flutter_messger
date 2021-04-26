import 'package:flutter/material.dart';
import 'package:flutter_ui_msg/models/user_firebase.dart';
import 'package:flutter_ui_msg/screens/authentication.dart';
import 'package:flutter_ui_msg/screens/home_screen.dart';
import 'package:flutter_ui_msg/screens/login_screen.dart';
import 'package:flutter_ui_msg/screens/sign_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserFirebase>(context);

    if (user == null) {
      return Authentication();
    } else {
      return HomeScreen();
    }
  }
}
