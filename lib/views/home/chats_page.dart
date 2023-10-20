import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/views/chats/chat_room_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;

import '../../model/message_model.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  ChatController chatController = Get.put(ChatController());
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String getFriendUid(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> chatData, int index) {
    List<String> members =
        List<String>.from(chatData.data!.docs[index]['members']);
    if (members.length > 1) {
      return members.firstWhere((userId) => userId != currentUserId,
          orElse: () => 'No friend found');
    }
    return 'No friend found';
  }

  Future getUserNameByUID(String uid) async {
    try {
      var userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userDoc.exists) {
        String userName = userDoc.data()?['userName'];
        return userName;
      } else {
        return "@ChatMateBot";
      }
    } catch (e) {
      return "Error fetching user data";
    }
  }

  Future getUserStatus(String uid) async {
    try {
      var userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userDoc.exists) {
        String userName = userDoc.data()?['userStatus'];
        return userName;
      } else {
        return "false";
      }
    } catch (e) {
      return "false";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      body: FutureBuilder(
        future: firestore
            .collection("chats")
            .where("members", arrayContains: currentUserId)
            .get(),
        builder: (context, chatSnapshot) {
          if (!chatSnapshot.hasData) {
            return SizedBox();
          } else if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(); /* Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: AppTheme.loaderColor,
                size: 50,
              ), */
            // );
          } else {
            return ListView.builder(
              itemCount: chatSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                //This is for calcutaing the unread messages
                List<dynamic> messages =
                    chatSnapshot.data!.docs[index]["messages"];
                List<MessageModel> readMessages = [];

                for (var messageData in messages) {
                  if (messageData["read"] == false) {
                    MessageModel message = MessageModel(
                      sender: messageData["sender"],
                      messageText: messageData["messageText"],
                      timestamp: messageData["timestamp"],
                      read: messageData["read"],
                    );
                    readMessages.add(message);
                  }
                }

                int unreadMessageCount = readMessages.length;

                return FutureBuilder(
                  future: getUserNameByUID(getFriendUid(chatSnapshot, index)),
                  builder: (context, friendUidSnapshot) {
                    if (friendUidSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (friendUidSnapshot.hasError) {
                      return const SizedBox();
                    } else {
                      String friendUsername = friendUidSnapshot.data.toString();

                      return ListTile(
                        onTap: () {
                          chatController.markChatAsRead(
                              chatSnapshot.data!.docs[index]["chatId"]);
                          //Update the UI
                          setState(() {});
                          Get.to(
                            () => ChatRoomPage(
                              mateName: friendUsername,
                              mateUid: getFriendUid(chatSnapshot, index),
                              chatRoomId: chatSnapshot.data!.docs[index]
                                  ["chatId"],
                            ),
                            transition: Transition.cupertino,
                          );
                        },
                        title: Text(
                          friendUsername,
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          "I tried to call you but yoh, My mom took the phone.",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        trailing: unreadMessageCount > 0
                            ? badges.Badge(
                                badgeAnimation:
                                    const badges.BadgeAnimation.fade(),
                                badgeStyle: const badges.BadgeStyle(
                                  badgeColor: AppTheme.mainColor,
                                ),
                                badgeContent: Text(
                                  unreadMessageCount.toString(),
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        leading: FutureBuilder(
                            future: getUserStatus(
                                getFriendUid(chatSnapshot, index)),
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
                                    child: SvgPicture.asset(
                                      "assets/icons/default.svg",
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
                                    child: SvgPicture.asset(
                                      "assets/icons/default.svg",
                                    ),
                                  ),
                                );
                              } else {
                                bool isUserOnline = userStatusSnap.data == true;

                                return Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: AppTheme.mainColorLight,
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/default.svg",
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
                                              color: Colors.greenAccent,
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
                            }),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),

      //Create message button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.mainColor,
        child: SvgPicture.asset(
          "assets/icons/chat.svg",
          color: Colors.white,
        ),
        onPressed: () {
          chatController.createChat(
            members: [
              currentUserId,
              "KarlMathuthu",
            ],
            senderId: currentUserId,
            messageText: "Hi there bro",
          );
        },
      ),
    );
  }
}
