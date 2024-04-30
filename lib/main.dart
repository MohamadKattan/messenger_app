import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers /one_chat_controller.dart';
import 'controllers /search_users.dart';
import 'controllers /user_controller.dart';
import 'controllers /voice_call_controller.dart';
import 'firebase_options.dart';
import 'routing/routing_name.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => SearchUsersController()),
        ChangeNotifierProvider(create: (_) => OneChatController()),
        ChangeNotifierProvider(create: (_) => CallVoiceController())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Messenger kattan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: rInitial,
        routes: AllRoute.routeMap);
  }
}


// gem update --system
// sudo gem install cocoapods --user-install

//sudo gem install cocoapods
//pod cache clean --all
// rm -rf Pods
// rm Podfile.lock
// pod update or pod install



