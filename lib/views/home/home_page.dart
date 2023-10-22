import 'package:chat_mate_messanger/controllers/auth_controller.dart';
import 'package:chat_mate_messanger/controllers/signaling_controller.dart';
import 'package:chat_mate_messanger/routes/route_class.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/views/home/calls_page.dart';
import 'package:chat_mate_messanger/views/home/chats_page.dart';
import 'package:chat_mate_messanger/views/home/statuses_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  AuthController authController = Get.put(AuthController());
  Signaling signaling = Signaling();
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBacgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.scaffoldBacgroundColor,
          actions: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/search.svg",
                color: Colors.black,
                height: 20,
              ),
            ),
            PopupMenuButton<String>(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              icon: SvgPicture.asset(
                "assets/icons/cog.svg",
                color: Colors.black,
                height: 20,
              ),
              onSelected: (String choice) {
                switch (choice) {
                  case 'goLive':
                    // Handle Go Live action
                    break;
                  case 'newBroadcast':
                    // Handle New Broadcast action
                    break;
                  case 'newGroupChat':
                    // Handle New Group Chat action
                    break;
                  case 'starredMessages':
                    // Handle Starred Messages action
                    break;
                  case 'settings':
                    // Handle Settings action
                    Get.toNamed(RouteClass.appSettingsPage);
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'goLive',
                    child: Text('Go Live'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'newBroadcast',
                    child: Text('New Broadcast'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'newGroupChat',
                    child: Text('New Group Chat'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'starredMessages',
                    child: Text('Starred Messages'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                ];
              },
            ),
          ],
          title: Text(
            "ChatMate",
            style: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: const [
              //Chats
              Tab(
                text: "Chats",
              ),
              //Status
              Tab(
                text: "Status",
              ),
              //Calls
              Tab(
                text: "Calls",
              ),
            ],
            unselectedLabelStyle: GoogleFonts.lato(),
            labelColor: AppTheme.mainColor,
            indicatorColor: AppTheme.mainColor,
            unselectedLabelColor: AppTheme.mainColorLight,
            labelStyle: GoogleFonts.lato(),
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: AppTheme.mainColor, width: 3.0),
            ),
          ),
        ),
        body: const Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  //Chats
                  ChatsPage(),
                  //Status
                  StatusesPage(),
                  //Calls.
                  CallsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
