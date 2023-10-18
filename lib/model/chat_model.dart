class ChatModel {
  final String message;
  final String date;
  final bool isSeen;
  final String from;
  final String to;

  ChatModel({
    required this.message,
    required this.date,
    required this.isSeen,
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'date': date,
      'isSeen': isSeen,
      'from': from,
      'to': to,
    };
  }
}
