import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/chat_model.dart';
import '../model/message_model.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create Chat
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

      // Add the new chat to Cloud Firestore
      await _firestore.collection('chats').doc(chatRoomId).set(
            newChat.toMap(),
          );

      // Update the user's chats list
      for (String memberId in members) {
        await _firestore
            .collection('users')
            .doc(memberId)
            .collection('chats')
            .doc(chatRoomId)
            .set(
          {
            'exists': true,
          },
        );
      }

      // Update the latest message in the user's profile
      for (String memberId in members) {
        await _firestore
            .collection('users')
            .doc(memberId)
            .collection('chats')
            .doc(chatRoomId)
            .update(
          {
            'lastMessage': newChat.messages.last.toMap(),
          },
        );
      }
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

  // Send Message
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
        read: false, // Mark the message as unread
      );

      // Add the new message to the chat's messages in Cloud Firestore
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(newMessage.toMap());

      // Update the chat's "last message" with the new message
      await _firestore.collection('chats').doc(chatId).update(
        {
          'lastMessage': newMessage.toMap(),
        },
      );
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Delete Message
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      // Delete the message from the chat's messages in Cloud Firestore
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();

      // Optionally, update the chat's "last message" or other relevant data
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  // Calculate Unread Messages
  int calculateUnreadMessageCount(List<MessageModel> messages) {
    int unreadCount = 0;
    for (final message in messages) {
      if (!message.read) {
        unreadCount++;
      }
    }
    return unreadCount;
  }

  // Keep Message
  // Delete for Everyone
  // Message Opened
}
