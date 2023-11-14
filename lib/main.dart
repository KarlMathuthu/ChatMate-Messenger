import 'dart:convert';

import 'package:chat_mate_messanger/routes/route_class.dart';
import 'package:chat_mate_messanger/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'controllers/notifications_controller.dart';
import 'firebase_options.dart';

//Listen to background Notifications
Future _firebaseBackgroundNotification(RemoteMessage message) async {
  if (message.notification != null) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Initialize Notifications 
  await NotificationsController.initNotification();
  await NotificationsController.localNotiInit();
  //Initialize background notifcations.
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundNotification);

  //Handle foreground notifications
  
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      String notificationPayLoad = jsonEncode(message.data);

      if (message.notification != null) {
        NotificationsController.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: notificationPayLoad,
        );
      }
    },
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: RouteClass.routes,
      initialRoute: RouteClass.splashPage,
      title: AppConstants.appName,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
