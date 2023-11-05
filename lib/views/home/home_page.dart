import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/custom_icons.dart';
import 'package:chat_mate_messanger/views/home/channels.dart';
import 'package:chat_mate_messanger/views/home/chats_page.dart';
import 'package:chat_mate_messanger/views/home/calls_page.dart';
import 'package:chat_mate_messanger/views/settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  AuthController authController = Get.put(AuthController());

  double iconSize = 22;
  int currentIndex = 0;

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> pages = [
    const ChatsPage(),
    const CallsPage(),
    const ChannelsPage(),
    AppSettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    // Check the app's lifecycle state and update user status accordingly
    if (state == AppLifecycleState.paused) {
      await authController.updateUserStatus("${DateTime.now()}");
    } else if (state == AppLifecycleState.resumed) {
      await authController.updateUserStatus("online");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble, size: iconSize),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.phone, size: iconSize),
            label: "Calls",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2, size: iconSize),
            label: "Channels",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear, size: iconSize),
            label: "Settings",
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          changePage(index);
        },
        activeColor: AppTheme.mainColor,
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(builder: (context) {
          return pages[index];
        });
      },
    );
  }
}
