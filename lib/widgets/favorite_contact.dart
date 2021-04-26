import 'package:flutter/material.dart';
import 'package:flutter_ui_msg/models/message_model.dart';
import 'package:flutter_ui_msg/screens/chat_room.dart';

class FavoriteContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Favorite Contacts',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                      color: Colors.blueGrey,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    color: Colors.blueGrey,
                    iconSize: 28.0,
                    onPressed: () {},
                  ),
                ],
          ),
        ),
        Container(
          height: 120.0,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.only(left: 10.0),
            scrollDirection: Axis.horizontal,
            itemCount: favorites.length,
              itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRoom(user: favorites[index])), ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35.0,
                        backgroundImage: AssetImage(favorites[index].imageUrl),
                      ),
                      SizedBox(height: 6.0,),
                      Text(
                          favorites[index].name,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
              }
          ),
        )
      ],
    );
  }
}
