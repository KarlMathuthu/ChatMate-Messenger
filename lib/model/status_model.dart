import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final String statusText;
  final Timestamp timeStamp;

  StatusModel({
    required this.statusText,
    required this.timeStamp,
  });
  factory StatusModel.fromMap(Map<String, dynamic> data) {
    final String statusText = data['statusText'];
    final Timestamp timeStamp = data['timeStamp'];

    return StatusModel(
      statusText: statusText,
      timeStamp: timeStamp,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'statusText': statusText,
      'timeStamp': timeStamp,
    };
  }
}
