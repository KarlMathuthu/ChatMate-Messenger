import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePageDebug extends StatefulWidget {
  const HomePageDebug({super.key});

  @override
  State<HomePageDebug> createState() => _HomePageDebugState();
}

class _HomePageDebugState extends State<HomePageDebug> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/chat.svg",
            ),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/status.svg",
            ),
            label: "Status",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/channels.svg",
            ),
            label: "Channels",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/profile.svg",
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
