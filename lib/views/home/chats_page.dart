import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/custom_icons.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:badges/badges.dart' as badges;

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
        return "@userName";
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

  Future<int> calculateUnreadMessageCount(String chatUid) async {
    final chatRef = FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .collection("chats")
        .doc(chatUid)
        .collection("messages");

    final unreadMessageQuery =
        await chatRef.where("read", isEqualTo: false).get();

    return unreadMessageQuery.docs.length;
  }

  Stream<List<int>> getUnreadMessageCounts(
      List<DocumentSnapshot> chatDocuments) async* {
    List<int> unreadMessageCounts = [];
    for (var chatDocument in chatDocuments) {
      int unreadMessages = await calculateUnreadMessageCount(chatDocument.id);
      unreadMessageCounts.add(unreadMessages);
      yield List<int>.from(unreadMessageCounts);
    }
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
                      Map<String, dynamic> lastMessage =
                          snapshot.data!.docs[index]["last_message"];
                      bool isSender = lastMessage["sender"] == currentUserId;

                      return ListTile(
                        subtitle: Text(
                          lastMessage["messageText"],
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            color:
                                isSender ? Colors.black54 : AppTheme.mainColor,
                          ),
                        ),
                        title: StreamBuilder<String>(
                          stream:
                              getUserNameByUID(snapshot.data!.docs[index].id),
                          builder: (context, nameSnapshot) {
                            if (!nameSnapshot.hasData ||
                                nameSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return const SizedBox();
                            } else {
                              return Row(
                                children: [
                                  Text(
                                    "@${nameSnapshot.data!}",
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  StreamBuilder(
                                    stream: getUserVerification(
                                        snapshot.data!.docs[index].id),
                                    builder: (context, vSnapshot) {
                                      if (vSnapshot.hasError ||
                                          !vSnapshot.hasData ||
                                          vSnapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          vSnapshot.data! == "false") {
                                        return const SizedBox();
                                      } else {
                                        return const Icon(
                                          Icons.verified,
                                          color: AppTheme.mainColor,
                                          size: 16,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        trailing: StreamBuilder(
                          stream: getUnreadMessageCounts(snapshot.data!.docs),
                          builder: (context, msSnapshot) {
                            if (!msSnapshot.hasData ||
                                msSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return const SizedBox();
                            } else {
                              return badges.Badge(
                                badgeStyle: const badges.BadgeStyle(
                                  badgeColor: AppTheme.mainColor,
                                ),
                                badgeContent: Text(
                                  msSnapshot.data!.length.toString(),
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        leading: StreamBuilder<String>(
                          stream: getUserStatus(snapshot.data!.docs[index].id),
                          builder: (context, userStatusSnap) {
                            if (userStatusSnap.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppTheme.mainColor,
                                ),
                                child: const Center(),
                              );
                            } else {
                              bool isUserOnline =
                                  userStatusSnap.data! == "online";

                              return StreamBuilder<String>(
                                stream: getUserProfilePic(
                                    snapshot.data!.docs[index].id),
                                builder: (context, profileSnap) {
                                  if (!profileSnap.hasData ||
                                      profileSnap.connectionState ==
                                          ConnectionState.waiting) {
                                    return Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: AppTheme.mainColor,
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
                                        color: AppTheme.mainColor,
                                      ),
                                      child: Stack(
                                        children: [
                                          hasProfilePicture
                                              ? CachedNetworkImage(
                                                  imageUrl: profileSnap.data!,
                                                )
                                              : Center(
                                                  child: SvgPicture.asset(
                                                      CustomIcons.defaultIcon),
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
