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
  TextEditingController textEditingController = TextEditingController();
  ChatController chatController = Get.put(ChatController());
  FocusNode focusNode = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

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
                  fontSize: 18,
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
                        fontSize: 14,
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text(
                      "connecting...",
                      style: GoogleFonts.lato(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    );
                  } else {
                    return Text(
                      snapshot.data!,
                      style: GoogleFonts.lato(
                        color: Colors.black54,
                        fontSize: 14,
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
              FutureBuilder(
                future:
                    firestore.collection("chats").doc(widget.chatRoomId).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("No chats Available"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Text("Loading"),
                    );
                  } else {
                    List<dynamic> messages = snapshot.data!.data()!["messages"];
                    return Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            //Day
                            Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(4.0),
                              constraints: const BoxConstraints(
                                minWidth: 80,
                                maxWidth: 100,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Today',
                                  overflow: TextOverflow.fade,
                                  style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            ListView.builder(
                              itemCount: messages.length,
                              reverse: false,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
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
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              //Write message
              CustomMessageBar(
                focusNode: focusNode,
                messageBarHintText: "Type a message",
                messageBarHintStyle: GoogleFonts.lato(
                  fontSize: 14,
                ),
                textFieldTextStyle: GoogleFonts.lato(
                  fontSize: 14,
                ),
                onSend: (message) {
                  chatController.sendMessage(
                    chatId: widget.chatRoomId,
                    senderId: auth.currentUser!.uid,
                    messageText: message,
                  );
                },
                actions: [
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      "assets/icons/emoji.svg",
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
