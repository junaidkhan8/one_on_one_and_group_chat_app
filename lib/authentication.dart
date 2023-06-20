import 'package:chat_screen_for/home_screen.dart';
import 'package:chat_screen_for/login_account_page.dart';
import 'package:chat_screen_for/page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

class Authentication extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}