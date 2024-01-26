import 'package:flutter/material.dart';
import 'package:messenger_test/components%20/ctm_btn.dart';
import 'package:messenger_test/components%20/ctm_divider.dart';
import 'package:provider/provider.dart';

import '../components /ctm_appbar.dart';
import '../components /ctm_progress.dart';
import '../components /ctm_txt.dart';
import '../components /ctm_txtfield.dart';
import '../components /tost_msg.dart';
import '../controllers /user_controller.dart';
import '../routing/routing_name.dart';
import '../utils/constants.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late TextEditingController _mail;
  late TextEditingController _passWord;
  @override
  void initState() {
    _mail = TextEditingController();
    _passWord = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _mail.dispose();
    _passWord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
              context: context,
              txtTitle: titleLogInP,
              bgColor: mainColor,
              isHomeScreen: true),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    Padding(
                        padding: EdgeInsets.all(mainPadding),
                        child: CustomTxt(desLogIn, color: txtColorBlack)),
                    Padding(
                        padding: EdgeInsets.all(mainPadding),
                        child: CustomtTextField(
                            controller: _mail,
                            label: mailLable,
                            inputType: TextInputType.emailAddress)),
                    Padding(
                        padding: EdgeInsets.all(mainPadding),
                        child: CustomtTextField(
                            controller: _passWord,
                            label: passWordLable,
                            inputType: TextInputType.visiblePassword,
                            isObscureText: true)),
                    Padding(
                        padding: EdgeInsets.all(mainPadding),
                        child: CustomBtn(
                            voidCallback: () => _checkBefor(),
                            txt: logInBtn,
                            cColor: mainColor)),
                    Padding(
                      padding: EdgeInsets.all(mainPadding),
                      child: CustomTxt(noAccount,
                          color: txtColorBlack,
                          fSzie: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    CustomDivider(bgColor: mainColor),
                    Padding(
                      padding: EdgeInsets.all(mainPadding),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pushNamed(context, rCreateAccount);
                        },
                        child: CustomTxt(createNewAccount,
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              context.watch<UserController>().isLouding
                  ? Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const CustomProgressIndicator())
                  : const SizedBox(),
            ],
          ),
        ),
      );
    });
  }

  _checkBefor() {
    String cMail = _mail.text.toLowerCase().trim();
    String cPassWord = _passWord.text;
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(cMail);
    if (cMail.isEmpty || !emailValid) {
      TostMsg().displayTostMsg(msg: errorMail);
    } else if (cPassWord.isEmpty) {
      TostMsg().displayTostMsg(msg: errorPass);
    } else {
      // _mail.clear();
      // _passWord.clear();
      FocusScope.of(context).unfocus();
      UserController().signIn(mail: cMail, pass: cPassWord, context: context);
    }
  }
}
