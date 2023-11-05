import 'dart:io';
import 'package:chat_mate_messanger/controllers/call_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  CallController signaling = CallController();
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  CustomLoader customLoader = CustomLoader();

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
    await signaling.createCallRoom(
      remoteRenderer: remoteRenderer,
      mateUid: widget.mateUid,
      callType: widget.callType,
      customLoader: customLoader,
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
                    widget.mateUid,
                    signaling,
                    localRenderer,
                    customLoader,
                  ),
                )
              : videoCallLayout(
                  localRenderer,
                  remoteRenderer,
                  widget.mateName,
                  context,
                  widget.mateUid,
                  signaling,
                  customLoader,
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
  String mateUid,
  CallController signaling,
  CustomLoader customLoader,
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
                              onPressed: () async {
                                signaling.closeCall(
                                    localRenderer, customLoader);
                                await FirebaseFirestore.instance
                                    .collection("calls")
                                    .doc(mateUid)
                                    .delete();
                                print("Call ended");
                                Get.back();
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

Widget audioCallLayout(
  String mateName,
  BuildContext context,
  String mateUid,
  CallController signaling,
  RTCVideoRenderer localRenderer,
  CustomLoader customLoader,
) {
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
                                signaling.closeCall(
                                    localRenderer, customLoader);

                                print("Call ended");
                                Get.back();
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
