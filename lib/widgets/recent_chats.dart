import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_msg/models/message_model.dart';
import 'package:flutter_ui_msg/models/user_firebase.dart';
import 'package:flutter_ui_msg/screens/chat_room.dart';
import 'package:flutter_ui_msg/services/database.dart';
import 'package:provider/provider.dart';

class RecentChats extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<List<UserDataFirebase>>(context) ?? [];
    final userdata = Provider.of<UserDocFirebase>(context);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
          child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: user.length,
              itemBuilder: (BuildContext context, int index) {
                final Message chat = chats[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ChatRoom(user: user[index])),
                  ),
                  child: userdata.uid == user[index].uid
                      ? SizedBox(
                          height: 10.0,
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: chat.unread
                                  ? Color(0xFFFFEFEE)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0))),
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 20.0, 5.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: user[index].imageUrl ==
                                              ''
                                          ? AssetImage(chat.sender.imageUrl)
                                          : NetworkImage(user[index].imageUrl),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user[index].username,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: Text(
                                            chat.text,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    chat.time,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  chat.unread
                                      ? Container(
                                          height: 20.0,
                                          width: 40.0,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'New',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ))
                                      : Text(''),
                                ],
                              )
                            ],
                          ),
                        ),
                );
              }),
        ),
      ),
    );
  }
}
