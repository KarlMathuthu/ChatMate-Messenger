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

  // Convert List<Map<String, dynamic>> to JSON string
  String convertToJson(List<Map<String, dynamic>> data) {
    return json.encode(data);
  }

// Convert JSON string to List<Map<String, dynamic>>
  List<Map<String, dynamic>> convertFromJson(String jsonString) {
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

// Storing the data in shared preferences
  void saveChatsData(List<Map<String, dynamic>> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = convertToJson(data);
    await prefs.setString('chats', jsonData);
  }

// Retrieving the data from shared preferences
  Future<List<Map<String, dynamic>>> retrieveChatsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('chats');
    if (jsonData != null) {
      return convertFromJson(jsonData);
    }
    return [];
  }
}
