
class StatusModel {
  final String text;
  final String timestamp;
  final String userName;

  StatusModel({
    required this.text,
    required this.timestamp,
    required this.userName,
  });

  factory StatusModel.fromMap(Map<String, dynamic> data) {
    final String text = data['text'];
    final String timestamp = data['timestamp'];
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
