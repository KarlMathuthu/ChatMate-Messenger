class MessageModel {
  final String sender;
  final String messageText;
  final int timestamp;
  bool read;

  MessageModel({
    required this.sender,
    required this.messageText,
    required this.timestamp,
    this.read = false, // Default to unread
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'messageText': messageText,
      'timestamp': timestamp,
      'read': read,
    };
  }
}
