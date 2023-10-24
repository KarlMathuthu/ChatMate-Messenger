import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final String text;
  final Timestamp timestamp;
  final String userName;

  StatusModel({
    required this.text,
    required this.timestamp,
    required this.userName,
  });

  factory StatusModel.fromMap(Map<String, dynamic> data) {
    final String text = data['text'];
    final Timestamp timestamp = data['timestamp'];
    final String userName = data["userName"];

    return StatusModel(
      text: text,
      timestamp: timestamp,
      userName: userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': timestamp,
      'userName': userName,
    };
  }
}
