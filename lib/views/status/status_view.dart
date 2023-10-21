import 'package:flutter/material.dart';
import 'package:flutter_story_view/flutter_story_view.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:flutter_story_view/models/user_info.dart';
import 'package:get/get.dart';

class StatusViewPage extends StatelessWidget {
  const StatusViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterStoryView(
        storyItems: const [
          // StoryItem (image) loaded from url
          StoryItem(
            url:
                "https://plus.unsplash.com/premium_photo-1669741908308-5ca216f3fcd1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1469&q=80",
            type: StoryItemType.image,
            viewers: [],
            duration: 5,
          ),
          // StoryItem (image) loaded from url
          StoryItem(
            url:
                "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
            type: StoryItemType.image,
            viewers: [],
            duration: 5,
          ),
        ],
        onComplete: () {
          print("Completed");
          Get.back();
        },
        onPageChanged: (index) {
          print("currentPageIndex = $index");
        },
        caption: "This is very beautiful STORY",
        createdAt: DateTime.now(),
        enableOnHoldHide: false,
        indicatorColor: Colors.grey[500],
        indicatorHeight: 2,
        indicatorValueColor: Colors.white,
        userInfo: UserInfo(
            username: "Username", // give your username
            profileUrl:
                "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80" // give your profile url
            ),
      ),
    );
  }
}
