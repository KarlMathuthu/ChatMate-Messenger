import 'package:chat_mate_messanger/controllers/signaling_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key, required this.mateUid});
  final String mateUid;

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
    signaling.openUserMedia(localRenderer, remoteRenderer);
    initializeCall();
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
      appBar: AppBar(
        title: Text("Call Page"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(remoteRenderer)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
