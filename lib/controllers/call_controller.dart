import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class CallController {
  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;
  //Create Call.
  Future<String> createCallRoom({
    RTCVideoRenderer? remoteRenderer,
    required String mateUid,
    required String callType,
    required CustomLoader customLoader,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('callRooms').doc();
    // String currentUser = FirebaseAuth.instance.currentUser!.uid;

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      callerCandidatesCollection.add(candidate.toMap());
    };

    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    Map<String, dynamic> roomWithOffer = {
      'offer': offer.toMap(),
    };

    await roomRef.set(roomWithOffer);
    var roomId = roomRef.id;
    currentRoomText = 'Current room is $roomId - You are the caller!';
    // Send a call invitation to friend chat room.

    // String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    // await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(mateUid)
    //     .collection("calls")
    //     .doc(mateUid)
    //     .set(
    //   {
    //     "calleeUid": currentUserUid,
    //     "callRoomId": roomId,
    //     "callType": callType,
    //     "time": DateTime.now(),
    //     "callState": "dialing",
    //   },
    // );

    peerConnection?.onTrack = (RTCTrackEvent event) {
      event.streams[0].getTracks().forEach((track) {
        remoteStream?.addTrack(track);
      });
    };

    roomRef.snapshots().listen((snapshot) async {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        await peerConnection?.setRemoteDescription(answer);
      }
    });

    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      }
    });

    return roomId;
  }

  //Join Call.
  Future<void> joinCallRoom(
      String roomId, RTCVideoRenderer? remoteVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('callRooms').doc(roomId);
    var roomSnapshot = await roomRef.get();

    if (roomSnapshot.exists) {
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          return;
        }
        calleeCandidatesCollection.add(candidate.toMap());
      };

      peerConnection?.onTrack = (RTCTrackEvent event) {
        event.streams[0].getTracks().forEach((track) {
          remoteStream?.addTrack(track);
        });
      };

      var data = roomSnapshot.data() as Map<String, dynamic>;
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {
          'type': answer.type,
          'sdp': answer.sdp,
        }
      };

      await roomRef.update(roomWithAnswer);

      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        for (var document in snapshot.docChanges) {
          var data = document.doc.data() as Map<String, dynamic>;
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    }
  }

  // Open Media
  Future<void> openUserMedia(
    RTCVideoRenderer? localVideo,
    RTCVideoRenderer? remoteVideo,
    String callType,
  ) async {
    var stream = await navigator.mediaDevices.getUserMedia(
      {
        'video': callType == "video" ? true : false,
        'audio': callType == "audio" ? true : false,
      },
    );

    localVideo?.srcObject = stream;
    localStream = stream;

    remoteVideo?.srcObject = await createLocalMediaStream('key');
  }

  // Register PeerConnection Listeners

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {};

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {};

    peerConnection?.onSignalingState = (RTCSignalingState state) {};

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {};

    peerConnection?.onAddStream = (MediaStream stream) {
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }

  // Close call.
  Future<void> closeCall(
      RTCVideoRenderer localVideo, CustomLoader customLoader) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    for (var track in tracks) {
      track.stop();
    }

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    if (roomId != null) {
      var db = FirebaseFirestore.instance;
      var roomRef = db.collection('callRooms').doc(roomId);
      var calleeCandidates = await roomRef.collection('calleeCandidates').get();
      for (var document in calleeCandidates.docs) {
        document.reference.delete();
      }

      var callerCandidates = await roomRef.collection('callerCandidates').get();
      for (var document in callerCandidates.docs) {
        document.reference.delete();
      }

      await roomRef.delete();
      customLoader.hideLoader();
    }

    localStream!.dispose();
    remoteStream?.dispose();
  }

  // Add call history to all mates.
  Future<void> addCallHistory(
    String callRoomId,
    String mateUid,
    String callerUid,
    CustomLoader customLoader,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String dbRef = "users";

    // Set the call history to current user.
    await firestore
        .collection(dbRef)
        .doc(currentUserUid)
        .collection("calls")
        .doc(callRoomId)
        .set(
      {
        "caller": callerUid,
        "time": DateTime.now().toString(),
      },
    );
    // Set the call history to mateUid.
    await firestore
        .collection(dbRef)
        .doc(mateUid)
        .collection("calls")
        .doc(callRoomId)
        .set(
      {
        "caller": callerUid,
        "time": DateTime.now().toString(),
      },
    );
    // Hide loader
    customLoader.hideLoader();
  }

  // clear history.
  Future<void> clearCallHistory(CustomLoader customLoader) async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String dbRef = "users";

    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection(dbRef)
        .doc(currentUserUid)
        .collection("calls");

    QuerySnapshot querySnapshot = await collectionRef.get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    customLoader.hideLoader();
  }
}
