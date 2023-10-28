import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController extends GetxController {
  //Save profile picture svg code
  Future<void> saveSvgCodeProfilePicture({required String photoUrl}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setString("photoUrl", photoUrl);
  }

}
