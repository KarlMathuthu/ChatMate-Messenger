import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/chat_model.dart';
import '../model/message_model.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create Chat
  Future<String> createChat({
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
      return chatRoomId;
    } catch (e) {
      print('Error creating chat: $e');
    }
    return "none";
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

  // Function to delete a message
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      final CollectionReference chats =
          FirebaseFirestore.instance.collection('chats');
      final DocumentReference chatDoc = chats.doc(chatId);

      // Fetch the chat document
      final DocumentSnapshot chatSnapshot = await chatDoc.get();

      if (chatSnapshot.exists) {
        // Get the current list of messages
        List<dynamic> currentMessages = chatSnapshot.get("messages");

        // Find and remove the message by messageId
        currentMessages.removeWhere((message) {
          return message['messageText'] == messageId;
        });
      }
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
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference chats =
          FirebaseFirestore.instance.collection('chats');
      DocumentSnapshot chatSnapshot = await chats.doc(chatId).get();

      if (chatSnapshot.exists) {
        Map<String, dynamic>? lastMessage = chatSnapshot['last_message'];

        if (lastMessage != null && lastMessage['sender'] != currentUserId) {
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

  //Delete message dialog
  Future<void> showCustomDialog({
    required BuildContext context,
    required bool isCurrentUser,
    required String message,
    required String chatId,
    required String messageId,
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(isCurrentUser ? 'Delete message' : 'Copy message'),
          content: Text(
            isCurrentUser
                ? 'Are you sure you want to delete this message?'
                : 'Message content that you want to copy.',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(isCurrentUser ? 'Delete' : 'Copy'),
              onPressed: () async {
                if (isCurrentUser) {
                  //Delete message
                } else {
                  await copyToClipBoard(message);
                }
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Copy to clipboard
  Future copyToClipBoard(String message) async {
    Clipboard.setData(
      ClipboardData(text: message),
    ).then((_) {
      Get.snackbar("Copied", "Message copied successfully!");
    });
  }

  // Keep Message
  // Delete for Everyone
  // Message Opened
}
