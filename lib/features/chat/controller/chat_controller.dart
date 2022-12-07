import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/massage_enum.dart';
import 'package:whatsapp_ui/features/auth/providers/auth_providers.dart';
import 'package:whatsapp_ui/features/chat/respository/chat_repository.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:whatsapp_ui/models/massage.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage({required String text, required BuildContext context, required String receiverUserId}) {
    ref.read(userDataProvider).whenData((UserModel? value) {
      debugPrint('ChatController userDataProvider when UserModel data received!');
      return chatRepository.sendTextMessage(
          context: context, text: text, receiverUserId: receiverUserId, sender: value!);
    });
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> getMessages(String receiverUserId) {
    return chatRepository.getMessages(receiverUserId);
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String receiverUserId,
      required MessageEnum messageType}) {
    ref.read(userDataProvider).whenData((UserModel? value) {
      return chatRepository.sendFileMessage(
        context: context,
        receiverUserId: receiverUserId,
        sender: value!,
        messageType: messageType,
        ref: ref,
        file: file,
      );
    });
  }
}
