import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/enums/massage_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/providers/auth_providers.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:whatsapp_ui/models/massage.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class ChatRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ChatRepository({required this.auth, required this.firestore});

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String receiverUserId,
      required UserModel sender,
      required ProviderRef ref, // to access CommonFirebaseStorageRepository
      required MessageEnum messageType}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String fileUrl = await ref
          .read(storageProvider)
          .storeFileToFirebase('chat/${messageType.type}/${sender.uid}/$receiverUserId/$messageId', file);

      var receiverData = await firestore.collection('users').doc(receiverUserId).get();
      UserModel receiver = UserModel.fromMap(receiverData.data()!);

      String contactsScreenMsg;
      switch (messageType) {
        case MessageEnum.image:
          contactsScreenMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactsScreenMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactsScreenMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactsScreenMsg = 'GIF';
          break;
        default:
          contactsScreenMsg = 'GIF';
      }

      _saveDataToContactsScreen(sender: sender, receiver: receiver, text: contactsScreenMsg, timeSent: timeSent);
      _saveDataToChatScreen(
          sender: sender,
          receiver: receiver,
          text: fileUrl,
          timeSent: timeSent,
          messageId: messageId,
          messageType: messageType);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<Message>> getMessages(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore.collection('users').doc(chatContact.contactId).get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
              name: user.name,
              profilePic: user.profilePic,
              lastMessage: chatContact.lastMessage,
              contactId: chatContact.contactId,
              timeSent: chatContact.timeSent),
        );
      }

      return contacts;
    });
  }

  // data to display chat screen list -> last message, profile pic, date and time
  void _saveDataToContactsScreen({
    required UserModel sender,
    required UserModel receiver,
    required String text,
    required DateTime timeSent,
  }) async {
    // there are 2 scenarios or sender msg is visible last or our msg is visible last
    // users -> receiver id -> chats -> current user id -> set data
    var receiverChatContact = ChatContact(
        name: sender.name, profilePic: sender.profilePic, lastMessage: text, contactId: sender.uid, timeSent: timeSent);

    await firestore
        .collection('users')
        .doc(receiver.uid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    // users -> current user id -> chats -> receiver id -> set data
    var senderChatContact = ChatContact(
        name: receiver.name,
        profilePic: receiver.profilePic,
        lastMessage: text,
        contactId: receiver.uid,
        timeSent: timeSent);

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiver.uid)
        .set(senderChatContact.toMap());
  }

  void _saveDataToChatScreen(
      {required UserModel sender,
      required UserModel receiver,
      required String text,
      required DateTime timeSent,
      required String messageId,
      required MessageEnum messageType}) async {
    // debugPrint('text: $text, messageId: $messageId, messageType: $messageType');
    // debugPrint('sender: ${sender.name}, receiver: ${receiver.name}, timeSent: $timeSent');
    // debugPrint('----------------------------------------------------');

    final message = Message(
        receiverId: receiver.uid,
        senderId: auth.currentUser!.uid,
        messageId: messageId,
        type: messageType,
        timeSent: timeSent,
        isSeen: false,
        text: text);

    // we have to store two times one per every user participating in conversation
    // users -> sender id -> chats -> receiver id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiver.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    // users -> receiver id  -> chats -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(receiver.uid)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  // if there are many parameters make sense to make them a named parameters
  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel sender,
  }) async {
    try {
      var timeSent = DateTime.now();

      // get receiver data by receiverUserId
      var receiverData = await firestore.collection('users').doc(receiverUserId).get();
      UserModel receiver = UserModel.fromMap(receiverData.data()!);

      // saving the data to two collections... first is contacts chat sub-collections
      _saveDataToContactsScreen(sender: sender, receiver: receiver, text: text, timeSent: timeSent);

      // second place is chat itself chat_list.dart widget
      var messageId = const Uuid().v1();
      _saveDataToChatScreen(
          sender: sender,
          receiver: receiver,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          messageType: MessageEnum.text);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      debugPrint(e.toString());
    }
  }
}
