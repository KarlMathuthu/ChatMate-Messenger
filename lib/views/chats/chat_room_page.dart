import 'dart:io';

import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/widgets/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../widgets/chat_buble.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({
    super.key,
    required this.mateName,
    required this.mateUid,
    required this.chatRoomId,
  });
  final String mateName;
  final String mateUid;
  final String chatRoomId;
  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  ChatController chatController = Get.put(ChatController());
  FocusNode focusNode = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  DateTime getTime(String userStatus) {
    DateTime? dateTime = DateTime.tryParse(userStatus);
    if (dateTime != null) {
      return dateTime;
    } else {
      return DateTime.now();
    }
  }

  Future getUserToken(String uid) async {
    try {
      var userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userDoc.exists) {
        String userName = userDoc.data()?['fcmToken'];
        return userName;
      } else {
        return "false";
      }
    } catch (e) {
      return "false";
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.mateName,
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FutureBuilder(
                future: chatController.getUserStatus(widget.mateUid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      "connecting...",
                      style: GoogleFonts.lato(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text(
                      "connecting...",
                      style: GoogleFonts.lato(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    );
                  } else {
                    String lastSeen = timeago.format(getTime(snapshot.data!));
                    return Text(
                      snapshot.data! == "online"
                          ? snapshot.data!
                          : "last seen $lastSeen",
                      style: GoogleFonts.lato(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/call.svg",
                color: AppTheme.mainColor,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/video.svg",
                color: AppTheme.mainColor,
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 0.8),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: AppTheme.scaffoldBacgroundColor,
          ),
          child: Column(
            children: [
              //Chats
              Expanded(
                child: StreamBuilder(
                  stream: firestore
                      .collection("chats")
                      .doc(widget.chatRoomId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No chats Available"),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Text("Loading"),
                      );
                    } else {
                      List<dynamic> messages =
                          snapshot.data!.data()!["messages"];
                      // Sort messages by "timestamp" in descending order
                      messages.sort(
                          (a, b) => b["timestamp"].compareTo(a["timestamp"]));
                      return ListView.builder(
                        itemCount: messages.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: false,
                        itemBuilder: (context, index) {
                          bool isSender = messages[index]["sender"] ==
                              auth.currentUser!.uid;

                          bool isRead = messages[index]["read"];
                          bool isSent = isRead == false;

                          return MyChatBubble(
                            message: messages[index]["messageText"],
                            isSender: isSender,
                            //isRead: isRead,
                            //isDelivered: isDelivered,
                            //isSent: isSent,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),

              //Write message
              FutureBuilder(
                future: getUserToken(widget.mateUid),
                builder: (context, snapshot) {
                  final mateToken = snapshot.data;

                  return CustomMessageBar(
                    focusNode: focusNode,
                    messageBarHintText: "Type a message",
                    messageBarHintStyle: GoogleFonts.lato(fontSize: 14),
                    textFieldTextStyle: GoogleFonts.lato(fontSize: 14),
                    currentUser: auth.currentUser!.uid,
                    chatRoomId: widget.chatRoomId,
                    mateName: widget.mateName,
                    mateToken: mateToken ?? "none",
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
