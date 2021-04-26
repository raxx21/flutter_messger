import 'package:cloud_firestore/cloud_firestore.dart';

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
}
