import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/chat/providers/chat_providers.dart';
import 'package:whatsapp_ui/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp_ui/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp_ui/models/massage.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;

  const ChatList({Key? key, required this.receiverUserId}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _messagesController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<List<Message>>(
            stream: ref.read(chatControllerProvider).getMessages(widget.receiverUserId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }

              SchedulerBinding.instance.addPostFrameCallback((_) {
                // when new message arrive jump to max scroll extent
                _messagesController.jumpTo(_messagesController.position.maxScrollExtent);
              });

              return ListView.builder(
                controller: _messagesController,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Message msg = snapshot.data![index];
                  if (msg.senderId == FirebaseAuth.instance.currentUser!.uid) {
                    return MyMessageCard(
                      message: msg.text.toString(),
                      date: DateFormat.jm().format(msg.timeSent).toString(),
                      type: msg.type,
                    );
                  }
                  return SenderMessageCard(
                    message: msg.text.toString(),
                    date: DateFormat.jm().format(msg.timeSent).toString(),
                    type: msg.type,
                  );
                },
              );
            }));
  }

  @override
  void dispose() {
    super.dispose();
    _messagesController.dispose();
  }
}
