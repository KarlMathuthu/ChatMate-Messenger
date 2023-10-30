import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8.0),
          SvgPicture.asset(
            "assets/icons/chat.svg",
            color: Colors.black,
          ),
          const SizedBox(width: 8.0),
          Text(
            "Chats",
            style: GoogleFonts.lato(fontSize: 15),
          ),
          const Expanded(child: Row()),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
