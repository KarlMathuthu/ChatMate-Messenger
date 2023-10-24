import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final String text;
  final Timestamp timestamp;

  StatusModel({
    required this.text,
    required this.timestamp,
  });

  factory StatusModel.fromMap(Map<String, dynamic> data) {
    final String text = data['text'];
    final Timestamp timestamp = data['timestamp'];

    return StatusModel(
      text: text,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': timestamp,
    };
  }
}
