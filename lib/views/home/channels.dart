import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_mate_messanger/controllers/channels_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({super.key});

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  ChannelsController channelsController = Get.put(ChannelsController());
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String currentUser = FirebaseAuth.instance.currentUser!.uid;
  CustomLoader customLoader = CustomLoader();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      appBar: AppBar(
        title: Text(
          "Channels",
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
              //discover channels
              // Get.to(() => CreateChannelPage());
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
                  "Discover",
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Search channels...",
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
          Expanded(
            child: StreamBuilder(
              stream: firebaseFirestore
                  .collection("channels")
                  .where("channelMembers", arrayContains: currentUser)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: AppTheme.loaderColor,
                      size: 40,
                    ),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  // Display a message when there are no channels.
                  return Center(
                    child: LottieBuilder.asset(
                      "assets/lottie/no_channels.json",
                      height: 150,
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //My chanels
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //   margin: const EdgeInsets.only(left: 8),
                      //   height: 32,
                      //   width: 100,
                      //   decoration: BoxDecoration(
                      //     color: const Color.fromARGB(255, 214, 227, 255),
                      //     borderRadius: BorderRadius.circular(6),
                      //   ),
                      //   child: Center(
                      //     child: Text(
                      //       "Following",
                      //       overflow: TextOverflow.ellipsis,
                      //       style: GoogleFonts.lato(
                      //         color: AppTheme.mainColor,
                      //         fontSize: 13,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          Map<String, dynamic> lastMessage =
                              snapshot.data!.docs[index]["lastMessage"];
                          int channelFollowers = (snapshot.data!.docs[index]
                                  ["channelMembers"] as List)
                              .length;
                          String followersText =
                              formatFollowers(channelFollowers);
                          String channelPhotoUrl =
                              snapshot.data!.docs[index]["channelPhotoUrl"];
                          String channelUid =
                              snapshot.data!.docs[index]["channelUid"];
                          String channelName =
                              snapshot.data!.docs[index]["channelName"];
                          bool isAdmin = snapshot.data!.docs[index]
                                  ["channelAdmin"] ==
                              currentUser;
                          bool isChannelVerified =
                              snapshot.data!.docs[index]["channelVerified"];
                          bool isMateFollwingChannel() {
                            List channelMembers = snapshot.data!.docs[index]
                                ["channelMembers"] as List;

                            if (channelMembers.contains(currentUser)) {
                              return true;
                            } else {
                              return false;
                            }
                          }

                          return ListTile(
                            onTap: () {
                              // Get.to(
                              //   () => ChannelRoomPage(
                              //     isAdmin: isAdmin,
                              //     isMateFllowing: isMateFollwingChannel(),
                              //     isChannelVerified: isChannelVerified,
                              //     channelName: channelName,
                              //     channelUid: channelUid,
                              //     channelPhotoUrl: channelPhotoUrl,
                              //     followersText: followersText,
                              //   ),
                              // );
                            },
                            title: Row(
                              children: [
                                Text(
                                  snapshot.data!.docs[index]["channelName"],
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                snapshot.data!.docs[index]["channelName"] ==
                                        "ChatMate Official"
                                    ? const Icon(
                                        Icons.verified,
                                        color: AppTheme.mainColor,
                                        size: 16,
                                      )
                                    : snapshot.data!.docs[index]
                                                ["channelVerified"] ==
                                            true
                                        ? const Icon(
                                            Icons.verified,
                                            color: AppTheme.mainColor,
                                            size: 16,
                                          )
                                        : const SizedBox(),
                              ],
                            ),
                            subtitle: snapshot.data!.docs[index]
                                        ["channelName"] ==
                                    "ChatMate Official"
                                ? Text(
                                    "Recieve latest updates & news",
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  )
                                : Text(
                                    lastMessage["messageText"],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(23),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: snapshot.data!.docs[index]
                                    ["channelPhotoUrl"],
                                height: 45,
                                width: 45,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 10),
          //Popular
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   margin: const EdgeInsets.only(left: 8),
          //   height: 32,
          //   width: 100,
          //   decoration: BoxDecoration(
          //     color: const Color.fromARGB(255, 214, 227, 255),
          //     borderRadius: BorderRadius.circular(6),
          //   ),
          //   child: Center(
          //     child: Text(
          //       "Popular",
          //       overflow: TextOverflow.ellipsis,
          //       style: GoogleFonts.lato(
          //         color: AppTheme.mainColor,
          //         fontSize: 13,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          // StreamBuilder(
          //   stream: firebaseFirestore.collection("channels").snapshots(),
          //   builder: (context, snapshot) {
          //     if (!snapshot.hasData) {
          //       return const SizedBox();
          //     } else if (snapshot.connectionState ==
          //         ConnectionState.waiting) {
          //       return const SizedBox();
          //     } else {
          //       List<QueryDocumentSnapshot> channels = snapshot.data!.docs;
          //       //Sort channels accroding the one which has more followers/ channelMembers

          //       channels.sort((a, b) {
          //         int membersA = (a["channelMembers"] as List).length;
          //         int membersB = (b["channelMembers"] as List).length;
          //         return membersB.compareTo(membersA);
          //       });

          //       return ListView.builder(
          //         itemCount: channels.length,
          //         shrinkWrap: true,
          //         physics: const ClampingScrollPhysics(),
          //         itemBuilder: (context, index) {
          //           int channelFollowers =
          //               (channels[index]["channelMembers"] as List).length;
          //           String followersText = formatFollowers(channelFollowers);
          //           String channelPhotoUrl =
          //               channels[index]["channelPhotoUrl"];
          //           String channelUid = channels[index]["channelUid"];
          //           String channelName = channels[index]["channelName"];
          //           bool isAdmin =
          //               channels[index]["channelAdmin"] == currentUser;
          //           bool isChannelVerified =
          //               channels[index]["channelVerified"];
          //           String channelAdmin = channels[index]["channelAdmin"];
          //           bool isMateFollwingChannel() {
          //             List channelMembers = snapshot.data!.docs[index]
          //                 ["channelMembers"] as List;

          //             if (channelMembers.contains(currentUser)) {
          //               return true;
          //             } else {
          //               return false;
          //             }
          //           }

          //           if (channelAdmin == currentUser) {
          //             // Hide the current user channels.
          //             return const SizedBox();
          //           }
          //           return ListTile(
          //             onTap: () {
          //               Get.to(
          //                 () => ChannelRoomPage(
          //                   isAdmin: isAdmin,
          //                   isMateFllowing: isMateFollwingChannel(),
          //                   isChannelVerified: isChannelVerified,
          //                   channelName: channelName,
          //                   channelUid: channelUid,
          //                   channelPhotoUrl: channelPhotoUrl,
          //                   followersText: followersText,
          //                 ),
          //                 transition: Transition.cupertino,
          //               );
          //             },
          //             title: Row(
          //               children: [
          //                 Text(
          //                   channels[index]["channelName"],
          //                   style: GoogleFonts.lato(
          //                     fontSize: 14,
          //                     color: Colors.black,
          //                   ),
          //                 ),
          //                 const SizedBox(width: 3),
          //                 channels[index]["channelName"] ==
          //                         "ChatMate Official"
          //                     ? const Icon(
          //                         Icons.verified,
          //                         color: AppTheme.mainColor,
          //                         size: 16,
          //                       )
          //                     : channels[index]["channelVerified"] == true
          //                         ? const Icon(
          //                             Icons.verified,
          //                             color: AppTheme.mainColor,
          //                             size: 16,
          //                           )
          //                         : const SizedBox(),
          //               ],
          //             ),
          //             subtitle: channels[index]["channelName"] ==
          //                     "ChatMate Official"
          //                 ? Text(
          //                     "Receive latest updates & news",
          //                     style: GoogleFonts.lato(
          //                       fontSize: 12,
          //                       color: Colors.black54,
          //                     ),
          //                   )
          //                 : Text(
          //                     followersText,
          //                     overflow: TextOverflow.ellipsis,
          //                     style: GoogleFonts.lato(
          //                       fontSize: 12,
          //                       color: Colors.black54,
          //                     ),
          //                   ),
          //             leading: ClipRRect(
          //               borderRadius: BorderRadius.circular(23),
          //               child: CachedNetworkImage(
          //                 fit: BoxFit.cover,
          //                 imageUrl: channels[index]["channelPhotoUrl"],
          //                 height: 45,
          //                 width: 45,
          //               ),
          //             ),
          //           );
          //         },
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }

  //Delete channel
  Future<void> deleteChannel(String channelIndex) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Delete Channel',
            style: GoogleFonts.lato(),
          ),
          content: Text(
            "Are you sure you want to delete this channel?, You won't be able to recover it mate!",
            style: GoogleFonts.lato(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Cancel',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: AppTheme.mainColorLight,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'Delete',
                style: GoogleFonts.lato(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                customLoader.showLoader(context);
                //Delete chat.
                channelsController.deleteChannel(
                  channelIndex: channelIndex,
                  customLoader: customLoader,
                );
                Get.snackbar(
                  "Successful!",
                  "Channel has been deleted successfully!",
                );
              },
            ),
          ],
        );
      },
    );
  }

  String formatFollowers(int followersCount) {
    if (followersCount >= 1000000) {
      double count = followersCount / 1000000;
      return '${count.toStringAsFixed(count.truncateToDouble() == count ? 0 : 1)}M followers';
    } else if (followersCount >= 1000) {
      double count = followersCount / 1000;
      return '${count.toStringAsFixed(count.truncateToDouble() == count ? 0 : 1)}K followers';
    } else if (followersCount == 1) {
      return '1 follower';
    } else {
      return '$followersCount followers';
    }
  }
}
