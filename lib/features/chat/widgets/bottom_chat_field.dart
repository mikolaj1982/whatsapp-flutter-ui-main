import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/common/enums/massage_enum.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/chat/providers/chat_providers.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;

  const BottomChatField({Key? key, required this.receiverUserId}) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final _messageController = TextEditingController();
  bool isTextFieldActive = false;
  bool isEmojiPickerActive = false;
  final _focusNode = FocusNode();

  void sendTextMessage() async {
    if (isTextFieldActive) {
      ref.read(chatControllerProvider).sendTextMessage(
          text: _messageController.text.trim(), context: context, receiverUserId: widget.receiverUserId);

      setState(() {
        _messageController.text = '';
      });
      hideKeyboardAndEmojiPicker();
    }
  }

  void sendFile(File file, MessageEnum type) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context: context, file: file, receiverUserId: widget.receiverUserId, messageType: type);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFile(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? image = await pickVideoFromGallery(context);
    if (image != null) {
      sendFile(image, MessageEnum.video);
    }
  }

  void hideEmojiPicker() {
    setState(() {
      isEmojiPickerActive = false;
    });
  }

  void showEmojiPicker() {
    setState(() {
      isEmojiPickerActive = true;
    });
  }

  void showKeyboard() => _focusNode.requestFocus();

  void hideKeyboard() => _focusNode.unfocus();

  void hideKeyboardAndEmojiPicker() {
    hideKeyboard();
    hideEmojiPicker();
  }

  void toggleEmojiPicker() {
    if (isEmojiPickerActive) {
      showKeyboard();
      hideEmojiPicker();
    } else {
      hideKeyboard();
      showEmojiPicker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: _focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isTextFieldActive = true;
                    });
                  } else {
                    setState(() {
                      isTextFieldActive = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiPicker,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 2, right: 2),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                    onTap: sendTextMessage,
                    child: isTextFieldActive
                        ? const Icon(
                            Icons.send,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.mic,
                            color: Colors.white,
                          )),
              ),
            )
          ],
        ),
        isEmojiPickerActive
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text = _messageController.text + emoji.emoji;
                    });

                    if (!isTextFieldActive) {
                      setState(() {
                        isTextFieldActive = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }
}
