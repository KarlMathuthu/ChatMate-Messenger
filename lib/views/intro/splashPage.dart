import 'package:chat_mate_messanger/routes/route_class.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 5));
    Get.offAllNamed(RouteClass.letsYouIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBacgroundColor,
      ),
      body: splashScreenLayout(),
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
