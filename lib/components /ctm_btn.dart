import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'ctm_txt.dart';

class CustomBtn extends StatelessWidget {
  final VoidCallback voidCallback;
  final String? txt;
  final Color? cColor;
  const CustomBtn(
      {super.key, required this.voidCallback, this.txt, this.cColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => voidCallback(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(mainPadding),
        decoration: BoxDecoration(
            color: cColor ?? btnColor,
            borderRadius: BorderRadius.circular(mainRadius)),
        child: CustomTxt(
          txt ?? '',
          color: txtColorBlack,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
