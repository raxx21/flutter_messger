class UserFirebase {
  final String uid;

  UserFirebase({this.uid});
}

class UserDataFirebase {
  final String username;
  final String phone;
  final String imageUrl;

  UserDataFirebase({this.username, this.phone, this.imageUrl});
}

class UserDocFirebase {
  final String uid;
  final String username;
  final String phone;
  final String imageUrl;

  UserDocFirebase({this.uid, this.username, this.phone, this.imageUrl});
}
