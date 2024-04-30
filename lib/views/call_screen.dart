import 'package:flutter/material.dart';
import 'package:messenger_test/components%20/ctm_iconbtn.dart';
import 'package:messenger_test/controllers%20/voice_call_controller.dart';
import 'package:messenger_test/routing/routing_name.dart';
import 'package:messenger_test/utils/constants.dart';
import 'package:provider/provider.dart';

import '../components /ctm_txt.dart';

class CallScreen extends StatefulWidget {
  final String? receiverName;
  const CallScreen({super.key, this.receiverName});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CallVoiceController>().openTheRecorder();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayName =
        context.watch<CallVoiceController>().displayName(widget.receiverName);
    bool isMuted = context.watch<CallVoiceController>().muted;
    bool isAccpted = context.watch<CallVoiceController>().isAccpted;
    bool isSpeaker = context.watch<CallVoiceController>().speaker;
    String statusOfCall =
        context.watch<CallVoiceController>().callStatusOfReciver ?? "On call";
    String? timeOfCall =
        context.watch<CallVoiceController>().resutlTimeOfCall ?? "null";
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: backgroundColor,
          // appBar: CustomAppBar(
          //   context: context,
          //   txtTitle: "call screen",
          // ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue,
                        child: CustomTxt(displayName[0].toUpperCase(),
                            fSzie: 24, fontWeight: FontWeight.bold)),
                  ),
                  CustomTxt(displayName, fontWeight: FontWeight.bold),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTxt(statusOfCall, fSzie: 28),
                  ),
                  if (timeOfCall != "null") CustomTxt(timeOfCall, fSzie: 14),
                  SizedBox(height: height / 2 - 50),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomIconBtn(
                          onClick: () {
                            context
                                .read<CallVoiceController>()
                                .listingToSpeaker();
                          },
                          iconData:
                              isSpeaker ? Icons.volume_up : Icons.volume_mute,
                          btnColor: isSpeaker ? Colors.green : secondryGrey,
                          btnSize: 45),
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: isAccpted
                            ? Colors.green
                            : Colors.redAccent.shade700,
                        child: CustomIconBtn(
                            onClick: () async {
                              _endOrAccept(context, isAccpted);
                            },
                            iconData: isAccpted
                                ? Icons.call
                                : Icons.call_end_outlined,
                            btnSize: 40),
                      ),
                      CustomIconBtn(
                        onClick: () {
                          context
                              .read<CallVoiceController>()
                              .listingToMutedMic();
                        },
                        iconData: isMuted ? Icons.mic_off_sharp : Icons.mic,
                        btnSize: 45,
                        btnColor: isMuted ? Colors.red : secondryGrey,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _endOrAccept(BuildContext context, bool isAccpted) async {
    if (isAccpted) {
      await context.read<CallVoiceController>().listingToAcceptCall();
    } else {
      await context.read<CallVoiceController>().listingToEndingCall();
      if (!context.mounted) return;
      // Navigator.pushReplacementNamed(context, rHomePage);
      Navigator.pushNamedAndRemoveUntil(context, rHomePage, (route) => false);
    }
  }
}
