import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List chatsDummy = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      body: chatsDummy.isNotEmpty
          ? const SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [],
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    "assets/images/splash.png",
                    height: 200,
                    width: 200,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Welcome 👋",
                  style: GoogleFonts.lato(
                    color: AppTheme.mainColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "ChatMate connects you with your family and friends.\n Start chatting now!",
                    style: GoogleFonts.lato(
                      color: AppTheme.mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
      floatingActionButtonLocation: chatsDummy.isEmpty
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endDocked,
      floatingActionButton: chatsDummy.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: CupertinoButton(
                  borderRadius: BorderRadius.circular(15),
                  color: AppTheme.mainColor,
                  child: Text(
                    "Start new chat",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            )
          : FloatingActionButton(
              onPressed: () {},
            ),
    );
  }
}
