import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
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
          "Calls",
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
              //Clear call history
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
                  "Join Call",
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
      backgroundColor: Colors.grey.shade300,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.only(top: 0),
        color: AppTheme.scaffoldBacgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    "Search calls...",
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            //Call History
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "No recent calls",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text(
      //     "Join Call",
      //     style: GoogleFonts.lato(
      //       color: Colors.white,
      //       fontSize: 14,
      //     ),
      //   ),
      //   backgroundColor: AppTheme.mainColor,
      //   onPressed: () {},
      //   icon: SvgPicture.asset(
      //     CustomIcons.joinCall,
      //     height: 18,
      //     colorFilter: const ColorFilter.mode(
      //       Colors.white,
      //       BlendMode.srcIn,
      //     ),
      //   ),
      // ),
    );
  }
}
