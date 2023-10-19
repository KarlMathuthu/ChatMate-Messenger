import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyChatBubble extends StatelessWidget {
  MyChatBubble({super.key});

  bool isSender = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isSender == true
            ? BubbleNormal(
                text: 'bubble normal with tail',
                isSender: true,
                color: Color(0xFF1B97F3),
                tail: true,
                seen: true,
                textStyle: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )
            : BubbleNormal(
                text: 'bubble normal with tail',
                isSender: false,
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
}
