import 'package:flutter/material.dart';
import 'package:messenger_test/controllers%20/user_controller.dart';
import 'package:messenger_test/utils/constants.dart';

import '../components /ctm_txt.dart';
import '../controllers /helper_methods.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _checkandNav();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainColor,
        body: Center(
            child: CustomTxt(appName,
                color: txtColorBlack, fSzie: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // check net work conection and user if logIn our not
  Future<void> _checkandNav() async {
    await HelperMehtods().internetChecker(callback: () async {
      // await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;
      await UserController().checkUserAuth(context);
    });
  }
}
