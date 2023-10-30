import 'package:chat_mate_messanger/model/channels_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChannelsController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //Create Channel.
  void createChannel() async {
    String channelUid = const Uuid().v1();
    final channelModel = ChannelsModel(
      channelName: "ChatMate Official",
      channelUid: channelUid,
      channelPhotoUrl:
          "https://firebasestorage.googleapis.com/v0/b/chat-mate-messenger.appspot.com/o/ChatMate%20-%20Messenger%2FappLogo.png?alt=media&token=b9eba7a9-3c6d-413e-a6d1-2f9a67783039&_gl=1*kr6dx6*_ga*MTAxMTI2My4xNjg4NTQ2ODU3*_ga_CW55HF8NVT*MTY5ODY2ODM2My4yNzMuMS4xNjk4NjY4NDIwLjMuMC4w",
      channelVerified: true,
      channelMembers: [
        auth.currentUser!.uid,
      ],
      channelAdmin: "chatMate",
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
