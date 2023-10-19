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
      await _firestore.collection('chats').doc(chatRoomId).set(newChat.toMap());
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

  //Read all messages
  Future<void> markChatAsRead(String chatId) async {
    try {
      CollectionReference chats =
          FirebaseFirestore.instance.collection('chats');

      // Get the chat document by its ID
      DocumentSnapshot chatSnapshot = await chats.doc(chatId).get();

      if (chatSnapshot.exists) {
        // Retrieve the 'messages' field, which is an array of messages
        List<dynamic> messages = chatSnapshot['messages'];

        // Update the 'read' field to true for each message
        List updatedMessages = messages.map((message) {
          message['read'] = true;
          return message;
        }).toList();

        // Update the 'messages' field with the updated messages
        await chats.doc(chatId).update({'messages': updatedMessages});

        print('Chat marked as read.');
      } else {
        print('Chat with ID $chatId does not exist.');
      }
    } catch (e) {
      print('Error marking chat as read: $e');
    }
  }

  // Keep Message
  // Delete for Everyone
  // Message Opened
}
