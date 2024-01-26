import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/my_chats_model.dart';

//app colors
Color mainColor = const Color.fromARGB(255, 147, 238, 248);
Color txtColorBlack = Colors.black;
Color txtColorWhite = Colors.white;
Color secondryGrey = const Color.fromARGB(255, 172, 182, 190);
Color btnColor = Colors.amberAccent;
Color grey = const Color(0xffEDF2F6);
Color green = const Color(0xff3CED78);


// numeric val
double mainSpacer = 20.0;
int tabeslNumber = 4; // as dynamic Number Table from dataBase
double mainPadding = 12.0;
double mainMargin = 12.0;
double mainRadius = 8.0;
// some value
List<MyChatsModel> checkMyChatsListId = [];
String? currentName;
String? currentIdUser;
bool? userOnLone;

// all txt in app =>  No loclaztion
const String appName = 'Messenger\nTest';
const String titleLogInP = 'Авторизоваться';
const String desLogIn =
    'Введите адрес электронной почты и пароль для входа в свою учетную запись';
const String mailLable = 'Введите свою почту';
const String passWordLable = 'Введите ваш пароль';
const String logInBtn = 'Войти';
const String noAccount = 'У вас нет учетной записи';
const String createNewAccount = 'Создать новый аккаунт';
const String desCreateNewAccount =
    'введите свои данные, затем \nНажмите кнопку ниже, чтобы создать новую учетную запись';
const String name = 'Введите ваше имя';
const createBtn = 'Создавать';
const alreadyHaveAnAccount = 'У вас уже есть аккаунт!?';
const String titleHomeP = 'Чаты';
const String txtSearchUser = 'Поиск';
const String noAnyChat =
    'У вас еще нет чата.\n Нажмите значок поиска и найдите имя, с которым хотите пообщаться.';
const String yesterday = 'Вчера';
const String txtSignOut = 'Выход';
const String writeNameSearch =
    'Напишите адрес электронной почты пользователя\с которым вы хотите пообщаться';
const String typeName = 'Введите электронную почту';
const String usrOnline = 'В сети';
const String usrLastSeen = 'визит';
const String msgChat = 'Сообщение';

// NOTE : ALL SENSITIVE CONFIG USUALLY IN PRODUCTION APP SHOULD BE STORED IN .env FILE

// ========ref instance of db=========
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

//======== table  name on db==========
const String usersTable = 'users';
const String subMyChatTable = 'my_chat';
const String messagesTable = 'messages';

//============key on db ==============
const String keyUserId = 'user_id';
const String keyUsername = 'user_name';
const String keyUserMail = 'userMail';
const String keyOnLine = 'on_line';
const String keyLastSeen = 'last_seen';
const String keyUserToken = 'user_token';
const String keyChatId = 'chat_id';
const String keyReceiverId = 'receiver_id';
const String keyReceiverName = 'receiver_name';
const String keyLastMsg = 'last_msg';
const String keyTime = 'time';
const String keyOwnerMsg = 'owner_msg';
const String keyMsg = 'msg';
const String keyTimeMsg = 'time_msg';
const String keyReaded = 'readed_msg';

// error msg
const String noNetMsg = 'Вы отключены от Интернета.';
const String errorName = 'ошибка, проверьте свое имя';
const String errorMail = 'ошибка, проверьте свою электронную почту';
const String errorPass = 'ошибка, проверьте свой пароль';
const String errorWeakPassword = 'Предоставленный пароль слишком слабый.';
const String erroremailInUse = 'Учетная запись для этого адреса электронной почты уже существует.';
const String catchError = 'Что-то пошло не так, попробуйте еще раз';
const String errorNoUser = 'No user found for that email.';
const String errorWrongPass = 'Wrong password provided for that user.';

// success msg
const createSuccess = 'Создать новую учетную запись успешно';
const welcomeBack = 'Привет, с возвращением ;)';
