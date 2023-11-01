import 'package:flutter/material.dart';

class ChannelRoomPage extends StatefulWidget {
  const ChannelRoomPage({
    super.key,
    required this.isAdmin,
    required this.channelName,
    required this.channelUid,
    required this.channelPhotoUrl,
    required this.followersText,
  });
  final bool isAdmin;
  final String channelName;
  final String channelUid;
  final String channelPhotoUrl;
  final String followersText;

  @override
  State<ChannelRoomPage> createState() => _ChannelRoomPageState();
}

class _ChannelRoomPageState extends State<ChannelRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //CustomAppBar.
        ],
      ),
    );
  }
}
