import 'package:chat_mate_messanger/controllers/video_call_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VoiceCallPage extends StatefulWidget {
  const VoiceCallPage({super.key, required this.mateUid});
  final String mateUid;

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  CallSignaling signaling = CallSignaling();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: CupertinoButton(
              color: Colors.lightBlue,
              onPressed: () {
                signaling.answerCall(_remoteRenderer);
              },
              child: Text(
                "Answer",
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: RTCVideoView(
                      _localRenderer,
                      mirror: true,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  Expanded(
                    child: RTCVideoView(
                      _remoteRenderer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
