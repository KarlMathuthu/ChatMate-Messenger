import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:chat_mate_messanger/controllers/sharedPref_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../chats/cantacts_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  ChatController chatController = Get.put(ChatController());
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CustomLoader customLoader = CustomLoader();
  SharedPrefController sharedPrefController = Get.put(SharedPrefController());

  // String getFriendUid(
  //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> chatData, int index) {
  //   List<String> members =
  //       List<String>.from(chatData.data!.docs[index]['members']);

  //   return 'No friend found';
  // }

  Stream<String> getUserNameByUID(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((userDoc) {
      if (userDoc.exists) {
        String userName = userDoc.data()?['userName'];
        return userName;
      } else {
        return "@ChatMateBot";
      }
    }).handleError((error) {
      return "Error fetching user data";
    });
  }

  Stream<String> getUserStatus(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((userDoc) {
      if (userDoc.exists) {
        String userStatus = userDoc.data()?['userStatus'];
        return userStatus;
      } else {
        return "offline";
      }
    }).handleError((error) {
      return "offline";
    });
  }

  Stream<String> getUserProfilePic(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((userDoc) {
      if (userDoc.exists) {
        String profilePic = userDoc.data()?['photoUrl'];
        return profilePic;
      } else {
        return "none";
      }
    }).handleError((error) {
      return "none";
    });
  }

  Stream<String> getUserVerification(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((userDoc) {
      if (userDoc.exists) {
        String isVerified = userDoc.data()!['isVerified'].toString();
        return isVerified;
      } else {
        return "false";
      }
    }).handleError((error) {
      return "false";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            text: "Chat",
            style: TextStyle(
              color: AppTheme.mainColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: " Mate",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              //Find mate
              Get.to(() => const ContactsPage(),
                  transition: Transition.cupertino);
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
                  "Find Mate",
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
      body: Column(
        children: [
          //Search chats/mate
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
                  "Search chats...",
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
          //Chats
          Expanded(
            child: StreamBuilder(
              stream: firestore
                  .collection("users")
                  .doc(currentUserId)
                  .collection("chats")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return Center();
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: AppTheme.loaderColor,
                      size: 40,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // Display a message when there are no chats.
                  return Center(
                    child: Text(
                      "No recent chats",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: StreamBuilder<String>(
                          stream: getUserStatus(snapshot.data!.docs[index].id),
                          builder: (context, userStatusSnap) {
                            if (!userStatusSnap.hasData) {
                              return Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.mainColorLight,
                                ),
                                child: Center(
                                  child: Text(
                                    "HL",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            } else if (userStatusSnap.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.mainColorLight,
                                ),
                                child: Center(
                                  child: Text(
                                    "HL",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              bool isUserOnline =
                                  userStatusSnap.data! == "online";

                              return StreamBuilder<String>(
                                stream: getUserProfilePic(
                                    snapshot.data!.docs[index].id),
                                builder: (context, profileSnap) {
                                  if (!profileSnap.hasData) {
                                    return Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: AppTheme.mainColorLight,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "HL",
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    bool hasProfilePicture =
                                        profileSnap.data! != "none";
                                    return Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: AppTheme.mainColorLight,
                                      ),
                                      child: Stack(
                                        children: [
                                          hasProfilePicture
                                              ? CachedNetworkImage(
                                                  imageUrl: profileSnap.data!,
                                                )
                                              : Center(
                                                  child: Text(
                                                    "HL",
                                                    style: GoogleFonts.lato(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                          if (isUserOnline) ...{
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                decoration: const BoxDecoration(
                                                  color: AppTheme.onlineStatus,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            )
                                          } else
                                            const SizedBox()
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),

      //Create message button
      // floatingActionButton: FloatingActionButton(
      //   shape: CircleBorder(),
      //   backgroundColor: AppTheme.mainColor,
      //   child: SvgPicture.asset(
      //     "assets/icons/chat.svg",
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     Get.to(() => const ContactsPage(), transition: Transition.cupertino);
      //   },
      // ),
    );
  }
}
