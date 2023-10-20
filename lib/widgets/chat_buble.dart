import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyChatBubble extends StatelessWidget {
  MyChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.type,
    //required this.isRead,
    //required this.isDelivered,
    //required this.isSent,
  });
  final String message;
  final bool isSender;
  final String type;
  //final bool isRead;
  //final bool isDelivered;
  //final bool isSent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isSender == true
            ? BubbleNormal(
                text: message,
                isSender: isSender,
                //color: Color(0xFF1B97F3),
                color: AppTheme.mainColor,
                tail: true,
                //seen: isRead,
                //sent: isSent,
                textStyle: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )
            : BubbleNormal(
                text: message,
                isSender: isSender,
                color: Color(0xFFE8E8EE),
                textStyle: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black,
                ),
                tail: true,
              ),
      ],
    );
  }

  bool isUrl(String text) {
    Uri uri = Uri.parse(text);

    // Check if the scheme (protocol) of the URL is not empty (indicating it's a valid URL)
    return uri.scheme.isNotEmpty;
  }
}
