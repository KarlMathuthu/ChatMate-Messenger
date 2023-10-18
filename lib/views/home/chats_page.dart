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
          : Stack(
              children: [
                /* Center(
                  child: Image.asset(
                    "assets/images/splash.png",
                    height: 200,
                    width: 200,
                  ),
                ), */
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.lato(
                          color: AppTheme.mainColor,
                          fontSize: 16,
                        ),
                        children: const [
                          TextSpan(
                            text: "Hey welcome to ChatMate\n",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: "Start chatting now!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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
