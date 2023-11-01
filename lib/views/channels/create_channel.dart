import 'dart:typed_data';

import 'package:chat_mate_messanger/controllers/channels_controller.dart';
import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/utils/constants.dart';
import 'package:chat_mate_messanger/utils/custom_icons.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/chip_list.dart';
import '../../widgets/image_picker.dart';

class CreateChannelPage extends StatefulWidget {
  const CreateChannelPage({super.key});

  @override
  State<CreateChannelPage> createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  List<String> topicsList = [
    "Anime",
    "Movies",
    "Cartoons",
    "MSA",
    "Random Chat",
    "Attack on Titan",
    "Dating",
    "School",
    "Studies",
    "Business",
    "Crypto",
    "Programming",
    "Developers",
    "Donations",
    "Indian Movies",
    "Bundocks",
    "Movies",
    "Random Mates",
    "TikTok Links",
    "News",
  ];
  int selectedTopic = 0;
  Uint8List? selectedImage;
  TextEditingController channelNameController = TextEditingController();
  ChannelsController channelsController = Get.put(ChannelsController());
  FocusNode channelNameNode = FocusNode();
  CustomLoader customLoader = CustomLoader();

  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  pickImage() async {
    Uint8List? im = await getPickedImage(ImageSource.gallery);
    setState(() {
      selectedImage = im;
    });
  }

  @override
  void dispose() {
    channelNameController.dispose();
    channelNameNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: channelNameNode.unfocus,
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: AppTheme.scaffoldBacgroundColor,
          title: Text(
            "Create Channel",
            style: GoogleFonts.lato(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                channelNameNode.hasFocus ? channelNameNode.unfocus() : null;
                //Create channel
                if (selectedImage == null) {
                  Get.snackbar("Warning", "Select image mate!");
                } else if (channelNameController.text.trim().isEmpty) {
                  Get.snackbar("Warning", "Put channel name mate!");
                } else {
                  //show note dialog
                  createChannel();
                }
              },
              icon: const Icon(
                Icons.done,
                color: AppTheme.mainColor,
              ),
            ),
          ],
        ),
        body: Container(
          color: AppTheme.scaffoldBacgroundColor,
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(top: 0.8),
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Pick Picture & TextField.
                Row(
                  children: [
                    selectedImage != null
                        ? GestureDetector(
                            onTap: () => pickImage(),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: AppTheme.mainColor,
                              backgroundImage: MemoryImage(selectedImage!),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => pickImage(),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: AppTheme.mainColor,
                              child: Center(
                                child: SvgPicture.asset(
                                  CustomIcons.camera,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        cursorColor: AppTheme.mainColor,
                        focusNode: channelNameNode,
                        controller: channelNameController,
                        style: GoogleFonts.lato(fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: "Channel name",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.mainColor),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(CustomIcons.emoji),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                //Topics
                Text(
                  "Choose Channel Topic",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),

                ChipList(
                  listOfChipNames: topicsList,
                  activeBgColorList: const [AppTheme.mainColor],
                  inactiveBgColorList: const [Colors.white],
                  activeTextColorList: const [Colors.white],
                  inactiveTextColorList: const [AppTheme.mainColor],
                  listOfChipIndicesCurrentlySeclected: [selectedTopic],
                  activeBorderColorList: const [AppTheme.mainColor],
                  inactiveBorderColorList: const [AppTheme.mainColor],
                  shouldWrap: true,
                  style: GoogleFonts.lato(fontSize: 13),
                  supportsMultiSelect: false,
                  wrapAlignment: WrapAlignment.start,
                  borderRadiiList: const [20],
                  extraOnToggle: (index) {
                    selectedTopic = index;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Create channel
  void createChannel() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            "Notice Mate!",
            style: GoogleFonts.lato(),
          ),
          content: Text(
            AppConstants.createChannelDescription,
            style: GoogleFonts.lato(),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                "Cancel",
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
                "Continue",
                style: GoogleFonts.lato(
                  color: AppTheme.mainColor,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                customLoader.showLoader(context);
                channelsController.createChannel(
                  channelName: channelNameController.text.trim(),
                  channelTopic: topicsList[selectedTopic],
                  imageFilePath: selectedImage!,
                  channelMembers: [
                    currentUserUid,
                  ],
                  customLoader: customLoader,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
