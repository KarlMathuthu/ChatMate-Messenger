import 'dart:io';

import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/constants.dart';
import '../../widgets/chip_list.dart';
import '../../widgets/custom_loader.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({
    super.key,
    required this.email,
    required this.password,
    required this.userName,
  });
  final String email;
  final String password;
  final String userName;

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  CustomLoader customLoader = CustomLoader();
  AuthController authController = Get.put(AuthController());
  List<String> topicsList = [
    "Anime",
    "Movies",
    "Cartoons",
    "Comics",
    "Manga",
    "Novels",
    "Poetry",
    "Stories",
    "Animation",
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
  List<int> selectedTopics = [];

  void continueSignup(List<int> selectedIndices) {
    List<String> userTopics = [];
    for (int index in selectedIndices) {
      userTopics.add(topicsList[index]);
    }
    customLoader.showLoader(context);
    authController.createAccount(
      email: widget.email,
      password: widget.password,
      userName: widget.userName,
      customLoader: customLoader,
      userTopics: userTopics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBacgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppTheme.scaffoldBacgroundColor,
        title: Text(
          "Choose your interests mate!",
          style: GoogleFonts.lato(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ChipList(
            listOfChipNames: topicsList,
            activeBgColorList: const [AppTheme.mainColor],
            inactiveBgColorList: const [Colors.white],
            activeTextColorList: const [Colors.white],
            inactiveTextColorList: const [AppTheme.mainColor],
            listOfChipIndicesCurrentlySeclected: selectedTopics,
            activeBorderColorList: const [AppTheme.mainColor],
            inactiveBorderColorList: const [AppTheme.mainColor],
            shouldWrap: true,
            style: GoogleFonts.lato(fontSize: 13),
            supportsMultiSelect: true,
            wrapAlignment: WrapAlignment.start,
            borderRadiiList: const [20],
          ),
          const Expanded(child: Column()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.mainColor,
                onPressed: () {
                  if (selectedTopics.isEmpty) {
                    Get.snackbar("Error", "Select one topic mate!");
                  } else {
                    createAccountDialog([""]);
                  }
                },
                child: Text(
                  "Create Account",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  //Create account dialog.
  void createAccountDialog(List<String> userTopics) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext __) {
        return CupertinoAlertDialog(
          title: Text(
            "Create Account?",
            style: GoogleFonts.lato(),
          ),
          content: Text(
            AppConstants.createAccountDescritpion,
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
                Navigator.of(__).pop();
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
                Navigator.of(__).pop();
                // Continue sign-up.
                // customLoader.showLoader(context);
                // authController.createAccount(
                //   email: widget.email,
                //   password: widget.password,
                //   userName: widget.userName,
                //   customLoader: customLoader,
                //   userTopics: ,
                // );
                continueSignup(selectedTopics);
              },
            ),
          ],
        );
      },
    );
  }
}
