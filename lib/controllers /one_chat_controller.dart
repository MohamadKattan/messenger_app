import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_test/components%20/ctm_txt.dart';
import 'package:messenger_test/components%20/tost_msg.dart';
import 'package:messenger_test/models/one_chat_model.dart';
import 'package:messenger_test/models/user_model.dart';
import 'package:messenger_test/utils/constants.dart';

import '../models/my_chats_model.dart';

class OneChatController extends ChangeNotifier {
  final String _lastSeenReceiver = '';
  String get lastSeenReceiver => _lastSeenReceiver;
  final bool _isReceiverOnLine = false;
  bool get isReceiverOnLine => _isReceiverOnLine;
  bool _isLouding = false;
  bool get isLouding => _isLouding;

  bool _emojiShowing = false;
  bool get emojiShowing => _emojiShowing;

  void louding(bool state) {
    _isLouding = !state;
    notifyListeners();
  }

  void toggelEmoji(bool state) {
    _emojiShowing = state;
    notifyListeners();
  }

  Widget listeningToReceiverStatus({required String id}) {
    Stream<DocumentSnapshot> statusStream =
        firestore.collection(usersTable).doc(id).snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: statusStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('...');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("...");
        }
        if (!snapshot.data!.exists) {
          return const Text("Null");
        }

        final data1 = snapshot.data!.data();
        UserModel newUser = UserModel.fromMap(data1 as Map<String, dynamic>);

        return CustomTxt(
            newUser.userOnLine ?? false
                ? usrOnline
                : _formatDate(newUser.userLastSeen!),
            fSzie: 12,
            color: Colors.grey);
      },
    );
  }

  Future<void> addNewMsgToOneChat({
    required String newMsg,
    required String chatIdR,
    required String receiverIdR,
    required String reciverNameR,
  }) async {
    await firestore
        .collection(usersTable)
        .doc(receiverIdR)
        .get()
        .then((value) async {
      final newVal = value.get(FieldPath(const [keyOnLine]));
      OneChatModel oneChatModel = OneChatModel(msg: newMsg, readed: newVal);

      await firestore
          .collection(messagesTable)
          .doc(chatIdR)
          .collection('chat')
          .add(oneChatModel.toJson())
          .catchError((ex) => TostMsg().displayTostMsg(msg: catchError + ex))
          .then((value) async {
        MyChatsModel myChatsModel = MyChatsModel(
          chatId: chatIdR,
          receiverId: receiverIdR,
          receiverName: reciverNameR,
          lastMsg: newMsg,
        );

        await firestore
            .collection(usersTable)
            .doc(auth.currentUser?.uid)
            .collection(subMyChatTable)
            .doc(receiverIdR)
            .set(myChatsModel.toJson())
            .catchError((ex) => TostMsg().displayTostMsg(msg: catchError));

        await firestore
            .collection(usersTable)
            .doc(receiverIdR)
            .collection(subMyChatTable)
            .doc(auth.currentUser!.uid)
            .set({
          keyChatId: chatIdR,
          keyReceiverId: auth.currentUser?.uid,
          keyReceiverName: currentName ?? auth.currentUser?.displayName,
          keyLastMsg: newMsg,
          keyTime: DateTime.now()
        });
      }).catchError((ex) => TostMsg().displayTostMsg(msg: catchError));
    }).catchError(
            (ex) => TostMsg().displayTostMsg(msg: catchError + ex.toString()));
  }

  Future updateReadMsg(String chatId) async {
    await firestore
        .collection(messagesTable)
        .doc(chatId)
        .collection('chat')
        .where(keyOwnerMsg, isNotEqualTo: currentIdUser)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        firestore
            .collection(messagesTable)
            .doc(chatId)
            .collection('chat')
            .doc(doc.id)
            .update({keyReaded: true});
      }
    });
  }

  String _formatDate(Timestamp userLastSeen) {
    String txt = '';
    final lastTime = userLastSeen.toDate();
    txt =
        '$usrLastSeen${lastTime.day}-${lastTime.month}-${lastTime.year.toString().substring(2)}';
    return txt;
  }
}
