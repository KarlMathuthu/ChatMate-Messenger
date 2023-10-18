import 'dart:io';

import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.only(top: 0.8),
        decoration: const BoxDecoration(
          color: AppTheme.scaffoldBacgroundColor,
        ),
        child: Column(
          children: [
            //My account
            ListTile(
              onTap: () {},
              title: Text(
                "@KarlKiyotaka",
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "always available 🔥",
                style: GoogleFonts.lato(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              leading: const CircleAvatar(),
              trailing: SvgPicture.asset(
                "assets/icons/cog.svg",
                color: Colors.black,
              ),
            ),
            //Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: SvgPicture.asset(
                "assets/icons/chat.svg",
                color: Colors.black,
              ),
              title: Text(
                "Chats",
                style: GoogleFonts.lato(),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: SvgPicture.asset(
                "assets/icons/noti.svg",
                color: Colors.black,
              ),
              title: Text(
                "Notifications",
                style: GoogleFonts.lato(),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: SvgPicture.asset(
                "assets/icons/file.svg",
                color: Colors.black,
              ),
              title: Text(
                "Storage & Data",
                style: GoogleFonts.lato(),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
