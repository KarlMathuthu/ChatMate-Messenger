import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          : const Stack(
              children: [
                /* Center(
                  child: Image.asset(
                    "assets/images/splash.png",
                    height: 200,
                    width: 200,
                  ),
                ), */
               /*  Padding(
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
                            text: "Hey welcome to ChatMate\n\n",
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
                ) */
              ],
            ),
      floatingActionButton: chatsDummy.isEmpty
          ? FloatingActionButton(
              backgroundColor: AppTheme.mainColor,
              onPressed: () {},
              child: SvgPicture.asset(
                "assets/icons/chat.svg",
                color: Colors.white,
              ),
            )
          : FloatingActionButton(
              onPressed: () {},
            ),
    );
  }
}
