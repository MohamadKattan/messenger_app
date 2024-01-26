import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_test/models/user_model.dart';
import 'package:provider/provider.dart';

import '../components /tost_msg.dart';
import '../routing/routing_name.dart';
import '../utils/constants.dart';

class UserController extends ChangeNotifier {
  bool _isLouding = false;
  bool get isLouding => _isLouding;

  void _louding(bool state) {
    _isLouding = state;
    notifyListeners();
  }

// check status
  checkUserAuth(BuildContext context) async {
    String userId = auth.currentUser?.uid ?? 'null';
    if (userId != 'null') {
      await getCurrentUser();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, rHomePage, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, rLogInScreen, (route) => false);
    }
  }

// get user data
  Future getCurrentUser() async {
    String id = auth.currentUser?.uid ?? 'null';
    if (id != 'null') {
      currentIdUser = id;
      await firestore
          .collection(usersTable)
          .doc(id)
          .get()
          .then((DocumentSnapshot doc) {
        if (doc.exists) {
          Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
          currentName = map[keyUsername];
          userOnLone = map[keyOnLine];
        }
      });
    } else {
      return;
    }
  }

// update if user on/off
  Future updateUserStatus(bool status) async {
    String? id = auth.currentUser?.uid ?? 'null';
    if (id != 'null') {
      firestore
          .collection(usersTable)
          .doc(id)
          .update({keyOnLine: status, keyLastSeen: DateTime.now()});
    } else {
      return;
    }
  }

  // create new account
  Future createNewAccount(
      {required String name,
      required String mail,
      required String password,
      required BuildContext context}) async {
    try {
      context.read<UserController>()._louding(true);
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );
      if (userCredential.user != null) {
        final user = userCredential.user;
        await auth.currentUser!.updateDisplayName(name);
        if (!context.mounted) return;
        await addNewUserToCloud(user, context, name);
      }
    } on FirebaseAuthException catch (e) {
      TostMsg().displayTostMsg(msg: e.code);
      if (!context.mounted) return;
      context.read<UserController>()._louding(false);
      if (e.code == 'weak-password') {
        TostMsg().displayTostMsg(msg: errorWeakPassword);
      } else if (e.code == 'email-already-in-use') {
        TostMsg().displayTostMsg(msg: erroremailInUse);
      }
    } catch (e) {
      if (!context.mounted) return;
      context.read<UserController>()._louding(false);
      TostMsg().displayTostMsg(msg: catchError);
    }
  }

  // add user data to fireCloud after auth
  Future addNewUserToCloud(
      User? user, BuildContext context, String name) async {
    UserModel newUser = UserModel(
        userId: user?.uid,
        userName: name,
        userMail: user?.email,
        userToken: user?.refreshToken);
    await firestore
        .collection(usersTable)
        .doc(user?.uid)
        .set(newUser.toJson())
        .catchError((e) async {
      TostMsg().displayTostMsg(msg: catchError);
      await auth.currentUser?.delete();
    });

    await getCurrentUser();
    if (!context.mounted) return;
    context.read<UserController>()._louding(false);
    TostMsg().displayTostMsg(msg: createSuccess, color: Colors.green);
    Navigator.pushReplacementNamed(context, rHomePage);
  }

// logIn Mehtod
  Future signIn(
      {required String mail,
      required String pass,
      required BuildContext context}) async {
    try {
      context.read<UserController>()._louding(true);
      await auth.signInWithEmailAndPassword(email: mail, password: pass);
      await getCurrentUser();
      if (!context.mounted) return;
      context.read<UserController>()._louding(false);
      TostMsg().displayTostMsg(msg: welcomeBack, color: Colors.green);
      Navigator.pushReplacementNamed(context, rHomePage);
    } on FirebaseAuthException catch (e) {
      TostMsg().displayTostMsg(msg: e.code);
      context.read<UserController>()._louding(false);
      if (e.code == 'user-not-found') {
        TostMsg().displayTostMsg(msg: errorNoUser);
      } else if (e.code == 'wrong-password') {
        TostMsg().displayTostMsg(msg: errorWrongPass);
      }
    } catch (ex) {
      context.read<UserController>()._louding(false);
      TostMsg().displayTostMsg(msg: ex.toString());
    }
  }

// logOut Method
  Future logOut() async {
    await updateUserStatus(false);
    await FirebaseAuth.instance.signOut();
  }
}
