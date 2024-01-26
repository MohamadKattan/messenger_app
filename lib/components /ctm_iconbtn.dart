import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomIconBtn extends StatelessWidget {
  final Color? btnColor;
  final double? btnSize;
  final IconData iconData;
  final VoidCallback onClick;
  const CustomIconBtn(
      {super.key,
      this.btnColor,
      this.btnSize,
      required this.iconData,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => onClick(),
        icon: Icon(
          iconData,
          size: btnSize ?? 16.0,
          color: btnColor ?? secondryGrey,
        ));
  }
}
