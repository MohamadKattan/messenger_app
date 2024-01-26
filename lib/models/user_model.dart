import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constants.dart';

class UserModel {
  String? userId;
  String? userName;
  String? userMail;
  bool? userOnLine;
  String? userToken;
  Timestamp? userLastSeen;

  UserModel(
      {this.userId,
      this.userMail,
      this.userName,
      this.userOnLine,
      this.userLastSeen,
      this.userToken});

  UserModel.fromMap(Map<String, dynamic> map) {
    userId = map[keyUserId];
    userName = map[keyUsername];
    userMail = map[keyUserMail];
    userOnLine = map[keyOnLine];
    userLastSeen = map[keyLastSeen];
    userToken = map[keyUserToken];
  }

  Map<String, dynamic> toJson() => {
        keyUserId: userId,
        keyUsername: userName,
        keyUserMail: userMail,
        keyOnLine: userOnLine ?? true,
        keyLastSeen: userLastSeen ?? DateTime.now(),
        keyUserToken: userToken ?? 'null'
      };
}
