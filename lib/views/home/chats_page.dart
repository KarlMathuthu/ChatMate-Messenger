import 'package:chat_mate_messanger/controllers/chat_controller.dart';
import 'package:chat_mate_messanger/controllers/sharedPref_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/views/chats/chat_room_page.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../model/message_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      appBar: AppBar(
        title: Text(
          "ChatMate",
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
               Get.to(() => const ContactsPage(), transition: Transition.cupertino);
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
                  .collection("chats")
                  .where("members", arrayContains: currentUserId)
                  .snapshots(),
              builder: (context, chatSnapshot) {
                if (!chatSnapshot.hasData) {
                  return const SizedBox();
                } else if (chatSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  // return Center();
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: AppTheme.loaderColor,
                      size: 40,
                    ),
                  );
                } else if (chatSnapshot.data!.docs.isEmpty) {
                  // Display a message when there are no chats.
                  return Center(
                    child: Text(
                      "Wave at mates by clicking the Find Mate",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: chatSnapshot.data!.docs.length,
                    // shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      List<dynamic> messages =
                          chatSnapshot.data!.docs[index]["messages"];
                      List<MessageModel> unreadMessages = [];

                      for (var messageData in messages) {
                        bool isSenderCurrentUser =
                            messageData["sender"] == currentUserId;

                        if (!isSenderCurrentUser && !messageData["read"]) {
                          MessageModel message = MessageModel(
                            sender: messageData["sender"],
                            messageText: messageData["messageText"],
                            timestamp: messageData["timestamp"],
                            read: messageData["read"],
                            messageType: messageData["messageType"],
                          );
                          unreadMessages.add(message);
                        }
                      }

                      int unreadMessageCount = unreadMessages.length;

                      return StreamBuilder<String>(
                        stream:
                            getUserNameByUID(getFriendUid(chatSnapshot, index)),
                        builder: (context, friendUidSnapshot) {
                          if (friendUidSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          } else if (!friendUidSnapshot.hasData) {
                            return const SizedBox();
                          } else {
                            String friendUsername =
                                friendUidSnapshot.data.toString();
                            String initials = friendUsername[0].toUpperCase() +
                                friendUsername[friendUsername.length - 1]
                                    .toUpperCase();
                            Map<String, dynamic>? lastMessage =
                                chatSnapshot.data!.docs[index]["last_message"];
                            String lastMessageSenderId = lastMessage!["sender"];
                            String messageType = lastMessage["type"];
                            bool isAWave = messageType == "wave" ||
                                lastMessage["messageText"] == null;

                            bool isLastMessageRead() {
                              if (lastMessageSenderId != currentUserId &&
                                  lastMessage["read"] == true) {
                                return true;
                              }
                              return false;
                            }

                            return ListTile(
                              onLongPress: () {
                                chatController.showDeleteDialog(
                                  context: context,
                                  chatId: chatSnapshot.data!.docs[index].id,
                                  customLoader: customLoader,
                                );
                              },
                              onTap: () {
                                chatController.markChatAsRead(
                                  chatSnapshot.data!.docs[index]["chatId"],
                                );
                                Get.to(
                                  () => ChatRoomPage(
                                    mateName: friendUsername,
                                    mateUid: getFriendUid(chatSnapshot, index),
                                    chatRoomId: chatSnapshot.data!.docs[index]
                                        ["chatId"],
                                    isNewChat: false,
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
                              subtitle: isAWave
                                  ? Text(
                                      "A new wave 👋!",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    )
                                  : Text(
                                      lastMessageSenderId == currentUserId
                                          ? "Me : ${lastMessage["messageText"]}"
                                          : lastMessage["messageText"],
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(
                                        color: isLastMessageRead() == false &&
                                                lastMessageSenderId !=
                                                    currentUserId
                                            ? AppTheme.loaderColor
                                            : Colors.black54,
                                        fontSize: 12,
                                        fontWeight: isLastMessageRead() == false
                                            ? FontWeight.bold
                                            : FontWeight.normal,
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
                              leading: StreamBuilder<String>(
                                  stream: getUserStatus(
                                      getFriendUid(chatSnapshot, index)),
                                  builder: (context, userStatusSnap) {
                                    if (!userStatusSnap.hasData) {
                                      return Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: AppTheme.mainColorLight,
                                        ),
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
                                      );
                                    } else if (userStatusSnap.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: AppTheme.mainColorLight,
                                        ),
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
                                      );
                                    } else {
                                      bool isUserOnline =
                                          userStatusSnap.data! == "online";

                                      return Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: AppTheme.mainColorLight,
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Text(
                                                initials,
                                                style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 73, 255, 167),
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
