import 'package:flutter/material.dart';

class CustomTxt extends Text {
  final Color? color;
  final double? fSzie;
  final FontWeight? fontWeight;
  final TextAlign? txtAlign;
  CustomTxt(super.data,
      {super.key, this.color, this.fSzie, this.fontWeight, this.txtAlign})
      : super(
            textAlign: txtAlign ?? TextAlign.center,
            style: TextStyle(
                color: color ?? Colors.white,
                fontSize: fSzie ?? 16.0,
                fontWeight: fontWeight ?? FontWeight.normal));
}
