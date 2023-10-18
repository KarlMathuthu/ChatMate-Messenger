import 'package:chat_mate_messanger/views/auth/check_user_state.dart';
import 'package:chat_mate_messanger/views/auth/login_page.dart';
import 'package:chat_mate_messanger/views/home/home_page.dart';
import 'package:chat_mate_messanger/views/intro/letsYouInPage.dart';
import 'package:chat_mate_messanger/views/intro/splashPage.dart';
import 'package:chat_mate_messanger/views/settings/app_settings.dart';
import 'package:get/get.dart';

import '../views/auth/reset_password.dart';
import '../views/auth/signup_page.dart';

class RouteClass {
  static String splashPage = "/splashPage";
  static String letsYouIn = "/letsYouIn";
  static String loginPage = "/loginPage";
  static String createAccountPage = "/createAccountPage";
  static String resetPasswordPage = "/resetPasswordPage";
  static String homePage = "/homePage";
  static String appSettingsPage = "/appSettingsPage";
  static String checkUserState = "/checkUserState";

  static List<GetPage> routes = [
    GetPage(name: splashPage, page: () => const SplashPage()),
    GetPage(name: letsYouIn, page: () => const LetsYouInPage()),
    GetPage(name: loginPage, page: () => LoginPage()),
    GetPage(name: createAccountPage, page: () => CreateAccountPage()),
    GetPage(name: resetPasswordPage, page: () => ResetPasswordPage()),
    GetPage(name: homePage, page: () => HomePage()),
    GetPage(name: appSettingsPage, page: () => AppSettingsPage()),
    GetPage(name: checkUserState, page: () => const CheckUserState()),
  ];
}
