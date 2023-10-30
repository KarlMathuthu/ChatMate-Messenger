import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/custom_icons.dart';
import 'package:chat_mate_messanger/views/home/channels.dart';
import 'package:chat_mate_messanger/views/home/chats_page.dart';
import 'package:chat_mate_messanger/views/home/calls_page.dart';
import 'package:chat_mate_messanger/views/settings/app_settings.dart';
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
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: GoogleFonts.lato(),
        unselectedLabelStyle: GoogleFonts.lato(),
        selectedItemColor: AppTheme.mainColor,
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        onTap: (index) {
          changePage(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
             CustomIcons.chat,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                currentIndex == 0 ? AppTheme.mainColor : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: "Chats",
          ),
          //Satuses chaning to Calls
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              CustomIcons.call,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                currentIndex == 1 ? AppTheme.mainColor : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: "Calls",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
             CustomIcons.channels,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                currentIndex == 2 ? AppTheme.mainColor : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: "Channels",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
             CustomIcons.cog,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                currentIndex == 3 ? AppTheme.mainColor : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
