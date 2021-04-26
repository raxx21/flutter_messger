import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_msg/models/user_firebase.dart';
import 'package:flutter_ui_msg/screens/home_screen.dart';
import 'package:flutter_ui_msg/screens/wrapper.dart';
import 'package:flutter_ui_msg/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserFirebase>.value(
      value: AuthService().userStream,
      child: MaterialApp(
        title: 'Flutter UI Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Color(0xFFFEF9EB),
        ),
        home: Wrapper(),
      ),
    );
  }
}
