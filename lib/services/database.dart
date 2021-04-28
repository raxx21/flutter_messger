import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_ui_msg/models/user_firebase.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  //update the doc in collection
  Future updateUser(String username, String phone, String imageUrl) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'phone': phone,
      'imageUrl': imageUrl,
    });
  }

  //make list from snapshots
  List<UserDataFirebase> _userListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserDataFirebase(
        uid: doc.id,
        username: doc.data()['username'] ?? '',
        phone: doc.data()['phone'] ?? '',
        imageUrl: doc.data()['imageUrl'],
      );
    }).toList();
  }

  //user doc data
  UserDocFirebase _userDocFirebase(DocumentSnapshot snapshot) {
    return UserDocFirebase(
      uid: uid,
      username: snapshot.data()['username'] ?? '',
      phone: snapshot.data()['phone'] ?? '',
      imageUrl: snapshot.data()['imageUrl'] ?? '',
    );
  }

  //Stream to see the list of users
  Stream<List<UserDataFirebase>> get users {
    return userCollection.snapshots().map(_userListFromSnapshots);
  }

  //Stream for the doc user
  Stream<UserDocFirebase> get userDoc {
    return userCollection.doc(uid).snapshots().map(_userDocFirebase);
  }

  //images from firebase
  imageFromFirebase(UserFirebase user, String imageUrl) async {
    final _storage = FirebaseStorage.instance;
    var snapshot = _storage.ref().child(user.uid);
    var downloadUrl = await snapshot.getDownloadURL();
    if (downloadUrl != null) {
      print(downloadUrl);
      imageUrl = downloadUrl;
    }
  }

  //method for sending the msg
  Future addMessage(
      String chatRoom, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoom)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessage(String chatRoom, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoom)
        .update(lastMessageInfoMap);
  }

  //create a chatroom
  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  //get messages from chats
  Future<Stream<QuerySnapshot>> getMessagesFromChat(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }
}
