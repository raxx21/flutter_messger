import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ui_msg/models/user_firebase.dart';
import 'package:flutter_ui_msg/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create cust based user struct from user model
  UserFirebase _userFromUserFirebase(User user) {
    return user != null ? UserFirebase(uid: user.uid) : null;
  }

  //stream for authchange
  Stream<UserFirebase> get userStream {
    return _auth.authStateChanges().map(_userFromUserFirebase);
  }

  //sign method
  Future signUpWithEmailAndPassword(
      String email, String password, String username, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //create user in user collection
      await DatabaseService(uid: user.uid).updateUser(username, phone, '');
      return _userFromUserFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //login method
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromUserFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out method
  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
