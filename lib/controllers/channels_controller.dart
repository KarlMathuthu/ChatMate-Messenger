import 'dart:typed_data';

import 'package:chat_mate_messanger/model/channels_model.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChannelsController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  void createChannel({
    required String channelName,
    required String channelTopic,
    required Uint8List imageFilePath,
    required List<String> channelMembers,
    required CustomLoader customLoader,
  }) async {
    String channelUid = const Uuid().v1();
    Map<String, dynamic> lastMessage = {
      "messageText": "$channelName was created",
      "timestamp": DateTime.now().toString(),
      "type": "text",
    };
    String channelPhotoUrl =
        await uploadImageToStorage(imageFilePath, channelUid);

    final channelModel = ChannelsModel(
      channelName: channelName,
      channelUid: channelUid,
      channelPhotoUrl: channelPhotoUrl,
      channelVerified: false,
      channelMembers: channelMembers,
      channelAdmin: auth.currentUser!.uid,
      channelTopic: channelTopic,
      createDate: DateTime.now().toString(),
      lastMessage: lastMessage,
    );
    await firebaseFirestore
        .collection("channels")
        .doc(channelUid)
        .set(channelModel.toMap());
    customLoader.hideLoader();
    Get.back();
    print("Channel id $channelUid has been created!");
  }

  Future<void> unfollowChannel(
    String channelUid,
    CustomLoader customLoader,
  ) async {
    try {
      final currentUserUid = auth.currentUser!.uid;

      final channelDoc =
          await firebaseFirestore.collection("channels").doc(channelUid).get();

      if (channelDoc.exists) {
        final Map<String, dynamic> channelData =
            channelDoc.data() as Map<String, dynamic>;
        List<String> channelMembers =
            List<String>.from(channelData["channelMembers"]);

        if (channelMembers.contains(currentUserUid)) {
          channelMembers.remove(currentUserUid);

          await firebaseFirestore
              .collection("channels")
              .doc(channelUid)
              .update({
            "channelMembers": channelMembers,
          });
          print("You have unfollowed the channel.");
          customLoader.hideLoader();
          Get.back();
        } else {
          print("You are not a member of this channel.");
        }
      } else {
        print("Channel not found.");
      }
    } catch (e) {
      print("Error unfollowing the channel: $e");
    }
  }

  Future<void> followChannel(String channelUid) async {
    try {
      final currentUserUid = auth.currentUser!.uid;

      final channelDoc =
          await firebaseFirestore.collection("channels").doc(channelUid).get();

      if (channelDoc.exists) {
        final Map<String, dynamic> channelData =
            channelDoc.data() as Map<String, dynamic>;
        List<String> channelMembers =
            List<String>.from(channelData["channelMembers"]);

        if (!channelMembers.contains(currentUserUid)) {
          channelMembers.add(currentUserUid);

          await firebaseFirestore
              .collection("channels")
              .doc(channelUid)
              .update({
            "channelMembers": channelMembers,
          });
          print("You have joined the channel.");
        } else {
          print("You are already a member of this channel.");
        }
      } else {
        print("Channel not found.");
      }
    } catch (e) {
      print("Error joining the channel: $e");
    }
  }

  void deleteChannel({
    required String channelIndex,
    required CustomLoader customLoader,
  }) async {
    await firebaseStorage.ref("channelLogos").child(channelIndex).delete();
    await firebaseFirestore.collection("channels").doc(channelIndex).delete();
    customLoader.hideLoader();
  }

  Future<String> uploadImageToStorage(
    Uint8List imagefile,
    String imageName,
  ) async {
    Reference ref = firebaseStorage.ref("channelLogos").child(imageName);
    UploadTask uploadTask = ref.putData(imagefile);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
