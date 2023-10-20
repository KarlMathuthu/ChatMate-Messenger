import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AudioCallHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize the WebRTC peer connection
  RTCPeerConnection? _peerConnection;

  // Initialize a local stream
  MediaStream? _localStream;

  // Initialize the remote stream
  MediaStream? _remoteStream;

  // Initialize a collection in Firestore to store call information
  final CollectionReference _callCollection = FirebaseFirestore.instance.collection('calls');

  // Function to initiate a call
  Future<void> makeCall(String callerUid, String receiverUid) async {
    // Create an offer
    _peerConnection = await createPeerConnection();

    // Add a local stream (your microphone audio)
    _localStream = await createStream();
    _peerConnection?.addStream(_localStream!);

    // Create an offer
    RTCSessionDescription offer = await _peerConnection?.createOffer();

    // Set the local description
    await _peerConnection?.setLocalDescription(offer);

    // Store the offer in Firestore
    await _callCollection.doc(callerUid).set({'offer': offer.sdp});

    // Listen for the answer in Firestore
    _callCollection.doc(receiverUid).snapshots().listen((event) async {
      final data = event.data() as Map<String, dynamic>;
      final answer = RTCSessionDescription(data['answer'], 'answer');
      await _peerConnection?.setRemoteDescription(answer);
    });
  }

  // Function to answer an incoming call
  Future<void> answerCall(String callerUid, String receiverUid) async {
    // Create an answer
    _peerConnection = await createPeerConnection();

    // Add a local stream (your microphone audio)
    _localStream = await createStream();
    _peerConnection?.addStream(_localStream!);

    // Listen for the offer in Firestore
    _callCollection.doc(callerUid).snapshots().listen((event) async {
      final data = event.data() as Map<String, dynamic>;
      final offer = RTCSessionDescription(data['offer'], 'offer');
      await _peerConnection?.setRemoteDescription(offer);

      // Create an answer
      RTCSessionDescription answer = await _peerConnection?.createAnswer();

      // Set the local description
      await _peerConnection?.setLocalDescription(answer);

      // Store the answer in Firestore
      await _callCollection.doc(receiverUid).set({'answer': answer.sdp});
    });
  }

  // Function to end a call
  Future<void> endCall() async {
    _peerConnection?.close();
    _localStream?.getTracks().forEach((track) => track.stop());
  }
}
