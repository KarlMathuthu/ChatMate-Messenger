import 'package:chat_mate_messanger/controllers/auth_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/custom_icons.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:chat_mate_messanger/widgets/custom_tile.dart';
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
        title: Text(
          "Settings",
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              //Find mate
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 32,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 227, 255),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Edit Profile",
                  style: GoogleFonts.lato(
                    color: AppTheme.mainColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
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
                    return SizedBox();
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
                    String initials = username[0].toUpperCase() +
                        username[username.length - 1].toUpperCase();

                    return ListTile(
                      onTap: () {},
                      title: Text(
                        "@$username",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        userbio,
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppTheme.loaderColor,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                initials,
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
            CustomTile(
              title: "Chats",
              icon: CustomIcons.chat,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CustomTile(
              title: "Notifications",
              icon: CustomIcons.notification,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CustomTile(
              title: "Storage & Data",
              icon: CustomIcons.file,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CustomTile(
              title: "Security",
              icon: CustomIcons.security,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CustomTile(
              title: "Help Center",
              icon: CustomIcons.help,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CustomTile(
              title: "Invite friends",
              icon: CustomIcons.friends,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _showLogoutConfirmation(context);
              },
              child: Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 240, 241),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8.0),
                    SvgPicture.asset(
                      CustomIcons.logout,
                      color: Colors.red,
                      height: 22,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "Logout",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    const Expanded(child: Row()),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                  ],
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
