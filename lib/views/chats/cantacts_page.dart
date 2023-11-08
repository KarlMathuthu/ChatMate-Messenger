import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:chat_mate_messanger/controllers/notifications_controller.dart';
import 'package:chat_mate_messanger/views/chats/chat_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/app_theme.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  ChatController chatController = Get.put(ChatController());

  void showSendWaveDialog(
    String mateName,
    String mateUid,
    String mateToken,
  ) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(
          "Hi to $mateName \n\n👋\n",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(
          "Do you want to send a wave to mate?",
          style: GoogleFonts.lato(),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              "Cancel",
              style: GoogleFonts.lato(
                color: AppTheme.mainColorLight,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              "Send Wave",
              style: GoogleFonts.lato(
                color: AppTheme.mainColor,
              ),
            ),
            onPressed: () async {
              Get.back();
              //send a wave to mate
              // waveAtMate(currentUserUid, mateUid);
              //send a notification.
              NotificationsController.sendMessageNotification(
                userToken: mateToken,
                body:
                    "A mate sent you a wave 😊, Reply them and become friends!",
                title: "ChatMate - Wave 👋",
              );
              Get.snackbar(
                  "Wave sent 😊😊", "You have sent a wave to $mateName");
            },
          ),
        ],
      ),
    );
  }

  // void waveAtMate(String currentUserUid, String mateUid) {
  //   chatController.sendAWaveToMate(
  //     members: [
  //       currentUserUid,
  //       mateUid,
  //     ],
  //     senderId: currentUserUid,
  //     messageText: "👋👋",
  //     type: "wave",
  //   );
  // }

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
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              //Find channels
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
                  "Filter Mates",
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
        title: Text(
          "Find Mates",
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
            const SizedBox(height: 5),
            //Search
            Container(
              height: 40,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    "assets/icons/search.svg",
                    height: 18,
                    colorFilter:
                        const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Search mates...",
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: firestore
                    .collection("users")
                    .orderBy("userStatus", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: AppTheme.loaderColor,
                        size: 40,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        bool isUserOnline = snapshot.data!.docs[index]
                                ["userStatus"] ==
                            "online";

                        String username =
                            snapshot.data!.docs[index]["userName"];
                        String mateUid = snapshot.data!.docs[index]["userUid"];
                        String mateToken =
                            snapshot.data!.docs[index]["fcmToken"];
                        String currentUserUid =
                            FirebaseAuth.instance.currentUser!.uid;
                        bool hasProfilePicture =
                            snapshot.data!.docs[index]["photoUrl"] != "none";
                        bool isVerified =
                            snapshot.data!.docs[index]["isVerified"];
                        String initials = username[0].toUpperCase() +
                            username[username.length - 1].toUpperCase();
                        if (mateUid == currentUserUid) {
                          return const SizedBox();
                        }

                        return ListTile(
                          onTap: () async {
                            if (mateUid == currentUserUid) {
                              Get.snackbar("No no 😳",
                                  "You can't send a message to yourself Mate!");
                            } else if (username == "chatmate") {
                              Get.dialog(
                                CupertinoAlertDialog(
                                  title: Text(
                                    "Note Mate!",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red,
                                    ),
                                  ),
                                  content: Text(
                                    "You can't send a wave at the chatMate's official account!",
                                    style: GoogleFonts.lato(
                                        color: CupertinoColors.black),
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text(
                                        "Understood!",
                                        style: GoogleFonts.lato(
                                          color: AppTheme.mainColor,
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              Get.off(
                                transition: Transition.cupertino,
                                () => ChatRoomPage(
                                  mateName: username,
                                  mateUid: mateUid,
                                ),
                              );
                            }
                          },
                          title: Row(
                            children: [
                              Text(
                                "@${snapshot.data!.docs[index]["userName"]}",
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
                            snapshot.data!.docs[index]["userBio"],
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
                                hasProfilePicture
                                    ? CachedNetworkImage(
                                        imageUrl: snapshot.data!.docs[index]
                                            ["photoUrl"],
                                      )
                                    : Center(
                                        child: Text(
                                          initials,
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                if (isUserOnline) ...{
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.onlineStatus,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                } else
                                  const SizedBox()
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
