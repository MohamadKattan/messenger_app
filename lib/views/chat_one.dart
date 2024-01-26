import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:messenger_test/components%20/ctm_iconbtn.dart';
import 'package:messenger_test/components%20/ctm_progress.dart';
import 'package:messenger_test/components%20/ctm_txt.dart';
import 'package:messenger_test/components%20/tost_msg.dart';
import 'package:messenger_test/models/one_chat_model.dart';
import 'package:messenger_test/utils/constants.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';

import '../controllers /one_chat_controller.dart';

class ChatOneScreen extends StatefulWidget {
  final String? receiverId;
  final String? receiverName;
  final String? chatId;
  
  const ChatOneScreen(
      {super.key,
      required this.receiverId,
      required this.receiverName,

      required this.chatId});

  @override
  State<ChatOneScreen> createState() => _ChatOneScreenState();
}

class _ChatOneScreenState extends State<ChatOneScreen> {
  late TextEditingController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _controller = TextEditingController();
    OneChatController().updateReadMsg(widget.chatId ?? 'null');
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appBar(context),
              _listChat(),
              _chatTxtPanel(),
              _emojy()
            ],
          ),
        ),
      );
    });
  }

  _appBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mainMargin, bottom: mainMargin),
      padding: EdgeInsets.all(mainPadding),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: secondryGrey, width: 1.0))),
      child: Row(
        children: [
          CustomIconBtn(
            iconData: Icons.arrow_back_ios,
            onClick: () => Navigator.pop(context),
            btnSize: 24,
            btnColor: txtColorBlack,
          ),
          CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: CustomTxt(widget.receiverName![0].toUpperCase())),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTxt(
                  widget.receiverName ?? 'null',
                  color: txtColorBlack,
                  fSzie: 18,
                  fontWeight: FontWeight.bold,
                ),
                OneChatController()
                    .listeningToReceiverStatus(id: widget.receiverId ?? 'null')
              ],
            ),
          ),
        ],
      ),
    );
  }

  _chatTxtPanel() {
    return Container(
      // height: MediaQuery.of(context).size.height * 12 / 100,
      padding: EdgeInsets.all(mainPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(mainMargin),
            decoration: BoxDecoration(
                color: grey, borderRadius: BorderRadius.circular(20)),
            child: Transform.rotate(
              angle: 40 * pi / 180.0,
              child: CustomIconBtn(
                iconData: Icons.attach_file,
                onClick: () {
                  _toggel();
                },
                btnSize: 30,
                btnColor: txtColorBlack,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: grey, borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    labelText: msgChat,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(mainPadding)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(mainMargin),
            decoration: BoxDecoration(
                color: grey, borderRadius: BorderRadius.circular(20)),
            child: Transform.rotate(
              angle: -40 * pi / 180.0,
              child: CustomIconBtn(
                iconData: Icons.send,
                onClick: () {
                  if (_controller.text.isNotEmpty) {
                    OneChatController().addNewMsgToOneChat(
                      newMsg: _controller.text,
                      chatIdR: widget.chatId ?? 'null',
                      receiverIdR: widget.receiverId ?? 'null',
                      reciverNameR: widget.receiverName ?? 'null',
                    );
                    _controller.clear();
                  }

                  bool val =
                      Provider.of<OneChatController>(context, listen: false)
                          .emojiShowing;
                  if (val) {
                    _toggel();
                  }
                },
                btnSize: 30,
                btnColor: txtColorBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _emojy() {
    return Offstage(
      offstage: !context.watch<OneChatController>().emojiShowing,
      child: SizedBox(
          height: 250,
          child: EmojiPicker(
            textEditingController: _controller,
            onBackspacePressed: _onBackspacePressed,
            config: Config(
              columns: 7,
              emojiSizeMax: 32 *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.30
                      : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              initCategory: Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              backspaceColor: Colors.blue,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              recentTabBehavior: RecentTabBehavior.RECENT,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: false,
              noRecents: const Text(
                'No Recents',
                style: TextStyle(fontSize: 20, color: Colors.black26),
                textAlign: TextAlign.center,
              ),
              loadingIndicator: const SizedBox.shrink(),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
              checkPlatformCompatibility: true,
            ),
          )),
    );
  }

  void _toggel() {
    bool val =
        Provider.of<OneChatController>(context, listen: false).emojiShowing;
    if (val) {
      context.read<OneChatController>().toggelEmoji(false);
    } else {
      context.read<OneChatController>().toggelEmoji(true);
    }
  }

  _listChat() {
    final Stream<QuerySnapshot> chatStream = firestore
        .collection(messagesTable)
        .doc(widget.chatId)
        .collection('chat')
        .orderBy(keyTimeMsg, descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: chatStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: TostMsg().displayTostMsg(msg: catchError));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data yet'),
            );
          }

          return Expanded(
            child: ListView(
              controller: _scrollController,
              shrinkWrap: true,
              reverse: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                OneChatModel oneChatModel = OneChatModel.fromMap(data);

                return _cardMsg(oneChatModel);
              }).toList(),
            ),
          );
        });
  }

  Widget _cardMsg(OneChatModel oneChatModel) {
    return Row(
      mainAxisAlignment: oneChatModel.ownerMsg == currentIdUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(mainMargin),
          decoration: BoxDecoration(
              color: oneChatModel.ownerMsg == currentIdUser ? green : grey,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0),
                  bottomLeft: Radius.circular(
                      oneChatModel.ownerMsg == currentIdUser ? 16 : 0),
                  bottomRight: Radius.circular(
                      oneChatModel.ownerMsg == currentIdUser ? 0 : 16.0))),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: 16,
                    right: oneChatModel.ownerMsg == currentIdUser ? 24.0 : 8.0,
                    left: oneChatModel.ownerMsg == currentIdUser ? 8.0 : 24.0),
                child: CustomTxt(
                  oneChatModel.msg ?? 'null',
                  fSzie: 18,
                  color: txtColorBlack,
                ),
              ),
              oneChatModel.ownerMsg == currentIdUser
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 8.0),
                          child: Icon(
                              oneChatModel.readed == false
                                  ? Icons.done
                                  : Icons.done_all,
                              size: 16)))
                  : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}
