import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../calls/answer_call.dart';
import '../calls/call_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewChatPage extends StatefulWidget {
  const NewChatPage({
    super.key,
    required this.mateName,
    required this.mateStatus,
    required this.mateUid,
  });
  final String mateName;
  final String mateStatus;
  final String mateUid;

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  DateTime getTime(String userStatus) {
    DateTime? dateTime = DateTime.tryParse(userStatus);
    if (dateTime != null) {
      return dateTime;
    } else {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    String lastSeen = timeago.format(getTime(widget.mateStatus));
    return Scaffold(
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
              /*  Get.to(
                  () => CallPage(
                    mateUid: widget.mateUid,
                    callType: "video",
                    mateName: widget.mateName,
                  ),
                ); */
            },
            icon: SvgPicture.asset(
              "assets/icons/video.svg",
              color: AppTheme.mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
