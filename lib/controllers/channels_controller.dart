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
  //Create Channel.
  void createChannel({
    required String channelName,
    required String channelTopic,
    required Uint8List imageFilePath,
    required List<String> channelMembers,
    required CustomLoader customLoader,
  }) async {
    String channelUid = const Uuid().v1();
    String channelPhotoUrl =
        await uploadImageToStorage(imageFilePath, "channelLogos");

    final channelModel = ChannelsModel(
      channelName: channelName,
      channelUid: channelUid,
      channelPhotoUrl: channelPhotoUrl,
      channelVerified: false,
      channelMembers: channelMembers,
      channelAdmin: auth.currentUser!.uid,
      channelTopic: channelTopic,
    );
    await firebaseFirestore
        .collection("channels")
        .doc(channelUid)
        .set(channelModel.toMap());
    customLoader.hideLoader();
    print("Channel id $channelUid has been created!");
  }

  //Join Channel.
  void joinChannel({required String channelUid}) async {
    await firebaseFirestore.collection("channels").doc(channelUid).update(
      {
        "channelMembers": [
          auth.currentUser!.uid,
        ],
      },
    );
  }

  //Upload channel logo/image
  Future<String> uploadImageToStorage(
    Uint8List imagefile,
    String childRef,
  ) async {
    // creating location to our firebase storage
    final String imageName = const Uuid().v1();
    Reference ref =
        firebaseStorage.ref("channels").child(childRef).child(imageName);
    UploadTask uploadTask = ref.putData(imagefile);
    TaskSnapshot snapshot = await uploadTask;
    //Getting downloadUrl.
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //Like Post in channel.
  //Turn on Noitifications for channel.
}
