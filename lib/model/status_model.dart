class StatusModel {
  final String text;
  final String timestamp;

  StatusModel({
    required this.text,
    required this.timestamp,
  });

  factory StatusModel.fromMap(Map<String, dynamic> data) {
    final String text = data['text'];
    final String timestamp = data['timestamp'];

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
