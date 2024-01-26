import 'package:flutter/material.dart';
import 'package:messenger_test/components%20/tost_msg.dart';
import 'package:provider/provider.dart';

import '../components /ctm_appbar.dart';
import '../components /ctm_btn.dart';
import '../components /ctm_divider.dart';
import '../components /ctm_progress.dart';
import '../components /ctm_txt.dart';
import '../components /ctm_txtfield.dart';
import '../controllers /user_controller.dart';
import '../utils/constants.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  late TextEditingController _name;
  late TextEditingController _mail;
  late TextEditingController _pass;
  @override
  void initState() {
    _name = TextEditingController();
    _mail = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _mail.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            context: context,
            txtTitle: createNewAccount,
            bgColor: mainColor,
          ),
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
                        child: CustomTxt(desCreateNewAccount,
                            color: txtColorBlack)),
                    Padding(
                        padding: EdgeInsets.all(mainPadding),
                        child: CustomtTextField(
                            controller: _name,
                            label: name,
                            inputType: TextInputType.emailAddress)),
                    Padding(
                        padding: EdgeInsets.all(mainPadding),
                        child: CustomtTextField(
                            controller: _mail,
                            label: mailLable,
                            inputType: TextInputType.emailAddress)),
                    Padding(
                        padding: EdgeInsets.all(mainPadding),
                        child: CustomtTextField(
                            controller: _pass,
                            label: passWordLable,
                            inputType: TextInputType.visiblePassword,
                            isObscureText: true)),
                    Padding(
                        padding: EdgeInsets.all(mainPadding),
                        child: CustomBtn(
                            voidCallback: () {
                              _checkBeforCreate();
                            },
                            txt: createBtn,
                            cColor: mainColor)),
                    Padding(
                      padding: EdgeInsets.all(mainPadding),
                      child: CustomTxt(alreadyHaveAnAccount,
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
                          Navigator.pop(context);
                        },
                        child: CustomTxt(logInBtn,
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

  void _checkBeforCreate() {
    String cName = _name.text;
    String cMail = _mail.text.toLowerCase().trim();
    String cPassWord = _pass.text;
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(cMail);
    if (cName.isEmpty || cName.length < 2) {
      TostMsg().displayTostMsg(msg: errorName);
    } else if (cMail.isEmpty || !emailValid) {
      TostMsg().displayTostMsg(msg: errorMail);
    } else if (cPassWord.isEmpty || cPassWord.length < 8) {
      TostMsg().displayTostMsg(msg: errorPass);
    } else {
      _name.clear();
      _mail.clear();
      _pass.clear();
      FocusScope.of(context).unfocus();
      UserController().createNewAccount(
          name: cName, mail: cMail, password: cPassWord, context: context);
    }
  }
}
