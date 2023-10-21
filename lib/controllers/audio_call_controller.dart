import 'package:chat_mate_messanger/views/calls/voice_call_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AudioCallHandler {
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;

  // Initialize the WebRTC peer connection
  Future<void> initializePeerConnection() async {
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    };

    peerConnection = await createPeerConnection(configuration, {});
  }

  // Initialize a local stream (microphone audio)
  Future<void> initializeLocalStream() async {
    localStream = await navigator.mediaDevices.getUserMedia(
      {
        'video': false,
        'audio': true,
      },
    );
    peerConnection!.addStream(localStream!);
  }

  // Initialize a collection in Firestore to store call information
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection('calls');

  // Function to initiate a call
  Future<void> makeCall(String toUserId) async {
    // Initialize the WebRTC peer connection here before creating an offer
    await initializePeerConnection();
    // Create an offer
    final offer = await peerConnection!.createOffer(
      {
        'offerToReceiveAudio': 1,
      },
    );
    await peerConnection!.setLocalDescription(offer);

    // Store the offer in Firestore
    await callCollection.doc(toUserId).set(
      {
        'offer': offer.toMap(),
      },
    );

    // Listen for the answer in Firestore
    callCollection.doc(toUserId).snapshots().listen(
      (snapshot) async {
        if (snapshot.exists) {
          final answer = snapshot['answer'];
          await peerConnection!.setRemoteDescription(
            RTCSessionDescription(answer, 'answer'),
          );
        }
      },
    );
  }

  // Function to answer an incoming call
  Future<void> answerCall(String fromUserId) async {
    // Initialize the WebRTC peer connection here before answering the call
    await initializePeerConnection();
    final offer = await callCollection.doc(fromUserId).get();
    if (offer.exists) {
      final remoteOffer = RTCSessionDescription(offer['offer'], 'offer');
      await peerConnection!.setRemoteDescription(remoteOffer);

      // Create an answer
      final answer = await peerConnection!.createAnswer({});
      await peerConnection!.setLocalDescription(answer);

      // Store the answer in Firestore
      await callCollection.doc(fromUserId).set(
        {
          'answer': answer.toMap(),
        },
      );
    }
  }

  // Function to end a call
  Future<void> endCall() async {
    await peerConnection?.close();
    localStream?.getTracks().forEach((track) => track.stop());
  }

  // Listen for incoming calls and navigate to CallPage
  void listenForIncomingCalls(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final callCollection = FirebaseFirestore.instance.collection('calls');
    callCollection.doc(currentUserId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        // An incoming call is detected, navigate to the CallPage
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
