// import 'dart:io';

// import 'package:chat_mate_messanger/controllers/signaling_controller.dart';
// import 'package:chat_mate_messanger/theme/app_theme.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AnswerCallPage extends StatefulWidget {
//   const AnswerCallPage({super.key});

//   @override
//   State<AnswerCallPage> createState() => _AnswerCallPageState();
// }

// class _AnswerCallPageState extends State<AnswerCallPage> {
//   Signaling signaling = Signaling();
//   String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   RTCVideoRenderer localRenderer = RTCVideoRenderer();
//   RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
//   String? callId;
//   String? callType;

//   void getCallRoom() async {
//     await firestore
//         .collection("users")
//         .doc(currentUserUid)
//         .collection("calls")
//         .doc(currentUserUid)
//         .get()
//         .then(
//           (value) => {
//             callId = value["callRoomId"],
//             callType = value["callType"],
//           },
//         );
//   }

//   void answerCall() async {
//     await signaling.joinRoom(
//       callId ?? "none",
//       null,
//     );
//   }

//   void declineCall() async {
//     await firestore
//         .collection("users")
//         .doc(currentUserUid)
//         .collection("calls")
//         .doc(currentUserUid)
//         .delete();
//   }

//   void initilizaMedia() async {
//     signaling.openUserMedia(
//       null,
//       null,
//       callType ?? "audio",
//     );
//     print("Got user media");
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCallRoom();
//     initilizaMedia();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.callScaffoldColor,
//       body: Stack(
//         children: [
//           Align(
//             alignment: Alignment.topCenter,
//             child: AppBar(
//               backgroundColor: AppTheme.callScaffoldColor,
//               leading: IconButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 icon: Icon(
//                   Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           Center(
//             child: Container(
//               height: 150,
//               width: 150,
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: SvgPicture.asset(
//                 "assets/icons/default.svg",
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 180),
//             child: Center(
//               child: Text(
//                 "Incoming Call...",
//                 style: GoogleFonts.lato(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),

//           //Three buttons
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 80,
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               width: double.infinity,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   //answer
//                   SizedBox(
//                     height: 60,
//                     width: 60,
//                     child: IconButton.filled(
//                       style: const ButtonStyle(
//                         backgroundColor: MaterialStatePropertyAll(
//                           AppTheme.mainColorLight,
//                         ),
//                       ),
//                       onPressed: () {
//                         answerCall();
//                       },
//                       icon: SvgPicture.asset(
//                         "assets/icons/call.svg",
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),

//                   //decline call
//                   SizedBox(
//                     height: 60,
//                     width: 60,
//                     child: IconButton.filled(
//                       style: const ButtonStyle(
//                         backgroundColor: MaterialStatePropertyAll(
//                           AppTheme.endCallButtonColor,
//                         ),
//                       ),
//                       onPressed: () {
//                         declineCall();
//                       },
//                       icon: SvgPicture.asset(
//                         "assets/icons/declineCall.svg",
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
