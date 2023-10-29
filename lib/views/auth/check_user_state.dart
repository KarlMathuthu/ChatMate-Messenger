import 'package:chat_mate_messanger/views/home/home_page_debug.dart';
import 'package:chat_mate_messanger/views/intro/letsYouInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/home_page.dart';

class CheckUserState extends StatelessWidget {
  const CheckUserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomePageDebug();
        } else {
          return const LetsYouInPage();
        }
      },
    );
  }
}
