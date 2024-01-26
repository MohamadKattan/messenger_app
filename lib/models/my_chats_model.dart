import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_test/utils/constants.dart';

class MyChatsModel {
  String? chatId;
  String? receiverId;
  String? receiverName;
  String? lastMsg;
  Timestamp? time;
  MyChatsModel(
      {this.chatId,
      this.receiverId,
      this.receiverName,
      this.lastMsg,
      this.time});

  MyChatsModel.fromMap(Map<String, dynamic> map) {
    chatId = map[keyChatId];
    receiverId = map[keyReceiverId];
    receiverName = map[keyReceiverName];
    lastMsg = map[keyLastMsg];
    time = map[keyTime];
  }

  Map<String, dynamic> toJson() => {
        keyChatId: chatId,
        keyReceiverId: receiverId,
        keyReceiverName: receiverName,
        keyLastMsg: lastMsg,
        keyTime: time ?? DateTime.now()
      };
}
