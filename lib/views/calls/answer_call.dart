import 'package:chat_mate_messanger/controllers/signaling_controller.dart';
import 'package:flutter/material.dart';

class AnswerCallPage extends StatefulWidget {
  const AnswerCallPage({super.key});

  @override
  State<AnswerCallPage> createState() => _AnswerCallPageState();
}

class _AnswerCallPageState extends State<AnswerCallPage> {
  Signaling signaling = Signaling();

  void answerCall() async {
    /*  signaling.joinRoom(
      "",
      remoteRenderer,
    ); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
