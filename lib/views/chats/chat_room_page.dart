import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/widgets/chat_buble.dart';
import 'package:chat_mate_messanger/widgets/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
        setState(() {});
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
              Expanded(
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
                        itemCount: 10,
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return MyChatBubble();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //Write message
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        // height: 50,
                        constraints: const BoxConstraints(
                          minHeight: 50,
                          maxHeight: 100,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: focusNode.hasFocus
                              ? AppTheme.textfieldActiveColor
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: focusNode.hasFocus
                                ? AppTheme.textfieldActiveBorderColor
                                : Colors.transparent,
                          ),
                        ),
                        child: TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.bottom,
                          keyboardType: TextInputType.text,
                          onTap: () {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                "assets/icons/emoji.svg",
                                color: Colors.grey,
                              ),
                            ),
                            border: InputBorder.none,
                            hintText: "Type a message",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    FloatingActionButton(
                      onPressed: () {},
                      shape: const CircleBorder(),
                      backgroundColor: AppTheme.mainColor,
                      child: SvgPicture.asset(
                        "assets/icons/record.svg",
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              CustomMessageBar(
                messageBarHintText: "Type a message",
                messageBarHintStyle: GoogleFonts.lato(
                  fontSize: 14,
                ),
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
