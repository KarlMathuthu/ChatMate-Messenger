import 'package:chat_mate_messanger/controllers/audio_call_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoiceCallPage extends StatefulWidget {
  const VoiceCallPage({super.key, required this.mateUid});
  final String mateUid;

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: CupertinoButton(
              color: Colors.lightBlue,
              onPressed: () {
                AudioCallHandler().answerCall(widget.mateUid);
              },
              child: Text(
                "Answer",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
