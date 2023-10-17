import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/views/intro/letsYouInPage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBacgroundColor,
      ),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 5)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const LetsYouInPage();
          } else {
            return splashScreenLayout();
          }
        },
      ),
    );
  }

  Widget splashScreenLayout() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.scaffoldBacgroundColor,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Center(
              child: Image.asset(
                "assets/images/splash.png",
                height: 150,
                width: 150,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: LoadingAnimationWidget.fourRotatingDots(
                color: AppTheme.loaderColor,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
