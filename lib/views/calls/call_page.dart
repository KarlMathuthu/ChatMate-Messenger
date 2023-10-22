import 'dart:io';

import 'package:chat_mate_messanger/controllers/signaling_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
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
    initializeCall();
    super.initState();
  }

  void initializeCall() async {
    await signaling.createRoom(
      remoteRenderer,
      widget.mateUid,
      widget.callType,
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
                  decoration: const BoxDecoration(
                    color: AppTheme.callScaffoldColor,
                  ),
                  child: audioCallLayout(
                    widget.mateName,
                    context,
                  ),
                )
              : videoCallLayout(
                  localRenderer,
                  remoteRenderer,
                  widget.mateName,
                  context,
                ),
        ],
      ),
    );
  }
}

Widget renderVideoOrText(RTCVideoRenderer remoteRender, String mateName) {
  if (remoteRender.textureId != null) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: RTCVideoView(
          remoteRender,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
        ),
      ),
    );
  } else {
    return Container(
      color: AppTheme.callScaffoldColor,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text(
          "Calling $mateName ...",
          style: GoogleFonts.lato(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget videoCallLayout(
  RTCVideoRenderer localRenderer,
  RTCVideoRenderer remoteRenderer,
  String mateName,
  BuildContext context,
) {
  return Stack(
    children: [
      renderVideoOrText(remoteRenderer, mateName),
      //Local RTCVideoView
      Align(
        alignment: Alignment.topCenter,
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Column(
            children: [
              Text(
                "@$mateName",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "05:46 minutes",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 100),
        child: Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            height: 150,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: RTCVideoView(
                localRenderer,
                mirror: true,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
          ),
        ),
      ), //Three buttons
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Sound high
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AppTheme.callButtonsColor,
                    ),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/soundOn.svg",
                    color: Colors.white,
                  ),
                ),
              ),

              //mute
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AppTheme.callButtonsColor,
                    ),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/audioOn.svg",
                    color: Colors.white,
                  ),
                ),
              ),
              //End call
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AppTheme.endCallButtonColor,
                    ),
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text("End Call"),
                          content: const Text(
                              "Are you sure you want to end this call?"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text(
                                "End Call",
                                style: TextStyle(
                                  color: CupertinoColors.systemRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                // Add your logic to end the call here
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
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

Widget audioCallLayout(String mateName, BuildContext context) {
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
            "Voice Call",
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
      Padding(
        padding: const EdgeInsets.only(top: 180),
        child: Center(
          child: Text(
            mateName,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 240),
        child: Center(
          child: Text(
            "05:46 minutes",
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
      //Three buttons
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Sound high
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AppTheme.callButtonsColor,
                    ),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/soundOn.svg",
                    color: Colors.white,
                  ),
                ),
              ),
              //mute
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AppTheme.callButtonsColor,
                    ),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    "assets/icons/audioOn.svg",
                    color: Colors.white,
                  ),
                ),
              ),
              //End call
              SizedBox(
                height: 60,
                width: 60,
                child: IconButton.filled(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AppTheme.endCallButtonColor,
                    ),
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text("End Call"),
                          content: const Text(
                              "Are you sure you want to end this call?"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text(
                                "End Call",
                                style: TextStyle(
                                  color: CupertinoColors.systemRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                // Add your logic to end the call here
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
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
