import 'dart:io';

import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({
    super.key,
    required this.mateName,
    required this.mateUid,
  });
  final String mateName;
  final String mateUid;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
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
              Text(
                "online",
                style: GoogleFonts.lato(
                  color: Colors.black54,
                  fontSize: 14,
                ),
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
              const Expanded(child: Column()),
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
            ],
          ),
        ),
      ),
    );
  }
}
