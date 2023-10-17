import 'package:chat_mate_messanger/views/auth/login_page.dart';
import 'package:chat_mate_messanger/views/intro/letsYouInPage.dart';
import 'package:chat_mate_messanger/views/intro/splashPage.dart';
import 'package:get/get.dart';

import '../views/auth/signup_page.dart';

class RouteClass {
  static String splashPage = "/splashPage";
  static String letsYouIn = "/letsYouIn";
  static String loginPage = "/loginPage";
  static String createAccountPage =
      "/createAccountPage"; // New route for Create Account

  static List<GetPage> routes = [
    GetPage(name: splashPage, page: () => const SplashPage()),
    GetPage(name: letsYouIn, page: () => const LetsYouInPage()),
    GetPage(name: loginPage, page: () => LoginPage()),
    GetPage(name: createAccountPage, page: () => CreateAccountPage()),
  ];
}
