import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/chat_model.dart';
import '../model/message_model.dart';

class ChatController extends GetxController {
  //create chat
  Future<void> createChat({
    required List<String> members,
    required String senderId,
    required String messageText,
  }) async {
    try {
      String chatRoomId = const Uuid().v1();
      // Create a new chat model
      final ChatModel newChat = ChatModel(
        chatId: chatRoomId,
        members: members,
        messages: [
          MessageModel(
            sender: senderId,
            messageText: messageText,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          )
        ],
      );

      // Push the new chat to the database
      final DatabaseReference chatRef =
          FirebaseDatabase.instance.ref().child('chats').push();
      newChat.chatId = chatRef.key!;
      chatRef.set(newChat.toMap());

      // Update the user's chats list
      for (String memberId in members) {
        FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(memberId)
            .child('chats')
            .child(newChat.chatId)
            .set(true);
      }

      // Update the latest message in the user's profile
      for (String memberId in members) {
        FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(memberId)
            .child('chats')
            .child(newChat.chatId)
            .child('lastMessage')
            .set(newChat.messages.last.toMap());
      }
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

  //Send message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String messageText,
  }) async {
    try {
      // Create a new message object
      final MessageModel newMessage = MessageModel(
        sender: senderId,
        messageText: messageText,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      // Push the new message to the chat's messages in the database
      final DatabaseReference messageRef = FirebaseDatabase.instance
          .ref()
          .child('chats')
          .child(chatId)
          .child('messages')
          .push();
      await messageRef.set(newMessage.toMap());

      // Update the chat's "last message" with the new message
      await FirebaseDatabase.instance
          .ref()
          .child('chats')
          .child(chatId)
          .update({'lastMessage': newMessage.toMap()});
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  //Delete message
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      // Delete the message from the chat's messages
      await FirebaseDatabase.instance
          .ref()
          .child('chats')
          .child(chatId)
          .child('messages')
          .child(messageId)
          .remove();

      // Optionally, update the chat's "last message" or other relevant data
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  //keep message
  //delete for everyone
  //message opened
}
