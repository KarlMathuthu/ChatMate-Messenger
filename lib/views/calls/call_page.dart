import 'dart:io';

import 'package:chat_mate_messanger/controllers/signaling_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CallPage extends StatefulWidget {
  const CallPage({
    super.key,
    required this.mateUid,
    required this.callType,
    required this.mateName,
  });
  final String mateUid;
  final String mateName;
  final String callType;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  Signaling signaling = Signaling();
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    localRenderer.initialize();
    remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      remoteRenderer.srcObject = stream;
      setState(() {});
    });
    signaling.openUserMedia(
      localRenderer,
      remoteRenderer,
      widget.callType,
    );
    //initializeCall();
    super.initState();
  }

  void initializeCall() async {
    await signaling.createRoom(
      remoteRenderer,
      widget.mateUid,
    );
    setState(() {});
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      body: Stack(
        children: [
          widget.callType == "audio"
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.callScaffoldColor,
                  ),
                  child: audioCallLayout(widget.mateName),
                )
              : RTCVideoView(localRenderer, mirror: true),
          /* Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  Expanded(child: RTCVideoView(remoteRenderer)),
                ],
              ),
            ),
          ), */
        ],
      ),
    );
  }
}

Widget audioCallLayout(String mateName) {
  return Stack(
    children: [
      Align(
        alignment: Alignment.topCenter,
        child: AppBar(
          backgroundColor: AppTheme.callScaffoldColor,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            "@$mateName",
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      ),
      Center(
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPicture.asset(
            "assets/icons/default.svg",
          ),
        ),
      ),
      //Three buttons
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 80,
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Sound high
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AppTheme.callButtonsColor,
                    ),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/default.svg",
                  ),
                ),
              ),
              //mute
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AppTheme.callButtonsColor,
                    ),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.speaker),
                ),
              ),
              //End call
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AppTheme.endCallButtonColor,
                    ),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/endcall.svg",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
