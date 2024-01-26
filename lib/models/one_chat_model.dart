import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/constants.dart';

class OneChatModel {
  String? ownerMsg;
  String? msg;
  Timestamp? time;
  bool? readed;
  OneChatModel({this.ownerMsg, this.msg, this.time, this.readed});

  OneChatModel.fromMap(Map<String, dynamic> map) {
    ownerMsg = map[keyOwnerMsg];
    msg = map[keyMsg];
    time = map[keyTimeMsg];
    readed = map[keyReaded];
  }

  Map<String, dynamic> toJson() => {
        keyOwnerMsg: ownerMsg ?? auth.currentUser?.uid,
        keyMsg: msg,
        keyTimeMsg: time ?? DateTime.now(),
        keyReaded: readed ?? false
      };
}
