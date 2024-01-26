import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'ctm_txt.dart';

class CustomDivider extends Container {
  final double? cWidth;
  final double? cHeight;
  final String? title;
  final double? cPadding;
  final double? cMargin;
  final Color? bgColor;
  CustomDivider(
      {super.key,
      this.cWidth,
      this.title,
      this.cPadding,
      this.cMargin,
      this.bgColor,
      this.cHeight})
      : super(
            width: cWidth ?? 120.0,
            height: cHeight ?? 2.0,
            padding: EdgeInsets.all(cPadding ?? 12.0),
            margin: EdgeInsets.all(cMargin ?? 0.0),
            decoration: BoxDecoration(color: bgColor ?? secondryGrey),
            child: CustomTxt(title ?? ''));
}
