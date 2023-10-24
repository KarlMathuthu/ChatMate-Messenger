import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/views/status/status_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/status_view_widget.dart';

class StatusesPage extends StatefulWidget {
  const StatusesPage({super.key});

  @override
  State<StatusesPage> createState() => _StatusesPageState();
}

class _StatusesPageState extends State<StatusesPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  List<String> names = [
    "@AlexAmbrose",
    "@DebbieClifton",
    "@JustinAmbrose",
  ];
  List<int> numberOfStatus = [
    3,
    1,
    5,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            //My Status.
            ListTile(
              onTap: () {},
              title: Text(
                "My Status",
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Tap to add status updates",
                style: GoogleFonts.lato(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
              leading: StreamBuilder(
                stream:
                    firestore.collection("users").doc(currentUser).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Stack(
                      children: [
                        // CircleAvatar
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 222, 235, 255),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.mainColor,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Stack(
                      children: [
                        // CircleAvatar
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Color.fromARGB(255, 222, 235, 255),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.mainColor,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    String username = snapshot.data!.get("userName");
                    String initials = username[0].toUpperCase() +
                        username[username.length - 1].toUpperCase();

                    return Stack(
                      children: [
                        // CircleAvatar
                        CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              const Color.fromARGB(255, 96, 149, 255),
                          child: Center(
                            child: Text(
                              initials,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.mainColor,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            //Get Statuses from 'statuses'

            StreamBuilder(
              stream: firestore.collection("statuses").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      List<dynamic> statusList =
                          snapshot.data!.docs[index]["status"];

                      Map<String, dynamic> statusMap = statusList[index];
                      String userName = statusMap["userName"];
                      String initials = userName[0].toUpperCase() +
                          userName[userName.length - 1].toUpperCase();
                      return ListTile(
                        onTap: () {
                          Get.to(
                            () => const StatusViewPage(),
                            transition: Transition.cupertino,
                          );
                        },
                        title: Text(
                          userName,
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          "Today at 15:04",
                          style: GoogleFonts.lato(
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        leading: StatusView(
                          radius: 25,
                          spacing: 15,
                          strokeWidth: 2,
                          indexOfSeenStatus: 1,
                          numberOfStatus: numberOfStatus[index],
                          padding: 4,
                          seenColor: Colors.grey,
                          unSeenColor: Colors.red,
                          child: Center(
                            child: Text(
                              initials,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
