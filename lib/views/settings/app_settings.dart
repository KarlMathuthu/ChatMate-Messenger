import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_mate_messanger/controllers/auth_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/avatars.dart';
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

class AppSettingsPage extends StatefulWidget {
  AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  AuthController authController = Get.put(AuthController());

  CustomLoader customLoader = CustomLoader();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  List<String> avatarsList = [
    Avatars.boy_1,
    Avatars.boy_2,
    Avatars.boy_3,
    Avatars.girl_1,
    Avatars.girl_2,
    Avatars.girl_3,
  ];

  int selectedAvatar = 0;

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
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
                      ),
                    );
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
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
                      ),
                    );
                  } else {
                    String username = snapshot.data!.get("userName");
                    String userbio = snapshot.data!.get("userBio");
                    bool hasProfilePicture =
                        snapshot.data!.get("photoUrl") != "none";
                    bool isVerified = snapshot.data!.get("isVerified");

                    return ListTile(
                      onTap: () {},
                      title: Row(
                        children: [
                          Text(
                            "@$username",
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 3),
                          isVerified
                              ? const Icon(
                                  Icons.verified,
                                  color: AppTheme.mainColor,
                                  size: 16,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      subtitle: Text(
                        userbio,overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      leading: GestureDetector(
                        onTap: () {
                          showChooseProfilePicture(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppTheme.loaderColor,
                          ),
                          child: Stack(
                            children: [
                              hasProfilePicture
                                  ? CachedNetworkImage(
                                      imageUrl: snapshot.data!.get("photoUrl"))
                                  : Center(
                                      child: SvgPicture.asset(
                                        CustomIcons.camera,
                                        height: 22,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                              // Center(
                              //   child: Text(
                              //     initials,
                              //     style: GoogleFonts.lato(
                              //       fontSize: 16,
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
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
                      ),
                      trailing: SvgPicture.asset(
                        "assets/icons/qr.svg",
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
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
                      colorFilter:
                          const ColorFilter.mode(Colors.red, BlendMode.srcIn),
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

  void showChooseProfilePicture(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (____) {
        return Container(
          height: Platform.isAndroid ? 190 : 230,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Text(
                "Choose your avatar",
                style: GoogleFonts.lato(
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: StatefulBuilder(
                    builder: (context, state) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: avatarsList.length,
                        itemBuilder: (context, index) {
                          return selectedAvatar == index
                              ? GestureDetector(
                                  onTap: () {
                                    selectedAvatar = index;
                                    state(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.mainColor,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    height: 80,
                                    width: 80,
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsets.all(4),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            avatarsList[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    selectedAvatar = index;
                                    state(() {});
                                  },
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    margin: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          avatarsList[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        },
                      );
                    },
                  ),
                ),
              ),
              //Save profile picture button.
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.mainColor,
                    child: Text(
                      "Update Profile Picture",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(____);
                      // Update profile Avatar.
                      customLoader.showLoader(context);
                      authController.updateUserProfilePcture(
                        assetPath: avatarsList[selectedAvatar],
                        customLoader: customLoader,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: Platform.isAndroid ? 10 : 50),
            ],
          ),
        );
      },
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
