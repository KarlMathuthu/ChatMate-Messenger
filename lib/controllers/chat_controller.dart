import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    required String type,
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
            messageType: type,
          )
        ],
      );
      Map<String, dynamic> lastMessage = {
        "messageText": messageText,
        "sender": senderId,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "read": false,
        "type": type,
      };
      await _firestore.collection('chats').doc(chatRoomId).set(newChat.toMap());
      await updateLastMessage(chatRoomId, lastMessage);
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

  // Send Message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String messageText,
    required String type,
  }) async {
    try {
      final newMessage = MessageModel(
        sender: senderId,
        messageText: messageText,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        messageType: type,
      );

      Map<String, dynamic> lastMessage = {
        "messageText": messageText,
        "sender": senderId,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "read": false,
        "type": type,
      };

      final chatDoc = _firestore.collection('chats').doc(chatId);

      final DocumentSnapshot chatSnapshot = await chatDoc.get();

      if (chatSnapshot.exists) {
        List<dynamic> currentMessages = chatSnapshot.get("messages");

        currentMessages.add(newMessage.toMap());

        await chatDoc.update({'messages': currentMessages});
      }
      await updateLastMessage(chatId, lastMessage);
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
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
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
        String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

        // Retrieve the 'messages' field, which is an array of messages
        List<dynamic> messages = chatSnapshot['messages'];

        // Update the 'read' field to true for each message where senderId is not equal to currentUserUid
        List updatedMessages = messages.map((message) {
          if (message['sender'] != currentUserUid) {
            message['read'] = true;
          }
          return message;
        }).toList();

        // Update the 'messages' field with the updated messages
        await chats.doc(chatId).update({'messages': updatedMessages});
        //Update last message read
        await updateReadFieldInLastMessage(chatId);

        print('Chat marked as read for non-current user messages.');
      } else {
        print('Chat with ID $chatId does not exist.');
      }
    } catch (e) {
      print('Error marking chat as read: $e');
    }
  }

  //Update last message read
  Future<void> updateReadFieldInLastMessage(String chatId) async {
    try {
      CollectionReference chats =
          FirebaseFirestore.instance.collection('chats');
      DocumentSnapshot chatSnapshot = await chats.doc(chatId).get();

      if (chatSnapshot.exists) {
        Map<String, dynamic>? lastMessage = chatSnapshot['last_message'];

        if (lastMessage != null) {
          lastMessage['read'] = true;

          await chats.doc(chatId).update({'last_message': lastMessage});
        }
      }
    } catch (e) {
      print('Error updating "read" field: $e');
    }
  }

  //Update last_message
  Future<void> updateLastMessage(
    String chatId,
    Map<String, dynamic> lastMessage,
  ) async {
    try {
      // Reference to the Firestore collection "chats"
      CollectionReference chats =
          FirebaseFirestore.instance.collection('chats');

      // Update the "last_message" field of the chat document
      await chats.doc(chatId).update({'last_message': lastMessage});
    } catch (e) {}
  }

  //User Status
  Future getUserStatus(String uid) async {
    try {
      var userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userDoc.exists) {
        String userName = userDoc.data()?['userStatus'];
        return userName;
      } else {
        return "offline";
      }
    } catch (e) {
      return "connecting...";
    }
  }
  // Keep Message
  // Delete for Everyone
  // Message Opened
}
