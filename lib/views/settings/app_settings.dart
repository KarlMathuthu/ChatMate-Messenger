import 'dart:io';

import 'package:chat_mate_messanger/controllers/auth_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSettingsPage extends StatelessWidget {
  AppSettingsPage({super.key});

  AuthController authController = Get.put(AuthController());
  CustomLoader customLoader = CustomLoader();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

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
            StreamBuilder(
                stream: firestore
                    .collection("users")
                    .doc(currentUserUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("data");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      onTap: () {},
                      title: Text(
                        "@username",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "loading...",
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppTheme.mainColor,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: const BoxDecoration(
                                  color: Colors.greenAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: SvgPicture.asset(
                        "assets/icons/qr.svg",
                        color: Colors.black,
                      ),
                    );
                  } else {
                    String username = snapshot.data!.get("userName");
                    String userbio = snapshot.data!.get("userBio");
                    return ListTile(
                      onTap: () {},
                      title: Text(
                        "@$username",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        userbio,
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppTheme.mainColor,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: const BoxDecoration(
                                  color: Colors.greenAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: SvgPicture.asset(
                        "assets/icons/qr.svg",
                        color: Colors.black,
                      ),
                    );
                  }
                }),
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
            const SizedBox(height: 5),
            ListTile(
              leading: SvgPicture.asset(
                "assets/icons/sec.svg",
                color: Colors.black,
              ),
              title: Text(
                "Security",
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
                "assets/icons/help.svg",
                color: Colors.black,
              ),
              title: Text(
                "Help Center",
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
                "assets/icons/friends.svg",
                color: Colors.black,
              ),
              title: Text(
                "Invite friends",
                style: GoogleFonts.lato(),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ),
            //Logout
            ListTile(
              splashColor: Colors.grey.shade400,
              onTap: () {
                _showLogoutConfirmation(context);
              },
              leading: SvgPicture.asset(
                "assets/icons/logout.svg",
                color: Colors.redAccent,
              ),
              title: Text(
                "Logout",
                style: GoogleFonts.lato(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Logout",
            style: GoogleFonts.lato(),
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: GoogleFonts.lato(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                "Cancel",
                style: GoogleFonts.lato(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Logout",
                style: GoogleFonts.lato(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                customLoader.showLoader(context);
                authController.logout(customLoader: customLoader);
              },
            ),
          ],
        );
      },
    );
  }
}
