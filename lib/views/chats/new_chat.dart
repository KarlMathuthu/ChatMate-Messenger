import 'dart:io';

import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../theme/app_theme.dart';
import '../../widgets/chat_buble.dart';
import '../../widgets/message_bar.dart';
import '../calls/call_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewChatPage extends StatefulWidget {
  const NewChatPage({
    super.key,
    required this.mateName,
    required this.mateStatus,
    required this.mateUid,
    required this.chatRoomId,
  });
  final String mateName;
  final String mateStatus;
  final String mateUid;
  final String chatRoomId;

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  FocusNode focusNode = FocusNode();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ChatController chatController = Get.put(ChatController());

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

  @override
  Widget build(BuildContext context) {
    String lastSeen = timeago.format(getTime(widget.mateStatus));
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
              Text(
                widget.mateStatus == "online"
                    ? widget.mateStatus
                    : "last seen $lastSeen",
                style: GoogleFonts.lato(
                  color: Colors.black54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(
                  () => CallPage(
                    mateUid: widget.mateUid,
                    callType: "audio",
                    mateName: widget.mateName,
                  ),
                );
              },
              icon: SvgPicture.asset(
                "assets/icons/call.svg",
                color: AppTheme.mainColor,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(
                  () => CallPage(
                    mateUid: widget.mateUid,
                    callType: "video",
                    mateName: widget.mateName,
                  ),
                );
              },
              icon: SvgPicture.asset(
                "assets/icons/video.svg",
                color: AppTheme.mainColor,
              ),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(top: 0.8),
          decoration: const BoxDecoration(
            color: AppTheme.scaffoldBacgroundColor,
          ),
          child: widget.mateUid == auth.currentUser!.uid
              ? Center(
                  child: Text(
                    "You can't message yourself!",
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          StreamBuilder(
                            stream: firestore
                                .collection("chats")
                                .doc(widget.chatRoomId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center();
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text("Error: ${snapshot.error}"),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null ||
                                  snapshot.data!.data() == null) {
                                return const Center(
                                  child: Text("Send your first message"),
                                );
                              } else {
                                List<dynamic> messages =
                                    snapshot.data!.data()!["messages"];

                                messages.sort((a, b) =>
                                    b["timestamp"].compareTo(a["timestamp"]));

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    bool isSender =
                                        snapshot.data!.data()!["messages"]
                                                [index]["sender"] ==
                                            auth.currentUser!.uid;

                                    bool isRead = messages[index]["read"];
                                    bool isSent = isRead == false;

                                    return GestureDetector(
                                      onLongPress: () {
                                        chatController.showCustomDialog(
                                          context: context,
                                          isCurrentUser: isSender,
                                          message: messages[index]
                                              ["messageText"],
                                          chatId: widget.chatRoomId,
                                          messageId: snapshot.data!.id,
                                        );
                                      },
                                      child: MyChatBubble(
                                        message: messages[index]["messageText"],
                                        isSender: isSender,
                                        type: messages[index]["messageType"],
                                        //isRead: isRead,
                                        //isDelivered: isDelivered,
                                        //isSent: isSent,
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
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
                          isNewChat: true,
                          mateUid: widget.mateUid,
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
