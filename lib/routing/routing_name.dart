import 'package:flutter/widgets.dart';
import 'package:messenger_test/views/call_screen.dart';
import 'package:messenger_test/views/create_account.dart';
import 'package:messenger_test/views/home_page.dart';
import 'package:messenger_test/views/login_screen.dart';
import '../views/search_user.dart';
import '../views/splash_screen.dart';

const String rInitial = '/';
const String rHomePage = '/homePage';
const String rLogInScreen = '/logIn';
const String rCreateAccount = '/create';
const String rSearchUser = '/search';
const String rchatWithone = '/chatOne';
const String rCallScreen = "/callScreen";

class AllRoute {
  static Map<String, Widget Function(BuildContext)> routeMap = {
    rInitial: (context) => const SplashScreen(),
    rHomePage: (context) => const HomePage(),
    rLogInScreen: (context) => const LogInScreen(),
    rCreateAccount: (context) => const CreateAccountScreen(),
    rSearchUser: (context) => const SearchUsersScreen(),
    // rchatWithone: (context) => const ChatOneScreen(receiverId: '',)
     rCallScreen: (context) => const CallScreen()
  };
}
