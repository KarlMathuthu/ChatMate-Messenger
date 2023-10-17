import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/views/home/calls_page.dart';
import 'package:chat_mate_messanger/views/home/chats_page.dart';
import 'package:chat_mate_messanger/views/home/statuses_page.dart';
import 'package:flutter/material.dart';
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
          backgroundColor: AppTheme.mainColor,
          actions: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/search.svg",
                color: Colors.white,
                height: 20,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/cog.svg",
                color: Colors.white,
                height: 20,
              ),
            ),
          ],
          title: Text(
            "ChatMate",
            style: GoogleFonts.lato(
              color: Colors.white,
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
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: GoogleFonts.lato(),
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.white, width: 3.0),
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
