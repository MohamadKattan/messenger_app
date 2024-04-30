import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:messenger_test/components%20/ctm_txt.dart';
import 'package:messenger_test/controllers%20/voice_call_controller.dart';
import 'package:provider/provider.dart';

import '../components /ctm_appbar.dart';
import '../components /ctm_drawer.dart';
import '../controllers /my_chats_controller.dart';
import '../controllers /user_controller.dart';
import '../routing/routing_name.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
        UserController().updateUserStatus(false);
        context.read<CallVoiceController>().rest();
        userOnLone = false;
        break;
      case AppLifecycleState.paused:
        UserController().updateUserStatus(false);
        context.read<CallVoiceController>().rest();
        userOnLone = false;

        break;
      case AppLifecycleState.resumed:
        UserController().updateUserStatus(true);
        userOnLone = true;

        break;
      case AppLifecycleState.inactive:
        UserController().updateUserStatus(false);
        context.read<CallVoiceController>().rest();
        userOnLone = false;
        break;
      case AppLifecycleState.hidden:
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    UserController().updateUserStatus(true);
    context.read<CallVoiceController>().notifyNewCall(context);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthQ = MediaQuery.of(context).size.width;
    return Builder(
      builder: (context) {
        return SafeArea(
          child: PopScope(
            canPop: false,
            child: Scaffold(
              appBar: CustomAppBar(
                  context: context,
                  txtTitle: '',
                  bgColor: Colors.white,
                  isHomeScreen: true),
              drawer: const CustomDrawer(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: mainPadding),
                    child: CustomTxt(
                      titleHomeP,
                      fSzie: 34,
                      color: txtColorBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: mainPadding, right: mainPadding),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, rSearchUser),
                      child: Container(
                        width: widthQ,
                        padding: EdgeInsets.all(mainPadding),
                        decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(mainRadius)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.search, size: 34, color: secondryGrey),
                            const SizedBox(
                              width: 8.0,
                            ),
                            CustomTxt(
                              txtSearchUser,
                              color: secondryGrey,
                              fSzie: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const ListAllMyChats()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
