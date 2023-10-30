import 'package:chat_mate_messanger/model/channels_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChannelsController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //Create Channel.
  void createChannel({
    required String channelPhotoUrl,
    required String channelName,
    required List<String> channelMembers,
  }) async {
    String channelUid = const Uuid().v1();
    final channelModel = ChannelsModel(
      channelName: channelName,
      channelUid: channelUid,
      channelPhotoUrl: channelPhotoUrl,
      channelVerified: false,
      channelMembers: channelMembers,
      channelAdmin: auth.currentUser!.uid,
    );
    await firebaseFirestore
        .collection("channels")
        .doc(channelUid)
        .set(channelModel.toMap());
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

  //Like Post in channel.
  //Turn on Noitifications for channel.
}
