import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChannelChatBubble extends StatelessWidget {
  const ChannelChatBubble({
    super.key,
    required this.message,
    required this.isAdmin,
    required this.type,
  });
  final String message;
  final bool isAdmin;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        type == "text" && isAdmin == true
            ? BubbleNormal(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                text: message,
                isSender: isAdmin,
                color: AppTheme.mainColor,
                tail: false,
                textStyle: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )
            : BubbleNormal(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                text: message,
                isSender: isAdmin,
                color: const Color(0xFFE8E8EE),
                textStyle: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black,
                ),
                tail: false,
              ),
      ],
    );
  }
}
