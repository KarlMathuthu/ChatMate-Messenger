import 'package:chat_mate_messanger/routes/route_class.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/views/home/calls_page.dart';
import 'package:chat_mate_messanger/views/home/chats_page.dart';
import 'package:chat_mate_messanger/views/home/statuses_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext ___) {
                    return CupertinoActionSheet(
                      title: Text(
                        "Options Menu",
                        style: GoogleFonts.lato(),
                      ),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: Text(
                            "Go Live",
                            style: GoogleFonts.lato(),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text(
                            "New Broadcast",
                            style: GoogleFonts.lato(),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text(
                            "New Group Chat",
                            style: GoogleFonts.lato(),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text(
                            "Starred Messages",
                            style: GoogleFonts.lato(),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text(
                            "Settings",
                            style: GoogleFonts.lato(),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Get.toNamed(RouteClass.appSettingsPage);
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.lato(),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    );
                  },
                );
              },
              icon: SvgPicture.asset(
                "assets/icons/cog.svg",
                color: Colors.black,
                height: 20,
              ),
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
