import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_test/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../components /tost_msg.dart';
import '../utils/constants.dart';
import '../views/chat_one.dart';

class SearchUsersController extends ChangeNotifier {
  var uuid = const Uuid();
  final List<UserModel> _listusers = [];
  List<UserModel> get listusers => _listusers;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  void _startSearching(bool state) {
    _isSearching = state;
    notifyListeners();
  }

  // get users that exist in db
  Future<void> startSearchUser(String value, BuildContext context) async {
     context.read<SearchUsersController>()._listusers.clear();
    context.read<SearchUsersController>()._startSearching(true);
    await firestore
        .collection(usersTable)
        .where(keyUserMail, isEqualTo: value)
        .get()
        .catchError((ex) {
      context.read<SearchUsersController>()._startSearching(false);
      return TostMsg().displayTostMsg(msg: ex.toString());
    }).then((QuerySnapshot querySnapshot) {
      context.read<SearchUsersController>()._startSearching(false);
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
        UserModel newUser = UserModel.fromMap(map);
        context.read<SearchUsersController>()._listusers.add(newUser);
      }
    });
  }

  checkIfUserInMyChat(
      {required String? id,
      required BuildContext context,
      required String? name,
      required bool? isOn}) async {
    int index = 0;
    String? myId = auth.currentUser?.uid;
    if (checkMyChatsListId.isNotEmpty) {
      for (var i in checkMyChatsListId) {
        if (i.receiverId == id) {
          await firestore
              .collection(usersTable)
              .doc(myId)
              .collection(subMyChatTable)
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              String chatId = doc[keyChatId];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatOneScreen(
                    receiverId: id,
                    receiverName: name,
                    chatId: chatId,
                  ),
                ),
              );
            }
          });

          break;
        } else {
          index += 1;
          if (index == checkMyChatsListId.length) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatOneScreen(
                  receiverId: id,
                  receiverName: name,
                  chatId: uuid.v4(),
                ),
              ),
            );
          }
        }
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatOneScreen(
            receiverId: id,
            receiverName: name,
            chatId: uuid.v4(),
          ),
        ),
      );
    }
  }
}
