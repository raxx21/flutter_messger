import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_msg/models/user_firebase.dart';
import 'package:flutter_ui_msg/screens/loading.dart';
import 'package:flutter_ui_msg/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String imageUrl;
  bool loading = false;
  UserFirebase user;

  @override
  void didChangeDependencies() {
    final user = Provider.of<UserFirebase>(context);
    final userdata = Provider.of<UserDocFirebase>(context);
    _checkImage(user, userdata); // do heavy tasks here, e.g., network fetches.
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserFirebase>(context);
    return loading
        ? Loading()
        : StreamBuilder(
            stream: DatabaseService(uid: user.uid).userDoc,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                UserDocFirebase userData = snapshot.data;
                return Scaffold(
                  backgroundColor: Theme.of(context).primaryColor,
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text('Profile',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: Column(
                      children: [
                        (imageUrl != null)
                            ? Image.network(
                                imageUrl,
                                height: 200.0,
                                width: double.infinity,
                              )
                            : Placeholder(
                                fallbackHeight: 200.0,
                                fallbackWidth: double.infinity,
                              ),
                        SizedBox(
                          height: 30.0,
                        ),
                        RaisedButton(
                            color: Colors.lightBlue,
                            child: Text('Upload'),
                            onPressed: () {
                              print(user.uid);
                              _uploadImage(user, userData);
                            })
                      ],
                    ),
                  ),
                );
              } else {
                return Text('');
              }
            },
          );
  }

  _checkImage(UserFirebase user, UserDocFirebase userdata) async {
    loading = true;
    final _storage = FirebaseStorage.instance;
    // var snapshot = _storage.ref().child(user.uid);
    // if (snapshot == null) {
    //   print('hey');
    // }
    // var downloadUrl = await snapshot.getDownloadURL();
    // print('downloadUrl ${downloadUrl}');
    if (userdata.imageUrl == '') {
      imageUrl = null;
      loading = false;
    } else {
      imageUrl = userdata.imageUrl;
      loading = false;
    }
    // if (downloadUrl != null) {
    //   setState(() {
    //     imageUrl = downloadUrl;
    //     loading = false;
    //   });
    // } else {
    //   setState(() {
    //     loading = false;
    //   });
  }

  _uploadImage(UserFirebase user, UserDocFirebase userdata) async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    final DatabaseService _data = DatabaseService(uid: user.uid);
    PickedFile image;
    //Permission for photos
    await Permission.photos.request();

    var permissionRequest = await Permission.photos.request();

    if (permissionRequest.isGranted) {
      //selected image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        setState(() {
          loading = true;
        });
        //Upload to firebase
        var snapshot = await _storage.ref().child(user.uid).putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        //set image
        setState(() {
          imageUrl = downloadUrl;
          _data.updateUser(
              userdata.username ?? '', userdata.phone ?? '', downloadUrl ?? '');
          loading = false;
        });
      } else {
        print('image path not recieved');
      }
    } else {
      print('Permission not granted');
    }
  }
}
