import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/auth/providers/auth_providers.dart';
import 'package:whatsapp_ui/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp_ui/features/chat/widgets/chat_list.dart';
import 'package:whatsapp_ui/models/user_model.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';

  final String name;
  final String uid;

  const MobileChatScreen({Key? key, required this.name, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
            // when we call a method in provider best is to use read
            stream: ref.read(authControllerProvider).userData(uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              var currentUser = snapshot.data! as UserModel;
              if (snapshot.hasData) {
                return Row(
                  children: [
                    Text(currentUser.name),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.online_prediction_outlined),
                      color: (currentUser.isOnline)
                          ? const Color.fromRGBO(255, 255, 255, 1)
                          : const Color.fromRGBO(255, 0, 0, 1),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return ErrorScreen(error: snapshot.error.toString());
              }

              return Container();
            }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(receiverUserId: uid),
          ),
          BottomChatField(receiverUserId: uid),
        ],
      ),
    );
  }
}
