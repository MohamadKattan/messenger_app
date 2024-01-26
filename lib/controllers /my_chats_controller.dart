import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_test/components%20/ctm_progress.dart';
import 'package:messenger_test/components%20/ctm_txt.dart';
import 'package:messenger_test/components%20/tost_msg.dart';
import 'package:messenger_test/models/my_chats_model.dart';
import 'package:messenger_test/utils/constants.dart';
import 'dart:math' as math;

import '../views/chat_one.dart';

class ListAllMyChats extends StatelessWidget {
  const ListAllMyChats({super.key});

  @override
  Widget build(BuildContext context) {
    String id = auth.currentUser?.uid ?? 'null';
    checkMyChatsListId.clear();
    final Stream<QuerySnapshot> myChatStream = firestore
        .collection(usersTable)
        .doc(id)
        .collection(subMyChatTable)
        .snapshots();
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: myChatStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return TostMsg().displayTostMsg(msg: catchError);
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomProgressIndicator();
            }
            if (!snapshot.hasData) {
              Center(
                  child: CustomTxt(
                noAnyChat,
                fSzie: 18,
                color: txtColorBlack,
                fontWeight: FontWeight.bold,
              ));
            }
            final color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0);
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                MyChatsModel myChat = MyChatsModel.fromMap(data);
                checkMyChatsListId.add(myChat);

                return Container(
                  margin: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(mainRadius),
                      border: Border.all()),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChatOneScreen(
                                    receiverId: myChat.receiverId,
                                    receiverName: myChat.receiverName,
                                    chatId: myChat.chatId,
                                  )));
                    },
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: color,
                      child: CustomTxt(
                        myChat.receiverName != null
                            ? myChat.receiverName![0].toUpperCase()
                            : "null",
                        fSzie: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: CustomTxt(
                      myChat.receiverName ?? 'null',
                      color: txtColorBlack,
                      fSzie: 18,
                      fontWeight: FontWeight.bold,
                      txtAlign: TextAlign.start,
                    ),
                    subtitle: Text(myChat.lastMsg ?? 'null'),
                    trailing: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: CustomTxt(
                        _dateFormat(myChat.time!),
                        color: txtColorBlack,
                        fSzie: 12.0,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }

  String _dateFormat(Timestamp timestamp) {
    String date = '';
    final lastTime = timestamp.toDate();
    final currentTime = DateTime.now();
    if (lastTime.day < currentTime.day) {
      date = 'yesterday';
    } else {
      date =
          '${lastTime.day}-${lastTime.month}-${lastTime.year.toString().substring(2)}';
    }
    return date;
  }
}
