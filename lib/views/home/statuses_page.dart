import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../widgets/status_view_widget.dart';

class StatusesPage extends StatefulWidget {
  const StatusesPage({super.key});

  @override
  State<StatusesPage> createState() => _StatusesPageState();
}

class _StatusesPageState extends State<StatusesPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String currentUser = FirebaseAuth.instance.currentUser!.uid;

  DateTime getTime(String userStatus) {
    DateTime? dateTime = DateTime.tryParse(userStatus);
    if (dateTime != null) {
      return dateTime;
    } else {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mates Status",
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              //Find mate
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 32,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 227, 255),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "New Status",
                  style: GoogleFonts.lato(
                    color: AppTheme.mainColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            //Search
            Container(
              height: 40,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    "assets/icons/search.svg",
                    height: 18,
                    colorFilter:
                        const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Search mate...",
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            //My Status.
            ListTile(
              onTap: () {},
              title: Text(
                "My Status",
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Tap to add status updates",
                style: GoogleFonts.lato(
                  color: Colors.black54,
                  fontSize: 12,
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
                      String userName = snapshot.data!.docs[index]["userName"];
                      String initials = userName[0].toUpperCase() +
                          userName[userName.length - 1].toUpperCase();
                      String statusUpdateTime = timeago.format(
                        getTime(
                          statusMap["timestamp"].toString(),
                        ),
                      );

                      return ListTile(
                        onTap: () {
                          /* Get.to(
                            () => const StatusViewPage(),
                            transition: Transition.cupertino,
                          ); */
                          print(
                              "KKKKKKKKKKKKKKAAAAAAAAAAAAAAARRRRRRRRRRRRRRRLLLLLLLLLLLL = $statusMap");
                        },
                        title: Text(
                          userName,
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          statusUpdateTime,
                          style: GoogleFonts.lato(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        leading: StatusView(
                          radius: 25,
                          spacing: 15,
                          strokeWidth: 2,
                          indexOfSeenStatus: 1,
                          numberOfStatus: statusList.length,
                          padding: 4,
                          seenColor: Colors.grey,
                          unSeenColor: AppTheme.mainColor,
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
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: AppTheme.mainColor,
        child: SvgPicture.asset(
          "assets/icons/status.svg",
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
}
