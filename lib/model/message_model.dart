class MessageModel {
  final String sender;
  final String messageText;
  final int timestamp;
  bool read;
  final String messageType;

  MessageModel({
    required this.sender,
    required this.messageText,
    required this.timestamp,
    this.read = false,
    required this.messageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'messageText': messageText,
      'timestamp': timestamp,
      'read': read,
      'messageType': messageType,
    };
  }
}
