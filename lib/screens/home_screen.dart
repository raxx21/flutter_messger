import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_msg/models/message_model.dart';
import 'package:flutter_ui_msg/services/auth.dart';
import 'package:flutter_ui_msg/widgets/category_selector.dart';
import 'package:flutter_ui_msg/widgets/favorite_contact.dart';
import 'package:flutter_ui_msg/widgets/recent_chats.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () async {
              await _auth.logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CategorySelector(),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Column(
                  children: [
                    FavoriteContact(),
                    RecentChats(),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
