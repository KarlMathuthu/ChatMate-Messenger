import 'package:chat_mate_messanger/views/home/home_page.dart';
import 'package:chat_mate_messanger/views/intro/letsYouInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckUserState extends StatelessWidget {
  const CheckUserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const LetsYouInPage();
        }
      },
    );
  }
}
