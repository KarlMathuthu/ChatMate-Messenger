import 'dart:io';

import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';
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
  void printSelectedItems() {
    for (int index in selectedTopics) {
      print(topicsList[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => printSelectedItems(),
      child: Scaffold(
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
                    // Continue sign-up.
                    customLoader.showLoader(context);
                    authController.createAccount(
                      email: widget.email,
                      password: widget.password,
                      userName: widget.userName,
                      customLoader: customLoader,
                    );
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
      ),
    );
  }
}
