import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_mate_messanger/controllers/channels_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/custom_icons.dart';
import 'package:chat_mate_messanger/widgets/channel_chat_bubble.dart';
import 'package:chat_mate_messanger/widgets/channel_message_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChannelRoomPage extends StatefulWidget {
  ChannelRoomPage({
    super.key,
    required this.isAdmin,
    required this.isMateFllowing,
    required this.isChannelVerified,
    required this.channelName,
    required this.channelUid,
    required this.channelPhotoUrl,
    required this.followersText,
  });
  final bool isAdmin;
  bool isMateFllowing;
  final bool isChannelVerified;
  final String channelName;
  final String channelUid;
  final String channelPhotoUrl;
  final String followersText;

  @override
  State<ChannelRoomPage> createState() => _ChannelRoomPageState();
}

class _ChannelRoomPageState extends State<ChannelRoomPage> {
  FocusNode focusNode = FocusNode();
  ChannelsController channelsController = Get.put(ChannelsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBacgroundColor,
        leadingWidth: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.channelPhotoUrl,
                height: 45,
                width: 45,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.channelName,
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 3),
                      widget.isChannelVerified
                          ? const Icon(
                              Icons.verified,
                              color: AppTheme.mainColor,
                              size: 16,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Text(
                    widget.followersText,
                    style: GoogleFonts.lato(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          widget.isMateFllowing
              ?
              //Unfollow button
              IconButton(
                  onPressed: () async {
                    unfollowChannel(widget.channelName);
                  },
                  icon: SvgPicture.asset(
                    CustomIcons.logout,
                    colorFilter:
                        const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                  ),
                )
              :
              //Follow channel
              InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () async {
                    await channelsController.followChannel(widget.channelUid);
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
                        "Follow",
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
        color: AppTheme.scaffoldBacgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ChannelChatBubble(
                    message: "hi",
                    isAdmin: widget.isAdmin,
                    type: "text",
                  );
                },
              ),
            ),

            //if owner is current user then return write message

            widget.isAdmin
                ? ChannelMessageBar(
                    channelUid: widget.channelUid,
                    focusNode: focusNode,
                    messageBarHintStyle: GoogleFonts.lato(fontSize: 15),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  //Unfollow channel.
  void unfollowChannel(String channelName) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Unfollow channel $channelName",
            style: GoogleFonts.lato(),
          ),
          content: Text(
            "Are you sure you want to unfollow $channelName mate?",
            style: GoogleFonts.lato(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                "Cancel",
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: AppTheme.mainColorLight,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "unfollow",
                style: GoogleFonts.lato(
                  color: Colors.redAccent,
                  fontSize: 14,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                //Unfollow function.
                await channelsController.unfollowChannel(widget.channelUid);
              },
            ),
          ],
        );
      },
    );
  }
}
