class ChatModel {
  final String chatUid;
  final String username;
  final Map<String, dynamic> lastMessage;

  ChatModel({
    required this.chatUid,
    required this.username,
    required this.lastMessage,
  });
}
