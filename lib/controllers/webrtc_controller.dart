import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

final _roomRef = FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('Room')
    .doc();

class WebRTCController extends GetxController {
  //createOffer/ Create Call
  void createOffer(RTCPeerConnection? peerConnection, String mateUid) async {
    print('this is creating offer');
    var roomId = _roomRef.id;
    docID = roomId;
    final contactRef = FirebaseFirestore.instance
        .collection('users')
        .doc(mateUid)
        .collection('Room')
        .doc(roomId);
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
    Map<String, dynamic> offerSdpConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': []
    };
    peerConnection =
        await createPeerConnection(configuration, offerSdpConstraints);

    peerConnection.addStream(_localStream!);

    _localStream!.getTracks().forEach(
          (track) => peerConnection!.addTrack(track, _localStream!),
        );

    print(
        'this is offer local streams lenght : ${peerConnection!.getLocalStreams().length}');

    // registerPeerConnectionListeners();
    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('this offer Connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("this offer Add remote stream");
      // onAddRemoteStream?.call(stream);
      _remoteStream = stream;
      _remoteVideoRenderer.srcObject = _remoteStream;
      print(
          'this is offer remote  streams on addStream lenght : ${peerConnection!.getRemoteStreams().length}');
    };

    peerConnection!.onIceCandidate = (RTCIceCandidate candidate) async {
      if (candidate.candidate != null) {
        /// PROBABLY SHOULD UPLOAD THIS TO FIREBASE
        final ref = await _roomRef
            .collection('callerCandidates')
            .add(candidate.toMap());
        // _contactRef.collection('callerCandidates').add(candidate.toMap());
        await contactRef
            .collection('callerCandidates')
            .doc(ref.id)
            .set(candidate.toMap());
        // showing it locally
        /* print(
          'this is offer candidate${json.encode({
                'candidate': candidate.candidate,
                'sdpMid': candidate.sdpMid,
                'sdpMlineIndex': candidate.sdpMLineIndex
              })}',
        ); */
      }
    };

    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('this Create Offer $offer');
    await _roomRef.set({'offer': offer.toMap()});
    await contactRef.set({'offer': offer.toMap()});
    await _roomRef
        .update({'offerFrom': FirebaseAuth.instance.currentUser!.uid});
    await contactRef
        .update({'offerFrom': FirebaseAuth.instance.currentUser!.uid});
    await _roomRef.update({'roomId': _roomRef.id});
    await contactRef.update({'roomId': _roomRef.id});

    print("this NEW ROOM CREATED WITH SDP OFFER ROOMID : $roomId");

    /// Tracks
    peerConnection!.onTrack = (RTCTrackEvent event) {
      print('this offer Got remote track : ${event.streams[0]}');

      event.streams[0].getTracks().forEach((element) {
        print('this add a track to the remoteStream $element');
        _remoteStream!.addTrack(element);
      });
    };

    /// setting up  a listener for remote sdp
    /// i really dont lnow if we should do the below for contacts also
    _roomRef.snapshots().listen((snapShot) async {
      print('this offer  Got updated room: ${snapShot.data()}');
      Map<String, dynamic> data = snapShot.data() as Map<String, dynamic>;
      if (data['answer'] != null) {
        var answer = RTCSessionDescription(
            data['answer']['sdp'], data['answer']['type']);
        print('this offer someone tried to connect');

        await peerConnection!.setRemoteDescription(answer);
      }
    });

    /// listening on remote ICE candidates
    _roomRef.collection('calleeCandidates').snapshots().listen((snapShot) {
      snapShot.docs.forEach((element) {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        print('this offer Got New Remote Ice Candidate ${jsonEncode(data)}');
        var remoteCandidate = RTCIceCandidate(
            data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
        peerConnection!.addCandidate(remoteCandidate);
      });
      // snapShot.docChanges.forEach((element) {
      //   if (element.type == DocumentChangeType.added) {
      //     Map<String, dynamic> data =
      //         element.doc.data() as Map<String, dynamic>;
      //     print('Got New Remote Ice Candidate ${jsonEncode(data)}');
      //     var remoteCandidate = RTCIceCandidate(
      //         data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
      //     peerConnection!.addCandidate(remoteCandidate);
      //   }
      // });
    });
  }
}
