import 'package:flutter/material.dart';
import 'package:messenger_test/routing/routing_name.dart';

import '../controllers /user_controller.dart';
import '../utils/constants.dart';
import 'ctm_txt.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTxt(
                'Hello :)',
                color: txtColorBlack,
              ),
            ),
          ),
          ListTile(
            title: const Text(txtSignOut),
            onTap: () async {
              await UserController().logOut();
              if (!context.mounted) return;
              currentIdUser = null;
              currentName = null;
              Navigator.pushReplacementNamed(context, rLogInScreen);
            },
          ),
        ],
      ),
    );
  }
}
