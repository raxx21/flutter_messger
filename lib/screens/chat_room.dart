import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_msg/models/message_model.dart';
import 'package:flutter_ui_msg/models/user_firebase.dart';
import 'package:flutter_ui_msg/models/user_model.dart';
import 'package:flutter_ui_msg/services/database.dart';
import 'package:random_string/random_string.dart';

class ChatRoom extends StatefulWidget {
  final UserDataFirebase user;
  final UserDocFirebase me;
  ChatRoom({this.user, this.me});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String chatRoomId, messageId = "", receiverUsername;
  String senderUsername, uid, imageUrl;
  Stream messageStream;
  TextEditingController messageEditingController = TextEditingController();

  //getting info from firebase
  getInfoFromFirebase() {
    senderUsername = widget.me.username;
    uid = widget.me.uid;
    imageUrl = widget.me.imageUrl;
    receiverUsername = widget.user.username;

    chatRoomId = getChatRoomId(senderUsername, receiverUsername);
    print(chatRoomId);
  }

  //creating chatroom
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      print("$b\_$a");
      return "$b\_$a";
    } else {
      print("$a\_$b");
      return "$a\_$b";
    }
  }

  //add messages
  addMessage(bool sendClicked) {
    if (messageEditingController.text != "") {
      String message = messageEditingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": senderUsername,
        "ts": lastMessageTs,
        "imgUrl": imageUrl,
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseService()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendIs": lastMessageTs,
          "lastMessageSendBy": senderUsername,
        };

        DatabaseService().updateLastMessage(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          //remove the text input
          messageEditingController.text = "";
          //make messageId blank so that we can make new msg
          messageId = "";
        }
      });
    }
  }

  //List of messages fetched
  Widget chatMessage() {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                reverse: true,
                padding: EdgeInsets.only(top: 20.0),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  bool isMe = ds["sendBy"] == senderUsername ? true : false;
                  return _buildMessage(ds, isMe);
                },
              )
            : Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ));
      },
    );
  }

  //get and set msg in screen
  getAndSetMessages() async {
    messageStream = await DatabaseService().getMessagesFromChat(chatRoomId);
    setState(() {});
  }

  //Functions on start
  doThisOnLaunch() async {
    await getInfoFromFirebase();
    getAndSetMessages();
  }

  _buildMessage(DocumentSnapshot ds, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(top: 8.0, left: 80.0, bottom: 8.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0))
            : BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ds["ts"].toString(),
            style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            ds["message"],
            style: TextStyle(
                color: Colors.blueGrey[700],
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: [
        msg,
        IconButton(
          icon: true ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: true ? Theme.of(context).primaryColor : Colors.blueGrey,
          onPressed: () {},
        ),
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.photo,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {}),
          Expanded(
              child: TextField(
            onChanged: (val) => addMessage(false),
            controller: messageEditingController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration.collapsed(
              hintText: 'Send a message..',
            ),
          )),
          IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                addMessage(true);
              }),
        ],
      ),
    );
  }

  @override
  void initState() {
    doThisOnLaunch();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(widget.user.username,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
            )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: chatMessage(),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    )),
                // child: ClipRRect(
                //   borderRadius: BorderRadius.only(
                //     topRight: Radius.circular(30.0),
                //     topLeft: Radius.circular(30.0),
                //   ),
                //   child:
                //   // ListView.builder(
                //   //     reverse: true,
                //   //     padding: EdgeInsets.only(top: 20.0),
                //   //     physics: const BouncingScrollPhysics(
                //   //         parent: AlwaysScrollableScrollPhysics()),
                //   //     itemCount: messages.length,
                //   //     itemBuilder: (BuildContext context, int index) {
                //   //       final Message message = messages[index];
                //   //       final bool isMe = message.sender.id == currentMe.id;
                //   //       return _buildMessage(message, isMe);
                //   //     }),
                // ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
