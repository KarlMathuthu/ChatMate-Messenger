import 'package:chat_mate_messanger/routes/route_class.dart';
import 'package:chat_mate_messanger/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: RouteClass.routes,
      initialRoute: RouteClass.letsYouIn,
      title: AppConstants.appName,
      theme: ThemeData(useMaterial3: true),
    );
  }
}
