import 'dart:io';

import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:chat_mate_messanger/views/chats/chat_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/icons/search.svg",
              color: Colors.black,
              height: 20,
            ),
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            icon: SvgPicture.asset(
              "assets/icons/cog.svg",
              color: Colors.black,
              height: 20,
            ),
            onSelected: (String choice) {
              switch (choice) {
                case 'newContact':
                  //handle oncick
                  break;
                case 'newGroup':
                  //handle onclik
                  break;
                case 'newBroadcast':
                  //handle onclick
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'newContact',
                  child: Text('New Contact'),
                ),
                const PopupMenuItem<String>(
                  value: 'newGroup',
                  child: Text('New Group'),
                ),
                const PopupMenuItem<String>(
                  value: 'newBroadcast',
                  child: Text('New Broadcast'),
                ),
              ];
            },
          ),
        ],
        title: Text(
          "Select Contact",
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
            //New group
            ListTile(
              onTap: () {},
              title: Text(
                "New Group",
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                    Center(
                      child: SvgPicture.asset(
                        "assets/icons/friends.svg",
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            //New contact
            ListTile(
              onTap: () {},
              title: Text(
                "New Contact",
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: SvgPicture.asset(
                "assets/icons/scan.svg",
                color: AppTheme.mainColor,
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
                    Center(
                      child: SvgPicture.asset(
                        "assets/icons/contact.svg",
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: firestore
                  .collection("users")
                  .orderBy("userStatus", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center();
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      bool isUserOnline =
                          snapshot.data!.docs[index]["userStatus"] == "online";

                      String username = snapshot.data!.docs[index]["userName"];
                      String initials = username[0].toUpperCase() +
                          username[username.length - 1].toUpperCase();

                      return ListTile(
                        onTap: () async {
                          Get.off(
                            () => ChatRoomPage(
                              mateName: snapshot.data!.docs[index]["userName"],
                              mateUid: snapshot.data!.docs[index]["userUid"],
                              chatRoomId: currentUserUid,
                              isNewChat: true,
                            ),
                          );
                          /*  Get.off(
                            () => NewChatPage(
                              mateName: snapshot.data!.docs[index]["userName"],
                              mateStatus: snapshot.data!.docs[index]
                                  ["userStatus"],
                              mateUid: snapshot.data!.docs[index]["userUid"],
                              chatRoomId: chatRoomId,
                            ),
                          ); */
                        },
                        title: Text(
                          "@${snapshot.data!.docs[index]["userName"]}",
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
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
                              if (isUserOnline) ...{
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 73, 255, 167),
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
          ],
        ),
      ),
    );
  }
}
