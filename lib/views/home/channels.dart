import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_mate_messanger/controllers/channels_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/views/channels/create_channel.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
              //Create channel
              Get.to(
                () => const CreateChannelPage(),
                transition: Transition.cupertino,
              );
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
                  "Create Channel",
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
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
            //My chanels
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              margin: const EdgeInsets.only(left: 8),
              height: 32,
              width: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 227, 255),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Following",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: AppTheme.mainColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: firebaseFirestore
                  .collection("channels")
                  .where("channelMembers", arrayContains: currentUser)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox();
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> lastMessage =
                          snapshot.data!.docs[index]["lastMessage"];
                      return ListTile(
                        onTap: () {},
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
                        subtitle: snapshot.data!.docs[index]["channelName"] ==
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
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            //All channels
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              margin: const EdgeInsets.only(left: 8),
              height: 32,
              width: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 214, 227, 255),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  "Popular",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: AppTheme.mainColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
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
}
