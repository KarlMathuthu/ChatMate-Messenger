import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../views/calls/voice_call_page.dart';

// Callback to notify when a remote stream is added
typedef StreamStateCallback = void Function(MediaStream stream);

class CallSignaling {
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
  String? callId;
  String? currentCallStatus;
  StreamStateCallback? onAddRemoteStream;

  // Function to start a call
  Future<String> startCall(
      RTCVideoRenderer remoteRenderer, String toUid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference callRef = db.collection('calls').doc("KarlMathuthu");

    print('Initializing PeerConnection with configuration: $configuration');

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Code for collecting ICE candidates below
    var callerCandidatesCollection = callRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      print('Generated candidate: ${candidate.toMap()}');
      callerCandidatesCollection.add(candidate.toMap());
    };
    // Finish Code for collecting ICE candidates

    // Add code for creating a call
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('Created call offer: $offer');

    Map<String, dynamic> callWithOffer = {
      'offer': offer.toMap(),
      'status': 'waiting', // Set the status to "waiting"
      'toUid': toUid,
    };

    await callRef.set(callWithOffer);
    var callId = callRef.id;
    print('New call created with an offer. Call ID: $callId');
    currentCallStatus = 'You are in a call with ID $callId';

    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Received remote track: ${event.streams[0]}');

      event.streams[0].getTracks().forEach((track) {
        print('Adding a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };

    // Listening for remote session description below
    callRef.snapshots().listen((snapshot) async {
      print('Received updated call: ${snapshot.data()}');

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        print("Another participant joined the call");
        await peerConnection?.setRemoteDescription(answer);
      }
    });
    // Listening for remote session description above

    // Listen for remote ICE candidates below
    callRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          print('Received new remote ICE candidate: ${jsonEncode(data)}');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    });

    return callId;
  }

  // Function to answer an incoming call
  Future<void> answerCall(RTCVideoRenderer remoteVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String currentUser = FirebaseAuth.instance.currentUser!.uid;

    // Get the most recent call that is waiting to be answered
    QuerySnapshot callQuery = await db
        .collection('calls')
        /* .where(
          'status',
          isEqualTo: 'waiting',
        ) */
        .where(
          "toUid",
          isEqualTo: currentUser,
        )
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (callQuery.docs.isNotEmpty) {
      DocumentSnapshot callDoc = callQuery.docs.first;
      callId = callDoc.id;

      // Update the call status to 'answered' to prevent others from answering it
      await callDoc.reference.update(
        {
          'status': 'answered',
        },
      );

      // Initialize the peer connection
      peerConnection = await createPeerConnection(configuration);
      registerPeerConnectionListeners();
      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection =
          callDoc.reference.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          print('ICE candidate gathering completed!');
          return;
        }
        print('Gathered ICE candidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidates above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Received remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          print('Adding a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = callDoc.data() as Map<String, dynamic>;
      print('Received offer $data');
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(
          offer['sdp'],
          offer['type'],
        ),
      );
      var answer = await peerConnection!.createAnswer();
      print('Created Answer $answer');
      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> callWithAnswer = {
        'answer': {
          'type': answer.type,
          'sdp': answer.sdp,
        }
      };

      await callDoc.reference.update(callWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      callDoc.reference
          .collection('callerCandidates')
          .snapshots()
          .listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
          print('Received new remote ICE candidate: $data');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    } else {
      print('No incoming calls to answer.');
    }
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    print(roomId);
    DocumentReference roomRef = db.collection('calls').doc(roomId);
    var roomSnapshot = await roomRef.get();
    print('Got Call ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          print('onIceCandidate: complete!');
          return;
        }
        print('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      print('Got offer $data');
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();
      print('Created Answer $answer');

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {
          'type': answer.type,
          'sdp': answer.sdp,
        }
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
          print('Got new remote ICE candidate: $data');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
  }

  // Function to open user media (camera and microphone)
  Future<void> openUserMedia(
    RTCVideoRenderer localVideo,
    RTCVideoRenderer remoteVideo,
  ) async {
    var stream = await navigator.mediaDevices.getUserMedia(
      {
        'video': true,
        'audio': true,
      },
    );

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  // Function to end a call
  Future<void> endCall(RTCVideoRenderer localVideo) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    tracks.forEach((track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    if (callId != null) {
      var db = FirebaseFirestore.instance;
      var callRef = db.collection('calls').doc(callId);
      var calleeCandidates = await callRef.collection('calleeCandidates').get();
      calleeCandidates.docs.forEach((document) => document.reference.delete());

      var callerCandidates = await callRef.collection('callerCandidates').get();
      callerCandidates.docs.forEach((document) => document.reference.delete());

      await callRef.delete();
    }

    localStream!.dispose();
    remoteStream?.dispose();
  }

  // Function to register peer connection listeners
  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Remote stream added");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }

  // Function to listen for incoming calls
  void listenForIncomingCalls(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;

    // Listen for incoming calls where status is "waiting" and toUid matches the currentUser
    db
        .collection('calls')
        .where('status', isEqualTo: 'waiting')
        .where('toUid', isEqualTo: currentUser)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        String callId = doc.id;

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const VoiceCallPage(),
          ),
        );
      }
    });
  }
}
