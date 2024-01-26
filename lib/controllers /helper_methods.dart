import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../components /tost_msg.dart';
import '../utils/constants.dart';

class HelperMehtods {

  Future internetChecker({required VoidCallback callback}) async {
    final listener =
        InternetConnectionChecker().onStatusChange.listen((status) async {
      switch (status) {
        case InternetConnectionStatus.connected:
          callback();
          break;
        case InternetConnectionStatus.disconnected:
          TostMsg().displayTostMsg(msg: noNetMsg);
          break;
      }
    });
    await Future.delayed(const Duration(seconds: 30));
    await listener.cancel();
  }
}
