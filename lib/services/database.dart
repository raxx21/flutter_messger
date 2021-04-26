import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ui_msg/models/user_firebase.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  //update the doc in collection
  Future updateUser(String username, String phone) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'phone': phone,
    });
  }

  //make list from snapshots
  List<UserDataFirebase> _userListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserDataFirebase(
        username: doc.data()['username'] ?? '',
        phone: doc.data()['phone'] ?? '',
      );
    }).toList();
  }

  //Stream to see the list of users
  Stream<List<UserDataFirebase>> get users {
    return userCollection.snapshots().map(_userListFromSnapshots);
  }
}
