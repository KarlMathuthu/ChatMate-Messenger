import 'package:chat_mate_messanger/controllers/video_call_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CallMatePage extends StatefulWidget {
  const CallMatePage({
    super.key,
    required this.mateName,
    required this.mateUid,
  });
  final String mateName;
  final String mateUid;

  @override
  State<CallMatePage> createState() => _CallMatePageState();
}

class _CallMatePageState extends State<CallMatePage> {
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  CallSignaling signaling = CallSignaling();

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    signaling.openUserMedia(_localRenderer, _remoteRenderer);
    signaling.startCall(_remoteRenderer, widget.mateUid);

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(widget.mateName),
      ),
      body: Stack(
        children: [
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
                    child: RTCVideoView(_remoteRenderer,),
                  ),
                ],
              ),
            ),
          ),
          //Render remote camera
          //Render local camera
          //end call, turn off video/mic
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              width: double.infinity,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppTheme.mainColorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.camera,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.camera,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.camera,
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
