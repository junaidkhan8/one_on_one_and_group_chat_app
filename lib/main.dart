import 'package:chat_screen_for/authentication.dart';
import 'package:chat_screen_for/chatroom.dart';
import 'package:chat_screen_for/login_account_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCTrZlFbbifqIsdx-Q1Rh4LMDJP9W0sfW0",
        appId: "",
        messagingSenderId: "",
        projectId: "one2onechat-6151f"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authentication(),
    );
  }
}
