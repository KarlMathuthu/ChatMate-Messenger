import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../views/home/home_page.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin localNotification =
    FlutterLocalNotificationsPlugin();

class NotificationsController {
//Initialize notification
  static Future initNotification() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }

  //Initialize local notifications
  static Future localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    localNotification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    Get.offAll(() => const HomePage());
  }

  // show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'ChatMateAndroidChannelId',
      'ChatMate',
      channelDescription: 'ChatMate - Messenger',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      enableVibration: true,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await localNotification.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  //Send Notification message
  static Future sendMessageNotification({
    required String userToken,
    required String body,
    required String title,
  }) async {
    String fcmApiKey =
        "AAAAb6D5kFw:APA91bHKKOXE0h6N9_ZoWl7CcJRXEe1IdB_9V3Dtzs_BSp-VtuT08SED0y_W8R0xiRLDYlDlBNWULV1btP8Q0EDCXIdYcYFHnidxu5cCKjoUWp38OmB8o8gkWmGXYzx1RzTURTbOou2-";
    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmApiKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'notification': <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "ChatMateAndroidChannelId",
            },
            "to": userToken,
          },
        ),
      );
    } catch (e) {
      throw "Error $e";
    }
  }
}
